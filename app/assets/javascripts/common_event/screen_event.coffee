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
      if opt.isPreview && opt.keepDispMag
        overlay = $('#preview_position_overlay')
        if !overlay? || overlay.length == 0
          # オーバーレイを被せる
          canvas = $("<canvas id='preview_position_overlay' style='background-color: transparent; width: 100%; height: 100%; z-index: #{Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1}'></canvas>")
          window.drawingCanvas.parent().append(canvas)
          overlay = $('#preview_position_overlay')
        # オーバーレイ描画
        overlay

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

    # プレビューを停止
    # @param [Function] callback コールバック
    stopPreview: (callback = null) ->
      # オーバーレイを削除
      $('#preview_position_overlay').remove()
      super(callback)

    # 独自コンフィグのイベント初期化
    @initSpecificConfig = (specificRoot) ->
      emt = specificRoot['changeScreenPosition']
      emt.find('event_pointing:first').off('click').on('click', (e) =>
        WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.DRAW)
        FloatView.showFixed('Drag position', FloatView.Type.INFO, =>
          WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT)
        )
      )

  @EVENT_ID = @PrivateClass.EVENT_ID
  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN
  @actionProperties = @PrivateClass.actionProperties

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
