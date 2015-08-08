# ワークテーブル読み込みフラグ
window.worktablePage = true

# アイテムに対してイベントを設定する
setupEvents = (obj) ->
  # コンテキストメニュー設定
  do ->
    menu = [{title: "Delete", cmd: "delete", uiIcon: "ui-icon-scissors"}]
    contextSelector = null
    if ArrowItem? && obj instanceof ArrowItem
      menu.push({title: "ArrowItem", cmd: "cut", uiIcon: "ui-icon-scissors"})
      contextSelector = ".arrow"
    else if ButtonItem? && obj instanceof ButtonItem
      menu.push({title: "ButtonItem", cmd: "cut", uiIcon: "ui-icon-scissors"})
      contextSelector = ".css3button"
    setupContextMenu(obj.getJQueryElement(), contextSelector, menu)

  # クリックイベント設定
  do ->
    obj.getJQueryElement().mousedown( (e)->
      if e.which == 1 #左クリック
        e.stopPropagation()
        clearSelectedBorder()
        setSelectedBorder(@, "edit")
    )

  # JQueryUIのドラッグイベントとリサイズ設定
  do ->
    obj.getJQueryElement().draggable({
      containment: scrollInside
      drag: (event, ui) ->
        if obj.drag?
          obj.drag()
      stop: (event, ui) ->
        if obj.dragComplete?
          obj.dragComplete()
    })
    obj.getJQueryElement().resizable({
      containment: scrollInside
      resize: (event, ui) ->
        if obj.resize?
          obj.resize()
      stop: (event, ui) ->
        if obj.resizeComplete?
          obj.resizeComplete()
    })

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
    $(window.drawingCanvas).css('z-index', Constant.ZINDEX_MAX)
  else if mode == Constant.Mode.EDIT
    $(window.drawingCanvas).css('z-index', 0)
  else if mode == Constant.Mode.OPTION
    $(window.drawingCanvas).css('z-index', Constant.ZINDEX_MAX)
  window.mode = mode

# 非表示をクリア
clearAllItemStyle = ->
  for k, v of getCreatedItemObject()
    v.clearAllEventStyle()

  # 選択枠を取る
  clearSelectedBorder()
  # 全てのカラーピッカーを閉じる
  $('.colorPicker').ColorPickerHide()

# 対象アイテムに対してフォーカスする(サイドバーオープン時)
# @param [Object] target 対象アイテム
# @param [String] selectedBordfcccccccccccccccerType 選択枠タイプ
focusToTargetWhenSidebarOpen = (target, selectedBorderType = "edit") ->
  # 選択枠設定
  setSelectedBorder(target, selectedBorderType)
  # 変更前のスライド値を保存
  setPageValue(Constant.PageValueKey.CONFIG_OPENED_SCROLL, {top: scrollContents.scrollTop(), left: scrollContents.scrollLeft()}, true)
  focusToTarget(target)


# キーイベント初期化
initKeyEvent = ->
  $(window).keydown( (e)->
    isMac = navigator.platform.toUpperCase().indexOf('MAC')>=0;
    if (isMac && e.metaKey) ||  (!isMac && e.ctrlKey)
      if e.keyCode == Constant.KeyboardKeyCode.Z
        e.preventDefault()
        if e.shiftKey
          # Shift + Ctrl + z → Redo
          redo()
        else
          # Ctrl + z → Undo
          undo()
  )

# 画面のアイテムをクリア
clearWorkTable = ->
  for k, v of getCreatedItemObject()
    v.getJQueryElement().remove()

### デバッグ ###
runDebug = ->
  for k, v of getCreatedItemObject()
    item = v
    return false
  if item.reDrawByObjPageValue()
    setupEvents(item)

$ ->
  # ブラウザ対応チェック
  if !checkBlowserEnvironment()
    alert('ブラウザ非対応です。')
    return

  # 共有変数
  worktableCommonVar()
  # WebStorageを初期化する
  lstorage.clear()
  # 初期状態としてボタンを選択(暫定)
  window.selectItemMenu = Constant.ItemId.BUTTON
  loadItemJs(Constant.ItemId.BUTTON)
  #Wrapper & Canvasサイズ
  $('#contents').css('height', $('#contents').height() - $('#nav').height())
  $('#canvas_container').attr('width', $('#main-wrapper').width())
  $('#canvas_container').attr('height', $('#main-wrapper').height())
  # スクロールサイズ
  scrollInside.width(scrollContents.width() * (scrollViewMag + 1))
  scrollInside.height(scrollContents.height() * (scrollViewMag + 1))
  # スクロール位置初期化
  scrollContents.scrollLeft(scrollContents.width() * (scrollViewMag * 0.5))
  scrollContents.scrollTop(scrollContents.height() * (scrollViewMag * 0.5))
  # ドロップダウン
  $('.dropdown-toggle').dropdown()
  # ヘッダーメニュー
  initHeaderMenu()
  # キーイベント
  initKeyEvent()
  # ドラッグ描画イベント
  initHandwrite()
  # コンテキストメニュー
  menu = [{title: "Default", cmd: "default", uiIcon: "ui-icon-scissors"}]
  setupContextMenu($('#main'), '#main-wrapper', menu)
  $('#main').on("mousedown", ->
    clearAllItemStyle()
  )
  # タイムライン初期化
  # TODO: 本来はタイムライン表示時に行う
  setupTimelineEventConfig()
