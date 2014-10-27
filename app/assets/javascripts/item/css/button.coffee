class Button extends CanvasBase
  @IDENTITY = "button"
  constructor: (loc = null) ->
    super(loc)
    if loc != null
      @moveLoc = {x:loc.x, y:loc.y}
    @cssStyle = null

  draw: (loc) ->
    if @rect != null
      @restoreDrawingSurface(@rect)

    @rect = {x:null,y:null,w:null,h:null}
    @rect.w = Math.abs(loc.x - @moveLoc.x);
    @rect.h = Math.abs(loc.y - @moveLoc.y);
    if loc.x > @moveLoc.x
      @rect.x = @moveLoc.x
    else
      @rect.x = loc.x
    if loc.y > @moveLoc.y
      @rect.y = @moveLoc.y
    else
      @rect.y = loc.y
    drawingContext.strokeRect(@rect.x, @rect.y, @rect.w, @rect.h)
  endDraw: (loc, zindex) ->
    if !super(loc, zindex)
      return false
    @make()
  make: ->
    emt = $('<div id="' + @elementId() + '" class="draggable resizable" style="position: absolute;top:' + @rect.y + 'px;left: ' + @rect.x + 'px;width:' + @rect.w + 'px;height:' + @rect.h + 'px;z-index:' + @zindex + '"><div type="button" class="css3button"><div></div></div></div>').appendTo('#main-wrapper')
    initContextMenu(emt.attr('id'), '.css3button', Constant.ItemType.BUTTON)
    setDraggableAndResizable(@)
    return true
  reDraw: ->
    @make()

  saveToStorage: ->
    obj = {
      itemType: Constant.ItemType.BUTTON
      startLoc: @startLoc
      rect: @rect
      zindex: @zindex
      cssStyle: @cssStyle
    }
    #console.log(JSON.stringify(obj).length)
    addStorage(@elementId(), JSON.stringify(obj))
    storageHistory[storageHistoryIndex] =  @elementId()
    storageHistoryIndex += 1
    console.log('save id:' + @elementId())

  loadByStorage: (elementId, obj) ->
    @id = elementId.slice(@constructor.IDENTITY.length + 1)
    @rect = obj['rect']
    @zindex = obj['zindex']
    @make()

$ ->
  btnEntryForm = $("#btn-entryForm", sidebarWrapper)
  btnCode = $("#btn-code", cssCode)
  btnPreviewCss = $("#btn-CSS", cssCode)
  configBoxLi = $("div.configBox > div.forms", sidebarWrapper)
  btnGradientStep = $("#btn-gradient-step")
  btnBgColor = $("#btn-bg-color1,#btn-bg-color2,#btn-bg-color3,#btn-bg-color4,#btn-bg-color5,#btn-border-color,#btn-font-color")
  btnShadowColor = $("#btn-shadow-color,#btn-shadowinset-color,#btn-text-shadow1-color,#btn-text-shadow2-color");

  # adjest window height
  #$('#contents').height($('body').height() - $('#nav').height())

  # CSSボタンコントロール初期化

  #スライダー
  settingGradientSlider('btn-slider-gradient', null)
  settingGradientDegSlider('btn-slider-gradient-deg', 0, 315, btnCode, btnPreviewCss)
  settingSlider('btn-slider-border-radius', 0, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-border-width', 0, 10, btnCode, btnPreviewCss)
  settingSlider('btn-slider-font-size', 0, 30, btnCode, btnPreviewCss)
  #settingSlider('btn-slider-padding-left', 0, 30)
  #settingSlider('btn-slider-padding-top', 0, 30)
  settingSlider('btn-slider-shadow-left', -100, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-shadow-opacity', 0.0, 1.0, btnCode, btnPreviewCss, 0.1)
  settingSlider('btn-slider-shadow-size', 0, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-shadow-top', -100, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-shadowinset-left', -100, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-shadowinset-opacity', 0.0, 1.0, btnCode, btnPreviewCss, 0.1)
  settingSlider('btn-slider-shadowinset-size', 0, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-shadowinset-top', -100, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-text-shadow1-left', -100, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-text-shadow1-opacity', 0.0, 1.0, btnCode, btnPreviewCss, 0.1)
  settingSlider('btn-slider-text-shadow1-size', 0, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-text-shadow1-top', -100, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-text-shadow2-left', -100, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-text-shadow2-opacity', 0.0, 1.0, btnCode, btnPreviewCss, 0.1)
  settingSlider('btn-slider-text-shadow2-size', 0, 100, btnCode, btnPreviewCss)
  settingSlider('btn-slider-text-shadow2-top', -100, 100, btnCode, btnPreviewCss)

  # カラーピッカーイベント
  btnBgColor.mousedown( ->
    id = $(this).attr("id"); inputEmt = btnEntryForm.find("#" + id + "-input"); inputValue = inputEmt.attr("value"); btnCodeEmt = cssCode.find("." + id)
    self = $(this)
    settingColorPicker(
      this,
      inputValue,
    (a, b, d) ->
      self.css("backgroundColor", "#" + b)
      inputEmt.attr("value", b)
      btnCodeEmt.text(b)
      btnPreviewCss.text(btnCode.text())
    )
  )
  btnShadowColor.mousedown( ->
    id = $(this).attr("id"); e = configBoxLi.find("#" + id + " div"); inputEmt = btnEntryForm.find("#" + id + "-input"); inputValue = inputEmt.attr("value"); btnCodeEmt = cssCode.find("." + id)
    self = $(this)
    settingColorPicker(
      this,
      inputValue,
    (a, b, d) ->
      self.css("backgroundColor", "#" + b)
      inputEmt.attr("value", b)
      btnCodeEmt.text(d.r + "," + d.g + "," + d.b)
      btnPreviewCss.text(btnCode.text())
    )
  )
#
#  # グラデーションStepイベント
#  btnGradientStep.on('keyup mouseup', (e) ->
#    changeGradientShow(e, btnCode, btnPreviewCss)
#    stepValue = parseInt($(e.currentTarget).val())
#    for i in [2 .. 4]
#      id = 'btn-bg-color' + i; mozFlag = $("#" + id + "-moz-flag"); mozCache = $("#" + id + "-moz-cache"); webkitFlag = $("#" + id + "-webkit-flag"); webkitCache = $("#" + id + "-webkit-cache");
#      if i > stepValue - 1
#        mh = mozFlag.html()
#        if mh.length > 0
#          mozCache.html(mh)
#        wh = webkitFlag.html()
#        if wh.length > 0
#          webkitCache.html(wh)
#        $(mozFlag).empty()
#        $(webkitFlag).empty()
#      else
#        mozFlag.html(mozCache.html());
#        webkitFlag.html(webkitCache.html())
#    btnPreviewCss.text(btnCode.text())
#  ).each( ->
#    stepValue = parseInt($(this).val())
#    for i in [2 .. 4]
#      id = 'btn-bg-color' + i; mozFlag = $("#" + id + "-moz-flag"); mozCache = $("#" + id + "-moz-cache"); webkitFlag = $("#" + id + "-webkit-flag"); webkitCache = $("#" + id + "-webkit-cache");
#      if i > stepValue - 1
#        mh = mozFlag.html()
#        if mh.length > 0
#          mozCache.html(mh)
#        wh = webkitFlag.html()
#        if wh.length > 0
#          webkitCache.html(wh)
#        $(mozFlag).empty()
#        $(webkitFlag).empty()
#    btnPreviewCss.text(btnCode.text())
#  )
  btnPreviewCss.text(btnCode.text());
