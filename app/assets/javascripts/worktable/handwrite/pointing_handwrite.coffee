class PointingHandwrite extends Handwrite

  # 手書きイベント初期化
  @initHandwrite = (@targetClass) ->
    super()

  # マウスダウン時の描画イベント
  # @param [Array] loc Canvas座標
  @mouseDownDrawing = (loc) ->
    if window.eventPointingMode == Constant.EventInputPointingMode.DRAW
      # イベント入力描画
      window.handwritingItem = new (@targetClass)(loc)
      window.handwritingItem.mouseDownDrawing()

  @isDrawMode = ->
    return window.eventPointingMode == Constant.EventInputPointingMode.DRAW
