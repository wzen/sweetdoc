class EPVItem extends EventPageValueBase
  @minObj = 'item_minobj'
  @itemSize = 'item_size'

  @initConfigValue = (eventConfig, item) ->
    super(eventConfig)

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
    writeValue[@PageValueKey.ANIAMTIONTYPE] = item.constructor.defaultAnimationType()
    start = @getAllScrollLength()
    end = start + item.coodRegist.length
    if start > end
      start = null
      end = null
    writeValue[@PageValueKey.SCROLL_POINT_START] = start
    writeValue[@PageValueKey.SCROLL_POINT_END] = end
    writeValue[@PageValueKey.IS_PARALLEL] = false

    itemWriteValue = item.objWriteEvent()
    # マージ
    $.extend(writeValue, itemWriteValue)

    if errorMes.length == 0
      value = item.constructor.defaultEventConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      teNum = PageValue.getEventPageValue(PageValue.Key.E_COUNT)

      if teNum?
        teNum = parseInt(teNum) + 1
      else
        teNum = 1

      PageValue.setEventPageValue(@PageValueKey.te(teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.E_COUNT, teNum)
      Timeline.changeTimelineColor(teNum, actionType)

    return errorMes

  @writeToPageValue = (eventConfig) ->
    errorMes = ""
    writeValue = super(eventConfig)
    item = createdObject[eventConfig.id]
    itemWriteValue = item.objWriteEvent()
    # マージ
    $.extend(writeValue, itemWriteValue)

    if errorMes.length == 0
      value = item.eventConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      PageValue.setEventPageValue(@PageValueKey.te(eventConfig.teNum), writeValue)
      if parseInt(PageValue.getEventPageValue(PageValue.Key.E_COUNT)) < eventConfig.teNum
        PageValue.setEventPageValue(PageValue.Key.E_COUNT, eventConfig.teNum)

    return errorMes

  @writeItemValueToPageValue = (item) ->
    tes = PageValue.getEventPageValue(PageValue.Key.E_PREFIX)
    for idx, te of tes
      if idx.indexOf(PageValue.Key.E_NUM_PREFIX) >= 0 && te.id == item.id
        # イベントのアイテム情報を更新
        key = "#{PageValue.Key.E_PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{idx}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{@minObj}"
        PageValue.setEventPageValue(key, item.getMinimumObject())

  @readFromPageValue = (eventConfig, item) ->
    ret = super(eventConfig)
    return ret
