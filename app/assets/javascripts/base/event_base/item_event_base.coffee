class ItemEventBase extends EventBase
  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    super(event)

    if @ instanceof CssItemBase
      # デザインCSS & アニメーションCSS作成
      @makeCss()
      @appendAnimationCssIfNeeded()

    # 描画してアイテムを作成
    # 表示非表示はwillChapterで切り替え
    @reDraw(false)
