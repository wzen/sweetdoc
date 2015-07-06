class TimelineCommonEventBackground extends TimelineEvent
  @PARAM_PREFIX = 'bcolor_'

  @writeToPageValue = (timelineConfig) ->
    errorMes = ""
    emt = timelineConfig.emt
    writeValue = @commonWriteValue(timelineConfig)
    value = {}
    emt.find('')

    writeValue[@constructor.PageValueKey.VALUE] = value

    if errorMes.length > 0
      setPageValue(@constructor.PageValueKey.te(timelineConfig.teNum), writeValue)
      setPageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum)

    return errorMes

  @readFromPageValue = ->