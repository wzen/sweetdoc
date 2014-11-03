# 定数
class Constant

  # @property SURFACE_IMAGE_MARGIN Canvasの背景貼り付け時のマージン
  @SURFACE_IMAGE_MARGIN = 5
  # @porperty ZINDEX_MAX z-indexの最大値
  @ZINDEX_MAX = 1000
  # @property OPERATION_STORE_MAX 操作履歴保存最大数
  @OPERATION_STORE_MAX = 30

  # 操作モード
  class @MODE
    # @property [Int] DRAW 描画
    @DRAW:0
    # @property [Int] EDIT 画面編集
    @EDIT:1
    # @property [Int] OPTION アイテムオプション
    @OPTION:2

  # アイテム種別
  class @ItemType
    # @property [Int] ARROW 矢印
    @ARROW : 0
    # @property [Int] BUTTON ボタン
    @BUTTON : 1

  # アイテムに対するアクション
  class @ItemActionType
    # @property [Int] MAKE 作成
    @MAKE : 0
    # @property [Int] MOVE 移動
    @MOVE : 1
    # @property [int] CHANGE_OPTION オプション変更
    @CHANGE_OPTION : 2

  # キーコード
  class @keyboardKeyCode
    # @property [Int] z zボタン
    @z : 90


# アイテム基底
class ItemBase
  # @abstract
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = ""

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->

    # @property [Int] id ID
    @id = generateId()
    # @property [Object] drawingSurfaceImageData 画面を保存する変数
    @drawingSurfaceImageData = null
    if cood != null
      # @property [Array] mousedownCood 初期座標
      @mousedownCood = {x:cood.x, y:cood.y}
    # @property [Array] itemSize サイズ
    @itemSize = null
    # @property [Int] zIndex z-index
    @zindex = 0
    # @property [Array] ohiRegist 操作履歴Index保存配列
    @ohiRegist = []
    # @property [Int] ohiRegistIndex 操作履歴Index保存配列のインデックス
    @ohiRegistIndex = 0

  # IDを取得
  # @return [Int] ID
  getId: -> @id

  # HTML要素IDを取得
  # @return [Int] HTML要素ID
  elementId: ->
    return @constructor.IDENTITY + '_' + @id

  # サイズ取得
  # @return [Array] サイズ
  getSize: -> @itemSize

  # サイズ設定
  # @param [Array] size サイズ
  setSize: (size) ->
    @itemSize = size

  # 操作履歴Indexをプッシュ
  # @param [ItemBase] obj オブジェクト
  pushOhi: (obj)->
    @ohiRegist[@ohiRegistIndex] = obj
    @ohiRegistIndex += 1

  # 操作履歴Index保存配列のインデックスをインクリメント
  incrementOhiRegistIndex: ->
    @ohiRegistIndex += 1

  # 操作履歴Indexを取り出す
  # @return [Int] 操作履歴Index
  popOhi: ->
    @ohiRegistIndex -= 1
    return @ohiRegist[@ohiRegistIndex]

  # 最後の操作履歴Indexを取得
  # @return [Int] 操作履歴Index
  lastestOhi: ->
    return @ohiRegist[@ohiRegist.length - 1]

  # 画面を保存(全画面)
  saveDrawingSurface : ->
    @drawingSurfaceImageData = drawingContext.getImageData(0, 0, drawingCanvas.width, drawingCanvas.height)

  # 保存した画面を全画面に再設定
  restoreAllDrawingSurface : ->
    drawingContext.putImageData(@drawingSurfaceImageData, 0, 0)

  # 保存した画面を指定したサイズで再設定
  # @param [Array] size サイズ
  restoreDrawingSurface : (size) ->
    drawingContext.putImageData(@drawingSurfaceImageData, 0, 0, size.x - Constant.SURFACE_IMAGE_MARGIN, size.y - Constant.SURFACE_IMAGE_MARGIN, size.w + Constant.SURFACE_IMAGE_MARGIN * 2, size.h + Constant.SURFACE_IMAGE_MARGIN * 2)

  # 描画開始時に呼ばれるメソッド
  startDraw: ->
    changeMode(Constant.MODE.DRAW)

  # 描画終了時に呼ばれるメソッド
  # @param [Array] cood 座標
  # @param [Int] zindex z-index
  # @return [Boolean] 処理結果
  endDraw: (cood, zindex) ->
    @zindex = zindex
    changeMode(Constant.MODE.EDIT)
    if isClick.call(@, cood)
      # 枠線を付ける
    else
      # 状態を保存
      @saveObj(Constant.ItemActionType.MAKE)
    return true

  # アイテムの情報をアイテムリストと操作履歴に保存
  # @param [ItemActionType] action アクション種別
  saveObj: (action) ->
    # 操作履歴に保存
    history = {
      obj: @
      action : action
      itemSize: @itemSize
    }
    @pushOhi(operationHistoryIndex - 1)
    pushOperationHistory(history)
    if action == Constant.ItemActionType.MAKE
      # アイテムリストに保存
      itemObjectList.push(@)
    console.log('save id:' + @elementId())

  # ストレージとDB保存用の最小限のデータを取得
  # @abstract
  generateMinimumObject: ->

  # 最小限のデータからアイテムを描画
  # @abstract
  loadByMinimumObject: (obj) ->

  # マウスクリックか判定
  # @private
  # @param [Array] cood マウスクリック座標
  isClick = (cood) ->
    return cood.x == @mousedownCood.x && cood.y == @mousedownCood.y


