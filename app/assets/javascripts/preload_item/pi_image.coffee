class PreloadItemImage extends ItemBase
  UPLOAD_FORM_WIDTH = 350
  UPLOAD_FORM_HEIGHT = 200

  @NAME_PREFIX = "image"
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
    @isKeepAspect = true
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @visible = true

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    super(w, h)
    size = _sizeOfKeepAspect.call(@)
    img = @getJQueryElement().find('img')
    img.width(size.width)
    img.height(size.height)

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  reDraw: (show = true, callback = null) ->
    @clearDraw()
    @createItemElement( =>
      @itemDraw(show)
      if @setupDragAndResizeEvents?
        # ドラッグ & リサイズイベント設定
        @setupDragAndResizeEvents()
      if callback?
        callback()
    , false)

  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (callback, showModal = true) ->
    _makeImageObjectIfNeed.call(@, =>
      if @_image?
        if @isKeepAspect
          size = _sizeOfKeepAspect.call(@)
          width = size.width
          height = size.height
        else
          width = @itemSize.w
          height = @itemSize.h
        contents = """
          <img class='put_center' src='#{@imagePath}' width='#{width}' height='#{height}' />
        """
        @addContentsToScrollInside(contents, callback)
      else
        # 画像未設定時表示
        contents = """
          <div class='no_image'><div class='center_image put_center'></div></div>
        """
        if showModal
          # 画像アップロードモーダル表示
          Common.showModalView(Constant.ModalViewType.ITEM_IMAGE_UPLOAD, true, (modalEmt, params, callback = null) =>
            $(modalEmt).find('form').off().on('ajax:complete', (e, data, status, error) =>
              # モーダル非表示
              Common.hideModalView()
              d = JSON.parse(data.responseText)
              @imagePath = d.image_url
              @saveObj()
              @reDraw()
            )
            _initModalEvent.call(@, modalEmt)
            if callback?
              callback()
          )
        @addContentsToScrollInside(contents, callback)
    )

  _makeImageObjectIfNeed = (callback) ->
    if @_image?
      # 作成済み
      callback()
      return

    if !@imagePath?
      # 作成不可
      callback()
      return

    @_image = new Image()
    @_image.src = @imagePath
    @_image.onload = ->
      callback()
    @_image.onerror = =>
      # 読み込み失敗 -> NoImageに変更
      @imagePath = null
      @_image = null
      @reDraw()

  _sizeOfKeepAspect = ->
    if @itemSize.w / @itemSize.h > @_image.naturalWidth / @_image.naturalHeight
      # 高さに合わせる
      return {width: @_image.naturalWidth * @itemSize.h / @_image.naturalHeight, height: @itemSize.h}
    else
      # 幅に合わせる
      return {width: @itemSize.w, height: @_image.naturalHeight * @itemSize.w / @_image.naturalWidth}

  _initModalEvent = (emt) ->
    @initModifiableSelectFile(emt)

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