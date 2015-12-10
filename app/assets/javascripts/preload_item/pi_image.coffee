class PreloadItemImage extends ItemBase
  if gon?
    constant = gon.const
    class @Key
      @PROJECT_ID = constant.PreloadItemImage.Key.PROJECT_ID
      @ITEM_OBJ_ID = constant.PreloadItemImage.Key.ITEM_OBJ_ID
      @EVENT_DIST_ID = constant.PreloadItemImage.Key.EVENT_DIST_ID
      @SELECT_FILE = constant.PreloadItemImage.Key.SELECT_FILE
      @URL = constant.PreloadItemImage.Key.URL
      @SELECT_FILE_DELETE = constant.PreloadItemImage.Key.SELECT_FILE_DELETE

  UPLOAD_FORM_WIDTH = 350
  UPLOAD_FORM_HEIGHT = 200

  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "image"
  @ITEM_ACCESS_TOKEN = 'PreloadItemImage'

  @actionProperties =
  {
    modifiables: {
      imagePath: {
        name: "Select image"
        type: 'select_file'
        ja: {
          name: "画像を選択"
        }
      }
    }
  }

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->
    super(cood)
    @imagePath = null
    @_image = null
    @isKeepAspect = false
    @scale = {w:1.0, h:1.0}
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}

  # ドラッグ描画
  # @param [Array] cood 座標
  draw: (cood) ->
    if @itemSize != null
      @restoreDrawingSurface(@itemSize)

    @itemSize = {x:null,y:null,w:null,h:null}
    @itemSize.w = Math.abs(cood.x - @_moveLoc.x);
    @itemSize.h = Math.abs(cood.y - @_moveLoc.y);
    if cood.x > @_moveLoc.x
      @itemSize.x = @_moveLoc.x
    else
      @itemSize.x = cood.x
    if cood.y > @_moveLoc.y
      @itemSize.y = @_moveLoc.y
    else
      @itemSize.y = cood.y
    drawingContext.strokeRect(@itemSize.x, @itemSize.y, @itemSize.w, @itemSize.h)

  # 描画終了
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true, callback = null) ->
    @zindex = zindex
    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()
    @createItemElement(true, (createdElement) =>
      $(createdElement).appendTo(window.scrollInside)
      if !show
        @getJQueryElement().css('opacity', 0)
      if @setupDragAndResizeEvents?
        # ドラッグ & リサイズイベント設定
        @setupDragAndResizeEvents()
    )

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  reDraw: (show = true)->
    super(show)
    @clearDraw()
    @createItemElement(false, (createdElement) =>
      $(createdElement).appendTo(window.scrollInside)
      if !show
        @getJQueryElement().css('opacity', 0)
      if @setupDragAndResizeEvents?
        # ドラッグ & リサイズイベント設定
        @setupDragAndResizeEvents()
    )

  # 描画削除
  clearDraw: ->
    @getJQueryElement().remove()

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    @getJQueryElement().css({width: w, height: h})
    @itemSize.w = parseInt(w)
    @itemSize.h = parseInt(h)

  # アニメーション変更前のアイテムサイズ
  originalItemElementSize: ->
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(@event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    $.extend(true, obj, diff)
    return obj.itemSize

  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (showModal, callback) ->
    if @_image?
      if @isKeepAspect
        size = _sizeOfKeepAspect.call(@)
        width = size.width
        height = size.height
      else
        width = @itemSize.w
        height = @itemSize.h
      contents = """
        <img src='#{@imagePath}' width='#{width}' height='#{height}' />
      """
      callback(Common.wrapCreateItemElement(@, $(contents)))
    else
      # 画像未設定時表示
      contents = """
        <div class='no_image'><div class='center_image'></div></div>
      """
      if showModal
        # 画像アップロードモーダル表示
        Common.showModalView(Constant.ModalViewType.ITEM_IMAGE_UPLOAD, true, (modalEmt, params, callback = null) =>
          $(modalEmt).find(".#{@constructor.Key.PROJECT_ID}").val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID))
          $(modalEmt).find(".#{@constructor.Key.ITEM_OBJ_ID}").val(@id)
          $(modalEmt).find('form').off().on('ajax:complete', (e, data, status, error) =>
            # モーダル非表示
            Common.hideModalView()
            d = JSON.parse(data.responseText)
            @imagePath = d.image_url
            # Aspect比はデフォルトtrue
            @isKeepAspect = true
            @_image = new Image()
            @_image.src = @imagePath
            @_image.onload = =>
              @reDraw()
          )
          _initModalEvent.call(@, modalEmt)
          if callback?
            callback()
        )
      callback(Common.wrapCreateItemElement(@, $(contents)))

  _sizeOfKeepAspect = ->
    if @itemSize.w / @itemSize.h > @_image.naturalWidth / @_image.naturalHeight
      # 高さに合わせる
      return {width: @_image.naturalWidth * @itemSize.h / @_image.naturalHeight, height: @itemSize.h}
    else
      # 幅に合わせる
      return {width: @itemSize.w, height: @_image.naturalHeight * @itemSize.w / @_image.naturalWidth}

  _initModalEvent = (emt) ->
    $(emt).find(".#{@constructor.Key.SELECT_FILE}:first").off().on('change', (e) =>
      target = e.target
      if target.value && target.value.length > 0
        # 選択時
        # URL入力を無効
        el = $(emt).find(".#{@constructor.Key.URL}:first")
        el.attr('disabled', true)
        el.css('backgroundColor', 'gray')
        del = $(emt).find(".#{@constructor.Key.SELECT_FILE_DELETE}:first")
        del.off('click').on('click', ->
          $(target).val('')
          $(target).trigger('change')
        )
        del.show()
      else
        # 未選択
        # URL入力を有効
        el = $(emt).find(".#{@constructor.Key.URL}:first")
        el.removeAttr('disabled')
        el.css('backgroundColor', 'white')
        $(emt).find(".#{@constructor.Key.SELECT_FILE_DELETE}:first").hide()
    )
    $(emt).find(".#{@constructor.Key.URL}:first").off().on('change', (e) =>
      target = e.target
      if $(target).val().length > 0
        # 入力時
        # ファイル選択を無効
        $(emt).find(".#{@constructor.Key.SELECT_FILE}:first").attr('disabled', true)
      else
        # 未入力時
        # ファイル選択を有効
        $(emt).find(".#{@constructor.Key.SELECT_FILE}:first").removeAttr('disabled')
    )

Common.setClassToMap(false, PreloadItemImage.ITEM_ACCESS_TOKEN, PreloadItemImage)

if window.itemInitFuncList? && !window.itemInitFuncList[PreloadItemImage.ITEM_ACCESS_TOKEN]?
  if EventConfig?
    EventConfig.addEventConfigContents(PreloadItemImage.ITEM_ACCESS_TOKEN)
  console.log('PreloadImage loaded')
  window.itemInitFuncList[PreloadItemImage.ITEM_ACCESS_TOKEN] = (option = {}) ->
    if window.isWorkTable && PreloadItemImage.jsLoaded?
      PreloadItemArrow.jsLoaded(option)
    #JS読み込み完了後の処理
    if window.debug
      console.log('PreloadImage init Finish')