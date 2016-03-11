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

  @clearTimelineSelectedBorderInMainWrapper = ->
    $('.timelineSelected', window.mainWrapper).remove()
    # 選択アイテムID解除
    window.selectedObjId = null

  # キャッシュからWorktableを作成するか判定
  @checkLoadWorktableFromCache = ->
    if window.lStorage.isOverWorktableSaveTimeLimit()
      # キャッシュ期限切れ
      return false
    if window.changeUser? && window.changeUser
      # ユーザが変更された場合
      return false
    generals = window.lStorage.loadGeneralValue()
    if !generals[constant.Project.Key.PROJECT_ID]?
      # プロジェクトが存在しない場合
      return false

    return true

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
      scrollContentsSize = Common.scrollContentsSizeUnderViewScale()
      instance.itemSize.x = parseInt(window.scrollContents.scrollLeft() + (scrollContentsSize.width - instance.itemSize.w) * 0.5)
      instance.itemSize.y = parseInt(window.scrollContents.scrollTop() + (scrollContentsSize.height - instance.itemSize.h) * 0.5)
      if instance.drawAndMakeConfigs?
        instance.drawAndMakeConfigs()
      instance.setItemAllPropToPageValue()
      window.lStorage.saveAllPageValues()

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

  # アイテム編集
  @editItem = (objId) ->
    item = window.instanceMap[objId]
    if item? && item.launchEdit?
      # launchEditメソッドが宣言されている場合は呼ぶ
      item.launchEdit()
    else
      # それ以外はアイテム編集サイドメニューを開く
      Sidebar.openItemEditConfig($("##{objId}"))

  # モードチェンジ
  # @param [Mode] afterMode 変更後画面モード
  @changeMode = (afterMode, pn = PageValue.getPageNum()) ->
    # 画面Zindex変更
    if afterMode == constant.Mode.NOT_SELECT
      #$(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT, pn))
      $(window.drawingCanvas).css('pointer-events', '')
      window.scrollInsideWrapper.removeClass('edit_mode')
    else if afterMode == constant.Mode.DRAW
      #$(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT, pn))
      $(window.drawingCanvas).css('pointer-events', '')
      window.scrollContents.find('.item.draggable').removeClass('edit_mode')
      window.scrollInsideWrapper.removeClass('edit_mode')
    else if afterMode == constant.Mode.EDIT
      #$(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM, pn))
      $(window.drawingCanvas).css('pointer-events', 'none')
      window.scrollContents.find('.item.draggable').addClass('edit_mode')
      window.scrollInsideWrapper.addClass('edit_mode')
      # ヘッダーをEditに
      Navbar.setModeEdit()
    else if afterMode == constant.Mode.OPTION
      #$(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT, pn))
      $(window.drawingCanvas).css('pointer-events', '')
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

  # 画面Pointingモードに変更
  @changeEventPointingMode = (afterMode) ->
    if afterMode == constant.EventInputPointingMode.NOT_SELECT
      # 全入力を有効
      Timeline.disabledOperation(false)
      Sidebar.disabledOperation(false)
      Navbar.disabledOperation(false)
    else if afterMode == constant.EventInputPointingMode.DRAW || afterMode == constant.EventInputPointingMode.ITEM_TOUCH
      # 全入力を無効に
      Timeline.disabledOperation(true)
      Sidebar.disabledOperation(true)
      Navbar.disabledOperation(true)

    @setModeClassToMainDiv(afterMode)
    window.eventPointingMode = afterMode

  # イベントポインタ表示削除
  @clearEventPointer: ->
    if EventDragPointingDraw? && EventDragPointingDraw.clear?
      EventDragPointingDraw.clear()
    if EventDragPointingRect? && EventDragPointingRect.clear?
      EventDragPointingRect.clear()

  # ID=MainのDivにクラス名を設定
  @setModeClassToMainDiv = (mode) ->
    classes = [
      'draw_mode'
      'draw_pointing'
      'click_pointing'
    ]
    $('#main').removeClass(classes.join(' '))
    if mode == constant.Mode.DRAW
      $('#main').addClass('draw_mode')
    else if mode == constant.EventInputPointingMode.DRAW
      $('#main').addClass('draw_pointing')
    else if mode == constant.EventInputPointingMode.ITEM_TOUCH
      $('#main').addClass('click_pointing')

  # モードを一つ前に戻す
  @putbackMode = ->
    if window.beforeMode?
      @changeMode(window.beforeMode)
      window.beforeMode = null

  # アイテム描画が変更されている場合にインスタンスから全アイテム再描画
  # @param [Integer] pn ページ番号
  @stopPreviewAndRefreshAllItemsFromInstancePageValue = (pn = PageValue.getPageNum(), callback = null) ->
    # イベント停止
    @stopAllEventPreview( (noRunningPreview) ->
      if window.worktableItemsChangedState || !noRunningPreview
        # アイテムの状態に変更がある場合は再描画処理
        items = Common.instancesInPage(pn)
        if items.length > 0
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
        WorktableCommon.initScrollContentsPosition()
        # イベントで変更された倍率を戻す
        se = new ScreenEvent()
        se.resetNowScaleToWorktableScale()
        # Footprint履歴削除
        PageValue.removeAllFootprint()
        if items.length == 0
          if callback?
            callback()
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
  @focusToTargetWhenSidebarOpen = (target, selectedBorderType = "edit", immediate = false) ->
    # 選択枠設定
    @setSelectedBorder(target, selectedBorderType)
    Common.focusToTarget(target, null, immediate)

  # キーイベント初期化
  @initKeyEvent = ->
    $(window).off('keydown').on('keydown', (e)->
      target = $(e.target)
      if target.prop('tagName') == 'INPUT' || target.prop('tagName') == 'TEXTAREA'
        return
      isMac = navigator.platform.toUpperCase().indexOf('MAC')>=0;
      if (isMac && e.metaKey) ||  (!isMac && e.ctrlKey)
        if window.debug
          console.log(e)
        if e.keyCode == constant.KeyboardKeyCode.Z
          e.preventDefault()
          if e.shiftKey
            # Shift + Ctrl + z → Redo
            OperationHistory.redo()
          else
            # Ctrl + z → Undo
            OperationHistory.undo()
        else if e.keyCode == constant.KeyboardKeyCode.C
          e.preventDefault()
          # Ctrl + c -> Copy
          WorktableCommon.copyItem()
          WorktableCommon.setMainContainerContext()
        else if e.keyCode == constant.KeyboardKeyCode.X
          e.preventDefault()
          # Ctrl + x -> Cut
          WorktableCommon.cutItem()
          WorktableCommon.setMainContainerContext()
        else if e.keyCode == constant.KeyboardKeyCode.V
          e.preventDefault()
          # 貼り付け
          WorktableCommon.pasteItem()
          # 履歴保存
          OperationHistory.add()
        else if e.shiftKey && (e.keyCode == constant.KeyboardKeyCode.PLUS || e.keyCode == constant.KeyboardKeyCode.SEMICOLON)
          e.preventDefault()
          # ズームイン
          step = 0.1
          updatedScale = WorktableCommon.getWorktableViewScale() + step
          WorktableCommon.setWorktableViewScale(updatedScale, true)
          if Sidebar.isOpenedConfigSidebar()
            WorktableSetting.PositionAndScale.initConfig()
        else if e.keyCode == constant.KeyboardKeyCode.MINUS || e.keyCode == constant.KeyboardKeyCode.F_MINUS
          e.preventDefault()
          # ズームアウト
          step = 0.1
          updatedScale = WorktableCommon.getWorktableViewScale() - step
          WorktableCommon.setWorktableViewScale(updatedScale, true)
          if Sidebar.isOpenedConfigSidebar()
            WorktableSetting.PositionAndScale.initConfig()
    )

  # Mainビューの高さ更新
  @updateMainViewSize = ->
    borderWidth = 5
    timelineTopPadding = 5
    $('#main').height($('#contents').height() - $('#timeline').height() - timelineTopPadding - (borderWidth * 2))
    $('#sidebar').height($('#contents').height() - (borderWidth * 2))

  # スクロール位置初期化
  @initScrollContentsPosition = ->
    Common.initScrollContentsPositionByWorktableConfig()

  # 画面サイズ設定
  @resizeMainContainerEvent = ->
    @updateMainViewSize()
    Common.updateCanvasSize()
    Common.updateScrollContentsFromScreenEventVar()
    Sidebar.resizeConfigHeight()

  # ウィンドウリサイズイベント
  @resizeEvent = ->
    WorktableCommon.resizeMainContainerEvent()

  # アイテムを削除
  @removeSingleItem = (itemElement) ->
    targetId = $(itemElement).attr('id')
    PageValue.removeInstancePageValue(targetId)
    PageValue.removeEventPageValueSync(targetId)
    if window.instanceMap[targetId]?
      window.instanceMap[targetId].getJQueryElement().remove()
    PageValue.adjustInstanceAndEventOnPage()
    Timeline.refreshAllTimeline()
    window.lStorage.saveAllPageValues()
    OperationHistory.add()

  # ページ削除
  @removePage = (pageNum, callback = null) ->
    # ページHTMLを削除
    root = $("##{constant.Paging.ROOT_ID}")
    afterSectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageCount())
    afterSection = $(".#{afterSectionClass}:first", root)
    for p in [(PageValue.getPageCount() - 1)..pageNum] by -1
      # ページをずらす
      beforeSectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', p)
      beforeSection = $(".#{beforeSectionClass}:first", root)
      afterSection.removeClass(afterSectionClass).addClass(beforeSectionClass)
      afterSection.css('z-index', Common.plusPagingZindex(0, p))
      afterSection = beforeSection
    afterSection.remove()
    # 共通イベントのデータを削除
    @removeCommonEventInstances(pageNum)
    # PageValueを削除
    PageValue.removeAndShiftGeneralPageValueOnPage(pageNum)
    PageValue.removeAndShiftInstancePageValueOnPage(pageNum)
    PageValue.removeAndShiftEventPageValueOnPage(pageNum)
    PageValue.removeAndShiftFootprintPageValueOnPage(pageNum)
    # ページ総数を減らす
    PageValue.updatePageCount()
    # PageValue調整
    PageValue.adjustInstanceAndEventOnPage()
    if callback?
      callback()

  ### デバッグ ###
  @runDebug = ->

  # Mainコンテナ初期化
  @initMainContainer = ->
    # 定数 & レイアウト & イベント系変数の初期化
    CommonVar.worktableCommonVar()
    Common.updateCanvasSize()
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT))
    # スクロールサイズ
    window.scrollInsideWrapper.width(window.scrollViewSize)
    window.scrollInsideWrapper.height(window.scrollViewSize)
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM + 1))
    # スクロールイベント設定
    window.scrollContents.off('scroll').on('scroll', (e) ->
      if window.skipScrollEvent? && window.skipScrollEvent
        window.skipScrollEvent = false
        return
      if window.skipScrollEventByAnimation? && window.skipScrollEventByAnimation
        return
      e.preventDefault()
      e.stopPropagation()
      scrollContentsSize = Common.scrollContentsSizeUnderViewScale()
      top = window.scrollContents.scrollTop() + scrollContentsSize.height * 0.5
      left = window.scrollContents.scrollLeft() + scrollContentsSize.width * 0.5
      centerPosition = Common.calcScrollCenterPosition(top, left)
      if centerPosition?
        FloatView.show(FloatView.scrollMessage(centerPosition.top.toFixed(1), centerPosition.left.toFixed(1)), FloatView.Type.DISPLAY_POSITION)
      Common.saveDisplayPosition(top, left, false, ->
        FloatView.hide()
        if Sidebar.isOpenedConfigSidebar()
          WorktableSetting.PositionAndScale.initConfig()
      )
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
    # コンフィグ設定初期化
    StateConfig.clearScreenConfig()
    # Mainビュー高さ設定
    @updateMainViewSize()
    # コンフィグ高さ設定
    Sidebar.resizeConfigHeight()
    # 共通設定
    WorktableSetting.clear()
    WorktableSetting.initConfig()
    # 選択アイテム初期化
    WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT)
    # ページ総数更新
    PageValue.updatePageCount()
    # フォーク総数更新
    PageValue.updateForkCount()
    # ページング初期化
    Paging.initPaging()

  # スクロール位置を再設定
  @adjustScrollContentsPosition: ->
    Common.applyViewScale()
    p =  PageValue.getWorktableScrollContentsPosition()
    if window.debug
      console.log('adjustScrollContentsPosition')
      console.log(p)
    Common.updateScrollContentsPosition(p.top, p.left)

  # Mainコンテナのコンテキストメニューを設定
  @setMainContainerContext: ->
    # コンテキストメニュー
    menu = []
    if window.copiedInstance?
      menu.push({title: I18n.t('context_menu.paste'), cmd: "paste", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 貼り付け
        WorktableCommon.pasteItem()
        # キャッシュ保存
        window.lStorage.saveAllPageValues()
        # 履歴保存
        OperationHistory.add()
      })
    page = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
    WorktableCommon.setupContextMenu($("#pages .#{page} .scroll_inside:first"), "#pages .#{page} .main-wrapper:first", menu)

  # ワークテーブル初期化
  @resetWorktable: ->
    # アイテムを全消去
    @removeAllItemAndEvent( =>
      # ページを全消去
      $('#pages .section').remove()
      # 環境をリセット
      Common.resetEnvironment()
      # アイテム選択をデフォルトに戻す
      Navbar.setDefaultItemSelect()
      # 変数初期化
      CommonVar.initVarWhenLoadedView()
      CommonVar.initCommonVar()
      # Mainコンテナ作成
      Common.createdMainContainerIfNeeded(PageValue.getPageNum())
      # コンテナ初期化
      @initMainContainer()
      # Mainビューの高さを初期化
      $('#main').css('height', '')
      # キャッシュ削除
      window.lStorage.clearWorktableWithoutSetting()
      # ページ数初期化
      PageValue.setPageNum(1)
      # 履歴に画面初期時を状態を保存
      OperationHistory.add(true)
      # ページ総数更新
      PageValue.updatePageCount()
      # フォーク総数更新
      PageValue.updateForkCount()
      # プロジェクトビュー & タイムラインを閉じる
      $('#project_wrapper').hide()
      $('#timeline').hide()
    )

  # ワークテーブルの画面倍率を取得
  @getWorktableViewScale = (pn = PageValue.getPageNum()) ->
    return Common.getWorktableViewScale(pn)

  # ワークテーブルの画面倍率を設定
  @setWorktableViewScale = (scale, withViewStateUpdate = false) ->
    PageValue.setGeneralPageValue(PageValue.Key.worktableScale(), scale)
    if withViewStateUpdate
      FloatView.show('View scale : ' + parseInt(scale * 100) + '%', FloatView.Type.SCALE, 1.0)
      # スクロール位置修正
      @adjustScrollContentsPosition()
      # キャッシュ保存
      window.lStorage.saveGeneralPageValue()

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
        if window.mode == constant.Mode.EDIT && $(t).hasClass('item')
        # 選択状態にする
          WorktableCommon.setSelectedBorder(t)
    })

  # 全てのアイテムとイベントを削除
  @removeAllItemAndEvent = (callback = null) ->
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    window.lStorage.clearWorktableWithoutSetting()
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
    window.lStorage.clearWorktableWithoutGeneralAndSetting()
    Common.removeAllItem(PageValue.getPageNum())
    EventConfig.removeAllConfig()
    PageValue.removeAllInstanceAndEventPageValueOnPage()
    Timeline.refreshAllTimeline()
    if callback?
      callback()

  # 共通イベントインスタンス作成
  @createCommonEventInstancesOnThisPageIfNeeded = ->
    for clsToken, cls of window.classMap
      if cls.prototype instanceof CommonEvent
        instance = new (Common.getClassFromMap(cls.CLASS_DIST_TOKEN))()
        if !window.instanceMap[instance.id]?
          Common.setInstanceFromMap(instance.id, instance.constructor.CLASS_DIST_TOKEN)
          instance.setItemAllPropToPageValue()

  # 共通イベントのページインスタンス削除
  @removeCommonEventInstances = (pn = PageValue.getPageNum()) ->
    for clsToken, cls of window.classMap
      if cls.prototype instanceof CommonEvent
        cls.deleteInstanceOnPage(pn)

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
    # 操作履歴削除
    PageValue.removeAllFootprint()
    teNum = parseInt(teNum)
    focusTargetItem = null
    # プレビュー実行フラグON
    if doRunPreview
      window.previewRunning = true
    for te, idx in tes
      item = window.instanceMap[te.id]
      if item?
        item.initEvent(te, keepDispMag)
        if item instanceof ItemBase && te[EventPageValueBase.PageValueKey.DO_FOCUS]
          # アイテムにフォーカス
          Common.focusToTarget(item.getJQueryElement(), null, true)
        if idx < tes.length - 1 || fromBlankEventConfig
          item.willChapter( ->
            # イベント後の状態に変更
            item.updateEventAfter()
            # 最終ステップでメソッドを実行
            item.execLastStep()
            item.didChapter()
          )
        else if doRunPreview
          # プレビュー実行
          item.preview( =>
            @stopPreview(keepDispMag)
          )
          # 状態変更フラグON
          window.worktableItemsChangedState = true
          # ボタン変更「Preview」->「StopPreview」
          EventConfig.switchPreviewButton(false)
    if callback?
      callback()

  @stopPreview: (keepDispMag, callback = null) ->
    # プレビューの実行回数超過
    # ボタン変更「StopPreview」->「Preview」
    EventConfig.switchPreviewButton(true)
    # 全てのアイテム状態をイベント前にする
    @updateAllItemsToBeforePreview(keepDispMag)
    # アイテム再描画
    @stopPreviewAndRefreshAllItemsFromInstancePageValue(PageValue.getPageNum(), =>
      FloatView.hideWithCloseButtonView()
      if callback?
        callback()
    )

  # 全てのアイテム状態をイベント前に戻す(プレビュー停止前に動作させること)
  # @param [Function] callback コールバック
  @updateAllItemsToBeforePreview: (keepDispMag) ->
    # EventPageValueを読み込み、全てイベント実行前(updateEventBefore)にする
    tesArray = []
    tesArray.push(PageValue.getEventPageValueSortedListByNum(PageValue.Key.EF_MASTER_FORKNUM))
    forkNum = PageValue.getForkNum()
    if forkNum > 0
      for i in [1..forkNum]
        # フォークデータを含める
        tesArray.push(PageValue.getEventPageValueSortedListByNum(i))
    for tes in tesArray
      for idx in [tes.length - 1 .. 0] by -1
        te = tes[idx]
        item = window.instanceMap[te.id]
        if item?
          item.initEvent(te, keepDispMag)
          item.updateEventBefore()

  # 全イベントのプレビューを停止
  # @param [Function] callback コールバック
  @stopAllEventPreview: (callback = null) ->
    if !window.previewRunning? || !window.previewRunning
      # プレビューが動作していない場合は処理無し
      if callback?
        callback(true)
      return

    # EventPageValueの退避がある場合戻す
    @reverseStashEventPageValueForPreviewIfNeeded( =>
      count = 0
      length = Object.keys(window.instanceMap).length
      noRunningPreview = true
      if length == 0
        if callback?
          callback(noRunningPreview)
      else
        for k, v of window.instanceMap
          if v.stopPreview?
            v.stopPreview((wasRunningPreview) ->
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
