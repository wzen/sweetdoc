// Generated by CoffeeScript 1.9.2
var WorkTableCommonExtend;

WorkTableCommonExtend = {
  startDraw: function() {},
  draw: function(cood) {},
  drawAndMakeConfigsAndWritePageValue: function(show) {
    if (show == null) {
      show = true;
    }
    this.reDraw(show);
    this.makeDesignConfig();
    EPVItem.writeDefaultToPageValue(this);
    Timeline.refreshAllTimeline();
    return true;
  },
  drawAndMakeConfigs: function(show) {
    if (show == null) {
      show = true;
    }
    this.reDraw(show);
    this.makeDesignConfig();
    return true;
  },
  showOptionMenu: function() {
    var sc;
    sc = $('.sidebar-config');
    sc.css('display', 'none');
    $('.dc', sc).css('display', 'none');
    $('#design-config').css('display', '');
    return $('#' + this.getDesignConfigId()).css('display', '');
  },
  setupDragAndResizeEvents: function() {
    var self;
    self = this;
    (function() {
      var contextSelector, menu;
      menu = [];
      contextSelector = null;
      if ((typeof ArrowItem !== "undefined" && ArrowItem !== null) && self instanceof ArrowItem) {
        contextSelector = ".arrow";
      } else if ((typeof ButtonItem !== "undefined" && ButtonItem !== null) && self instanceof ButtonItem) {
        contextSelector = ".css3button";
      }
      menu.push({
        title: "Edit",
        cmd: "edit",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          var initOptionMenu, target;
          initOptionMenu = function(event) {
            var emt, obj;
            emt = $(event.target);
            obj = instanceMap[emt.attr('id')];
            if ((obj != null) && (obj.setupOptionMenu != null)) {
              obj.setupOptionMenu();
            }
            if ((obj != null) && (obj.showOptionMenu != null)) {
              return obj.showOptionMenu();
            }
          };
          target = event.target;
          initColorPickerValue();
          initOptionMenu(event);
          Sidebar.openConfigSidebar(target);
          return changeMode(Constant.Mode.OPTION);
        }
      });
      menu.push({
        title: "Delete",
        cmd: "delete",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          var target, targetId;
          target = event.target;
          targetId = $(target).attr('id');
          PageValue.removeInstancePageValue(targetId);
          target.remove();
          PageValue.adjustInstanceAndEvent();
          Timeline.refreshAllTimeline();
          LocalStorage.saveEventPageValue();
          return OperationHistory.add();
        }
      });
      return WorktableCommon.setupContextMenu(self.getJQueryElement(), contextSelector, menu);
    })();
    (function() {
      return self.getJQueryElement().mousedown(function(e) {
        if (e.which === 1) {
          e.stopPropagation();
          clearSelectedBorder();
          return setSelectedBorder(this, "edit");
        }
      });
    })();
    return (function() {
      self.getJQueryElement().draggable({
        containment: scrollInside,
        drag: function(event, ui) {
          if (self.drag != null) {
            return self.drag();
          }
        },
        stop: function(event, ui) {
          if (self.dragComplete != null) {
            return self.dragComplete();
          }
        }
      });
      return self.getJQueryElement().resizable({
        containment: scrollInside,
        resize: function(event, ui) {
          if (self.resize != null) {
            return self.resize();
          }
        },
        stop: function(event, ui) {
          if (self.resizeComplete != null) {
            return self.resizeComplete();
          }
        }
      });
    })();
  }
};

//# sourceMappingURL=common_extend.js.map
