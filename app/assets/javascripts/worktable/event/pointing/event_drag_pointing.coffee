class EventDragPointing
  # SingleTon

  instance = null

  constructor: (cood = null) ->
    return @constructor.getInstance(cood)

  class @PrivateClass extends CssItemBase
    @NAME_PREFIX = "EDPointing"
    @CLASS_DIST_TOKEN = 'EDPointing'

    constructor: (cood) ->
      super(cood)

    @include(itemBaseWorktableExtend)

    setDrawCallback: (callback) ->
      @drawCallback = callback

    # 枠のみのエレメント描画
    cssItemHtml: ->
      return '<div class="drag_pointing"></div>'

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
      @zindex = Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1

      @refresh(true, =>
        @setupDragAndResizeEvent()
        if @drawCallback?
          @drawCallback(@itemSize)
        if callback?
          callback()
      )

    drag: ->
      if @drawCallback?
        @drawCallback(@itemSize)

    resize: ->
      if @drawCallback?
        @drawCallback(@itemSize)

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
