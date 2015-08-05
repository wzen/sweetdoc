# 画面表示イベント
class ScreenEvent extends CommonEvent
  @EVENT_ID = '2'

  getJQueryElement: ->
    return window.mainWrapper

  # 画面移動イベント
  changeScreenPosition: (e) =>
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.CLICK
      finished_count = 0
      scrollTop = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.X]
      scrollLeft = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Y]
      scrollContents.animate({scrollTop: (scrollContents.scrollTop() + scrollTop), scrollLeft: (scrollContents.scrollLeft() + scrollLeft) }, 'normal', 'linear', ->
        finished_count += 1
        if finished_count >= 2
          @isFinishedEvent = true
          if window.timeLine?
            window.timeLine.nextChapterIfFinishedAllEvent()
      )

      scale = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Z]
      @getJQueryElement().transition({scale: "+=#{scale}"}, 'normal', 'linear', ->
        finished_count += 1
        if finished_count >= 2
          @isFinishedEvent = true
          if window.timeLine?
            window.timeLine.nextChapterIfFinishedAllEvent()
      )

  # ページング時
  clearPaging: (methodName) ->
    super(methodName)
    @getJQueryElement().removeClass('changeScreenPosition_' + @id)

setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent)