# ワークテーブル読み込みフラグ
window.worktablePage = true

# 選択枠を付ける
# @param [Object] target 対象のオブジェクト
# @param [String] selectedBorderType 選択タイプ
setSelectedBorder = (target, selectedBorderType = "edit") ->
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
clearSelectedBorder = ->
  $('.editSelected, .timelineSelected').remove()


# アイテムのJSファイル初期化関数名を取得
# @param [Int] itemId アイテム種別
getInitFuncName = (itemId) ->
  itemName = Constant.ITEM_PATH_LIST[itemId]
  # TODO: ハイフンが途中にあるものはキャメルに変換
  return itemName + "Init"

# モードチェンジ
# @param [Mode] mode 画面モード
changeMode = (mode) ->
  if mode == Constant.Mode.DRAW
    $(window.drawingCanvas).css('z-index', Constant.Zindex.MAX)
  else if mode == Constant.Mode.EDIT
    $(window.drawingCanvas).css('z-index', Constant.Zindex.EVENTBOTTOM)
  else if mode == Constant.Mode.OPTION
    $(window.drawingCanvas).css('z-index', Constant.Zindex.MAX)
  window.mode = mode

# 非表示をクリア
clearAllItemStyle = ->
  for k, v of Common.getCreatedItemObject()
    if v instanceof ItemBase
      v.clearAllEventStyle()

  # 選択枠を取る
  clearSelectedBorder()
  # 全てのカラーピッカーを閉じる
  $('.colorPicker').ColorPickerHide()

# 対象アイテムに対してフォーカスする(サイドバーオープン時)
# @param [Object] target 対象アイテム
# @param [String] selectedBorderType 選択枠タイプ
focusToTargetWhenSidebarOpen = (target, selectedBorderType = "edit") ->
  # 選択枠設定
  setSelectedBorder(target, selectedBorderType)
  # 変更前のスライド値を保存
  PageValue.setInstancePageValue(PageValue.Key.CONFIG_OPENED_SCROLL, {top: scrollContents.scrollTop(), left: scrollContents.scrollLeft()}, true)
  LocalStorage.savePageValue()
  Common.focusToTarget(target)

# キーイベント初期化
initKeyEvent = ->
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
clearWorkTable = ->
  for k, v of Common.getCreatedItemObject()
    v.getJQueryElement().remove()

### デバッグ ###
runDebug = ->

$ ->
  # ブラウザ対応チェック
  if !Common.checkBlowserEnvironment()
    alert('ブラウザ非対応です。')
    return

  # 共有変数
  worktableCommonVar()
  #Wrapper & Canvasサイズ
  $('#contents').css('height', $('#contents').height() - $("##{Constant.ElementAttribute.NAVBAR_ROOT}").height())
  borderWidth = 5
  timelineTopPadding = 5
  padding = borderWidth * 4 + timelineTopPadding
  window.mainWrapper.height($('#contents').height() - $('#timeline').height() - padding)
  $('#canvas_container').attr('width', window.mainWrapper.width())
  $('#canvas_container').attr('height', window.mainWrapper.height())
  # スクロールサイズ
  scrollInside.width(window.scrollViewSize)
  scrollInside.height(window.scrollViewSize)
  # スクロール位置初期化
  scrollContents.scrollLeft(scrollInside.width() * 0.5)
  scrollContents.scrollTop(scrollInside.height() * 0.5)
  # ドロップダウン
  $('.dropdown-toggle').dropdown()
  # ヘッダーメニュー
  initHeaderMenu()
  # キーイベント
  initKeyEvent()
  # ドラッグ描画イベント
  Handwrite.initHandwrite()
  # コンテキストメニュー
  menu = [{title: "Default", cmd: "default", uiIcon: "ui-icon-scissors"}]
  WorktableCommon.setupContextMenu($('#main'), '#main-wrapper', menu)
  $('#main').on("mousedown", ->
    clearAllItemStyle()
  )

  if !LocalStorage.isOverWorktableSaveTimeLimit()
    # キャッシュが存在する場合アイテム描画
    LocalStorage.loadValueForWorktable()
    PageValue.adjustInstanceAndEvent()
    WorktableCommon.drawAllItemFromEventPageValue()
  else
    LocalStorage.clearWorktable()
    Timeline.refreshAllTimeline()

  # 履歴に画面初期時を状態を保存
  OperationHistory.add()

