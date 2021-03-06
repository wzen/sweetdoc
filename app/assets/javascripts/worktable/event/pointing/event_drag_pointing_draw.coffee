class EventDragPointingDraw
  # SingleTon

  instance = null

  constructor: (cood = null) ->
    return @constructor.getInstance(cood)

  class @PrivateClass extends CssItemBase
    @NAME_PREFIX = "EDPointingDraw"
    @CLASS_DIST_TOKEN = 'EDPointingDraw'

    @include(itemBaseWorktableExtend)

    setApplyCallback: (callback) ->
      @applyCallback = callback

    setEndDrawCallback: (callback) ->
      @endDrawCallback = callback

    clearDraw: ->
      # アイテム削除
      drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height)
      @drawPaths = []
      @drawPathIndex = 0

    applyDraw: ->
      # アイテム削除
      drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height)
      if @applyCallback?
        @applyCallback(@drawPaths)

    initData: (@multiDraw) ->
      @drawPaths = []
      @drawPathIndex = 0

    # マウスダウン時の描画イベント
    # @param [Array] loc Canvas座標
    mouseDownDrawing: (callback = null) ->
      #@saveDrawingSurface()
      if callback?
        callback()

    # マウスアップ時の描画イベント
    mouseUpDrawing: (zindex, callback = null) ->
      #@restoreAllDrawingSurface()
      @endDraw(callback)

    startCood: (cood) ->
      if cood?
        @_moveLoc = {x: cood.x, y: cood.y}
      if @multiDraw && @drawPaths.length > 0
        @drawPathIndex += 1
      else
        @drawPaths = []
        @drawPathIndex = 0
      @drawPaths[@drawPathIndex] = []
      @itemSize = null

    # ドラッグ描画(線)
    # @param [Array] cood 座標
    draw: (cood) ->
      @drawPaths[@drawPathIndex].push(cood)

      for d in @drawPaths
        drawingContext.beginPath()
        for p, idx in d
          if idx == 0
            drawingContext.moveTo(p.x, p.y)
          else
            drawingContext.lineTo(p.x, p.y)
        drawingContext.stroke()

    endDraw: (zindex, show = true, callback = null) ->
      if @endDrawCallback?
        @endDrawCallback(@drawPaths)
      # コントローラ表示
      FloatView.showPointingController(@)
      if callback?
        callback()

    # 以下の処理はなし
    saveObj: (newCreated = false) ->
    getItemPropFromPageValue : (prop, isCache = false) ->
    setItemPropToPageValue : (prop, value, isCache = false) ->
    applyDefaultDesign: ->
    makeCss: (forceUpdate = false) ->

  @getInstance: (cood = null) ->
    if !instance?
      instance = new @PrivateClass()
    instance.startCood(cood)
    return instance

  @run: (opt) ->
    endDrawCallback = opt.endDrawCallback
    applyDrawCallback = opt.applyDrawCallback
    multiDraw = opt.multiDraw
    if !multiDraw?
      multiDraw = false
    pointing = new @()
    pointing.setApplyCallback((pointingPaths) =>
      _cb = =>
        pointing = new @()
        pointing.getJQueryElement().remove()
        Handwrite.initHandwrite()
        WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT)
      if applyDrawCallback?
        if applyDrawCallback(pointingPaths)
          _cb.call(@)
      else
        _cb.call(@)
    )
    pointing.setEndDrawCallback((pointingPaths) =>
      if endDrawCallback?
        endDrawCallback(pointingPaths)
    )
    pointing.initData(multiDraw)
    PointingHandwrite.initHandwrite(@)
    WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.DRAW)
    FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, =>
      # 画面上のポイントアイテムを削除
      pointing = new @()
      pointing.getJQueryElement().remove()
      Handwrite.initHandwrite()
      WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT)
    )

$.fn.eventDragPointingDraw = (opt, eventType = 'click') ->
  if eventType == 'click'
    $(@).off('click.event_pointing_draw').on('click.event_pointing_draw', (e) =>
      EventDragPointingDraw.run(opt)
    )
  else if eventType == 'change'
    $(@).off('change.event_pointing_draw').on('change.event_pointing_draw', (e) =>
      if $(e.target).val == opt.targetValue
        EventDragPointingDraw.run(opt)
    )