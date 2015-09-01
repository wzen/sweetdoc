class Worktable

  # ワークテーブル読み込みフラグ
  window.worktablePage = true

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
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.MAX))
    else if mode == Constant.Mode.EDIT
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM))
    else if mode == Constant.Mode.OPTION
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.MAX))
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

    #Wrapper & Canvasサイズ
    borderWidth = 5
    timelineTopPadding = 5
    padding = borderWidth * 4 + timelineTopPadding
    $('#pages').height($('#contents').height() - $("##{Constant.ElementAttribute.NAVBAR_ROOT}").height() - $('#timeline').height() - padding)
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM))
    $(window.drawingCanvas).attr('width', window.mainWrapper.width())
    $(window.drawingCanvas).attr('height', window.mainWrapper.height())
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
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', window.pageNum)
    WorktableCommon.setupContextMenu($('#main'), "#pages .#{page} .main-wrapper:first", menu)
    $('#main').on("mousedown", =>
      @clearAllItemStyle()
    )
    # 共通設定
    Setting.initConfig()

$ ->
  # ブラウザ対応チェック
  if !Common.checkBlowserEnvironment()
    alert('ブラウザ非対応です。')
    return

  # 現在のページ番号
  window.pageNum = PageValue.getPageNum()

  # キャッシュチェック
  existedCache = !LocalStorage.isOverWorktableSaveTimeLimit()

  if existedCache
    # キャッシュが存在する場合アイテム描画
    LocalStorage.loadValueForWorktable()

  # 現在のページ番号
  window.pageNum = PageValue.getPageNum()
  # Mainコンテナ作成
  Common.createdMainContainerIfNeeded(window.pageNum)
  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  # コンテナ初期化
  Worktable.initMainContainer()

  if existedCache
    # 描画
    PageValue.adjustInstanceAndEventOnThisPage()
    WorktableCommon.drawAllItemFromEventPageValue()
  else
    LocalStorage.clearWorktable()
    Timeline.refreshAllTimeline()

  # 履歴に画面初期時を状態を保存
  OperationHistory.add(true)
  # ページ総数更新
  PageValue.updatePageCount()
  # ページング
  Paging.initPaging()
