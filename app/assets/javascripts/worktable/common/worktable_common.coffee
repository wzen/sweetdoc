class WorktableCommon

  # コンテキストメニュー初期化
  # @param [String] elementID HTML要素ID
  # @param [String] contextSelector
  # @param [Array] menu 表示メニュー
  @setupContextMenu = (element, contextSelector, menu) ->
    element.contextmenu(
      {
        preventContextMenuForPopup: true
        preventSelect: true
        menu: menu
        select: (event, ui) ->
          for value in menu
            if value.cmd == ui.cmd
              value.func(event, ui)
        beforeOpen: (event, ui) ->
          # 選択メニューを最前面に表示
          ui.menu.zIndex( $(event.target).zIndex() + 1)
      }
    )

  # 全てのアイテムを削除
  @removeAllItem = ->
    for k, v of Common.getCreatedItemObject()
      if v.getJQueryElement?
        v.getJQueryElement().remove()
    window.instanceMap = {}

  # 全てのアイテムとイベントを削除
  @removeAllItemAndEvent = ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    lstorage = localStorage
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_EVENT_PAGEVALUES)
    Common.clearAllEventChange( =>
      @removeAllItem()
      EventConfig.removeAllConfig()
      PageValue.removeAllItemAndEventPageValue()
      Timeline.refreshAllTimeline()
    )

  # ページ内の全てのアイテムとイベントを削除
  @removeAllItemAndEventOnThisPage = ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    lstorage = localStorage
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_EVENT_PAGEVALUES)
    Common.clearAllEventChange( =>
      @removeAllItem()
      EventConfig.removeAllConfig()
      PageValue.removeAllItemAndEventPageValueOnThisPage()
      Timeline.refreshAllTimeline()
    )

  # イベントPageValueから全てのアイテムを描画
  @drawAllItemFromEventPageValue: ->
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix())
    needItemIds = []
    for k, obj of pageValues
      if obj.value.itemId?
        if $.inArray(obj.value.itemId, needItemIds) < 0
          needItemIds.push(obj.value.itemId)

    @loadItemJs(needItemIds, ->
      for k, obj of pageValues
        isCommon = null
        id = obj.value.id
        classMapId = null
        if obj.value.itemId?
          isCommon = false
          classMapId = obj.value.itemId
        else
          isCommon = true
          classMapId = obj.value.eventId
        event = Common.getInstanceFromMap(isCommon, id, classMapId)
        if event instanceof ItemBase
          event.setMiniumObject(obj.value)
          if event instanceof CssItemBase && event.makeCss?
            event.makeCss()
          if event.drawAndMakeConfigs?
            event.drawAndMakeConfigs()
        event.setItemAllPropToPageValue()

      # タイムライン更新
      Timeline.refreshAllTimeline()
    )

  # JSファイルをサーバから読み込む
  # @param [Int] itemId アイテム種別
  # @param [Function] callback コールバック関数
  @loadItemJs = (itemIds, callback = null) ->
    if jQuery.type(itemIds) != "array"
      itemIds = [itemIds]

    callbackCount = 0
    needReadItemIds = []
    for itemId in itemIds
      if itemId?
        itemInitFuncName = getInitFuncName(itemId)
        if window.itemInitFuncList[itemInitFuncName]?
          # 読み込み済みなアイテムIDの場合
          window.itemInitFuncList[itemInitFuncName]()
          callbackCount += 1
          if callbackCount >= itemIds.length
            if callback?
              # 既に全て読み込まれている場合はコールバック実行して終了
              callback()
            return
        else
          # Ajaxでjs読み込みが必要なアイテムID
          needReadItemIds.push(itemId)
      else
        callbackCount += 1

    # js読み込み
    $.ajax(
      {
        url: "/item_js/index"
        type: "POST"
        dataType: "json"
        data: {
          itemIds: needReadItemIds
        }
        success: (data)->
          callbackCount = 0
          for d in data
            if d.css_info?
              option = {isWorkTable: true, css_temp: d.css_info}

            WorktableCommon.availJs(getInitFuncName(d.item_id), d.js_src, option, ->
              callbackCount += 1
              if callback? && callbackCount >= data.length
                callback()
            )
            PageValue.addItemInfo(d.item_id, d.te_actions)
            EventConfig.addEventConfigContents(d.item_id, d.te_actions, d.te_values)

        error: (data) ->
      }
    )

  # JSファイルを設定
  # @param [String] initName アイテム初期化関数名
  # @param [String] jsSrc jsファイル名
  # @param [Function] callback 設定後のコールバック
  @availJs = (initName, jsSrc, option = {}, callback = null) ->
    s = document.createElement('script');
    s.type = 'text/javascript';
    # TODO: 認証コードの比較
    s.src = jsSrc;
    firstScript = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(s, firstScript);
    t = setInterval( ->
      if window.itemInitFuncList[initName]?
        clearInterval(t)
        window.itemInitFuncList[initName](option)
        if callback?
          callback()
    , '500')
