class ItemPreviewCommon

  # Mainコンテナ初期化
  @initMainContainerAsWorktable = ->
    # 定数 & レイアウト & イベント系変数の初期化
    CommonVar.itemPreviewVar()
    Common.updateCanvasSize()
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
    # スクロールサイズ
    window.scrollInsideWrapper.width(window.scrollViewSize)
    window.scrollInsideWrapper.height(window.scrollViewSize)
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1))
    # スクロールイベント設定
    window.scrollContents.off('scroll')
    window.scrollContents.on('scroll', (e) ->
      e.preventDefault()
      top = window.scrollContents.scrollTop()
      left = window.scrollContents.scrollLeft()
      FloatView.show(FloatView.scrollMessage(top, left), FloatView.Type.DISPLAY_POSITION)
      if window.scrollContentsScrollTimer?
        clearTimeout(window.scrollContentsScrollTimer)
      window.scrollContentsScrollTimer = setTimeout( ->
        PageValue.setDisplayPosition(top, left)
        FloatView.hide()
        window.scrollContentsScrollTimer = null
      , 500)
    )
    # ナビバー
    #Navbar.initWorktableNavbar()
    # ドラッグ描画イベント
    ItemPreviewHandwrite.initHandwrite()
    # 環境設定
    Common.applyEnvironmentFromPagevalue()
    # Mainビュー高さ設定
    WorktableCommon.updateMainViewSize()

  # 初期化
  @initAfterLoadItem = ->
    # 描画モード
    window.selectItemMenu = ItemPreviewTemp.ITEM_ID
    WorktableCommon.changeMode(Constant.Mode.DRAW)


