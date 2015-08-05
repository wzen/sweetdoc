# チャプター(タイムラインの区切り)
class Chapter
  constructor: (list) ->
    @eventListenerList = list.eventListenerList
    @timelineEventList = list.timelineEventList

  # チャプター共通の前処理
  willChapter: ->
    for eventListener, idx in @eventListenerList
      eventListener.initWithEvent(@timelineEventList[idx])
      eventListener.setEvent(@timelineEventList[idx])
      methodName = eventListener.timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
      eventListener.willChapter(methodName)
      eventListener.appendCssIfNeeded(methodName)

    @sinkFrontAllActor()
    @focusToActorIfNeed(false)

  # チャプター共通の後処理
  didChapter: ->
    @eventListenerList.forEach((eventListener) ->
      methodName = eventListener.timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
      eventListener.didChapter(methodName)
    )

  # アイテムにフォーカス(アイテムが1つのみの場合)
  focusToActorIfNeed: (isImmediate, type = "center") ->
    window.disabledEventHandler = true
    item = null
    @eventListenerList.forEach((e, idx) =>
      if @timelineEventList[idx][TimelineEvent.PageValueKey.IS_COMMON_EVENT] == false
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
    @eventListenerList.forEach((eventListener) ->
      if eventListener.timelineEvent[TimelineEvent.PageValueKey.IS_COMMON_EVENT] == false
        eventListener.getJQueryElement().css('z-index', scrollInsideCoverZindex + 1)
    )

  # 全てのイベントアイテムをFrontから落とす
  sinkFrontAllActor: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @eventListenerList.forEach((eventListener) ->
      if eventListener.timelineEvent[TimelineEvent.PageValueKey.IS_COMMON_EVENT] == false
        eventListener.getJQueryElement().css('z-index', 0)
    )

  # 全てのイベントが終了しているか
  finishedAllEvent: ->
    return true