# ブラウザ対応のチェック
# @return [Boolean] 処理結果
checkBlowserEnvironment = ->
  if !localStorage
    return false
  else
    try
      localStorage.setItem('test', 'test')
      c = localStorage.getItem('test')
      localStorage.removeItem('test')
    catch e
      return false
  if !File
    return false
  return true

# 共有変数定義
initCommonVar = ->
  window.sidebarWrapper = $("#sidebar-wrapper")
  window.mainScroll = $('#main_scroll')
  window.mainWrapper = $('#main-wrapper')
  window.originalMainContainerSize = {w: mainWrapper.width(), h: mainWrapper.height()}
  window.cssCode = $("#cssCode")
  window.codeCache = $("#codeCache")
  window.messageTimer = null
  window.flushMessageTimer = null
  window.drawingCanvas = document.getElementById('canvas_container')
  window.drawingContext = drawingCanvas.getContext('2d')
  window.mode = Constant.MODE.DRAW
  window.selectItemMenu = Constant.ItemType.BUTTON
  window.storage = localStorage
  # WebStorageを初期化する
  storage.clear()
  window.itemObjectList = []
  window.operationHistory = []
  window.operationHistoryIndex = 0

# JQueryUIのドラッグイベントとリサイズをセット
initDraggableAndResizable =  ->
  drag = $('.draggable')
#  drag.on('mousedown', (e) ->
#    e.stopPropagation()
#  )
  drag.draggable({
    containment: mainWrapper
  })

  rSize = $('.resizable')
#  rSize.on('mousedown', (e) ->
#    e.stopPropagation()
#  )
  rSize.resizable({
    containment: mainWrapper
  })

# JQueryUIのドラッグイベントとリサイズをセット
# @param [ItemBase] obj アイテムオブジェクト
setDraggableAndResizable = (obj)->
  $('#' + obj.elementId()).draggable({
    containment: mainWrapper
    stop: (event, ui) ->
      rect = {x:ui.position.left, y: ui.position.top, w: obj.getSize().w, h: obj.getSize().h}
      obj.save(Constant.ItemActionType.MOVE, rect)
  })
  $('#' + obj.elementId()).resizable({
    containment: mainWrapper
    stop: (event, ui) ->
      rect = {x: obj.getSize().x, y: obj.getSize().y, w: ui.size.width, h: ui.size.height}
      obj.save(Constant.ItemActionType.MOVE, rect)
  })

# アイテムのIDを作成
# @return [Int] 生成したID
generateId = ->
  numb = 10 #10文字
  RandomString = '';
  BaseString ='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  n = 62
  for i in [0..numb]
    RandomString += BaseString.charAt( Math.floor( Math.random() * n))
  return RandomString

### スライダーの作成 ###

