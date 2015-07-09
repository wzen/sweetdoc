class TLEScreenPositionChange extends TimelineEvent
  @X = 'x'
  @Y = 'y'
  @Z = 'z'

  @writeToPageValue = (timelineConfig) ->
    errorMes = ""
    emt = timelineConfig.emt
    writeValue = @commonWriteValue(timelineConfig)
    value[@constructor.X] = $('.screenposition_change_x:first', emt).val()
    value[@constructor.Y] = $('.screenposition_change_y:first', emt).val()
    value[@constructor.Z] = $('.screenposition_change_z:first', emt).val()

    if errorMes.length == 0
      writeValue[@constructor.PageValueKey.VALUE] = value
      setPageValue(@constructor.PageValueKey.te(timelineConfig.teNum), writeValue)
      setPageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum)

    return errorMes

  @readFromPageValue = (timelineConfig) ->
    emt = timelineConfig.emt
    writeValue = getPageValue(@constructor.PageValueKey.te(timelineConfig.teNum))
    @commonReadValue(timelineConfig, writeValue)
    value = writeValue[@constructor.PageValueKey.VALUE]
    $('.screenposition_change_x:first', emt).val(value[@constructor.X])
    $('.screenposition_change_y:first', emt).val(value[@constructor.Y])
    $('.screenposition_change_z:first', emt).val(value[@constructor.Z])
