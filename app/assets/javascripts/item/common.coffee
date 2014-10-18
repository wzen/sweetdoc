### 定数 ###
class Constant
  @RESTORE_MARGIN = 5
  @ZINDEX_TOP = 1000

  # 操作履歴保存
  @OPERATION_STORE_PREFIX = "o_"
  @OPERATION_STORE_MAX = 30

  class @MODE
    @DRAW:0
    @EDIT:1
    @OPTION:2
  class @ItemType
    @ARROW: 0
    @BUTTON: 1
  class @keyboardKeyCode
    @z : 90

### Canvas基底クラス ###
class CanvasBase
  constructor: (loc)->
    @id = generateId()
    @drawingSurfaceImageData = null
    @startLoc = {x:loc.x, y:loc.y}
    @rect = null
  getId: -> @id
  getRect: -> @rect
  saveDrawingSurface : ->
    @drawingSurfaceImageData = drawingContext.getImageData(0, 0, drawingCanvas.width, drawingCanvas.height)
  restoreAllDrawingSurface : ->
    drawingContext.putImageData(@drawingSurfaceImageData, 0, 0)
  restoreDrawingSurface : (rect) ->
    drawingContext.putImageData(@drawingSurfaceImageData, 0, 0, rect.x - Constant.RESTORE_MARGIN, rect.y - Constant.RESTORE_MARGIN, rect.w + Constant.RESTORE_MARGIN * 2, rect.h + Constant.RESTORE_MARGIN * 2)
  startDraw: ->
    changeMode(Constant.MODE.DRAW)
  endDraw: (loc, containerState, zindex) ->
    changeMode(Constant.MODE.EDIT)
    if isClick.call(@, loc)
      return false
    containerState.save(this, zindex)
    return true
  isClick = (loc) ->
    return loc.x == @startLoc.x && loc.y == @startLoc.y


### コンテナ状態保存 ###
class ContainerState
  @storage = localStorage

  constructor: ->
    @itemStates = []
  save: (obj, zindex) ->
    iState = new ItemState(obj, zindex)
    @itemStates.push(iState)
  dbSave: ->

  dbLoad: ->

  class ItemState
    constructor: (obj, zindex) ->
      @zindex = zindex
      @obj = obj
      # ↓後回し
      @cssCode = null

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
setDraggableAndResizable = (emt)->
#  emt.on('mousedown', (e) ->
#    e.stopPropagation()
#  )
  emt.draggable({
    containment: mainWrapper
  })
  emt.resizable({
    containment: mainWrapper
  })

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

# エレメントでグラデーションスライダーの作成
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
settingGradientSlider = (id, values, codeEmt, previewEmt) ->
  meterElement = $('#' + id)
  settingGradientSliderByElement(meterElement, values, codeEmt, previewEmt)


# グラデーションDegスライダーの作成
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
switchGradientColorSelectorVisible = (gradientStepValue) ->
  for i in [2 .. 4]
    element = $('#btn-bg-color' + i)
    if i > gradientStepValue - 1
      element.css('display', 'none')
    else
      element.css('display', '')
### グラデーション ここまで ###

### ヘッダーメニュー ここから ###
initHeaderMenu = ->
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

### ヘッダーメニュー ここまで ###

# カラーピッカーの作成
settingColorPicker = (ele, defaultColor, onChange) ->
  $(ele).ColorPicker({
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
initContextMenu = (id, contextSelector, itemType = null) ->

  # 共通メニュー
  menu = [
    {title: "Delete", cmd: "delete", uiIcon: "ui-icon-scissors"}
  ]

  # アイテム個別メニュー
  if itemType == Constant.ItemType.ARROW
    menu.push(
      {title: "Arrow", cmd: "cut", uiIcon: "ui-icon-scissors"}
    )
  else if itemType == Constant.ItemType.BUTTON
    menu.push(
      {title: "Button", cmd: "cut", uiIcon: "ui-icon-scissors"}
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

### モードチェンジ ###
changeMode = (mode) ->
  if mode == Constant.MODE.DRAW
    $(window.drawingCanvas).css('z-index', Constant.ZINDEX_TOP)
  else if mode == Constant.MODE.EDIT
    $(window.drawingCanvas).css('z-index', 0)
  else if mode == Constant.MODE.OPTION
    $(window.drawingCanvas).css('z-index', Constant.ZINDEX_TOP)
  window.mode = mode

### サイドバー ###
openSidebar = (scrollWidth = null) ->
  $('#main').switchClass('col-md-12', 'col-md-9', 500, 'swing', ->
    $('#sidebar').fadeIn('1000')
  )
  if scrollWidth != null
    mainScroll.animate({scrollLeft: scrollWidth}, 500)

closeSidebar = ->
  $('#sidebar').fadeOut('1000', ->
    mainScroll.animate({scrollLeft: 0}, 500)
    $('#main').switchClass('col-md-9', 'col-md-12', 500, 'swing')
  )

### ###
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

#警告表示
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

#エラー表示
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

#警告表示(フラッシュ)
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

#キーイベント
initKeyEvent = ->
  $(window).keydown( (e)->
    e.preventDefault()
    isMac = navigator.platform.toUpperCase().indexOf('MAC')>=0;
    if (isMac && e.metaKey) ||  (!isMac && e.ctrlKey)
      if e.keyCode == Constant.keyboardKeyCode.z
        if e.shiftKey
          # Shift + Ctrl + z → Redo
          flushWarn("Redo")
        else
          # Ctrl + z → Undo
          flushWarn("Undo")
  )

$ ->
  # 共有変数
  initCommonVar()

  #initDraggableAndResizable()

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