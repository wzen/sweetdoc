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
      @removeItemElement()
      @drawPaths = []
      @drawPathIndex = 0

    applyDraw: ->
      if @applyCallback?
        @applyCallback(_callbackParam.call(@))

    initData: (@multiDraw) ->
      @drawPaths = []
      @drawPathIndex = 0

    # マウスダウン時の描画イベント
    # @param [Array] loc Canvas座標
    mouseDownDrawing: (callback = null) ->
      @saveDrawingSurface()
      # アイテム削除
      @removeItemElement()
      if callback?
        callback()

    # マウスアップ時の描画イベント
    mouseUpDrawing: (zindex, callback = null) ->
      @restoreAllDrawingSurface()
      @endDraw(callback)

    startCood: (cood) ->
      if cood?
        @_moveLoc = {x: cood.x, y: cood.y}
      if @multiDraw
        @drawPathIndex += 1
      else
        @drawPathIndex = 0
      @drawPaths[@drawPathIndex] = []
      @itemSize = null

    # ドラッグ描画(線)
    # @param [Array] cood 座標
    draw: (cood) ->
      drawPaths[@drawPathIndex].push(cood)
      @restoreRefreshingSurface(@itemSize)

      for d in @drawPaths
        drawingContext.beginPath()
        for p, idx in d
          if idx == 0
            drawingContext.moveTo(p.x, p.y)
          else
            drawingContext.lineTo(p.x, p.y)
        drawingContext.stroke()

    endDraw: (callback = null) ->
      @zindex = Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1

      @refresh(true, =>
        @getJQueryElement().addClass('drag_pointing')
        @setupDragAndResizeEvent()
        @endDrawCallback(_callbackParam.call(@))
        # コントローラ表示
        FloatView.showPointingController(@)
        if callback?
          callback()
      )

    # 以下の処理はなし
    saveObj: (newCreated = false) ->
    getItemPropFromPageValue : (prop, isCache = false) ->
    setItemPropToPageValue : (prop, value, isCache = false) ->
    applyDefaultDesign: ->
    makeCss: (forceUpdate = false) ->

    _callbackParam = ->
      m = @drawPaths
      if !@multiDraw
        m = @drawPaths[0]
      return m

  @getInstance: (cood = null) ->
    if !instance?
      instance = new @PrivateClass()
    instance.startCood(cood)
    return instance

$.fn.eventDragPointingDraw = (endDrawCallback, applyDrawCallback, multiDraw = false) ->
  $(@).off('click').on('click', (e) =>
    pointing = new EventDragPointingDraw()
    pointing.setApplyCallback((pointingPaths) =>
      applyDrawCallback(pointingPaths)
    )
    pointing.setEndDrawCallback((pointingPaths) =>
      endDrawCallback(pointingPaths)
    )
    pointing.initData()
    PointingHandwrite.initHandwrite(EventDragPointingDraw)
    WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.DRAW)
    FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, =>
      # 画面上のポイントアイテムを削除
      pointing = new EventDragPointingDraw()
      pointing.getJQueryElement().remove()
      Handwrite.initHandwrite()
      WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT)
    )

  )