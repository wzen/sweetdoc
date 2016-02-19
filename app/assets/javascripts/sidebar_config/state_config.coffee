class StateConfig
  # 定数
  constant = gon.const
  @ROOT_ID_NAME = constant.StateConfig.ROOT_ID_NAME

  # 設定値初期化
  @initConfig: ->
    do =>
      # Background Color
      emt = $("##{@ROOT_ID_NAME} .configBox.background")
      be = new BackgroundEvent()
      ColorPickerUtil.initColorPicker(
        emt.find('.colorPicker:first'),
        be.backgroundColor
        (a, b, d, e) =>
          be = new BackgroundEvent()
          be.backgroundColor = "##{b}"
      )

    do =>
      # Screen
      emt = $("##{@ROOT_ID_NAME} .configBox.screen_event")
      se = new ScreenEvent()
      if se.hasInitConfig()
        center = Common.calcScrollCenterPosition(se.initConfigY, se.initConfigX)

        $('.initConfigX:first', emt).attr('disabled', '').removeClass('empty').val(center.left)
        $('.initConfigY:first', emt).attr('disabled', '').removeClass('empty').val(center.top)
        $('.initConfigScale:first', emt).attr('disabled', '').removeClass('empty').val(se.initConfigScale)
        $('.clear_pointing:first', emt).show()
        $('input', emt).off('change').on('change', (e) =>
          se = new ScreenEvent()
          target = e.target
          se[$(target).attr('class')] = Common.calcScrollTopLeftPosition($(target).val())
          se.setItemAllPropToPageValue()
        )
      else
        $('.initConfigX:first', emt).attr('disabled', 'disabled').addClass('empty').val('')
        $('.initConfigY:first', emt).attr('disabled', 'disabled').addClass('empty').val('')
        $('.initConfigScale:first', emt).attr('disabled', 'disabled').addClass('empty').val('')
        $('.clear_pointing:first', emt).hide()

      _updateConfigInput = (emt, pointingSize) ->
        x =  pointingSize.x + pointingSize.w * 0.5
        y = pointingSize.y + pointingSize.h * 0.5
        z = null
        screenSize = Common.getScreenSize()
        scale = WorktableCommon.getWorktableViewScale()
        if pointingSize.w > pointingSize.h
          z = screenSize.width / pointingSize.w * scale
        else
          z = screenSize.height / pointingSize.h * scale
        center = Common.calcScrollCenterPosition(y, x)
        $('.initConfigX:first', emt).attr('disabled', '').removeClass('empty').val(center.left)
        $('.initConfigY:first', emt).attr('disabled', '').removeClass('empty').val(center.top)
        $('.initConfigScale:first', emt).attr('disabled', '').removeClass('empty').val(z)
        $('.clear_pointing:first', emt).show()
        se = new ScreenEvent()
        se.initConfigX = x
        se.initConfigY = y
        se.initConfigScale = z
        se.setItemAllPropToPageValue()

      emt.find('.event_pointing:first').eventDragPointingRect({
        applyDrawCallback: (pointingSize) =>
          if window.debug
            console.log('applyDrawCallback')
            console.log(pointingSize)
          _updateConfigInput.call(@, emt, pointingSize)
      })

  @clearScreenConfig: ->
    emt = $("##{@ROOT_ID_NAME} .configBox.screen_event")
    $('.initConfigX:first', emt).attr('disabled', 'disabled').addClass('empty').val('')
    $('.initConfigY:first', emt).attr('disabled', 'disabled').addClass('empty').val('')
    $('.initConfigScale:first', emt).attr('disabled', 'disabled').addClass('empty').val('')
    $('.clear_pointing:first', emt).hide()
    se = new ScreenEvent()
    se.initConfigX = null
    se.initConfigY = null
    se.initConfigScale = se._defaultInitScale
    se.setItemAllPropToPageValue()
