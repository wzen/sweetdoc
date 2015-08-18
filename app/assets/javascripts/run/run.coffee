# 閲覧ページ読み込みフラグ
window.runPage = true

# 画面初期化
initView = ->
  $('#contents').css('height', $('#contents').height() - $('#nav').height())
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

  is_reload = PageValue.getPageValue(Constant.PageValueKey.IS_RUNWINDOW_RELOAD)
  ls = new LocalStorage(LocalStorage.Key.RUN_EVENT_PAGEVALUES)
  if is_reload?
    ls.loadEventPageValue()
  else
    ls.saveEventPageValue()

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
  eventPageValueList = PageValue.getEventPageValueSortedListByNum()

  # チャプターの作成
  chapterList = []
  eventObjList = []
  eventList = []
  $.each(eventPageValueList, (idx, obj)->

    event = Common.getInstanceFromMap(obj)
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
        chapter = new ClickChapter({eventObjList: eventObjList, eventList: eventList})
      else
        chapter = new ScrollChapter({eventObjList: eventObjList, eventList: eventList})
      chapterList.push(chapter)
      eventObjList = []
      eventList = []

      if !window.firstItemFocused && !obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
          # 最初のアイテムにフォーカスする
          chapter.focusToActorIfNeed(true)
          window.firstItemFocused = true

    return true
  )
  window.eventAction = new EventAction(chapterList)
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
    if eventAction.finished || !eventAction.isScrollChapter()
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
    eventAction.handleScrollEvent(distX, distY)
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

  # CSS
  $('#sup_css').html(PageValue.getEventPageValue(Constant.PageValueKey.E_CSS))
