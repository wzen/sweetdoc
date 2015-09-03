class Sidebar

  # サイドバーをオープン
  # @param [Array] target フォーカス対象オブジェクト
  # @param [String] selectedBorderType 選択枠タイプ
  @openConfigSidebar = (target = null, selectedBorderType = "edit") ->
    if !Sidebar.isOpenedConfigSidebar()
      main = $('#main')
      if !Sidebar.isOpenedConfigSidebar()
        main.removeClass('col-md-12')
        main.addClass('col-md-9')
        $('#sidebar').fadeIn('500')
        if target != null
          WorktableCommon.focusToTargetWhenSidebarOpen(target, selectedBorderType)

  # サイドバーをクローズ
  @closeSidebar = (callback = null) ->
    # 選択枠を削除
    WorktableCommon.clearSelectedBorder()
    if !Sidebar.isClosedConfigSidebar()
      main = $('#main')
      $('#sidebar').fadeOut('500', ->
        s = PageValue.getInstancePageValue(PageValue.Key.CONFIG_OPENED_SCROLL)
        if s?
          scrollContents.css({scrollTop: s.top, scrollLeft: s.left})
          PageValue.removePageValue(PageValue.Key.CONFIG_OPENED_SCROLL)
        main.removeClass('col-md-9')
        main.addClass('col-md-12')
        if callback?
          callback()
        $('.sidebar-config').css('display', 'none')
      )

  # サイドバーがオープンしているか
  @isOpenedConfigSidebar = ->
    return $('#main').hasClass('col-md-9')

  # サイドバーがクローズしているか
  @isClosedConfigSidebar = ->
    return $('#main').hasClass('col-md-12')

  # サイドバー内容のスイッチ
  # @param [String] configType コンフィグタイプ
  @switchSidebarConfig = (configType, item = null) ->
    animation = @isOpenedConfigSidebar()
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
        $('#event-config').show()
      else
        $('#event-config').css('display', '')
    else if configType == 'setting'
      sc = $("##{Setting.ROOT_ID_NAME}")
      if animation
        sc.show()
      else
        sc.css('display', '')


class SidebarUI

  # 通常スライダーの作成
  # @param [Int] id メーターのElementID
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Object] cssCode コードエレメント
  # @param [Object] cssStyle CSSプレビューのエレメント
  # @param [Int] stepValue 進捗数
  @settingSlider = (className, min, max, cssCode, cssStyle, root, stepValue = 0) ->
    meterElement = $('.' + className, root)
    valueElement = $('.' + className + '-value', root)
    d = $('.' + className + '-value', cssCode)[0]
    defaultValue = $(d).html()
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
        valueElement.val(ui.value)
        valueElement.html(ui.value)
        cssStyle.text(cssCode.text())
    })

  # HTML要素からグラデーションスライダーの作成
  # @param [Object] element HTML要素
  # @param [Array] values 値の配列
  # @param [Object] cssCode コードエレメント
  # @param [Object] cssStyle CSSプレビューのエレメント
  @settingGradientSliderByElement = (element, values, cssCode, cssStyle) ->
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
        position = $('.btn-bg-color' + (index + 2) + '-position', cssCode)
        position.html(("0" + ui.value).slice(-2))
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
  @settingGradientSlider = (className, values, cssCode, cssStyle, root) ->
    meterElement = $('.' + className, root)
    @settingGradientSliderByElement(meterElement, values, cssCode, cssStyle)


  # グラデーション方向スライダーの作成
  # @param [Int] id メーターのElementID
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Object] cssCode コードエレメント
  # @param [Object] cssStyle CSSプレビューのエレメント
  @settingGradientDegSlider = (className, min, max, cssCode, cssStyle, root) ->
    meterElement = $('.' + className, root)
    valueElement = $('.' + className + '-value', cssCode)
    webkitValueElement = $('.' + className + '-value-webkit', cssCode)
    d = $('.' + className + '-value', cssCode)[0]
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
        cssStyle.text(cssCode.text())
    })

  # グラデーションの表示変更(スライダーのハンドル&カラーピッカー)
  # @param [Object] element HTML要素
  # @param [Object] cssCode コードエレメント
  # @param [Object] cssStyle CSSプレビューのエレメント
  @changeGradientShow = (targetElement, cssCode, cssStyle, cssConfig) ->
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

      SidebarUI.settingGradientSliderByElement(meterElement, values, cssCode, cssStyle)
      @switchGradientColorSelectorVisible(value, cssConfig)

  # グラデーションのカラーピッカー表示切り替え
  # @param [Int] gradientStepValue 現在のグラデーション数
  @switchGradientColorSelectorVisible = (gradientStepValue, cssConfig) ->
    for i in [2 .. 4]
      element = $('.btn-bg-color' + i, cssConfig)
      if i > gradientStepValue - 1
        element.css('display', 'none')
      else
        element.css('display', '')