# チャプター(イベントの区切り)
class Chapter
  constructor: (list) ->
    @eventList = list.eventList
    @num = list.num

    @eventObjList = []
    for obj in @eventList
      isCommonEvent = obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      id = obj[EventPageValueBase.PageValueKey.ID]
      classMapId = if isCommonEvent then obj[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] else obj[EventPageValueBase.PageValueKey.ITEM_ID]
      event = Common.getInstanceFromMap(isCommonEvent, id, classMapId)
      @eventObjList.push(event)

    @doMoveChapter = false

  # チャプター共通の前処理
  willChapter: ->
    for event, idx in @eventObjList
      methodName = event.event[EventPageValueBase.PageValueKey.METHODNAME]
      event.willChapter(methodName)
      event.appendCssIfNeeded(methodName)
      @doMoveChapter = false

    @sinkFrontAllObj()
    @focusToActorIfNeed(false)

  # チャプター共通の後処理
  didChapter: ->
    @eventObjList.forEach((event) ->
      methodName = event.event[EventPageValueBase.PageValueKey.METHODNAME]
      event.didChapter(methodName)
    )

  # アイテムにフォーカス(アイテムが1つのみの場合)
  focusToActorIfNeed: (isImmediate, type = "center") ->
    window.disabledEventHandler = true
    item = null
    @eventObjList.forEach((e, idx) =>
      if @eventList[idx][EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
        item = e
        return false
    )

    if item?
        width = item.itemSize.w
        height = item.itemSize.h
        if item.scale?
          width *= item.scale.w
          height *= item.scale.h

        left = null
        top = null
        if type == "center"
          left = item.itemSize.x + width * 0.5 - (window.scrollContentsSize.width * 0.5)
          top = item.itemSize.y + height * 0.5 - (window.scrollContentsSize.height * 0.5)

        if isImmediate
          window.scrollContents.scrollTop(top)
          window.scrollContents.scrollLeft(left)
          window.disabledEventHandler = false
        else
          window.scrollContents.animate({scrollTop: top, scrollLeft: left }, 'normal', 'linear', ->
            window.disabledEventHandler = false
          )
    else
      window.disabledEventHandler = false

  # イベントアイテムをFrontに浮上
  riseFrontAllObj: (eventObjList) ->
    window.scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.off)
    window.scrollContents.css('z-index', scrollViewSwitchZindex.on)
    eventObjList.forEach((e) ->
      if e.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
        e.getJQueryElement().css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
    )

  # 全てのイベントアイテムをFrontから落とす
  sinkFrontAllObj: ->
    window.scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    window.scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @eventObjList.forEach((e) =>
      if e.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
        e.getJQueryElement().css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + @num))
    )

  # 全てのイベントが終了しているか
  finishedAllEvent: ->
    return true

  # チャプターのイベントをリセットする
  resetAllEvents: ->
    @eventObjList.forEach((e) =>
      e.resetEvent()
    )

  # チャプターのイベントを実行後にする
  forwardAllEvents: ->
    @eventObjList.forEach((e) =>
      e.forwardEvent()
    )