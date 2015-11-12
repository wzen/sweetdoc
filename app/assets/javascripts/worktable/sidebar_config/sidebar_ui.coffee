class Sidebar

  if gon?
    # 定数
    constant = gon.const
    @SIDEBAR_TAB_ROOT = constant.ElementAttribute.SIDEBAR_TAB_ROOT

  class @Type
    @STATE = 'state'
    @CSS = 'css'
    @CANVAS = 'canvas'
    @TIMELINE = 'timeline'
    @SETTING = 'setting'

  # サイドバーをオープン
  # @param [Array] target フォーカス対象オブジェクト
  # @param [String] selectedBorderType 選択枠タイプ
  @openConfigSidebar = (target = null, selectedBorderType = "edit") ->
    if !Sidebar.isOpenedConfigSidebar()
      # モードを変更
      WorktableCommon.changeMode(Constant.Mode.OPTION)
      main = $('#main')
      if !Sidebar.isOpenedConfigSidebar()
        main.removeClass('col-xs-12')
        main.addClass('col-xs-9')
        $('#sidebar').fadeIn('500', ->
          WorktableCommon.resizeMainContainerEvent()
        )
        if target != null
          WorktableCommon.focusToTargetWhenSidebarOpen(target, selectedBorderType)

  # サイドバーをクローズ
  # @param [Function] callback コールバック
  @closeSidebar = (callback = null) ->
    # 選択枠を削除
    WorktableCommon.clearSelectedBorder()
    if !Sidebar.isClosedConfigSidebar()
      main = $('#main')
      $('#sidebar').fadeOut('500', ->
        main.removeClass('col-xs-9')
        main.addClass('col-xs-12')
        WorktableCommon.resizeMainContainerEvent()
        if callback?
          callback()
        $('.sidebar-config').hide()
      )

  # サイドバーがオープンしているか
  # @return [Boolean] 判定結果
  @isOpenedConfigSidebar = ->
    return $('#main').hasClass('col-xs-9')

  # サイドバーがクローズしているか
  # @return [Boolean] 判定結果
  @isClosedConfigSidebar = ->
    return $('#main').hasClass('col-xs-12')

  # サイドバー内容のスイッチ
  # @param [String] configType コンフィグタイプ
  # @param [Object] item アイテムオブジェクト
  @switchSidebarConfig = (configType, item = null) ->
    animation = @isOpenedConfigSidebar()
    $('.sidebar-config').hide()

    if configType == @Type.STATE || configType == @Type.SETTING
      sc = $("##{@SIDEBAR_TAB_ROOT}")
      if animation
        sc.fadeIn('fast')
      else
        sc.show()
    else if configType == @Type.CSS && item? && item.cssConfig?
      if animation
        item.cssConfig.fadeIn('fast')
      else
        item.cssConfig.show()
    else if configType == @Type.CANVAS && item? && item.canvasConfig?
      if animation
        item.canvasConfig.fadeIn('fast')
      else
        item.canvasConfig.show()
    else if configType == @Type.TIMELINE
      if animation
        $('#event-config').fadeIn('fast')
      else
        $('#event-config').show()

  # アイテム編集メニュー表示
  @openItemEditConfig = (target) ->
    emt = $(target)
    obj = instanceMap[emt.attr('id')]

    # オプションメニューを初期化
    _initOptionMenu = ->
      if obj? && obj.setupOptionMenu?
        # 初期化関数を呼び出す
        obj.setupOptionMenu()
      if obj? && obj.showOptionMenu?
        # オプションメニュー表示処理
        obj.showOptionMenu()

    # コンフィグ表示切り替え
    if obj instanceof CssItemBase
      @switchSidebarConfig(@Type.CSS)
    else if obj instanceof CanvasItemBase
      @switchSidebarConfig(@Type.CANVAS)

    # カラーピッカー値を初期化
    ColorPickerUtil.initColorPickerValue()
    # オプションメニューの値を初期化
    _initOptionMenu()
    # オプションメニューを表示
    @openConfigSidebar(target)

