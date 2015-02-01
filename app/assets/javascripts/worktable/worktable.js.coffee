# ワークテーブル読み込みフラグ
window.worktablePage = true

# ワークテーブル用アイテム拡張モジュール
# 共通
WorkTableCommonExtend =
  # オプションメニューを開く
  showOptionMenu: ->
    sc = $('.sidebar-config')
    sc.css('display', 'none')
    $('.dc', sc).css('display', 'none')
    $('#design-config').css('display', '')
    $('#' + @getDesignConfigId()).css('display', '')

  # タイムラインイベントの選択内容を更新
  updateTimelineEventSelect: ->

# CSS
WorkTableCssItemExtend =
  # デザイン変更コンフィグを作成
  makeDesignConfig: ->
    @designConfigRoot = $('#' + @getDesignConfigId())
    if !@designConfigRoot? || @designConfigRoot.length == 0
      @designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', @getDesignConfigId())
      @designConfigRoot.removeClass('design_temp')
      cssConfig = @designConfigRoot.find('.css-config')
      @designConfigRoot.find('.css-config').css('display', '')
      @designConfigRoot.find('.canvas-config').remove()
      $('#design-config').append(@designConfigRoot)

  # ドラッグ時のイベント
  drag: ->
    element = $('#' + @id)
    @itemSize.x = element.position().left
    @itemSize.y = element.position().top
  # リサイズ時のイベント
  resize: ->
    element = $('#' + @id)
    @itemSize.w = element.width()
    @itemSize.h = element.height()

  # 履歴データを取得
  # @param [ItemActionType] action アクション種別
  getHistoryObj: (action) ->
    obj = {
      obj: @
      action : action
      itemSize: makeClone(@itemSize)
    }
    return obj

  # 履歴データを設定
  setHistoryObj: (historyObj) ->
    @itemSize = makeClone(historyObj.itemSize)

# Canvas
WorkTableCanvasItemExtend =
# デザイン変更コンフィグを作成
  makeDesignConfig: ->
    @designConfigRoot = $('#' + @getDesignConfigId())
    if !@designConfigRoot? || @designConfigRoot.length == 0
      @designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', @getDesignConfigId())
      @designConfigRoot.removeClass('design_temp')
      @designConfigRoot.find('.canvas-config').css('display', '')
      @designConfigRoot.find('.css-config').remove()
      $('#design-config').append(@designConfigRoot)

# ドラッグ時のイベント
  drag: ->
    element = $('#' + @id)
    @itemSize.x = element.position().left
    @itemSize.y = element.position().top
    console.log("drag: itemSize: #{JSON.stringify(@itemSize)}")

# リサイズ時のイベント
  resize: ->
    canvas = $('#' + @canvasElementId())
    element = $('#' + @id)
    @scale.w = element.width() / @itemSize.w
    @scale.h = element.height() / @itemSize.h
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.scale(@scale.w, @scale.h)
    @drawNewCanvas()
    console.log("resize: itemSize: #{JSON.stringify(@itemSize)}")

# 履歴データを取得
# @param [ItemActionType] action アクション種別
  getHistoryObj: (action) ->
    obj = {
      obj: @
      action : action
      itemSize: makeClone(@itemSize)
      scale: makeClone(@scale)
    }
    console.log("getHistory: scale:#{@scale.w},#{@scale.h}")
    return obj

# 履歴データを設定
# @param [Array] historyObj 履歴オブジェクト
  setHistoryObj: (historyObj) ->
    @itemSize = makeClone(historyObj.itemSize)
    @scale = makeClone(historyObj.scale)
    console.log("setHistoryObj: itemSize: #{JSON.stringify(@itemSize)}")

