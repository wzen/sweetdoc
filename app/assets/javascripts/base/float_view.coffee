class FloatView
  class @Type
    @PREVIEW = 'preview'
    @DISPLAY_POSITION = 'display_position'
    @INFO = 'info'
    @WARN = 'warn'
    @ERROR = 'error'

  @show = (message, type) ->
    if !window.initDone
      return

    screenWrapper = $('#screen_wrapper')
    root = $(".float_view.#{type}:first", screenWrapper)
    if root.length == 0
      $(".float_view", screenWrapper).remove()
      $('.float_view_temp', screenWrapper).clone(true).attr('class', 'float_view').appendTo(screenWrapper)
      root = $('.float_view:first', screenWrapper)
      root.removeClass((index, className) ->
        return className != 'float_view'
      ).addClass(type)
      $('.message', root).removeClass((index, className) ->
        return className != 'message'
      ).addClass(type)
    root.show()

    $('.message', root).html(message)

  @hide = ->
    $(".float_view").fadeOut('fast')

  @scrollMessage = (top, left) ->
    if !window.initDone
      return ''
    screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
    if screenSize?
      t = (window.scrollInsideWrapper.height() + screenSize.height) * 0.5 - top
      l = (window.scrollInsideWrapper.width() + screenSize.width) * 0.5 - left
      return "X: #{l}  Y:#{t}"
    return ''

  @displayPositionMessage = ->
    return 'Running Preview'
