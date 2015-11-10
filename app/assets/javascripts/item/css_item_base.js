// Generated by CoffeeScript 1.9.2
var CssItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

CssItemBase = (function(superClass) {
  var constant;

  extend(CssItemBase, superClass);

  CssItemBase.CSSTEMPID = '';

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    CssItemBase.DESIGN_ROOT_CLASSNAME = constant.DesignConfig.ROOT_CLASSNAME;
  }

  function CssItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
    CssItemBase.__super__.constructor.call(this, cood);
    this.cssRoot = null;
    this.cssCache = null;
    this.cssCode = null;
    this.cssStyle = null;
    if (cood !== null) {
      this.moveLoc = {
        x: cood.x,
        y: cood.y
      };
    }
    this.css = null;
    this.cssStypeReflectTimer = null;
    if (window.isWorkTable) {
      this.constructor.include(WorkTableCssItemExtend);
    }
  }

  CssItemBase.jsLoaded = function(option) {
    var css_temp, tempEmt;
    css_temp = option.css_temp;
    if (css_temp != null) {
      tempEmt = "<div id='" + this.CSSTEMPID + "'>" + css_temp + "</div>";
      return window.cssCodeInfoTemp.append(tempEmt);
    }
  };

  CssItemBase.prototype.reDraw = function(show) {
    if (show == null) {
      show = true;
    }
    CssItemBase.__super__.reDraw.call(this, show);
    this.clearDraw();
    $(ElementCode.get().createItemElement(this)).appendTo(window.scrollInside);
    if (!show) {
      this.getJQueryElement().css('opacity', 0);
    }
    if (this.setupDragAndResizeEvents != null) {
      return this.setupDragAndResizeEvents();
    }
  };

  CssItemBase.prototype.clearDraw = function() {
    return this.getJQueryElement().remove();
  };

  CssItemBase.prototype.getMinimumObject = function() {
    var newobj, obj;
    obj = CssItemBase.__super__.getMinimumObject.call(this);
    newobj = {
      itemId: this.constructor.ITEM_ID,
      mousedownCood: Common.makeClone(this.mousedownCood)
    };
    if (this.cssRoot == null) {
      this.cssRoot = $('#' + this.getCssRootElementId());
    }
    if ((this.cssRoot != null) && this.cssRoot.length > 0) {
      newobj['css'] = this.cssRoot[0].outerHTML;
    }
    $.extend(obj, newobj);
    return obj;
  };

  CssItemBase.prototype.setMiniumObject = function(obj) {
    CssItemBase.__super__.setMiniumObject.call(this, obj);
    this.mousedownCood = Common.makeClone(obj.mousedownCood);
    return this.css = Common.makeClone(obj.css);
  };

  CssItemBase.prototype.stateEventBefore = function(isForward) {
    var itemDiff, itemSize, obj;
    obj = this.getMinimumObject();
    if (!isForward) {
      itemSize = obj.itemSize;
      itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
      obj.itemSize = {
        x: itemSize.x - itemDiff.x,
        y: itemSize.y - itemDiff.y,
        w: itemSize.w - itemDiff.w,
        h: itemSize.h - itemDiff.h
      };
    }
    console.log("stateEventBefore");
    console.log(obj);
    return obj;
  };

  CssItemBase.prototype.stateEventAfter = function(isForward) {
    var itemDiff, itemSize, obj;
    obj = this.getMinimumObject();
    if (isForward) {
      obj = this.getMinimumObject();
      itemSize = obj.itemSize;
      itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
      obj.itemSize = {
        x: itemSize.x + itemDiff.x,
        y: itemSize.y + itemDiff.y,
        w: itemSize.w + itemDiff.w,
        h: itemSize.h + itemDiff.h
      };
    }
    console.log("stateEventAfter");
    console.log(obj);
    return obj;
  };

  CssItemBase.prototype.updateEventBefore = function() {
    var capturedEventBeforeObject;
    CssItemBase.__super__.updateEventBefore.call(this);
    capturedEventBeforeObject = this.getCapturedEventBeforeObject();
    if (capturedEventBeforeObject) {
      return this.updatePositionAndItemSize(Common.makeClone(capturedEventBeforeObject.itemSize), false);
    }
  };

  CssItemBase.prototype.updateEventAfter = function() {
    var capturedEventAfterObject;
    CssItemBase.__super__.updateEventAfter.call(this);
    capturedEventAfterObject = this.getCapturedEventAfterObject();
    if (capturedEventAfterObject) {
      return this.updatePositionAndItemSize(Common.makeClone(capturedEventAfterObject.itemSize), false);
    }
  };

  CssItemBase.prototype.updateItemSize = function(w, h) {
    this.getJQueryElement().css({
      width: w,
      height: h
    });
    this.itemSize.w = parseInt(w);
    return this.itemSize.h = parseInt(h);
  };

  CssItemBase.prototype.originalItemElementSize = function() {
    var capturedEventBeforeObject;
    capturedEventBeforeObject = this.getCapturedEventBeforeObject();
    return capturedEventBeforeObject.itemSize;
  };

  CssItemBase.prototype.changeCssId = function(oldObjId) {
    var reg;
    reg = new RegExp(oldObjId, 'g');
    return this.css = this.css.replace(reg, this.id);
  };

  CssItemBase.prototype.getCssRootElementId = function() {
    return "css-" + this.id;
  };

  CssItemBase.prototype.getCssAnimElementId = function() {
    return "css-anim-style";
  };

  CssItemBase.prototype.makeCss = function(fromTemp) {
    var newEmt;
    if (fromTemp == null) {
      fromTemp = false;
    }
    newEmt = null;
    $("" + (this.getCssRootElementId())).remove();
    if (!fromTemp && (this.css != null)) {
      newEmt = $(this.css);
    } else {
      newEmt = $('#' + this.constructor.CSSTEMPID).clone(true).attr('id', this.getCssRootElementId());
      newEmt.find('.design-item-id').html(this.id);
    }
    window.cssCodeInfo.append(newEmt);
    this.cssRoot = $('#' + this.getCssRootElementId());
    this.cssCache = $(".css-cache", this.cssRoot);
    this.cssCode = $(".css-code", this.cssRoot);
    this.cssStyle = $(".css-style", this.cssRoot);
    return this.reflectCssStyle(false);
  };

  CssItemBase.prototype.cssAnimationElement = function() {
    return null;
  };

  CssItemBase.prototype.appendAnimationCssIfNeeded = function() {
    var ce, funcName, methodName;
    ce = this.cssAnimationElement();
    if (ce != null) {
      methodName = this.getEventMethodName();
      this.removeCss();
      funcName = methodName + "_" + this.id;
      return window.cssCode.append("<div class='" + funcName + "'><style type='text/css'> " + ce + " </style></div>");
    }
  };

  CssItemBase.prototype.reflectCssStyle = function(doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    this.cssStyle.text(this.cssCode.text());
    if (this.cssRoot != null) {
      this.css = this.cssRoot[0].outerHTML;
    }
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
  };

  CssItemBase.prototype.removeCss = function() {
    var funcName, methodName;
    methodName = this.getEventMethodName();
    funcName = methodName + "_" + this.id;
    return window.cssCode.find("." + funcName).remove();
  };

  CssItemBase.prototype.setupOptionMenu = function() {
    var btnBgColor, btnGradientStep, btnShadowColor, cssCache, cssCode, cssRoot, cssStyle, item;
    CssItemBase.__super__.setupOptionMenu.call(this);
    item = this;
    cssRoot = this.cssRoot;
    cssCache = this.cssCache;
    cssCode = this.cssCode;
    cssStyle = this.cssStyle;
    if (this.constructor.actionProperties.designConfig === Constant.ItemDesignOptionType.DESIGN_TOOL) {
      btnGradientStep = $(".design-gradient-step", this.designConfigRoot);
      btnBgColor = $(".design-bg-color1,.design-bg-color2,.design-bg-color3,.design-bg-color4,.design-bg-color5,.design-border-color,.design-font-color", this.designConfigRoot);
      btnShadowColor = $(".design-shadow-color,.design-shadowinset-color,.design-text-shadow1-color,.design-text-shadow2-color", this.designConfigRoot);
      SidebarUI.settingGradientSlider('design-slider-gradient', null, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingGradientDegSlider('design-slider-gradient-deg', 0, 315, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-border-radius', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-border-width', 0, 10, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-font-size', 0, 30, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-shadow-left', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-shadow-opacity', 0.0, 1.0, cssCode, cssStyle, this.designConfigRoot, 0.1);
      SidebarUI.settingSlider('design-slider-shadow-size', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-shadow-top', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-shadowinset-left', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-shadowinset-opacity', 0.0, 1.0, cssCode, cssStyle, this.designConfigRoot, 0.1);
      SidebarUI.settingSlider('design-slider-shadowinset-size', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-shadowinset-top', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-text-shadow1-left', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-text-shadow1-opacity', 0.0, 1.0, cssCode, cssStyle, this.designConfigRoot, 0.1);
      SidebarUI.settingSlider('design-slider-text-shadow1-size', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-text-shadow1-top', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-text-shadow2-left', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-text-shadow2-opacity', 0.0, 1.0, cssCode, cssStyle, this.designConfigRoot, 0.1);
      SidebarUI.settingSlider('design-slider-text-shadow2-size', 0, 100, cssCode, cssStyle, this.designConfigRoot);
      SidebarUI.settingSlider('design-slider-text-shadow2-top', -100, 100, cssCode, cssStyle, this.designConfigRoot);
      btnBgColor.each(function() {
        var btnCodeEmt, className, colorValue, self;
        self = $(this);
        className = self[0].classList[0];
        btnCodeEmt = cssCode.find("." + className).first();
        colorValue = btnCodeEmt.text();
        return ColorPickerUtil.initColorPicker(self, colorValue, function(a, b, d) {
          btnCodeEmt = cssCode.find("." + className);
          btnCodeEmt.text(b);
          return item.reflectCssStyle();
        });
      });
      btnShadowColor.each(function() {
        var btnCodeEmt, className, colorValue, self;
        self = $(this);
        className = self[0].classList[0];
        btnCodeEmt = cssCode.find("." + className).first();
        colorValue = btnCodeEmt.text();
        return ColorPickerUtil.initColorPicker(self, colorValue, function(a, b, d) {
          btnCodeEmt = cssCode.find("." + className);
          btnCodeEmt.text(d.r + "," + d.g + "," + d.b);
          return item.reflectCssStyle();
        });
      });
      btnGradientStep.off('keyup mouseup');
      return btnGradientStep.on('keyup mouseup', function(e) {
        var className, i, j, mh, mozCache, mozFlag, stepValue, webkitCache, webkitFlag, wh;
        SidebarUI.changeGradientShow(e.currentTarget, cssCode, cssStyle, this.designConfigRoot);
        stepValue = parseInt($(e.currentTarget).val());
        for (i = j = 2; j <= 4; i = ++j) {
          className = 'design-bg-color' + i;
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
        return item.reflectCssStyle();
      }).each(function() {
        var className, i, j, mh, mozCache, mozFlag, stepValue, webkitCache, webkitFlag, wh;
        SidebarUI.changeGradientShow(this, cssCode, cssStyle, this.designConfigRoot);
        stepValue = parseInt($(this).val());
        for (i = j = 2; j <= 4; i = ++j) {
          className = 'design-bg-color' + i;
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
        return item.reflectCssStyle();
      });
    }
  };

  return CssItemBase;

})(ItemBase);

//# sourceMappingURL=css_item_base.js.map
