class ItemPreviewHandwrite extends Handwrite
  # マウスアップ時の描画イベント
  @mouseUpDrawing = ->
    if @item?
      # 表示アイテムは一つのみ
      if window.scrollInside.find('.item').length == 0
        @item.restoreAllDrawingSurface()
        @item.willCallEndDraw()
        @item.endDraw(@zindex, true, =>
          @item.didCallEndDraw()
          @item.setupDragAndResizeEvents()
          @item.saveObj(true)
          @zindex += 1
          # デザインコンフィグを初期化
          Sidebar.initItemEditConfig(@item)
          # イベントコンフィグを初期化
          ItemPreviewEventConfig.addEventConfigContents(@item.itemToken)
          # EventConfigのDistIdは適当
          Sidebar.initEventConfig(Common.generateId())
        )

    WorktableCommon.changeMode(Constant.Mode.EDIT)
