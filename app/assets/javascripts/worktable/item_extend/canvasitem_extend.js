// Generated by CoffeeScript 1.9.2
var WorkTableCanvasItemExtend;

WorkTableCanvasItemExtend = {
  endDraw: function(zindex, show) {
    if (show == null) {
      show = true;
    }
    this.zindex = zindex;
    (function(_this) {
      return (function() {
        _this.coodRegist.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        _this.coodLeftBodyPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        _this.coodRightBodyPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        return _this.coodHeadPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
      });
    })(this)();
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    this.applyDefaultDesign();
    this.drawAndMakeConfigsAndWritePageValue(show);
    this.saveNewDrawedSurface();
    return true;
  },
  setupDesignToolOptionMenu: function() {
    var btnBgColor, btnGradientStep, btnShadowColor, designConfigRoot, self;
    self = this;
    designConfigRoot = $('#' + this.getDesignConfigId());
    self.settingGradientSlider('design_slider_gradient', null);
    self.settingGradientDegSlider('design_slider_gradient_deg', 0, 315);
    self.settingSlider('design_slider_border_radius', 0, 100);
    self.settingSlider('design_slider_border_width', 0, 10);
    self.settingSlider('design_slider_font_size', 0, 30);
    self.settingSlider('design_slider_shadow_left', -100, 100);
    self.settingSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1);
    self.settingSlider('design_slider_shadow_size', 0, 100);
    self.settingSlider('design_slider_shadow_top', -100, 100);
    self.settingSlider('design_slider_shadowinset_left', -100, 100);
    self.settingSlider('design_slider_shadowinset_opacity', 0.0, 1.0, 0.1);
    self.settingSlider('design_slider_shadowinset_size', 0, 100);
    self.settingSlider('design_slider_shadowinset_top', -100, 100);
    self.settingSlider('design_slider_text_shadow1_left', -100, 100);
    self.settingSlider('design_slider_text_shadow1_opacity', 0.0, 1.0, 0.1);
    self.settingSlider('design_slider_text_shadow1_size', 0, 100);
    self.settingSlider('design_slider_text_shadow1_top', -100, 100);
    self.settingSlider('design_slider_text_shadow2_left', -100, 100);
    self.settingSlider('design_slider_text_shadow2_opacity', 0.0, 1.0, 0.1);
    self.settingSlider('design_slider_text_shadow2_size', 0, 100);
    self.settingSlider('design_slider_text_shadow2_top', -100, 100);
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
          this.designs.values[className + "_value"] = value;
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
        return self.applyGradientStepChange(e);
      };
    })(this));
  },
  applyDesignStyleChange: function(doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    this.cssStyle.text(this.cssCode.text());
    if (doStyleSave) {
      if (this.cssStypeReflectTimer != null) {
        clearTimeout(this.cssStypeReflectTimer);
        this.cssStypeReflectTimer = null;
      }
      return this.cssStypeReflectTimer = setTimeout((function(_this) {
        return function() {
          _this.setItemAllPropToPageValue();
          LocalStorage.saveAllPageValues();
          return _this.cssStypeReflectTimer = setTimeout(function() {
            return OperationHistory.add();
          }, 1000);
        };
      })(this), 500);
    }
  },
  applyGradientStyleChange: function(index, designKeyName, value, doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    return this.reDraw();
  },
  applyGradientDegChange: function(designKeyName, value, doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    return this.reDraw();
  },
  applyGradientStepChange: function(target) {
    return this.reDraw();
  },
  applyColorChangeByPicker: function(designKeyName, value, doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    return this.reDraw();
  },
  applyDesignTool: function(drawingContext) {
    return drawingContext.fillStyle = "#00008B";
  }
};

//# sourceMappingURL=canvasitem_extend.js.map
