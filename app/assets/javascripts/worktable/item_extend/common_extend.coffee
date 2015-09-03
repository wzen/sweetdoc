# ワークテーブル用アイテム拡張モジュール
# 共通
WorkTableCommonExtend =
  # ドラッグ描画開始
  startDraw: ->
    return

  # ドラッグ描画
  draw: (cood) ->
    return

  # 描画&コンフィグ作成
  drawAndMakeConfigsAndWritePageValue: (show = true) ->
    # ボタン設置
    @reDraw(show)
    # コンフィグ作成
    @makeDesignConfig()
    # イベント記述
    EPVItem.writeDefaultToPageValue(@)
    # タイムライン作成
    Timeline.refreshAllTimeline()

    return true

  # 描画&コンフィグ作成
  # @param [boolean] show 要素作成後に描画を表示するか
  # @return [Boolean] 処理結果
  drawAndMakeConfigs: (show = true) ->
    # ボタン設置
    @reDraw(show)
    # コンフィグ作成
    @makeDesignConfig()

    return true

  # オプションメニューを開く
  showOptionMenu: ->
    sc = $('.sidebar-config')
    sc.css('display', 'none')
    $('.dc', sc).css('display', 'none')
    $('#design-config').css('display', '')
    $('#' + @getDesignConfigId()).css('display', '')

  # アイテムに対してドラッグ&リサイズイベントを設定する
  setupDragAndResizeEvents: ->
    self = @
    # コンテキストメニュー設定
    do ->
      menu = []
      contextSelector = null
      if ArrowItem? && self instanceof ArrowItem
        contextSelector = ".arrow"
      else if ButtonItem? && self instanceof ButtonItem
        contextSelector = ".css3button"
      menu.push({title: "Edit", cmd: "edit", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # オプションメニューを初期化
        initOptionMenu = (event) ->
          emt = $(event.target)
          obj = instanceMap[emt.attr('id')]
          if obj? && obj.setupOptionMenu?
            # 初期化関数を呼び出す
            obj.setupOptionMenu()
          if obj? && obj.showOptionMenu?
            # オプションメニュー表示処理
            obj.showOptionMenu()

        target = event.target
        # カラーピッカー値を初期化
        initColorPickerValue()
        # オプションメニューの値を初期化
        initOptionMenu(event)
        # オプションメニューを表示
        Sidebar.openConfigSidebar(target)
        # モードを変更
        WorktableCommon.changeMode(Constant.Mode.OPTION)
      })
      menu.push({title: "Delete", cmd: "delete", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        target = event.target
        targetId = $(target).attr('id')
        PageValue.removeInstancePageValue(targetId)
        target.remove()
        PageValue.adjustInstanceAndEventOnThisPage()
        Timeline.refreshAllTimeline()
        LocalStorage.saveValueForWorktable()
        OperationHistory.add()
      })
      WorktableCommon.setupContextMenu(self.getJQueryElement(), contextSelector, menu)

    # クリックイベント設定
    do ->
      self.getJQueryElement().mousedown( (e)->
        if e.which == 1 #左クリック
          e.stopPropagation()
          WorktableCommon.clearSelectedBorder()
          WorktableCommon.setSelectedBorder(@, "edit")
      )

    # JQueryUIのドラッグイベントとリサイズ設定
    do ->
      self.getJQueryElement().draggable({
        containment: scrollInside
        drag: (event, ui) ->
          if self.drag?
            self.drag()
        stop: (event, ui) ->
          if self.dragComplete?
            self.dragComplete()
      })
      self.getJQueryElement().resizable({
        containment: scrollInside
        resize: (event, ui) ->
          if self.resize?
            self.resize()
        stop: (event, ui) ->
          if self.resizeComplete?
            self.resizeComplete()
      })