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
    if (this.constructor.defaultMethodName() != null) {
      EPVItem.writeDefaultToPageValue(this);
      return Timeline.refreshAllTimeline();
    }
  },
  drawAndMakeConfigs: function(show) {
    if (show == null) {
      show = true;
    }
    this.reDraw(show);
    return this.makeDesignConfig();
  },
  showOptionMenu: function() {
    var sc;
    sc = $('.sidebar-config');
    sc.hide();
    $("." + SidebarUI.DESIGN_ROOT_CLASSNAME, sc).hide();
    $('#design-config').show();
    return $('#' + this.getDesignConfigId()).show();
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
          return Sidebar.openItemEditConfig(event.target);
        }
      });
      menu.push({
        title: I18n.t('context_menu.copy'),
        cmd: "copy",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          WorktableCommon.copyItem();
          return WorktableCommon.setMainContainerContext();
        }
      });
      menu.push({
        title: I18n.t('context_menu.cut'),
        cmd: "cut",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          WorktableCommon.cutItem();
          return WorktableCommon.setMainContainerContext();
        }
      });
      menu.push({
        title: I18n.t('context_menu.float'),
        cmd: "float",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          var objId;
          objId = $(event.target).attr('id');
          WorktableCommon.floatItem(objId);
          LocalStorage.saveAllPageValues();
          return OperationHistory.add();
        }
      });
      menu.push({
        title: I18n.t('context_menu.rear'),
        cmd: "rear",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          var objId;
          objId = $(event.target).attr('id');
          WorktableCommon.rearItem(objId);
          LocalStorage.saveAllPageValues();
          return OperationHistory.add();
        }
      });
      menu.push({
        title: I18n.t('context_menu.delete'),
        cmd: "delete",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          if (window.confirm(I18n.t('message.dialog.delete_item'))) {
            return WorktableCommon.removeItem(event.target);
          }
        }
      });
      return WorktableCommon.setupContextMenu(self.getJQueryElement(), contextSelector, menu);
    })();
    (function() {
      return self.getJQueryElement().mousedown(function(e) {
        if (e.which === 1) {
          e.stopPropagation();
          WorktableCommon.clearSelectedBorder();
          return WorktableCommon.setSelectedBorder(this, "edit");
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
