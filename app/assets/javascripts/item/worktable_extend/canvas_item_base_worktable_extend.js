// Generated by CoffeeScript 1.9.2
var canvasItemBaseWorktableExtend;

canvasItemBaseWorktableExtend = {
  endDraw: function(zindex, show, callback) {
    var k, rex, v;
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    this.zindex = zindex;
    rex = new RegExp(Constant.CANVAS_ITEM_COORDINATE_VAR_SURFIX + "$");
    for (k in this) {
      v = this[k];
      if (k.match(rex)) {
        v.forEach((function(_this) {
          return function(e) {
            e.x -= _this.itemSize.x;
            return e.y -= _this.itemSize.y;
          };
        })(this));
      }
    }
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    this.applyDefaultDesign();
    return this.drawAndMakeConfigsAndWritePageValue(show, (function(_this) {
      return function() {
        _this.saveNewDrawedSurface();
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  },
  resize: function(size, originalSize) {
    var diff, scale;
    scale = WorktableCommon.getWorktableViewScale();
    diff = {
      width: (size.width - originalSize.width) / scale,
      height: (size.height - originalSize.height) / scale
    };
    size.width = originalSize.width + diff.width;
    size.height = originalSize.height + diff.height;
    this.updateItemSize(size.width, size.height);
    WorktableCommon.updateEditSelectBorderSize(this.getJQueryElement());
    this.refresh();
    if (window.debug) {
      console.log("resize: size:");
      console.log(size);
      return console.log("resize: itemSize: " + (JSON.stringify(this.itemSize)));
    }
  },
  setupDesignToolOptionMenu: function() {
    var btnBgColor, btnGradientStep, btnShadowColor, designConfigRoot;
    designConfigRoot = $('#' + this.getDesignConfigId());
    this.settingGradientSlider('design_slider_gradient', null);
    this.settingGradientDegSlider('design_slider_gradient_deg', 0, 315, false);
    this.settingDesignSlider('design_slider_border_radius', 1, 100);
    this.settingDesignSlider('design_slider_border_width', 0, 30);
    this.settingDesignSlider('design_slider_font_size', 0, 30);
    this.settingDesignSlider('design_slider_shadow_left', -100, 100);
    this.settingDesignSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1);
    this.settingDesignSlider('design_slider_shadow_size', 0, 100);
    this.settingDesignSlider('design_slider_shadow_top', -100, 100);
    btnBgColor = $(".design_bg_color1,.design_bg_color2,.design_bg_color3,.design_bg_color4,.design_bg_color5,.design_border_color,.design_font_color", designConfigRoot);
    btnBgColor.each((function(_this) {
      return function(idx, e) {
        var className, colorValue;
        className = e.classList[0];
        colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(_this.id, className + "_value"));
        return ColorPickerUtil.initColorPicker($(e), colorValue, function(a, b, d, e) {
          var value;
          value = "" + b;
          _this.designs.values[className + "_value"] = value;
          return _this.applyColorChangeByPicker(className, value);
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
          return _this.applyColorChangeByPicker(className, value);
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
          _this.designs.flags["design_bg_color" + i + "_flag"] = i <= stepValue - 1;
        }
        return _this.applyGradientStepChange(e.currentTarget);
      };
    })(this)).each((function(_this) {
      return function(idx, e) {
        var i, j, l, stepValue;
        stepValue = 2;
        for (i = j = 2; j <= 4; i = ++j) {
          if (!_this.designs.flags["design_bg_color" + i + "_flag"]) {
            stepValue = i;
            break;
          }
        }
        $(e).val(stepValue);
        for (i = l = 2; l <= 4; i = ++l) {
          _this.designs.flags["design_bg_color" + i + "_flag"] = i <= stepValue - 1;
        }
        return _this.applyGradientStepChange(e);
      };
    })(this));
  },
  applyDesignStyleChange: function(designKeyName, value, doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  },
  applyGradientStyleChange: function(index, designKeyName, value, doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  },
  applyGradientDegChange: function(designKeyName, value, doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  },
  applyGradientStepChange: function(target, doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  },
  applyColorChangeByPicker: function(designKeyName, value, doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    return this.applyDesignChange(doStyleSave);
  }
};

//# sourceMappingURL=canvas_item_base_worktable_extend.js.map
