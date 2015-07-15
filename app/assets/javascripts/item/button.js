// Generated by CoffeeScript 1.9.2
var ButtonItem, WorkTableButtonItem,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ButtonItem = (function(superClass) {
  extend(ButtonItem, superClass);

  ButtonItem.IDENTITY = "Button";

  ButtonItem.ITEM_ID = Constant.ItemId.BUTTON;

  function ButtonItem(cood) {
    if (cood == null) {
      cood = null;
    }
    this.defaultClick = bind(this.defaultClick, this);
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

  ButtonItem.prototype.endDraw = function(zindex, show) {
    if (show == null) {
      show = true;
    }
    if (!ButtonItem.__super__.endDraw.call(this, zindex)) {
      return false;
    }
    this.makeElement(show);
    return true;
  };

  ButtonItem.prototype.reDraw = function(show) {
    if (show == null) {
      show = true;
    }
    return this.makeElement(show);
  };

  ButtonItem.prototype.makeElement = function(show) {
    if (show == null) {
      show = true;
    }
    $(ElementCode.get().createItemElement(this)).appendTo('#scroll_inside');
    if (!show) {
      return false;
    }
  };

  ButtonItem.prototype.getMinimumObject = function() {
    var newobj, obj;
    obj = ButtonItem.__super__.getMinimumObject.call(this);
    newobj = {
      itemId: Constant.ItemId.BUTTON,
      mousedownCood: makeClone(this.mousedownCood),
      css: makeClone(this.css)
    };
    $.extend(obj, newobj);
    return obj;
  };

  ButtonItem.prototype.setMiniumObject = function(obj) {
    ButtonItem.__super__.setMiniumObject.call(this, obj);
    this.mousedownCood = makeClone(obj.mousedownCood);
    return this.css = makeClone(obj.css);
  };

  ButtonItem.prototype.reDrawByMinimumObject = function(obj) {
    this.setMiniumObject(obj);
    this.reDraw();
    return this.saveObj(Constant.ItemActionType.MAKE);
  };

  ButtonItem.prototype.defaultClick = function(e) {
    this.getJQueryElement().addClass('dentButton_' + this.id);
    return this.getJQueryElement().on('webkitAnimationEnd animationend', (function(_this) {
      return function(e) {
        return _this.nextChapter();
      };
    })(this));
  };

  ButtonItem.dentButton = function(buttonItem) {
    var css, emt, funcName, height, keyFrameName, keyframe, left, mozKeyframe, top, webkitKeyframe, width;
    funcName = 'dentButton_' + buttonItem.id;
    keyFrameName = funcName + "_" + buttonItem.id;
    emt = buttonItem.getJQueryElement();
    top = emt.css('top');
    left = emt.css('left');
    width = emt.css('width');
    height = emt.css('height');
    keyframe = keyFrameName + " {\n  0% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n  40% {\n    top: " + (parseInt(top) + 10) + "px;\n    left: " + (parseInt(left) + 10) + "px;\n    width: " + (parseInt(width) - 20) + "px;\n    height: " + (parseInt(height) - 20) + "px;\n  }\n  80% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n  90% {\n    top: " + (parseInt(top) + 5) + "px;\n    left: " + (parseInt(left) + 5) + "px;\n    width: " + (parseInt(width) - 10) + "px;\n    height: " + (parseInt(height) - 10) + "px;\n  }\n  100% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n}";
    webkitKeyframe = "@-webkit-keyframes " + keyframe;
    mozKeyframe = "@-moz-keyframes " + keyframe;
    css = "." + funcName + "\n{\n-webkit-animation-name: " + keyFrameName + ";\n-moz-animation-name: " + keyFrameName + ";\n-webkit-animation-duration: 0.5s;\n-moz-animation-duration: 0.5s;\n}";
    return webkitKeyframe + " " + mozKeyframe + " " + css;
  };

  return ButtonItem;

})(CssItemBase);

window.loadedClassList.ButtonItem = ButtonItem;

if (window.worktablePage != null) {
  WorkTableButtonItem = (function(superClass) {
    extend(WorkTableButtonItem, superClass);

    WorkTableButtonItem.include(WorkTableCommonExtend);

    WorkTableButtonItem.include(WorkTableCssItemExtend);

    WorkTableButtonItem.CSSTEMPID = "button_css_temp";

    function WorkTableButtonItem(cood) {
      if (cood == null) {
        cood = null;
      }
      WorkTableButtonItem.__super__.constructor.call(this, cood);
      this.cssRoot = null;
      this.cssCache = null;
      this.cssCode = null;
      this.cssStyle = null;
    }

    WorkTableButtonItem.prototype.getMinimumObject = function() {
      var obj;
      obj = WorkTableButtonItem.__super__.getMinimumObject.call(this);
      obj.css = this.cssRoot[0].outerHTML;
      return obj;
    };

    WorkTableButtonItem.prototype.makeElement = function(show) {
      var newEmt;
      if (show == null) {
        show = true;
      }
      WorkTableButtonItem.__super__.makeElement.call(this, show);
      if (this.css != null) {
        newEmt = $(this.css);
      } else {
        newEmt = $('#' + WorkTableButtonItem.CSSTEMPID).clone(true).attr('id', this.getCssRootElementId());
        newEmt.find('.btn-item-id').html(this.id);
      }
      $('#css_code_info').append(newEmt);
      this.cssRoot = $('#' + this.getCssRootElementId());
      this.cssCache = $(".css-cache", this.cssRoot);
      this.cssCode = $(".css-code", this.cssRoot);
      this.cssStyle = $(".css-style", this.cssRoot);
      this.cssStyle.text(this.cssCode.text());
      this.makeDesignConfig();
      TLEItemChange.writeDefaultToPageValue(this);
      return true;
    };

    WorkTableButtonItem.prototype.setupOptionMenu = function() {
      var btnBgColor, btnGradientStep, btnShadowColor, cssCache, cssCode, cssRoot, cssStyle, name;
      cssRoot = this.cssRoot;
      cssCache = this.cssCache;
      cssCode = this.cssCode;
      cssStyle = this.cssStyle;
      this.designConfigRoot = $('#' + this.getDesignConfigId());
      if (this.designConfigRoot == null) {
        this.makeDesignConfig();
      }
      this.cssConfig = $(".css-config", this.designConfigRoot);
      this.canvasConfig = $(".canvas-config", this.designConfigRoot);
      btnGradientStep = $(".btn-gradient-step", this.cssConfig);
      btnBgColor = $(".btn-bg-color1,.btn-bg-color2,.btn-bg-color3,.btn-bg-color4,.btn-bg-color5,.btn-border-color,.btn-font-color", this.cssConfig);
      btnShadowColor = $(".btn-shadow-color,.btn-shadowinset-color,.btn-text-shadow1-color,.btn-text-shadow2-color", this.cssConfig);
      name = $('.item-name', this.designConfigRoot);
      name.val(this.name);
      name.off('change').on('change', (function(_this) {
        return function() {
          _this.name = name.val();
          return _this.setItemPropToPageValue('name', _this.name);
        };
      })(this));
      settingGradientSlider('btn-slider-gradient', null, cssCode, cssStyle, this.designConfigRoot);
      settingGradientDegSlider('btn-slider-gradient-deg', 0, 315, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-border-radius', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-border-width', 0, 10, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-font-size', 0, 30, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-shadow-left', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-shadow-opacity', 0.0, 1.0, cssCode, cssStyle, this.designConfigRoot, 0.1);
      settingSlider('btn-slider-shadow-size', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-shadow-top', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-shadowinset-left', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-shadowinset-opacity', 0.0, 1.0, cssCode, cssStyle, this.designConfigRoot, 0.1);
      settingSlider('btn-slider-shadowinset-size', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-shadowinset-top', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-text-shadow1-left', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-text-shadow1-opacity', 0.0, 1.0, cssCode, cssStyle, this.designConfigRoot, 0.1);
      settingSlider('btn-slider-text-shadow1-size', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-text-shadow1-top', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-text-shadow2-left', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-text-shadow2-opacity', 0.0, 1.0, cssCode, cssStyle, this.designConfigRoot, 0.1);
      settingSlider('btn-slider-text-shadow2-size', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      settingSlider('btn-slider-text-shadow2-top', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      btnBgColor.each(function() {
        var btnCodeEmt, className, colorValue, self;
        self = $(this);
        className = self[0].classList[0];
        btnCodeEmt = cssCode.find("." + className).first();
        colorValue = btnCodeEmt.text();
        return initColorPicker(self, colorValue, function(a, b, d) {
          btnCodeEmt = cssCode.find("." + className);
          btnCodeEmt.text(b);
          return cssStyle.text(cssCode.text());
        });
      });
      btnShadowColor.each(function() {
        var btnCodeEmt, className, colorValue, self;
        self = $(this);
        className = self[0].classList[0];
        btnCodeEmt = cssCode.find("." + className).first();
        colorValue = btnCodeEmt.text();
        return initColorPicker(self, colorValue, function(a, b, d) {
          btnCodeEmt = cssCode.find("." + className);
          btnCodeEmt.text(d.r + "," + d.g + "," + d.b);
          return cssStyle.text(cssCode.text());
        });
      });
      btnGradientStep.off('keyup mouseup');
      return btnGradientStep.on('keyup mouseup', function(e) {
        var className, i, j, mh, mozCache, mozFlag, stepValue, webkitCache, webkitFlag, wh;
        changeGradientShow(e.currentTarget, cssCode, cssStyle, this.cssConfig);
        stepValue = parseInt($(e.currentTarget).val());
        for (i = j = 2; j <= 4; i = ++j) {
          className = 'btn-bg-color' + i;
          mozFlag = $("." + className + "-moz-flag", cssRoot);
          mozCache = $("." + className + "-moz-cache", cssRoot);
          webkitFlag = $("." + className + "-webkit-flag", cssRoot);
          webkitCache = $("." + className + "-webkit-cache", cssRoot);
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
        var className, i, j, mh, mozCache, mozFlag, stepValue, webkitCache, webkitFlag, wh;
        changeGradientShow(this, cssCode, cssStyle, this.cssConfig);
        stepValue = parseInt($(this).val());
        for (i = j = 2; j <= 4; i = ++j) {
          className = 'btn-bg-color' + i;
          mozFlag = $("." + className + "-moz-flag", cssRoot);
          mozCache = $("." + className + "-moz-cache", cssRoot);
          webkitFlag = $("." + className + "-webkit-flag", cssRoot);
          webkitCache = $("." + className + "-webkit-cache", cssRoot);
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

    return WorkTableButtonItem;

  })(ButtonItem);
  window.loadedClassList.WorkTableButtonItem = WorkTableButtonItem;
}

if ((window.itemInitFuncList != null) && (window.itemInitFuncList.buttonInit == null)) {
  window.itemInitFuncList.buttonInit = function(option) {
    var css_temp, tempEmt;
    if (option == null) {
      option = {};
    }
    window.loadedItemTypeList.push(Constant.ItemId.BUTTON);
    if (option.isWorkTable != null) {
      css_temp = option.css_temp;
      if (css_temp != null) {
        tempEmt = "<div id='" + WorkTableButtonItem.CSSTEMPID + "'>" + css_temp + "</div>";
        return $('#css_code_info_temp').append(tempEmt);
      }
    }
  };
}

//# sourceMappingURL=button.js.map
