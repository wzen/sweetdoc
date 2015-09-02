class Run

  # 閲覧ページ読み込みフラグ
  window.runPage = true

  # 画面初期化
  @initView = ->
    $('#contents').css('height', $('#contents').height() - $("##{Constant.ElementAttribute.NAVBAR_ROOT}").height())
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width())
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height())
    # 暫定でスクロールを上に持ってくる
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)

    # スクロールビューの大きさ
    scrollInside.width(window.scrollViewSize)
    scrollInside.height(window.scrollViewSize)
    scrollInsideCover.width(window.scrollViewSize)
    scrollInsideCover.height(window.scrollViewSize)
    scrollHandle.width(window.scrollViewSize)
    scrollHandle.height(window.scrollViewSize)

    # スクロール位置初期化
    scrollContents.scrollLeft(scrollInside.width() * 0.5)
    scrollContents.scrollTop(scrollInside.height() * 0.5)
    scrollHandleWrapper.scrollLeft(scrollHandle.width() * 0.5)
    scrollHandleWrapper.scrollTop(scrollHandle.height() * 0.5)

    is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD)
    if is_reload?
      LocalStorage.loadValueForRun()
    else
      LocalStorage.saveValueForRun()

    # 共通設定
    Setting.initConfig()

  @initResize = (wrap, scrollWrapper) ->
    resizeTimer = false;
    $(window).resize( ->
      if resizeTimer != false
        clearTimeout(resizeTimer)
      resizeTimer = setTimeout( ->
        h = $(window).height()
        mainWrapper.height(h)
        scrollWrapper.height(h)
      , 200)
    )

  # イベント作成
  @initEventAction = ->
    # アクションのイベントを取得
    pageCount = PageValue.getPageCount()
    pageList = []
    for i in [1..pageCount]
      eventPageValueList = PageValue.getEventPageValueSortedListByNum(i)
      page = new Page(eventPageValueList)
      pageList.push(page)

    # ナビバーのページ数 & チャプター数設定
    Navbar.setPageMax(pageCount)
    # アクション作成
    window.eventAction = new EventAction(pageList, PageValue.getPageNum() - 1)
    window.eventAction.start()

  # Handleスクロール位置の初期化
  @initHandleScrollPoint = ->
    scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * 0.5)
    scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * 0.5)

  # スクロールイベントの初期化
  @setupScrollEvent = ->
    lastLeft = scrollHandleWrapper.scrollLeft()
    lastTop = scrollHandleWrapper.scrollTop()
    stopTimer = null

    scrollHandleWrapper.scroll( ->
      if eventAction.thisPage().finishedAllChapters || !eventAction.thisPage().isScrollChapter()
        return

      x = $(@).scrollLeft()
      y = $(@).scrollTop()

      if stopTimer != null
        clearTimeout(stopTimer)
      stopTimer = setTimeout( =>
        Run.initHandleScrollPoint()
        lastLeft = $(@).scrollLeft()
        lastTop = $(@).scrollTop()
        clearTimeout(stopTimer)
        stopTimer = null
      , 100)

      distX = x - lastLeft
      distY = y - lastTop
      lastLeft = x
      lastTop = y

      console.log('distX:' + distX + ' distY:' + distY)
      eventAction.thisPage().handleScrollEvent(distX, distY)
    )

    scrollFinished = ->
      #scrollpoint_container.show()

  # Mainコンテナ初期化
  @initMainContainer = ->
    CommonVar.runCommonVar()
    @initView()
    @initHandleScrollPoint()
    #@initResize(wrap, scrollWrapper)
    @initEventAction()
    @setupScrollEvent()
    Navbar.initRunNavbar()

$ ->
  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()
  # Mainコンテナ作成
  Common.createdMainContainerIfNeeded(PageValue.getPageNum())
  # コンテナ初期化
  Run.initMainContainer()

  # CSS
  $('#sup_css').html(PageValue.getEventPageValue(PageValue.Key.eventCss()))