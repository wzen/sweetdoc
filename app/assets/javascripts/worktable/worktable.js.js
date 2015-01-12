// Generated by CoffeeScript 1.8.0
var addStorage, availJs, changeGradientShow, changeMode, clearAllItemStyle, clearSelectedBorder, clearWorkTable, closeSidebar, createColorPicker, drawItemFromStorage, flushWarn, focusToTarget, getInitFuncName, getObjFromObjectListByElementId, getStorageByKey, initColorPickerValue, initCommonVar, initHandwrite, initHeaderMenu, initKeyEvent, isClosedConfigSidebar, isOpenedConfigSidebar, loadFromServer, loadItemJs, openConfigSidebar, popOperationHistory, popOperationHistoryRedo, pushOperationHistory, redo, run, runDebug, saveToServer, setSelectedBorder, settingColorPicker, settingGradientDegSlider, settingGradientSlider, settingGradientSliderByElement, settingSlider, setupContextMenu, setupEvents, setupTimeLineCss, setupTimeLineObjects, setupTimelineEvents, showError, showWarn, switchGradientColorSelectorVisible, switchSidebarConfig, undo;

initCommonVar = function() {
  window.sidebarWrapper = $("#sidebar-wrapper");
  window.scrollContents = $('#scroll_contents');
  window.scrollInside = $('#scroll_inside');
  window.cssCode = $("#cssCode");
  window.messageTimer = null;
  window.flushMessageTimer = null;
  window.mode = Constant.Mode.DRAW;
  window.lstorage = localStorage;
  window.itemObjectList = [];
  window.itemInitFuncList = [];
  window.operationHistory = [];
  window.operationHistoryIndex = 0;
  window.scrollViewMag = 500;
  lstorage.clear();
  window.selectItemMenu = Constant.ItemType.BUTTON;
  return loadItemJs(Constant.ItemType.BUTTON);
};

initHandwrite = function() {
  var MOVE_FREQUENCY, click, drag, enableMoveEvent, item, lastX, lastY, mouseDownDrawing, mouseMoveDrawing, mouseUpDrawing, queueLoc, windowToCanvas, zindex;
  drag = false;
  click = false;
  lastX = null;
  lastY = null;
  item = null;
  enableMoveEvent = true;
  queueLoc = null;
  zindex = 1;
  MOVE_FREQUENCY = 7;
  windowToCanvas = function(canvas, x, y) {
    var bbox;
    bbox = canvas.getBoundingClientRect();
    return {
      x: x - bbox.left * (canvas.width / bbox.width),
      y: y - bbox.top * (canvas.height / bbox.height)
    };
  };
  mouseDownDrawing = function(loc) {
    if (selectItemMenu === Constant.ItemType.ARROW) {
      item = new WorkTableArrowItem(loc);
    } else if (selectItemMenu === Constant.ItemType.BUTTON) {
      item = new WorkTableButtonItem(loc);
    }
    item.saveDrawingSurface();
    changeMode(Constant.Mode.DRAW);
    return item.startDraw();
  };
  mouseMoveDrawing = function(loc) {
    var q;
    if (enableMoveEvent) {
      enableMoveEvent = false;
      drag = true;
      item.draw(loc);
      if (queueLoc !== null) {
        q = queueLoc;
        queueLoc = null;
        item.draw(q);
      }
      return enableMoveEvent = true;
    } else {
      return queueLoc = loc;
    }
  };
  mouseUpDrawing = function() {
    item.restoreAllDrawingSurface();
    item.endDraw(zindex);
    setupEvents(item);
    changeMode(Constant.Mode.EDIT);
    item.saveObj(Constant.ItemActionType.MAKE);
    return zindex += 1;
  };
  return (function(_this) {
    return function() {
      var calcCanvasLoc, saveLastLoc;
      calcCanvasLoc = function(e) {
        var x, y;
        x = e.x || e.clientX;
        y = e.y || e.clientY;
        return windowToCanvas(drawingCanvas, x, y);
      };
      saveLastLoc = function(loc) {
        lastX = loc.x;
        return lastY = loc.y;
      };
      drawingCanvas.onmousedown = function(e) {
        var loc;
        if (e.which === 1) {
          loc = calcCanvasLoc(e);
          saveLastLoc(loc);
          click = true;
          if (mode === Constant.Mode.DRAW) {
            e.preventDefault();
            return mouseDownDrawing(loc);
          } else if (mode === Constant.Mode.OPTION) {
            closeSidebar();
            return changeMode(Constant.Mode.EDIT);
          }
        }
      };
      drawingCanvas.onmousemove = function(e) {
        var loc;
        if (e.which === 1) {
          loc = calcCanvasLoc(e);
          if (click && Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY) {
            if (mode === Constant.Mode.DRAW) {
              e.preventDefault();
              mouseMoveDrawing(loc);
            }
            return saveLastLoc(loc);
          }
        }
      };
      return drawingCanvas.onmouseup = function(e) {
        if (e.which === 1) {
          if (drag && mode === Constant.Mode.DRAW) {
            e.preventDefault();
            mouseUpDrawing();
          }
        }
        drag = false;
        return click = false;
      };
    };
  })(this)();
};

