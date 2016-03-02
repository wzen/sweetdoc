class ItemPreviewHandwrite extends Handwrite
  # マウスアップ時の描画イベント
  @mouseUpDrawing = ->
    if window.handwritingItem?
      # 表示アイテムは一つのみ
      if window.scrollInside.find('.item').length == 0
        window.handwritingItem.restoreAllDrawingSurface()
        window.handwritingItem.endDraw(@zindex, true, =>
          window.handwritingItem.setupItemEvents()
          window.handwritingItem.saveObj(true)
          @zindex += 1
          # デザインコンフィグを初期化
          Sidebar.initItemEditConfig(window.handwritingItem)
          # イベントコンフィグを初期化
          ItemPreviewEventConfig.addEventConfigContents(window.handwritingItem.classDistToken)
          # EventConfigのDistIdは適当
          Sidebar.initEventConfig(Common.generateId())
          window.handwritingItem = null
        )

    WorktableCommon.changeMode(constant.Mode.EDIT)
