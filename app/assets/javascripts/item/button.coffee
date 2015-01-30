
# ボタンアイテム
# @extend CssItemBase
class ButtonItem extends CssItemBase
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "Button"
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
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true) ->
    if !super(zindex)
      return false
    @makeElement(show)
    return true

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  reDraw: (show = true)->
    @makeElement(show)

  # HTML要素を作成
  # @param [boolean] show 要素作成後に描画を表示するか
  makeElement: (show = true) ->
    $(ElementCode.get().createItemElement(@)).appendTo('#scroll_inside')
    if !show
      # TODO: alphaを0にして非表示にする
      return false

  # ストレージとDB保存用の最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  generateMinimumObject: ->
    obj = {
      id: makeClone(@id)
      name: makeClone(@name)
      itemType: Constant.ItemType.BUTTON
      mousedownCood: makeClone(@mousedownCood)
      itemSize: makeClone(@itemSize)
      zindex: makeClone(@zindex)
      css: makeClone(@css)
    }
    return obj

  # 最小限のデータからアイテムを描画
  # @param [Array] obj アイテムオブジェクトの最小限データ
  reDrawByMinimumObject: (obj) ->
    @setMiniumObject(obj)
    @reDraw()
    @saveObj(Constant.ItemActionType.MAKE)


  # 最小限のデータを設定
  # @param [Array] obj アイテムオブジェクトの最小限データ
  setMiniumObject: (obj) ->
    @id = makeClone(obj.id) # IDも変更
    @name = makeClone(obj.name)
    @mousedownCood = makeClone(obj.mousedownCood)
    @itemSize = makeClone(obj.itemSize)
    @zindex = makeClone(obj.zindex)
    @css = makeClone(obj.css)

  # 共通クリックイベント ※アクションイベント
  defaultClick : (e) =>
    # ボタン凹むアクション
    @getJQueryElement().addClass('dentButton_' + @id)
    @getJQueryElement().on('webkitAnimationEnd animationend', (e) =>
      #console.log('css-anim end')
      @nextChapter()
    )

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
    #{keyFrameName} {
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
    webkitKeyframe = "@-webkit-keyframes #{keyframe}"
    mozKeyframe = "@-moz-keyframes #{keyframe}"

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
    return "#{webkitKeyframe} #{mozKeyframe} #{css}"

window.loadedClassList.ButtonItem = ButtonItem

