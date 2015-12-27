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
      cood = _convertTopLeftToCenterCood.call(@, scrollContents.scrollTop(), scrollContents.scrollLeft())
      @beforeX = cood.x
      @beforeY = cood.y

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event, @keepDispMag = false) ->
      super(event)

    # 変更を戻して再表示
    refresh: (show = true, callback = null) ->
      pos = _convertCenterCoodToSize.call(@, @beforeX, @beforeY)
      @getJQueryElement().css('scale', @beforeScale)
      Common.updateScrollContentsPosition(pos.top, pos.left, true, ->
        if callback?
          callback()
      )
      $('.keep_mag_base').remove()

    # イベント前の表示状態にする
    updateEventBefore: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        @getJQueryElement().css('scale', @beforeScale)
        size = _convertCenterCoodToSize.call(@, @beforeX, @beforeY)
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
        size = _convertCenterCoodToSize.call(@, x, y)
        _drawKeepDispRect.call(@, x, y, scale)
        Common.updateScrollContentsPosition(size.top, size.left)

    # 画面移動イベント
    changeScreenPosition: (opt) =>
      _drawOverlay = (context, x, y, width, height, scale) ->
        _rect = (context, x, y, w, h) ->
          context.moveTo(x, y);
          context.lineTo(x, y + h);
          context.lineTo(x + w, y + h);
          context.lineTo(x + w, y);
#          context.lineTo(x + w, y);
#          context.lineTo(x + w, y + h);
#          context.lineTo(x, y + h);
          context.closePath();

        context.clearRect(0, 0, width, height);
        context.save()
        context.fillStyle = "rgba(33, 33, 33, 0.5)";
        context.beginPath();
        context.rect(0, 0, width, height);
        # 枠を作成
        size = _convertCenterCoodToSize.call(@, x, y)
        w = size.width / scale
        h = size.height / scale
        top = y - h / 2.0
        left = x - w / 2.0
        _rect.call(@, context, left - window.scrollContents.scrollLeft(), top - window.scrollContents.scrollTop(), w, h)
        context.fill()
        context.restore()

      scale = (parseFloat(@_specificMethodValues.afterZ) - @beforeScale) * (opt.progress / opt.progressMax) + @beforeScale
      x = ((parseFloat(@_specificMethodValues.afterX) - @beforeX) * (opt.progress / opt.progressMax)) + @beforeX
      y = ((parseFloat(@_specificMethodValues.afterY) - @beforeY) * (opt.progress / opt.progressMax)) + @beforeY
      if opt.isPreview
        if @keepDispMag && scale > 1.0
          overlay = $('#preview_position_overlay')
          if !overlay? || overlay.length == 0
            # オーバーレイを被せる
            w = $(window.drawingCanvas).attr('width')
            h = $(window.drawingCanvas).attr('height')
            canvas = $("<canvas id='preview_position_overlay' class='canvas_container canvas' width='#{w}' height='#{h}' style='z-index: #{Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1}'></canvas>")
            $(window.drawingCanvas).parent().append(canvas)
            overlay = $('#preview_position_overlay')
          # オーバーレイ描画
          canvasContext = overlay[0].getContext('2d')
          _drawOverlay.call(@, canvasContext, x, y, overlay.width(), overlay.height(), scale)
        else
          # オーバーレイ削除
          $('#preview_position_overlay').remove()

      if !@keepDispMag
        @getJQueryElement().css('scale', scale)
        size = _convertCenterCoodToSize.call(@, x, y)
        Common.updateScrollContentsPosition(size.top, size.left, true)
      else
        @getJQueryElement().css('scale', 1.0)

    # プレビューを停止
    # @param [Function] callback コールバック
    stopPreview: (loopFinishCallback = null, callback = null) ->
      setTimeout( ->
        # オーバーレイを削除
        $('#preview_position_overlay').remove()
      , 0)
      super(loopFinishCallback, callback)

    # 独自コンフィグのイベント初期化
    @initSpecificConfig = (specificRoot) ->
      _updateConfigInput = (emt, pointingSize) ->
        x = pointingSize.x + pointingSize.w / 2.0
        y = pointingSize.y + pointingSize.h / 2.0
        z = null
        screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
        if pointingSize.w > pointingSize.h
          z = screenSize.width / pointingSize.w
        else
          z = screenSize.height / pointingSize.h
        emt.find('.afterX:first').val(x)
        emt.find('.afterY:first').val(y)
        emt.find('.afterZ:first').val(z)

      emt = specificRoot['changeScreenPosition']
      emt.find('.event_pointing:first').off('click').on('click', (e) =>
        pointing = new EventDragPointing()
        pointing.setDrawCallback((pointingSize) =>
          _updateConfigInput.call(@, emt, pointingSize)
        )
        PointingHandwrite.initHandwrite()

        WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.DRAW)
        FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, =>
          Handwrite.initHandwrite()
          WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT)
        )
      )

    _drawKeepDispRect = (x, y, scale) ->
      $('.keep_mag_base').remove()

      if scale > 1.0
        size = _convertCenterCoodToSize.call(@, x, y)
        style = "position:absolute;top:#{size.top}px;left:#{size.left}px;width:#{size.width}px;height:#{size.height}px;"
        emt = $("<div class='keep_mag_base' style='#{style}'></div>")
        window.scrollInside.append(emt)

    _convertCenterCoodToSize = (x, y) ->
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
      width = screenSize.width
      height = screenSize.height
      top = y - height / 2.0
      left = x - width / 2.0
      return {top: top, left: left, width: width, height: height}

    _convertTopLeftToCenterCood = (top, left) ->
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
      width = screenSize.width
      height = screenSize.height
      y = top + height / 2.0
      x = left + width / 2.0
      return {x: x, y: y}

  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