# 通常スライダーの作成
# @param [Int] id メーターのElementID
# @param [Int] min 最小値
# @param [Int] max 最大値
# @param [Object] codeEmt コードエレメント
# @param [Object] previewEmt CSSプレビューのエレメント
# @param [Int] stepValue 進捗数
settingSlider = (id, min, max, codeEmt, previewEmt, stepValue) ->
  if typeof stepValue == 'undefined'
    stepValue = 0

  meterElement = $('#' + id)
  valueElement = $('.' + id + '-value')
  d = $('.' + id + '-value', codeEmt)[0]
  defaultValue = $(d).html()
  valueElement.val(defaultValue)
  valueElement.html(defaultValue)
  meterElement.slider({
    min: min,
    max: max,
    step: stepValue,
    value: defaultValue
    slide: (event, ui)->
      valueElement.val(ui.value)
      valueElement.html(ui.value)
      previewEmt.text(codeEmt.text())
  })

# HTML要素からグラデーションスライダーの作成
# @param [Object] element HTML要素
# @param [Array] values 値の配列
# @param [Object] codeEmt コードエレメント
# @param [Object] previewEmt CSSプレビューのエレメント
settingGradientSliderByElement = (element, values, codeEmt, previewEmt) ->
  id = element.attr("id")

  element.slider({
    values: values
    slide: (event, ui) ->
      index = $(ui.handle).index()
      position = $('.btn-bg-color' + (index + 2) + '-position', codeEmt)
      position.html(ui.value)
      previewEmt.text(codeEmt.text())
  })

  handleElement = element.children('.ui-slider-handle')
  if values == null
    handleElement.css('display', 'none')
  else
    handleElement.css('display', '')

# グラデーションスライダーの作成
# @param [Int] id HTML要素のID
# @param [Array] values 値の配列
# @param [Object] codeEmt コードエレメント
# @param [Object] previewEmt CSSプレビューのエレメント
settingGradientSlider = (id, values, codeEmt, previewEmt) ->
  meterElement = $('#' + id)
  settingGradientSliderByElement(meterElement, values, codeEmt, previewEmt)


# グラデーション方向スライダーの作成
# @param [Int] id メーターのElementID
# @param [Int] min 最小値
# @param [Int] max 最大値
# @param [Object] codeEmt コードエレメント
# @param [Object] previewEmt CSSプレビューのエレメント
settingGradientDegSlider = (id, min, max, codeEmt, previewEmt) ->
  meterElement = $('#' + id)
  valueElement = $('.' + id + '-value')
  webkitValueElement = $('.' + id + '-value-webkit')
  d = $('.' + id + '-value', codeEmt)[0]
  defaultValue = $(d).html()
  webkitDeg = {0 : 'left top, left bottom', 45 : 'right top, left bottom', 90 : 'right top, left top', 135 : 'right bottom, left top', 180 : 'left bottom, left top', 225 : 'left bottom, right top', 270 : 'left top, right top', 315: 'left top, right bottom'}

  valueElement.val(defaultValue)
  valueElement.html(defaultValue)
  webkitValueElement.html(webkitDeg[defaultValue])

  meterElement.slider({
    min: min,
    max: max,
    step: 45,
    value: defaultValue
    slide: (event, ui)->
      valueElement.val(ui.value)
      valueElement.html(ui.value)
      webkitValueElement.html(webkitDeg[ui.value])
      previewEmt.text(codeEmt.text())
  })
### スライダーの作成 ここまで ###

### グラデーション ###

# グラデーションの表示変更(スライダーのハンドル&カラーピッカー)
# @param [Object] element HTML要素
# @param [Object] codeEmt コードエレメント
# @param [Object] previewEmt CSSプレビューのエレメント
changeGradientShow = (element, codeEmt, previewEmt) ->
  targetElement = element.currentTarget
  value = parseInt(targetElement.value)
  if value >= 2 && value <= 5
    meterElement = $(targetElement).siblings('.ui-slider:first')
    values = null
    if value == 3
      values = [50]
    else if value == 4
      values = [30, 70]
    else if value == 5
      values = [25, 50, 75]

    meterElement.slider("destroy")
    settingGradientSliderByElement(meterElement, values, codeEmt, previewEmt)
    switchGradientColorSelectorVisible(value)

# グラデーションのカラーピッカー表示切り替え
# @param [Int] gradientStepValue 現在のグラデーション数
switchGradientColorSelectorVisible = (gradientStepValue) ->
  for i in [2 .. 4]
    element = $('#btn-bg-color' + i)
    if i > gradientStepValue - 1
      element.css('display', 'none')
    else
      element.css('display', '')

### グラデーション ここまで ###

