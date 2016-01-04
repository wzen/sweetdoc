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
        instance = window.instanceMap[objId]
        if instance instanceof ItemBase
          window.copiedInstance = Common.makeClone(instance.getMinimumObject())
          if isCopyOperation
            window.copiedInstance.isCopy = true

  # 選択アイテムの切り取り (Ctrl + x)
  # @param [Integer] objId コピーするアイテムのオブジェクトID
  @cutItem = (objId = window.selectedObjId) ->
    @copyItem(objId, false)
    @removeSingleItem($("##{objId}"))

  # アイテムの貼り付け (Ctrl + v)
  @pasteItem = ->
    if window.copiedInstance?
      instance = new (Common.getClassFromMap(window.copiedInstance.classDistToken))()
      window.instanceMap[instance.id] = instance
      obj = Common.makeClone(window.copiedInstance)
      obj.id = instance.id
      instance.setMiniumObject(obj)
      if obj.isCopy? && obj.isCopy
        instance.name = instance.name + ' (Copy)'
      # 画面中央に貼り付け
      instance.itemSize.x = parseInt(window.scrollContents.scrollLeft() + (window.scrollContents.width() - instance.itemSize.w) / 2.0)
      instance.itemSize.y = parseInt(window.scrollContents.scrollTop() + (window.scrollContents.height() - instance.itemSize.h) / 2.0)
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
    i = parseInt(window.scrollInsideWrapper.css('z-index'))
    for item in sorted
      itemObjId = $(item).attr('id')
      if objId != itemObjId
        item.css('z-index', i)
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemObjId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i))
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
    i = parseInt(window.scrollInsideWrapper.css('z-index')) + 1
    for item in sorted
      itemObjId = $(item).attr('id')
      if objId != itemObjId
        item.css('z-index', i)
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemObjId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i))
        i += 1
    minZIndex = parseInt(window.scrollInsideWrapper.css('z-index'))
    $("##{objId}").css('z-index', minZIndex)
    PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(minZIndex))

  # モードチェンジ
  # @param [Mode] afterMode 変更後画面モード
  @changeMode = (afterMode, pn = PageValue.getPageNum()) ->

    # 画面Zindex変更
    if afterMode == Constant.Mode.NOT_SELECT
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT, pn))
      window.scrollInsideWrapper.removeClass('edit_mode')
    else if afterMode == Constant.Mode.DRAW
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT, pn))
      window.scrollContents.find('.item.draggable').removeClass('edit_mode')
      window.scrollInsideWrapper.removeClass('edit_mode')
    else if afterMode == Constant.Mode.EDIT
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM, pn))
      window.scrollContents.find('.item.draggable').addClass('edit_mode')
      window.scrollInsideWrapper.addClass('edit_mode')
      # ヘッダーをEditに
      Navbar.setModeEdit()
    else if afterMode == Constant.Mode.OPTION
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT, pn))
      window.scrollContents.find('.item.draggable').removeClass('edit_mode')
      window.scrollInsideWrapper.removeClass('edit_mode')

    @setModeClassToMainDiv(afterMode)

    if window.mode != afterMode
      # 変更前のモードを保存
      window.beforeMode = window.mode
      window.mode = afterMode

      # アイテムのイベント呼び出し
      items = Common.itemInstancesInPage()
      for item in items
        if item.changeMode?
          item.changeMode(afterMode)

  @changeEventPointingMode = (afterMode) ->
    if afterMode == Constant.EventInputPointingMode.NOT_SELECT
      # 全入力を有効
      Timeline.disabledOperation(false)
      Sidebar.disabledOperation(false)
      Navbar.disabledOperation(false)
      # 画面上のポイントアイテムを削除
      $(window.scrollInside).find('.item').each( ->
        sp = $(@).attr('id').split('_')
        if sp[0] == ItemBase.ID_PREFIX && sp[1] == EventDragPointing.PrivateClass.NAME_PREFIX
          $(@).remove()
      )
    else if afterMode == Constant.EventInputPointingMode.DRAW || afterMode == Constant.EventInputPointingMode.ITEM_TOUCH
      # 全入力を無効に
      Timeline.disabledOperation(true)
      Sidebar.disabledOperation(true)
      Navbar.disabledOperation(true)

    @setModeClassToMainDiv(afterMode)
    window.eventPointingMode = afterMode

  # ID=MainのDivにクラス名を設定
  @setModeClassToMainDiv = (mode) ->
    classes = [
      'draw_mode'
      'draw_pointing'
      'click_pointing'
    ]
    $('#main').removeClass(classes.join(' '))
    if mode == Constant.Mode.DRAW
      $('#main').addClass('draw_mode')
    else if mode == Constant.EventInputPointingMode.DRAW
      $('#main').addClass('draw_pointing')
    else if mode == Constant.EventInputPointingMode.ITEM_TOUCH
      $('#main').addClass('click_pointing')

  # モードを一つ前に戻す
  @putbackMode = ->
    if window.beforeMode?
      @changeMode(window.beforeMode)
      window.beforeMode = null

  # アイテム描画が変更されている場合にインスタンスから全アイテム再描画
  # @param [Integer] pn ページ番号
  @refreshAllItemsFromInstancePageValueIfChanging = (pn = PageValue.getPageNum(), callback = null) ->
    # イベント停止
    @stopAllEventPreview( (noRunningPreview) ->
      if window.worktableItemsChangedState || !noRunningPreview
        # アイテムの状態に変更がある場合は再描画処理
        items = Common.instancesInPage(pn)
        callbackCount = 0
        for item in items
          item.refreshFromInstancePageValue(true, ->
            callbackCount += 1
            if callbackCount >= items.length
              # アイテム状態変更フラグOFF
              window.worktableItemsChangedState = false
              if callback?
                callback()
          )

        # アイテムフォーカスしてる場合があるので表示位置を戻す
        Common.updateWorktableScrollContentsFromPageValue()
      else
        if callback?
          callback()
    )

  # 非表示をクリア
  @clearAllItemStyle = ->
    for k, v of Common.allItemInstances()
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
    $('#main').height($('#contents').height() - $("##{Navbar.NAVBAR_ROOT}").height() - $('#timeline').height() - timelineTopPadding - (borderWidth * 2))
    window.scrollContentsSize = {width: window.scrollContents.width(), height: window.scrollContents.height()}
    $('#sidebar').height($('#contents').height() - $("##{Navbar.NAVBAR_ROOT}").height() - (borderWidth * 2))

  # 画面サイズ設定
  @resizeMainContainerEvent = ->
    @updateMainViewSize()
    Common.updateCanvasSize()
    Common.updateScrollContentsFromScreenEventVar()

  # ウィンドウリサイズイベント
  @resizeEvent = ->
    WorktableCommon.resizeMainContainerEvent()

  # アイテムを削除
  @removeSingleItem = (itemElement) ->
    targetId = $(itemElement).attr('id')
    PageValue.removeInstancePageValue(targetId)
    PageValue.removeEventPageValueSync(targetId)
    if window.instanceMap[targetId]?
      window.instanceMap[targetId].removeItemElement()
    PageValue.adjustInstanceAndEventOnPage()
    Timeline.refreshAllTimeline()
    LocalStorage.saveAllPageValues()
    OperationHistory.add()

  ### デバッグ ###
  @runDebug = ->

  # Mainコンテナ初期化
  @initMainContainer = ->
    # 定数 & レイアウト & イベント系変数の初期化
    CommonVar.worktableCommonVar()
    Common.updateCanvasSize()
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
    # スクロールサイズ
    window.scrollInsideWrapper.width(window.scrollViewSize)
    window.scrollInsideWrapper.height(window.scrollViewSize)
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1))
    # スクロールイベント設定
    window.scrollContents.off('scroll').on('scroll', (e) ->
      e.preventDefault()
      top = window.scrollContents.scrollTop()
      left = window.scrollContents.scrollLeft()
      if jQuery(":hover")[jQuery(':hover').length - 1] == window.scrollInside.get(0)
        # 手動スクロールした場合のみメッセージ & 画面位置更新
        FloatView.show(FloatView.scrollMessage(top, left), FloatView.Type.DISPLAY_POSITION)
        if window.scrollContentsScrollTimer?
          clearTimeout(window.scrollContentsScrollTimer)
        window.scrollContentsScrollTimer = setTimeout( ->
          setTimeout( ->
            FloatView.hide()
            PageValue.setWorktableDisplayPosition(top, left)
            LocalStorage.saveAllPageValues()
            window.scrollContentsScrollTimer = null
          , 0)
        , 500)
    )
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
    $('#project_contents').off("mousedown")
    $('#project_contents').on("mousedown", =>
      @clearAllItemStyle()
    )
    # 環境設定
    Common.applyEnvironmentFromPagevalue()
    # Mainビュー高さ設定
    @updateMainViewSize()
    # 共通設定
    WorktableSetting.initConfig()

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

  # ワークテーブル初期化
  @resetWorktable: ->
    # アイテムを全消去
    @removeAllItemAndEvent( =>
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
    )

  # コンテキストメニュー初期化
  # @param [String] elementID HTML要素ID
  # @param [String] contextSelector
  # @param [Array] menu 表示メニュー
  @setupContextMenu = (element, contextSelector, menu) ->
    Common.setupContextMenu(element, contextSelector, {
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
    })

  # 全てのアイテムとイベントを削除
  @removeAllItemAndEvent = (callback = null) ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    LocalStorage.clearWorktableWithoutSetting()
    Common.removeAllItem()
    EventConfig.removeAllConfig()
    PageValue.removeAllGeneralAndInstanceAndEventPageValue()
    Timeline.refreshAllTimeline()
    if callback?
      callback()

  # ページ内の全てのアイテムとイベントを削除
  @removeAllItemAndEventOnThisPage = (callback = null) ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    LocalStorage.clearWorktableWithoutGeneralAndSetting()
    Common.removeAllItem(PageValue.getPageNum())
    EventConfig.removeAllConfig()
    PageValue.removeAllInstanceAndEventPageValueOnPage()
    Timeline.refreshAllTimeline()
    if callback?
      callback()

  # 共通イベントインスタンス作成
  @createCommonEventInstancesIfNeeded = (pn = PageValue.getPageNum()) ->
    for clsToken, cls of window.classMap
      if cls.prototype instanceof CommonEvent
        instance = new (Common.getClassFromMap(cls.CLASS_DIST_TOKEN))()
        if !window.instanceMap[instance.id]?
          Common.setInstanceFromMap(instance.id, instance.constructor.CLASS_DIST_TOKEN)
          instance.setItemAllPropToPageValue()

  # PageValueから全てのインスタンスを作成
  # @param [Function] callback コールバック
  # @param [Integer] pageNum 描画するPageValueのページ番号
  @createAllInstanceAndDrawFromInstancePageValue: (callback = null, pageNum = PageValue.getPageNum()) ->
    Common.loadJsFromInstancePageValue( ->
      # インスタンス取得 & PageValueの値で初期化
      items = Common.itemInstancesInPage(pageNum, true, true)
      for item in items
        if item.drawAndMakeConfigs?
          item.drawAndMakeConfigs()

      # コールバック
      if callback?
        callback()
    , pageNum)

  # イベント進行ルートを取得
  # @param [Integer] finishTeNum 終了イベント番号
  # @param [Integer] finishFn 終了フォーク番号
  # @return [Array] EventPageValue配列 無い場合は空配列
  @eventProgressRoute = (finishTeNum, finishFn = PageValue.getForkNum()) ->
    finishTeNum = parseInt(finishTeNum)
    finishFn = parseInt(finishFn)
    _trace = (forkNum) ->
      routes = []
      tes = PageValue.getEventPageValueSortedListByNum(forkNum)
      if tes.length == 0
        return {result: true, routes: []}
      for te, idx in tes
        changeForkNum = te[EventPageValueBase.PageValueKey.CHANGE_FORKNUM]
        if changeForkNum? && changeForkNum != forkNum
          ret = _trace.call(@, changeForkNum)
          result = ret.result
          if result
            routes.push(te)
            $.merge(routes, ret.routes)
            return {result: true, routes: routes}
        else
          routes.push(te)
          if idx + 1 == finishTeNum && forkNum == finishFn
            # 発見
            return {result: true, routes: routes}

      if tes.length + 1 == finishTeNum && forkNum == finishFn
        return {result: true, routes: routes}
      else
        return {result: false, routes: []}

    return _trace.call(@, PageValue.Key.EF_MASTER_FORKNUM)

  # イベント進行ルートが繋がっているか
  @isConnectedEventProgressRoute = (finishTeNum, finishFn = PageValue.getForkNum()) ->
    ret = @eventProgressRoute(finishTeNum, finishFn)
    return ret.result

  # 指定イベント以前をイベント適用後の状態に変更
  @updatePrevEventsToAfter = (teNum, keepDispMag = false, fromBlankEventConfig = false, callback = null) ->
    _updatePrevEventsToAfterAndRunPreview.call(@, teNum, keepDispMag, fromBlankEventConfig, false, callback)

  # プレビュー実行
  # @param [Integer] te_num 実行するイベント番号
  @runPreview = (teNum, keepDispMag = false, callback = null) ->
    _updatePrevEventsToAfterAndRunPreview.call(@, teNum, keepDispMag, false, true, callback)

  _updatePrevEventsToAfterAndRunPreview = (teNum, keepDispMag, fromBlankEventConfig, doRunPreview, callback = null) ->
    if doRunPreview && window.previewRunning? && window.previewRunning
      # プレビュー二重実行は無視
      return
    epr = @eventProgressRoute(teNum)
    if !epr.result
      # 設定が繋がっていない場合は無視
      return
    tes = epr.routes

    # 状態変更フラグON
    window.worktableItemsChangedState = true
    # 全ての状態をイベント適応前にする
    Common.updateAllEventsToBefore( =>
      # 操作履歴削除
      PageValue.removeAllFootprint()
      teNum = parseInt(teNum)
      focusTargetItem = null
      for te, idx in tes
        item = window.instanceMap[te.id]
        if item?
          item.initEvent(te, keepDispMag)
          if item instanceof ItemBase && te[EventPageValueBase.PageValueKey.DO_FOCUS]
            focusTargetItem = item
          if idx < tes.length - 1 || fromBlankEventConfig
            item.willChapter()
            # イベント後の状態に変更
            item.updateEventAfter()
            item.didChapter()
          else if doRunPreview
            if focusTargetItem?
              # アイテムにフォーカス
              Common.focusToTarget(focusTargetItem.getJQueryElement(), null, true, true)
            window.previewRunning = true
            # プレビュー実行
            item.preview( =>
              # プレビューの実行回数超過
              window.previewRunning = false
              # ボタン変更「StopPreview」->「Preview」
              EventConfig.switchPreviewButton(true)
              # アイテム再描画
              @refreshAllItemsFromInstancePageValueIfChanging()
            )
            # 状態変更フラグON
            window.worktableItemsChangedState = true
            # ボタン変更「Preview」->「StopPreview」
            EventConfig.switchPreviewButton(false)
            $(window.drawingCanvas).one('click.runPreview', (e) =>
              # アイテムを再描画
              @refreshAllItemsFromInstancePageValueIfChanging()
            )
      if !doRunPreview
        if focusTargetItem?
          # アイテムにフォーカス
          Common.focusToTarget(focusTargetItem.getJQueryElement(), null, true, true)
      if callback?
        callback()
    )

  # 全イベントのプレビューを停止
  # @param [Function] callback コールバック
  @stopAllEventPreview: (callback = null) ->
    if !window.previewRunning? || !window.previewRunning
      # プレビューが動作していない場合は処理無し
      if callback?
        callback()
      return

    # EventPageValueの退避がある場合戻す
    @reverseStashEventPageValueForPreviewIfNeeded( =>
      count = 0
      length = Object.keys(window.instanceMap).length
      noRunningPreview = true
      for k, v of window.instanceMap
        if v.stopPreview?
          v.stopPreview(null, (wasRunningPreview) ->
            count += 1
            if wasRunningPreview
              noRunningPreview = false
            if length <= count
              window.previewRunning = false
              # ボタン変更「StopPreview」->「Preview」
              EventConfig.switchPreviewButton(true)
              if callback?
                callback(noRunningPreview)
              return
          )
        else
          count += 1
          if length <= count
            window.previewRunning = false
            # ボタン変更「StopPreview」->「Preview」
            EventConfig.switchPreviewButton(true)
            if callback?
              callback(noRunningPreview)
            return
    )

  @stashEventPageValueForPreview: (teNum, callback = null) ->
    _callback = ->
      window.stashedEventPageValueForPreview = {
        pageNum: PageValue.getPageNum()
        forkNum: PageValue.getForkNum()
        teNum: teNum
        value: PageValue.getEventPageValue(PageValue.Key.eventNumber(teNum))
      }
      if callback?
        callback()

    if window.stashedEventPageValueForPreview?
      # 既ににある場合は一度戻す
      @reverseStashEventPageValueForPreviewIfNeeded( =>
        _callback.call(@)
      )
    else
      _callback.call(@)

  @reverseStashEventPageValueForPreviewIfNeeded: (callback = null) ->
    if !window.stashedEventPageValueForPreview?
      # 無い場合は終了
      if callback?
        callback()
      return

    pageNum = window.stashedEventPageValueForPreview.pageNum
    forkNum = window.stashedEventPageValueForPreview.forkNum
    teNum = window.stashedEventPageValueForPreview.teNum
    value = window.stashedEventPageValueForPreview.value
    PageValue.setEventPageValue(PageValue.Key.eventNumber(teNum, forkNum, pageNum), value)
    window.stashedEventPageValueForPreview = null
    if callback?
      callback()
