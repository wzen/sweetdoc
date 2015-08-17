class WorktableCommon

  # コンテキストメニュー初期化
  # @param [String] elementID HTML要素ID
  # @param [String] contextSelector
  # @param [Array] menu 表示メニュー
  @setupContextMenu = (element, contextSelector, menu) ->

    # オプションメニューを初期化
    initOptionMenu = (event) ->
      emt = $(event.target)
      obj = createdObject[emt.attr('id')]
      if obj? && obj.setupOptionMenu?
        # 初期化関数を呼び出す
        obj.setupOptionMenu()
      if obj? && obj.showOptionMenu?
        # オプションメニュー表示処理
        obj.showOptionMenu()

    element.contextmenu(
      {
        preventContextMenuForPopup: true
        preventSelect: true
        menu: menu
        select: (event, ui) ->
          $target = event.target
          switch ui.cmd
            when "delete"
              $target.remove()
              return
            when "cut"

            else
              return
          # カラーピッカー値を初期化
          initColorPickerValue()
          # オプションメニューの値を初期化
          initOptionMenu(event)
          # オプションメニューを表示
          Sidebar.openConfigSidebar($target)
          # モードを変更
          changeMode(Constant.Mode.OPTION)

        beforeOpen: (event, ui) ->
          # 選択メニューを最前面に表示
          ui.menu.zIndex( $(event.target).zIndex() + 1)
      }
    )
