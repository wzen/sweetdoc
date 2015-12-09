class PreloadItemImage extends ItemBase
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
    super()
    @imagePath = null
    @isKeepAspect = false
    @scale = {w:1.0, h:1.0}

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  reDraw: (show = true)->
    super(show)
    @clearDraw()
    @createItemElement((createdElement) =>
      $(createdElement).appendTo(window.scrollInside)
      if !show
        @getJQueryElement().css('opacity', 0)

      if @setupDragAndResizeEvents?
        # ドラッグ & リサイズイベント設定
        @setupDragAndResizeEvents()
    )

  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (callback) ->
    if @imagePath?
      contents = """
        <img src='#{@imagePath}' />
      """
      callback(Common.wrapCreateItemElement(@, contents))
    else
      ConfigMenu.loadConfig(ConfigMenu.Action.PRELOAD_IMAGE_PATH_SELECT, (config) ->
        # 画像選択フォームを中央に表示
        style = ''
        top = @itemSize.h - $(config).height() / 2.0
        left = @itemSize.w - $(config).width() / 2.0
        contents = """
          <div style='position:absolute;top:#{top}px;left:#{left}px;'>#{config}</div>
        """
        callback(Common.wrapCreateItemElement(@, contents))
      )

# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList[PreloadItemImage.ITEM_ACCESS_TOKEN]?
  if EventConfig?
    EventConfig.addEventConfigContents(PreloadItemImage.ITEM_ACCESS_TOKEN)
  console.log('button loaded')