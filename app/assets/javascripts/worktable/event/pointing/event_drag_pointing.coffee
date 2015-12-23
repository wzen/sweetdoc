class EventDragPointing
  # SingleTon

  instance = null

  constructor: (cood = null) ->
    return @constructor.getInstance(cood)

  class @PrivateClass
    setDrawEndCallback: (callback) ->
      @drawEndCallback = callback

    startCood: (cood) ->
      if cood?
        @_moveLoc = {x: cood.x, y: cood.y}
      @itemSize = null

    # ドラッグ描画(枠)
    # @param [Array] cood 座標
    draw: (cood) ->
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

    endDraw: ->
      # Canvasに枠を描く

      if @drawEndCallback?
        @drawEndCallback(@itemSize)

  @getInstance: (cood = null) ->
    if !instance?
      instance = new @PrivateClass()
    instance.startCood(cood)
    return instance

  # マウスダウン時の描画イベント
  # @param [Array] loc Canvas座標
  mouseDownDrawing: (callback = null) ->

  # マウスアップ時の描画イベント
  mouseUpDrawing: (zindex, callback = null) ->
    @endDraw(zindex)

  # ドラッグ描画(枠)
  # @param [Array] cood 座標
  draw: (cood) ->
    instance.draw(cood)

  # ドラッグ終了
  endDraw: (zindex, show = true, callback = null) ->
    instance.endDraw()