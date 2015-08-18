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

  # 全てのアイテムを削除
  @removeAllItem = ->
    for k, v of Common.getCreatedItemObject()
      if v.getJQueryElement?
        v.getJQueryElement().remove()
    window.createdObject = {}
    window.instanceMap = {}

  # 全てのアイテムとイベントを削除
  @removeAllItemAndEvent = ->
    Sidebar.closeSidebar()
    # WebStorageを初期化する
    localStorage.clear()
    Common.clearAllEventChange( =>
      @removeAllItem()
      EventConfig.removeAllConfig()
      PageValue.removeAllItemAndEventPageValue()
      Timeline.removeAllTimeline()
    )

  # イベントPageValueから全てのアイテムを描画
  @drawAllItemFromEventPageValue: ->
    ePageValues = PageValue.getEventPageValueSortedListByNum()
    needItemIds = []
    for obj in ePageValues
      isCommonEvent = obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      if !isCommonEvent
        needItemIds.push(obj[EventPageValueBase.PageValueKey.ITEM_ID])

    @loadItemJs(needItemIds, ->
      for obj in ePageValues
        event = Common.getInstanceFromMap(obj)
        event.initWithEvent(obj)
        isCommonEvent = obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
        if !isCommonEvent
          event.reDraw()
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





