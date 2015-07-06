class TimelineCommonEventMove extends TimelineEvent
  @writeToPageValue = (timelineEvent) ->
    writeValue = null
    setPageValue(@constructor.PageValueKey.TE_VALUE.replace('@te_num', timelineEvent.teNum), writeValue)
    setPageValue(Constant.PageValueKey.TE_COUNT, @teNum)

  @readFromPageValue = ->