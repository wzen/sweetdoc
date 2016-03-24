canvasItemBaseWorktableExtend =
  # 描画終了
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true, callback = null) ->
    @zindex = zindex

    # 座標を新規キャンパス用に修正
    rex = new RegExp("#{Constant.CANVAS_ITEM_COORDINATE_VAR_SURFIX}$")
    for k, v of @
      if k.match(rex)
        v.forEach((e) =>
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

  # リサイズ時のイベント
  resize: (size, originalSize) ->
    scale = WorktableCommon.getWorktableViewScale()
    diff = {
      width: (size.width - originalSize.width) / scale
      height: (size.height - originalSize.height) / scale
    }
    size.width = originalSize.width + diff.width
    size.height = originalSize.height + diff.height
    @updateItemSize(size.width, size.height)
    WorktableCommon.updateEditSelectBorderSize(@getJQueryElement())
    # キャンパスはリサイズ時に再描画する
    @refresh()
    if window.debug
      console.log("resize: size:")
      console.log(size)
      console.log("resize: itemSize: #{JSON.stringify(@itemSize)}")

  # デザインツールメニュー設定
  setupDesignToolOptionMenu: ->
    designConfigRoot = $('#' + @getDesignConfigId())

    # スライダー
    @settingGradientSlider('design_slider_gradient', null)
    @settingGradientDegSlider('design_slider_gradient_deg', 0, 315, false)
    @settingDesignSlider('design_slider_border_radius', 1, 100)
    @settingDesignSlider('design_slider_border_width', 0, 30)
    @settingDesignSlider('design_slider_font_size', 0, 30)
    @settingDesignSlider('design_slider_shadow_left', -100, 100)
    @settingDesignSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1)
    @settingDesignSlider('design_slider_shadow_size', 0, 100)
    @settingDesignSlider('design_slider_shadow_top', -100, 100)

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
        @designs.flags["design_bg_color#{i}_flag"] = i <= stepValue - 1
      @applyGradientStepChange(e.currentTarget)
    ).each((idx, e) =>
      stepValue = 2
      for i in [2 .. 4]
        if !@designs.flags["design_bg_color#{i}_flag"]
          stepValue = i
          break
      $(e).val(stepValue)
      for i in [2 .. 4]
        @designs.flags["design_bg_color#{i}_flag"] = i <= stepValue - 1
      @applyGradientStepChange(e)
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
