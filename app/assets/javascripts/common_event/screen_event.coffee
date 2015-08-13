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
    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
    if methodName == 'changeScreenPosition'
      scrollContents.css({scrollTop: @beforeScrollTop, scrollLeft: @beforeScrollLeft})

  # イベント後の表示状態にする
  updateEventAfter: ->
    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
    if methodName == 'changeScreenPosition'
      scrollTop = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.X]
      scrollLeft = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Y]
      scrollContents.css({scrollTop: (@beforeScrollTop + scrollTop), scrollLeft: @beforeScrollLeft + scrollLeft})

  # 画面移動イベント
  changeScreenPosition: (e, complete) =>
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.CLICK
      finished_count = 0
      scrollTop = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.X]
      scrollLeft = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Y]
      scrollContents.animate({scrollTop: (scrollContents.scrollTop() + scrollTop), scrollLeft: (scrollContents.scrollLeft() + scrollLeft) }, 'normal', 'linear', ->
        finished_count += 1
        if finished_count >= 2
          @isFinishedEvent = true
          if complete?
            complete()
      )

      scale = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Z]
      if scale != 0
        @getJQueryElement().transition({scale: "+=#{scale}"}, 'normal', 'linear', ->
          finished_count += 1
          if finished_count >= 2
            @isFinishedEvent = true
            if complete?
              complete()
        )

  # ページング時
  clearPaging: (methodName) ->
    super(methodName)
    @getJQueryElement().removeClass('changeScreenPosition_' + @id)

setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent)