# ヘッダーメニュー初期化
initHeaderMenu = ->
  itemsMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
  $('.menu-open', itemsMenuEmt).on('click', ->
    loadFromServer()
  )
  $('.menu-save', itemsMenuEmt).on('click', ->
    saveToServer()
  )

  itemsMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
  $('.menu-button', itemsMenuEmt).on('click', ->
    itemsMenuEmt.removeClass('active')
    $(@).parent('li').addClass('active')
    window.selectItemMenu = Constant.ItemType.BUTTON
    changeMode(Constant.MODE.DRAW)
  )
  $('.menu-arrow', itemsMenuEmt).on('click', ->
    itemsMenuEmt.removeClass('active')
    $(@).parent('li').addClass('active')
    window.selectItemMenu = Constant.ItemType.ARROW
    changeMode(Constant.MODE.DRAW)
  )

# カラーピッカーの作成
# @param [Object] element HTML要素
# @param [Color] defaultColor デフォルト色
# @param [Function] onChange 変更時に呼ばれるメソッド
settingColorPicker = (element, defaultColor, onChange) ->
  $(element).ColorPicker({
    color: defaultColor
    onShow: (a) ->
      $(a).show()
      return false
    onHide: (a) ->
      $(a).hide()
      return false
    onChange: onChange
  })


#カラーピッカー値の初期化
initColorPickerValue = ->
  $('.colorPicker', sidebarWrapper).each( ->
    id = $(this).attr('id')
    color = $('.' + id, cssCode).html()
    $(this).css('backgroundColor', '#' + color)
    inputEmt = sidebarWrapper.find('#' + id + '-input')
    inputEmt.attr('value', color)
  )

# コンテキストメニュー初期化
# @param [Int] id コンテキストメニューのID
# @param [Object] contextSelector コンテキストメニューを設定する要素
# @param [ItemType] itemType アイテム種別
initContextMenu = (id, contextSelector, itemType = null) ->

  # サイドバーオープン時のスライド距離を計算
  # @param [Object] target スクロールビュー
  calMoveScrollLeft = (target) ->
    # col-md-9 → 75% padding → 15px
    targetMiddle = ($(target).offset().left + $(target).width() * 0.5)
    #  viewMiddle = (mainScroll.width() * 0.5)
    scrollLeft = targetMiddle - mainScroll.width() * 0.75 * 0.5
    if scrollLeft < 0
      scrollLeft = 0
    else if scrollLeft > mainScroll.width() * 0.25
      scrollLeft =  mainScroll.width() * 0.25
    return scrollLeft

  # 共通メニュー
  menu = [
    {title: "Delete", cmd: "delete", uiIcon: "ui-icon-scissors"}
  ]

  # アイテム個別メニュー
  if itemType == Constant.ItemType.ARROW
    menu.push(
      {title: "ArrowItem", cmd: "cut", uiIcon: "ui-icon-scissors"}
    )
  else if itemType == Constant.ItemType.BUTTON
    menu.push(
      {title: "ButtonItem", cmd: "cut", uiIcon: "ui-icon-scissors"}
    )

  $('#' + id).contextmenu(
    {
      delegate: contextSelector
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
        openSidebar(calMoveScrollLeft($target))
        changeMode(Constant.MODE.OPTION)

      beforeOpen: (event, ui) =>
        $target = ui.target
        $menu = ui.menu
        extraData = ui.extraData
        ui.menu.zIndex( $(event.target).zIndex() + 1)
        #$('#contents').contextmenu("setEntry", "copy", "Copy '" + $target.text() + "'").contextmenu("setEntry", "paste", "Paste" + (CLIPBOARD ? " '" + CLIPBOARD + "'" : "")).contextmenu("enableEntry", "paste", (CLIPBOARD != ""))
    }
  )

# モードチェンジ
# @param [Mode] mode 画面モード
changeMode = (mode) ->
  if mode == Constant.MODE.DRAW
    $(window.drawingCanvas).css('z-index', Constant.ZINDEX_MAX)
  else if mode == Constant.MODE.EDIT
    $(window.drawingCanvas).css('z-index', 0)
  else if mode == Constant.MODE.OPTION
    $(window.drawingCanvas).css('z-index', Constant.ZINDEX_MAX)
  window.mode = mode

