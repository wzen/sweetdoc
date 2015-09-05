class ScrollGuide extends GuideBase

  @timer = null
  @IDLE_TIMER = 100 # 1秒

  if gon?
    # 定数
    constant = gon.const
    @TOP_ROOT_ID = constant.RunGuide.TOP_ROOT_ID
    @BOTTOM_ROOT_ID = constant.RunGuide.BOTTOM_ROOT_ID
    @LEFT_ROOT_ID = constant.RunGuide.LEFT_ROOT_ID
    @RIGHT_ROOT_ID = constant.RunGuide.RIGHT_ROOT_ID

  @setTimer: (enableDirection, forwardDirection, canForward, canReverse) ->
    if @timer?
      clearTimeout(@timer)
    @hideGuide()
    @timer = setTimeout( =>
      @showGuide(enableDirection, forwardDirection, canForward, canReverse)
    , @IDLE_TIMER)

  # ガイド表示
  @showGuide: (enableDirection, forwardDirection, canForward, canReverse) ->
    @hideGuide()
    if enableDirection.top
      base = $("##{@TOP_ROOT_ID}")
      emt = base.find('.guide_scroll_image_mac:first')
      if forwardDirection.top && canForward
        emt.removeClass('reverse').addClass('forward')
        base.css('display', 'block')
      else if !forwardDirection.top && canReverse
        emt.removeClass('forward').addClass('reverse')
        base.css('display', 'block')
    if enableDirection.bottom
      base = $("##{@BOTTOM_ROOT_ID}")
      emt = base.find('.guide_scroll_image_mac:first')
      if forwardDirection.bottom && canForward
        emt.removeClass('reverse').addClass('forward')
        base.css('display', 'block')
      else if !forwardDirection.bottom && canReverse
        emt.removeClass('forward').addClass('reverse')
        base.css('display', 'block')
    if enableDirection.left
      base = $("##{@LEFT_ROOT_ID}")
      emt = base.find('.guide_scroll_image_mac:first')
      if forwardDirection.left && canForward
        emt.removeClass('reverse').addClass('forward')
        base.css('display', 'block')
      else if !forwardDirection.left && canReverse
        emt.removeClass('forward').addClass('reverse')
        base.css('display', 'block')
    if enableDirection.right
      base = $("##{@RIGHT_ROOT_ID}")
      emt = base.find('.guide_scroll_image_mac:first')
      if forwardDirection.right && canForward
        emt.removeClass('reverse').addClass('forward')
        base.css('display', 'block')
      else if !forwardDirection.right && canReverse
        emt.removeClass('forward').addClass('reverse')
        base.css('display', 'block')

  # ガイド非表示
  @hideGuide: ->
    if @timer?
      clearTimeout(@timer)

    $("##{@TOP_ROOT_ID}").css('display', 'none')
    $("##{@BOTTOM_ROOT_ID}").css('display', 'none')
    $("##{@LEFT_ROOT_ID}").css('display', 'none')
    $("##{@RIGHT_ROOT_ID}").css('display', 'none')