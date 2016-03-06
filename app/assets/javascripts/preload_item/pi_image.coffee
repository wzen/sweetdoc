class PreloadItemImage extends ItemBase
  UPLOAD_FORM_WIDTH = 350
  UPLOAD_FORM_HEIGHT = 200

  @NAME_PREFIX = "image"
  @CLASS_DIST_TOKEN = 'PreloadItemImage'

  @actionProperties =
  {
    modifiables: {
      imagePath: {
        name: "Select image"
        type: 'select_image_file'
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
    if @isKeepAspect
      size = _sizeOfKeepAspect.call(@)
      width = size.width
      height = size.height
    else
      width = @itemSize.w
      height = @itemSize.h
    imageCanvas = @getJQueryElement().find('canvas').get(0)
    imageCanvas.width = @itemSize.w
    imageCanvas.height = @itemSize.h
    imageContext = imageCanvas.getContext('2d')
    left = (@itemSize.w - width) * 0.5
    top = (@itemSize.h - height) * 0.5
    imageContext.drawImage(@_image, left, top, width, height)

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  refresh: (show = true, callback = null) ->
    @removeItemElement()
    @createItemElement(show, (_show) =>
      @itemDraw(_show)
      if @setupItemEvents?
        # アイテムのイベント設定
        @setupItemEvents()
      if callback?
        callback(@)
    , false)

  # アイテム削除 ※コールバックは無くていい
  removeItemElement: ->
    super()
    # TODO: レコード削除


  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (show, callback, showModal = true) ->
    _makeImageObjectIfNeed.call(@, (show) =>
      if @_image?
        if @_onloaded? && @_onloaded
          if @isKeepAspect
            size = _sizeOfKeepAspect.call(@)
            width = size.width
            height = size.height
          else
            width = @itemSize.w
            height = @itemSize.h
          imageCanvas = document.createElement('canvas')
          imageCanvas.width = @itemSize.w
          imageCanvas.height = @itemSize.h
          imageContext = imageCanvas.getContext('2d')
          left = (@itemSize.w - width) * 0.5
          top = (@itemSize.h - height) * 0.5
          imageContext.drawImage(@_image, left, top, width, height)
          @addContentsToScrollInside(imageCanvas, ->
            if callback?
              callback(show)
          )
        else
          # @_image有り & @_onloaded無し -> 別スレッドで描画中の場合はadd処理なし
          if callback?
            callback()
      else
        # 画像未設定時表示
        contents = """
          <div class='no_image'><div class='center_image put_center'></div></div>
        """
        @addContentsToScrollInside(contents, ->
          if callback?
            callback(show)
        )
        if showModal
          # 画像アップロードモーダル表示
          Common.showModalView(constant.ModalViewType.ITEM_IMAGE_UPLOAD, true, (modalEmt, params, callback = null) =>
            $(modalEmt).find('form').off().on('ajax:complete', (e, data, status, error) =>
              # モーダル非表示
              Common.hideModalView()
              d = JSON.parse(data.responseText)
              @imagePath = d.image_url
              @saveObj()
              @refresh()
            )
            _initModalEvent.call(@, modalEmt)
            if callback?
              callback(show)
          )
    , show)

  _makeImageObjectIfNeed = (callback, show) ->
    if @_image?
      # 作成済みの場合
      callback(show)
      return

    if !@imagePath?
      # 作成不可
      callback(show)
      return

    @_onloaded = false
    @_image = new Image()
    @_image.src = @imagePath
    @_image.onload = =>
      @_onloaded = true
      callback(show)
    @_image.onerror = =>
      # 読み込み失敗 -> NoImageに変更
      @imagePath = null
      @_image = null
      @refresh()

  _sizeOfKeepAspect = ->
    if @itemSize.w / @itemSize.h > @_image.naturalWidth / @_image.naturalHeight
      # 高さに合わせる
      return {width: @_image.naturalWidth * @itemSize.h / @_image.naturalHeight, height: @itemSize.h}
    else
      # 幅に合わせる
      return {width: @itemSize.w, height: @_image.naturalHeight * @itemSize.w / @_image.naturalWidth}

  _initModalEvent = (emt) ->
    @initModifiableSelectFile(emt)

Common.setClassToMap(PreloadItemImage.CLASS_DIST_TOKEN, PreloadItemImage)

if window.itemInitFuncList? && !window.itemInitFuncList[PreloadItemImage.CLASS_DIST_TOKEN]?
  if window.debug
    console.log('PreloadImage loaded')
  window.itemInitFuncList[PreloadItemImage.CLASS_DIST_TOKEN] = (option = {}) ->
    if window.isWorkTable && PreloadItemImage.jsLoaded?
      PreloadItemArrow.jsLoaded(option)
    #JS読み込み完了後の処理
    if window.debug
      console.log('PreloadImage init Finish')