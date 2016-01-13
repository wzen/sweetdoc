class StateConfig
  if gon?
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
      $('.initConfigX:first', emt).val(se.initConfigX)
      $('.initConfigY:first', emt).val(se.initConfigY)
      $('.initConfigScale:first', emt).val(se.initConfigScale)
      $('input', emt).off('change').on('change', (e) =>
        se = new ScreenEvent()
        se[$(e.target).attr('class')] = $(e.target).val()
        se.setItemAllPropToPageValue()
      )

      _updateConfigInput = (emt, pointingSize) ->
        x = pointingSize.x + pointingSize.w / 2.0
        y = pointingSize.y + pointingSize.h / 2.0
        z = null
        screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
        if pointingSize.w > pointingSize.h
          z = screenSize.width / pointingSize.w
        else
          z = screenSize.height / pointingSize.h
        emt.find('.initConfigX:first').val(x)
        emt.find('.initConfigY:first').val(y)
        emt.find('.initConfigScale:first').val(z)
        se = new ScreenEvent()
        se.initConfigX = x
        se.initConfigY = y
        se.initConfigScale = z
        se.setItemAllPropToPageValue()

      emt.find('.event_pointing:first').eventDragPointingRect((pointingSize) =>
        _updateConfigInput.call(@, emt, pointingSize)
      )

