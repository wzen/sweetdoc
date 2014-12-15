// Generated by CoffeeScript 1.8.0
var ButtonItem, WorkTableButtonItem,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.loadedItemTypeList.push(Constant.ItemType.BUTTON);

ButtonItem = (function(_super) {
  __extends(ButtonItem, _super);

  ButtonItem.IDENTITY = "button";

  ButtonItem.ITEMTYPE = Constant.ItemType.BUTTON;

  function ButtonItem(cood) {
    if (cood == null) {
      cood = null;
    }
    ButtonItem.__super__.constructor.call(this, cood);
    if (cood !== null) {
      this.moveLoc = {
        x: cood.x,
        y: cood.y
      };
    }
    this.css = null;
  }

  ButtonItem.prototype.draw = function(cood) {
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
  };

  ButtonItem.prototype.endDraw = function(zindex) {
    if (!ButtonItem.__super__.endDraw.call(this, zindex)) {
      return false;
    }
    return this.makeElement();
  };

  ButtonItem.prototype.reDraw = function() {
    return this.makeElement();
  };

  ButtonItem.prototype.makeElement = function() {
    $(ElementCode.get().createItemElement(this)).appendTo('#main-wrapper');
    return true;
  };

  ButtonItem.prototype.generateMinimumObject = function() {
    var obj;
    obj = {
      id: this.id,
      itemType: Constant.ItemType.BUTTON,
      mousedownCood: this.mousedownCood,
      itemSize: this.itemSize,
      zindex: this.zindex,
      css: this.css
    };
    return obj;
  };

  ButtonItem.prototype.loadByMinimumObject = function(obj) {
    this.setMiniumObject(obj);
    this.reDraw();
    return this.saveObj(Constant.ItemActionType.MAKE);
  };

  ButtonItem.prototype.setMiniumObject = function(obj) {
    this.id = obj.id;
    this.mousedownCood = obj.mousedownCood;
    this.itemSize = obj.itemSize;
    this.zindex = obj.zindex;
    return this.css = obj.css;
  };

  ButtonItem.prototype.actorClickEvent = function(e) {};

  ButtonItem.dentButton = function(buttonItem) {
    var css, emt, funcName, height, keyFrameName, keyframe, left, top, width;
    funcName = 'dentButton_' + buttonItem.id;
    keyFrameName = "" + funcName + "_" + buttonItem.id;
    emt = buttonItem.getJQueryElement();
    top = emt.css('top');
    left = emt.css('left');
    width = emt.css('width');
    height = emt.css('height');
    keyframe = "@-webkit-keyframes " + keyFrameName + " {\n  0% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n  40% {\n    top: " + (parseInt(top) + 10) + "px;\n    left: " + (parseInt(left) + 10) + "px;\n    width: " + (parseInt(width) - 20) + "px;\n    height: " + (parseInt(height) - 20) + "px;\n  }\n  80% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n  90% {\n    top: " + (parseInt(top) + 5) + "px;\n    left: " + (parseInt(left) + 5) + "px;\n    width: " + (parseInt(width) - 10) + "px;\n    height: " + (parseInt(height) - 10) + "px;\n  }\n  100% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n}";
    css = "." + funcName + "\n{\n-webkit-animation-name: " + keyFrameName + ";\n-moz-animation-name: " + keyFrameName + ";\n-webkit-animation-duration: 0.5s;\n-moz-animation-duration: 0.5s;\n}";
    return "" + keyframe + " " + css;
  };

  return ButtonItem;

})(CssItemBase);

