// Generated by CoffeeScript 1.9.2
var Sidebar;

Sidebar = (function() {
  var constant;

  function Sidebar() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    Sidebar.SIDEBAR_TAB_ROOT = constant.ElementAttribute.SIDEBAR_TAB_ROOT;
  }

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
    if (window.isWorkTable) {
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
    }
  };

  Sidebar.closeSidebar = function(callback) {
    var main;
    if (callback == null) {
      callback = null;
    }
    if (window.isWorkTable) {
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
    animation = this.isOpenedConfigSidebar();
    $('.sidebar-config').hide();
    if (configType === this.Type.STATE || configType === this.Type.SETTING) {
      sc = $("#" + this.SIDEBAR_TAB_ROOT);
      if (animation) {
        return sc.fadeIn('fast');
      } else {
        return sc.show();
      }
    } else if (configType === this.Type.CSS && (item != null) && (item.cssConfig != null)) {
      if (animation) {
        return item.cssConfig.fadeIn('fast');
      } else {
        return item.cssConfig.show();
      }
    } else if (configType === this.Type.CANVAS && (item != null) && (item.canvasConfig != null)) {
      if (animation) {
        return item.canvasConfig.fadeIn('fast');
      } else {
        return item.canvasConfig.show();
      }
    } else if (configType === this.Type.TIMELINE) {
      if (animation) {
        return $('#event-config').fadeIn('fast');
      } else {
        return $('#event-config').show();
      }
    }
  };

  Sidebar.openItemEditConfig = function(target) {
    var emt, obj;
    emt = $(target);
    obj = instanceMap[emt.attr('id')];
    if (obj instanceof CssItemBase) {
      this.switchSidebarConfig(this.Type.CSS);
    } else if (obj instanceof CanvasItemBase) {
      this.switchSidebarConfig(this.Type.CANVAS);
    }
    this.initItemEditConfig(obj);
    if ((obj != null) && (obj.showOptionMenu != null)) {
      obj.showOptionMenu();
    }
    return this.openConfigSidebar(target);
  };

  Sidebar.initItemEditConfig = function(obj) {
    ColorPickerUtil.initColorPickerValue();
    if ((obj != null) && (obj.setupOptionMenu != null)) {
      return obj.setupOptionMenu();
    }
  };

  return Sidebar;

})();

//# sourceMappingURL=sidebar_ui.js.map
