# 画面表示イベント
class ScreenEvent extends CommonEvent
  @EVENT_ID = '2'

  constructor: ->
    super()
    @beforeScrollTop = scrollContents.scrollTop()
    @beforeScrollLeft = scrollContents.scrollLeft()

  getJQueryElement: ->
    return window.mainWrapper

  # イベント前の表示状態にする
  updateEventBefore: ->
    methodName = @timelineEvent[EventPageValueBase.PageValueKey.METHODNAME]
    if methodName == 'changeScreenPosition'
      scrollContents.scrollTop(@beforeScrollTop)
      scrollContents.scrollLeft(@beforeScrollLeft)

  # イベント後の表示状態にする
  updateEventAfter: ->
    methodName = @timelineEvent[EventPageValueBase.PageValueKey.METHODNAME]
    if methodName == 'changeScreenPosition'
      scrollTop = parseInt(@timelineEvent[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.X])
      scrollLeft = parseInt(@timelineEvent[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Y])
      scrollContents.scrollTop(@beforeScrollTop + scrollTop)
      scrollContents.scrollLeft(@beforeScrollLeft + scrollLeft)

  # 画面移動イベント
  changeScreenPosition: (e, complete) =>
    @updateEventBefore()

    actionType = @timelineEvent[EventPageValueBase.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.CLICK
      finished_count = 0
      scrollTop = parseInt(@timelineEvent[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.X])
      scrollLeft = parseInt(@timelineEvent[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Y])
      scrollContents.animate({scrollTop: (scrollContents.scrollTop() + scrollTop), scrollLeft: (scrollContents.scrollLeft() + scrollLeft) }, 'normal', 'linear', ->
        finished_count += 1
        if finished_count >= 2
          @isFinishedEvent = true
          if complete?
            complete()
      )

      scale = @timelineEvent[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Z]
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

  # ページング時
  clearPaging: (methodName) ->
    super(methodName)
    @getJQueryElement().removeClass('changeScreenPosition_' + @id)

Common.setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent)
