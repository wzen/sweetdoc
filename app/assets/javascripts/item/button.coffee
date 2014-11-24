#JS読み込み完了
window.itemLoadedJsPathList['button'] = true

# ボタンアイテム
# @extend ItemBase
class ButtonItem extends ItemBase
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "button"
  # @property [String] ITEMTYPE アイテム種別
  @ITEMTYPE = Constant.ItemType.BUTTON

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null) ->
    super(cood)
    if cood != null
      @moveLoc = {x:cood.x, y:cood.y}
    @cssStyle = null

  # 描画
  # @param [Array] cood 座標
  draw: (cood) ->
    if @itemSize != null
      @restoreDrawingSurface(@itemSize)

    @itemSize = {x:null,y:null,w:null,h:null}
    @itemSize.w = Math.abs(cood.x - @moveLoc.x);
    @itemSize.h = Math.abs(cood.y - @moveLoc.y);
    if cood.x > @moveLoc.x
      @itemSize.x = @moveLoc.x
    else
      @itemSize.x = cood.x
    if cood.y > @moveLoc.y
      @itemSize.y = @moveLoc.y
    else
      @itemSize.y = cood.y
    drawingContext.strokeRect(@itemSize.x, @itemSize.y, @itemSize.w, @itemSize.h)

  # 描画終了時の処理
  # @param [Array] cood 座標
  # @param [Int] zindex z-index
  # @return [Boolean] 処理結果
  endDraw: (zindex) ->
    if !super(zindex)
      return false
    @makeElement()

  # 再描画処理
  reDraw: ->
    @makeElement()

  # HTML要素を作成
  # @return [Boolean] 処理結果
  makeElement: ->
    $(ElementCode.get().createItemElement(@)).appendTo('#main-wrapper')
    @setupEvents()
    return true

  # ストレージとDB保存用の最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  generateMinimumObject: ->
    obj = {
      itemType: Constant.ItemType.BUTTON
      mousedownCood: @mousedownCood
      itemSize: @itemSize
      zindex: @zindex
      cssStyle: @cssStyle
    }
    return obj

  # 最小限のデータからアイテムを描画
  # @param [Array] obj アイテムオブジェクトの最小限データ
  loadByMinimumObject: (obj) ->
    #@id = elementId.slice(@constructor.IDENTITY.length + 1)
    @mousedownCood = obj.mousedownCood
    @itemSize = obj.itemSize
    @zindex = obj.zindex
    @cssStyle = obj.cssStyle
    @reDraw()
    @saveObj(Constant.ItemActionType.MAKE)

# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList.buttonInit?
  window.itemInitFuncList.buttonInit = ->
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
