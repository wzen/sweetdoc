# ボタンアイテム
# @extend CssItemBase
class ButtonItem extends CssItemBase
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "Button"

  # @property [String] CSSTEMPID CSSテンプレートID
  @CSSTEMPID = "button_css_temp"

  if window.loadedItemId?
    # @property [String] ITEM_ID アイテム種別
    @ITEM_ID = window.loadedItemId

  @actionProperties: ->
    {
      defaultMethod: 'defaultClick'
      methods: {
        defaultClick: {
          actionType: 'click'
          options: {
            id: 'defaultClick'
            name: 'Default click action'
            desc: "Click push action"
            ja: {
              name: '通常クリック'
              desc: 'デフォルトのボタンクリック'
            }
          }
        }

        changeColorScroll: {
          actionType: 'scroll'
          scrollEnabledDirection: {
            top: true
            bottom: true
            left: false
            right: false
          }
          scrollForwardDirection: {
            top: false
            bottom: true
            left: false
            right: false
          }
          options: {
            id: 'changeColorScroll_Design'
            name: 'Changing color by click'
          }
        }
      }
    }

  # イベント前の表示状態にする
  updateEventBefore: ->
    @getJQueryElement().css('opacity', 0)
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration')

  # イベント後の表示状態にする
  updateEventAfter: ->
    @getJQueryElement().css('opacity', 1)
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().css({'-webkit-animation-duration':'0', '-moz-animation-duration', '0'})

  # 共通クリックイベント ※アクションイベント
  defaultClick : (e, complete) =>
    # ボタン凹むアクション
    @getJQueryElement().addClass('defaultClick_' + @id)
    @getJQueryElement().off('webkitAnimationEnd animationend')
    @getJQueryElement().on('webkitAnimationEnd animationend', (e) =>
      #console.log('css-anim end')
      @getJQueryElement().removeClass('defaultClick_' + @id)
      @isFinishedEvent = true
      if complete?
        complete()
    )

  # CSS
  cssAnimationElement : ->
    methodName = @getEventMethodName()
    funcName = "#{methodName}_#{@id}"
    keyFrameName = "#{@id}_frame"
    emt = @getJQueryElement()
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

  willChapter: ->
    super()
    if @getEventMethodName() == 'defaultClick'
      # ボタンを表示
      @getJQueryElement().css('opacity', 1)

  # CSSボタンコントロール初期化
  setupOptionMenu: ->
    item = @

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

    # スライダー初期化
    SidebarUI.settingGradientSlider('btn-slider-gradient', null, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingGradientDegSlider('btn-slider-gradient-deg', 0, 315, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-border-radius', 0, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-border-width', 0, 10, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-font-size', 0, 30, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-shadow-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-shadow-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
    SidebarUI.settingSlider('btn-slider-shadow-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-shadow-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-shadowinset-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-shadowinset-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
    SidebarUI.settingSlider('btn-slider-shadowinset-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-shadowinset-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-text-shadow1-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-text-shadow1-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
    SidebarUI.settingSlider('btn-slider-text-shadow1-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-text-shadow1-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-text-shadow2-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-text-shadow2-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
    SidebarUI.settingSlider('btn-slider-text-shadow2-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
    SidebarUI.settingSlider('btn-slider-text-shadow2-top', -100, 100, cssCode, cssStyle, @designConfigRoot)

    # オプションメニューを作成
    # カラーピッカーイベント
    btnBgColor.each( ->
      self = $(@)
      className = self[0].classList[0]
      btnCodeEmt = cssCode.find("." + className).first()
      colorValue = btnCodeEmt.text()
      ColorPickerUtil.initColorPicker(
        self,
        colorValue,
        (a, b, d) ->
          btnCodeEmt = cssCode.find("." + className)
          btnCodeEmt.text(b)
          item.reflectCssStyle()
      )
    )
    btnShadowColor.each( ->
      self = $(@)
      className = self[0].classList[0]
      btnCodeEmt = cssCode.find("." + className).first()
      colorValue = btnCodeEmt.text()
      ColorPickerUtil.initColorPicker(
        self,
        colorValue,
        (a, b, d) ->
          btnCodeEmt = cssCode.find("." + className)
          btnCodeEmt.text(d.r + "," + d.g + "," + d.b)
          item.reflectCssStyle()
      )
    )

    # グラデーションStepイベント
    btnGradientStep.off('keyup mouseup')
    btnGradientStep.on('keyup mouseup', (e) ->
      SidebarUI.changeGradientShow(e.currentTarget, cssCode, cssStyle, @cssConfig)
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
      item.reflectCssStyle()
    ).each( ->
      SidebarUI.changeGradientShow(@, cssCode, cssStyle, @cssConfig)
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
      item.reflectCssStyle()
    )


Common.setClassToMap(false, ButtonItem.ITEM_ID, ButtonItem)

# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList[ButtonItem.ITEM_ID]?
  window.itemInitFuncList[ButtonItem.ITEM_ID] = (option = {}) ->
    if window.isWorkTable && ButtonItem.jsLoaded?
      ButtonItem.jsLoaded(option)
    #JS読み込み完了
    if window.debug
      console.log('button loaded')

