# 画面表示イベント
class ScreenEvent extends CommonEvent
  @instance = {}

  class @PrivateClass extends CommonEvent.PrivateClass
    @EVENT_ID = '2'
    @CLASS_DIST_TOKEN = "PI_ScreenEvent"
    @TAKE_SCALE_FROM_MAINWRAPPER = 0.0000
    @scale = 1.0

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
            afterX: ''
            afterY: ''
            afterZ: ''
          }
        }
      }
    }

    getJQueryElement: ->
      return window.mainWrapper

    constructor: ->
      super()
      @name = 'Screen'
      cood = _convertTopLeftToCenterCood.call(@, scrollContents.scrollTop(), scrollContents.scrollLeft(), 1.0)
      @_originalX = cood.x
      @_originalY = cood.y
      @initScale = @constructor.TAKE_SCALE_FROM_MAINWRAPPER
      @initX = null
      @initY = null
      @beforeX = null
      @beforeY = null
      @beforeScale = null

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event, @keepDispMag = false) ->
      super(event)

    _takeScaleFromMainwrapper = ->
      if @initScale == @constructor.TAKE_SCALE_FROM_MAINWRAPPER
        @initScale = _getScale.call(@)
        cood = _convertTopLeftToCenterCood.call(@, scrollContents.scrollTop(), scrollContents.scrollLeft(), @initScale)
        @initX = cood.x
        @initY = cood.y
        @beforeX = @initX
        @beforeY = @initY
        @beforeScale = @initScale

    # 変更を戻して再表示
    refresh: (show = true, callback = null) ->
      pos = _convertCenterCoodToSize.call(@, @_originalX, @_originalY, 1.0)
      _setScale.call(@, 1.0)
      Common.updateScrollContentsPosition(pos.top, pos.left, true, ->
        if callback?
          callback()
      )
      # オーバーレイ削除
      $('#preview_position_overlay').remove()
      $('.keep_mag_base').remove()

    # イベント前の表示状態にする
    updateEventBefore: ->
      super()
      _takeScaleFromMainwrapper.call(@)
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        _setScale.call(@, @beforeScale)
        _overlay.call(@, @beforeX, @beforeY, @beforeScale)
        if !@keepDispMag
          size = _convertCenterCoodToSize.call(@, @beforeX, @beforeY, @beforeScale)
          Common.updateScrollContentsPosition(size.top, size.left)

    # イベント後の表示状態にする
    updateEventAfter: ->
      super()
      _takeScaleFromMainwrapper.call(@)
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        @_nowX = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX)
        @_nowY = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY)
        @_nowScale = parseFloat(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ)
        _setScale.call(@, @_nowScale)
        _overlay.call(@, @_nowX, @_nowY, @_nowScale)
        if !@keepDispMag
          size = _convertCenterCoodToSize.call(@, @_nowX, @_nowY, @_nowScale)
          Common.updateScrollContentsPosition(size.top, size.left)

    # 画面移動イベント
    changeScreenPosition: (opt) =>
      _takeScaleFromMainwrapper.call(@)
      @_nowScale = (parseFloat(@_specificMethodValues.afterZ) - @beforeScale) * (opt.progress / opt.progressMax) + @beforeScale
      @_nowX = ((parseFloat(@_specificMethodValues.afterX) - @beforeX) * (opt.progress / opt.progressMax)) + @beforeX
      @_nowY = ((parseFloat(@_specificMethodValues.afterY) - @beforeY) * (opt.progress / opt.progressMax)) + @beforeY
      if opt.isPreview
        _overlay.call(@, @_nowX, @_nowY, @_nowScale)
        if @keepDispMag
          _setScale.call(@, 1.0)

      if !@keepDispMag
        _setScale.call(@, @_nowScale)
        size = _convertCenterCoodToSize.call(@, @_nowX, @_nowY, @_nowScale)
        Common.updateScrollContentsPosition(size.top, size.left, true)

    # プレビューを停止
    # @param [Function] callback コールバック
    stopPreview: (loopFinishCallback = null, callback = null) ->
      setTimeout( ->
        # オーバーレイを削除
        $('#preview_position_overlay').remove()
      , 0)
      super(loopFinishCallback, callback)

    didChapter: ->
      @beforeX = @_nowX
      @beforeY = @_nowY
      @beforeScale = @_nowScale
      super()

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

    _overlay = (x, y, scale) ->
      _drawOverlay = (context, x, y, width, height, scale) ->
        _rect = (context, x, y, w, h) ->
          context.moveTo(x, y);
          context.lineTo(x, y + h);
          context.lineTo(x + w, y + h);
          context.lineTo(x + w, y);
          context.closePath();

        context.clearRect(0, 0, width, height);
        context.save()
        context.fillStyle = "rgba(33, 33, 33, 0.5)";
        context.beginPath();
        context.rect(0, 0, width, height);
        # 枠を作成
        size = _convertCenterCoodToSize.call(@, x, y, 1.0)
        w = size.width / scale
        h = size.height / scale
        top = y - h / 2.0
        left = x - w / 2.0
        _rect.call(@, context, left - window.scrollContents.scrollLeft(), top - window.scrollContents.scrollTop(), w, h)
        context.fill()
        context.restore()

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

    _drawKeepDispRect = (x, y, scale) ->
      $('.keep_mag_base').remove()

      if scale > 1.0
        size = _convertCenterCoodToSize.call(@, x, y, scale)
        style = "position:absolute;top:#{size.top}px;left:#{size.left}px;width:#{size.width}px;height:#{size.height}px;"
        emt = $("<div class='keep_mag_base' style='#{style}'></div>")
        window.scrollInside.append(emt)

    _convertCenterCoodToSize = (x, y, scale) ->
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
      width = screenSize.width / scale
      height = screenSize.height / scale
      top = y - height / 2.0
      left = x - width / 2.0
      return {top: top, left: left, width: width, height: height}

    _convertTopLeftToCenterCood = (top, left, scale) ->
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
      width = screenSize.width / scale
      height = screenSize.height / scale
      y = top + height / 2.0
      x = left + width / 2.0
      return {x: x, y: y}

    _setScale = (scale) ->
      @constructor.scale = scale
      Common.applyViewScale()

    _getScale = ->
      return @constructor.scale


  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
