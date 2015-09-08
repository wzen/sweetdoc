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
      return window.selectedObjId = target.id;
    }
  };

  WorktableCommon.clearSelectedBorder = function() {
    $('.editSelected, .timelineSelected').remove();
    return window.selectedObjId = null;
  };

  WorktableCommon.copyItem = function(objId) {
    var instance;
    if (objId == null) {
      objId = window.selectedObjId;
    }
    if (objId != null) {
      instance = PageValue.getInstancePageValue(PageValue.Key.instanceValue(objId));
      if ((instance != null) && instance instanceof ItemBase) {
        window.copiedInstance = Common.makeClone(instance);
        return window.copiedInstance.id = null;
      }
    }
  };

  WorktableCommon.cutItem = function(objId) {
    if (objId == null) {
      objId = window.selectedObjId;
    }
    this.copyItem(objId);
    return this.removeItem($("#" + window.selectedObjId));
  };

  WorktableCommon.pasteItem = function() {
    var instance;
    if ((window.copiedInstance != null) && window.copiedInstance instanceof ItemBase) {
      instance = Common.makeClone(window.copiedInstance);
      instance.id = Common.generateId();
      instance.itemSize.x = parseInt(window.scrollContents.scrollLeft() + (window.scrollContents.width() - instance.itemSize.w) / 2.0);
      instance.itemSize.y = parseInt(window.scrollContents.scrollTop() + (window.scrollContents.height() - instance.itemSize.h) / 2.0);
      if (instance instanceof CssItemBase && (instance.makeCss != null)) {
        instance.makeCss();
      }
      if (instance.drawAndMakeConfigs != null) {
        instance.drawAndMakeConfigs();
      }
      instance.setItemAllPropToPageValue();
      return LocalStorage.saveValueForWorktable();
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

  WorktableCommon.getInitFuncName = function(itemId) {
    var itemName;
    itemName = Constant.ITEM_PATH_LIST[itemId];
    return itemName + "Init";
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
    ref = Common.getCreatedItemObject();
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
    LocalStorage.saveInstancePageValue();
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
        }
      }
    });
  };

  WorktableCommon.updateMainViewSize = function() {
    var borderWidth, padding, timelineTopPadding;
    borderWidth = 5;
    timelineTopPadding = 5;
    padding = borderWidth * 2 + timelineTopPadding;
    $('#main').height($('#contents').height() - $("#" + Constant.ElementAttribute.NAVBAR_ROOT).height() - $('#timeline').height() - padding);
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
    PageValue.adjustInstanceAndEventOnThisPage();
    Timeline.refreshAllTimeline();
    LocalStorage.saveValueForWorktable();
    return OperationHistory.add();
  };

  WorktableCommon.removeAllItemOnWorkTable = function() {
    var k, ref, results, v;
    ref = Common.getCreatedItemObject();
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
    var menu, page;
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
    menu = [
      {
        title: "Default",
        cmd: "default",
        uiIcon: "ui-icon-scissors"
      }
    ];
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
    WorktableCommon.setupContextMenu($('#main'), "#pages ." + page + " .main-wrapper:first", menu);
    $('#main').on("mousedown", (function(_this) {
      return function() {
        return _this.clearAllItemStyle();
      };
    })(this));
    return Setting.initConfig();
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
    return Common.clearAllEventChange((function(_this) {
      return function() {
        Common.removeAllItem();
        EventConfig.removeAllConfig();
        PageValue.removeAllItemAndEventPageValue();
        return Timeline.refreshAllTimeline();
      };
    })(this));
  };

  WorktableCommon.removeAllItemAndEventOnThisPage = function() {
    Sidebar.closeSidebar();
    LocalStorage.clearWorktableWithoutGeneralAndSetting();
    return Common.clearAllEventChange((function(_this) {
      return function() {
        Common.removeAllItem();
        EventConfig.removeAllConfig();
        PageValue.removeAllItemAndEventPageValueOnThisPage();
        return Timeline.refreshAllTimeline();
      };
    })(this));
  };

  WorktableCommon.drawAllItemFromInstancePageValue = function(callback, pageNum) {
    var k, needItemIds, obj, pageValues;
    if (callback == null) {
      callback = null;
    }
    if (pageNum == null) {
      pageNum = PageValue.getPageNum();
    }
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum));
    needItemIds = [];
    for (k in pageValues) {
      obj = pageValues[k];
      if (obj.value.itemId != null) {
        if ($.inArray(obj.value.itemId, needItemIds) < 0) {
          needItemIds.push(obj.value.itemId);
        }
      }
    }
    return this.loadItemJs(needItemIds, function() {
      var classMapId, event, id, isCommon;
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
    });
  };

  WorktableCommon.loadItemJs = function(itemIds, callback) {
    var callbackCount, itemId, itemInitFuncName, l, len, needReadItemIds;
    if (callback == null) {
      callback = null;
    }
    if (jQuery.type(itemIds) !== "array") {
      itemIds = [itemIds];
    }
    if (itemIds.length === 0) {
      if (callback != null) {
        callback();
      }
      return;
    }
    callbackCount = 0;
    needReadItemIds = [];
    for (l = 0, len = itemIds.length; l < len; l++) {
      itemId = itemIds[l];
      if (itemId != null) {
        itemInitFuncName = WorktableCommon.getInitFuncName(itemId);
        if (window.itemInitFuncList[itemInitFuncName] != null) {
          window.itemInitFuncList[itemInitFuncName]();
          callbackCount += 1;
          if (callbackCount >= itemIds.length) {
            if (callback != null) {
              callback();
            }
            return;
          }
        } else {
          needReadItemIds.push(itemId);
        }
      } else {
        callbackCount += 1;
      }
    }
    return $.ajax({
      url: "/item_js/index",
      type: "POST",
      dataType: "json",
      data: {
        itemIds: needReadItemIds
      },
      success: function(data) {
        var d, len1, m, option, results;
        callbackCount = 0;
        results = [];
        for (m = 0, len1 = data.length; m < len1; m++) {
          d = data[m];
          if (d.css_info != null) {
            option = {
              isWorkTable: true,
              css_temp: d.css_info
            };
          }
          WorktableCommon.availJs(WorktableCommon.getInitFuncName(d.item_id), d.js_src, option, function() {
            callbackCount += 1;
            if ((callback != null) && callbackCount >= data.length) {
              return callback();
            }
          });
          PageValue.addItemInfo(d.item_id, d.te_actions);
          results.push(EventConfig.addEventConfigContents(d.item_id, d.te_actions, d.te_values));
        }
        return results;
      },
      error: function(data) {}
    });
  };

  WorktableCommon.availJs = function(initName, jsSrc, option, callback) {
    var firstScript, s, t;
    if (option == null) {
      option = {};
    }
    if (callback == null) {
      callback = null;
    }
    s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = jsSrc;
    firstScript = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(s, firstScript);
    return t = setInterval(function() {
      if (window.itemInitFuncList[initName] != null) {
        clearInterval(t);
        window.itemInitFuncList[initName](option);
        if (callback != null) {
          return callback();
        }
      }
    }, '500');
  };

  return WorktableCommon;

})();

//# sourceMappingURL=worktable_common.js.map
