class PreloadItemText extends ItemBase
  @NAME_PREFIX = "text"
  @ITEM_ACCESS_TOKEN = 'PreloadItemImage'

  @actionProperties =
  {
    modifiables: {
      fontType: {
        name: "Select Font"
        type: 'select'
        ja: {
          name: 'フォント選択'
        }
        options: [
          'sans-serif'
          'arial'
          'arial black'
          'arial narrow'
          'arial unicode ms'
          'Century Gothic'
          'Franklin Gothic Medium'
          'Gulim'
          'Dotum'
          'Haettenschweiler'
          'Impact'
          'Ludica Sans Unicode'
          'Microsoft Sans Serif'
          'MS Sans Serif'
          'MV Boil'
          'New Gulim'
          'Tahoma'
          'Trebuchet'
          'Verdana'
          'serif'
          'Batang'
          'Book Antiqua'
          'Bookman Old Style'
          'Century'
          'Estrangelo Edessa'
          'Garamond'
          'Gautami'
          'Georgia'
          'Gungsuh'
          'Latha'
          'Mangal'
          'MS Serif'
          'PMingLiU'
          'Palatino Linotype'
          'Raavi'
          'Roman'
          'Shruti'
          'Sylfaen'
          'Times New Roman'
          'Tunga'
          'monospace'
          'BatangChe'
          'Courier'
          'Courier New'
          'DotumChe'
          'GulimChe'
          'GungsuhChe'
          'HG行書体'
          'Lucida Console'
          'MingLiU'
          'ＭＳ ゴシック'
          'ＭＳ 明朝'
          'OCRB'
          'SimHei'
          'SimSun'
          'Small Fonts'
          'Terminal'
          'fantasy'
          'alba'
          'alba matter'
          'alba super'
          'baby kruffy'
          'Chick'
          'Croobie'
          'Fat'
          'Freshbot'
          'Frosty'
          'Gloo Gun'
          'Jokewood'
          'Modern'
          'Monotype Corsiva'
          'Poornut'
          'Pussycat Snickers'
          'Weltron Urban'
          'cursive'
          'Comic Sans MS'
          'HGP行書体'
          'HG正楷書体-PRO'
          'Jenkins v2.0'
          'Script'
          ['ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro']
          ['ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN']
          ['ヒラギノ角ゴ Pro W6', 'HiraKakuPro-W6']
          ['ヒラギノ角ゴ ProN W6', 'HiraKakuProN-W6']
          ['ヒラギノ角ゴ Std W8', 'Hiragino Kaku Gothic Std']
          ['ヒラギノ角ゴ StdN W8', 'Hiragino Kaku Gothic StdN']
          ['ヒラギノ丸ゴ Pro W4', 'Hiragino Maru Gothic Pro']
          ['ヒラギノ丸ゴ ProN W4', 'Hiragino Maru Gothic ProN']
          ['ヒラギノ明朝 Pro W3', 'Hiragino Mincho Pro']
          ['ヒラギノ明朝 ProN W3', 'Hiragino Mincho ProN']
          ['ヒラギノ明朝 Pro W6', 'HiraMinPro-W6']
          ['ヒラギノ明朝 ProN W6', 'HiraMinProN-W6']
          'Osaka'
          ['Osaka－等幅', 'Osaka-Mono']
          'MS UI Gothic'
          ['ＭＳ Ｐゴシック','MS PGothic']
          ['ＭＳ ゴシック','MS Gothic']
          ['ＭＳ Ｐ明朝', 'MS PMincho']
          ['ＭＳ 明朝', 'MS Mincho']
          ['メイリオ', 'Meiryo']
          'Meiryo UI'
        ]
      }
      imagePath: {
        name: "Text"
        type: 'string'
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
    @scale = {w:1.0, h:1.0}
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @visible = true
    if window.isWorkTable
      @constructor.include WorkTableCommonInclude

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
  # @param [Function] callback コールバック
  reDraw: (show = true, callback = null)->
    super(show, =>
      @clearDraw()
      @createItemElement(false, (createdElement) =>
        $(createdElement).appendTo(window.scrollInside)
        if !show
          @getJQueryElement().css('opacity', 0)
        if @setupDragAndResizeEvents?
          # ドラッグ & リサイズイベント設定
          @setupDragAndResizeEvents()
        if callback?
          callback()
      )
    )

  # デザイン反映
  applyDesignChange: (doStyleSave) ->
    @reDraw()

  # 描画削除
  clearDraw: ->
    @getJQueryElement().remove()

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    @getJQueryElement().css({width: w, height: h})
    @itemSize.w = parseInt(w)
    @itemSize.h = parseInt(h)
    size = _sizeOfKeepAspect.call(@)
    img = @getJQueryElement().find('img')
    img.width(size.width)
    img.height(size.height)

  # アニメーション変更前のアイテムサイズ
  originalItemElementSize: ->
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(@event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    $.extend(true, obj, diff)
    return obj.itemSize

  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (showModal, callback) ->
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
        callback(Common.wrapCreateItemElement(@, $(contents)))
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
        callback(Common.wrapCreateItemElement(@, $(contents)))
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