class SidebarUI

  if gon?
    constant = gon.const

    @DESIGN_ROOT_CLASSNAME = constant.DesignConfig.ROOT_CLASSNAME

  # 通常スライダーの作成
  # @param [Int] id メーターのElementID
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Object] cssCode コードエレメント
  # @param [Object] designConfigRoot デザインコンフィグRoot
  # @param [Int] stepValue 進捗数
  @settingSlider = (className, min, max, cssCode, designConfigRoot, stepValue = 0) ->
    self = @

    meterElement = $('.' + className, designConfigRoot)
    valueElement = $('.' + className + '_value', designConfigRoot)
    cssCodeElement = $('.' + className + '_value', cssCode)
    defaultValue = cssCodeElement.html()
    valueElement.val(defaultValue)
    valueElement.html(defaultValue)
    try
      meterElement.slider('destroy')
    catch #例外は握りつぶす
    meterElement.slider({
      min: min,
      max: max,
      step: stepValue,
      value: defaultValue
      slide: (event, ui)->
        value = ui.value
        valueElement.val(value)
        valueElement.html(value)
        cssCodeElement.html(value)
        _applyStyle.call(self, event.target)
    })

  # HTML要素からグラデーションスライダーの作成
  # @param [Object] element HTML要素
  # @param [Array] values 値の配列
  # @param [Object] cssCode コードエレメント
  @settingGradientSliderByElement = (element, values, cssCode) ->
    self = @

    id = element.attr("id")
    try
      element.slider('destroy')
    catch #例外は握りつぶす
    element.slider({
      # 0%と100%は含まない
      min: 1
      max: 99
      values: values
      slide: (event, ui) ->
        index = $(ui.handle).index()
        position = $('.design_bg_color' + (index + 2) + '_position', cssCode)
        position.html(("0" + ui.value).slice(-2))
        _applyStyle.call(self, event.target)
    })

    handleElement = element.children('.ui-slider-handle')
    if values == null
      handleElement.hide()
    else
      handleElement.show()

  # グラデーションスライダーの作成
  # @param [Int] id HTML要素のID
  # @param [Array] values 値の配列
  # @param [Object] cssCode コードエレメント
  # @param [Object] designConfigRoot デザインコンフィグRoot
  @settingGradientSlider = (className, values, cssCode, designConfigRoot) ->
    meterElement = $('.' + className, designConfigRoot)
    @settingGradientSliderByElement(meterElement, values, cssCode)


  # グラデーション方向スライダーの作成
  # @param [Int] id メーターのElementID
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Object] cssCode コードエレメント
  # @param [Object] designConfigRoot デザインコンフィグRoot
  @settingGradientDegSlider = (className, min, max, cssCode, designConfigRoot) ->
    self = @

    meterElement = $('.' + className, designConfigRoot)
    valueElement = $('.' + className + '_value', cssCode)
    webkitValueElement = $('.' + className + '_value_webkit', cssCode)
    d = $('.' + className + '_value', cssCode)[0]
    defaultValue = $(d).html()
    webkitDeg = {0 : 'left top, left bottom', 45 : 'right top, left bottom', 90 : 'right top, left top', 135 : 'right bottom, left top', 180 : 'left bottom, left top', 225 : 'left bottom, right top', 270 : 'left top, right top', 315: 'left top, right bottom'}

    valueElement.val(defaultValue)
    valueElement.html(defaultValue)
    webkitValueElement.html(webkitDeg[defaultValue])

    try
      meterElement.slider('destroy')
    catch #例外は握りつぶす
    meterElement.slider({
      min: min,
      max: max,
      step: 45,
      value: defaultValue
      slide: (event, ui)->
        valueElement.val(ui.value)
        valueElement.html(ui.value)
        webkitValueElement.html(webkitDeg[ui.value])
        _applyStyle.call(self, event.target)
    })

  # グラデーションの表示変更(スライダーのハンドル&カラーピッカー)
  # @param [Object] element HTML要素
  # @param [Object] cssCode コードエレメント
  # @param [Object] cssConfig CSSコンフィグRoot
  @changeGradientShow = (targetElement, cssCode, cssConfig) ->
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

      SidebarUI.settingGradientSliderByElement(meterElement, values, cssCode)
      @switchGradientColorSelectorVisible(value, cssConfig)

  # グラデーションのカラーピッカー表示切り替え
  # @param [Int] gradientStepValue 現在のグラデーション数
  # @param [Object] cssConfig CSSコンフィグRoot
  @switchGradientColorSelectorVisible = (gradientStepValue, cssConfig) ->
    for i in [2 .. 4]
      element = $('.design_bg_color' + i, cssConfig)
      if i > gradientStepValue - 1
        element.hide()
      else
        element.show()

  _applyStyle = (eventTarget) ->
    prefix = ItemBase.DESIGN_CONFIG_ROOT_ID.replace('@id', '')
    objId = $(eventTarget).closest(".#{CssItemBase.DESIGN_ROOT_CLASSNAME}").attr('id').replace(prefix, '')
    item = window.instanceMap[objId]
    if item? && item instanceof CssItemBase
      item.applyCssStyle()
