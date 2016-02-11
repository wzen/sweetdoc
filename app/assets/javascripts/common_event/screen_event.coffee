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
      if window.scrollContents?
        @initConfigX = window.scrollInsideWrapper.height() * 0.5
        @initConfigY = window.scrollInsideWrapper.width() * 0.5
      @nowX = null
      @nowY = null
      @nowScale = null
      @_initDone = false

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event, @_keepDispMag = false) ->
      super(event)

    initPreview: ->
      # initConfigの値を適用
      @_scale = _getInitConfigScale.call(@)

    # 変更を戻して再表示
    refresh: (show = true, callback = null) ->
      if window.isWorkTable
        WorktableCommon.initScrollContentsPosition()
      s = null
      if window.isWorkTable
        s = WorktableCommon.getWorktableViewScale()
      else
        s = 1.0
      _setScale.call(@, s)
      # オーバーレイ削除
      $('#preview_position_overlay').remove()
      $('.keep_mag_base').remove()
      # 倍率を戻す
      @_scale = s
      if callback?
        callback()

    # イベント前の表示状態にする
    updateEventBefore: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        if !@_keepDispMag && @nowScale?
          _setScale.call(@, @nowScale)
          size = _convertCenterCoodToSize.call(@, @nowX, @nowY, @nowScale)
          scrollContentsSize = Common.scrollContentsSizeUnderScreenEventScale()
          Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false)

    # イベント後の表示状態にする
    updateEventAfter: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        @_progressX = parseFloat(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX)
        @_progressY = parseFloat(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY)
        @_progressScale = parseFloat(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ)
        if @_keepDispMag
          _setScale.call(@, WorktableCommon.getWorktableViewScale())
          _overlay.call(@, @_progressX, @_progressY, @_progressScale)
        else
          _setScale.call(@, @_progressScale)
          size = _convertCenterCoodToSize.call(@, @_progressX, @_progressY, @_progressScale)
          scrollContentsSize = Common.scrollContentsSizeUnderScreenEventScale()
          Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false)

    # 画面移動イベント
    changeScreenPosition: (opt) =>
      @_progressScale = (parseFloat(@_specificMethodValues.afterZ) - @nowScale) * (opt.progress / opt.progressMax) + @nowScale
      @_progressX = ((parseFloat(@_specificMethodValues.afterX) - @nowX) * (opt.progress / opt.progressMax)) + @nowX
      @_progressY = ((parseFloat(@_specificMethodValues.afterY) - @nowY) * (opt.progress / opt.progressMax)) + @nowY
      if window.isWorkTable && opt.isPreview
        _overlay.call(@, @_progressX, @_progressY, @_progressScale)
        if @_keepDispMag
          _setScale.call(@, WorktableCommon.getWorktableViewScale())

      if !@_keepDispMag
        _setScale.call(@, @_progressScale)
        size = _convertCenterCoodToSize.call(@, @_progressX, @_progressY, @_progressScale)
        scrollContentsSize = Common.scrollContentsSizeUnderScreenEventScale()
        Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false)

    # プレビューを停止
    # @param [Function] callback コールバック
    stopPreview: (callback = null) ->
      setTimeout( ->
        # オーバーレイを削除
        $('#preview_position_overlay').remove()
      , 0)
      super(callback)

    willChapter: ->
      @nowScale = @_scale
      super()

    didChapter: ->
      @nowX = @_progressX
      @nowY = @_progressY
      @nowScale = @_progressScale
      @_progressScale = null
      @_scale = @nowScale
      super()

    setMiniumObject: (obj) ->
      super(obj)
      if !window.isWorkTable && !@_initDone
        _setScale.call(@, _getInitConfigScale.call(@))
        @nowScale = _getInitConfigScale.call(@)
        Common.updateScrollContentsPosition(@initConfigY, @initConfigX)
        @_initDone = true

    getNowScale: ->
      if !@_scale?
        @_scale = _getInitConfigScale.call(@)
      return @_scale

    getNowProgressScale: ->
      if @_progressScale?
        return @_progressScale
      else
        # 動作中でない場合はnowScaleを返却
        @getNowScale()

    # 独自コンフィグのイベント初期化
    @initSpecificConfig = (specificRoot) ->
      _updateConfigInput = (emt, pointingSize) ->
        x = pointingSize.x + pointingSize.w / 2.0
        y = pointingSize.y + pointingSize.h / 2.0
        z = null
        screenSize = Common.getScreenSize()
        if pointingSize.w > pointingSize.h
          z = screenSize.width / pointingSize.w
        else
          z = screenSize.height / pointingSize.h
        emt.find('.afterX:first').val(x)
        emt.find('.afterY:first').val(y)
        emt.find('.afterZ:first').val(z)

      emt = specificRoot['changeScreenPosition']
      emt.find('.event_pointing:first').eventDragPointingRect({
        applyDrawCallback: (pointingSize) =>
          _updateConfigInput.call(@, emt, pointingSize)
      })

    @setNowXAndY = (x, y) ->
      if ScreenEvent.hasInstanceCache()
        se = new ScreenEvent()
        ins = PageValue.getInstancePageValue(PageValue.Key.instanceValue(se.id))
        if ins?
          ins.nowX = x
          ins.nowY = y
          PageValue.setInstancePageValue(PageValue.Key.instanceValue(se.id), ins)
        se.nowX = x
        se.nowY = y

    @resetNowScale = ->
      if ScreenEvent.hasInstanceCache()
        se = new ScreenEvent()
        s = null
        if window.isWorkTable
          s = WorktableCommon.getWorktableViewScale()
        else
          s = 1.0
        se.scale = s

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
        size = _convertCenterCoodToSize.call(@, x, y, WorktableCommon.getWorktableViewScale())
        w = size.width / scale
        h = size.height / scale
        top = y - h / 2.0
        left = x - w / 2.0
        _rect.call(@, context, left - window.scrollContents.scrollLeft(), top - window.scrollContents.scrollTop(), w, h)
        context.fill()
        context.restore()

      if @_keepDispMag && scale > WorktableCommon.getWorktableViewScale()
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

    _convertCenterCoodToSize = (x, y, scale) ->
      screenSize = Common.getScreenSize()
      width = screenSize.width / scale
      height = screenSize.height / scale
      top = y - height / 2.0
      left = x - width / 2.0
      return {top: top, left: left, width: width, height: height}

    _setScale = (scale) ->
      @_scale = scale
      Common.applyViewScale()

    _getScale = ->
      return @_scale

    _getInitConfigScale = ->
      if window.isWorkTable && !window.previewRunning
        return WorktableCommon.getWorktableViewScale()
      return @initConfigScale

  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
