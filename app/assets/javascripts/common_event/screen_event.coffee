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
      @initConfigX = null
      @initConfigY = null
      @initConfigScale = Common.getWorktableViewScale()
      @eventBaseX = null
      @eventBaseY = null
      @eventBaseScale = null
      @previewLaunchBaseScale = null
      @_notMoving = true
      @_initDone = false

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event, @_keepDispMag = false) ->
      super(event)

    initPreview: ->
      @previewLaunchBaseScale = @eventBaseScale
      if @_notMoving
        @previewLaunchBaseScale = _getInitScale.call(@)
        # 画面スクロール位置更新
        if @hasInitConfig()
          if !@_keepDispMag
            Common.updateScrollContentsPosition(@initConfigY, @initConfigX, true, false)
          @eventBaseX = @initConfigX
          @eventBaseY = @initConfigY
          @eventBaseScale = @initConfigScale

    # 変更を戻して再表示
    refresh: (show = true, callback = null) ->
      s = null
      # 倍率を戻す
      if window.isWorkTable && (!window.previewRunning || @_keepDispMag)
        @resetNowScaleToWorktableScale()
        _setScaleAndUpdateViewing.call(@, WorktableCommon.getWorktableViewScale())
      else if @_notMoving
        # Run初期値で戻す
        _setScaleAndUpdateViewing.call(@, _getInitScale.call(@))
      else
        # イベント中の倍率
        _setScaleAndUpdateViewing.call(@, @eventBaseScale)
      # オーバーレイ削除
      $('#preview_position_overlay').remove()
      $('.keep_mag_base').remove()
      @_notMoving = true
      if callback?
        callback(@)

    # イベント前の表示状態にする
    updateEventBefore: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        if !@_keepDispMag && @eventBaseScale?
          _setScaleAndUpdateViewing.call(@, @eventBaseScale)
          size = _convertCenterCoodToSize.call(@, @eventBaseX, @eventBaseY, @eventBaseScale)
          scrollContentsSize = Common.scrollContentsSizeUnderScale()
          Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false)

    # イベント後の表示状態にする
    updateEventAfter: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeScreenPosition'
        p = Common.calcScrollTopLeftPosition(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY, @_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX)
        @_progressX = parseFloat(p.left)
        @_progressY = parseFloat(p.top)
        @_progressScale = parseFloat(@_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ)
        if @_keepDispMag
          _setScaleAndUpdateViewing.call(@, WorktableCommon.getWorktableViewScale())
          _overlay.call(@, @_progressX, @_progressY, @_progressScale)
        else
          _setScaleAndUpdateViewing.call(@, @_progressScale)
          size = _convertCenterCoodToSize.call(@, @_progressX, @_progressY, @_progressScale)
          scrollContentsSize = Common.scrollContentsSizeUnderScale()
          Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false)

    # 画面移動イベント
    changeScreenPosition: (opt) =>
      p = Common.calcScrollTopLeftPosition(@_specificMethodValues.afterY, @_specificMethodValues.afterX)
      @_progressScale = (parseFloat(@_specificMethodValues.afterZ) - @eventBaseScale) * (opt.progress / opt.progressMax) + @eventBaseScale
      @_progressX = ((parseFloat(p.left) - @eventBaseX) * (opt.progress / opt.progressMax)) + @eventBaseX
      @_progressY = ((parseFloat(p.top) - @eventBaseY) * (opt.progress / opt.progressMax)) + @eventBaseY
      if window.isWorkTable && opt.isPreview
        _overlay.call(@, @_progressX, @_progressY, @_progressScale)
        if @_keepDispMag
          _setScaleAndUpdateViewing.call(@, WorktableCommon.getWorktableViewScale())

      if !@_keepDispMag
        _setScaleAndUpdateViewing.call(@, @_progressScale)
        size = _convertCenterCoodToSize.call(@, @_progressX, @_progressY, @_progressScale)
        scrollContentsSize = Common.scrollContentsSizeUnderScale()
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
      if window.previewRunning
        # 倍率を戻す
        @eventBaseScale = @previewLaunchBaseScale
      else
        if @_notMoving
          @eventBaseScale = _getInitScale.call(@)
      super()

    didChapter: ->
      @eventBaseX = @_progressX
      @eventBaseY = @_progressY
      @eventBaseScale = @_progressScale
      @_progressScale = null
      super()

    setMiniumObject: (obj) ->
      super(obj)
      if !@_initDone
        if !window.isWorkTable
          _setScaleAndUpdateViewing.call(@, _getInitScale.call(@))
          @eventBaseScale = _getInitScale.call(@)
          # スクロール位置設定
          Common.initScrollContentsPosition()
          RunCommon.updateMainViewSize()
        else
          # スクロール位置更新
          WorktableCommon.initScrollContentsPosition()
          WorktableCommon.updateMainViewSize()
        @_initDone = true
        @_notMoving = true

    getNowScreenEventScale: ->
      if !@_nowScreenEventScale?
        # 設定されていない場合は初期値を返す
        @_nowScreenEventScale = _getInitScale.call(@)
      return @_nowScreenEventScale

    hasInitConfig: ->
      return @initConfigX? && @initConfigY?

    setInitConfig: (x, y, scale) ->
      @initConfigX = x
      @initConfigY = y
      @initConfigScale = scale
      @eventBaseScale = @initConfigScale
      @setItemAllPropToPageValue()

    clearInitConfig: ->
      @initConfigX = null
      @initConfigY = null
      s = Common.getWorktableViewScale()
      @initConfigScale = s
      @eventBaseScale = s
      @setItemAllPropToPageValue()

    resetNowScaleToWorktableScale: ->
      @eventBaseScale = WorktableCommon.getWorktableViewScale()

    # 独自コンフィグのイベント初期化
    @initSpecificConfig = (specificRoot) ->
      _updateConfigInput = (emt, pointingSize) ->
        x =  pointingSize.x + pointingSize.w * 0.5
        y = pointingSize.y + pointingSize.h * 0.5
        z = null
        screenSize = Common.getScreenSize()
        if pointingSize.w > pointingSize.h
          z = screenSize.width / pointingSize.w
        else
          z = screenSize.height / pointingSize.h
        center = Common.calcScrollCenterPosition(y, x)
        emt.find('.afterX:first').removeClass('empty').val(center.left)
        emt.find('.afterY:first').removeClass('empty').val(center.top)
        emt.find('.afterZ:first').removeClass('empty').val(z)

      emt = specificRoot['changeScreenPosition']
      emt.find('.event_pointing:first').eventDragPointingRect({
        applyDrawCallback: (pointingSize) =>
          _updateConfigInput.call(@, emt, pointingSize)
      })
      x = emt.find('.afterX:first')
      if x.val().length == 0
        x.attr('disabled', 'disabled').addClass('empty')
      y = emt.find('.afterY:first')
      if y.val().length == 0
        y.attr('disabled', 'disabled').addClass('empty')
      z = emt.find('.afterZ:first')
      if z.val().length == 0
        z.attr('disabled', 'disabled').addClass('empty')

    @setEventBaseXAndY = (x, y) ->
      if ScreenEvent.hasInstanceCache()
        se = new ScreenEvent()
        ins = PageValue.getInstancePageValue(PageValue.Key.instanceValue(se.id))
        if ins?
          ins.eventBaseX = x
          ins.eventBaseY = y
          PageValue.setInstancePageValue(PageValue.Key.instanceValue(se.id), ins)
        se.eventBaseX = x
        se.eventBaseY = y

    _overlay = (x, y, scale) ->
      _drawOverlay = (context, x, y, width, height, scale) ->
        _rect = (context, x, y, w, h) ->
          context.moveTo(x, y);
          context.lineTo(x, y + h);
          context.lineTo(x + w, y + h);
          context.lineTo(x + w, y);
          context.closePath();

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
        context.clearRect(0, 0, width, height);
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

    _setScaleAndUpdateViewing = (scale) ->
      @_nowScreenEventScale = scale
      @_notMoving = false
      Common.applyViewScale()

    _getInitScale = ->
      if window.isWorkTable && !window.previewRunning
        return WorktableCommon.getWorktableViewScale()
      else if @initConfigScale?
        return @initConfigScale
      else
        return 1.0

  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent)