# 共有変数定義
initCommonVar = ->
  window.sidebarWrapper = $("#sidebar-wrapper")
  window.scrollContents = $('#scroll_contents')
  window.scrollInside = $('#scroll_inside')
  window.cssCode = $("#cssCode")
  window.messageTimer = null
  window.flushMessageTimer = null
  window.mode = Constant.Mode.DRAW
  window.lstorage = localStorage
  window.itemObjectList = []
  window.itemInitFuncList = []
  window.operationHistory = []
  window.operationHistoryIndex = 0
  window.scrollViewMag = 500

  # WebStorageを初期化する
  lstorage.clear()

  # 初期状態としてボタンを選択(暫定)
  window.selectItemMenu = Constant.ItemType.BUTTON
  loadItemJs(Constant.ItemType.BUTTON)

# 手書きイベント初期化
initHandwrite = ->
  drag = false
  click = false
  lastX = null; lastY = null
  item = null
  enableMoveEvent = true
  queueLoc = null
  zindex = 1
  MOVE_FREQUENCY = 7

  # ウィンドウ座標からCanvas座標に変換する
  # @param [Object] canvas Canvas
  # @param [Int] x x座標
  # @param [Int] y y座標
  windowToCanvas = (canvas, x, y) ->
    bbox = canvas.getBoundingClientRect()
    return {x: x - bbox.left * (canvas.width  / bbox.width), y: y - bbox.top  * (canvas.height / bbox.height)}

  # マウスダウン時の描画イベント
  # @param [Array] loc Canvas座標
  mouseDownDrawing = (loc) ->
    if selectItemMenu == Constant.ItemType.ARROW
      item = new WorkTableArrowItem(loc)
    else if selectItemMenu == Constant.ItemType.BUTTON
      item = new WorkTableButtonItem(loc)
    item.saveDrawingSurface()
    changeMode(Constant.Mode.DRAW)
    item.startDraw()

  # マウスドラッグ時の描画イベント
  # @param [Array] loc Canvas座標
  mouseMoveDrawing = (loc) ->
    if enableMoveEvent
      enableMoveEvent = false
      drag = true
      item.draw(loc)

      # 待ちキューがある場合はもう一度実行
      if queueLoc != null
        q = queueLoc
        queueLoc = null
        item.draw(q)

      enableMoveEvent = true
    else
      # 待ちキューに保存
      queueLoc = loc

  # マウスアップ時の描画イベント
  # @param [Array] loc Canvas座標
  mouseUpDrawing = ->
    item.restoreAllDrawingSurface()
    item.endDraw(zindex)
    setupEvents(item)
    changeMode(Constant.Mode.EDIT)
    item.saveObj(Constant.ItemActionType.MAKE)
    item.setAllItemPropToPageValue()
    zindex += 1

  # 手書きイベントを設定
  do =>

    # 画面のウィンドウ座標からCanvas座標に変換
    # @param [Array] e ウィンドウ座標
    # @return [Array] Canvas座標
    calcCanvasLoc = (e)->
      x = e.x || e.clientX
      y = e.y || e.clientY
      return windowToCanvas(drawingCanvas, x, y)

    # 座標の状態を保存
    # @param [Array] loc 座標
    saveLastLoc = (loc) ->
      lastX = loc.x
      lastY = loc.y

    # マウスダウンイベント
    # @param [Array] e ウィンドウ座標
    drawingCanvas.onmousedown = (e) ->
      if e.which == 1 #左クリック
        loc = calcCanvasLoc(e)
        saveLastLoc(loc)
        click = true
        if mode == Constant.Mode.DRAW
          e.preventDefault()
          mouseDownDrawing(loc)
        else if mode == Constant.Mode.OPTION
          # サイドバーを閉じる
          closeSidebar()
          changeMode(Constant.Mode.EDIT)

    # マウスドラッグイベント
    # @param [Array] e ウィンドウ座標
    drawingCanvas.onmousemove = (e) ->
      if e.which == 1 #左クリック
        loc = calcCanvasLoc(e)
        if click &&
          Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY
            if mode == Constant.Mode.DRAW
              e.preventDefault()
              mouseMoveDrawing(loc)
            saveLastLoc(loc)

    # マウスアップイベント
    # @param [Array] e ウィンドウ座標
    drawingCanvas.onmouseup = (e) ->
      if e.which == 1 #左クリック
        if drag && mode == Constant.Mode.DRAW
          e.preventDefault()
          mouseUpDrawing()
      drag = false
      click = false

