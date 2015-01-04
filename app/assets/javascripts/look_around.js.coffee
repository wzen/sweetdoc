# 初期化
initCommonVar = ->
  window.wrap = $('#main-wrapper')
  window.contents = $("#scroll_wrapper")
  window.scrollContents = $("#scroll_contents")
  window.inside = $("#scroll_inside")
  window.distX = 0
  window.distY = 0
  window.scrollViewMag = 1000
  window.resizeTimer = false
  window.timeLine = null
  window.scrollViewZindex = 100
  window.lstorage = localStorage

# 画面初期化
initView = ->
  $('#canvas_container').attr('width', $('#canvas_wrapper').width())
  $('#canvas_container').attr('height', $('#canvas_wrapper').height())
  contents.css('z-index', scrollViewZindex)
  inside.width(scrollContents.width() * (scrollViewMag + 1))
  inside.height(scrollContents.height() * (scrollViewMag + 1))

initResize = (wrap, contents) ->
  resizeTimer = false;
  $(window).resize( ->
    if resizeTimer != false
      clearTimeout(resizeTimer)
    resizeTimer = setTimeout( ->
      h = $(window).height()
      wrap.height(h)
      contents.height(h)
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
  scrollContents.scrollLeft(scrollContents.width() * (scrollViewMag * 0.5))
  scrollContents.scrollTop(scrollContents.height() * (scrollViewMag * 0.5))

# スクロールイベントの初期化
initScroll = ->
  lastLeft = scrollContents.scrollLeft()
  lastTop = scrollContents.scrollTop()
  stopTimer = null

  scrollContents.scroll( ->
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
  #initResize(wrap, contents)
  initTimeline()
  initScroll()

  # CSS
  $('#sup_css').html(lstorage.getItem('itemCssStyle'))


