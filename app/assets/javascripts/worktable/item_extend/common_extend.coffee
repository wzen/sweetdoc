# ワークテーブル用アイテム拡張モジュール
# 共通
WorkTableCommonInclude =

  # コンフィグメニューの要素IDを取得
  # @return [String] HTML要素ID
  getDesignConfigId: ->
    return @constructor.DESIGN_CONFIG_ROOT_ID.replace('@id', @id)

  # ドラッグ描画開始
  startDraw: ->
    return

  # 描画&コンフィグ作成
  # @param [Boolean] show 要素作成後に描画を表示するか
  drawAndMakeConfigsAndWritePageValue: (show = true) ->
    # ボタン設置
    @reDraw(show)
    # コンフィグ作成
    @makeDesignConfig()

    if @constructor.defaultMethodName()?
      # デフォルトイベントがある場合はイベント作成
      EPVItem.writeDefaultToPageValue(@)
      # タイムライン更新
      Timeline.refreshAllTimeline()

  # 描画&コンフィグ作成
  # @param [boolean] show 要素作成後に描画を表示するか
  # @return [Boolean] 処理結果
  drawAndMakeConfigs: (show = true) ->
    # ボタン設置
    @reDraw(show)
    # コンフィグ作成
    @makeDesignConfig()

  # オプションメニューを開く
  showOptionMenu: ->
    # 全てのサイドバーを非表示
    sc = $('.sidebar-config')
    sc.hide()
    $(".#{Constant.DesignConfig.DESIGN_ROOT_CLASSNAME}", sc).hide()
    $('#design-config').show()
    $('#' + @getDesignConfigId()).show()

  # アイテムに対してドラッグ&リサイズイベントを設定する
  setupDragAndResizeEvents: ->
    self = @
    # コンテキストメニュー設定
    do ->
      menu = []
      contextSelector = null
      if ArrowItem? && self instanceof ArrowItem
        contextSelector = ".arrow"
      else if ButtonItem? && self instanceof ButtonItem
        contextSelector = ".css3button"
      menu.push({title: "Edit", cmd: "edit", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # アイテム編集
        Sidebar.openItemEditConfig(event.target)
      })
      menu.push({title: I18n.t('context_menu.copy'), cmd: "copy", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # コピー
        WorktableCommon.copyItem()
        WorktableCommon.setMainContainerContext()
      })
      menu.push({title: I18n.t('context_menu.cut'), cmd: "cut", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 切り取り
        WorktableCommon.cutItem()
        WorktableCommon.setMainContainerContext()
      })
      menu.push({title: I18n.t('context_menu.float'), cmd: "float", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 最前面移動
        objId = $(event.target).attr('id')
        WorktableCommon.floatItem(objId)
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        # 履歴保存
        OperationHistory.add()
      })
      menu.push({title: I18n.t('context_menu.rear'), cmd: "rear", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 最背面移動
        objId = $(event.target).attr('id')
        WorktableCommon.rearItem(objId)
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        # 履歴保存
        OperationHistory.add()
      })
      menu.push({title: I18n.t('context_menu.delete'), cmd: "delete", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # アイテム削除
        if window.confirm(I18n.t('message.dialog.delete_item'))
          WorktableCommon.removeItem(event.target)
      })
      WorktableCommon.setupContextMenu(self.getJQueryElement(), contextSelector, menu)

    # クリックイベント設定
    do ->
      self.getJQueryElement().mousedown( (e)->
        if e.which == 1 #左クリック
          e.stopPropagation()
          WorktableCommon.clearSelectedBorder()
          WorktableCommon.setSelectedBorder(@, "edit")
      )

    # JQueryUIのドラッグイベントとリサイズ設定
    do ->
      self.getJQueryElement().draggable({
        containment: scrollInside
        drag: (event, ui) ->
          if self.drag?
            self.drag()
        stop: (event, ui) ->
          if self.dragComplete?
            self.dragComplete()
      })
      self.getJQueryElement().resizable({
        containment: scrollInside
        resize: (event, ui) ->
          if self.resize?
            self.resize()
        stop: (event, ui) ->
          if self.resizeComplete?
            self.resizeComplete()
      })

  # デザイン変更コンフィグを作成
  makeDesignConfig: ->
    self = @
    designConfigRoot = $('#' + @getDesignConfigId())
    if !designConfigRoot? || designConfigRoot.length == 0
      DesignConfig.addConfigIfNeed(@, (data) ->
        html = $(data.html).attr('id', self.getDesignConfigId())
        $('#design-config').append(html)
      )

  # ドラッグ中イベント
  drag: ->
    element = $('#' + @id)
    @updateItemPosition(element.position().left, element.position().top)
    if window.debug
      console.log("drag: itemSize: #{JSON.stringify(@itemSize)}")

  # リサイズ時のイベント
  resize: ->
    element = $('#' + @id)
    @updateItemSize(element.width(), element.height())

  # ドラッグ完了時イベント
  dragComplete: ->
    @saveObj()

  # リサイズ完了時イベント
  resizeComplete: ->
    @saveObj()


  # CSSボタンコントロール初期化
  setupOptionMenu: ->
    self = @

    designConfigRoot = $('#' + @getDesignConfigId())
    if !designConfigRoot? || designConfigRoot.length == 0
      @makeDesignConfig()
      designConfigRoot = $('#' + @getDesignConfigId())

    # アイテム名の変更
    name = $('.item-name', designConfigRoot)
    name.val(@name)
    name.off('change').on('change', =>
      @name = name.val()
      @setItemPropToPageValue('name', @name)
    )

    # アイテム位置の変更
    x = @getJQueryElement().position().left
    y = @getJQueryElement().position().top
    w = @getJQueryElement().width()
    h = @getJQueryElement().height()
    $('.item_position_x:first', designConfigRoot).val(x)
    $('.item_position_y:first', designConfigRoot).val(y)
    $('.item_width:first', designConfigRoot).val(w)
    $('.item_height:first', designConfigRoot).val(h)
    $('.item_position_x:first, .item_position_y:first, .item_width:first, .item_height:first', designConfigRoot).off('change').on('change', =>
      itemSize = {
        x: parseInt($('.item_position_x:first', designConfigRoot).val())
        y: parseInt($('.item_position_y:first', designConfigRoot).val())
        w: parseInt($('.item_width:first', designConfigRoot).val())
        h: parseInt($('.item_height:first', designConfigRoot).val())
      }
      @updatePositionAndItemSize(itemSize)
    )

    if @constructor.actionProperties.designConfig == Constant.ItemDesignOptionType.DESIGN_TOOL

      # スライダー
      self.settingGradientSlider('design_slider_gradient', null)
      self.settingGradientDegSlider('design_slider_gradient_deg', 0, 315)
      self.settingSlider('design_slider_border_radius', 0, 100)
      self.settingSlider('design_slider_border_width', 0, 10)
      self.settingSlider('design_slider_font_size', 0, 30)
      self.settingSlider('design_slider_shadow_left', -100, 100)
      self.settingSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1)
      self.settingSlider('design_slider_shadow_size', 0, 100)
      self.settingSlider('design_slider_shadow_top', -100, 100)
      self.settingSlider('design_slider_shadowinset_left', -100, 100)
      self.settingSlider('design_slider_shadowinset_opacity', 0.0, 1.0, 0.1)
      self.settingSlider('design_slider_shadowinset_size', 0, 100)
      self.settingSlider('design_slider_shadowinset_top', -100, 100)
      self.settingSlider('design_slider_text_shadow1_left', -100, 100)
      self.settingSlider('design_slider_text_shadow1_opacity', 0.0, 1.0, 0.1)
      self.settingSlider('design_slider_text_shadow1_size', 0, 100)
      self.settingSlider('design_slider_text_shadow1_top', -100, 100)
      self.settingSlider('design_slider_text_shadow2_left', -100, 100)
      self.settingSlider('design_slider_text_shadow2_opacity', 0.0, 1.0, 0.1)
      self.settingSlider('design_slider_text_shadow2_size', 0, 100)
      self.settingSlider('design_slider_text_shadow2_top', -100, 100)

      # 背景色
      btnBgColor = $(".design_bg_color1,.design_bg_color2,.design_bg_color3,.design_bg_color4,.design_bg_color5,.design_border_color,.design_font_color", designConfigRoot)
      btnBgColor.each((idx, e) =>
        className = e.classList[0]
        colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
        ColorPickerUtil.initColorPicker(
          $(e),
          colorValue,
          (a, b, d, e) =>
            @designs.values["#{className}_value"] = b
            self.applyColorChangeByPicker(className, b)
        )
      )

      # 背景影
      btnShadowColor = $(".design_shadow_color,.design_shadowinset_color,.design_text_shadow1_color,.design_text_shadow2_color", designConfigRoot);
      btnShadowColor.each( (idx, e) =>
        className = e.classList[0]
        colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
        ColorPickerUtil.initColorPicker(
          $(e),
          colorValue,
          (a, b, d) ->
            value = "#{d.r},#{d.g},#{d.b}"
            @designs.values["#{className}_value"] = value
            self.applyColorChangeByPicker(className, value)
        )
      )

      # グラデーションStep
      btnGradientStep = $(".design_gradient_step", designConfigRoot)
      btnGradientStep.off('keyup mouseup')
      btnGradientStep.on('keyup mouseup', (e) ->
        self.applyGradientStepChange(e.currentTarget)
      ).each( ->
        self.applyGradientStepChange(@)
      )

  # 通常スライダーの作成
  # @param [Int] id メーターのElementID
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Int] stepValue 進捗数
  settingSlider: (className, min, max, stepValue = 0) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    meterElement = $(".#{className}", designConfigRoot)
    valueElement = $(".#{className}_value", designConfigRoot)
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
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
      slide: (event, ui) =>
        valueElement.val(ui.value)
        valueElement.html(ui.value)
        classNames = $(event.target).attr('class').split(' ')
        n = $.grep(classNames, (s) -> s.indexOf('design_') >= 0)[0]
        @designs.values["#{n}_value"] = ui.value
        @applyDesignStyleChange(n, ui.value)
    })

  # HTML要素からグラデーションスライダーの作成
  # @param [Object] element HTML要素
  # @param [Array] values 値の配列
  settingGradientSliderByElement: (element, values) ->
    try
      element.slider('destroy')
    catch #例外は握りつぶす
    element.slider({
      # 0%と100%は含まない
      min: 1
      max: 99
      values: values
      slide: (event, ui) =>
        index = $(ui.handle).index()
        classNames = $(event.target).attr('class').split(' ')
        n = $.grep(classNames, (s) -> s.indexOf('design_') >= 0)[0]
        @designs.values["#{n}_value"] = ui.value
        @applyGradientStyleChange(index, n, ui.value)
    })

    handleElement = element.children('.ui-slider-handle')
    if values == null
      handleElement.hide()
    else
      handleElement.show()

  # グラデーションスライダーの作成
  # @param [Int] id HTML要素のID
  # @param [Array] values 値の配列
  settingGradientSlider: (className, values) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    meterElement = $(".#{className}", designConfigRoot)
    @settingGradientSliderByElement(meterElement, values)

  # グラデーション方向スライダーの作成
  # @param [Int] id メーターのElementID
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  settingGradientDegSlider: (className, min, max) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    meterElement = $('.' + className, designConfigRoot)
    valueElement = $('.' + className + '_value', designConfigRoot)
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
    valueElement.val(defaultValue)
    valueElement.html(defaultValue)

    try
      meterElement.slider('destroy')
    catch #例外は握りつぶす
    meterElement.slider({
      min: min,
      max: max,
      step: 45,
      value: defaultValue
      slide: (event, ui) =>
        valueElement.val(ui.value)
        valueElement.html(ui.value)
        classNames = $(event.target).attr('class').split(' ')
        n = $.grep(classNames, (s) -> s.indexOf('design_') >= 0)[0]
        @designs.values["#{n}_value"] = ui.value
        @applyGradientDegChange(n, ui.value)
    })

  # グラデーションの表示変更(スライダーのハンドル&カラーピッカー)
  # @param [Object] element HTML要素
  changeGradientShow: (targetElement) ->
    designConfigRoot = $('#' + @getDesignConfigId())
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

      @settingGradientSliderByElement(meterElement, values)
      @switchGradientColorSelectorVisible(value, designConfigRoot)

  # グラデーションのカラーピッカー表示切り替え
  # @param [Int] gradientStepValue 現在のグラデーション数
  switchGradientColorSelectorVisible: (gradientStepValue) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    for i in [2 .. 4]
      element = $('.design_bg_color' + i, designConfigRoot)
      if i > gradientStepValue - 1
        element.hide()
      else
        element.show()