# イベントを設定する
setupEvents = (obj) ->
  # コンテキストメニュー設定
  do ->
    menu = [{title: "Delete", cmd: "delete", uiIcon: "ui-icon-scissors"}]
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
        obj.saveObj(Constant.ItemActionType.MOVE)
    })
    obj.getJQueryElement().resizable({
      containment: scrollInside
      resize: (event, ui) ->
        if obj.resize?
          obj.resize()
      stop: (event, ui) ->
        obj.saveObj(Constant.ItemActionType.MOVE)
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

# コンテキストメニュー初期化
# @param [String] elementID HTML要素ID
# @param [String] contextSelector
# @param [Array] menu 表示メニュー
setupContextMenu = (element, contextSelector, menu) ->

  # オプションメニューを初期化
  initOptionMenu = (event) ->
    emt = $(event.target)
    obj = getObjFromObjectListByElementId(emt.attr('id'))
    if obj? && obj.setupOptionMenu?
      # 初期化関数を呼び出す
      obj.setupOptionMenu()
    if obj? && obj.showOptionMenu?
      # オプションメニュー表示処理
      obj.showOptionMenu()

  element.contextmenu(
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
        # カラーピッカー値を初期化
        initColorPickerValue()
        # オプションメニューの値を初期化
        initOptionMenu(event)
        # オプションメニューを表示
        openConfigSidebar($target)
        # モードを変更
        changeMode(Constant.Mode.OPTION)

      beforeOpen: (event, ui) ->
        # 選択メニューを最前面に表示
        ui.menu.zIndex( $(event.target).zIndex() + 1)
    }
  )

# 要素IDでオブジェクトリストから対象のオブジェクトを取得
getObjFromObjectListByElementId = (emtId) ->
  obj = null
  itemObjectList.forEach((o) ->
    if emtId == o.id
      obj = o
  )
  return obj

### スライダーの作成 ###

# 通常スライダーの作成
# @param [Int] id メーターのElementID
# @param [Int] min 最小値
# @param [Int] max 最大値
# @param [Object] cssCode コードエレメント
# @param [Object] cssStyle CSSプレビューのエレメント
# @param [Int] stepValue 進捗数
settingSlider = (className, min, max, cssCode, cssStyle, root, stepValue = 0) ->
  meterElement = $('.' + className, root)
  valueElement = $('.' + className + '-value', root)
  d = $('.' + className + '-value', cssCode)[0]
  defaultValue = $(d).html()
  valueElement.val(defaultValue)
  valueElement.html(defaultValue)
  try
    meterElement.slider('destroy')
  catch
  meterElement.slider({
    min: min,
    max: max,
    step: stepValue,
    value: defaultValue
    slide: (event, ui)->
      valueElement.val(ui.value)
      valueElement.html(ui.value)
      cssStyle.text(cssCode.text())
  })

# HTML要素からグラデーションスライダーの作成
# @param [Object] element HTML要素
# @param [Array] values 値の配列
# @param [Object] cssCode コードエレメント
# @param [Object] cssStyle CSSプレビューのエレメント
settingGradientSliderByElement = (element, values, cssCode, cssStyle) ->
  id = element.attr("id")

  try
    element.slider('destroy')
  catch
  element.slider({
    values: values
    slide: (event, ui) ->
      index = $(ui.handle).index()
      position = $('.btn-bg-color' + (index + 2) + '-position', cssCode)
      position.html(ui.value)
      cssStyle.text(cssCode.text())
  })

  handleElement = element.children('.ui-slider-handle')
  if values == null
    handleElement.css('display', 'none')
  else
    handleElement.css('display', '')

# グラデーションスライダーの作成
# @param [Int] id HTML要素のID
# @param [Array] values 値の配列
# @param [Object] cssCode コードエレメント
# @param [Object] cssStyle CSSプレビューのエレメント
settingGradientSlider = (className, values, cssCode, cssStyle, root) ->
  meterElement = $('.' + className, root)
  settingGradientSliderByElement(meterElement, values, cssCode, cssStyle)


# グラデーション方向スライダーの作成
# @param [Int] id メーターのElementID
# @param [Int] min 最小値
# @param [Int] max 最大値
# @param [Object] cssCode コードエレメント
# @param [Object] cssStyle CSSプレビューのエレメント
settingGradientDegSlider = (className, min, max, cssCode, cssStyle, root) ->
  meterElement = $('.' + className, root)
  valueElement = $('.' + className + '-value', root)
  webkitValueElement = $('.' + className + '-value-webkit', root)
  d = $('.' + className + '-value', cssCode)[0]
  defaultValue = $(d).html()
  webkitDeg = {0 : 'left top, left bottom', 45 : 'right top, left bottom', 90 : 'right top, left top', 135 : 'right bottom, left top', 180 : 'left bottom, left top', 225 : 'left bottom, right top', 270 : 'left top, right top', 315: 'left top, right bottom'}

  valueElement.val(defaultValue)
  valueElement.html(defaultValue)
  webkitValueElement.html(webkitDeg[defaultValue])

  try
    meterElement.slider('destroy')
  catch
  meterElement.slider({
    min: min,
    max: max,
    step: 45,
    value: defaultValue
    slide: (event, ui)->
      valueElement.val(ui.value)
      valueElement.html(ui.value)
      webkitValueElement.html(webkitDeg[ui.value])
      cssStyle.text(cssCode.text())
  })
### スライダーの作成 ここまで ###

### グラデーション ###

# グラデーションの表示変更(スライダーのハンドル&カラーピッカー)
# @param [Object] element HTML要素
# @param [Object] cssCode コードエレメント
# @param [Object] cssStyle CSSプレビューのエレメント
changeGradientShow = (targetElement, cssCode, cssStyle, cssConfig) ->
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

    settingGradientSliderByElement(meterElement, values, cssCode, cssStyle)
    switchGradientColorSelectorVisible(value, cssConfig)

# グラデーションのカラーピッカー表示切り替え
# @param [Int] gradientStepValue 現在のグラデーション数
switchGradientColorSelectorVisible = (gradientStepValue, cssConfig) ->
  for i in [2 .. 4]
    element = $('.btn-bg-color' + i, cssConfig)
    if i > gradientStepValue - 1
      element.css('display', 'none')
    else
      element.css('display', '')

### グラデーション ここまで ###

# ヘッダーメニュー初期化
initHeaderMenu = ->
  itemsMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
  $('.menu-load', itemsMenuEmt).on('click', ->
    loadFromServer()
  )
  $('.menu-save', itemsMenuEmt).on('click', ->
    saveToServer()
  )

  itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
  $('.menu-item', itemsSelectMenuEmt).on('click', ->
    # TODO: 取り方見直す
    itemType = parseInt($(this).attr('id').replace('menu-item-', ''))
    itemsSelectMenuEmt.removeClass('active')
    $(@).parent('li').addClass('active')
    window.selectItemMenu = itemType
    changeMode(Constant.Mode.DRAW)
    loadItemJs(itemType)
  )

# アイテムのJSファイル初期化関数名を取得
# @param [Int] itemType アイテム種別
getInitFuncName = (itemType) ->
  itemName = Constant.ITEM_PATH_LIST[itemType]
  # TODO: ハイフンが途中にあるものはキャメルに変換
  return itemName + "Init"

# JSファイルをサーバから読み込む
# @param [Int] itemType アイテム種別
# @param [Function] callback コールバック関数
loadItemJs = (itemType, callback = null) ->
  itemInitFuncName = getInitFuncName(itemType)
  if window.itemInitFuncList[itemInitFuncName]?
    # 既に読み込まれている場合はコールバックのみ実行
    window.itemInitFuncList[itemInitFuncName]()
    if callback?
      callback()
    return

  # js読み込み
  $.ajax(
    {
      url: "/item_js/index"
      type: "POST"
      dataType: "json"
      data: {
        itemId: itemType
      }
      success: (data)->
        if data.css_info?
          option = {isWorkTable: true, css_temp: data.css_info}

        availJs(itemInitFuncName, data.js_src, option, callback)
        addTimelineEventContents(data.te_actions, data.te_values)

      error: (data) ->
    }
  )

# JSファイルを設定
# @param [String] initName アイテム初期化関数名
# @param [String] jsSrc jsファイル名
# @param [Function] callback 設定後のコールバック
availJs = (initName, jsSrc, option = {}, callback = null) ->
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

# タイムラインイベントのUIを追加
# @param [String] contents 追加するHTMLの文字列
addTimelineEventContents = (te_actions, te_values) ->
  if !te_actions?
    return
  if !te_values?
    return


# カラーピッカーの作成
# @param [Object] element HTML要素
createColorPicker = (element) ->
  $(element).ColorPicker({})

# カラーピッカーの設定
# @param [Object] element HTML要素
# @param [Color] changeColor 変更色
# @param [Function] onChange 変更時に呼ばれるメソッド
settingColorPicker = (element, changeColor, onChange) ->
  emt = $(element)
  emt.ColorPickerSetColor(changeColor)
  emt.ColorPickerResetOnChange(onChange)

#カラーピッカー値の初期化(アイテムのコンテキスト表示時に設定)
initColorPickerValue = ->
  $('.colorPicker', sidebarWrapper).each( ->
    id = $(this).attr('id')
    color = $('.' + id, cssCode).html()
    $(this).css('backgroundColor', '#' + color)
    inputEmt = sidebarWrapper.find('#' + id + '-input')
    inputEmt.attr('value', color)
  )

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
  itemObjectList.forEach((obj) ->
    # オブジェクトのイベントをクリア
    obj.clearAllEventStyle()
  )
  # 選択枠を取る
  clearSelectedBorder()
  # 全てのカラーピッカーを閉じる
  $('.colorPicker').ColorPickerHide()

### サイドバー ###

# サイドバーをオープン
# @param [Array] target フォーカス対象オブジェクト
# @param [String] selectedBorderType 選択枠タイプ
openConfigSidebar = (target = null, selectedBorderType = "edit") ->
  main = $('#main')
  if !isOpenedConfigSidebar()
    main.switchClass('col-md-12', 'col-md-9', 500, 'swing', ->
      $('#sidebar').fadeIn('1000')
    )
    if target != null
      focusToTargetWhenSidebarOpen(target, selectedBorderType)

# サイドバーをクローズ
closeSidebar = ->
  main = $('#main')
  if !isClosedConfigSidebar()
    $('#sidebar').fadeOut('1000', ->
      s = getPageValue(Constant.PageValueKey.CONFIG_OPENED_SCROLL)
      if s?
        scrollContents.animate({scrollTop: s.top, scrollLeft: s.left}, 500, null, ->
          removePageValue(Constant.PageValueKey.CONFIG_OPENED_SCROLL)
        )
      main.switchClass('col-md-9', 'col-md-12', 500, 'swing')
      $('.sidebar-config').css('display', 'none')
    )

# サイドバーがオープンしているか
isOpenedConfigSidebar = ->
  return $('#main').hasClass('col-md-9')

# サイドバーがクローズしているか
isClosedConfigSidebar = ->
  return $('#main').hasClass('col-md-12')

# サイドバー内容のスイッチ
# @param [String] configType コンフィグタイプ
switchSidebarConfig = (configType, item = null) ->
  animation = isOpenedConfigSidebar()
  $('.sidebar-config').css('display', 'none')
  if configType == "css" && item? && item.cssConfig?
    if animation
      item.cssConfig.show()
    else
      item.cssConfig.css('display', '')
  else if configType == "canvas" && item? && item.canvasConfig?
    if animation
      item.canvasConfig.show()
    else
      item.canvasConfig.css('display', '')
  else if configType == "timeline"
    if animation
      $('#timeline-config').show()
    else
      $('#timeline-config').css('display', '')

# 対象アイテムに対してフォーカスする(サイドバーオープン時)
# @param [Object] target 対象アイテム
# @param [String] selectedBordfcccccccccccccccerType 選択枠タイプ
focusToTargetWhenSidebarOpen = (target, selectedBorderType = "edit") ->
  # 選択枠設定
  setSelectedBorder(target, selectedBorderType)
  # 変更前のスライド値を保存
  setPageValue(Constant.PageValueKey.CONFIG_OPENED_SCROLL, {top: scrollContents.scrollTop(), left: scrollContents.scrollLeft()}, true)
  focusToTarget(target)

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
      if e.keyCode == Constant.KeyboardKeyCode.Z
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
    obj.getJQueryElement().remove()
  else if action == Constant.ItemActionType.MOVE
    obj.getJQueryElement().remove()
    past = operationHistory[pastOperationIndex]
    obj = past.obj
    obj.setHistoryObj(past)
    obj.reDraw()
    console.log("undo: itemSize: #{JSON.stringify(obj.itemSize)}")
    setupEvents(obj)
    console.log("undo2: itemSize: #{JSON.stringify(obj.itemSize)}")

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
    obj.setHistoryObj(history)
    obj.reDraw()
    setupEvents(obj)
  else if action == Constant.ItemActionType.MOVE
    obj.getJQueryElement().remove()
    obj.setHistoryObj(history)
    obj.reDraw()
    setupEvents(obj)

# サーバにアイテムの情報を保存
saveToServer = ->
  jsonList = []
  itemObjectList.forEach((obj) ->
    j = {
      id: makeClone(obj.id)
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
        state: JSON.stringify(jsonList)
      }
      dataType: "json"
      success: (data)->
        console.log(data.message)
      error: (data) ->
        console.log(data.message)
    }
  )

