// Generated by CoffeeScript 1.9.2
var WorktableCommon;

WorktableCommon = (function() {
  function WorktableCommon() {}

  WorktableCommon.setSelectedBorder = function(target, selectedBorderType) {
    var className;
    if (selectedBorderType == null) {
      selectedBorderType = "edit";
    }
    className = null;
    if (selectedBorderType === "edit") {
      className = 'editSelected';
    } else if (selectedBorderType === "timeline") {
      className = 'timelineSelected';
    }
    $(target).find("." + className).remove();
    $(target).append("<div class=" + className + " />");
    if (selectedBorderType === "edit") {
      return window.selectedObjId = $(target).attr('id');
    }
  };

  WorktableCommon.clearSelectedBorder = function() {
    $('.editSelected, .timelineSelected').remove();
    return window.selectedObjId = null;
  };

  WorktableCommon.copyItem = function(objId, isCopy) {
    var instance, pageValue;
    if (objId == null) {
      objId = window.selectedObjId;
    }
    if (isCopy == null) {
      isCopy = true;
    }
    if (objId != null) {
      pageValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(objId));
      if (pageValue != null) {
        instance = Common.getInstanceFromMap(false, objId, pageValue.itemId);
        if (instance instanceof ItemBase) {
          window.copiedInstance = Common.makeClone(instance.getMinimumObject());
          if (isCopy) {
            return window.copiedInstance.isCopy = true;
          }
        }
      }
    }
  };

  WorktableCommon.cutItem = function(objId) {
    if (objId == null) {
      objId = window.selectedObjId;
    }
    this.copyItem(objId, false);
    return this.removeItem($("#" + objId));
  };

  WorktableCommon.pasteItem = function() {
    var instance, obj;
    if (window.copiedInstance != null) {
      instance = Common.newInstance(false, window.copiedInstance.itemId);
      obj = Common.makeClone(window.copiedInstance);
      obj.id = instance.id;
      instance.setMiniumObject(obj);
      if ((obj.isCopy != null) && obj.isCopy) {
        instance.name = instance.name + ' (Copy)';
      }
      instance.itemSize.x = parseInt(window.scrollContents.scrollLeft() + (window.scrollContents.width() - instance.itemSize.w) / 2.0);
      instance.itemSize.y = parseInt(window.scrollContents.scrollTop() + (window.scrollContents.height() - instance.itemSize.h) / 2.0);
      if (instance instanceof CssItemBase && (instance.makeCss != null)) {
        instance.css = null;
        instance.makeCss();
      }
      if (instance.drawAndMakeConfigs != null) {
        instance.drawAndMakeConfigs();
      }
      instance.setItemAllPropToPageValue();
      return LocalStorage.saveAllPageValues();
    }
  };

  WorktableCommon.floatItem = function(objId) {
    var a, b, drawedItems, i, item, itemId, j, l, len, maxZIndex, sorted, targetZIndex, w;
    drawedItems = window.scrollInside.find('.item');
    sorted = [];
    drawedItems.each(function() {
      return sorted.push($(this));
    });
    i = 0;
    while (i <= drawedItems.length - 2) {
      j = i + 1;
      while (j <= drawedItems.length - 1) {
        a = parseInt(sorted[i].css('z-index'));
        b = parseInt(sorted[j].css('z-index'));
        if (a > b) {
          w = sorted[i];
          sorted[i] = sorted[j];
          sorted[j] = w;
        }
        j += 1;
      }
      i += 1;
    }
    targetZIndex = parseInt($("#" + objId).css('z-index'));
    i = parseInt(window.scrollInside.css('z-index'));
    for (l = 0, len = sorted.length; l < len; l++) {
      item = sorted[l];
      itemId = $(item).attr('id');
      if (objId !== itemId) {
        item.css('z-index', i);
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i));
        i += 1;
      }
    }
    maxZIndex = i;
    $("#" + objId).css('z-index', maxZIndex);
    return PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(maxZIndex));
  };

  WorktableCommon.rearItem = function(objId) {
    var a, b, drawedItems, i, item, itemId, j, l, len, minZIndex, sorted, targetZIndex, w;
    drawedItems = window.scrollInside.find('.item');
    sorted = [];
    drawedItems.each(function() {
      return sorted.push($(this));
    });
    i = 0;
    while (i <= drawedItems.length - 2) {
      j = i + 1;
      while (j <= drawedItems.length - 1) {
        a = parseInt(sorted[i].css('z-index'));
        b = parseInt(sorted[j].css('z-index'));
        if (a > b) {
          w = sorted[i];
          sorted[i] = sorted[j];
          sorted[j] = w;
        }
        j += 1;
      }
      i += 1;
    }
    targetZIndex = parseInt($("#" + objId).css('z-index'));
    i = parseInt(window.scrollInside.css('z-index')) + 1;
    for (l = 0, len = sorted.length; l < len; l++) {
      item = sorted[l];
      itemId = $(item).attr('id');
      if (objId !== itemId) {
        item.css('z-index', i);
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i));
        i += 1;
      }
    }
    minZIndex = parseInt(window.scrollInside.css('z-index'));
    $("#" + objId).css('z-index', minZIndex);
    return PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(minZIndex));
  };

  WorktableCommon.changeMode = function(mode) {
    if (mode === Constant.Mode.DRAW) {
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT));
      window.scrollContents.find('.item.draggable').removeClass('edit_mode');
      window.scrollInside.removeClass('edit_mode');
    } else if (mode === Constant.Mode.EDIT) {
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM));
      window.scrollContents.find('.item.draggable').addClass('edit_mode');
      window.scrollInside.addClass('edit_mode');
    } else if (mode === Constant.Mode.OPTION) {
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT));
      window.scrollContents.find('.item.draggable').removeClass('edit_mode');
      window.scrollInside.removeClass('edit_mode');
    }
    return window.mode = mode;
  };

  WorktableCommon.clearAllItemStyle = function() {
    var k, ref, v;
    ref = Common.getCreatedItemInstances();
    for (k in ref) {
      v = ref[k];
      if (v instanceof ItemBase) {
        v.clearAllEventStyle();
      }
    }
    this.clearSelectedBorder();
    return $('.colorPicker').ColorPickerHide();
  };

  WorktableCommon.focusToTargetWhenSidebarOpen = function(target, selectedBorderType) {
    if (selectedBorderType == null) {
      selectedBorderType = "edit";
    }
    this.setSelectedBorder(target, selectedBorderType);
    return Common.focusToTarget(target);
  };

  WorktableCommon.initKeyEvent = function() {
    return $(window).keydown(function(e) {
      var isMac;
      isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
      if ((isMac && e.metaKey) || (!isMac && e.ctrlKey)) {
        if (e.keyCode === Constant.KeyboardKeyCode.Z) {
          e.preventDefault();
          if (e.shiftKey) {
            return OperationHistory.redo();
          } else {
            return OperationHistory.undo();
          }
        } else if (e.keyCode === Constant.KeyboardKeyCode.C) {
          WorktableCommon.copyItem();
          return WorktableCommon.setMainContainerContext();
        } else if (e.keyCode === Constant.KeyboardKeyCode.X) {
          WorktableCommon.cutItem();
          return WorktableCommon.setMainContainerContext();
        } else if (e.keyCode === Constant.KeyboardKeyCode.V) {
          WorktableCommon.pasteItem();
          LocalStorage.saveAllPageValues();
          return OperationHistory.add();
        }
      }
    });
  };

  WorktableCommon.updateMainViewSize = function() {
    var borderWidth, padding, timelineTopPadding;
    borderWidth = 5;
    timelineTopPadding = 5;
    padding = borderWidth * 2 + timelineTopPadding;
    $('#main').height($('#contents').height() - $("#" + Navbar.NAVBAR_ROOT).height() - $('#timeline').height() - padding);
    return window.scrollContentsSize = {
      width: window.scrollContents.width(),
      height: window.scrollContents.height()
    };
  };

  WorktableCommon.resizeMainContainerEvent = function() {
    this.updateMainViewSize();
    $(window.drawingCanvas).attr('width', window.mainWrapper.width());
    return $(window.drawingCanvas).attr('height', window.mainWrapper.height());
  };

  WorktableCommon.initResize = function() {
    var resizeTimer;
    resizeTimer = false;
    return $(window).resize(function() {
      if (resizeTimer !== false) {
        clearTimeout(resizeTimer);
      }
      return resizeTimer = setTimeout(function() {
        WorktableCommon.resizeMainContainerEvent();
        return clearTimeout(resizeTimer);
      }, 200);
    });
  };

  WorktableCommon.removeItem = function(itemElement) {
    var targetId;
    targetId = $(itemElement).attr('id');
    PageValue.removeInstancePageValue(targetId);
    PageValue.removeEventPageValueSync(targetId);
    itemElement.remove();
    PageValue.adjustInstanceAndEventOnPage();
    Timeline.refreshAllTimeline();
    LocalStorage.saveAllPageValues();
    return OperationHistory.add();
  };

  WorktableCommon.removeAllItemOnWorkTable = function() {
    var k, ref, results, v;
    ref = Common.getCreatedItemInstances();
    results = [];
    for (k in ref) {
      v = ref[k];
      results.push(v.getJQueryElement().remove());
    }
    return results;
  };


  /* デバッグ */

  WorktableCommon.runDebug = function() {};

  WorktableCommon.initMainContainer = function() {
    CommonVar.worktableCommonVar();
    $(window.drawingCanvas).attr('width', window.mainWrapper.width());
    $(window.drawingCanvas).attr('height', window.mainWrapper.height());
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT));
    window.scrollInside.width(window.scrollViewSize);
    window.scrollInside.height(window.scrollViewSize);
    window.scrollInside.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1));
    scrollContents.scrollLeft(window.scrollInside.width() * 0.5);
    scrollContents.scrollTop(window.scrollInside.height() * 0.5);
    $('.dropdown-toggle').dropdown();
    Navbar.initWorktableNavbar();
    this.initKeyEvent();
    Handwrite.initHandwrite();
    this.setMainContainerContext();
    $('#main').on("mousedown", (function(_this) {
      return function() {
        return _this.clearAllItemStyle();
      };
    })(this));
    return Setting.initConfig();
  };

  WorktableCommon.setMainContainerContext = function() {
    var menu, page;
    menu = [];
    if (window.copiedInstance != null) {
      menu.push({
        title: I18n.t('context_menu.paste'),
        cmd: "paste",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          WorktableCommon.pasteItem();
          LocalStorage.saveAllPageValues();
          return OperationHistory.add();
        }
      });
    }
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
    return WorktableCommon.setupContextMenu($("#pages ." + page + " .scroll_inside:first"), "#pages ." + page + " .main-wrapper:first", menu);
  };

  WorktableCommon.recreateMainContainer = function() {
    this.removeAllItemAndEvent();
    $('#pages .section').remove();
    Common.createdMainContainerIfNeeded(PageValue.getPageNum());
    WorktableCommon.initMainContainer();
    LocalStorage.clearWorktableWithoutSetting();
    Timeline.refreshAllTimeline();
    PageValue.setPageNum(1);
    OperationHistory.add(true);
    PageValue.updatePageCount();
    return Paging.initPaging();
  };

  WorktableCommon.setupContextMenu = function(element, contextSelector, menu) {
    return element.contextmenu({
      preventContextMenuForPopup: true,
      preventSelect: true,
      menu: menu,
      select: function(event, ui) {
        var l, len, results, value;
        results = [];
        for (l = 0, len = menu.length; l < len; l++) {
          value = menu[l];
          if (value.cmd === ui.cmd) {
            results.push(value.func(event, ui));
          } else {
            results.push(void 0);
          }
        }
        return results;
      },
      beforeOpen: function(event, ui) {
        var t;
        t = $(event.target);
        ui.menu.zIndex($(event.target).zIndex() + 1);
        if (window.mode === Constant.Mode.EDIT && $(t).hasClass('item')) {
          return WorktableCommon.setSelectedBorder(t);
        }
      }
    });
  };

  WorktableCommon.removeAllItemAndEvent = function() {
    Sidebar.closeSidebar();
    LocalStorage.clearWorktableWithoutSetting();
    return Common.clearAllEventAction((function(_this) {
      return function() {
        Common.removeAllItem();
        EventConfig.removeAllConfig();
        PageValue.removeAllGeneralAndInstanceAndEventPageValue();
        return Timeline.refreshAllTimeline();
      };
    })(this));
  };

  WorktableCommon.removeAllItemAndEventOnThisPage = function() {
    Sidebar.closeSidebar();
    LocalStorage.clearWorktableWithoutGeneralAndSetting();
    return Common.clearAllEventAction((function(_this) {
      return function() {
        Common.removeAllItem();
        EventConfig.removeAllConfig();
        PageValue.removeAllInstanceAndEventPageValueOnPage();
        return Timeline.refreshAllTimeline();
      };
    })(this));
  };

  WorktableCommon.drawAllItemFromInstancePageValue = function(callback, pageNum) {
    if (callback == null) {
      callback = null;
    }
    if (pageNum == null) {
      pageNum = PageValue.getPageNum();
    }
    return Common.loadJsFromInstancePageValue(function() {
      var classMapId, event, id, isCommon, k, obj, pageValues;
      pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum));
      for (k in pageValues) {
        obj = pageValues[k];
        isCommon = null;
        id = obj.value.id;
        classMapId = null;
        if (obj.value.itemId != null) {
          isCommon = false;
          classMapId = obj.value.itemId;
        } else {
          isCommon = true;
          classMapId = obj.value.eventId;
        }
        event = Common.getInstanceFromMap(isCommon, id, classMapId);
        if (event instanceof ItemBase) {
          event.setMiniumObject(obj.value);
          if (event instanceof CssItemBase && (event.makeCss != null)) {
            event.makeCss();
          }
          if (event.drawAndMakeConfigs != null) {
            event.drawAndMakeConfigs();
          }
        }
        event.setItemAllPropToPageValue();
      }
      Timeline.refreshAllTimeline();
      if (callback != null) {
        return callback();
      }
    }, pageNum);
  };

  WorktableCommon.stopAllEventPreview = function(callback) {
    var count, k, length, ref, results, v;
    if (callback == null) {
      callback = null;
    }
    count = 0;
    length = Object.keys(window.instanceMap).length;
    ref = window.instanceMap;
    results = [];
    for (k in ref) {
      v = ref[k];
      if (v.stopPreview != null) {
        results.push(v.stopPreview(function() {
          count += 1;
          if (length <= count && (callback != null)) {
            return callback();
          }
        }));
      } else {
        count += 1;
        if (length <= count && (callback != null)) {
          results.push(callback());
        } else {
          results.push(void 0);
        }
      }
    }
    return results;
  };

  return WorktableCommon;

})();

//# sourceMappingURL=worktable_common.js.map
