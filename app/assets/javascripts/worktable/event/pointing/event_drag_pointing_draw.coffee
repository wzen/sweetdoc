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

    clearDraw: ->
      # アイテム削除
      @removeItemElement()
      @drawPaths = []

    applyDraw: ->
      if @applyCallback?
        @applyCallback(@itemSize)

    initData: ->
      @drawPaths = []

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
      @itemSize = null

    # ドラッグ描画(線)
    # @param [Array] cood 座標
    draw: (cood) ->
      if @itemSize != null
        @restoreRefreshingSurface(@itemSize)

      @itemSize = {x: null, y: null, w: null, h: null}
      @itemSize.w = Math.abs(cood.x - @_moveLoc.x);
      @itemSize.h = Math.abs(cood.y - @_moveLoc.y);
      if cood.x > @_moveLoc.x
        @itemSize.x = @_moveLoc.x
      else
        @itemSize.x = cood.x
      if cood.y > @_moveLoc.y
        @itemSize.y = @_moveLoc.y
      else
        @itemSize.y = cood.y
      drawingContext.strokeRect(@itemSize.x, @itemSize.y, @itemSize.w, @itemSize.h)

    endDraw: (callback = null) ->
      @itemSize.x += scrollContents.scrollLeft()
      @itemSize.y += scrollContents.scrollTop()
      @zindex = Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1

      @refresh(true, =>
        @getJQueryElement().addClass('drag_pointing')
        @setupDragAndResizeEvent()
        # コントローラ表示
        FloatView.showPointingController(@)
        if callback?
          callback()
      )

    drag: ->
      if @applyCallback?
        @applyCallback(@itemSize)

    resize: ->
      if @applyCallback?
        @applyCallback(@itemSize)

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

$.fn.eventDragPointingDraw = (applyDrawCallback, multiDraw = false) ->
  $(@).off('click').on('click', (e) =>
    pointing = new EventDragPointingDraw()
    pointing.setApplyCallback((pointingPaths) =>
      applyDrawCallback(pointingPaths)
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