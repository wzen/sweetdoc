# 画面表示イベント
class ScreenEvent extends CommonEvent
  @EVENT_ID = '2'

  constructor: ->
    super()
    @beforeScrollTop = scrollContents.scrollTop()
    @beforeScrollLeft = scrollContents.scrollLeft()

  # イベント前の表示状態にする
  updateEventBefore: ->
    methodName = @getEventMethodName()
    if methodName == 'changeScreenPosition'
      Common.updateScrollContentsPosition(@beforeScrollTop, @beforeScrollLeft)

  # イベント後の表示状態にする
  updateEventAfter: ->
    methodName = @getEventMethodName()
    if methodName == 'changeScreenPosition'
      scrollTop = parseInt(@event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.X])
      scrollLeft = parseInt(@event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Y])
      Common.updateScrollContentsPosition(@beforeScrollTop + scrollTop, @beforeScrollLeft + scrollLeft)

  # 画面移動イベント
  # @param [Object] e クリックオブジェクト
  # @param [Function] complete 終了コールバック
  changeScreenPosition: (e, complete) =>
    @updateEventBefore()

    actionType = @getEventActionType()
    if actionType == Constant.ActionType.CLICK
      finished_count = 0
      scrollLeft = parseInt(@event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.X])
      scrollTop = parseInt(@event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Y])
      Common.updateScrollContentsPosition(scrollContents.scrollTop() + scrollTop, scrollContents.scrollLeft() + scrollLeft, false, ->
        finished_count += 1
        if finished_count >= 2
          @isFinishedEvent = true
          if complete?
            complete()
      )

      scale = @event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Z]
      if scale != 0
        @getJQueryElement().transition({scale: "+=#{scale}"}, 'normal', 'linear', ->
          finished_count += 1
          if finished_count >= 2
            @isFinishedEvent = true
            if complete?
              complete()
        )
      else
        finished_count += 1
        if finished_count >= 2
          @isFinishedEvent = true
          if complete?
            complete()

Common.setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent)
