# ワークテーブル用アイテム拡張モジュール
# 共通
WorkTableCommonExtend =
  # ドラッグ描画開始
  startDraw: ->
    return

  # ドラッグ描画
  # @param [Array] cood 座標
  draw: (cood) ->

  # 描画&コンフィグ作成
  # @param [Boolean] show 要素作成後に描画を表示するか
  drawAndMakeConfigsAndWritePageValue: (show = true) ->
    # ボタン設置
    @reDraw(show)
    # コンフィグ作成
    @makeDesignConfig()

    if @constructor.defaultMethodName()?
      # デフォルトイベントがある場合はイベント作成
      EPVItem.writeDefaultToPageValue(@)
      # タイムライン更新
      Timeline.refreshAllTimeline()

  # 描画&コンフィグ作成
  # @param [boolean] show 要素作成後に描画を表示するか
  # @return [Boolean] 処理結果
  drawAndMakeConfigs: (show = true) ->
    # ボタン設置
    @reDraw(show)
    # コンフィグ作成
    @makeDesignConfig()

  # オプションメニューを開く
  showOptionMenu: ->
    # 全てのサイドバーを非表示
    sc = $('.sidebar-config')
    sc.hide()
    $(".#{SidebarUI.DESIGN_ROOT_CLASSNAME}", sc).hide()
    $('#design-config').show()
    $('#' + @getDesignConfigId()).show()

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
        # アイテム編集
        Sidebar.openItemEditConfig(event.target)
      })
      menu.push({title: I18n.t('context_menu.copy'), cmd: "copy", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # コピー
        WorktableCommon.copyItem()
        WorktableCommon.setMainContainerContext()
      })
      menu.push({title: I18n.t('context_menu.cut'), cmd: "cut", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 切り取り
        WorktableCommon.cutItem()
        WorktableCommon.setMainContainerContext()
      })
      menu.push({title: I18n.t('context_menu.float'), cmd: "float", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 最前面移動
        objId = $(event.target).attr('id')
        WorktableCommon.floatItem(objId)
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        # 履歴保存
        OperationHistory.add()
      })
      menu.push({title: I18n.t('context_menu.rear'), cmd: "rear", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 最背面移動
        objId = $(event.target).attr('id')
        WorktableCommon.rearItem(objId)
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        # 履歴保存
        OperationHistory.add()
      })
      menu.push({title: I18n.t('context_menu.delete'), cmd: "delete", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # アイテム削除
        if window.confirm(I18n.t('message.dialog.delete_item'))
          WorktableCommon.removeItem(event.target)
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