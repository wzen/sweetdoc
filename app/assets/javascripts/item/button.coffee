#JS読み込み完了
window.loadedItemTypeList.push(Constant.ItemType.BUTTON)

# ボタンアイテム
# @extend CssItemBase
class ButtonItem extends CssItemBase
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
    @setMiniumObject(obj)
    @reDraw()
    @saveObj(Constant.ItemActionType.MAKE)


  # 最小限のデータを設定
  setMiniumObject: (obj) ->
    @mousedownCood = obj.mousedownCood
    @itemSize = obj.itemSize
    @zindex = obj.zindex
    @cssStyle = obj.cssStyle

  # クリックイベント
  actorClickEvent: (e) ->
    @nextChapter()


# ワークテーブル用ボタンクラス
class WorkTableButtonItem extends ButtonItem
  # @property [String] CSSTEMPID CSSテンプレートID
  @CSSTEMPID = "button_css_temp"

  # オプションメニュー
  @btnEntryForm = $("#btn-entryForm", $("#sidebar-wrapper"))
  @configBoxLi = $("div.configBox > div.forms", $("#sidebar-wrapper"))
  @btnGradientStep = $("#btn-gradient-step")
  @btnBgColor = $("#btn-bg-color1,#btn-bg-color2,#btn-bg-color3,#btn-bg-color4,#btn-bg-color5,#btn-border-color,#btn-font-color")
  @btnShadowColor = $("#btn-shadow-color,#btn-shadowinset-color,#btn-text-shadow1-color,#btn-text-shadow2-color");

  constructor: (cood = null) ->
    super(cood)
    @cssRoot = null
    @cssCode = null
    @cssStyle = null

  # CSSのルートのIDを取得
  getCssRootElementId: ->
    return "css-" + @id

  # HTML要素とCSSを作成
  # @return [Boolean] 処理結果
  makeElement: ->
    super()
    # CSSテンプレートからオブジェクト個別のCSSを作成
    newEmt = $('#' + WorkTableButtonItem.CSSTEMPID).clone(true).attr('id', @getCssRootElementId())
    newEmt.find('.btn-item-id').html(@getElementId())
    $('#css_code_info').append(newEmt)

    @cssRoot = $('#' + @getCssRootElementId())
    @cssCode = $(".css-code", @cssRoot)
    @cssStyle = $(".css-style", @cssRoot)
    @cssStyle.text(@cssCode.text())

    return true

  # CSSボタンコントロール初期化
  setupOptionMenu: ->
    #スライダー
    settingGradientSlider('btn-slider-gradient', null)
    settingGradientDegSlider('btn-slider-gradient-deg', 0, 315, @cssCode, @cssStyle)
    settingSlider('btn-slider-border-radius', 0, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-border-width', 0, 10, @cssCode, @cssStyle)
    settingSlider('btn-slider-font-size', 0, 30, @cssCode, @cssStyle)
    #settingSlider('btn-slider-padding-left', 0, 30)
    #settingSlider('btn-slider-padding-top', 0, 30)
    settingSlider('btn-slider-shadow-left', -100, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-shadow-opacity', 0.0, 1.0, @cssCode, @cssStyle, 0.1)
    settingSlider('btn-slider-shadow-size', 0, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-shadow-top', -100, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-shadowinset-left', -100, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-shadowinset-opacity', 0.0, 1.0, @cssCode, @cssStyle, 0.1)
    settingSlider('btn-slider-shadowinset-size', 0, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-shadowinset-top', -100, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-text-shadow1-left', -100, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-text-shadow1-opacity', 0.0, 1.0, @cssCode, @cssStyle, 0.1)
    settingSlider('btn-slider-text-shadow1-size', 0, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-text-shadow1-top', -100, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-text-shadow2-left', -100, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-text-shadow2-opacity', 0.0, 1.0, @cssCode, @cssStyle, 0.1)
    settingSlider('btn-slider-text-shadow2-size', 0, 100, @cssCode, @cssStyle)
    settingSlider('btn-slider-text-shadow2-top', -100, 100, @cssCode, @cssStyle)

    # カラーピッカーイベント
    @btnBgColor.mousedown( ->
      id = $(this).attr("id"); inputEmt = @btnEntryForm.find("#" + id + "-input"); inputValue = inputEmt.attr("value"); btnCodeEmt = @cssCode.find("." + id)
      self = $(this)
      settingColorPicker(
        this,
        inputValue,
        (a, b, d) ->
          self.css("backgroundColor", "#" + b)
          inputEmt.attr("value", b)
          btnCodeEmt.text(b)
          @cssStyle.text(@cssCode.text())
      )
    )
    @btnShadowColor.mousedown( ->
      id = $(this).attr("id"); e = @configBoxLi.find("#" + id + " div"); inputEmt = @btnEntryForm.find("#" + id + "-input"); inputValue = inputEmt.attr("value"); btnCodeEmt = @cssCode.find("." + id)
      self = $(this)
      settingColorPicker(
        this,
        inputValue,
        (a, b, d) ->
          self.css("backgroundColor", "#" + b)
          inputEmt.attr("value", b)
          btnCodeEmt.text(d.r + "," + d.g + "," + d.b)
          @cssStyle.text(@cssCode.text())
      )
    )

    # グラデーションStepイベント
    @btnGradientStep.on('keyup mouseup', (e) ->
      changeGradientShow(e, @cssCode, @cssStyle)
      stepValue = parseInt($(e.currentTarget).val())
      for i in [2 .. 4]
        id = 'btn-bg-color' + i; mozFlag = $("." + id + "-moz-flag", cssRoot); mozCache = $("." + id + "-moz-cache", cssRoot); webkitFlag = $("." + id + "-webkit-flag", cssRoot); webkitCache = $("." + id + "-webkit-cache", cssRoot);
        if i > stepValue - 1
          mh = mozFlag.html()
          if mh.length > 0
            mozCache.html(mh)
          wh = webkitFlag.html()
          if wh.length > 0
            webkitCache.html(wh)
          $(mozFlag).empty()
          $(webkitFlag).empty()
        else
          mozFlag.html(mozCache.html());
          webkitFlag.html(webkitCache.html())
      @cssStyle.text(@cssCode.text())
    ).each( ->
      stepValue = parseInt($(this).val())
      for i in [2 .. 4]
        id = 'btn-bg-color' + i; mozFlag = $("." + id + "-moz-flag", cssRoot); mozCache = $("." + id + "-moz-cache", cssRoot); webkitFlag = $("." + id + "-webkit-flag", cssRoot); webkitCache = $("." + id + "-webkit-cache", cssRoot);
        if i > stepValue - 1
          mh = mozFlag.html()
          if mh.length > 0
            mozCache.html(mh)
          wh = webkitFlag.html()
          if wh.length > 0
            webkitCache.html(wh)
          $(mozFlag).empty()
          $(webkitFlag).empty()
      @cssStyle.text(@cssCode.text())
    )
    @cssStyle.text(@cssCode.text())

  # オプションメニューを開く
  @showOptionMenu: ->

    # オプションメニューを閉じる
  @hideOptionMenu: ->


# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList.buttonInit?
  window.itemInitFuncList.buttonInit = (option = {}) ->
    # ボタンのCSSテンプレートを設置
    css_temp = option.css_temp
    if css_temp?
      tempEmt = "<div id='#{WorkTableButtonItem.CSSTEMPID}'>#{css_temp}</div>"
      $('#css_code_info_temp').append(tempEmt)