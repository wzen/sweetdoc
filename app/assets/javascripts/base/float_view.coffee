class FloatView
  class @Type
    @PREVIEW = 'preview'
    @DISPLAY_POSITION = 'display_position'

  @show = (message, type) ->
    if !window.initDone
      return

    screenWrapper = $('#screen_wrapper')
    root = $('.float_view:first', screenWrapper)
    if root.length == 0
      $('.float_view_temp', screenWrapper).clone(true).attr('class', 'float_view').appendTo(screenWrapper)
      root = $('.float_view:first', screenWrapper)

      if type == @Type.PREVIEW
        rootCss = {
          'background-color': 'black'
          opacity: '0.3'
          'z-index': '1999999999'
        }
        messageCss = {
          color: 'white'
          'font-size': '24px'
        }
      else if type == @Type.DISPLAY_POSITION
        rootCss = {
          'background-color': 'black'
          opacity: '0.3'
          'z-index': '1999999999'
        }
        messageCss = {
          color: 'white'
          'font-size': '24px'
        }

      root.css(rootCss)
      $('.message', root).css(messageCss)
    else
      root.show()

    $('.message', root).html(message)

  @hide = ->
    $(".float_view").fadeOut('fast')

  @scrollMessage = (top, left) ->
    if !window.initDone
      return ''
    screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
    if screenSize?
      t = (window.scrollInside.height() + screenSize.height) * 0.5 - top
      l = (window.scrollInside.width() + screenSize.width) * 0.5 - left
      return "X: #{l}  Y:#{t}"
    return ''

  @displayPositionMessage = ->
    return 'Motion Preview'
