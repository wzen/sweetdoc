// Generated by CoffeeScript 1.9.2
var WorktableCommon;

WorktableCommon = (function() {
  var _updatePrevEventsToAfterAndRunPreview;

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

  WorktableCommon.copyItem = function(objId, isCopyOperation) {
    var instance, pageValue;
    if (objId == null) {
      objId = window.selectedObjId;
    }
    if (isCopyOperation == null) {
      isCopyOperation = true;
    }
    if (objId != null) {
      pageValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(objId));
      if (pageValue != null) {
        instance = window.instanceMap[objId];
        if (instance instanceof ItemBase) {
          window.copiedInstance = Common.makeClone(instance.getMinimumObject());
          if (isCopyOperation) {
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
    return this.removeSingleItem($("#" + objId));
  };

  WorktableCommon.pasteItem = function() {
    var instance, obj;
    if (window.copiedInstance != null) {
      instance = new (Common.getClassFromMap(window.copiedInstance.classDistToken))();
      window.instanceMap[instance.id] = instance;
      obj = Common.makeClone(window.copiedInstance);
      obj.id = instance.id;
      instance.setMiniumObject(obj);
      if ((obj.isCopy != null) && obj.isCopy) {
        instance.name = instance.name + ' (Copy)';
      }
      instance.itemSize.x = parseInt(window.scrollContents.scrollLeft() + (window.scrollContents.width() - instance.itemSize.w) / 2.0);
      instance.itemSize.y = parseInt(window.scrollContents.scrollTop() + (window.scrollContents.height() - instance.itemSize.h) / 2.0);
      if (instance.drawAndMakeConfigs != null) {
        instance.drawAndMakeConfigs();
      }
      instance.setItemAllPropToPageValue();
      return LocalStorage.saveAllPageValues();
    }
  };

  WorktableCommon.floatItem = function(objId) {
    var a, b, drawedItems, i, item, itemObjId, j, l, len, maxZIndex, sorted, targetZIndex, w;
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
    i = parseInt(window.scrollInsideWrapper.css('z-index'));
    for (l = 0, len = sorted.length; l < len; l++) {
      item = sorted[l];
      itemObjId = $(item).attr('id');
      if (objId !== itemObjId) {
        item.css('z-index', i);
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemObjId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i));
        i += 1;
      }
    }
    maxZIndex = i;
    $("#" + objId).css('z-index', maxZIndex);
    return PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(maxZIndex));
  };

  WorktableCommon.rearItem = function(objId) {
    var a, b, drawedItems, i, item, itemObjId, j, l, len, minZIndex, sorted, targetZIndex, w;
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
    i = parseInt(window.scrollInsideWrapper.css('z-index')) + 1;
    for (l = 0, len = sorted.length; l < len; l++) {
      item = sorted[l];
      itemObjId = $(item).attr('id');
      if (objId !== itemObjId) {
        item.css('z-index', i);
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemObjId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i));
        i += 1;
      }
    }
    minZIndex = parseInt(window.scrollInsideWrapper.css('z-index'));
    $("#" + objId).css('z-index', minZIndex);
    return PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(minZIndex));
  };

  WorktableCommon.changeMode = function(afterMode, pn) {
    var item, items, l, len, results;
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    if (afterMode === Constant.Mode.NOT_SELECT) {
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT, pn));
      window.scrollInsideWrapper.removeClass('edit_mode');
    } else if (afterMode === Constant.Mode.DRAW) {
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT, pn));
      window.scrollContents.find('.item.draggable').removeClass('edit_mode');
      window.scrollInsideWrapper.removeClass('edit_mode');
    } else if (afterMode === Constant.Mode.EDIT) {
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM, pn));
      window.scrollContents.find('.item.draggable').addClass('edit_mode');
      window.scrollInsideWrapper.addClass('edit_mode');
      Navbar.setModeEdit();
    } else if (afterMode === Constant.Mode.OPTION) {
      $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT, pn));
      window.scrollContents.find('.item.draggable').removeClass('edit_mode');
      window.scrollInsideWrapper.removeClass('edit_mode');
    }
    this.setModeClassToMainDiv(afterMode);
    if (window.mode !== afterMode) {
      window.beforeMode = window.mode;
      window.mode = afterMode;
      items = Common.itemInstancesInPage();
      results = [];
      for (l = 0, len = items.length; l < len; l++) {
        item = items[l];
        if (item.changeMode != null) {
          results.push(item.changeMode(afterMode));
        } else {
          results.push(void 0);
        }
      }
      return results;
    }
  };

  WorktableCommon.changeEventPointingMode = function(afterMode) {
    if (afterMode === Constant.EventInputPointingMode.NOT_SELECT) {
      Timeline.disabledOperation(false);
      Sidebar.disabledOperation(false);
      Navbar.disabledOperation(false);
    } else if (afterMode === Constant.EventInputPointingMode.DRAW) {
      Timeline.disabledOperation(true);
      Sidebar.disabledOperation(true);
      Navbar.disabledOperation(true);
    } else if (afterMode === Constant.EventInputPointingMode.ITEM_TOUCH) {
      Timeline.disabledOperation(true);
      Sidebar.disabledOperation(true);
      Navbar.disabledOperation(true);
    }
    this.setModeClassToMainDiv(afterMode);
    return window.eventPointingMode = afterMode;
  };

  WorktableCommon.setModeClassToMainDiv = function(mode) {
    var classes;
    classes = ['draw_mode', 'draw_pointing', 'click_pointing'];
    $('#main').removeClass(classes.join(' '));
    if (mode === Constant.Mode.DRAW) {
      return $('#main').addClass('draw_mode');
    } else if (mode === Constant.EventInputPointingMode.DRAW) {
      return $('#main').addClass('draw_pointing');
    } else if (mode === Constant.EventInputPointingMode.ITEM_TOUCH) {
      return $('#main').addClass('click_pointing');
    }
  };

  WorktableCommon.putbackMode = function() {
    if (window.beforeMode != null) {
      this.changeMode(window.beforeMode);
      return window.beforeMode = null;
    }
  };

  WorktableCommon.reDrawAllItemsFromInstancePageValueIfChanging = function(pn, callback) {
    var callbackCount;
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    if (callback == null) {
      callback = null;
    }
    callbackCount = 0;
    return this.stopAllEventPreview(function(noRunningPreview) {
      var item, items, l, len, results;
      if (window.worktableItemsChangedState || !noRunningPreview) {
        items = Common.itemInstancesInPage(pn);
        results = [];
        for (l = 0, len = items.length; l < len; l++) {
          item = items[l];
          results.push(item.reDrawFromInstancePageValue(true, function() {
            callbackCount += 1;
            if (callbackCount >= items.length) {
              window.worktableItemsChangedState = false;
              if (callback != null) {
                return callback();
              }
            }
          }));
        }
        return results;
      }
    });
  };

  WorktableCommon.clearAllItemStyle = function() {
    var k, ref, v;
    ref = Common.allItemInstances();
    for (k in ref) {
      v = ref[k];
      v.clearAllEventStyle();
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
    $(window).off('keydown');
    return $(window).on('keydown', function(e) {
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
          e.preventDefault();
          WorktableCommon.copyItem();
          return WorktableCommon.setMainContainerContext();
        } else if (e.keyCode === Constant.KeyboardKeyCode.X) {
          e.preventDefault();
          WorktableCommon.cutItem();
          return WorktableCommon.setMainContainerContext();
        } else if (e.keyCode === Constant.KeyboardKeyCode.V) {
          e.preventDefault();
          WorktableCommon.pasteItem();
          LocalStorage.saveAllPageValues();
          return OperationHistory.add();
        }
      }
    });
  };

  WorktableCommon.updateMainViewSize = function() {
    var borderWidth, timelineTopPadding;
    borderWidth = 5;
    timelineTopPadding = 5;
    $('#main').height($('#contents').height() - $("#" + Navbar.NAVBAR_ROOT).height() - $('#timeline').height() - timelineTopPadding - (borderWidth * 2));
    window.scrollContentsSize = {
      width: window.scrollContents.width(),
      height: window.scrollContents.height()
    };
    return $('#sidebar').height($('#contents').height() - $("#" + Navbar.NAVBAR_ROOT).height() - (borderWidth * 2));
  };

  WorktableCommon.resizeMainContainerEvent = function() {
    this.updateMainViewSize();
    Common.updateCanvasSize();
    return Common.updateScrollContentsFromPagevalue();
  };

  WorktableCommon.resizeEvent = function() {
    return WorktableCommon.resizeMainContainerEvent();
  };

  WorktableCommon.removeSingleItem = function(itemElement) {
    var targetId;
    targetId = $(itemElement).attr('id');
    PageValue.removeInstancePageValue(targetId);
    PageValue.removeEventPageValueSync(targetId);
    if (window.instanceMap[targetId] != null) {
      window.instanceMap[targetId].removeItemElement();
    }
    PageValue.adjustInstanceAndEventOnPage();
    Timeline.refreshAllTimeline();
    LocalStorage.saveAllPageValues();
    return OperationHistory.add();
  };


  /* デバッグ */

  WorktableCommon.runDebug = function() {};

  WorktableCommon.initMainContainer = function() {
    CommonVar.worktableCommonVar();
    Common.updateCanvasSize();
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT));
    window.scrollInsideWrapper.width(window.scrollViewSize);
    window.scrollInsideWrapper.height(window.scrollViewSize);
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1));
    window.scrollContents.off('scroll');
    window.scrollContents.on('scroll', function(e) {
      var left, top;
      e.preventDefault();
      top = window.scrollContents.scrollTop();
      left = window.scrollContents.scrollLeft();
      FloatView.show(FloatView.scrollMessage(top, left), FloatView.Type.DISPLAY_POSITION);
      if (window.scrollContentsScrollTimer != null) {
        clearTimeout(window.scrollContentsScrollTimer);
      }
      return window.scrollContentsScrollTimer = setTimeout(function() {
        PageValue.setDisplayPosition(top, left);
        FloatView.hide();
        return window.scrollContentsScrollTimer = null;
      }, 500);
    });
    $('.dropdown-toggle').dropdown();
    Navbar.initWorktableNavbar();
    this.initKeyEvent();
    Handwrite.initHandwrite();
    this.setMainContainerContext();
    $('#project_contents').off("mousedown");
    $('#project_contents').on("mousedown", (function(_this) {
      return function() {
        return _this.clearAllItemStyle();
      };
    })(this));
    Common.applyEnvironmentFromPagevalue();
    this.updateMainViewSize();
    return WorktableSetting.initConfig();
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

  WorktableCommon.resetWorktable = function() {
    return this.removeAllItemAndEvent((function(_this) {
      return function() {
        $('#pages .section').remove();
        Common.resetEnvironment();
        CommonVar.initVarWhenLoadedView();
        CommonVar.initCommonVar();
        Common.createdMainContainerIfNeeded(PageValue.getPageNum());
        WorktableCommon.initMainContainer();
        LocalStorage.clearWorktableWithoutSetting();
        Timeline.refreshAllTimeline();
        PageValue.setPageNum(1);
        OperationHistory.add(true);
        PageValue.updatePageCount();
        PageValue.updateForkCount();
        return Paging.initPaging();
      };
    })(this));
  };

  WorktableCommon.setupContextMenu = function(element, contextSelector, menu) {
    return Common.setupContextMenu(element, contextSelector, {
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

  WorktableCommon.removeAllItemAndEvent = function(callback) {
    if (callback == null) {
      callback = null;
    }
    Sidebar.closeSidebar();
    LocalStorage.clearWorktableWithoutSetting();
    return Common.updateAllEventsToBefore((function(_this) {
      return function() {
        Common.removeAllItem();
        EventConfig.removeAllConfig();
        PageValue.removeAllGeneralAndInstanceAndEventPageValue();
        Timeline.refreshAllTimeline();
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  WorktableCommon.removeAllItemAndEventOnThisPage = function(callback) {
    if (callback == null) {
      callback = null;
    }
    Sidebar.closeSidebar();
    LocalStorage.clearWorktableWithoutGeneralAndSetting();
    return Common.updateAllEventsToBefore((function(_this) {
      return function() {
        Common.removeAllItem(PageValue.getPageNum());
        EventConfig.removeAllConfig();
        PageValue.removeAllInstanceAndEventPageValueOnPage();
        Timeline.refreshAllTimeline();
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  WorktableCommon.createAllInstanceAndDrawFromInstancePageValue = function(callback, pageNum) {
    if (callback == null) {
      callback = null;
    }
    if (pageNum == null) {
      pageNum = PageValue.getPageNum();
    }
    return Common.loadJsFromInstancePageValue(function() {
      var item, items, l, len;
      items = Common.itemInstancesInPage(pageNum, true, true);
      for (l = 0, len = items.length; l < len; l++) {
        item = items[l];
        if (item.drawAndMakeConfigs != null) {
          item.drawAndMakeConfigs();
        }
      }
      if (callback != null) {
        return callback();
      }
    }, pageNum);
  };

  WorktableCommon.eventProgressRoute = function(finishTeNum, finishFn) {
    var _trace, result, routes;
    if (finishFn == null) {
      finishFn = PageValue.getForkNum();
    }
    finishTeNum = parseInt(finishTeNum);
    finishFn = parseInt(finishFn);
    routes = [];
    result = false;
    _trace = function(forkNum) {
      var changeForkNum, idx, l, len, results, te, tes;
      tes = PageValue.getEventPageValueSortedListByNum(forkNum);
      results = [];
      for (idx = l = 0, len = tes.length; l < len; idx = ++l) {
        te = tes[idx];
        routes.push(te);
        if (idx + 1 === finishTeNum && forkNum === finishFn) {
          result = true;
          break;
        }
        changeForkNum = te[EventPageValueBase.PageValueKey.CHANGE_FORKNUM];
        if (changeForkNum != null) {
          _trace.call(changeForkNum);
          break;
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    _trace.call(PageValue.Key.EF_MASTER_FORKNUM);
    if (result) {
      return routes;
    } else {
      return [];
    }
  };

  WorktableCommon.isConnectedEventProgressRoute = function(finishTeNum, finishFn) {
    if (finishFn == null) {
      finishFn = PageValue.getForkNum();
    }
    return this.eventProgressRoute(finishTeNum, finishFn).length > 0;
  };

  WorktableCommon.updatePrevEventsToAfter = function(teNum, callback) {
    if (callback == null) {
      callback = null;
    }
    return _updatePrevEventsToAfterAndRunPreview.call(this, teNum, false, false, callback);
  };

  WorktableCommon.runPreview = function(teNum, keepDispMag, callback) {
    if (keepDispMag == null) {
      keepDispMag = false;
    }
    if (callback == null) {
      callback = null;
    }
    return _updatePrevEventsToAfterAndRunPreview.call(this, teNum, keepDispMag, true, callback);
  };

  _updatePrevEventsToAfterAndRunPreview = function(teNum, keepDispMag, doRunPreview, callback) {
    var tes;
    if (callback == null) {
      callback = null;
    }
    if (doRunPreview && (window.previewRunning != null) && window.previewRunning) {
      return;
    }
    tes = this.eventProgressRoute(teNum);
    if (tes.length === 0) {
      return;
    }
    window.worktableItemsChangedState = true;
    return Common.updateAllEventsToBefore((function(_this) {
      return function() {
        var idx, item, l, len, te;
        PageValue.removeAllFootprint();
        teNum = parseInt(teNum);
        for (idx = l = 0, len = tes.length; l < len; idx = ++l) {
          te = tes[idx];
          item = window.instanceMap[te.id];
          if (item != null) {
            item.initEvent(te);
            if (idx < tes.length - 1) {
              PageValue.saveInstanceObjectToFootprint(item.id, true, item._event[EventPageValueBase.PageValueKey.DIST_ID]);
              item.updateEventAfter();
            } else if (doRunPreview) {
              window.previewRunning = true;
              item.preview(te, keepDispMag, function() {
                window.previewRunning = false;
                return _this.reverseStashEventPageValueForPreviewIfNeeded(function() {
                  return _this.reDrawAllItemsFromInstancePageValueIfChanging();
                });
              });
              window.worktableItemsChangedState = true;
              window.drawingCanvas.one('click.runPreview', function(e) {
                return _this.stopAllEventPreview(function() {
                  return _this.reDrawAllItemsFromInstancePageValueIfChanging();
                });
              });
            }
          }
        }
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  WorktableCommon.stopAllEventPreview = function(callback) {
    if (callback == null) {
      callback = null;
    }
    if ((window.previewRunning == null) || !window.previewRunning) {
      if (callback != null) {
        callback();
      }
      return;
    }
    return this.reverseStashEventPageValueForPreviewIfNeeded((function(_this) {
      return function() {
        var count, k, length, noRunningPreview, ref, v;
        count = 0;
        length = Object.keys(window.instanceMap).length;
        noRunningPreview = true;
        ref = window.instanceMap;
        for (k in ref) {
          v = ref[k];
          if (v.stopPreview != null) {
            v.stopPreview(function(wasRunningPreview) {
              count += 1;
              if (wasRunningPreview) {
                noRunningPreview = false;
              }
              if (length <= count) {
                window.previewRunning = false;
                if (callback != null) {
                  callback(noRunningPreview);
                }
              }
            });
          } else {
            count += 1;
            if (length <= count) {
              window.previewRunning = false;
              if (callback != null) {
                callback(noRunningPreview);
              }
              return;
            }
          }
        }
      };
    })(this));
  };

  WorktableCommon.stashEventPageValueForPreview = function(teNum, callback) {
    var _callback;
    if (callback == null) {
      callback = null;
    }
    _callback = function() {
      return window.stashedEventPageValueForPreview = {
        pageNum: PageValue.getPageNum(),
        forkNum: PageValue.getForkNum(),
        teNum: teNum,
        value: PageValue.getEventPageValue(PageValue.Key.eventNumber(teNum))
      };
    };
    if (window.stashedEventPageValueForPreview != null) {
      return this.reverseStashEventPageValueForPreviewIfNeeded((function(_this) {
        return function() {
          return _callback.call(_this);
        };
      })(this));
    } else {
      return _callback.call(this);
    }
  };

  WorktableCommon.reverseStashEventPageValueForPreviewIfNeeded = function(callback) {
    var forkNum, pageNum, teNum, value;
    if (callback == null) {
      callback = null;
    }
    if (window.stashedEventPageValueForPreview == null) {
      if (callback != null) {
        callback();
      }
      return;
    }
    pageNum = window.stashedEventPageValueForPreview.pageNum;
    forkNum = window.stashedEventPageValueForPreview.forkNum;
    teNum = window.stashedEventPageValueForPreview.teNum;
    value = window.stashedEventPageValueForPreview.value;
    PageValue.setEventPageValue(PageValue.Key.eventNumber(teNum, forkNum, pageNum), value);
    window.stashedEventPageValueForPreview = null;
    if (callback != null) {
      return callback();
    }
  };

  return WorktableCommon;

})();

//# sourceMappingURL=worktable_common.js.map
