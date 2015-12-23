# 画面表示イベント
class ScreenEvent extends CommonEvent
  class @PrivateClass extends CommonEvent.PrivateClass
    @EVENT_ID = '2'
    @CLASS_DIST_TOKEN = "PI_ScreenEvent"

    @actionProperties =
    {
      methods: {
        changeScreenPosition: {
          options: {
            id: 'changeScreenPosition'
            name: 'Changing position'
            ja: {
              name: '表示位置変更'
            }
          }
          specificValues: {
            afterX: scrollContents.scrollTop()
            afterY: scrollContents.scrollLeft()
            afterZ: 1
          }
        }
      }
    }

    constructor: ->
      super()
      @beforeScrollTop = scrollContents.scrollTop()
      @beforeScrollLeft = scrollContents.scrollLeft()

    # イベント前の表示状態にする
    updateEventBefore: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        Common.updateScrollContentsPosition(@beforeScrollTop, @beforeScrollLeft)

    # イベント後の表示状態にする
    updateEventAfter: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        scrollTop = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX)
        scrollLeft = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY)
        Common.updateScrollContentsPosition(scrollTop, scrollLeft)

    # 画面移動イベント
    changeScreenPosition: (opt) =>
      # TODO: オーバーレイを表示

      actionType = @getEventActionType()
      if actionType == Constant.ActionType.CLICK
        finished_count = 0
        scrollLeft = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX)
        scrollTop = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY)
        Common.updateScrollContentsPosition(scrollTop, scrollLeft, false, ->
          finished_count += 1
          if finished_count >= 2
            @_isFinishedEvent = true
            if opt.complete?
              opt.complete()
        )

        scale = @_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ
        if scale != 0
          @getJQueryElement().transition({scale: "#{scale}"}, 'normal', 'linear', ->
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

  @EVENT_ID = @PrivateClass.EVENT_ID
  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN
  @actionProperties = @PrivateClass.actionProperties

  if EventConfig?
    EventConfig.addEventConfigContents(@PrivateClass.CLASS_DIST_TOKEN)

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