setupEvents = function(obj) {
  (function() {
    var contextSelector, menu;
    menu = [
      {
        title: "Delete",
        cmd: "delete",
        uiIcon: "ui-icon-scissors"
      }
    ];
    if ((typeof ArrowItem !== "undefined" && ArrowItem !== null) && obj instanceof ArrowItem) {
      menu.push({
        title: "ArrowItem",
        cmd: "cut",
        uiIcon: "ui-icon-scissors"
      });
      contextSelector = ".arrow";
    } else if ((typeof ButtonItem !== "undefined" && ButtonItem !== null) && obj instanceof ButtonItem) {
      menu.push({
        title: "ButtonItem",
        cmd: "cut",
        uiIcon: "ui-icon-scissors"
      });
      contextSelector = ".css3button";
    }
    return setupContextMenu(obj.getJQueryElement(), contextSelector, menu);
  })();
  (function() {
    return obj.getJQueryElement().mousedown(function(e) {
      if (e.which === 1) {
        e.stopPropagation();
        return setSelectedBorder(this, "edit");
      }
    });
  })();
  return (function() {
    obj.getJQueryElement().draggable({
      containment: scrollInside,
      drag: function(event, ui) {
        if (obj.drag != null) {
          return obj.drag();
        }
      },
      stop: function(event, ui) {
        return obj.saveObj(Constant.ItemActionType.MOVE);
      }
    });
    return obj.getJQueryElement().resizable({
      containment: scrollInside,
      resize: function(event, ui) {
        if (obj.resize != null) {
          return obj.resize();
        }
      },
      stop: function(event, ui) {
        return obj.saveObj(Constant.ItemActionType.MOVE);
      }
    });
  })();
};

setSelectedBorder = function(target, selectedBorderType) {
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
  return $(target).append("<div class=" + className + " />");
};

clearSelectedBorder = function() {
  return $('.editSelected, .timelineSelected').remove();
};

setupContextMenu = function(element, contextSelector, menu) {
  var initOptionMenu;
  initOptionMenu = function(event) {
    var emt, obj;
    emt = $(event.target);
    obj = getObjFromObjectListByElementId(emt.attr('id'));
    if ((obj != null) && (obj.setupOptionMenu != null)) {
      obj.setupOptionMenu();
    }
    if ((obj != null) && (obj.showOptionMenu != null)) {
      return obj.showOptionMenu();
    }
  };
  return element.contextmenu({
    delegate: contextSelector,
    preventContextMenuForPopup: true,
    preventSelect: true,
    menu: menu,
    select: function(event, ui) {
      var $target;
      $target = event.target;
      switch (ui.cmd) {
        case "delete":
          $target.remove();
          return;
        case "cut":
          break;
        default:
          return;
      }
      initColorPickerValue();
      initOptionMenu(event);
      openConfigSidebar($target);
      return changeMode(Constant.Mode.OPTION);
    },
    beforeOpen: function(event, ui) {
      return ui.menu.zIndex($(event.target).zIndex() + 1);
    }
  });
};

