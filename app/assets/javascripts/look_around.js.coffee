# 初期化
initCommonVar = ->
  window.wrap = $('#main-wrapper')
  window.contents = $("#scroll_wrapper")
  window.scrollContents = $("#scroll_contents")
  window.inside = $("#scroll_inside")
  window.distX = 0
  window.distY = 0
  window.scrollViewMag = 20
  window.resizeTimer = false
  window.timeLine = null

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

initScrollPoint = ->
  scrollContents.scrollLeft(scrollContents.width() * (scrollViewMag * 0.5))
  scrollContents.scrollTop(scrollContents.height() * (scrollViewMag * 0.5))

initScroll = ->
  lastLeft = null
  lastTop = null
  stopTimer = null

  scrollContents.on("mousedown",(e) ->
    e.preventDefault()
    console.log('onmousedown')
  )

  scrollContents.scroll( ->
    x = $(@).scrollLeft()
    y = $(@).scrollTop()
    if lastLeft == null || lastTop == null
      initScrollPoint()
      lastLeft = x
      lastTop = y

    if stopTimer != null
      clearTimeout(stopTimer)
    stopTimer = setTimeout(->
      lastLeft = null
      lastTop = null
      clearTimeout(stopTimer)
      stopTimer = null
    , 50)

    if lastLeft == null || lastTop == null
      return

    distX = x - lastLeft
    distY = y - lastTop
    lastLeft = x
    lastTop = y

    #timeLine.handleScrollEvent(distX, distY)
    #console.log('distX:' + distX + ' distY:' + distY)
  )

  scrollFinished = ->
    #scrollpoint_container.show()

$ ->
  initCommonVar()

  inside.width(scrollContents.width() * (scrollViewMag + 1))
  inside.height(scrollContents.height() * (scrollViewMag + 1))
  initScrollPoint()

  $('#canvas_container').attr('width', $('#canvas_wrapper').width())
  $('#canvas_container').attr('height', $('#canvas_wrapper').height())
  #initResize(wrap, contents)

  # アクションのイベントを取得
  window.lstorage = localStorage
  objList = JSON.parse(lstorage.getItem('timelineObjList'))
  actorList = []
  objList.forEach( (obj)->
    item = null
    miniObj = obj.miniObj
    if miniObj.itemType == Constant.ItemType.BUTTON
      item = new ButtonItem()
    else if miniObj.itemType == Constant.ItemType.ARROW
      item = new ArrowItem()
    item.initActor(miniObj, obj.actorSize, obj.sEvent, obj.cEvent)
    actorList.push(item)
  )
  chapterList = []
  chapter = new Chapter(actorList)
  chapterList.push(chapter)
  window.timeLine = new TimeLine(chapterList)

  initScroll()


