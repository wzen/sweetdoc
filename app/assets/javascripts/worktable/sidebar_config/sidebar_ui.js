// Generated by CoffeeScript 1.9.2
var Sidebar, SidebarUI;

Sidebar = (function() {
  function Sidebar() {}

  Sidebar.Type = (function() {
    function Type() {}

    Type.STATE = 'state';

    Type.CSS = 'css';

    Type.CANVAS = 'canvas';

    Type.TIMELINE = 'timeline';

    Type.SETTING = 'setting';

    return Type;

  })();

  Sidebar.openConfigSidebar = function(target, selectedBorderType) {
    var main;
    if (target == null) {
      target = null;
    }
    if (selectedBorderType == null) {
      selectedBorderType = "edit";
    }
    if (!Sidebar.isOpenedConfigSidebar()) {
      WorktableCommon.changeMode(Constant.Mode.OPTION);
      main = $('#main');
      if (!Sidebar.isOpenedConfigSidebar()) {
        main.removeClass('col-xs-12');
        main.addClass('col-xs-9');
        $('#sidebar').fadeIn('500', function() {
          return WorktableCommon.resizeMainContainerEvent();
        });
        if (target !== null) {
          return WorktableCommon.focusToTargetWhenSidebarOpen(target, selectedBorderType);
        }
      }
    }
  };

  Sidebar.closeSidebar = function(callback) {
    var main;
    if (callback == null) {
      callback = null;
    }
    WorktableCommon.clearSelectedBorder();
    if (!Sidebar.isClosedConfigSidebar()) {
      main = $('#main');
      return $('#sidebar').fadeOut('500', function() {
        main.removeClass('col-xs-9');
        main.addClass('col-xs-12');
        WorktableCommon.resizeMainContainerEvent();
        if (callback != null) {
          callback();
        }
        return $('.sidebar-config').hide();
      });
    }
  };

  Sidebar.isOpenedConfigSidebar = function() {
    return $('#main').hasClass('col-xs-9');
  };

  Sidebar.isClosedConfigSidebar = function() {
    return $('#main').hasClass('col-xs-12');
  };

  Sidebar.switchSidebarConfig = function(configType, item) {
    var animation, sc;
    if (item == null) {
      item = null;
    }
    animation = false;
    $('.sidebar-config').hide();
    if (configType === this.Type.STATE) {
      sc = $("#" + StateConfig.ROOT_ID_NAME);
      if (animation) {
        return sc.show('fast');
      } else {
        return sc.show();
      }
    } else if (configType === this.Type.CSS && (item != null) && (item.cssConfig != null)) {
      if (animation) {
        return item.cssConfig.show('fast');
      } else {
        return item.cssConfig.show();
      }
    } else if (configType === this.Type.CANVAS && (item != null) && (item.canvasConfig != null)) {
      if (animation) {
        return item.canvasConfig.show('fast');
      } else {
        return item.canvasConfig.show();
      }
    } else if (configType === this.Type.TIMELINE) {
      if (animation) {
        return $('#event-config').show('fast');
      } else {
        return $('#event-config').show();
      }
    } else if (configType === this.Type.SETTING) {
      sc = $("#" + Setting.ROOT_ID_NAME);
      if (animation) {
        return sc.show('fast');
      } else {
        return sc.show();
      }
    }
  };

  Sidebar.openItemEditConfig = function(target) {
    var _initOptionMenu, emt, obj;
    emt = $(target);
    obj = instanceMap[emt.attr('id')];
    _initOptionMenu = function() {
      if ((obj != null) && (obj.setupOptionMenu != null)) {
        obj.setupOptionMenu();
      }
      if ((obj != null) && (obj.showOptionMenu != null)) {
        return obj.showOptionMenu();
      }
    };
    if (obj instanceof CssItemBase) {
      this.switchSidebarConfig(this.Type.CSS);
    } else if (obj instanceof CanvasItemBase) {
      this.switchSidebarConfig(this.Type.CANVAS);
    }
    ColorPickerUtil.initColorPickerValue();
    _initOptionMenu();
    return this.openConfigSidebar(target);
  };

  return Sidebar;

})();

