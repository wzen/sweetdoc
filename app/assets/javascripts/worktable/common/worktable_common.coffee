class WorktableCommon

  # 選択枠を付ける
  # @param [Object] target 対象のオブジェクト
  # @param [String] selectedBorderType 選択タイプ
  @setSelectedBorder = (target, selectedBorderType = "edit") ->
    className = null
    if selectedBorderType == "edit"
      className = 'editSelected'
    else if selectedBorderType == "timeline"
      className = 'timelineSelected'

    # 選択枠を取る
    $(target).find(".#{className}").remove()
    # 設定
    $(target).append("<div class=#{className} />")

  # 全ての選択枠を外す
  @clearSelectedBorder = ->
    $('.editSelected, .timelineSelected').remove()

  # アイテムのJSファイル初期化関数名を取得
  # @param [Int] itemId アイテム種別
  @getInitFuncName = (itemId) ->
    itemName = Constant.ITEM_PATH_LIST[itemId]
    # TODO: ハイフンが途中にあるものはキャメルに変換
    return itemName + "Init"

  # モードチェンジ
  # @param [Mode] mode 画面モード
  @changeMode = (mode) ->
    if mode == Constant.Mode.DRAW
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
    else if mode == Constant.Mode.EDIT
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM))
    else if mode == Constant.Mode.OPTION
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
    window.mode = mode

  # 非表示をクリア
  @clearAllItemStyle = ->
    for k, v of Common.getCreatedItemObject()
      if v instanceof ItemBase
        v.clearAllEventStyle()

    # 選択枠を取る
    @clearSelectedBorder()
    # 全てのカラーピッカーを閉じる
    $('.colorPicker').ColorPickerHide()

  # 対象アイテムに対してフォーカスする(サイドバーオープン時)
  # @param [Object] target 対象アイテム
  # @param [String] selectedBorderType 選択枠タイプ
  @focusToTargetWhenSidebarOpen = (target, selectedBorderType = "edit") ->
    # 選択枠設定
    @setSelectedBorder(target, selectedBorderType)
    # 変更前のスライド値を保存
    PageValue.setInstancePageValue(PageValue.Key.CONFIG_OPENED_SCROLL, {top: scrollContents.scrollTop(), left: scrollContents.scrollLeft()}, true)
    LocalStorage.saveInstancePageValue()
    Common.focusToTarget(target)

  # キーイベント初期化
  @initKeyEvent = ->
    $(window).keydown( (e)->
      isMac = navigator.platform.toUpperCase().indexOf('MAC')>=0;
      if (isMac && e.metaKey) ||  (!isMac && e.ctrlKey)
        if e.keyCode == Constant.KeyboardKeyCode.Z
          e.preventDefault()
          if e.shiftKey
            # Shift + Ctrl + z → Redo
            OperationHistory.redo()
          else
            # Ctrl + z → Undo
            OperationHistory.undo()
    )

  # 画面の高さ設定
  @setupWindowHeight = ->
    borderWidth = 5
    timelineTopPadding = 5
    padding = borderWidth * 2 + timelineTopPadding
    $('#main').height($('#contents').height() - $("##{Constant.ElementAttribute.NAVBAR_ROOT}").height() - $('#timeline').height() - padding)
    $(window.drawingCanvas).attr('width', window.mainWrapper.width())
    $(window.drawingCanvas).attr('height', window.mainWrapper.height())
    # フォーカス処理のために保存
    window.scrollContentsSize = {width: scrollContents.width(), height: scrollContents.height()}

  # ウィンドウリサイズイベント
  @initResize = ->
    resizeTimer = false;
    $(window).resize( ->
      if resizeTimer != false
        clearTimeout(resizeTimer)
      resizeTimer = setTimeout( ->
        WorktableCommon.setupWindowHeight()
        clearTimeout(resizeTimer)
      , 200)
    )

  # 画面のアイテムをクリア
  @clearWorkTable = ->
    for k, v of Common.getCreatedItemObject()
      v.getJQueryElement().remove()

  ### デバッグ ###
  @runDebug = ->

  # Mainコンテナ初期化
  @initMainContainer = ->
    # 定数 & レイアウト & イベント系変数の初期化
    CommonVar.worktableCommonVar()
    @setupWindowHeight()
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM))
    # スクロールサイズ
    scrollInside.width(window.scrollViewSize)
    scrollInside.height(window.scrollViewSize)
    # スクロール位置初期化
    scrollContents.scrollLeft(scrollInside.width() * 0.5)
    scrollContents.scrollTop(scrollInside.height() * 0.5)
    # ドロップダウン
    $('.dropdown-toggle').dropdown()
    # ナビバー
    Navbar.initWorktableNavbar()
    # キーイベント
    @initKeyEvent()
    # ドラッグ描画イベント
    Handwrite.initHandwrite()
    # コンテキストメニュー
    menu = [{title: "Default", cmd: "default", uiIcon: "ui-icon-scissors"}]
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
    WorktableCommon.setupContextMenu($('#main'), "#pages .#{page} .main-wrapper:first", menu)
    $('#main').on("mousedown", =>
      @clearAllItemStyle()
    )
    # 共通設定
    Setting.initConfig()

  # Mainコンテナ再作成
  @recreateMainContainer: ->
    # アイテムを全消去
    @removeAllItemAndEvent()
    # ページを全消去
    $('#pages .section').remove()
    # Mainコンテナ作成
    Common.createdMainContainerIfNeeded(PageValue.getPageNum())
    # コンテナ初期化
    WorktableCommon.initMainContainer()
    # キャッシュ削除
    LocalStorage.clearWorktableWithoutSetting()
    # タイムライン更新
    Timeline.refreshAllTimeline()
    # ページ数初期化
    PageValue.setPageNum(1)
    # 履歴に画面初期時を状態を保存
    OperationHistory.add(true)
    # ページ総数更新
    PageValue.updatePageCount()
    # ページング
    Paging.initPaging()

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

  # 全てのアイテムとイベントを削除
  @removeAllItemAndEvent = ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    LocalStorage.clearWorktableWithoutSetting()
    Common.clearAllEventChange( =>
      Common.removeAllItem()
      EventConfig.removeAllConfig()
      PageValue.removeAllItemAndEventPageValue()
      Timeline.refreshAllTimeline()
    )

  # ページ内の全てのアイテムとイベントを削除
  @removeAllItemAndEventOnThisPage = ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    LocalStorage.clearWorktableWithoutGeneralAndSetting()
    Common.clearAllEventChange( =>
      Common.removeAllItem()
      EventConfig.removeAllConfig()
      PageValue.removeAllItemAndEventPageValueOnThisPage()
      Timeline.refreshAllTimeline()
    )

  # イベントPageValueから全てのアイテムを描画
  @drawAllItemFromEventPageValue: (callback = null, pageNum = PageValue.getPageNum()) ->
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum))
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
        LocalStorage.saveValueForWorktable()

      # タイムライン更新
      Timeline.refreshAllTimeline()

      # コールバック
      if callback?
        callback()
    )

  # JSファイルをサーバから読み込む
  # @param [Int] itemId アイテム種別
  # @param [Function] callback コールバック関数
  @loadItemJs = (itemIds, callback = null) ->
    if jQuery.type(itemIds) != "array"
      itemIds = [itemIds]

    # 読み込むIDがない場合はコールバック実行して終了
    if itemIds.length == 0
      if callback?
        callback()
      return

    callbackCount = 0
    needReadItemIds = []
    for itemId in itemIds
      if itemId?
        itemInitFuncName = WorktableCommon.getInitFuncName(itemId)
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

            WorktableCommon.availJs(WorktableCommon.getInitFuncName(d.item_id), d.js_src, option, ->
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
