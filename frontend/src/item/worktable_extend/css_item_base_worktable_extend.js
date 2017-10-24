/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
window.cssItemBaseWorktableExtend = {

  // 描画終了
  // @param [Int] zindex z-index
  // @param [boolean] show 要素作成後に描画を表示するか
  endDraw(zindex, show, callback = null) {
    if(show === null) {
      show = true;
    }
    this.zindex = zindex;
    // スクロールビュー分のxとyを追加
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    this.applyDefaultDesign();
    return this.drawAndMakeConfigsAndWritePageValue(show, callback);
  },

  // デザインツールメニュー設定
  setupDesignToolOptionMenu() {
    let className, colorValue, i, stepValue, value;
    const designConfigRoot = $(`#${this.getDesignConfigId()}`);

    // スライダー
    this.settingGradientSlider('design_slider_gradient', null);
    this.settingGradientDegSlider('design_slider_gradient_deg', 0, 315);
    this.settingDesignSlider('design_slider_border_radius', 0, 100);
    this.settingDesignSlider('design_slider_border_width', 0, 10);
    this.settingDesignSlider('design_slider_font_size', 0, 30);
    this.settingDesignSlider('design_slider_shadow_left', -100, 100);
    this.settingDesignSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1);
    this.settingDesignSlider('design_slider_shadow_size', 0, 100);
    this.settingDesignSlider('design_slider_shadow_top', -100, 100);
    this.settingDesignSlider('design_slider_shadowinset_left', -100, 100);
    this.settingDesignSlider('design_slider_shadowinset_opacity', 0.0, 1.0, 0.1);
    this.settingDesignSlider('design_slider_shadowinset_size', 0, 100);
    this.settingDesignSlider('design_slider_shadowinset_top', -100, 100);
    this.settingDesignSlider('design_slider_text_shadow1_left', -100, 100);
    this.settingDesignSlider('design_slider_text_shadow1_opacity', 0.0, 1.0, 0.1);
    this.settingDesignSlider('design_slider_text_shadow1_size', 0, 100);
    this.settingDesignSlider('design_slider_text_shadow1_top', -100, 100);
    this.settingDesignSlider('design_slider_text_shadow2_left', -100, 100);
    this.settingDesignSlider('design_slider_text_shadow2_opacity', 0.0, 1.0, 0.1);
    this.settingDesignSlider('design_slider_text_shadow2_size', 0, 100);
    this.settingDesignSlider('design_slider_text_shadow2_top', -100, 100);

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
        this.designs.flags[`design_bg_color${i}_moz_flag`] = i <= (stepValue - 1);
        this.designs.flags[`design_bg_color${i}_webkit_flag`] = i <= (stepValue - 1);
      }
      return this.applyGradientStepChange(e.currentTarget);
    }).each((idx, e) => {
      stepValue = 2;
      for(i = 2; i <= 4; i++) {
        if(!this.designs.flags[`design_bg_color${i}_moz_flag`]) {
          stepValue = i;
          break;
        }
      }
      $(e).val(stepValue);
      for(i = 2; i <= 4; i++) {
        this.designs.flags[`design_bg_color${i}_moz_flag`] = i <= (stepValue - 1);
        this.designs.flags[`design_bg_color${i}_webkit_flag`] = i <= (stepValue - 1);
      }
      this._cssDesignToolStyle.text(this._cssDesignToolCode.text());
      return this.saveDesign();
    });
  },

  // デザイン変更を反映
  applyDesignStyleChange(designKeyName, value, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    const cssCodeElement = $(`.${designKeyName}_value`, this._cssDesignToolCode);
    cssCodeElement.html(value);
    return this.applyDesignChange(doStyleSave);
  },

  // グラデーションデザイン変更を反映
  applyGradientStyleChange(index, designKeyName, value, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    const position = $(`.design_bg_color${index + 2}_position_value`, this._cssDesignToolCode);
    position.html((`0${value}`).slice(-2));
    return this.applyDesignStyleChange(designKeyName, value, doStyleSave);
  },

  // グラデーション方向変更を反映
  applyGradientDegChange(designKeyName, value, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    const webkitDeg = {
      0: 'left top, left bottom',
      45: 'right top, left bottom',
      90: 'right top, left top',
      135: 'right bottom, left top',
      180: 'left bottom, left top',
      225: 'left bottom, right top',
      270: 'left top, right top',
      315: 'left top, right bottom'
    };
    this.designs.values[`${designKeyName}_value_webkit_value`] = webkitDeg[value];
    const webkitValueElement = $(`.${designKeyName}_value_webkit_value`, this._cssDesignToolCode);
    webkitValueElement.html(webkitDeg[value]);
    return this.applyDesignStyleChange(designKeyName, value, doStyleSave);
  },

  applyGradientStepChange(target, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    this.changeGradientShow(target);
    const stepValue = parseInt($(target).val());
    for(let i = 2; i <= 4; i++) {
      const className = `design_bg_color${i}`;
      const mozFlag = $(`.${className}_moz_flag`, this._cssRoot);
      const mozCache = $(`.${className}_moz_cache`, this._cssDesignToolCache);
      const webkitFlag = $(`.${className}_webkit_flag`, this._cssRoot);
      const webkitCache = $(`.${className}_webkit_cache`, this._cssDesignToolCache);
      if(i > (stepValue - 1)) {
        const mh = mozFlag.html();
        if(mh.length > 0) {
          mozCache.html(mh);
        }
        const wh = webkitFlag.html();
        if(wh.length > 0) {
          webkitCache.html(wh);
        }
        $(mozFlag).empty();
        $(webkitFlag).empty();
      } else {
        mozFlag.html(mozCache.html());
        webkitFlag.html(webkitCache.html());
      }
    }
    return this.applyDesignChange(doStyleSave);
  },

  applyColorChangeByPicker(designKeyName, value, doStyleSave) {
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    const codeEmt = $(`.${designKeyName}_value`, this._cssDesignToolCode);
    codeEmt.text(value);
    return this.applyDesignChange(doStyleSave);
  }
};