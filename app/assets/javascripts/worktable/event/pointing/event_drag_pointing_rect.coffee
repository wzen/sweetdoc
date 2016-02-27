class EventDragPointingRect
  # SingleTon

  instance = null

  constructor: (cood = null) ->
    return @constructor.getInstance(cood)

  class @PrivateClass extends CssItemBase
    @NAME_PREFIX = "EDPointingRect"
    @CLASS_DIST_TOKEN = 'EDPointingRect'

    @include(itemBaseWorktableExtend)

    setApplyCallback: (callback) ->
      @applyCallback = callback

    clearDraw: ->
      # アイテム削除
      @removeItemElement()

    applyDraw: ->
      if @applyCallback?
        @applyCallback(@itemSize)

    # マウスダウン時の描画イベント
    # @param [Array] loc Canvas座標
    mouseDownDrawing: (callback = null) ->
      # アイテム削除
      @removeItemElement()
      @saveDrawingSurface()
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

    # ドラッグ描画(枠)
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
        # コントローラ表示
        FloatView.showPointingController(@)
        if callback?
          callback()
      , false)

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
    applyDrawCallback = opt.applyDrawCallback
    closeCallback = opt.closeCallback
    pointing = new @()
    pointing.setApplyCallback((pointingSize) =>
      applyDrawCallback(pointingSize)
      Handwrite.initHandwrite()
      WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT)
      EventDragPointingRect.draw(pointingSize)
    )
    PointingHandwrite.initHandwrite(@)
    WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.DRAW)
    FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, =>
      if closeCallback?
        closeCallback()
      else
        # 画面上のポイントアイテムを削除
        pointing = new @()
        pointing.getJQueryElement().remove()
      Handwrite.initHandwrite()
      WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT)
    )
    @clear()

  @draw: (size) ->
    if size?
      pointing = new @()
      pointing.itemSize = size
      pointing.zindex = Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1
      pointing.refresh(true, =>
        pointing.getJQueryElement().addClass('drag_pointing')
      , false)
  @clear: ->
    pointing = new @()
    pointing.clearDraw()

$.fn.eventDragPointingRect = (opt, eventType = 'click') ->
  if eventType == 'click'
    $(@).off('click.event_pointing_rect').on('click.event_pointing_rect', (e) =>
      EventDragPointingRect.run(opt)
    )
