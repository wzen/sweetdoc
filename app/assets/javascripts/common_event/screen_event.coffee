# 画面表示イベント
class ScreenEvent extends CommonEvent
  @instance = {}

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
            afterX: 0
            afterY: 0
            afterZ: 1
          }
        }
      }
    }

    getJQueryElement: ->
      return window.mainWrapper

    constructor: ->
      super()
      @name = 'Screen'
      @beforeScale = 1.0
      cood = _convertTopLeftToCenterCood.call(@, scrollContents.scrollTop(), scrollContents.scrollLeft(), @beforeScale)
      @beforeX = cood.x
      @beforeY = cood.y

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event, @keepDispMag = false) ->
      super(event)

    # 変更を戻して再表示
    refresh: (show = true, callback = null) ->
      displayPosition = PageValue.getScrollContentsPosition()
      Common.updateScrollContentsPosition(displayPosition.top, displayPosition.left, true, ->
        if callback?
          callback()
      )
      $('.keep_mag_base').remove()

    # イベント前の表示状態にする
    updateEventBefore: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        size = _convertCenterCoodToSize.call(@, @beforeX, @beforeY, @beforeScale)
        _drawKeepDispRect.call(@, @beforeX, @beforeY, @beforeScale)
        Common.updateScrollContentsPosition(size.top, size.left)

    # イベント後の表示状態にする
    updateEventAfter: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        x = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX)
        y = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY)
        scale = parseFloat(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ)
        size = _convertCenterCoodToSize.call(@, x, y, scale)
        _drawKeepDispRect.call(@, x, y, scale)
        Common.updateScrollContentsPosition(size.top, size.left)

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
        size = _convertCenterCoodToSize.call(@, x, y, scale)
        _rect.call(@, context, size.left, size.top, size.width, size.height)
        context.fill()
        context.restore()

      x = (parseInt(@_specificMethodValues.afterX) - @beforeX) * (opt.progress / opt.progressMax) + @beforeX
      y = (parseInt(@_specificMethodValues.afterY) - @beforeY) * (opt.progress / opt.progressMax) + @beforeY
      scale = (parseFloat(@_specificMethodValues.afterZ) - @beforeScale) * (opt.progress / opt.progressMax) + @beforeScale
      if opt.isPreview
        if @keepDispMag && scale < 1.0
          overlay = $('#preview_position_overlay')
          if !overlay? || overlay.length == 0
            # オーバーレイを被せる
            canvas = $("<canvas id='preview_position_overlay' style='background-color: transparent; width: 100%; height: 100%; z-index: #{Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1}'></canvas>")
            $(window.drawingCanvas).parent().append(canvas)
            overlay = $('#preview_position_overlay')
          # オーバーレイ描画
          canvasContext = overlay[0].getContent('2d')
          _drawOverlay.call(canvasContext, x, y, scale)
        else
          # オーバーレイ削除
          $('#preview_position_overlay').remove()

      size = _convertCenterCoodToSize.call(@, x, y, scale)
      Common.updateScrollContentsPosition(size.top, size.left, true)
      @getJQueryElement().css('scale', scale)

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
        FloatView.showFixed('Drag position', FloatView.Type.POINTING_DRAG, =>
          WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT)
        )
      )

    _drawKeepDispRect = (x, y, scale) ->
      $('.keep_mag_base').remove()

      if scale < 1.0
        size = _convertCenterCoodToSize.call(@, x, y, scale)
        style = "position:absolute;top:#{size.top}px;left:#{size.left}px;width:#{size.width}px;height:#{size.height}px;"
        emt = $("<div class='keep_mag_base' style='#{style}'></div>")
        window.scrollInside.append(emt)

    _convertCenterCoodToSize = (x, y, scale) ->
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
      width = screenSize.width * scale
      height = screenSize.height * scale
      top = y - height / 2.0
      left = x - width / 2.0
      return {top: top, left: left, width: width, height: height}

    _convertTopLeftToCenterCood = (top, left, scale) ->
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
      width = screenSize.width * scale
      height = screenSize.height * scale
      y = top + height / 2.0
      x = left + width / 2.0
      return {x: x, y: y}

  @EVENT_ID = @PrivateClass.EVENT_ID
  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN
  @actionProperties = @PrivateClass.actionProperties

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
