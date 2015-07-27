class TLEItemChange extends TimelineEvent
  @minObj = 'item_minobj'
  @itemSize = 'item_size'

  @initConfigValue = (timelineConfig, item) ->
    super(timelineConfig)

  @writeDefaultToPageValue = (item) ->
    errorMes = ""
    writeValue = {}
    writeValue[@PageValueKey.ID] = item.id
    writeValue[@PageValueKey.ITEM_ID] = item.constructor.ITEM_ID
    writeValue[@PageValueKey.COMMON_EVENT_ID] = null
    # fixme
    writeValue[@PageValueKey.CHAPTER] = 1
    # fixme
    writeValue[@PageValueKey.CHAPTER] = 1
    writeValue[@PageValueKey.IS_COMMON_EVENT] = false
    writeValue[@PageValueKey.METHODNAME] = item.constructor.defaultMethodName()
    actionType = item.constructor.defaultActionType()
    writeValue[@PageValueKey.ACTIONTYPE] = actionType
    start = @getAllScrollLength()
    end = start + item.coodRegist.length
    if start > end
      start = null
      end = null
    writeValue[@PageValueKey.SCROLL_POINT_START] = start
    writeValue[@PageValueKey.SCROLL_POINT_END] = end
    writeValue[@PageValueKey.IS_PARALLEL] = false

    itemWriteValue = item.objWriteTimeline()
    # マージ
    $.extend(writeValue, itemWriteValue)

    if errorMes.length == 0
      value = item.constructor.timelineDefaultConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      teNum = getTimelinePageValue(Constant.PageValueKey.TE_COUNT)
      if teNum?
        teNum = parseInt(teNum) + 1
      else
        teNum = 1
      setTimelinePageValue(@PageValueKey.te(teNum), writeValue, teNum)
      setTimelinePageValue(Constant.PageValueKey.TE_COUNT, teNum)
      changeTimelineColor(teNum, actionType)

    return errorMes

  @writeToPageValue = (timelineConfig) ->
    errorMes = ""
    writeValue = super(timelineConfig)
    item = itemObject[timelineConfig.id]
    itemWriteValue = item.objWriteTimeline()
    # マージ
    $.extend(writeValue, itemWriteValue)

    if errorMes.length == 0
      value = item.timelineConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      setTimelinePageValue(@PageValueKey.te(timelineConfig.teNum), writeValue, timelineConfig.teNum)
      if parseInt(getTimelinePageValue(Constant.PageValueKey.TE_COUNT)) < timelineConfig.teNum
        setTimelinePageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum)

    return errorMes

  @readFromPageValue = (timelineConfig, item) ->
    ret = super(timelineConfig)
    return ret