# サーバからアイテムの情報を取得して描画
loadFromServer = ->
  $.ajax(
    {
      url: "/item_state/load_itemstate"
      type: "POST"
      data: {
        user_id: 0
        loaded_item_type_list : JSON.stringify(loadedItemTypeList)
      }
      dataType: "json"
      success: (data)->

        # 全て読み込んだ後のコールバック
        callback = ->
          clearWorkTable()
          itemList = JSON.parse(data.item_list)
          for j in itemList
            obj = j.obj
            item = null
            if obj.itemType == Constant.ItemType.BUTTON
              item = new WorkTableButtonItem()
            else if obj.itemType == Constant.ItemType.ARROW
              item = new WorkTableArrowItem()
            item.reDrawByMinimumObject(obj)
            setupEvents(item)

        # CSS情報を設置
        if data.css_info_list?
          cssInfoList = JSON.parse(data.css_info_list)
          cssInfoList.forEach((cssInfo)->
            $('#css_code_info').append(cssInfo)
          )

        # JS読み込み
        jsList = JSON.parse(data.js_list)
        if jsList.length == 0
          callback()
          return
        loadedCount = 0
        jsList.forEach((js)->
          option = {isWorkTable: true, css_temp: js.css_temp}
          availJs( getInitFuncName(js.item_type), js.src, option, ->
            loadedCount += 1
            if loadedCount >= jsList.length
              # 全て読み込んだ後
              callback()
          )
        )
        #console.log(data.message)

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
  lstorage.setItem(id, obj)

# キーでWebStorageから取得
# @return [ItemBase] アイテムオブジェクト
getStorageByKey = (key) ->
  return lstorage.getItem(key)

# 画面のアイテムをクリア
clearWorkTable = ->
  itemObjectList.forEach((obj) ->
    obj.getJQueryElement().remove()
  )

### デバッグ ###
runDebug = ->
  item = itemObjectList[0]
  if item.reDrawByObjPageValue()
    setupEvents(item)

### タイムライン ###

# タイムラインのイベント設定
setupTimelineEvents = ->
  self = @

  # イベント初期化
  initEvents = (e) ->
    if $(e).is('.ui-sortable-helper')
      # ドラッグの場合はクリック反応なし
      return

    setSelectedBorder(e, "timeline")
    switchSidebarConfig("timeline")
    $(".config.te_div", emt).css('display', 'none')

    # イベントメニューの存在チェック
    te_num = $(e).find('input.te_num').val()
    eId = Constant.ElementAttribute.TE_ITEM_ROOT_ID.replace('@te_num', te_num)
    emt = $('#' + eId)
    if emt.length == 0
      # イベントメニューの作成
      emt = $('#timeline-config .timeline_temp .event').clone(true).attr('id', eId)
      $('#timeline-config').append(emt)

    # JSイベントの追加
    do =>
      em = $('.te_item_select', emt)
      em.off('change')
      em.on('change', (e) ->
        timelineItemSelect(@)
      )
      em = $('.push.button.cancel', emt)
      em.off('click')
      em.on('click', (e) ->
        closeSidebar()
      )

    # イベントメニューの表示
    $('#timeline-config .event').css('display', 'none')
    emt.css('display', '')

    if !isOpenedConfigSidebar()
      # タイムラインのconfigをオープンする
      openConfigSidebar()


    # コンフィグ初期化
    if $(e).hasClass('blank')
      # ブランク
      # アイテムのリストを表示


    else
      # イベント設定済み


  # イベントのクリック
  $('.timeline_event').off('click')
  $('.timeline_event').on('click', (e) ->
    initEvents.call(self, @)
  )

  # イベントのD&D
  $('#timeline_events').sortable({
    revert: true
    axis: 'x'
    containment: $('#timeline_events_container')
    items: '.sortable'
    stop: (event, ui) ->
      # イベントのソート番号を更新
  })

# タイムライン アイテム選択イベント
timelineItemSelect = (e) ->
  emt = $(e).parents('.event')
  v = $(e).val()
  d = null
  if v.indexOf('c_') == 0
    # 共通 → 変更値を表示
    d = "values_div"
  else
    # アイテム → アクション名一覧を表示
    d = "action_div"
    # フォーカス


  $(".config.te_div", emt).css('display', 'none')
  $(".#{d} .forms", emt).children("div").css('display', 'none')
  $(".#{d} .#{v}", emt).css('display', '')
  $(".#{d}", emt).css('display', '')

# タイムライン アクション名選択イベント
timelineActionSelect = (e) ->
  emt = $(e).parents('.event')


# タイムラインのオブジェクトをまとめる
setupTimeLineObjects = ->
  # 処理は暫定(itemObjectListから取っているが、本当はタイムラインの情報を取る)

  # Storageに値を格納
  # とりあえず矢印だけ
  objList = []
  itemObjectList.forEach((item) ->
    obj = {
      chapter: 1
      screen: 1
      miniObj: item.generateMinimumObject()
      itemSize: item.itemSize
      sEvent: "scrollDraw"
      cEvent: "defaultClick"
    }
    objList.push(obj)
  )
  return objList

# タイムラインのCSSをまとめる
setupTimeLineCss = ->
  itemCssStyle = ""
  $('#css_code_info').find('.css-style').each( ->
    itemCssStyle += $(this).html()
  )
  # 暫定処理
  itemObjectList.forEach((item) ->
    if ButtonItem? && item instanceof ButtonItem
      # cssアニメーション
      itemCssStyle += ButtonItem.dentButton(item)
  )

  return itemCssStyle

### 閲覧 ###

# 閲覧を実行する
run = ->
  Function.prototype.toJSON = Function.prototype.toString
  lstorage.setItem('timelineObjList', JSON.stringify(setupTimeLineObjects()))
  lstorage.setItem('loadedItemTypeList', JSON.stringify(loadedItemTypeList))
  lstorage.setItem('itemCssStyle', setupTimeLineCss())
  window.open('/run')

$ ->
  # ブラウザ対応チェック
  if !checkBlowserEnvironment()
    alert('ブラウザ非対応です。')
    return

  # 共有変数
  initCommonVar()
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
  setupTimelineEvents()