WorkTableButtonItem = (function(_super) {
  __extends(WorkTableButtonItem, _super);

  WorkTableButtonItem.CSSTEMPID = "button_css_temp";

  WorkTableButtonItem.btnEntryForm = $("#btn-entryForm", $("#sidebar-wrapper"));

  WorkTableButtonItem.configBoxLi = $("div.configBox > div.forms", $("#sidebar-wrapper"));

  WorkTableButtonItem.btnGradientStep = $("#btn-gradient-step");

  WorkTableButtonItem.btnBgColor = $("#btn-bg-color1,#btn-bg-color2,#btn-bg-color3,#btn-bg-color4,#btn-bg-color5,#btn-border-color,#btn-font-color");

  WorkTableButtonItem.btnShadowColor = $("#btn-shadow-color,#btn-shadowinset-color,#btn-text-shadow1-color,#btn-text-shadow2-color");

  function WorkTableButtonItem(cood) {
    if (cood == null) {
      cood = null;
    }
    WorkTableButtonItem.__super__.constructor.call(this, cood);
    this.cssRoot = null;
    this.cssCode = null;
    this.cssStyle = null;
  }

  WorkTableButtonItem.prototype.generateMinimumObject = function() {
    var obj;
    obj = WorkTableButtonItem.__super__.generateMinimumObject.call(this);
    obj.css = this.cssRoot[0].outerHTML;
    return obj;
  };

  WorkTableButtonItem.prototype.makeElement = function() {
    var newEmt;
    WorkTableButtonItem.__super__.makeElement.call(this);
    if (this.css != null) {
      newEmt = $(this.css);
    } else {
      newEmt = $('#' + WorkTableButtonItem.CSSTEMPID).clone(true).attr('id', this.getCssRootElementId());
      newEmt.find('.btn-item-id').html(this.getElementId());
    }
    $('#css_code_info').append(newEmt);
    this.cssRoot = $('#' + this.getCssRootElementId());
    this.cssCode = $(".css-code", this.cssRoot);
    this.cssStyle = $(".css-style", this.cssRoot);
    this.cssStyle.text(this.cssCode.text());
    return true;
  };

  WorkTableButtonItem.prototype.setupOptionMenu = function() {
    var base, cssCode, cssRoot, cssStyle;
    base = this;
    cssRoot = this.cssRoot;
    cssCode = this.cssCode;
    cssStyle = this.cssStyle;
    settingGradientSlider('btn-slider-gradient', null);
    settingGradientDegSlider('btn-slider-gradient-deg', 0, 315, cssCode, cssStyle);
    settingSlider('btn-slider-border-radius', 0, 100, cssCode, cssStyle);
    settingSlider('btn-slider-border-width', 0, 10, cssCode, cssStyle);
    settingSlider('btn-slider-font-size', 0, 30, cssCode, cssStyle);
    settingSlider('btn-slider-shadow-left', -100, 100, cssCode, cssStyle);
    settingSlider('btn-slider-shadow-opacity', 0.0, 1.0, cssCode, cssStyle, 0.1);
    settingSlider('btn-slider-shadow-size', 0, 100, cssCode, cssStyle);
    settingSlider('btn-slider-shadow-top', -100, 100, cssCode, cssStyle);
    settingSlider('btn-slider-shadowinset-left', -100, 100, cssCode, cssStyle);
    settingSlider('btn-slider-shadowinset-opacity', 0.0, 1.0, cssCode, cssStyle, 0.1);
    settingSlider('btn-slider-shadowinset-size', 0, 100, cssCode, cssStyle);
    settingSlider('btn-slider-shadowinset-top', -100, 100, cssCode, cssStyle);
    settingSlider('btn-slider-text-shadow1-left', -100, 100, cssCode, cssStyle);
    settingSlider('btn-slider-text-shadow1-opacity', 0.0, 1.0, cssCode, cssStyle, 0.1);
    settingSlider('btn-slider-text-shadow1-size', 0, 100, cssCode, cssStyle);
    settingSlider('btn-slider-text-shadow1-top', -100, 100, cssCode, cssStyle);
    settingSlider('btn-slider-text-shadow2-left', -100, 100, cssCode, cssStyle);
    settingSlider('btn-slider-text-shadow2-opacity', 0.0, 1.0, cssCode, cssStyle, 0.1);
    settingSlider('btn-slider-text-shadow2-size', 0, 100, cssCode, cssStyle);
    settingSlider('btn-slider-text-shadow2-top', -100, 100, cssCode, cssStyle);
    WorkTableButtonItem.btnBgColor.each(function() {
      var btnCodeEmt, id, inputEmt, inputValue, self;
      self = $(this);
      id = self.attr("id");
      inputEmt = WorkTableButtonItem.btnEntryForm.find("#" + id + "-input");
      inputValue = inputEmt.attr("value");
      btnCodeEmt = cssCode.find("." + id);
      settingColorPicker(self, inputValue, function(a, b, d) {
        self.css("backgroundColor", "#" + b);
        inputEmt.attr("value", b);
        btnCodeEmt = cssCode.find("." + id);
        btnCodeEmt.text(b);
        cssCode = base.cssCode;
        cssStyle = base.cssStyle;
        return cssStyle.text(cssCode.text());
      });
      self.unbind();
      return self.mousedown(function(e) {
        e.stopPropagation();
        clearAllItemStyle();
        self.ColorPickerHide();
        return self.ColorPickerShow();
      });
    });
    WorkTableButtonItem.btnShadowColor.each(function() {
      var btnCodeEmt, e, id, inputEmt, inputValue, self;
      self = $(this);
      id = self.attr("id");
      e = WorkTableButtonItem.configBoxLi.find("#" + id + " div");
      inputEmt = WorkTableButtonItem.btnEntryForm.find("#" + id + "-input");
      inputValue = inputEmt.attr("value");
      btnCodeEmt = cssCode.find("." + id);
      settingColorPicker(self, inputValue, function(a, b, d) {
        self.css("backgroundColor", "#" + b);
        inputEmt.attr("value", b);
        btnCodeEmt = cssCode.find("." + id);
        btnCodeEmt.text(d.r + "," + d.g + "," + d.b);
        cssCode = base.cssCode;
        cssStyle = base.cssStyle;
        return cssStyle.text(cssCode.text());
      });
      self.unbind();
      return self.mousedown(function(e) {
        e.stopPropagation();
        clearAllItemStyle();
        self.ColorPickerHide();
        return self.ColorPickerShow();
      });
    });
    WorkTableButtonItem.btnGradientStep.off('keyup mouseup');
    return WorkTableButtonItem.btnGradientStep.on('keyup mouseup', function(e) {
      var i, id, mh, mozCache, mozFlag, stepValue, webkitCache, webkitFlag, wh, _i;
      cssCode = base.cssCode;
      cssStyle = base.cssStyle;
      changeGradientShow(e.currentTarget, cssCode, cssStyle);
      stepValue = parseInt($(e.currentTarget).val());
      for (i = _i = 2; _i <= 4; i = ++_i) {
        id = 'btn-bg-color' + i;
        mozFlag = $("." + id + "-moz-flag", cssRoot);
        mozCache = $("." + id + "-moz-cache", cssRoot);
        webkitFlag = $("." + id + "-webkit-flag", cssRoot);
        webkitCache = $("." + id + "-webkit-cache", cssRoot);
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
      return cssStyle.text(cssCode.text());
    }).each(function() {
      var i, id, mh, mozCache, mozFlag, stepValue, webkitCache, webkitFlag, wh, _i;
      cssCode = base.cssCode;
      cssStyle = base.cssStyle;
      changeGradientShow(this, cssCode, cssStyle);
      stepValue = parseInt($(this).val());
      for (i = _i = 2; _i <= 4; i = ++_i) {
        id = 'btn-bg-color' + i;
        mozFlag = $("." + id + "-moz-flag", cssRoot);
        mozCache = $("." + id + "-moz-cache", cssRoot);
        webkitFlag = $("." + id + "-webkit-flag", cssRoot);
        webkitCache = $("." + id + "-webkit-cache", cssRoot);
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
        }
      }
      return cssStyle.text(cssCode.text());
    });
  };

  WorkTableButtonItem.showOptionMenu = function() {};

  WorkTableButtonItem.hideOptionMenu = function() {};

  return WorkTableButtonItem;

})(ButtonItem);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList.buttonInit == null)) {
  window.itemInitFuncList.buttonInit = function(option) {
    var css_temp, tempEmt;
    if (option == null) {
      option = {};
    }
    if (option.isWorkTable != null) {
      css_temp = option.css_temp;
      if (css_temp != null) {
        tempEmt = "<div id='" + WorkTableButtonItem.CSSTEMPID + "'>" + css_temp + "</div>";
        $('#css_code_info_temp').append(tempEmt);
      }
      createColorPicker(WorkTableButtonItem.btnBgColor);
      return createColorPicker(WorkTableButtonItem.btnShadowColor);
    }
  };
}

//# sourceMappingURL=button.js.map
