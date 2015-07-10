class TLEItemChange extends TimelineEvent
  @minObj = 'item_minobj'
  @itemSize = 'item_size'

  @initConfigValue = (timelineConfig, item) ->
    @initCommonConfigValue(timelineConfig)

  @updateAllScrollLength = (item) ->
    if item.coodRegist.length > 0
      start = parseInt(getPageValue(Constant.PageValueKey.TE_ALL_SCROLL_LENGTH))
      start += item.coodRegist.length
      setPageValue(Constant.PageValueKey.TE_ALL_SCROLL_LENGTH, start)

  @writeDefaultToPageValue = (item) ->
    errorMes = ""
    writeValue = {}
    writeValue[@PageValueKey.ID] = item.id
    writeValue[@PageValueKey.ITEM_ID] = item.constructor.ITEM_ID
    writeValue[@PageValueKey.ACTION_EVENT_TYPE_ID] = null
    # fixme
    writeValue[@PageValueKey.CHAPTER] = 1
    # fixme
    writeValue[@PageValueKey.CHAPTER] = 1
    writeValue[@PageValueKey.IS_COMMON_EVENT] = false
    writeValue[@PageValueKey.METHODNAME] = item.constructor.defaultMethodName()
    actionType = item.constructor.defaultActionType()
    writeValue[@PageValueKey.ACTIONTYPE] = actionType
    start = parseInt(getPageValue(Constant.PageValueKey.TE_ALL_SCROLL_LENGTH))
    end = start + item.coodRegist.length
    if start < end
      scrollPoint = "#{start}#{@PageValueKey.SCROLL_POINT_SEP}#{end}"
    else
      scrollPoint = null
    writeValue[@PageValueKey.SCROLL_POINT] = scrollPoint
    writeValue[@PageValueKey.IS_CLICK_PARALLEL] = false

    itemWriteValue = item.objWriteTimeline()
    # マージ
    $.extend(writeValue, itemWriteValue)

    if errorMes.length == 0
      value = item.constructor.timelineDefaultConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      teNum = getPageValue(Constant.PageValueKey.TE_COUNT)
      if teNum?
        teNum = parseInt(teNum) + 1
      else
        teNum = 1
      setPageValue(@PageValueKey.te(teNum), writeValue)
      setPageValue(Constant.PageValueKey.TE_COUNT, teNum)

    return errorMes

  @writeToPageValue = (timelineConfig, item) ->
    errorMes = ""
    writeValue = @commonWriteValue(timelineConfig)
    itemWriteValue = item.objWriteTimeline()
    # マージ
    $.extend(writeValue, itemWriteValue)

    if errorMes.length == 0
      value = item.timelineConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      setPageValue(@PageValueKey.te(timelineConfig.teNum), writeValue)
      setPageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum)

    return errorMes

  @readFromPageValue = (timelineConfig, item) ->
    @commonReadValue(timelineConfig)
