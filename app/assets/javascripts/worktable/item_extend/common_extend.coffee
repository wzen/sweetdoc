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
      menu = [{title: "Delete", cmd: "delete", uiIcon: "ui-icon-scissors"}]
      contextSelector = null
      if ArrowItem? && self instanceof ArrowItem
        menu.push({title: "ArrowItem", cmd: "cut", uiIcon: "ui-icon-scissors"})
        contextSelector = ".arrow"
      else if ButtonItem? && self instanceof ButtonItem
        menu.push({title: "ButtonItem", cmd: "cut", uiIcon: "ui-icon-scissors"})
        contextSelector = ".css3button"
      WorktableCommon.setupContextMenu(self.getJQueryElement(), contextSelector, menu)

    # クリックイベント設定
    do ->
      self.getJQueryElement().mousedown( (e)->
        if e.which == 1 #左クリック
          e.stopPropagation()
          clearSelectedBorder()
          setSelectedBorder(@, "edit")
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


