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
      scrollTop = parseInt(@_event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.X])
      scrollLeft = parseInt(@_event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Y])
      Common.updateScrollContentsPosition(@beforeScrollTop + scrollTop, @beforeScrollLeft + scrollLeft)

  # 画面移動イベント
  changeScreenPosition: (opt) =>
    # TODO: オーバーレイを表示

    actionType = @getEventActionType()
    if actionType == Constant.ActionType.CLICK
      finished_count = 0
      scrollLeft = parseInt(@_event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.X])
      scrollTop = parseInt(@_event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Y])
      Common.updateScrollContentsPosition(scrollContents.scrollTop() + scrollTop, scrollContents.scrollLeft() + scrollLeft, false, ->
        finished_count += 1
        if finished_count >= 2
          @_isFinishedEvent = true
          if opt.complete?
            opt.complete()
      )

      scale = @_event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Z]
      if scale != 0
        @getJQueryElement().transition({scale: "+=#{scale}"}, 'normal', 'linear', ->
          finished_count += 1
          if finished_count >= 2
            @_isFinishedEvent = true
            if opt.complete?
              opt.complete()
        )
      else
        finished_count += 1
        if finished_count >= 2
          @_isFinishedEvent = true
          if opt.complete?
            opt.complete()

Common.setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent)
