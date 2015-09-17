class RunCommon
  # @property [String] RUN_CSS CSSスタイルRoot
  @RUN_CSS = constant.ElementAttribute.RUN_CSS

  # 画面初期化
  @initView = ->
    # Canvasサイズ設定
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

  # Mainビューの高さ更新
  @updateMainViewSize = ->
    padding = 5 * 2
    $('#main').height($('#contents').height() - $("##{Navbar.NAVBAR_ROOT}").height() - padding)
    window.scrollContentsSize = {width: window.scrollContents.width(), height: window.scrollContents.height()}

  # ウィンドウの高さ設定
  @resizeMainContainerEvent = ->
    @updateMainViewSize()
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width())
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height())

  # ウィンドウリサイズイベント
  @initResize = ->
    $(window).resize( ->
      RunCommon.resizeMainContainerEvent()
    )

  # イベント作成
  @initEventAction = ->
    # アクションのイベントを取得
    pageCount = PageValue.getPageCount()
    pageList = new Array(pageCount)
    for i in [1..pageCount]
      forkEventPageValueList = {}
      for j in [0..PageValue.getForkCount()]
        forkEventPageValueList[j] = PageValue.getEventPageValueSortedListByNum(j, i)
      page = null
      if forkEventPageValueList[PageValue.Key.EF_MASTER_FORKNUM].length > 0
        # Masterデータが存在する場合ページを作成
        page = new Page({
          forks: forkEventPageValueList
        })
      pageList[i - 1] = page

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

    scrollHandleWrapper.scroll( (e) ->
      e.preventDefault()

      if !RunCommon.enabledScroll()
        return

      x = $(@).scrollLeft()
      y = $(@).scrollTop()

      if stopTimer != null
        clearTimeout(stopTimer)
      stopTimer = setTimeout( =>
        RunCommon.initHandleScrollPoint()
        lastLeft = $(@).scrollLeft()
        lastTop = $(@).scrollTop()
        clearTimeout(stopTimer)
        stopTimer = null
      , 100)

      distX = x - lastLeft
      distY = y - lastTop
      lastLeft = x
      lastTop = y

      #console.log('distX:' + distX + ' distY:' + distY)
      window.eventAction.thisPage().handleScrollEvent(distX, distY)
    )

  # スクロールが有効の状態か判定
  # @return [Boolena] 判定結果
  @enabledScroll = ->
    ret = false
    if window.eventAction? &&
      window.eventAction.thisPage()? &&
      (window.eventAction.thisPage().finishedAllChapters || (window.eventAction.thisPage().thisChapter()? && window.eventAction.thisPage().isScrollChapter()))
        ret = true
    return ret

  # CSS要素作成
  # @param [Integer] pageNum ページ番号
  @createCssElement = (pageNum) ->
    # CSS作成
    cssId = @RUN_CSS.replace('@pagenum', pageNum)
    cssEmt = $("##{cssId}")
    if !cssEmt? || cssEmt.length == 0
      $("<div id='#{cssId}'></div>").appendTo(window.cssCode)
      cssEmt = $("##{cssId}")
    cssEmt.html(PageValue.itemCssOnPage(pageNum))

  # 対象ページのPageValueデータを読み込み
  # @param [Integer] loadPageNum 読み込むページ番号
  # @param [Function] callback コールバック
  # @param [Boolean] forceUpdate 既存データを上書きするか
  @loadPagingPageValue = (loadPageNum, callback = null, forceUpdate = false) ->
    lastPageNum = loadPageNum + Constant.Paging.PRELOAD_PAGEVALUE_NUM
    targetPages = []
    for i in [loadPageNum..lastPageNum]
      if forceUpdate
        targetPages.push(i)
      else
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', i)
        section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        if !section? || section.length == 0
          targetPages.push(i)

    if targetPages.length == 0
      if callback?
        callback()
      return

    $.ajax(
      {
        url: "/run/paging"
        type: "POST"
        dataType: "json"
        data: {
          targetPages: targetPages
        }
        success: (data)->
          if data.instance_pagevalue_hash != null
            for k, v of data.instance_pagevalue_hash
              PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)
          if data.event_pagevalue_hash != null
            for k, v of data.event_pagevalue_hash
              PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)

          # コールバック
          if callback?
            callback()
        error: (data) ->
      }
    )

  # Mainコンテナ初期化
  @initMainContainer = ->
    CommonVar.runCommonVar()
    @initView()
    @initHandleScrollPoint()
    @initResize()
    @setupScrollEvent()
    Navbar.initRunNavbar()