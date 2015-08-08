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
  scrollInside.width(scrollContents.width() * (scrollViewMag + 1))
  scrollInside.height(scrollContents.height() * (scrollViewMag + 1))
  scrollInsideCover.width(scrollContents.width() * (scrollViewMag + 1))
  scrollInsideCover.height(scrollContents.height() * (scrollViewMag + 1))
  scrollHandle.width(scrollHandleWrapper.width() * (scrollViewMag + 1))
  scrollHandle.height(scrollHandleWrapper.height() * (scrollViewMag + 1))

  # スクロール位置初期化
  scrollContents.scrollLeft(scrollContents.width() * (scrollViewMag * 0.5))
  scrollContents.scrollTop(scrollContents.height() * (scrollViewMag * 0.5))
  scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * (scrollViewMag * 0.5))
  scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * (scrollViewMag * 0.5))

  is_reload = getPageValue(Constant.PageValueKey.IS_RUNWINDOW_RELOAD)
  if is_reload?
    loadPageValueFromStorage()
  else
    savePageValueToStorage()

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

# タイムライン作成
initTimeline = ->
  # アクションのイベントを取得
  timelinePageValues = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX)
  timelineList = new Array(getTimelinePageValue(Constant.PageValueKey.TE_COUNT))

  # ソート
  for k, v of timelinePageValues
    if k.indexOf(Constant.PageValueKey.TE_NUM_PREFIX) == 0
      index = parseInt(k.substring(Constant.PageValueKey.TE_NUM_PREFIX.length)) - 1
      timelineList[index] = v

  # チャプターの作成
  chapterList = []
  eventList = []
  tList = []
  $.each(timelineList, (idx, obj)->

    event = getInstanceFromMap(obj)
    event.initWithEvent(obj)
    eventList.push(event)
    tList.push(obj)

    parallel = false
    if idx < timelineList.length - 1
      beforeTimeline = timelineList[idx + 1]
      if beforeTimeline[TimelineEvent.PageValueKey.IS_PARALLEL]
        parallel = true

    if !parallel
      chapter = null
      if obj[TimelineEvent.PageValueKey.ACTIONTYPE] == Constant.ActionEventHandleType.CLICK
        chapter = new ClickChapter({eventListenerList: eventList, timelineEventList: tList})
      else
        chapter = new ScrollChapter({eventListenerList: eventList, timelineEventList: tList})
      chapterList.push(chapter)
      eventList = []
      tList = []

      if !window.firstItemFocused && !obj[TimelineEvent.PageValueKey.IS_COMMON_EVENT]
          # 最初のアイテムにフォーカスする
          chapter.focusToActorIfNeed(true)
          window.firstItemFocused = true

    return true
  )
  window.timeLine = new TimeLine(chapterList)
  window.timeLine.start()

# Handleスクロール位置の初期化
initHandleScrollPoint = ->
  scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * (scrollViewMag * 0.5))
  scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * (scrollViewMag * 0.5))

# スクロールイベントの初期化
setupScrollEvent = ->
  lastLeft = scrollHandleWrapper.scrollLeft()
  lastTop = scrollHandleWrapper.scrollTop()
  stopTimer = null

  scrollHandleWrapper.scroll( ->
    if timeLine.finished || !timeLine.isScrollChapter()
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
    timeLine.handleScrollEvent(distX, distY)
  )

  scrollFinished = ->
    #scrollpoint_container.show()

# ストレージにページ値を保存
savePageValueToStorage = ->
  h = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX)
  lstorage.setItem(Constant.StorageKey.TIMELINE_PAGEVALUES, JSON.stringify(h))

# ストレージからページ値を読み込み
loadPageValueFromStorage = ->
  h = JSON.parse(lstorage.getItem(Constant.StorageKey.TIMELINE_PAGEVALUES))
  setTimelinePageValue(Constant.PageValueKey.TE_PREFIX, h)

$ ->
  runCommonVar()
  initView()
  initHandleScrollPoint()
  #initResize(wrap, scrollWrapper)
  initTimeline()
  setupScrollEvent()

  # CSS
  $('#sup_css').html(lstorage.getItem('itemCssStyle'))
  $('#sup_css').html(getTimelinePageValue(Constant.PageValueKey.TE_CSS))
