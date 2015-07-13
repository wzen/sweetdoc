# 閲覧ページ読み込みフラグ
window.runPage = true

# 初期化
initCommonVar = ->
  window.wrap = $('#main-wrapper')
  window.scrollWrapper = $("#scroll_wrapper")
  window.scrollHandleWrapper = $("#scroll_handle_wrapper")
  window.scrollHandle = $("#scroll_handle")
  window.scrollContents = $("#scroll_contents")
  window.scrollInside = $("#scroll_inside")
  window.scrollInsideCover = $('#scroll_inside_cover')
  window.distX = 0
  window.distY = 0
  window.scrollViewMag = 500
  window.resizeTimer = false
  window.timeLine = null
  window.scrollViewSwitchZindex = {'on': 100, 'off': 0}
  window.scrollInsideCoverZindex = 1
  window.lstorage = localStorage

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
      wrap.height(h)
      scrollWrapper.height(h)
    , 200)
  )


# タイムライン作成
initTimeline = ->
  # アクションのイベントを取得
  #objList = JSON.parse(lstorage.getItem('timelineObjList'))
  timelinePageValues = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX)
  objList = new Array(getTimelinePageValue(Constant.PageValueKey.TE_COUNT))
  timelinePageValues.forEach((k, v) ->
    objList[k.substring(getTimelinePageValue(Constant.PageValueKey.TE_NUM_PREFIX))] = v
  )
  #objList = JSON.parse(lstorage.getItem('timelineObjList'))

  chapterList = []
  objList.forEach( (obj, idx)->
    actorList = []
    #item = null
    miniObj = obj.miniObj
    if miniObj.itemId == Constant.ItemId.BUTTON
      item = new ButtonItem()
    else if miniObj.itemId == Constant.ItemId.ARROW
      item = new ArrowItem()
    item.initListener(miniObj, obj.itemSize)
    item.reDraw(false)
    item.setEvents(obj.sEvent, obj.cEvent)
    actorList.push(item)
    # とりあえずここでChapterを分ける
    if miniObj.itemId == Constant.ItemId.BUTTON
      chapter = new ClickChapter(actorList)
    else if miniObj.itemId == Constant.ItemId.ARROW
      chapter = new ScrollChapter(actorList)
    chapterList.push(chapter)

    if idx == 0
      # TODO: 暫定初期スクロール位置
      scrollContents.scrollLeft(item.itemSize.x + item.itemSize.w * 0.5 - (scrollContents.width() * 0.5))
      scrollContents.scrollTop(item.itemSize.y + item.itemSize.h * 0.5 - (scrollContents.height() * 0.5))
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
  console.log('savePageValueToStorage:' + JSON.stringify(h))

# ストレージからページ値を読み込み
loadPageValueFromStorage = ->
  h = JSON.parse(lstorage.getItem(Constant.StorageKey.TIMELINE_PAGEVALUES))
  setTimelinePageValue(Constant.PageValueKey.TE_PREFIX, h)

$ ->
  initCommonVar()
  initView()
  initHandleScrollPoint()
  #initResize(wrap, scrollWrapper)
  initTimeline()
  setupScrollEvent()

  # CSS
  $('#sup_css').html(lstorage.getItem('itemCssStyle'))
