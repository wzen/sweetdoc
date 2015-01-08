# 初期化
initCommonVar = ->
  window.wrap = $('#main-wrapper')
  window.scrollWrapper = $("#scroll_wrapper")
  window.scrollHandleWrapper = $("#scroll_handle_wrapper")
  window.scrollHandle = $("#scroll_handle")
  window.scrollContents = $("#scroll_contents")
  window.scrollInside = $("#scroll_inside")
  window.distX = 0
  window.distY = 0
  window.scrollViewMag = 500
  window.resizeTimer = false
  window.timeLine = null
  window.scrollViewZindex = 100
  window.lstorage = localStorage

# 画面初期化
initView = ->
  $('#contents').css('height', $('#contents').height() - $('#nav').height())
  $('#canvas_container').attr('width', $('#canvas_wrapper').width())
  $('#canvas_container').attr('height', $('#canvas_wrapper').height())
  scrollWrapper.css('z-index', scrollViewZindex)
  scrollInside.width(scrollContents.width() * (scrollViewMag + 1))
  scrollInside.height(scrollContents.height() * (scrollViewMag + 1))
  scrollHandle.width(scrollHandleWrapper.width() * (scrollViewMag + 1))
  scrollHandle.height(scrollHandleWrapper.height() * (scrollViewMag + 1))
  # スクロール位置初期化
  scrollContents.scrollLeft(scrollContents.width() * (scrollViewMag * 0.5))
  scrollContents.scrollTop(scrollContents.height() * (scrollViewMag * 0.5))
  scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * (scrollViewMag * 0.5))
  scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * (scrollViewMag * 0.5))

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
  objList = JSON.parse(lstorage.getItem('timelineObjList'))
  chapterList = []
  objList.forEach( (obj)->
    actorList = []
    #item = null
    miniObj = obj.miniObj
    if miniObj.itemType == Constant.ItemType.BUTTON
      item = new ButtonItem()
      # とりあえずボタンの場合はそのまま表示
      item.initActor(miniObj, obj.itemSize, obj.sEvent, obj.cEvent)
      item.reDraw()
    else if miniObj.itemType == Constant.ItemType.ARROW
      item = new ArrowItem()
      item.initActor(miniObj, obj.itemSize, obj.sEvent, obj.cEvent)
      item.reDraw(false)
    actorList.push(item)
    # とりあえずここでChapterを分ける
    if miniObj.itemType == Constant.ItemType.BUTTON
      chapter = new ClickChapter(actorList)
    else if miniObj.itemType == Constant.ItemType.ARROW
      chapter = new ScrollChapter(actorList)
    chapterList.push(chapter)
  )
  window.timeLine = new TimeLine(chapterList)

# スクロール位置の初期化
initScrollPoint = ->
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
      initScrollPoint()
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

$ ->
  initCommonVar()
  initView()
  initScrollPoint()
  #initResize(wrap, scrollWrapper)
  initTimeline()
  setupScrollEvent()

  # CSS
  $('#sup_css').html(lstorage.getItem('itemCssStyle'))


