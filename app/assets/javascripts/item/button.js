// Generated by CoffeeScript 1.9.2
var ButtonItem,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ButtonItem = (function(superClass) {
  extend(ButtonItem, superClass);

  function ButtonItem() {
    this.defaultClick = bind(this.defaultClick, this);
    return ButtonItem.__super__.constructor.apply(this, arguments);
  }

  ButtonItem.IDENTITY = "Button";

  ButtonItem.CSSTEMPID = "button_css_temp";

  if (window.loadedItemId != null) {
    ButtonItem.ITEM_ID = window.loadedItemId;
  }

  ButtonItem.actionProperties = {
    defaultMethod: 'defaultClick',
    designConfig: 'design_tool',
    methods: {
      defaultClick: {
        actionType: 'click',
        options: {
          id: 'defaultClick',
          name: 'Default click action',
          desc: "Click push action",
          ja: {
            name: '通常クリック',
            desc: 'デフォルトのボタンクリック'
          }
        }
      },
      changeColorScroll: {
        actionType: 'scroll',
        scrollEnabledDirection: {
          top: true,
          bottom: true,
          left: false,
          right: false
        },
        scrollForwardDirection: {
          top: false,
          bottom: true,
          left: false,
          right: false
        },
        options: {
          id: 'changeColorScroll_Design',
          name: 'Changing color by click'
        }
      }
    }
  };

  ButtonItem.prototype.updateEventBefore = function() {
    var methodName;
    this.getJQueryElement().css('opacity', 0);
    methodName = this.getEventMethodName();
    if (methodName === 'defaultClick') {
      return this.getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration');
    }
  };

  ButtonItem.prototype.updateEventAfter = function() {
    var methodName;
    this.getJQueryElement().css('opacity', 1);
    methodName = this.getEventMethodName();
    if (methodName === 'defaultClick') {
      return this.getJQueryElement().css({
        '-webkit-animation-duration': '0',
        '-moz-animation-duration': '-moz-animation-duration',
        '0': '0'
      });
    }
  };

  ButtonItem.prototype.defaultClick = function(e, complete) {
    this.getJQueryElement().addClass('defaultClick_' + this.id);
    this.getJQueryElement().off('webkitAnimationEnd animationend');
    return this.getJQueryElement().on('webkitAnimationEnd animationend', (function(_this) {
      return function(e) {
        _this.getJQueryElement().removeClass('defaultClick_' + _this.id);
        _this.isFinishedEvent = true;
        if (complete != null) {
          return complete();
        }
      };
    })(this));
  };

  ButtonItem.prototype.cssAnimationElement = function() {
    var css, emt, funcName, height, keyFrameName, keyframe, left, methodName, mozKeyframe, top, webkitKeyframe, width;
    methodName = this.getEventMethodName();
    funcName = methodName + "_" + this.id;
    keyFrameName = this.id + "_frame";
    emt = this.getJQueryElement();
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

  ButtonItem.prototype.willChapter = function() {
    ButtonItem.__super__.willChapter.call(this);
    if (this.getEventMethodName() === 'defaultClick') {
      return this.getJQueryElement().css('opacity', 1);
    }
  };

  ButtonItem.prototype.setupOptionMenu = function() {
    var btnBgColor, btnGradientStep, btnShadowColor, cssCache, cssCode, cssRoot, cssStyle, item, name;
    item = this;
    cssRoot = this.cssRoot;
    cssCache = this.cssCache;
    cssCode = this.cssCode;
    cssStyle = this.cssStyle;
    this.designConfigRoot = $('#' + this.getDesignConfigId());
    if ((this.designConfigRoot == null) || this.designConfigRoot.length === 0) {
      this.makeDesignConfig();
      this.designConfigRoot = $('#' + this.getDesignConfigId());
    }
    btnGradientStep = $(".design-gradient-step", this.designConfigRoot);
    btnBgColor = $(".design-bg-color1,.design-bg-color2,.design-bg-color3,.design-bg-color4,.design-bg-color5,.design-border-color,.design-font-color", this.designConfigRoot);
    btnShadowColor = $(".design-shadow-color,.design-shadowinset-color,.design-text-shadow1-color,.design-text-shadow2-color", this.designConfigRoot);
    name = $('.item-name', this.designConfigRoot);
    name.val(this.name);
    name.off('change').on('change', (function(_this) {
      return function() {
        _this.name = name.val();
        return _this.setItemPropToPageValue('name', _this.name);
      };
    })(this));
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
  };

  return ButtonItem;

})(CssItemBase);

Common.setClassToMap(false, ButtonItem.ITEM_ID, ButtonItem);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[ButtonItem.ITEM_ID] == null)) {
  window.itemInitFuncList[ButtonItem.ITEM_ID] = function(option) {
    if (option == null) {
      option = {};
    }
    if (window.isWorkTable && (ButtonItem.jsLoaded != null)) {
      ButtonItem.jsLoaded(option);
    }
    if (window.debug) {
      return console.log('button loaded');
    }
  };
}

//# sourceMappingURL=button.js.map
