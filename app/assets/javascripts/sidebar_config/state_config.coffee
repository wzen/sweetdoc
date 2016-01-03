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
      $('.initX:first', emt).val(se.initX)
      $('.initY:first', emt).val(se.initY)
      $('.initScale:first', emt).val(se.initScale)
      $('input', emt).off('change').on('change', (e) =>
        se = new ScreenEvent()
        se[$(e.target).attr('class')] = $(e.target).val()
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
        emt.find('.initX:first').val(x)
        emt.find('.initY:first').val(y)
        emt.find('.initScale:first').val(z)

      emt.find('.event_pointing:first').eventDragPointing((pointingSize) =>
        _updateConfigInput.call(@, emt, pointingSize)
      )

