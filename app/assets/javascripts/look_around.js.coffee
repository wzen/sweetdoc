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
  lastLeft = scrollContents.scrollLeft()
  lastTop = scrollContents.scrollTop()
  stopTimer = null

  scrollContents.scroll( ->
    x = $(@).scrollLeft()
    y = $(@).scrollTop()
#    if lastLeft == null || lastTop == null
#      lastLeft = x
#      lastTop = y

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

  inside.width(scrollContents.width() * (scrollViewMag + 1))
  inside.height(scrollContents.height() * (scrollViewMag + 1))
  initScrollPoint()

  $('#canvas_container').attr('width', $('#canvas_wrapper').width())
  $('#canvas_container').attr('height', $('#canvas_wrapper').height())
  #initResize(wrap, contents)

  # アクションのイベントを取得
  window.lstorage = localStorage
  objList = JSON.parse(lstorage.getItem('timelineObjList'))
  chapterList = []
  objList.forEach( (obj)->
    actorList = []
    item = null
    miniObj = obj.miniObj
    if miniObj.itemType == Constant.ItemType.BUTTON
      item = new ButtonItem()
      # とりあえずボタンの場合はそのまま表示
      item.setMiniumObject(miniObj)
      item.reDraw()
    else if miniObj.itemType == Constant.ItemType.ARROW
      item = new ArrowItem()
    item.initActor(miniObj, obj.actorSize, obj.sEvent, obj.cEvent)
    actorList.push(item)
    chapter = new Chapter(actorList)
    chapterList.push(chapter)
  )

  window.timeLine = new TimeLine(chapterList)

  initScroll()


