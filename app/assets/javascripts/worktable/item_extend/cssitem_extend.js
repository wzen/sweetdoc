// Generated by CoffeeScript 1.9.2
var WorkTableCssItemExtend;

WorkTableCssItemExtend = {
  draw: function(cood) {
    if (this.itemSize !== null) {
      this.restoreDrawingSurface(this.itemSize);
    }
    this.itemSize = {
      x: null,
      y: null,
      w: null,
      h: null
    };
    this.itemSize.w = Math.abs(cood.x - this.moveLoc.x);
    this.itemSize.h = Math.abs(cood.y - this.moveLoc.y);
    if (cood.x > this.moveLoc.x) {
      this.itemSize.x = this.moveLoc.x;
    } else {
      this.itemSize.x = cood.x;
    }
    if (cood.y > this.moveLoc.y) {
      this.itemSize.y = this.moveLoc.y;
    } else {
      this.itemSize.y = cood.y;
    }
    return drawingContext.strokeRect(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h);
  },
  endDraw: function(zindex, show) {
    if (show == null) {
      show = true;
    }
    this.zindex = zindex;
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    this.applyDefaultDesign();
    this.makeCss(true);
    this.drawAndMakeConfigsAndWritePageValue(show);
    return true;
  },
  setupDesignToolOptionMenu: function() {
    var btnBgColor, btnGradientStep, btnShadowColor, designConfigRoot, self;
    self = this;
    designConfigRoot = $('#' + this.getDesignConfigId());
    self.settingGradientSlider('design_slider_gradient', null);
    self.settingGradientDegSlider('design_slider_gradient_deg', 0, 315);
    self.settingDesignSlider('design_slider_border_radius', 0, 100);
    self.settingDesignSlider('design_slider_border_width', 0, 10);
    self.settingDesignSlider('design_slider_font_size', 0, 30);
    self.settingDesignSlider('design_slider_shadow_left', -100, 100);
    self.settingDesignSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1);
    self.settingDesignSlider('design_slider_shadow_size', 0, 100);
    self.settingDesignSlider('design_slider_shadow_top', -100, 100);
    self.settingDesignSlider('design_slider_shadowinset_left', -100, 100);
    self.settingDesignSlider('design_slider_shadowinset_opacity', 0.0, 1.0, 0.1);
    self.settingDesignSlider('design_slider_shadowinset_size', 0, 100);
    self.settingDesignSlider('design_slider_shadowinset_top', -100, 100);
    self.settingDesignSlider('design_slider_text_shadow1_left', -100, 100);
    self.settingDesignSlider('design_slider_text_shadow1_opacity', 0.0, 1.0, 0.1);
    self.settingDesignSlider('design_slider_text_shadow1_size', 0, 100);
    self.settingDesignSlider('design_slider_text_shadow1_top', -100, 100);
    self.settingDesignSlider('design_slider_text_shadow2_left', -100, 100);
    self.settingDesignSlider('design_slider_text_shadow2_opacity', 0.0, 1.0, 0.1);
    self.settingDesignSlider('design_slider_text_shadow2_size', 0, 100);
    self.settingDesignSlider('design_slider_text_shadow2_top', -100, 100);
    btnBgColor = $(".design_bg_color1,.design_bg_color2,.design_bg_color3,.design_bg_color4,.design_bg_color5,.design_border_color,.design_font_color", designConfigRoot);
    btnBgColor.each((function(_this) {
      return function(idx, e) {
        var className, colorValue;
        className = e.classList[0];
        colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(_this.id, className + "_value"));
        return ColorPickerUtil.initColorPicker($(e), colorValue, function(a, b, d, e) {
          _this.designs.values[className + "_value"] = b;
          return self.applyColorChangeByPicker(className, b);
        });
      };
    })(this));
    btnShadowColor = $(".design_shadow_color,.design_shadowinset_color,.design_text_shadow1_color,.design_text_shadow2_color", designConfigRoot);
    btnShadowColor.each((function(_this) {
      return function(idx, e) {
        var className, colorValue;
        className = e.classList[0];
        colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(_this.id, className + "_value"));
        return ColorPickerUtil.initColorPicker($(e), colorValue, function(a, b, d) {
          var value;
          value = d.r + "," + d.g + "," + d.b;
          _this.designs.values[className + "_value"] = value;
          return self.applyColorChangeByPicker(className, value);
        });
      };
    })(this));
    btnGradientStep = $(".design_gradient_step", designConfigRoot);
    btnGradientStep.off('keyup mouseup');
    return btnGradientStep.on('keyup mouseup', (function(_this) {
      return function(e) {
        var i, j, stepValue;
        stepValue = parseInt($(e.currentTarget).val());
        for (i = j = 2; j <= 4; i = ++j) {
          _this.designs.flags["design_bg_color" + i + "_moz_flag"] = i <= stepValue - 1;
          _this.designs.flags["design_bg_color" + i + "_webkit_flag"] = i <= stepValue - 1;
        }
        return self.applyGradientStepChange(e.currentTarget);
      };
    })(this)).each((function(_this) {
      return function(idx, e) {
        var i, j, k, stepValue;
        stepValue = 2;
        for (i = j = 2; j <= 4; i = ++j) {
          if (!_this.designs.flags["design_bg_color" + i + "_moz_flag"]) {
            stepValue = i;
            break;
          }
        }
        $(e).val(stepValue);
        for (i = k = 2; k <= 4; i = ++k) {
          _this.designs.flags["design_bg_color" + i + "_moz_flag"] = i <= stepValue - 1;
          _this.designs.flags["design_bg_color" + i + "_webkit_flag"] = i <= stepValue - 1;
        }
        _this.cssStyle.text(_this.cssCode.text());
        return _this.saveDesign();
      };
    })(this));
  },
  applyDesignStyleChange: function(designKeyName, value, doStyleSave) {
    var cssCodeElement;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    cssCodeElement = $('.' + designKeyName + '_value', this.cssCode);
    cssCodeElement.html(value);
    return this.applyDesignChange(doStyleSave);
  },
  applyGradientStyleChange: function(index, designKeyName, value, doStyleSave) {
    var position;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    position = $('.design_bg_color' + (index + 2) + '_position_value', this.cssCode);
    position.html(("0" + value).slice(-2));
    return this.applyDesignStyleChange(designKeyName, value, doStyleSave);
  },
  applyGradientDegChange: function(designKeyName, value, doStyleSave) {
    var webkitDeg, webkitValueElement;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    webkitDeg = {
      0: 'left top, left bottom',
      45: 'right top, left bottom',
      90: 'right top, left top',
      135: 'right bottom, left top',
      180: 'left bottom, left top',
      225: 'left bottom, right top',
      270: 'left top, right top',
      315: 'left top, right bottom'
    };
    this.designs.values[designKeyName + "_value_webkit_value"] = webkitDeg[value];
    webkitValueElement = $('.' + designKeyName + '_value_webkit_value', this.cssCode);
    webkitValueElement.html(webkitDeg[value]);
    return this.applyDesignStyleChange(designKeyName, value, doStyleSave);
  },
  applyGradientStepChange: function(target, doStyleSave) {
    var className, i, j, mh, mozCache, mozFlag, stepValue, webkitCache, webkitFlag, wh;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    this.changeGradientShow(target);
    stepValue = parseInt($(target).val());
    for (i = j = 2; j <= 4; i = ++j) {
      className = 'design_bg_color' + i;
      mozFlag = $("." + className + "_moz_flag", this.cssRoot);
      mozCache = $("." + className + "_moz_cache", this.cssRoot);
      webkitFlag = $("." + className + "_webkit_flag", this.cssRoot);
      webkitCache = $("." + className + "_webkit_cache", this.cssRoot);
      if (i > stepValue - 1) {
        mh = mozFlag.html();
        if (mh.length > 0) {
          mozCache.html(mh);
        }
        wh = webkitFlag.html();
        if (wh.length > 0) {
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
  applyColorChangeByPicker: function(designKeyName, value, doStyleSave) {
    var codeEmt;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    codeEmt = $("." + designKeyName + "_value", this.cssCode);
    codeEmt.text(value);
    return this.applyDesignChange(doStyleSave);
  }
};

//# sourceMappingURL=cssitem_extend.js.map
