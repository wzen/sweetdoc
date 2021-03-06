cssItemBaseWorktableExtend =

  # 描画終了
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true, callback = null) ->
    @zindex = zindex
    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()
    @applyDefaultDesign()
    @drawAndMakeConfigsAndWritePageValue(show, callback)

  # デザインツールメニュー設定
  setupDesignToolOptionMenu: ->
    designConfigRoot = $('#' + @getDesignConfigId())

    # スライダー
    @settingGradientSlider('design_slider_gradient', null)
    @settingGradientDegSlider('design_slider_gradient_deg', 0, 315)
    @settingDesignSlider('design_slider_border_radius', 0, 100)
    @settingDesignSlider('design_slider_border_width', 0, 10)
    @settingDesignSlider('design_slider_font_size', 0, 30)
    @settingDesignSlider('design_slider_shadow_left', -100, 100)
    @settingDesignSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1)
    @settingDesignSlider('design_slider_shadow_size', 0, 100)
    @settingDesignSlider('design_slider_shadow_top', -100, 100)
    @settingDesignSlider('design_slider_shadowinset_left', -100, 100)
    @settingDesignSlider('design_slider_shadowinset_opacity', 0.0, 1.0, 0.1)
    @settingDesignSlider('design_slider_shadowinset_size', 0, 100)
    @settingDesignSlider('design_slider_shadowinset_top', -100, 100)
    @settingDesignSlider('design_slider_text_shadow1_left', -100, 100)
    @settingDesignSlider('design_slider_text_shadow1_opacity', 0.0, 1.0, 0.1)
    @settingDesignSlider('design_slider_text_shadow1_size', 0, 100)
    @settingDesignSlider('design_slider_text_shadow1_top', -100, 100)
    @settingDesignSlider('design_slider_text_shadow2_left', -100, 100)
    @settingDesignSlider('design_slider_text_shadow2_opacity', 0.0, 1.0, 0.1)
    @settingDesignSlider('design_slider_text_shadow2_size', 0, 100)
    @settingDesignSlider('design_slider_text_shadow2_top', -100, 100)

    # 背景色
    btnBgColor = $(".design_bg_color1,.design_bg_color2,.design_bg_color3,.design_bg_color4,.design_bg_color5,.design_border_color,.design_font_color", designConfigRoot)
    btnBgColor.each((idx, e) =>
      className = e.classList[0]
      colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
      ColorPickerUtil.initColorPicker(
        $(e),
        colorValue,
        (a, b, d, e) =>
          value = "#{b}"
          @designs.values["#{className}_value"] = value
          @applyColorChangeByPicker(className, value)
      )
    )

    # 背景影
    btnShadowColor = $(".design_shadow_color,.design_shadowinset_color,.design_text_shadow1_color,.design_text_shadow2_color", designConfigRoot);
    btnShadowColor.each((idx, e) =>
      className = e.classList[0]
      colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
      ColorPickerUtil.initColorPicker(
        $(e),
        colorValue,
        (a, b, d) =>
          value = "#{d.r},#{d.g},#{d.b}"
          @designs.values["#{className}_value"] = value
          @applyColorChangeByPicker(className, value)
      )
    )

    # グラデーションStep
    btnGradientStep = $(".design_gradient_step", designConfigRoot)
    btnGradientStep.off('keyup mouseup')
    btnGradientStep.on('keyup mouseup', (e) =>
      stepValue = parseInt($(e.currentTarget).val())
      for i in [2 .. 4]
        @designs.flags["design_bg_color#{i}_moz_flag"] = i <= stepValue - 1
        @designs.flags["design_bg_color#{i}_webkit_flag"] = i <= stepValue - 1
      @applyGradientStepChange(e.currentTarget)
    ).each((idx, e) =>
      stepValue = 2
      for i in [2 .. 4]
        if !@designs.flags["design_bg_color#{i}_moz_flag"]
          stepValue = i
          break
      $(e).val(stepValue)
      for i in [2 .. 4]
        @designs.flags["design_bg_color#{i}_moz_flag"] = i <= stepValue - 1
        @designs.flags["design_bg_color#{i}_webkit_flag"] = i <= stepValue - 1
      @_cssDesignToolStyle.text(@_cssDesignToolCode.text())
      @saveDesign()
    )

  # デザイン変更を反映
  applyDesignStyleChange: (designKeyName, value, doStyleSave = true) ->
    cssCodeElement = $('.' + designKeyName + '_value', @_cssDesignToolCode)
    cssCodeElement.html(value)
    @applyDesignChange(doStyleSave)

  # グラデーションデザイン変更を反映
  applyGradientStyleChange: (index, designKeyName, value, doStyleSave = true) ->
    position = $('.design_bg_color' + (index + 2) + '_position_value', @_cssDesignToolCode)
    position.html(("0" + value).slice(-2))
    @applyDesignStyleChange(designKeyName, value, doStyleSave)

  # グラデーション方向変更を反映
  applyGradientDegChange: (designKeyName, value, doStyleSave = true) ->
    webkitDeg = {
      0: 'left top, left bottom',
      45: 'right top, left bottom',
      90: 'right top, left top',
      135: 'right bottom, left top',
      180: 'left bottom, left top',
      225: 'left bottom, right top',
      270: 'left top, right top',
      315: 'left top, right bottom'
    }
    @designs.values["#{designKeyName}_value_webkit_value"] = webkitDeg[value]
    webkitValueElement = $('.' + designKeyName + '_value_webkit_value', @_cssDesignToolCode)
    webkitValueElement.html(webkitDeg[value])
    @applyDesignStyleChange(designKeyName, value, doStyleSave)

  applyGradientStepChange: (target, doStyleSave = true) ->
    @changeGradientShow(target)
    stepValue = parseInt($(target).val())
    for i in [2 .. 4]
      className = 'design_bg_color' + i
      mozFlag = $("." + className + "_moz_flag", @_cssRoot)
      mozCache = $("." + className + "_moz_cache", @_cssDesignToolCache)
      webkitFlag = $("." + className + "_webkit_flag", @_cssRoot)
      webkitCache = $("." + className + "_webkit_cache", @_cssDesignToolCache)
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
    @applyDesignChange(doStyleSave)

  applyColorChangeByPicker: (designKeyName, value, doStyleSave = true) ->
    codeEmt = $(".#{designKeyName}_value", @_cssDesignToolCode)
    codeEmt.text(value)
    @applyDesignChange(doStyleSave)