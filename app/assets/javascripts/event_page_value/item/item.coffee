class EPVItem extends EventPageValueBase
  @itemSize = 'item_size'

  @initConfigValue = (eventConfig, item) ->
    super(eventConfig)

  @writeDefaultToPageValue = (item) ->
    errorMes = ""
    writeValue = {}
    writeValue[@PageValueKey.ID] = item.id
    writeValue[@PageValueKey.ITEM_ID] = item.constructor.ITEM_ID
    writeValue[@PageValueKey.COMMON_EVENT_ID] = null
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
    writeValue[@PageValueKey.SCROLL_ENABLED_DIRECTIONS] = item.constructor.defaultScrollEnabledDirection()
    writeValue[@PageValueKey.SCROLL_FORWARD_DIRECTIONS] = item.constructor.defaultScrollForwardDirection()

    itemWriteValue = item.objWriteEvent()
    # マージ
    $.extend(writeValue, itemWriteValue)

    if errorMes.length == 0
      value = item.constructor.defaultEventConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      teNum = PageValue.getEventPageValue(PageValue.Key.eventCount())

      if teNum?
        teNum = parseInt(teNum) + 1
      else
        teNum = 1

      PageValue.setEventPageValue(@PageValueKey.te(teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.eventCount(), teNum)
      Timeline.changeTimelineColor(teNum, actionType)

      # Storageに保存
      LocalStorage.saveValueForWorktable()

    return errorMes

  @writeToPageValue = (eventConfig) ->
    errorMes = ""
    writeValue = super(eventConfig)
    item = instanceMap[eventConfig.id]
    itemWriteValue = item.objWriteEvent()
    # マージ
    $.extend(writeValue, itemWriteValue)

    if errorMes.length == 0
      value = item.eventConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      PageValue.setEventPageValue(@PageValueKey.te(eventConfig.teNum), writeValue)
      if parseInt(PageValue.getEventPageValue(PageValue.Key.eventCount())) < eventConfig.teNum
        PageValue.setEventPageValue(PageValue.Key.eventCount(), eventConfig.teNum)

      # Storageに保存
      LocalStorage.saveValueForWorktable()

    return errorMes

  @writeItemValueToPageValue = (item) ->
    # TODO: アイテムのみの情報をここで保存
    return

  @readFromPageValue = (eventConfig, item) ->
    ret = super(eventConfig)
    return ret