SidebarUI = (function() {
  var _reflectStyle, constant;

  function SidebarUI() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    SidebarUI.DESIGN_ROOT_CLASSNAME = constant.DesignConfig.ROOT_CLASSNAME;
  }

  SidebarUI.settingSlider = function(className, min, max, cssCode, cssStyle, designConfigRoot, stepValue) {
    var d, defaultValue, meterElement, self, valueElement;
    if (stepValue == null) {
      stepValue = 0;
    }
    self = this;
    meterElement = $('.' + className, designConfigRoot);
    valueElement = $('.' + className + '-value', designConfigRoot);
    d = $('.' + className + '-value', cssCode)[0];
    defaultValue = $(d).html();
    valueElement.val(defaultValue);
    valueElement.html(defaultValue);
    try {
      meterElement.slider('destroy');
    } catch (_error) {

    }
    return meterElement.slider({
      min: min,
      max: max,
      step: stepValue,
      value: defaultValue,
      slide: function(event, ui) {
        valueElement.val(ui.value);
        valueElement.html(ui.value);
        return _reflectStyle.call(self, event.target);
      }
    });
  };

  SidebarUI.settingGradientSliderByElement = function(element, values, cssCode, cssStyle) {
    var handleElement, id, self;
    self = this;
    id = element.attr("id");
    try {
      element.slider('destroy');
    } catch (_error) {

    }
    element.slider({
      min: 1,
      max: 99,
      values: values,
      slide: function(event, ui) {
        var index, position;
        index = $(ui.handle).index();
        position = $('.btn-bg-color' + (index + 2) + '-position', cssCode);
        position.html(("0" + ui.value).slice(-2));
        return _reflectStyle.call(self, event.target);
      }
    });
    handleElement = element.children('.ui-slider-handle');
    if (values === null) {
      return handleElement.hide();
    } else {
      return handleElement.show();
    }
  };

  SidebarUI.settingGradientSlider = function(className, values, cssCode, cssStyle, designConfigRoot) {
    var meterElement;
    meterElement = $('.' + className, designConfigRoot);
    return this.settingGradientSliderByElement(meterElement, values, cssCode, cssStyle);
  };

  SidebarUI.settingGradientDegSlider = function(className, min, max, cssCode, cssStyle, designConfigRoot) {
    var d, defaultValue, meterElement, self, valueElement, webkitDeg, webkitValueElement;
    self = this;
    meterElement = $('.' + className, designConfigRoot);
    valueElement = $('.' + className + '-value', cssCode);
    webkitValueElement = $('.' + className + '-value-webkit', cssCode);
    d = $('.' + className + '-value', cssCode)[0];
    defaultValue = $(d).html();
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
    valueElement.val(defaultValue);
    valueElement.html(defaultValue);
    webkitValueElement.html(webkitDeg[defaultValue]);
    try {
      meterElement.slider('destroy');
    } catch (_error) {

    }
    return meterElement.slider({
      min: min,
      max: max,
      step: 45,
      value: defaultValue,
      slide: function(event, ui) {
        valueElement.val(ui.value);
        valueElement.html(ui.value);
        webkitValueElement.html(webkitDeg[ui.value]);
        return _reflectStyle.call(self, event.target);
      }
    });
  };

  SidebarUI.changeGradientShow = function(targetElement, cssCode, cssStyle, cssConfig) {
    var meterElement, value, values;
    value = parseInt(targetElement.value);
    if (value >= 2 && value <= 5) {
      meterElement = $(targetElement).siblings('.ui-slider:first');
      values = null;
      if (value === 3) {
        values = [50];
      } else if (value === 4) {
        values = [30, 70];
      } else if (value === 5) {
        values = [25, 50, 75];
      }
      SidebarUI.settingGradientSliderByElement(meterElement, values, cssCode, cssStyle);
      return this.switchGradientColorSelectorVisible(value, cssConfig);
    }
  };

  SidebarUI.switchGradientColorSelectorVisible = function(gradientStepValue, cssConfig) {
    var element, i, j, results;
    results = [];
    for (i = j = 2; j <= 4; i = ++j) {
      element = $('.btn-bg-color' + i, cssConfig);
      if (i > gradientStepValue - 1) {
        results.push(element.hide());
      } else {
        results.push(element.show());
      }
    }
    return results;
  };

  _reflectStyle = function(eventTarget) {
    var item, objId, prefix;
    prefix = ItemBase.DESIGN_CONFIG_ROOT_ID.replace('@id', '');
    objId = $(eventTarget).closest("." + CssItemBase.DESIGN_ROOT_CLASSNAME).attr('id').replace(prefix, '');
    item = window.instanceMap[objId];
    if ((item != null) && item instanceof CssItemBase) {
      return item.reflectCssStyle();
    }
  };

  return SidebarUI;

})();

//# sourceMappingURL=sidebar_ui.js.map