getObjFromObjectListByElementId = function(emtId) {
  var obj;
  obj = null;
  itemObjectList.forEach(function(o) {
    var objId;
    objId = o.constructor.getIdByElementId(emtId);
    if (objId === o.id) {
      return obj = o;
    }
  });
  return obj;
};


/* スライダーの作成 */

settingSlider = function(id, min, max, cssCode, cssStyle, stepValue) {
  var d, defaultValue, meterElement, valueElement;
  if (typeof stepValue === 'undefined') {
    stepValue = 0;
  }
  meterElement = $('#' + id);
  valueElement = $('.' + id + '-value');
  d = $('.' + id + '-value', cssCode)[0];
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

settingGradientSliderByElement = function(element, values, cssCode, cssStyle) {
  var handleElement, id;
  id = element.attr("id");
  try {
    element.slider('destroy');
  } catch (_error) {

  }
  element.slider({
    values: values,
    slide: function(event, ui) {
      var index, position;
      index = $(ui.handle).index();
      position = $('.btn-bg-color' + (index + 2) + '-position', cssCode);
      position.html(ui.value);
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

settingGradientSlider = function(id, values, cssCode, cssStyle) {
  var meterElement;
  meterElement = $('#' + id);
  return settingGradientSliderByElement(meterElement, values, cssCode, cssStyle);
};

settingGradientDegSlider = function(id, min, max, cssCode, cssStyle) {
  var d, defaultValue, meterElement, valueElement, webkitDeg, webkitValueElement;
  meterElement = $('#' + id);
  valueElement = $('.' + id + '-value');
  webkitValueElement = $('.' + id + '-value-webkit');
  d = $('.' + id + '-value', cssCode)[0];
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


/* スライダーの作成 ここまで */


/* グラデーション */

changeGradientShow = function(targetElement, cssCode, cssStyle, cssConfig) {
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
    settingGradientSliderByElement(meterElement, values, cssCode, cssStyle);
    return switchGradientColorSelectorVisible(value, cssConfig);
  }
};

switchGradientColorSelectorVisible = function(gradientStepValue, cssConfig) {
  var element, i, _i, _results;
  _results = [];
  for (i = _i = 2; _i <= 4; i = ++_i) {
    element = $('.btn-bg-color' + i, cssConfig);
    if (i > gradientStepValue - 1) {
      _results.push(element.css('display', 'none'));
    } else {
      _results.push(element.css('display', ''));
    }
  }
  return _results;
};


/* グラデーション ここまで */

initHeaderMenu = function() {
  var itemsMenuEmt, itemsSelectMenuEmt;
  itemsMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
  $('.menu-load', itemsMenuEmt).on('click', function() {
    return loadFromServer();
  });
  $('.menu-save', itemsMenuEmt).on('click', function() {
    return saveToServer();
  });
  itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
  return $('.menu-item', itemsSelectMenuEmt).on('click', function() {
    var itemType;
    itemType = parseInt($(this).attr('id').replace('menu-item-', ''));
    itemsSelectMenuEmt.removeClass('active');
    $(this).parent('li').addClass('active');
    window.selectItemMenu = itemType;
    changeMode(Constant.Mode.DRAW);
    return loadItemJs(itemType);
  });
};

getInitFuncName = function(itemType) {
  var itemName;
  itemName = Constant.ITEM_PATH_LIST[itemType];
  return itemName + "Init";
};

loadItemJs = function(itemType, callback) {
  var itemInitFuncName;
  if (callback == null) {
    callback = null;
  }
  itemInitFuncName = getInitFuncName(itemType);
  if (window.itemInitFuncList[itemInitFuncName] != null) {
    window.itemInitFuncList[itemInitFuncName]();
    if (callback != null) {
      callback();
    }
    return;
  }
  return $.ajax({
    url: "/item_js/index",
    type: "POST",
    dataType: "json",
    data: {
      itemType: itemType
    },
    success: function(data) {
      var option;
      if (data.css_info != null) {
        option = {
          isWorkTable: true,
          css_temp: data.css_info
        };
      }
      return availJs(itemInitFuncName, data.js_src, option, callback);
    },
    error: function(data) {}
  });
};

availJs = function(initName, jsSrc, option, callback) {
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

createColorPicker = function(element) {
  return $(element).ColorPicker({});
};

settingColorPicker = function(element, changeColor, onChange) {
  var emt;
  emt = $(element);
  emt.ColorPickerSetColor(changeColor);
  return emt.ColorPickerResetOnChange(onChange);
};

initColorPickerValue = function() {
  return $('.colorPicker', sidebarWrapper).each(function() {
    var color, id, inputEmt;
    id = $(this).attr('id');
    color = $('.' + id, cssCode).html();
    $(this).css('backgroundColor', '#' + color);
    inputEmt = sidebarWrapper.find('#' + id + '-input');
    return inputEmt.attr('value', color);
  });
};

changeMode = function(mode) {
  if (mode === Constant.Mode.DRAW) {
    $(window.drawingCanvas).css('z-index', Constant.ZINDEX_MAX);
  } else if (mode === Constant.Mode.EDIT) {
    $(window.drawingCanvas).css('z-index', 0);
  } else if (mode === Constant.Mode.OPTION) {
    $(window.drawingCanvas).css('z-index', Constant.ZINDEX_MAX);
  }
  return window.mode = mode;
};

clearAllItemStyle = function() {
  itemObjectList.forEach(function(obj) {
    return obj.clearAllEventStyle();
  });
  clearSelectedBorder();
  return $('.colorPicker').ColorPickerHide();
};


/* サイドバー */

openConfigSidebar = function(target, selectedBorderType) {
  var main;
  if (target == null) {
    target = null;
  }
  if (selectedBorderType == null) {
    selectedBorderType = "edit";
  }
  main = $('#main');
  if (!isOpenedConfigSidebar()) {
    main.switchClass('col-md-12', 'col-md-9', 500, 'swing', function() {
      return $('#sidebar').fadeIn('1000');
    });
    if (target !== null) {
      return focusToTarget(target, selectedBorderType);
    }
  }
};

isOpenedConfigSidebar = function() {
  return $('#main').hasClass('col-md-9');
};

closeSidebar = function() {
  var main;
  main = $('#main');
  if (!isClosedConfigSidebar()) {
    return $('#sidebar').fadeOut('1000', function() {
      scrollContents.animate({
        scrollLeft: 0
      }, 500);
      main.switchClass('col-md-9', 'col-md-12', 500, 'swing');
      return $('.sidebar-config').css('display', 'none');
    });
  }
};

isClosedConfigSidebar = function() {
  return $('#main').hasClass('col-md-12');
};

switchSidebarConfig = function(configType) {
  var animation;
  animation = isOpenedConfigSidebar();
  $('.sidebar-config').css('display', 'none');
  if (configType === "edit") {
    if (animation) {
      return $('#css-config').show();
    } else {
      return $('#css-config').css('display', '');
    }
  } else if (configType === "canvas") {
    if (animation) {
      return $('#canvas-config').show();
    } else {
      return $('#canvas-config').css('display', '');
    }
  } else if (configType === "timeline") {
    if (animation) {
      return $('#timeline-config').show();
    } else {
      return $('#timeline-config').css('display', '');
    }
  }
};

focusToTarget = function(target, selectedBorderType) {
  var scrollLeft, scrollTop, targetMiddle;
  if (selectedBorderType == null) {
    selectedBorderType = "edit";
  }
  setSelectedBorder(target, selectedBorderType);
  targetMiddle = {
    top: $(target).offset().top + $(target).height() * 0.5,
    left: $(target).offset().left + $(target).width() * 0.5
  };
  scrollTop = targetMiddle.top - scrollContents.height() * 0.5;
  if (scrollTop < 0) {
    scrollTop = 0;
  } else if (scrollTop > scrollContents.height() * 0.25) {
    scrollTop = scrollContents.height() * 0.25;
  }
  scrollLeft = targetMiddle.left - scrollContents.width() * 0.75 * 0.5;
  if (scrollLeft < 0) {
    scrollLeft = 0;
  } else if (scrollLeft > scrollContents.width() * 0.25) {
    scrollLeft = scrollContents.width() * 0.25;
  }
  console.log("focusToTarget:: scrollTop:" + scrollTop + " scrollLeft:" + scrollLeft);
  return scrollContents.animate({
    scrollTop: scrollContents.scrollTop() + scrollTop,
    scrollLeft: scrollContents.scrollLeft() + scrollLeft
  }, 500);
};

showWarn = function(message) {
  var bottom, css, errorFooter, exist_mes, isBeforeWarnDisplay, isErrorDisplay, mes, warnDisplay, warnFooter;
  warnFooter = $('.warn-message');
  errorFooter = $('.error-message');
  warnDisplay = $('.footer-message-display', warnFooter);
  isBeforeWarnDisplay = warnDisplay.val() === "1";
  isErrorDisplay = $('.footer-message-display', errorFooter).val() === "1";
  mes = $('> div > p', warnFooter);
  if (message === void 0) {
    return;
  }
  warnDisplay.val("1");
  exist_mes = mes.html();
  if (exist_mes === null || exist_mes === "") {
    mes.html(message);
  } else {
    mes.html(exist_mes + '<br/>' + message);
  }
  if (messageTimer !== null) {
    clearTimeout(messageTimer);
  }
  if (isBeforeWarnDisplay) {
    css = {};
  } else {
    if (isErrorDisplay) {
      bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10;
      css = {
        bottom: bottom + 'px'
      };
    } else {
      css = {
        bottom: '20px'
      };
    }
  }
  return warnFooter.animate(css, 'fast', function(e) {
    return window.messageTimer = setTimeout(function(e) {
      var footer;
      footer = $('.footer-message');
      $('.footer-message-display', footer).val("0");
      return footer.stop().animate({
        bottom: '-30px'
      }, 'fast', function(e) {
        window.messageTimer = null;
        return $('> div > p', $(this)).html('');
      });
    }, 3000);
  });
};

showError = function(message) {
  var css, errorDisplay, errorFooter, exist_mes, isBeforeErrorDisplay, isWarnDisplay, mes, warnFooter;
  warnFooter = $('.warn-message');
  errorFooter = $('.error-message');
  errorDisplay = $('.footer-message-display', errorFooter);
  isBeforeErrorDisplay = errorDisplay.val() === "1";
  isWarnDisplay = $('.footer-message-display', warnFooter).val() === "1";
  mes = $('> div > p', errorFooter);
  if (message === void 0) {
    return;
  }
  errorDisplay.val("1");
  exist_mes = mes.html();
  if (exist_mes === null || exist_mes === "") {
    mes.html(message);
  } else {
    mes.html(exist_mes + '<br/>' + message);
  }
  if (messageTimer !== null) {
    clearTimeout(messageTimer);
  }
  if (isBeforeErrorDisplay) {
    css = {};
  } else {
    css = {
      bottom: '20px'
    };
  }
  return errorFooter.animate(css, 'fast', function(e) {
    var bottom;
    if (isWarnDisplay) {
      bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10;
      css = {
        bottom: bottom + 'px'
      };
      warnFooter.stop().animate(css, 'fast');
    }
    return window.messageTimer = setTimeout(function(e) {
      var footer;
      footer = $('.footer-message');
      $('.footer-message-display', footer).val("0");
      return footer.stop().animate({
        bottom: '-30px'
      }, 'fast', function(e) {
        window.messageTimer = null;
        return $('> div > p', $(this)).html('');
      });
    }, 3000);
  });
};

flushWarn = function(message) {
  var fw, mes;
  if (window.messageTimer !== null) {
    return;
  }
  if (window.flushMessageTimer !== null) {
    clearTimeout(flushMessageTimer);
  }
  fw = $('#flush_warn');
  mes = $('> div > p', fw);
  mes.html(message);
  fw.show();
  return window.flushMessageTimer = setTimeout(function(e) {
    return fw.hide();
  }, 100);
};

initKeyEvent = function() {
  return $(window).keydown(function(e) {
    var isMac;
    isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
    if ((isMac && e.metaKey) || (!isMac && e.ctrlKey)) {
      if (e.keyCode === Constant.KeyboardKeyCode.Z) {
        e.preventDefault();
        if (e.shiftKey) {
          return redo();
        } else {
          return undo();
        }
      }
    }
  });
};

undo = function() {
  var action, history, obj, past, pastOperationIndex;
  if (operationHistoryIndex <= 0) {
    flushWarn("Can't Undo");
    return;
  }
  history = popOperationHistory();
  obj = history.obj;
  pastOperationIndex = obj.popOhi();
  action = history.action;
  if (action === Constant.ItemActionType.MAKE) {
    return obj.getJQueryElement().remove();
  } else if (action === Constant.ItemActionType.MOVE) {
    obj.getJQueryElement().remove();
    past = operationHistory[pastOperationIndex];
    obj = past.obj;
    obj.setHistoryObj(past);
    obj.reDraw();
    console.log("undo: itemSize: " + (JSON.stringify(obj.itemSize)));
    setupEvents(obj);
    return console.log("undo2: itemSize: " + (JSON.stringify(obj.itemSize)));
  }
};

redo = function() {
  var action, history, obj;
  if (operationHistory.length <= operationHistoryIndex) {
    flushWarn("Can't Redo");
    return;
  }
  history = popOperationHistoryRedo();
  obj = history.obj;
  obj.incrementOhiRegistIndex();
  action = history.action;
  if (action === Constant.ItemActionType.MAKE) {
    obj.setHistoryObj(history);
    obj.reDraw();
    return setupEvents(obj);
  } else if (action === Constant.ItemActionType.MOVE) {
    obj.getJQueryElement().remove();
    obj.setHistoryObj(history);
    obj.reDraw();
    return setupEvents(obj);
  }
};

saveToServer = function() {
  var jsonList;
  jsonList = [];
  itemObjectList.forEach(function(obj) {
    var j;
    j = {
      id: makeClone(obj.id),
      obj: obj.generateMinimumObject()
    };
    return jsonList.push(j);
  });
  return $.ajax({
    url: "/item_state/save_itemstate",
    type: "POST",
    data: {
      user_id: 0,
      state: JSON.stringify(jsonList)
    },
    dataType: "json",
    success: function(data) {
      return console.log(data.message);
    },
    error: function(data) {
      return console.log(data.message);
    }
  });
};

loadFromServer = function() {
  return $.ajax({
    url: "/item_state/load_itemstate",
    type: "POST",
    data: {
      user_id: 0,
      loaded_item_type_list: JSON.stringify(loadedItemTypeList)
    },
    dataType: "json",
    success: function(data) {
      var callback, cssInfoList, jsList, loadedCount;
      callback = function() {
        var item, itemList, j, obj, _i, _len, _results;
        clearWorkTable();
        itemList = JSON.parse(data.item_list);
        _results = [];
        for (_i = 0, _len = itemList.length; _i < _len; _i++) {
          j = itemList[_i];
          obj = j.obj;
          item = null;
          if (obj.itemType === Constant.ItemType.BUTTON) {
            item = new WorkTableButtonItem();
          } else if (obj.itemType === Constant.ItemType.ARROW) {
            item = new WorkTableArrowItem();
          }
          item.loadByMinimumObject(obj);
          _results.push(setupEvents(item));
        }
        return _results;
      };
      if (data.css_info_list != null) {
        cssInfoList = JSON.parse(data.css_info_list);
        cssInfoList.forEach(function(cssInfo) {
          return $('#css_code_info').append(cssInfo);
        });
      }
      jsList = JSON.parse(data.js_list);
      if (jsList.length === 0) {
        callback();
        return;
      }
      loadedCount = 0;
      return jsList.forEach(function(js) {
        var option;
        option = {
          isWorkTable: true,
          css_temp: js.css_temp
        };
        return availJs(getInitFuncName(js.item_type), js.src, option, function() {
          loadedCount += 1;
          if (loadedCount >= jsList.length) {
            return callback();
          }
        });
      });
    },
    error: function(data) {
      return console.log(data.message);
    }
  });
};


/* 操作履歴 */

pushOperationHistory = function(obj) {
  operationHistory[operationHistoryIndex] = obj;
  return operationHistoryIndex += 1;
};

popOperationHistory = function() {
  operationHistoryIndex -= 1;
  return operationHistory[operationHistoryIndex];
};

popOperationHistoryRedo = function() {
  var obj;
  obj = operationHistory[operationHistoryIndex];
  operationHistoryIndex += 1;
  return obj;
};


/* WebStorage保存 */

drawItemFromStorage = function() {};

addStorage = function(id, obj) {
  return lstorage.setItem(id, obj);
};

getStorageByKey = function(key) {
  return lstorage.getItem(key);
};

clearWorkTable = function() {
  return itemObjectList.forEach(function(obj) {
    return obj.getJQueryElement().remove();
  });
};


/* デバッグ */

runDebug = function() {
  setPageValue('test:ok:desuka:testcache', {
    1: "ok1",
    2: {
      3: "ok2",
      4: "ok3"
    },
    7: "ok7"
  }, true);
  return console.log(getPageValue('test:ok:desuka:testcache'));
};


/* タイムライン */

setupTimelineEvents = function() {
  $('.timeline_event').off('click');
  return $('.timeline_event').on('click', function(e) {
    setSelectedBorder(this, "timeline");
    switchSidebarConfig("timeline");
    if (!isOpenedConfigSidebar()) {
      return openConfigSidebar();
    }
  });
};

setupTimeLineObjects = function() {
  var objList;
  objList = [];
  itemObjectList.forEach(function(item) {
    var obj;
    obj = {
      chapter: 1,
      screen: 1,
      miniObj: item.generateMinimumObject(),
      itemSize: item.itemSize,
      sEvent: "scrollDraw",
      cEvent: "defaultClick"
    };
    return objList.push(obj);
  });
  return objList;
};

setupTimeLineCss = function() {
  var itemCssStyle;
  itemCssStyle = "";
  $('#css_code_info').find('.css-style').each(function() {
    return itemCssStyle += $(this).html();
  });
  itemObjectList.forEach(function(item) {
    if ((typeof ButtonItem !== "undefined" && ButtonItem !== null) && item instanceof ButtonItem) {
      return itemCssStyle += ButtonItem.dentButton(item);
    }
  });
  return itemCssStyle;
};


/* 閲覧 */

run = function() {
  Function.prototype.toJSON = Function.prototype.toString;
  lstorage.setItem('timelineObjList', JSON.stringify(setupTimeLineObjects()));
  lstorage.setItem('loadedItemTypeList', JSON.stringify(loadedItemTypeList));
  lstorage.setItem('itemCssStyle', setupTimeLineCss());
  return window.open('/run');
};

$(function() {
  var menu;
  if (!checkBlowserEnvironment()) {
    alert('ブラウザ非対応です。');
    return;
  }
  initCommonVar();
  $('#contents').css('height', $('#contents').height() - $('#nav').height());
  $('#canvas_container').attr('width', $('#main-wrapper').width());
  $('#canvas_container').attr('height', $('#main-wrapper').height());
  scrollInside.width(scrollContents.width() * (scrollViewMag + 1));
  scrollInside.height(scrollContents.height() * (scrollViewMag + 1));
  scrollContents.scrollLeft(scrollContents.width() * (scrollViewMag * 0.5));
  scrollContents.scrollTop(scrollContents.height() * (scrollViewMag * 0.5));
  $('.dropdown-toggle').dropdown();
  initHeaderMenu();
  initKeyEvent();
  initHandwrite();
  menu = [
    {
      title: "Default",
      cmd: "default",
      uiIcon: "ui-icon-scissors"
    }
  ];
  setupContextMenu($('#main'), '#main-wrapper', menu);
  $('#main').on("mousedown", function() {
    return clearAllItemStyle();
  });
  return setupTimelineEvents();
});

//# sourceMappingURL=worktable.js.js.map
