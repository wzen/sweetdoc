# 閲覧ページ読み込みフラグ
window.runPage = true

# 画面初期化
initView = ->
  $('#contents').css('height', $('#contents').height() - $("##{Constant.ElementAttribute.NAVBAR_ROOT}").height())
  $('#canvas_container').attr('width', $('#canvas_wrapper').width())
  $('#canvas_container').attr('height', $('#canvas_wrapper').height())
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

initResize = (wrap, scrollWrapper) ->
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
initEventAction = ->
  # アクションのイベントを取得

  # ページ総数
  pageCount = PageValue.getPageCount()
  pageList = []
  for i in [1..pageCount]
    eventPageValueList = PageValue.getEventPageValueSortedListByNum(i)
    chapterList = []
    if eventPageValueList?
      eventObjList = []
      eventList = []
      $.each(eventPageValueList, (idx, obj)->
        isCommonEvent = obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
        id = obj[EventPageValueBase.PageValueKey.ID]
        classMapId = if isCommonEvent then obj[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] else obj[EventPageValueBase.PageValueKey.ITEM_ID]
        event = Common.getInstanceFromMap(isCommonEvent, id, classMapId)
        event.initWithEvent(obj)
        eventObjList.push(event)
        eventList.push(obj)

        parallel = false
        if idx < eventPageValueList.length - 1
          beforeEvent = eventPageValueList[idx + 1]
          if beforeEvent[EventPageValueBase.PageValueKey.IS_PARALLEL]
            parallel = true

        if !parallel
          chapter = null
          if obj[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionEventHandleType.CLICK
            chapter = new ClickChapter({eventObjList: eventObjList, eventList: eventList, num: idx})
          else
            chapter = new ScrollChapter({eventObjList: eventObjList, eventList: eventList, num: idx})
          chapterList.push(chapter)
          eventObjList = []
          eventList = []

          if !window.firstItemFocused && !obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
              # 最初のアイテムにフォーカスする
              chapter.focusToActorIfNeed(true)
              window.firstItemFocused = true

        return true
      )
    page = new Page(chapterList)
    pageList.push(page)

  # ナビバーのページ数 & チャプター数設定
  Navbar.setPageMax(pageCount)

  # アクション作成
  window.eventAction = new EventAction(pageList, window.pageNum - 1)
  window.eventAction.start()

# Handleスクロール位置の初期化
initHandleScrollPoint = ->
  scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * 0.5)
  scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * 0.5)

# スクロールイベントの初期化
setupScrollEvent = ->
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
      initHandleScrollPoint()
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

$ ->
  runCommonVar()
  initView()
  initHandleScrollPoint()
  #initResize(wrap, scrollWrapper)
  initEventAction()
  setupScrollEvent()
  Navbar.initRunNavbar()

  # CSS
  $('#sup_css').html(PageValue.getEventPageValue(PageValue.Key.eventCss()))