if window.worktablePage?
  # ワークテーブル用ボタンクラス
  class WorkTableButtonItem extends ButtonItem
    @include WorkTableCommonExtend
    @include WorkTableCssItemExtend

    # @property [String] CSSTEMPID CSSテンプレートID
    @CSSTEMPID = "button_css_temp"

    constructor: (cood = null) ->
      super(cood)
      @cssRoot = null
      @cssCache = null
      @cssCode = null
      @cssStyle = null

    # ストレージとDB保存用の最小限のデータを取得
    # @return [Array] アイテムオブジェクトの最小限データ
    generateMinimumObject: ->
      obj = super()
      obj.css = @cssRoot[0].outerHTML
      return obj

    # HTML要素とCSSとコンフィグを作成
    # @param [boolean] show 要素作成後に描画を表示するか
    # @return [Boolean] 処理結果
    makeElement: (show = true) ->
      super(show)
      if @css?
        newEmt = $(@css)
      else
        # CSSテンプレートからオブジェクト個別のCSSを作成
        newEmt = $('#' + WorkTableButtonItem.CSSTEMPID).clone(true).attr('id', @getCssRootElementId())
        newEmt.find('.btn-item-id').html(@id)
      $('#css_code_info').append(newEmt)

      @cssRoot = $('#' + @getCssRootElementId())
      @cssCache = $(".css-cache", @cssRoot)
      @cssCode = $(".css-code", @cssRoot)
      @cssStyle = $(".css-style", @cssRoot)
      @cssStyle.text(@cssCode.text())

      # コンフィグ作成
      @makeDesignConfig()
      # タイムラインイベント更新
      @updateTimelineEventSelect()

      return true

    # CSSボタンコントロール初期化
    setupOptionMenu: ->
      base = @
      cssRoot = @cssRoot
      cssCache = @cssCache
      cssCode = @cssCode
      cssStyle = @cssStyle

      @designConfigRoot = $('#' + @getDesignConfigId())
      if !@designConfigRoot?
        @makeDesignConfig()
      @cssConfig = $(".css-config", @designConfigRoot)
      @canvasConfig = $(".canvas-config", @designConfigRoot)
      btnGradientStep = $(".btn-gradient-step", @cssConfig)
      btnBgColor = $(".btn-bg-color1,.btn-bg-color2,.btn-bg-color3,.btn-bg-color4,.btn-bg-color5,.btn-border-color,.btn-font-color", @cssConfig)
      btnShadowColor = $(".btn-shadow-color,.btn-shadowinset-color,.btn-text-shadow1-color,.btn-text-shadow2-color", @cssConfig);

      # アイテム名の変更
      name = $('.item-name', @designConfigRoot)
      name.val(@name)
      name.off('change').on('change', =>
        @name = name.val()
        @setItemPropToPageValue('name', @name)
      )

      #スライダー
      settingGradientSlider('btn-slider-gradient', null, cssCode, cssStyle, @designConfigRoot)
      settingGradientDegSlider('btn-slider-gradient-deg', 0, 315, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-border-radius', 0, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-border-width', 0, 10, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-font-size', 0, 30, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-shadow-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-shadow-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
      settingSlider('btn-slider-shadow-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-shadow-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-shadowinset-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-shadowinset-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
      settingSlider('btn-slider-shadowinset-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-shadowinset-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-text-shadow1-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-text-shadow1-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
      settingSlider('btn-slider-text-shadow1-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-text-shadow1-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-text-shadow2-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-text-shadow2-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
      settingSlider('btn-slider-text-shadow2-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
      settingSlider('btn-slider-text-shadow2-top', -100, 100, cssCode, cssStyle, @designConfigRoot)

      # オプションメニューを作成
      ## カラーピッカー
      createColorPicker(btnBgColor)
      createColorPicker(btnShadowColor)

      # カラーピッカーイベント
      btnBgColor.each( ->
        self = $(@)
        className = self[0].classList[0]
        btnCodeEmt = cssCode.find("." + className).first()
        colorValue = btnCodeEmt.text()
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

      btnShadowColor.each( ->
        self = $(@)
        className = self[0].classList[0]
        btnCodeEmt = cssCode.find("." + className).first()
        colorValue = btnCodeEmt.text()
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
      btnGradientStep.off('keyup mouseup')
      btnGradientStep.on('keyup mouseup', (e) ->
        cssCode = base.cssCode
        cssStyle = base.cssStyle
        changeGradientShow(e.currentTarget, cssCode, cssStyle, @cssConfig)
        stepValue = parseInt($(e.currentTarget).val())
        for i in [2 .. 4]
          className = 'btn-bg-color' + i
          mozFlag = $("." + className + "-moz-flag", cssRoot)
          mozCache = $("." + className + "-moz-cache", cssRoot)
          webkitFlag = $("." + className + "-webkit-flag", cssRoot)
          webkitCache = $("." + className + "-webkit-cache", cssRoot)
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
        changeGradientShow(@, cssCode, cssStyle, @cssConfig)
        stepValue = parseInt($(@).val())
        for i in [2 .. 4]
          className = 'btn-bg-color' + i
          mozFlag = $("." + className + "-moz-flag", cssRoot)
          mozCache = $("." + className + "-moz-cache", cssRoot)
          webkitFlag = $("." + className + "-webkit-flag", cssRoot)
          webkitCache = $("." + className + "-webkit-cache", cssRoot)
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

  window.loadedClassList.WorkTableButtonItem = WorkTableButtonItem

# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList.buttonInit?
  window.itemInitFuncList.buttonInit = (option = {}) ->
    #JS読み込み完了
    window.loadedItemTypeList.push(Constant.ItemType.BUTTON)

    if option.isWorkTable?
      # ワークテーブルの初期化処理
      css_temp = option.css_temp
      if css_temp?
        # ボタンのCSSテンプレートを設置
        tempEmt = "<div id='#{WorkTableButtonItem.CSSTEMPID}'>#{css_temp}</div>"
        $('#css_code_info_temp').append(tempEmt)
