resizeTimer = false
scrollTimer = -1
scrollViewHeight = 50000
scrollEvents = []

arrow = null

initScrollEvents = ->
  # Color Change
  color_max = 256 * 3
  colorPerHeight = (color_max) / scrollViewHeight
  c = 0
  for i in [0..scrollViewHeight]
    styles = []
    c += colorPerHeight
    cf = Math.floor(c)
    r = parseInt(cf / 3)
    g = parseInt((cf + 1) / 3)
    b = parseInt((cf + 2) / 3)
    rgb = "rgb(" + r + "," + g + "," + b + ")"
    style = {name : "background-color", param : rgb}
    styles.push(style)
    scrollEvents[i] = styles
  @

initResize = (wrap, contents) ->
  resizeTimer = false;
  $(window).resize( ->
    if resizeTimer != false
      clearTimeout(resizeTimer)
    resizeTimer = setTimeout( ->
      h = $(window).height()
      wrap.height(h)
      contents.height(h - 80)
    , 200)
  )

initScroll = (scroll_contents) ->
  scroll_contents.scroll( ->
    if scrollTimer != -1
      clearTimeout(scrollTimer)

    scrollTimer = setTimeout(scrollFinished, 500)
    #scrollpoint_container.hide()

    # Set ScrollEvents
    sh = Math.floor($(this).scrollTop())
    #console.log("scrollTop:" + sh)
    styles = scrollEvents[sh]
    $.each(styles, (i, v)->
      scroll_contents.css(v["name"], v["param"])
    )
  )

  scrollFinished = ->
    #scrollpoint_container.show()

$ ->
  wrap = $('#main-wrapper')
  contents = $("#scroll_wrapper")
  scroll_contents = $("#scroll_contents")
  inside = $("#inside")
  #scrollpoint_container = $("#scrollpoint_container")
  inside.height(scrollViewHeight)
  scrollEvents = new Array(scrollViewHeight)

#  h = $(window).height()
#  wrap.height(h)
#  contents.height(h)

  $('#canvas_container').attr('width', $('#canvas_wrapper').width())
  $('#canvas_container').attr('height', $('#canvas_wrapper').height())
  initResize(wrap, contents)

  window.lstorage = localStorage
  objList = JSON.parse(lstorage.getItem('lookaround'))
  objList.forEach( (obj)->
    if obj.itemType == Constant.ItemType.BUTTON
      item = new ButtonItem()
    else if obj.itemType == Constant.ItemType.ARROW
      item = new ArrowItem()
    item.drawForLookaround(obj)
  )


  #initScrollEvents()
  #initScroll(scroll_contents)


