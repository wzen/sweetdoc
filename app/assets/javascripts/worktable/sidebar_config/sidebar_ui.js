// Generated by CoffeeScript 1.9.2
var Sidebar, SidebarUI;

Sidebar = (function() {
  function Sidebar() {}

  Sidebar.openConfigSidebar = function(target, selectedBorderType) {
    var main;
    if (target == null) {
      target = null;
    }
    if (selectedBorderType == null) {
      selectedBorderType = "edit";
    }
    if (!Sidebar.isOpenedConfigSidebar()) {
      main = $('#main');
      if (!Sidebar.isOpenedConfigSidebar()) {
        main.removeClass('col-md-12');
        main.addClass('col-md-9');
        $('#sidebar').fadeIn('500');
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
        var s;
        s = PageValue.getInstancePageValue(PageValue.Key.CONFIG_OPENED_SCROLL);
        if (s != null) {
          scrollContents.css({
            scrollTop: s.top,
            scrollLeft: s.left
          });
          PageValue.removePageValue(PageValue.Key.CONFIG_OPENED_SCROLL);
        }
        main.removeClass('col-md-9');
        main.addClass('col-md-12');
        if (callback != null) {
          callback();
        }
        return $('.sidebar-config').css('display', 'none');
      });
    }
  };

  Sidebar.isOpenedConfigSidebar = function() {
    return $('#main').hasClass('col-md-9');
  };

  Sidebar.isClosedConfigSidebar = function() {
    return $('#main').hasClass('col-md-12');
  };

  Sidebar.switchSidebarConfig = function(configType, item) {
    var animation, sc;
    if (item == null) {
      item = null;
    }
    animation = this.isOpenedConfigSidebar();
    $('.sidebar-config').css('display', 'none');
    if (configType === "css" && (item != null) && (item.cssConfig != null)) {
      if (animation) {
        return item.cssConfig.show();
      } else {
        return item.cssConfig.css('display', '');
      }
    } else if (configType === "canvas" && (item != null) && (item.canvasConfig != null)) {
      if (animation) {
        return item.canvasConfig.show();
      } else {
        return item.canvasConfig.css('display', '');
      }
    } else if (configType === "timeline") {
      if (animation) {
        return $('#event-config').show();
      } else {
        return $('#event-config').css('display', '');
      }
    } else if (configType === 'setting') {
      sc = $("#" + Setting.ROOT_ID_NAME);
      if (animation) {
        return sc.show();
      } else {
        return sc.css('display', '');
      }
    }
  };

  return Sidebar;

})();

SidebarUI = (function() {
  function SidebarUI() {}

  SidebarUI.settingSlider = function(className, min, max, cssCode, cssStyle, root, stepValue) {
    var d, defaultValue, meterElement, valueElement;
    if (stepValue == null) {
      stepValue = 0;
    }
    meterElement = $('.' + className, root);
    valueElement = $('.' + className + '-value', root);
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
        return cssStyle.text(cssCode.text());
      }
    });
  };

  SidebarUI.settingGradientSliderByElement = function(element, values, cssCode, cssStyle) {
    var handleElement, id;
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
        return cssStyle.text(cssCode.text());
      }
    });
    handleElement = element.children('.ui-slider-handle');
    if (values === null) {
      return handleElement.css('display', 'none');
    } else {
      return handleElement.css('display', '');
    }
  };

  SidebarUI.settingGradientSlider = function(className, values, cssCode, cssStyle, root) {
    var meterElement;
    meterElement = $('.' + className, root);
    return this.settingGradientSliderByElement(meterElement, values, cssCode, cssStyle);
  };

  SidebarUI.settingGradientDegSlider = function(className, min, max, cssCode, cssStyle, root) {
    var d, defaultValue, meterElement, valueElement, webkitDeg, webkitValueElement;
    meterElement = $('.' + className, root);
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
        return cssStyle.text(cssCode.text());
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
        results.push(element.css('display', 'none'));
      } else {
        results.push(element.css('display', ''));
      }
    }
    return results;
  };

  return SidebarUI;

})();

//# sourceMappingURL=sidebar_ui.js.map