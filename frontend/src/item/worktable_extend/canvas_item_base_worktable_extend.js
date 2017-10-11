/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const canvasItemBaseWorktableExtend = {
  // 描画終了
  // @param [Int] zindex z-index
  // @param [boolean] show 要素作成後に描画を表示するか
  endDraw(zindex, show, callback = null) {
    if(show === null) {
      show = true;
    }
    this.zindex = zindex;

    // 座標を新規キャンパス用に修正
    const rex = new RegExp(`${Constant.CANVAS_ITEM_COORDINATE_VAR_SURFIX}$`);
    for(let k in this) {
      const v = this[k];
      if(k.match(rex)) {
        v.forEach(e => {
          e.x -= this.itemSize.x;
          return e.y -= this.itemSize.y;
        });
      }
    }

    // スクロールビュー分のxとyを追加
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    this.applyDefaultDesign();
    return this.drawAndMakeConfigsAndWritePageValue(show, () => {
      // Canvas状態を保存
      this.saveNewDrawedSurface();
      if(callback !== null) {
        return callback();
      }
    });
  },

  // リサイズ時のイベント
  resize(size, originalSize) {
    const scale = WorktableCommon.getWorktableViewScale();
    const diff = {
      width: (size.width - originalSize.width) / scale,
      height: (size.height - originalSize.height) / scale
    };
    size.width = originalSize.width + diff.width;
    size.height = originalSize.height + diff.height;
    this.updateItemSize(size.width, size.height);
    WorktableCommon.updateEditSelectBorderSize(this.getJQueryElement());
    // キャンパスはリサイズ時に再描画する
    this.refresh();
    if(window.debug) {
      console.log("resize: size:");
      console.log(size);
      return console.log(`resize: itemSize: ${JSON.stringify(this.itemSize)}`);
    }
  },

  // デザインツールメニュー設定
  setupDesignToolOptionMenu() {
    let className, colorValue, i, stepValue, value;
    const designConfigRoot = $(`#${this.getDesignConfigId()}`);

    // スライダー
    this.settingGradientSlider('design_slider_gradient', null);
    this.settingGradientDegSlider('design_slider_gradient_deg', 0, 315, false);
    this.settingDesignSlider('design_slider_border_radius', 1, 100);
    this.settingDesignSlider('design_slider_border_width', 0, 30);
    this.settingDesignSlider('design_slider_font_size', 0, 30);
    this.settingDesignSlider('design_slider_shadow_left', -100, 100);
    this.settingDesignSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1);
    this.settingDesignSlider('design_slider_shadow_size', 0, 100);
    this.settingDesignSlider('design_slider_shadow_top', -100, 100);

    // 背景色
    const btnBgColor = $(".design_bg_color1,.design_bg_color2,.design_bg_color3,.design_bg_color4,.design_bg_color5,.design_border_color,.design_font_color", designConfigRoot);
    btnBgColor.each((idx, e) => {
      className = e.classList[0];
      colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(this.id, `${className}_value`));
      return ColorPickerUtil.initColorPicker(
        $(e),
        colorValue,
        (a, b, d, e) => {
          value = `${b}`;
          this.designs.values[`${className}_value`] = value;
          return this.applyColorChangeByPicker(className, value);
        });
    });

    // 背景影
    const btnShadowColor = $(".design_shadow_color,.design_shadowinset_color,.design_text_shadow1_color,.design_text_shadow2_color", designConfigRoot);
    btnShadowColor.each((idx, e) => {
      className = e.classList[0];
      colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(this.id, `${className}_value`));
      return ColorPickerUtil.initColorPicker(
        $(e),
        colorValue,
        (a, b, d) => {
          value = `${d.r},${d.g},${d.b}`;
          this.designs.values[`${className}_value`] = value;
          return this.applyColorChangeByPicker(className, value);
        });
    });

    // グラデーションStep
    const btnGradientStep = $(".design_gradient_step", designConfigRoot);
    btnGradientStep.off('keyup mouseup');
    return btnGradientStep.on('keyup mouseup', e => {
      stepValue = parseInt($(e.currentTarget).val());
      for(i = 2; i <= 4; i++) {
        this.designs.flags[`design_bg_color${i}_flag`] = i <= (stepValue - 1);
      }
      return this.applyGradientStepChange(e.currentTarget);
    }).each((idx, e) => {
      stepValue = 2;
      for(i = 2; i <= 4; i++) {
        if(!this.designs.flags[`design_bg_color${i}_flag`]) {
          stepValue = i;
          break;
        }
      }
      $(e).val(stepValue);
      for(i = 2; i <= 4; i++) {
        this.designs.flags[`design_bg_color${i}_flag`] = i <= (stepValue - 1);
      }
      return this.applyGradientStepChange(e);
    });
  },

  // デザイン変更を反映
  applyDesignStyleChange(designKeyName, value, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  },

  // グラデーションデザイン変更を反映
  applyGradientStyleChange(index, designKeyName, value, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  },

  // グラデーション方向変更を反映
  applyGradientDegChange(designKeyName, value, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  },

  // グラデーションステップ数変更を反映
  applyGradientStepChange(target, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  },

  // カラーピッカー変更を反映
  applyColorChangeByPicker(designKeyName, value, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  }
};
