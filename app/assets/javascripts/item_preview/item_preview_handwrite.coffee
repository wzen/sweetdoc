class ItemPreviewHandwrite extends Handwrite
  # マウスアップ時の描画イベント
  @mouseUpDrawing = ->
    if @item?
      @item.restoreAllDrawingSurface()
      @item.endDraw(@zindex, true, =>
        @item.setupDragAndResizeEvents()
        WorktableCommon.changeMode(Constant.Mode.EDIT)
        @item.saveObj(true)
        @zindex += 1
        # デザインコンフィグを初期化
        Sidebar.initItemEditConfig(@item)
        # イベントコンフィグを初期化
        EventConfig.addEventConfigContents(@item.itemId)
        Sidebar.initEventConfig()
      )
