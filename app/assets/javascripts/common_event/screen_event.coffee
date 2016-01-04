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
      @initConfigX = 0
      @initConfigY = 0
      @initConfigScale = 1.0
      @nowX = null
      @nowY = null
      @nowScale = null

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event, @keepDispMag = false) ->
      super(event)

    # 変更を戻して再表示
    refresh: (show = true, callback = null) ->
      Common.updateWorktableScrollContentsFromPageValue()
      _setScale.call(@, Common.scaleFromViewRate)
      # オーバーレイ削除
      $('#preview_position_overlay').remove()
      $('.keep_mag_base').remove()
      if callback?
        callback()

    # イベント前の表示状態にする
    updateEventBefore: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        if !@keepDispMag
          _setScale.call(@, @nowScale)
          size = _convertCenterCoodToSize.call(@, @nowX, @nowY, @nowScale)
          Common.updateScrollContentsPosition(size.top, size.left, true, false)

    # イベント後の表示状態にする
    updateEventAfter: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        @_progressX = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX)
        @_progressY = parseInt(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY)
        @_progressScale = parseFloat(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ)
        if @keepDispMag
          _setScale.call(@, Common.scaleFromViewRate)
          _overlay.call(@, @_progressX, @_progressY, @_progressScale)
        else
          _setScale.call(@, @_progressScale)
          size = _convertCenterCoodToSize.call(@, @_progressX, @_progressY, @_progressScale)
          Common.updateScrollContentsPosition(size.top, size.left, true, false)

    # 画面移動イベント
    changeScreenPosition: (opt) =>
      @_progressScale = (parseFloat(@_specificMethodValues.afterZ) - @nowScale) * (opt.progress / opt.progressMax) + @nowScale
      @_progressX = ((parseFloat(@_specificMethodValues.afterX) - @nowX) * (opt.progress / opt.progressMax)) + @nowX
      @_progressY = ((parseFloat(@_specificMethodValues.afterY) - @nowY) * (opt.progress / opt.progressMax)) + @nowY
      if opt.isPreview
        _overlay.call(@, @_progressX, @_progressY, @_progressScale)
        if @keepDispMag
          _setScale.call(@, Common.scaleFromViewRate)

      if !@keepDispMag
        _setScale.call(@, @_progressScale)
        size = _convertCenterCoodToSize.call(@, @_progressX, @_progressY, @_progressScale)
        Common.updateScrollContentsPosition(size.top, size.left, true, false)

    # プレビューを停止
    # @param [Function] callback コールバック
    stopPreview: (loopFinishCallback = null, callback = null) ->
      setTimeout( ->
        # オーバーレイを削除
        $('#preview_position_overlay').remove()
      , 0)
      super(loopFinishCallback, callback)

    didChapter: ->
      @nowX = @_progressX
      @nowY = @_progressY
      @nowScale = @_progressScale
      super()

    getNowScale: ->
      if !@nowScale?
        @nowScale = @initConfigScale
      return @nowScale

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
      emt.find('.event_pointing:first').eventDragPointing( (pointingSize) =>
        _updateConfigInput.call(@, emt, pointingSize)
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
        size = _convertCenterCoodToSize.call(@, x, y, Common.scaleFromViewRate)
        w = size.width / scale
        h = size.height / scale
        top = y - h / 2.0
        left = x - w / 2.0
        _rect.call(@, context, left - window.scrollContents.scrollLeft(), top - window.scrollContents.scrollTop(), w, h)
        context.fill()
        context.restore()

      if @keepDispMag && scale > Common.scaleFromViewRate
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

      if scale > Common.scaleFromViewRate
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
      @nowScale = scale
      Common.applyViewScale()

    _getScale = ->
      return @nowScale

  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
