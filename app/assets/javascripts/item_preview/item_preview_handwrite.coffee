class ItemPreviewHandwrite extends Handwrite
  # マウスアップ時の描画イベント
  @mouseUpDrawing = ->
    if item?
      item.restoreAllDrawingSurface()
      item.endDraw(zindex)
      item.setupDragAndResizeEvents()
      WorktableCommon.changeMode(Constant.Mode.DRAW)
      zindex += 1
      # デザインコンフィグを初期化

