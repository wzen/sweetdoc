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
    @css = null

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
      id: @id
      itemType: Constant.ItemType.BUTTON
      mousedownCood: @mousedownCood
      itemSize: @itemSize
      zindex: @zindex
      css: @css
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
    @id = obj.id # IDも変更
    @mousedownCood = obj.mousedownCood
    @itemSize = obj.itemSize
    @zindex = obj.zindex
    @css = obj.css

  # 共通クリックイベント
  actorClickEvent: (e) ->

  # CSSアニメーション 凹むボタン
  @dentButton : (buttonItem) ->
    funcName = 'dentButton_' + buttonItem.id
    keyFrameName = "#{funcName}_#{buttonItem.id}"
    emt = buttonItem.getJQueryElement()
    top = emt.css('top')
    left = emt.css('left')
    width = emt.css('width')
    height = emt.css('height')

    # キーフレーム
    keyframe = """
    @-webkit-keyframes #{keyFrameName} {
      0% {
        top: #{ parseInt(top)}px;
        left: #{ parseInt(left)}px;
        width: #{parseInt(width)}px;
        height: #{parseInt(height)}px;
      }
      40% {
        top: #{ parseInt(top) + 10 }px;
        left: #{ parseInt(left) + 10 }px;
        width: #{parseInt(width) - 20}px;
        height: #{parseInt(height) - 20}px;
      }
      80% {
        top: #{ parseInt(top)}px;
        left: #{ parseInt(left)}px;
        width: #{parseInt(width)}px;
        height: #{parseInt(height)}px;
      }
      90% {
        top: #{ parseInt(top) + 5 }px;
        left: #{ parseInt(left) + 5 }px;
        width: #{parseInt(width) - 10}px;
        height: #{parseInt(height) - 10}px;
      }
      100% {
        top: #{ parseInt(top)}px;
        left: #{ parseInt(left)}px;
        width: #{parseInt(width)}px;
        height: #{parseInt(height)}px;
      }
    }
    """

    # CSSに設定
    css = """
    .#{funcName}
    {
    -webkit-animation-name: #{keyFrameName};
    -moz-animation-name: #{keyFrameName};
    -webkit-animation-duration: 0.5s;
    -moz-animation-duration: 0.5s;
    }
    """

    return "#{keyframe} #{css}"