# サイドバーをオープン
# @param [Array] scrollLeft オープン時にスクロースさせる位置
openSidebar = (scrollLeft = null) ->
  $('#main').switchClass('col-md-12', 'col-md-9', 500, 'swing', ->
    $('#sidebar').fadeIn('1000')
  )
  if scrollLeft != null
    mainScroll.animate({scrollLeft: scrollLeft}, 500)

# サイドバーをクローズ
closeSidebar = ->
  $('#sidebar').fadeOut('1000', ->
    mainScroll.animate({scrollLeft: 0}, 500)
    $('#main').switchClass('col-md-9', 'col-md-12', 500, 'swing')
  )

# 警告表示
# @param [String] message メッセージ内容
showWarn = (message) ->
  warnFooter = $('.warn-message')
  errorFooter = $('.error-message')
  warnDisplay = $('.footer-message-display', warnFooter)
  isBeforeWarnDisplay = warnDisplay.val() == "1"
  isErrorDisplay = $('.footer-message-display', errorFooter).val() == "1"
  mes = $('> div > p', warnFooter)

  if message == undefined
    return

  warnDisplay.val("1")
  exist_mes = mes.html()
  if exist_mes == null || exist_mes == ""
    mes.html(message)
  else
    mes.html(exist_mes + '<br/>' + message)

  if messageTimer != null
    clearTimeout(messageTimer)

  if isBeforeWarnDisplay
    css = {}
  else
    if isErrorDisplay
      bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10
      css = {bottom: bottom + 'px'}
    else
      css = {bottom: '20px'}

  warnFooter.animate(css, 'fast', (e)->
    window.messageTimer = setTimeout((e)->
      footer = $('.footer-message')
      $('.footer-message-display', footer).val("0")
      footer.stop().animate({bottom: '-30px'}, 'fast', (e)->
        window.messageTimer = null
        $('> div > p', $(this)).html('')
      )
    , 3000)
  )

# エラー表示
# @param [String] message メッセージ内容
showError = (message) ->
  warnFooter = $('.warn-message')
  errorFooter = $('.error-message')
  errorDisplay = $('.footer-message-display', errorFooter)
  isBeforeErrorDisplay = errorDisplay.val() == "1"
  isWarnDisplay = $('.footer-message-display', warnFooter).val() == "1"
  mes = $('> div > p', errorFooter)

  if message == undefined
    return

  errorDisplay.val("1")
  exist_mes = mes.html()
  if exist_mes == null || exist_mes == ""
    mes.html(message)
  else
    mes.html(exist_mes + '<br/>' + message)

  if messageTimer != null
    clearTimeout(messageTimer)

  if isBeforeErrorDisplay
    css = {}
  else
    css = {bottom: '20px'}

  errorFooter.animate(css, 'fast', (e)->
    if isWarnDisplay
      bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10
      css = {bottom: bottom + 'px'}
      warnFooter.stop().animate(css, 'fast')

    window.messageTimer = setTimeout((e)->
      footer = $('.footer-message')
      $('.footer-message-display', footer).val("0")
      footer.stop().animate({bottom: '-30px'}, 'fast', (e)->
        window.messageTimer = null
        $('> div > p', $(this)).html('')
      )
    , 3000)
  )

# 警告表示(フラッシュ)
# @param [String] message メッセージ内容
flushWarn = (message) ->
  # 他のメッセージが表示されているときは表示しない
  if(window.messageTimer != null)
    return

  if(window.flushMessageTimer != null)
    clearTimeout(flushMessageTimer)

  fw = $('#flush_warn')
  mes = $('> div > p', fw)
  mes.html(message)
  fw.show()
  window.flushMessageTimer = setTimeout((e)->
    fw.hide()
  , 100)

# キーイベント初期化
initKeyEvent = ->
  $(window).keydown( (e)->
    isMac = navigator.platform.toUpperCase().indexOf('MAC')>=0;
    if (isMac && e.metaKey) ||  (!isMac && e.ctrlKey)
      if e.keyCode == Constant.keyboardKeyCode.z
        e.preventDefault()
        if e.shiftKey
          # Shift + Ctrl + z → Redo
          redo()
        else
          # Ctrl + z → Undo
          undo()
  )

