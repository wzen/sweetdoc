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
      # ScreenEvent
      emt = $("##{@ROOT_ID_NAME} .configBox.screen_event")
      se = new ScreenEvent()
      center = WorktableCommon.calcScrollCenterPosition(se.initConfigY, se.initConfigX)
      $('.initConfigX:first', emt).val(center.left)
      $('.initConfigY:first', emt).val(center.top)
      $('.initConfigScale:first', emt).val(se.initConfigScale)
      $('input', emt).off('change').on('change', (e) =>
        se = new ScreenEvent()
        se[$(e.target).attr('class')] = $(e.target).val()
        se.setItemAllPropToPageValue()
      )

      _updateConfigInput = (emt, pointingSize) ->
        x =  pointingSize.x + pointingSize.w * 0.5
        y = pointingSize.y + pointingSize.h * 0.5
        z = null
        screenSize = Common.getScreenSize()
        if pointingSize.w > pointingSize.h
          z = screenSize.width / pointingSize.w
        else
          z = screenSize.height / pointingSize.h
        center = WorktableCommon.calcScrollCenterPosition(y, x)
        emt.find('.initConfigX:first').val(center.left)
        emt.find('.initConfigY:first').val(center.top)
        emt.find('.initConfigScale:first').val(z)
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

