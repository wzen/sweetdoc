class EPVScreenPosition extends EventPageValueBase
  @X = 'x'
  @Y = 'y'
  @Z = 'z'

  @initConfigValue = (eventConfig) ->
    super(eventConfig)

    $('.screenposition_change_x:first', eventConfig.emt).val(0)
    $('.screenposition_change_y:first', eventConfig.emt).val(0)
    $('.screenposition_change_z:first', eventConfig.emt).val(0)

  @writeToPageValue = (eventConfig) ->
    errorMes = ""
    emt = eventConfig.emt
    writeValue = super(eventConfig)
    value = {}
    value[@X] = $('.screenposition_change_x:first', emt).val()
    value[@Y] = $('.screenposition_change_y:first', emt).val()
    value[@Z] = $('.screenposition_change_z:first', emt).val()

    if errorMes.length == 0
      writeValue[@PageValueKey.VALUE] = value
      PageValue.setEventPageValue(@PageValueKey.te(eventConfig.teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.E_COUNT, eventConfig.teNum)

    return errorMes

  @readFromPageValue = (eventConfig) ->
    ret = super(eventConfig)
    if !ret
      return false
    emt = eventConfig.emt
    writeValue = PageValue.getEventPageValue(@PageValueKey.te(eventConfig.teNum))
    value = writeValue[@PageValueKey.VALUE]
    $('.screenposition_change_x:first', emt).val(value[@X])
    $('.screenposition_change_y:first', emt).val(value[@Y])
    $('.screenposition_change_z:first', emt).val(value[@Z])
    return true

