# チャプター(タイムラインの区切り)
class Chapter
  constructor: (list) ->
    @eventObjList = list.eventObjList
    @eventList = list.eventList

  # チャプター共通の前処理
  willChapter: ->
    for event, idx in @eventObjList
      event.initWithEvent(@eventList[idx])
      methodName = event.event[EventPageValueBase.PageValueKey.METHODNAME]
      event.willChapter(methodName)
      event.appendCssIfNeeded(methodName)

    @sinkFrontAllActor()
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
          left = item.itemSize.x + width * 0.5 - (scrollContents.width() * 0.5)
          top = item.itemSize.y + height * 0.5 - (scrollContents.height() * 0.5)

        if isImmediate
          scrollContents.scrollTop(top)
          scrollContents.scrollLeft(left)
          window.disabledEventHandler = false
        else
          scrollContents.animate({scrollTop: top, scrollLeft: left }, 'normal', 'linear', ->
            window.disabledEventHandler = false
          )
    else
      window.disabledEventHandler = false

  # 全てのイベントアイテムをFrontに浮上
  riseFrontAllActor: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.off)
    scrollContents.css('z-index', scrollViewSwitchZindex.on)
    @eventObjList.forEach((event) ->
      if event.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
        event.getJQueryElement().css('z-index', scrollInsideCoverZindex + 1)
    )

  # 全てのイベントアイテムをFrontから落とす
  sinkFrontAllActor: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @eventObjList.forEach((event) ->
      if event.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
        event.getJQueryElement().css('z-index', Constant.Zindex.EVENTBOTTOM)
    )

  # 全てのイベントが終了しているか
  finishedAllEvent: ->
    return true
