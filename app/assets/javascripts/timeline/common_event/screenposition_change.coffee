class TLEScreenPositionChange extends TimelineEvent
  @X = 'x'
  @Y = 'y'
  @Z = 'z'

  @initConfigValue = (timelineConfig) ->
    super(timelineConfig)

    scroll = $('#scroll_inside')
    width = scroll.width()
    height = scroll.height()
    top = window.scrollContents.scrollTop()
    left = window.scrollContents.scrollLeft()
    scale = 1
    mainTramsform = $('#main-wrapper').css('transform')
    if mainTramsform?
      scale = parseInt(mainTramsform.replace('scale', '').replace('(', '').replace(')', ''))

    $('.screenposition_change_x:first', timelineConfig.emt).val(parseInt(left + (width / 2)))
    $('.screenposition_change_y:first', timelineConfig.emt).val(parseInt(top + (height / 2)))
    $('.screenposition_change_z:first', timelineConfig.emt).val(scale)

  @writeToPageValue = (timelineConfig) ->
    errorMes = ""
    emt = timelineConfig.emt
    writeValue = super(timelineConfig)
    value = {}
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
    $('.screenposition_change_x:first', emt).val(value[@X])
    $('.screenposition_change_y:first', emt).val(value[@Y])
    $('.screenposition_change_z:first', emt).val(value[@Z])
    return true