# ワークテーブル用ボタンクラス
class WorkTableButtonItem extends ButtonItem
  # @property [String] CSSTEMPID CSSテンプレートID
  @CSSTEMPID = "button_css_temp"

  # オプションメニュー
  @cssConfig = $("#css-config", $("#sidebar-wrapper"))
  @configBoxLi = $("div.configBox > div.forms", $("#sidebar-wrapper"))
  @btnGradientStep = $(".btn-gradient-step", @cssConfig)
  @btnBgColor = $(".btn-bg-color1,.btn-bg-color2,.btn-bg-color3,.btn-bg-color4,.btn-bg-color5,.btn-border-color,.btn-font-color", @cssConfig)
  @btnShadowColor = $(".btn-shadow-color,.btn-shadowinset-color,.btn-text-shadow1-color,.btn-text-shadow2-color", @cssConfig);


  constructor: (cood = null) ->
    super(cood)
    @cssRoot = null
    @cssCode = null
    @cssStyle = null

  # ストレージとDB保存用の最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  generateMinimumObject: ->
    obj = super()
    obj.css = @cssRoot[0].outerHTML
    return obj

  # HTML要素とCSSを作成
  # @return [Boolean] 処理結果
  makeElement: ->
    super()
    if @css?
      newEmt = $(@css)
    else
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
    base = @
    cssRoot = @cssRoot
    cssCode = @cssCode
    cssStyle = @cssStyle

    #スライダー
    settingGradientSlider('btn-slider-gradient', null)
    settingGradientDegSlider('btn-slider-gradient-deg', 0, 315, cssCode, cssStyle)
    settingSlider('btn-slider-border-radius', 0, 100, cssCode, cssStyle)
    settingSlider('btn-slider-border-width', 0, 10, cssCode, cssStyle)
    settingSlider('btn-slider-font-size', 0, 30, cssCode, cssStyle)
    #settingSlider('btn-slider-padding-left', 0, 30)
    #settingSlider('btn-slider-padding-top', 0, 30)
    settingSlider('btn-slider-shadow-left', -100, 100, cssCode, cssStyle)
    settingSlider('btn-slider-shadow-opacity', 0.0, 1.0, cssCode, cssStyle, 0.1)
    settingSlider('btn-slider-shadow-size', 0, 100, cssCode, cssStyle)
    settingSlider('btn-slider-shadow-top', -100, 100, cssCode, cssStyle)
    settingSlider('btn-slider-shadowinset-left', -100, 100, cssCode, cssStyle)
    settingSlider('btn-slider-shadowinset-opacity', 0.0, 1.0, cssCode, cssStyle, 0.1)
    settingSlider('btn-slider-shadowinset-size', 0, 100, cssCode, cssStyle)
    settingSlider('btn-slider-shadowinset-top', -100, 100, cssCode, cssStyle)
    settingSlider('btn-slider-text-shadow1-left', -100, 100, cssCode, cssStyle)
    settingSlider('btn-slider-text-shadow1-opacity', 0.0, 1.0, cssCode, cssStyle, 0.1)
    settingSlider('btn-slider-text-shadow1-size', 0, 100, cssCode, cssStyle)
    settingSlider('btn-slider-text-shadow1-top', -100, 100, cssCode, cssStyle)
    settingSlider('btn-slider-text-shadow2-left', -100, 100, cssCode, cssStyle)
    settingSlider('btn-slider-text-shadow2-opacity', 0.0, 1.0, cssCode, cssStyle, 0.1)
    settingSlider('btn-slider-text-shadow2-size', 0, 100, cssCode, cssStyle)
    settingSlider('btn-slider-text-shadow2-top', -100, 100, cssCode, cssStyle)

    # カラーピッカーイベント
    WorkTableButtonItem.btnBgColor.each( ->
      self = $(@)
      className = self[0].classList[0]
      btnCodeEmt = cssCode.find("." + className).first()
      if btnCodeEmt?
        colorValue = btnCodeEmt.text()
      else
        colorValue = "ffffff"
      self.css("backgroundColor", "#" + colorValue)
      settingColorPicker(
        self,
        colorValue,
        (a, b, d) ->
          self.css("backgroundColor", "#" + b)
          btnCodeEmt = cssCode.find("." + className)
          btnCodeEmt.text(b)
          cssCode = base.cssCode
          cssStyle = base.cssStyle
          cssStyle.text(cssCode.text())
      )
      self.unbind()
      self.mousedown( (e) ->
        e.stopPropagation()
        clearAllItemStyle()
        self.ColorPickerHide()
        self.ColorPickerShow()
      )
    )

    WorkTableButtonItem.btnShadowColor.each( ->
      self = $(@)
      className = self[0].classList[0]
      btnCodeEmt = cssCode.find("." + className).first()
      if btnCodeEmt?
        colorValue = btnCodeEmt.text()
      else
        colorValue = "ffffff"
      self.css("backgroundColor", "#" + colorValue)
      settingColorPicker(
        self,
        colorValue,
        (a, b, d) ->
          self.css("backgroundColor", "#" + b)
          btnCodeEmt = cssCode.find("." + className)
          btnCodeEmt.text(d.r + "," + d.g + "," + d.b)
          cssCode = base.cssCode
          cssStyle = base.cssStyle
          cssStyle.text(cssCode.text())
      )
      self.unbind()
      self.mousedown( (e) ->
        e.stopPropagation()
        clearAllItemStyle()
        self.ColorPickerHide()
        self.ColorPickerShow()
      )
    )

    # グラデーションStepイベント
    WorkTableButtonItem.btnGradientStep.off('keyup mouseup')
    WorkTableButtonItem.btnGradientStep.on('keyup mouseup', (e) ->
      cssCode = base.cssCode
      cssStyle = base.cssStyle
      changeGradientShow(e.currentTarget, cssCode, cssStyle)
      stepValue = parseInt($(e.currentTarget).val())
      for i in [2 .. 4]
        className = 'btn-bg-color' + i; mozFlag = $("." + className + "-moz-flag", cssRoot); mozCache = $("." + className + "-moz-cache", cssRoot); webkitFlag = $("." + className + "-webkit-flag", cssRoot); webkitCache = $("." + className + "-webkit-cache", cssRoot);
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
      cssStyle.text(cssCode.text())
    ).each( ->
      cssCode = base.cssCode
      cssStyle = base.cssStyle
      changeGradientShow(@, cssCode, cssStyle)
      stepValue = parseInt($(@).val())
      for i in [2 .. 4]
        className = 'btn-bg-color' + i; mozFlag = $("." + className + "-moz-flag", cssRoot); mozCache = $("." + className + "-moz-cache", cssRoot); webkitFlag = $("." + className + "-webkit-flag", cssRoot); webkitCache = $("." + className + "-webkit-cache", cssRoot);
        if i > stepValue - 1
          mh = mozFlag.html()
          if mh.length > 0
            mozCache.html(mh)
          wh = webkitFlag.html()
          if wh.length > 0
            webkitCache.html(wh)
          $(mozFlag).empty()
          $(webkitFlag).empty()
      cssStyle.text(cssCode.text())
    )
    #cssStyle.text(cssCode.text())

  # オプションメニューを開く
  @showOptionMenu: ->

    # オプションメニューを閉じる
  @hideOptionMenu: ->


# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList.buttonInit?
  window.itemInitFuncList.buttonInit = (option = {}) ->
    if option.isWorkTable?
      # ワークテーブルの初期化処理
      css_temp = option.css_temp
      if css_temp?
        # ボタンのCSSテンプレートを設置
        tempEmt = "<div id='#{WorkTableButtonItem.CSSTEMPID}'>#{css_temp}</div>"
        $('#css_code_info_temp').append(tempEmt)


      # オプションメニューを作成
      ## カラーピッカー
      createColorPicker(WorkTableButtonItem.btnBgColor)
      createColorPicker(WorkTableButtonItem.btnShadowColor)