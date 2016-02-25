// Generated by CoffeeScript 1.9.2
var Sidebar;

Sidebar = (function() {
  var constant;

  function Sidebar() {}

  constant = gon["const"];

  Sidebar.SIDEBAR_TAB_ROOT = constant.ElementAttribute.SIDEBAR_TAB_ROOT;

  Sidebar.Type = (function() {
    function Type() {}

    Type.STATE = 'state';

    Type.EVENT = 'event';

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
        }
        return $('#screen_wrapper').off('click.sidebar_close').on('click.sidebar_close', (function(_this) {
          return function(e) {
            if (Sidebar.isOpenedConfigSidebar()) {
              if (window.eventPointingMode === Constant.EventInputPointingMode.NOT_SELECT) {
                Sidebar.closeSidebar();
                WorktableCommon.putbackMode();
                return $(window.drawingCanvas).off('click.sidebar_close');
              }
            }
          };
        })(this));
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
        return $('#sidebar').fadeOut('200', function() {
          main.removeClass('col-xs-9');
          main.addClass('col-xs-12');
          WorktableCommon.resizeMainContainerEvent();
          WorktableCommon.changeMode(window.mode);
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
    } else if (configType === this.Type.EVENT) {
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
    return this.initItemEditConfig(obj, (function(_this) {
      return function() {
        if ((obj != null) && (obj.showOptionMenu != null)) {
          obj.showOptionMenu();
        }
        return _this.openConfigSidebar(target);
      };
    })(this));
  };

  Sidebar.openStateConfig = function() {
    var getLeftPosi, reAdjust, root, scrollBarWidths, widthOfHidden, widthOfList;
    root = $('#tab-config');
    scrollBarWidths = 40;
    this.openConfigSidebar();
    widthOfList = function() {
      var itemsWidth;
      itemsWidth = 0;
      $('.nav-tabs li', root).each(function() {
        var itemWidth;
        itemWidth = $(this).outerWidth();
        return itemsWidth += itemWidth;
      });
      return itemsWidth;
    };
    widthOfHidden = function() {
      return (($('.tab-nav-tabs-wrapper', root).outerWidth()) - widthOfList() - getLeftPosi()) - scrollBarWidths;
    };
    getLeftPosi = function() {
      return $('.nav-tabs', root).position().left;
    };
    reAdjust = function() {
      if (($('.tab-nav-tabs-wrapper', root).outerWidth()) < widthOfList()) {
        $('.scroller-right', root).show();
      } else {
        $('.scroller-right', root).hide();
      }
      if (getLeftPosi() < 0) {
        return $('.scroller-left', root).show();
      } else {
        $('.item', root).animate({
          left: "-=" + getLeftPosi() + "px"
        }, 'fast');
        return $('.scroller-left', root).hide();
      }
    };
    reAdjust();
    $('.scroller-right', root).off('click').on('click', function() {
      $('.scroller-left', root).fadeIn('fast');
      $('.scroller-right', root).fadeOut('fast');
      return $('.nav-tabs', root).animate({
        left: "+=" + widthOfHidden() + "px"
      }, 'fast');
    });
    return $('.scroller-left', root).off('click').on('click', function() {
      $('.scroller-right', root).fadeIn('fast');
      $('.scroller-left', root).fadeOut('fast');
      return $('.nav-tabs', root).animate({
        left: "-=" + getLeftPosi() + "px"
      }, 'fast');
    });
  };

  Sidebar.initItemEditConfig = function(obj, callback) {
    if (callback == null) {
      callback = null;
    }
    ColorPickerUtil.initColorPickerValue();
    if ((obj != null) && (obj.setupOptionMenu != null)) {
      return obj.setupOptionMenu(callback);
    }
  };

  Sidebar.initEventConfig = function(distId, teNum) {
    var eId, emt;
    if (teNum == null) {
      teNum = 1;
    }
    eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId);
    emt = $("#" + eId);
    if (emt.length === 0) {
      emt = $('#event-config .event_temp .event').clone(true).attr('id', eId);
      $('#event-config').append(emt);
    }
    return EventConfig.initEventConfig(distId, teNum);
  };

  Sidebar.disabledOperation = function(flg) {
    if (flg) {
      if ($('#sidebar .cover_touch_overlay').length === 0) {
        $('#sidebar').append("<div class='cover_touch_overlay'></div>");
        return $('.cover_touch_overlay').off('click').on('click', function(e) {
          e.preventDefault();
        });
      }
    } else {
      return $('#sidebar .cover_touch_overlay').remove();
    }
  };

  Sidebar.resizeConfigHeight = function() {
    var contentsHeight, padding, tabHeight;
    contentsHeight = $('#contents').height();
    tabHeight = 39;
    padding = 5;
    return $('#myTabContent').height(contentsHeight - tabHeight - padding * 2);
  };

  return Sidebar;

})();

//# sourceMappingURL=sidebar_ui.js.map