# undo処理
undo = ->
  if operationHistoryIndex <= 0
    flushWarn("Can't Undo")
    return

  history = popOperationHistory()
  obj = history.obj
  pastOperationIndex = obj.popOhi()
  action = history.action
  if action == Constant.ItemActionType.MAKE
    # オブジェクトを消去
    $('#' + obj.elementId()).remove()
  else if action == Constant.ItemActionType.MOVE
    $('#' + obj.elementId()).remove()
    past = operationHistory[pastOperationIndex]
    obj = past.obj
    obj.setSize(past.itemSize)
    obj.reDraw()

# redo処理
redo = ->
  if operationHistory.length <= operationHistoryIndex
    flushWarn("Can't Redo")
    return

  history = popOperationHistoryRedo()
  obj = history.obj
  obj.incrementOhiRegistIndex()
  action = history.action
  if action == Constant.ItemActionType.MAKE
    obj.setSize(history.itemSize)
    obj.reDraw()
  else if action == Constant.ItemActionType.MOVE
    $('#' + obj.elementId()).remove()
    obj.setSize(history.itemSize)
    obj.reDraw()

# サーバにアイテムの情報を保存
saveToServer = ->
  jsonList = []
  itemObjectList.forEach((obj) ->
    j = {
      id: obj.getId()
      obj: obj.generateMinimumObject()
    }
    jsonList.push(j)
  )

  $.ajax(
    {
      url: "/item_state/save_itemstate"
      type: "POST"
      data: {
        user_id: 0
        contents: JSON.stringify(jsonList)
      }
      dataType: "json"
      success: (data)->
        console.log(data.message)
      error: (data) ->
        console.log(data.message)
    }
  )

# サーバからアイテムの情報を取得
loadFromServer = ->
  $.ajax(
    {
      url: "/item_state/load_itemstate"
      type: "POST"
      data: {
        user_id: 0
      }
      dataType: "json"
      success: (data)->
        #console.log(data.message)
        clearWorkTable()
        itemState = JSON.parse(data.item_state)
        contents = JSON.parse(itemState.contents)
        for j in contents
          obj = j.obj
          item = null
          if obj.itemType == Constant.ItemType.BUTTON
            item = new ButtonItem()
          else if obj.itemType == Constant.ItemType.ARROW
            item = new ArrowItem()
          item.loadByMinimumObject(obj)
      error: (data) ->
        console.log(data.message)
    }
  )

### 操作履歴 ###

# 操作履歴をプッシュ
# @param [ItemBase] obj アイテムオブジェクト
pushOperationHistory = (obj) ->
  operationHistory[operationHistoryIndex] = obj
  operationHistoryIndex += 1

# 操作履歴を取り出し
# @return [ItemBase] アイテムオブジェクト
popOperationHistory = ->
  operationHistoryIndex -= 1
  return operationHistory[operationHistoryIndex]

# 操作履歴を取り出してIndexを進める(redo処理)
# @return [ItemBase] アイテムオブジェクト
popOperationHistoryRedo = ->
  obj = operationHistory[operationHistoryIndex]
  operationHistoryIndex += 1
  return obj

### WebStorage保存 ###

# WebStorageから全てのアイテムを描画
drawItemFromStorage = ->

# WebStorageに設定
# @param [Int] id キー
# @param [ItemBase] obj アイテムオブジェクト
addStorage = (id, obj) ->
  storage.setItem(id, obj)

# キーでWebStorageから取得
# @return [ItemBase] アイテムオブジェクト
getStorageByKey = (key) ->
  return storage.getItem(key)

# 画面のアイテムをクリア
clearWorkTable = ->
  itemObjectList.forEach((obj) ->
    $('#' + obj.elementId()).remove()
  )

$ ->
  # ブラウザ対応チェック
  if !checkBlowserEnvironment()
    alert('ブラウザ非対応です。')
    return


  # 共有変数
  initCommonVar()

  #Wrapper & Canvasサイズ
  mainWrapper.css('width', $('#main_container').width())
  $('#canvas_container').attr('width', $('#main_container').width())
  $('#canvas_container').attr('height', $('#main_container').height())

  # カラーピッカー
  initColorPickerValue()

  # ドロップダウン
  $('.dropdown-toggle').dropdown()

  # ヘッダーメニュー
  initHeaderMenu()

  # キーイベント
  initKeyEvent()

  $(document).ready(->
    # コンテキストメニュー
    initContextMenu('contents', '#main_container')
  )