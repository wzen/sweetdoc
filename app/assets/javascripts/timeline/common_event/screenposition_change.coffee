class TLEScreenPositionChange extends TimelineEvent
  @X = 'x'
  @Y = 'y'
  @Z = 'z'

  @writeToPageValue = (timelineConfig) ->
    errorMes = ""
    emt = timelineConfig.emt
    writeValue = super(timelineConfig)
    value[@X] = $('.screenposition_change_x:first', emt).val()
    value[@Y] = $('.screenposition_change_y:first', emt).val()
    value[@Z] = $('.screenposition_change_z:first', emt).val()

    if errorMes.length == 0
      writeValue[@PageValueKey.VALUE] = value
      setTimelinePageValue(@PageValueKey.te(timelineConfig.teNum), writeValue, timelineConfig.teNum)
      setTimelinePageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum)

    return errorMes

  @readFromPageValue = (timelineConfig) ->
    ret = super(timelineConfig)
    if !ret
      return false
    emt = timelineConfig.emt
    writeValue = getTimelinePageValue(@PageValueKey.te(timelineConfig.teNum))
    value = writeValue[@PageValueKey.VALUE]
    $('.screenposition_change_x:first', emt).val(value[@constructor.X])
    $('.screenposition_change_y:first', emt).val(value[@constructor.Y])
    $('.screenposition_change_z:first', emt).val(value[@constructor.Z])
    return true
