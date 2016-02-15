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

  WorktableCommon.checkLoadWorktableFromCache = function() {
    var generals;
    if (LocalStorage.isOverWorktableSaveTimeLimit()) {
      return false;
    }
    if ((window.changeUser != null) && window.changeUser) {
      return false;
    }
    generals = LocalStorage.loadGeneralValue();
    if (generals[Constant.Project.Key.PROJECT_ID] == null) {
      return false;
    }
    return true;
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
      instance.itemSize.x = parseInt(window.scrollContents.scrollLeft() + (window.scrollContents.width() - instance.itemSize.w) * 0.5);
      instance.itemSize.y = parseInt(window.scrollContents.scrollTop() + (window.scrollContents.height() - instance.itemSize.h) * 0.5);
      if (instance.drawAndMakeConfigs != null) {
        instance.drawAndMakeConfigs();
      }
      instance.setItemAllPropToPageValue();
      return LocalStorage.saveAllPageValues();
    }
  };

  WorktableCommon.floatItem = function(objId) {
    var a, b, drawedItems, i, item, itemObjId, j, len, m, maxZIndex, sorted, targetZIndex, w;
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
    for (m = 0, len = sorted.length; m < len; m++) {
      item = sorted[m];
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
    var a, b, drawedItems, i, item, itemObjId, j, len, m, minZIndex, sorted, targetZIndex, w;
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
    for (m = 0, len = sorted.length; m < len; m++) {
      item = sorted[m];
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

  WorktableCommon.editItem = function(objId) {
    var item;
    item = window.instanceMap[objId];
    if ((item != null) && (item.launchEdit != null)) {
      return item.launchEdit();
    } else {
      return Sidebar.openItemEditConfig($("#" + objId));
    }
  };

  WorktableCommon.changeMode = function(afterMode, pn) {
    var item, items, len, m, results;
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    if (afterMode === Constant.Mode.NOT_SELECT) {
      $(window.drawingCanvas).css('pointer-events', '');
      window.scrollInsideWrapper.removeClass('edit_mode');
    } else if (afterMode === Constant.Mode.DRAW) {
      $(window.drawingCanvas).css('pointer-events', '');
      window.scrollContents.find('.item.draggable').removeClass('edit_mode');
      window.scrollInsideWrapper.removeClass('edit_mode');
    } else if (afterMode === Constant.Mode.EDIT) {
      $(window.drawingCanvas).css('pointer-events', 'none');
      window.scrollContents.find('.item.draggable').addClass('edit_mode');
      window.scrollInsideWrapper.addClass('edit_mode');
      Navbar.setModeEdit();
    } else if (afterMode === Constant.Mode.OPTION) {
      $(window.drawingCanvas).css('pointer-events', '');
      window.scrollContents.find('.item.draggable').removeClass('edit_mode');
      window.scrollInsideWrapper.removeClass('edit_mode');
    }
    this.setModeClassToMainDiv(afterMode);
    if (window.mode !== afterMode) {
      window.beforeMode = window.mode;
      window.mode = afterMode;
      items = Common.itemInstancesInPage();
      results = [];
      for (m = 0, len = items.length; m < len; m++) {
        item = items[m];
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
    } else if (afterMode === Constant.EventInputPointingMode.DRAW || afterMode === Constant.EventInputPointingMode.ITEM_TOUCH) {
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

  WorktableCommon.refreshAllItemsFromInstancePageValueIfChanging = function(pn, callback) {
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    if (callback == null) {
      callback = null;
    }
    return this.stopAllEventPreview(function(noRunningPreview) {
      var callbackCount, item, items, len, m;
      if (window.worktableItemsChangedState || !noRunningPreview) {
        items = Common.instancesInPage(pn);
        callbackCount = 0;
        for (m = 0, len = items.length; m < len; m++) {
          item = items[m];
          item.refreshFromInstancePageValue(true, function() {
            callbackCount += 1;
            if (callbackCount >= items.length) {
              window.worktableItemsChangedState = false;
              if (callback != null) {
                return callback();
              }
            }
          });
        }
        WorktableCommon.initScrollContentsPosition();
        ScreenEvent.PrivateClass.resetNowScale;
        return PageValue.removeAllFootprint();
      } else {
        if (callback != null) {
          return callback();
        }
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

  WorktableCommon.focusToTargetWhenSidebarOpen = function(target, selectedBorderType, immediate) {
    if (selectedBorderType == null) {
      selectedBorderType = "edit";
    }
    if (immediate == null) {
      immediate = false;
    }
    this.setSelectedBorder(target, selectedBorderType);
    return Common.focusToTarget(target, null, immediate);
  };

  WorktableCommon.initKeyEvent = function() {
    return $(window).off('keydown').on('keydown', function(e) {
      var isMac, step, target, updatedScale;
      target = $(e.target);
      if (target.prop('tagName') === 'INPUT' || target.prop('tagName') === 'TEXTAREA') {
        return;
      }
      isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
      if ((isMac && e.metaKey) || (!isMac && e.ctrlKey)) {
        if (window.debug) {
          console.log(e);
        }
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
          return OperationHistory.add();
        } else if (e.shiftKey && (e.keyCode === Constant.KeyboardKeyCode.PLUS || e.keyCode === Constant.KeyboardKeyCode.SEMICOLON)) {
          e.preventDefault();
          step = 0.1;
          updatedScale = WorktableCommon.getWorktableViewScale() + step;
          WorktableCommon.setWorktableViewScale(updatedScale, true);
          if (Sidebar.isOpenedConfigSidebar()) {
            return WorktableSetting.PositionAndScale.initConfig();
          }
        } else if (e.keyCode === Constant.KeyboardKeyCode.MINUS || e.keyCode === Constant.KeyboardKeyCode.F_MINUS) {
          e.preventDefault();
          step = 0.1;
          updatedScale = WorktableCommon.getWorktableViewScale() - step;
          WorktableCommon.setWorktableViewScale(updatedScale, true);
          if (Sidebar.isOpenedConfigSidebar()) {
            return WorktableSetting.PositionAndScale.initConfig();
          }
        }
      }
    });
  };

  WorktableCommon.updateMainViewSize = function() {
    var borderWidth, timelineTopPadding;
    borderWidth = 5;
    timelineTopPadding = 5;
    $('#main').height($('#contents').height() - $('#timeline').height() - timelineTopPadding - (borderWidth * 2));
    $('#sidebar').height($('#contents').height() - (borderWidth * 2));
    return window.scrollContentsSize = {
      width: window.scrollContents.width(),
      height: window.scrollContents.height()
    };
  };

  WorktableCommon.initScrollContentsPosition = function() {
    var position;
    position = PageValue.getWorktableScrollContentsPosition();
    if (position != null) {
      return Common.updateScrollContentsPosition(position.top, position.left);
    } else {
      return Common.resetScrollContentsPositionToCenter();
    }
  };

  WorktableCommon.resizeMainContainerEvent = function() {
    this.updateMainViewSize();
    Common.updateCanvasSize();
    Common.updateScrollContentsFromScreenEventVar();
    return Sidebar.resizeConfigHeight();
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
      window.instanceMap[targetId].getJQueryElement().remove();
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
    window.scrollContents.off('scroll').on('scroll', function(e) {
      var centerPosition, left, top;
      if ((window.skipScrollEvent != null) && window.skipScrollEvent) {
        window.skipScrollEvent = false;
        return;
      }
      if ((window.skipScrollEventByAnimation != null) && window.skipScrollEventByAnimation) {
        return;
      }
      e.preventDefault();
      e.stopPropagation();
      top = window.scrollContents.scrollTop() + window.scrollContents.height() * 0.5;
      left = window.scrollContents.scrollLeft() + window.scrollContents.width() * 0.5;
      centerPosition = WorktableCommon.calcScrollCenterPosition(top, left);
      if (centerPosition != null) {
        FloatView.show(FloatView.scrollMessage(centerPosition.top.toFixed(1), centerPosition.left.toFixed(1)), FloatView.Type.DISPLAY_POSITION);
      }
      return Common.saveDisplayPosition(top, left, false, function() {
        FloatView.hide();
        if (Sidebar.isOpenedConfigSidebar()) {
          return WorktableSetting.PositionAndScale.initConfig();
        }
      });
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
    Sidebar.resizeConfigHeight();
    WorktableSetting.initConfig();
    return WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT);
  };

  WorktableCommon.calcScrollCenterPosition = function(top, left) {
    var l, screenSize, t;
    screenSize = Common.getScreenSize();
    t = top - (window.scrollInsideWrapper.height() + screenSize.height) * 0.5;
    l = left - (window.scrollInsideWrapper.width() + screenSize.width) * 0.5;
    return {
      top: t,
      left: l
    };
  };

  WorktableCommon.calcScrollTopLeftPosition = function(top, left) {
    var l, screenSize, t;
    screenSize = Common.getScreenSize();
    t = top + (window.scrollInsideWrapper.height() + screenSize.height) * 0.5;
    l = left + (window.scrollInsideWrapper.width() + screenSize.width) * 0.5;
    return {
      top: t,
      left: l
    };
  };

  WorktableCommon.calcItemCenterPositionInWorktable = function(itemSize) {
    var cp, diff, itemCenterPosition, p;
    p = PageValue.getWorktableScrollContentsPosition();
    cp = this.calcScrollCenterPosition(p.top, p.left);
    itemCenterPosition = {
      x: itemSize.x + itemSize.w * 0.5,
      y: itemSize.y + itemSize.h * 0.5
    };
    diff = {
      x: p.left - itemCenterPosition.x,
      y: p.top - itemCenterPosition.y
    };
    return {
      top: cp.top - diff.y,
      left: cp.left - diff.x
    };
  };

  WorktableCommon.calcItemScrollContentsPosition = function(centerPosition, itemWidth, itemHeight) {
    var cp, diff, itemCenterPosition, p;
    p = PageValue.getWorktableScrollContentsPosition();
    cp = this.calcScrollCenterPosition(p.top, p.left);
    diff = {
      x: cp.left - centerPosition.x,
      y: cp.top - centerPosition.y
    };
    itemCenterPosition = {
      x: p.left - diff.x,
      y: p.top - diff.y
    };
    return {
      left: itemCenterPosition.x - itemWidth * 0.5,
      top: itemCenterPosition.y - itemHeight * 0.5
    };
  };

  WorktableCommon.adjustScrollContentsPosition = function() {
    var p;
    Common.applyViewScale();
    p = PageValue.getWorktableScrollContentsPosition();
    if (window.debug) {
      console.log('adjustScrollContentsPosition');
      console.log(p);
    }
    return Common.updateScrollContentsPosition(p.top, p.left);
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
        $('#main').css('height', '');
        LocalStorage.clearWorktableWithoutSetting();
        PageValue.setPageNum(1);
        OperationHistory.add(true);
        PageValue.updatePageCount();
        PageValue.updateForkCount();
        $('#project_wrapper').hide();
        return $('#timeline').hide();
      };
    })(this));
  };

  WorktableCommon.getWorktableViewScale = function() {
    var scale;
    scale = PageValue.getGeneralPageValue(PageValue.Key.worktableScale());
    if (scale == null) {
      scale = 1.0;
      this.setWorktableViewScale(scale);
    }
    return parseFloat(scale);
  };

  WorktableCommon.setWorktableViewScale = function(scale, withViewStateUpdate) {
    if (withViewStateUpdate == null) {
      withViewStateUpdate = false;
    }
    PageValue.setGeneralPageValue(PageValue.Key.worktableScale(), scale);
    if (withViewStateUpdate) {
      FloatView.show('View scale : ' + parseInt(scale * 100) + '%', FloatView.Type.SCALE, 1.0);
      this.adjustScrollContentsPosition();
      return LocalStorage.saveGeneralPageValue();
    }
  };

  WorktableCommon.setupContextMenu = function(element, contextSelector, menu) {
    return Common.setupContextMenu(element, contextSelector, {
      menu: menu,
      select: function(event, ui) {
        var len, m, results, value;
        results = [];
        for (m = 0, len = menu.length; m < len; m++) {
          value = menu[m];
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
    Common.removeAllItem();
    EventConfig.removeAllConfig();
    PageValue.removeAllGeneralAndInstanceAndEventPageValue();
    Timeline.refreshAllTimeline();
    if (callback != null) {
      return callback();
    }
  };

  WorktableCommon.removeAllItemAndEventOnThisPage = function(callback) {
    if (callback == null) {
      callback = null;
    }
    Sidebar.closeSidebar();
    LocalStorage.clearWorktableWithoutGeneralAndSetting();
    Common.removeAllItem(PageValue.getPageNum());
    EventConfig.removeAllConfig();
    PageValue.removeAllInstanceAndEventPageValueOnPage();
    Timeline.refreshAllTimeline();
    if (callback != null) {
      return callback();
    }
  };

  WorktableCommon.createCommonEventInstancesIfNeeded = function(pn) {
    var cls, clsToken, instance, ref, results;
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    ref = window.classMap;
    results = [];
    for (clsToken in ref) {
      cls = ref[clsToken];
      if (cls.prototype instanceof CommonEvent) {
        instance = new (Common.getClassFromMap(cls.CLASS_DIST_TOKEN))();
        if (window.instanceMap[instance.id] == null) {
          Common.setInstanceFromMap(instance.id, instance.constructor.CLASS_DIST_TOKEN);
          results.push(instance.setItemAllPropToPageValue());
        } else {
          results.push(void 0);
        }
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  WorktableCommon.createAllInstanceAndDrawFromInstancePageValue = function(callback, pageNum) {
    if (callback == null) {
      callback = null;
    }
    if (pageNum == null) {
      pageNum = PageValue.getPageNum();
    }
    return Common.loadJsFromInstancePageValue(function() {
      var item, items, len, m;
      items = Common.itemInstancesInPage(pageNum, true, true);
      for (m = 0, len = items.length; m < len; m++) {
        item = items[m];
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
    var _trace;
    if (finishFn == null) {
      finishFn = PageValue.getForkNum();
    }
    finishTeNum = parseInt(finishTeNum);
    finishFn = parseInt(finishFn);
    _trace = function(forkNum) {
      var changeForkNum, idx, len, m, result, ret, routes, te, tes;
      routes = [];
      tes = PageValue.getEventPageValueSortedListByNum(forkNum);
      if (tes.length === 0) {
        return {
          result: true,
          routes: []
        };
      }
      for (idx = m = 0, len = tes.length; m < len; idx = ++m) {
        te = tes[idx];
        changeForkNum = te[EventPageValueBase.PageValueKey.CHANGE_FORKNUM];
        if ((changeForkNum != null) && changeForkNum !== forkNum) {
          ret = _trace.call(this, changeForkNum);
          result = ret.result;
          if (result) {
            routes.push(te);
            $.merge(routes, ret.routes);
            return {
              result: true,
              routes: routes
            };
          }
        } else {
          routes.push(te);
          if (idx + 1 === finishTeNum && forkNum === finishFn) {
            return {
              result: true,
              routes: routes
            };
          }
        }
      }
      if (tes.length + 1 === finishTeNum && forkNum === finishFn) {
        return {
          result: true,
          routes: routes
        };
      } else {
        return {
          result: false,
          routes: []
        };
      }
    };
    return _trace.call(this, PageValue.Key.EF_MASTER_FORKNUM);
  };

  WorktableCommon.isConnectedEventProgressRoute = function(finishTeNum, finishFn) {
    var ret;
    if (finishFn == null) {
      finishFn = PageValue.getForkNum();
    }
    ret = this.eventProgressRoute(finishTeNum, finishFn);
    return ret.result;
  };

  WorktableCommon.updatePrevEventsToAfter = function(teNum, keepDispMag, fromBlankEventConfig, callback) {
    if (keepDispMag == null) {
      keepDispMag = false;
    }
    if (fromBlankEventConfig == null) {
      fromBlankEventConfig = false;
    }
    if (callback == null) {
      callback = null;
    }
    return _updatePrevEventsToAfterAndRunPreview.call(this, teNum, keepDispMag, fromBlankEventConfig, false, callback);
  };

  WorktableCommon.runPreview = function(teNum, keepDispMag, callback) {
    if (keepDispMag == null) {
      keepDispMag = false;
    }
    if (callback == null) {
      callback = null;
    }
    return _updatePrevEventsToAfterAndRunPreview.call(this, teNum, keepDispMag, false, true, callback);
  };

  _updatePrevEventsToAfterAndRunPreview = function(teNum, keepDispMag, fromBlankEventConfig, doRunPreview, callback) {
    var epr, tes;
    if (callback == null) {
      callback = null;
    }
    if (doRunPreview && (window.previewRunning != null) && window.previewRunning) {
      return;
    }
    epr = this.eventProgressRoute(teNum);
    if (!epr.result) {
      return;
    }
    tes = epr.routes;
    window.worktableItemsChangedState = true;
    return this.updateAllEventsToBefore(keepDispMag, (function(_this) {
      return function() {
        var focusTargetItem, idx, item, len, m, te;
        PageValue.removeAllFootprint();
        teNum = parseInt(teNum);
        focusTargetItem = null;
        for (idx = m = 0, len = tes.length; m < len; idx = ++m) {
          te = tes[idx];
          item = window.instanceMap[te.id];
          if (item != null) {
            item.initEvent(te, keepDispMag);
            if (item instanceof ItemBase && te[EventPageValueBase.PageValueKey.DO_FOCUS]) {
              Common.focusToTarget(item.getJQueryElement(), null, true);
            }
            if (idx < tes.length - 1 || fromBlankEventConfig) {
              item.willChapter();
              item.updateEventAfter();
              item.didChapter();
            } else if (doRunPreview) {
              window.previewRunning = true;
              item.preview(function() {
                window.previewRunning = false;
                EventConfig.switchPreviewButton(true);
                _this.refreshAllItemsFromInstancePageValueIfChanging();
                return FloatView.hide();
              });
              window.worktableItemsChangedState = true;
              EventConfig.switchPreviewButton(false);
              $(window.drawingCanvas).one('click.runPreview', function(e) {
                return _this.refreshAllItemsFromInstancePageValueIfChanging();
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

  WorktableCommon.updateAllEventsToBefore = function(keepDispMag, callback) {
    var _updateEventBefore, forkNum, i, m, ref, self, tesArray;
    if (callback == null) {
      callback = null;
    }
    self = this;
    tesArray = [];
    tesArray.push(PageValue.getEventPageValueSortedListByNum(PageValue.Key.EF_MASTER_FORKNUM));
    forkNum = PageValue.getForkNum();
    if (forkNum > 0) {
      for (i = m = 1, ref = forkNum; 1 <= ref ? m <= ref : m >= ref; i = 1 <= ref ? ++m : --m) {
        tesArray.push(PageValue.getEventPageValueSortedListByNum(i));
      }
    }
    _updateEventBefore = function() {
      var idx, item, len, n, o, ref1, results, te, tes;
      results = [];
      for (n = 0, len = tesArray.length; n < len; n++) {
        tes = tesArray[n];
        for (idx = o = ref1 = tes.length - 1; o >= 0; idx = o += -1) {
          te = tes[idx];
          item = window.instanceMap[te.id];
          if (item != null) {
            item.initEvent(te, keepDispMag);
            item.updateEventBefore();
          }
        }
        if (callback != null) {
          results.push(callback());
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    return this.stopAllEventPreview((function(_this) {
      return function() {
        return _updateEventBefore.call(_this);
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
                EventConfig.switchPreviewButton(true);
                if (callback != null) {
                  callback(noRunningPreview);
                }
              }
            });
          } else {
            count += 1;
            if (length <= count) {
              window.previewRunning = false;
              EventConfig.switchPreviewButton(true);
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
      window.stashedEventPageValueForPreview = {
        pageNum: PageValue.getPageNum(),
        forkNum: PageValue.getForkNum(),
        teNum: teNum,
        value: PageValue.getEventPageValue(PageValue.Key.eventNumber(teNum))
      };
      if (callback != null) {
        return callback();
      }
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
