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
      @beforeZoom = 1.0

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event, @keepDispMag = false) ->
      super(event)

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

    _drawKeepDispRect = (x, y, scale) ->
      $('.keep_mag_base').remove()
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
      width = screenSize.width * scale
      height = screenSize.height * scale
      top = y - height / 2.0
      left = x - width / 2.0
      style = "position:absolute;top:#{top}px;left:#{left}px;width:#{width}px;height:#{height}px;"
      emt = $("<div class='keep_mag_base' style='#{style}'></div>")
      window.scrollInside.append(emt)

    # 画面移動イベント
    changeScreenPosition: (opt) =>
      _drawOverlay = (context, x, y, scale) ->
        _rect = (context, x, y, w, h) ->
          context.beginPath();
          context.moveTo(x, y);
          context.lineTo(x + w, y);
          context.lineTo(x + w, y + h);
          context.lineTo(x, y + h);
          context.closePath();

        context.fillStyle = 'gray'
        context.clearRect(0, 0, context.canvas.width, context.canvas.height);
        context.save()
        context.rect(0, 0, context.canvas.width, context.canvas.height);
        # projectサイズで枠を作成
        screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
        top = y - (screenSize.height * scale) / 2.0
        left = x - (screenSize.width * scale) / 2.0
        _rect(context, left, top, (screenSize.width * scale),(screenSize.height * scale))
        context.fill()
        context.restore()

      x = (@_specificMethodValues.afterX - @beforeScrollLeft) * (opt.progress / opt.progressMax) + @beforeScrollLeft
      y = (@_specificMethodValues.afterY - @beforeScrollTop) * (opt.progress / opt.progressMax) + @beforeScrollTop
      scale = (@_specificMethodValues.afterZ - @beforeZoom) * (opt.progress / opt.progressMax) + @beforeZoom
      if opt.isPreview
        if @keepDispMag && scale < 1.0
          overlay = $('#preview_position_overlay')
          if !overlay? || overlay.length == 0
            # オーバーレイを被せる
            canvas = $("<canvas id='preview_position_overlay' style='background-color: transparent; width: 100%; height: 100%; z-index: #{Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1}'></canvas>")
            window.drawingCanvas.parent().append(canvas)
            overlay = $('#preview_position_overlay')
          # オーバーレイ描画
          canvasContext = overlay[0].getContent('2d')
          _drawOverlay.call(canvasContext, x, y, scale)
        else
          # オーバーレイ削除
          $('#preview_position_overlay').remove()

      actionType = @getEventActionType()
      if actionType == Constant.ActionType.CLICK
        finished_count = 0
        scrollLeft = parseInt(x)
        scrollTop = parseInt(y)
        Common.updateScrollContentsPosition(scrollTop, scrollLeft, false, ->
          finished_count += 1
          if finished_count >= 2
            @_isFinishedEvent = true
            if opt.complete?
              opt.complete()
        )
        @getJQueryElement().transition({scale: "#{scale}"}, 'normal', 'linear', ->
          finished_count += 1
          if finished_count >= 2
            @_isFinishedEvent = true
            if opt.complete?
              opt.complete()
        )

    # プレビューを停止
    # @param [Function] callback コールバック
    stopPreview: (callback = null) ->
      # オーバーレイを削除
      $('#preview_position_overlay').remove()
      super(callback)

    # 独自コンフィグのイベント初期化
    @initSpecificConfig = (specificRoot) ->
      _updateConfigInput = (emt, pointingSize) ->
        x = pointingSize.x + pointingSize.w / 2.0
        y = pointingSize.y + pointingSize.h / 2.0
        z = null
        screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
        if pointingSize.w > pointingSize.h
          z = pointingSize.w / screenSize.width
        else
          z = pointingSize.h / screenSize.height
        emt.find('.afterX:first').val(x)
        emt.find('.afterY:first').val(y)
        emt.find('.afterZ:first').val(z)

      emt = specificRoot['changeScreenPosition']
      emt.find('event_pointing:first').off('click').on('click', (e) =>
        pointing = new EventDragPointing()
        pointing.setDrawCallback((pointingSize) =>
          _updateConfigInput.call(@, emt, pointingSize)
        )

        WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.DRAW)
        FloatView.showFixed('Drag position', FloatView.Type.INFO, =>
          WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT)
        )
      )

  @EVENT_ID = @PrivateClass.EVENT_ID
  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN
  @actionProperties = @PrivateClass.actionProperties

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
