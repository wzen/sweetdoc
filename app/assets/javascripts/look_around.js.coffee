resizeTimer = false
scrollTimer = -1
scrollViewHeight = 50000
scrollEvents = []

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

initScroll = (scroll_contents, scrollpoint_container) ->
  scroll_contents.scroll( ->
    if scrollTimer != -1
      clearTimeout(scrollTimer)

    scrollTimer = setTimeout(scrollFinished, 500)
    scrollpoint_container.hide()

    # Set ScrollEvents
    sh = Math.floor($(this).scrollTop())
    #console.log("scrollTop:" + sh)
    styles = scrollEvents[sh]
    $.each(styles, (i, v)->
      scroll_contents.css(v["name"], v["param"])
    )
  )

  scrollFinished = ->
    scrollpoint_container.show()

$ ->
  wrap = $('#wrap')
  contents = $("#wrap_contents")
  scroll_contents = $("#scroll_contents")
  inside = $("#inside")
  scrollpoint_container = $("#scrollpoint_container")
  inside.height(scrollViewHeight)
  scrollEvents = new Array(scrollViewHeight)

  h = $(window).height()
  wrap.height(h)
  contents.height(h - 80)

  initResize(wrap, contents)
  initScroll(scroll_contents, scrollpoint_container)
  initScrollEvents()

