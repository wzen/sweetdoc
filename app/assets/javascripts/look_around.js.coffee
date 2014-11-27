resizeTimer = false
scrollTimer = -1
scrollEvents = []
item = null

initCommonVar = ->
  window.wrap = $('#main-wrapper')
  window.contents = $("#scroll_wrapper")
  window.scrollContents = $("#scroll_contents")
  window.inside = $("#scroll_inside")
  window.distX = 0
  window.distY = 0
  window.scrollViewMag = 20

initScrollEvents = ->


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

    #console.log('distX:' + distX + ' distY:' + distY)
    scrollEvent(distX, distY)
  )

  scrollFinished = ->
    #scrollpoint_container.show()

scrollEvent = (distX, distY) ->
  item.scrollEvent(distX, distY)

$ ->
  initCommonVar()

  inside.width(scrollContents.width() * (scrollViewMag + 1))
  inside.height(scrollContents.height() * (scrollViewMag + 1))
  initScrollPoint()

  $('#canvas_container').attr('width', $('#canvas_wrapper').width())
  $('#canvas_container').attr('height', $('#canvas_wrapper').height())
  #initResize(wrap, contents)

  window.lstorage = localStorage
  objList = JSON.parse(lstorage.getItem('lookaround'))
  objList.forEach( (obj)->
    if obj.itemType == Constant.ItemType.BUTTON
      item = new ButtonItem()
    else if obj.itemType == Constant.ItemType.ARROW
      item = new ArrowItem()
    item.setMiniumObject(obj)
  )


  #initScrollEvents()
  initScroll()


