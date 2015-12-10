# Canvas
WorkTableCanvasItemExtend =
  # 描画終了
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true, callback = null) ->
    @zindex = zindex

    # TODO: 汎用的に修正
    # 座標を新規キャンパス用に修正
    do =>
      @coodRegist.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @_coodLeftBodyPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @_coodRightBodyPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @_coodHeadPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )

    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()
    @applyDefaultDesign()
    @drawAndMakeConfigsAndWritePageValue(show, =>
      # Canvas状態を保存
      @saveNewDrawedSurface()
      if callback?
        callback()
    )

  # デザインツールメニュー設定
  setupDesignToolOptionMenu: ->
    self = @
    designConfigRoot = $('#' + @getDesignConfigId())

    # スライダー
    self.settingGradientSlider('design_slider_gradient', null)
    self.settingGradientDegSlider('design_slider_gradient_deg', 0, 315, false)
    self.settingDesignSlider('design_slider_border_radius', 1, 100)
    self.settingDesignSlider('design_slider_border_width', 0, 30)
    self.settingDesignSlider('design_slider_font_size', 0, 30)
    self.settingDesignSlider('design_slider_shadow_left', -100, 100)
    self.settingDesignSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1)
    self.settingDesignSlider('design_slider_shadow_size', 0, 100)
    self.settingDesignSlider('design_slider_shadow_top', -100, 100)

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
        (a, b, d) =>
          value = "#{d.r},#{d.g},#{d.b}"
          @designs.values["#{className}_value"] = value
          self.applyColorChangeByPicker(className, value)
      )
    )

    # グラデーションStep
    btnGradientStep = $(".design_gradient_step", designConfigRoot)
    btnGradientStep.off('keyup mouseup')
    btnGradientStep.on('keyup mouseup', (e) =>
      stepValue = parseInt($(e.currentTarget).val())
      for i in [2 .. 4]
        @designs.flags["design_bg_color#{i}_flag"] = i <= stepValue - 1
      self.applyGradientStepChange(e.currentTarget)
    ).each( (idx, e) =>
      stepValue = 2
      for i in [2 .. 4]
        if !@designs.flags["design_bg_color#{i}_flag"]
          stepValue = i
          break
      $(e).val(stepValue)
      for i in [2 .. 4]
        @designs.flags["design_bg_color#{i}_flag"] = i <= stepValue - 1
      self.applyGradientStepChange(e)
    )

  # デザイン変更を反映
  applyDesignStyleChange: (designKeyName, value, doStyleSave = true) ->
    @applyDesignChange(doStyleSave)

  # グラデーションデザイン変更を反映
  applyGradientStyleChange: (index, designKeyName, value, doStyleSave = true) ->
    @applyDesignChange(doStyleSave)

  # グラデーション方向変更を反映
  applyGradientDegChange: (designKeyName, value, doStyleSave = true) ->
    @applyDesignChange(doStyleSave)

  # グラデーションステップ数変更を反映
  applyGradientStepChange: (target, doStyleSave = true) ->
    @applyDesignChange(doStyleSave)

  # カラーピッカー変更を反映
  applyColorChangeByPicker: (designKeyName, value, doStyleSave = true) ->
    @applyDesignChange(doStyleSave)
