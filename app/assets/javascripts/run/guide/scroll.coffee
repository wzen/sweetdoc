class ScrollGuide extends GuideBase
  # 定数
  constant = gon.const
  @TOP_ROOT_ID = constant.RunGuide.TOP_ROOT_ID
  @BOTTOM_ROOT_ID = constant.RunGuide.BOTTOM_ROOT_ID
  @LEFT_ROOT_ID = constant.RunGuide.LEFT_ROOT_ID
  @RIGHT_ROOT_ID = constant.RunGuide.RIGHT_ROOT_ID

  # ガイド表示
  @showGuide: (enableDirection, forwardDirection, canForward, canReverse) ->
    @hideGuide()
    if enableDirection.top
      base = $("##{@TOP_ROOT_ID}")
      emt = base.find('.guide_scroll_image_mac:first')
      if forwardDirection.top && canForward
        emt.removeClass('reverse').addClass('forward')
        base.show()
      else if !forwardDirection.top && canReverse
        emt.removeClass('forward').addClass('reverse')
        base.show()
    if enableDirection.bottom
      base = $("##{@BOTTOM_ROOT_ID}")
      emt = base.find('.guide_scroll_image_mac:first')
      if forwardDirection.bottom && canForward
        emt.removeClass('reverse').addClass('forward')
        base.show()
      else if !forwardDirection.bottom && canReverse
        emt.removeClass('forward').addClass('reverse')
        base.show()
    if enableDirection.left
      base = $("##{@LEFT_ROOT_ID}")
      emt = base.find('.guide_scroll_image_mac:first')
      if forwardDirection.left && canForward
        emt.removeClass('reverse').addClass('forward')
        base.show()
      else if !forwardDirection.left && canReverse
        emt.removeClass('forward').addClass('reverse')
        base.show()
    if enableDirection.right
      base = $("##{@RIGHT_ROOT_ID}")
      emt = base.find('.guide_scroll_image_mac:first')
      if forwardDirection.right && canForward
        emt.removeClass('reverse').addClass('forward')
        base.show()
      else if !forwardDirection.right && canReverse
        emt.removeClass('forward').addClass('reverse')
        base.show()

  # ガイド非表示
  @hideGuide: ->
    $("##{@TOP_ROOT_ID}").hide()
    $("##{@BOTTOM_ROOT_ID}").hide()
    $("##{@LEFT_ROOT_ID}").hide()
    $("##{@RIGHT_ROOT_ID}").hide()
