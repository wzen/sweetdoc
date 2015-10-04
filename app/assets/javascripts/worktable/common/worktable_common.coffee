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

    # 選択アイテムID保存
    if selectedBorderType == "edit"
      window.selectedObjId = $(target).attr('id')

  # 全ての選択枠を外す
  @clearSelectedBorder = ->
    $('.editSelected, .timelineSelected').remove()
    # 選択アイテムID解除
    window.selectedObjId = null

  # 選択アイテムの複製処理 (Ctrl + c)
  # @param [Integer] objId コピーするアイテムのオブジェクトID
  # @param [Boolean] isCopyOperation コピー = true, 切り取り = false
  @copyItem = (objId = window.selectedObjId, isCopyOperation = true) ->
    if objId?
      pageValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(objId))
      if pageValue?
        instance = Common.getInstanceFromMap(false, objId, pageValue.itemId)
        if instance instanceof ItemBase
          window.copiedInstance = Common.makeClone(instance.getMinimumObject())
          if isCopyOperation
            window.copiedInstance.isCopy = true

  # 選択アイテムの切り取り (Ctrl + x)
  # @param [Integer] objId コピーするアイテムのオブジェクトID
  @cutItem = (objId = window.selectedObjId) ->
    @copyItem(objId, false)
    @removeItem($("##{objId}"))

  # アイテムの貼り付け (Ctrl + v)
  @pasteItem = ->
    if window.copiedInstance?
      instance = Common.newInstance(false, window.copiedInstance.itemId)
      obj = Common.makeClone(window.copiedInstance)
      obj.id = instance.id
      instance.setMiniumObject(obj)
      if obj.isCopy? && obj.isCopy
        instance.name = instance.name + ' (Copy)'
      # 画面中央に貼り付け
      instance.itemSize.x = parseInt(window.scrollContents.scrollLeft() + (window.scrollContents.width() - instance.itemSize.w) / 2.0)
      instance.itemSize.y = parseInt(window.scrollContents.scrollTop() + (window.scrollContents.height() - instance.itemSize.h) / 2.0)
      if instance instanceof CssItemBase
        # CSSを作成する ※CSSのIDをコピー先に変更
        instance.changeCssId(window.copiedInstance.id)
        instance.makeCss()
      if instance.drawAndMakeConfigs?
        instance.drawAndMakeConfigs()
      instance.setItemAllPropToPageValue()
      LocalStorage.saveAllPageValues()

  # アイテムを最前面に移動
  # @param [Integer] objId 対象オブジェクトID
  @floatItem = (objId) ->
    drawedItems = window.scrollInside.find('.item')
    sorted = []
    drawedItems.each( -> sorted.push($(@)))
    i = 0
    while i <= drawedItems.length - 2
      j = i + 1
      while j <= drawedItems.length - 1
        a = parseInt(sorted[i].css('z-index'))
        b = parseInt(sorted[j].css('z-index'))
        if a > b
          w = sorted[i]
          sorted[i] = sorted[j]
          sorted[j] = w
        j += 1
      i += 1

    targetZIndex = parseInt($("##{objId}").css('z-index'))
    i = parseInt(window.scrollInside.css('z-index'))
    for item in sorted
      itemId = $(item).attr('id')
      if objId != itemId
        item.css('z-index', i)
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i))
        i += 1
    maxZIndex = i
    $("##{objId}").css('z-index', maxZIndex)
    PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(maxZIndex))

  # アイテムを再背面に移動
  # @param [Integer] objId 対象オブジェクトID
  @rearItem = (objId) ->
    drawedItems = window.scrollInside.find('.item')
    sorted = []
    drawedItems.each( -> sorted.push($(@)))
    i = 0
    while i <= drawedItems.length - 2
      j = i + 1
      while j <= drawedItems.length - 1
        a = parseInt(sorted[i].css('z-index'))
        b = parseInt(sorted[j].css('z-index'))
        if a > b
          w = sorted[i]
          sorted[i] = sorted[j]
          sorted[j] = w
        j += 1
      i += 1

    targetZIndex = parseInt($("##{objId}").css('z-index'))
    i = parseInt(window.scrollInside.css('z-index')) + 1
    for item in sorted
      itemId = $(item).attr('id')
      if objId != itemId
        item.css('z-index', i)
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i))
        i += 1
    minZIndex = parseInt(window.scrollInside.css('z-index'))
    $("##{objId}").css('z-index', minZIndex)
    PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(minZIndex))

  # モードチェンジ
  # @param [Mode] mode 画面モード
  @changeMode = (mode) ->
    if mode == Constant.Mode.DRAW
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
      window.scrollContents.find('.item.draggable').removeClass('edit_mode')
      window.scrollInside.removeClass('edit_mode')
    else if mode == Constant.Mode.EDIT
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM))
      window.scrollContents.find('.item.draggable').addClass('edit_mode')
      window.scrollInside.addClass('edit_mode')
      # ヘッダーをEditに
      Navbar.setModeEdit()
    else if mode == Constant.Mode.OPTION
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
      window.scrollContents.find('.item.draggable').removeClass('edit_mode')
      window.scrollInside.removeClass('edit_mode')

    # 変更前のモードを保存
    window.beforeMode = window.mode
    window.mode = mode

  # モードを一つ前に戻す
  @putbackMode = ->
    if window.beforeMode?
      @changeMode(window.beforeMode)
      window.beforeMode = null

  # アイテム描画が変更されている場合にインスタンス全アイテム再描画
  # @param [Integer] pn ページ番号
  @reDrawAllInstanceItemIfChanging = (pn = PageValue.getPageNum()) ->
    if window.runningPreview
      # イベント停止
      @stopAllEventPreview( ->
        instances = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pn))
        for k, obj of instances
          isCommon = null
          id = obj.value.id
          classMapId = null
          if obj.value.itemId?
            item = Common.getInstanceFromMap(false, id, obj.value.itemId)
            if item? && item instanceof ItemBase
              item.reDraw()
      )

  # 非表示をクリア
  @clearAllItemStyle = ->
    for k, v of Common.getCreatedItemInstances()
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
    Common.focusToTarget(target)

  # キーイベント初期化
  @initKeyEvent = ->
    $(window).off('keydown')
    $(window).on('keydown', (e)->
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
        else if e.keyCode == Constant.KeyboardKeyCode.C
          e.preventDefault()
          # Ctrl + c -> Copy
          WorktableCommon.copyItem()
          WorktableCommon.setMainContainerContext()
        else if e.keyCode == Constant.KeyboardKeyCode.X
          e.preventDefault()
          # Ctrl + x -> Cut
          WorktableCommon.cutItem()
          WorktableCommon.setMainContainerContext()
        else if e.keyCode == Constant.KeyboardKeyCode.V
          e.preventDefault()
          # 貼り付け
          WorktableCommon.pasteItem()
          # キャッシュ保存
          LocalStorage.saveAllPageValues()
          # 履歴保存
          OperationHistory.add()
    )

  # Mainビューの高さ更新
  @updateMainViewSize = ->
    borderWidth = 5
    timelineTopPadding = 5
    padding = borderWidth * 2 + timelineTopPadding
    $('#main').height($('#contents').height() - $("##{Navbar.NAVBAR_ROOT}").height() - $('#timeline').height() - padding)
    window.scrollContentsSize = {width: window.scrollContents.width(), height: window.scrollContents.height()}
    $('#sidebar').height($('#contents').height() - $("##{Navbar.NAVBAR_ROOT}").height() - borderWidth * 2)

  # 画面サイズ設定
  @resizeMainContainerEvent = ->
    @updateMainViewSize()
    Common.updateCanvasSize()

  # ウィンドウリサイズイベント
  @resizeEvent = ->
    WorktableCommon.resizeMainContainerEvent()

  # アイテムを削除
  @removeItem = (itemElement) ->
    targetId = $(itemElement).attr('id')
    PageValue.removeInstancePageValue(targetId)
    PageValue.removeEventPageValueSync(targetId)
    itemElement.remove()
    PageValue.adjustInstanceAndEventOnPage()
    Timeline.refreshAllTimeline()
    LocalStorage.saveAllPageValues()
    OperationHistory.add()

  # 画面の全アイテムを削除
  @removeAllItemOnWorkTable = ->
    for k, v of Common.getCreatedItemInstances()
      v.getJQueryElement().remove()

  ### デバッグ ###
  @runDebug = ->

  # Mainコンテナ初期化
  @initMainContainer = ->
    # 定数 & レイアウト & イベント系変数の初期化
    CommonVar.worktableCommonVar()
    $(window.drawingCanvas).attr('width', window.mainWrapper.width())
    $(window.drawingCanvas).attr('height', window.mainWrapper.height())
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
    # スクロールサイズ
    window.scrollInside.width(window.scrollViewSize)
    window.scrollInside.height(window.scrollViewSize)
    window.scrollInside.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1))
    # スクロール位置初期化
    Common.updateScrollContentsPosition(window.scrollInside.width() * 0.5, window.scrollInside.height() * 0.5)
    # ドロップダウン
    $('.dropdown-toggle').dropdown()
    # ナビバー
    Navbar.initWorktableNavbar()
    # キーイベント
    @initKeyEvent()
    # ドラッグ描画イベント
    Handwrite.initHandwrite()
    # コンテキストメニュー
    @setMainContainerContext()
    $('#project_wrapper').on("mousedown", =>
      @clearAllItemStyle()
    )
    # 共通設定
    Setting.initConfig()

  # Mainコンテナのコンテキストメニューを設定
  @setMainContainerContext: ->
    # コンテキストメニュー
    menu = []
    if window.copiedInstance?
      menu.push({title: I18n.t('context_menu.paste'), cmd: "paste", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 貼り付け
        WorktableCommon.pasteItem()
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        # 履歴保存
        OperationHistory.add()
      })
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
    WorktableCommon.setupContextMenu($("#pages .#{page} .scroll_inside:first"), "#pages .#{page} .main-wrapper:first", menu)

  # Mainコンテナ再作成
  @recreateMainContainer: ->
    # アイテムを全消去
    @removeAllItemAndEvent()
    # ページを全消去
    $('#pages .section').remove()
    # 環境をリセット
    Common.resetEnvironment()
    # 変数初期化
    CommonVar.initVarWhenLoadedView()
    CommonVar.initCommonVar()
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
    # フォーク総数更新
    PageValue.updateForkCount()
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
          t = $(event.target)
          # 選択メニューを最前面に表示
          ui.menu.zIndex( $(event.target).zIndex() + 1)
          if window.mode == Constant.Mode.EDIT && $(t).hasClass('item')
            # 選択状態にする
            WorktableCommon.setSelectedBorder(t)
      }
    )

  # 全てのアイテムとイベントを削除
  @removeAllItemAndEvent = ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    LocalStorage.clearWorktableWithoutSetting()
    Common.clearAllEventAction( =>
      Common.removeAllItem()
      EventConfig.removeAllConfig()
      PageValue.removeAllGeneralAndInstanceAndEventPageValue()
      Timeline.refreshAllTimeline()
    )

  # ページ内の全てのアイテムとイベントを削除
  @removeAllItemAndEventOnThisPage = ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    LocalStorage.clearWorktableWithoutGeneralAndSetting()
    Common.clearAllEventAction( =>
      Common.removeAllItem()
      EventConfig.removeAllConfig()
      PageValue.removeAllInstanceAndEventPageValueOnPage()
      Timeline.refreshAllTimeline()
    )

  # イベントPageValueから全てのアイテムを描画
  # @param [Function] callback コールバック
  # @param [Integer] pageNum 描画するPageValueのページ番号
  @drawAllItemFromInstancePageValue: (callback = null, pageNum = PageValue.getPageNum()) ->
    Common.loadJsFromInstancePageValue( ->
      pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum))
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
          if event instanceof CssItemBase
            event.makeCss()
          if event.drawAndMakeConfigs?
            event.drawAndMakeConfigs()
        event.setItemAllPropToPageValue()

      # コールバック
      if callback?
        callback()
    , pageNum)

  # 全イベントのプレビューを停止
  # @param [Function] callback コールバック
  @stopAllEventPreview: (callback = null) ->
    if !window.runningPreview
      if callback?
        callback()
        return

    count = 0
    length = Object.keys(window.instanceMap).length
    for k, v of window.instanceMap
      if v.stopPreview?
        v.stopPreview( ->
          count += 1
          if length <= count && callback?
            window.runningPreview = false
            callback()
            return
        )
      else
        count += 1
        if length <= count && callback?
          window.runningPreview = false
          callback()
          return
