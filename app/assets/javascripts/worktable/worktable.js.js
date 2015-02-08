// Generated by CoffeeScript 1.8.0
var WorkTableCanvasItemExtend, WorkTableCommonExtend, WorkTableCssItemExtend, addStorage, addTimelineEventContents, availJs, changeGradientShow, changeMode, clearAllItemStyle, clearSelectedBorder, clearWorkTable, closeSidebar, createColorPicker, drawItemFromStorage, flushWarn, focusToTargetWhenSidebarOpen, getInitFuncName, getObjFromObjectListByElementId, getStorageByKey, initColorPickerValue, initCommonVar, initHandwrite, initHeaderMenu, initKeyEvent, isClosedConfigSidebar, isOpenedConfigSidebar, loadFromServer, loadItemJs, openConfigSidebar, popOperationHistory, popOperationHistoryRedo, pushOperationHistory, redo, run, runDebug, saveToServer, setSelectedBorder, settingColorPicker, settingGradientDegSlider, settingGradientSlider, settingGradientSliderByElement, settingSlider, setupContextMenu, setupEvents, setupTimeLineCss, setupTimeLineObjects, setupTimelineEvents, showError, showWarn, switchGradientColorSelectorVisible, switchSidebarConfig, undo;

window.worktablePage = true;

WorkTableCommonExtend = {
  showOptionMenu: function() {
    var sc;
    sc = $('.sidebar-config');
    sc.css('display', 'none');
    $('.dc', sc).css('display', 'none');
    $('#design-config').css('display', '');
    return $('#' + this.getDesignConfigId()).css('display', '');
  }
};

WorkTableCssItemExtend = {
  makeDesignConfig: function() {
    var cssConfig;
    this.designConfigRoot = $('#' + this.getDesignConfigId());
    if ((this.designConfigRoot == null) || this.designConfigRoot.length === 0) {
      this.designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', this.getDesignConfigId());
      this.designConfigRoot.removeClass('design_temp');
      cssConfig = this.designConfigRoot.find('.css-config');
      this.designConfigRoot.find('.css-config').css('display', '');
      this.designConfigRoot.find('.canvas-config').remove();
      return $('#design-config').append(this.designConfigRoot);
    }
  },
  drag: function() {
    var element;
    element = $('#' + this.id);
    this.itemSize.x = element.position().left;
    return this.itemSize.y = element.position().top;
  },
  resize: function() {
    var element;
    element = $('#' + this.id);
    this.itemSize.w = element.width();
    return this.itemSize.h = element.height();
  },
  getHistoryObj: function(action) {
    var obj;
    obj = {
      obj: this,
      action: action,
      itemSize: makeClone(this.itemSize)
    };
    return obj;
  },
  setHistoryObj: function(historyObj) {
    return this.itemSize = makeClone(historyObj.itemSize);
  }
};

WorkTableCanvasItemExtend = {
  makeDesignConfig: function() {
    this.designConfigRoot = $('#' + this.getDesignConfigId());
    if ((this.designConfigRoot == null) || this.designConfigRoot.length === 0) {
      this.designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', this.getDesignConfigId());
      this.designConfigRoot.removeClass('design_temp');
      this.designConfigRoot.find('.canvas-config').css('display', '');
      this.designConfigRoot.find('.css-config').remove();
      return $('#design-config').append(this.designConfigRoot);
    }
  },
  drag: function() {
    var element;
    element = $('#' + this.id);
    this.itemSize.x = element.position().left;
    this.itemSize.y = element.position().top;
    return console.log("drag: itemSize: " + (JSON.stringify(this.itemSize)));
  },
  resize: function() {
    var canvas, drawingCanvas, drawingContext, element;
    canvas = $('#' + this.canvasElementId());
    element = $('#' + this.id);
    this.scale.w = element.width() / this.itemSize.w;
    this.scale.h = element.height() / this.itemSize.h;
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    drawingContext.scale(this.scale.w, this.scale.h);
    this.drawNewCanvas();
    return console.log("resize: itemSize: " + (JSON.stringify(this.itemSize)));
  },
  getHistoryObj: function(action) {
    var obj;
    obj = {
      obj: this,
      action: action,
      itemSize: makeClone(this.itemSize),
      scale: makeClone(this.scale)
    };
    console.log("getHistory: scale:" + this.scale.w + "," + this.scale.h);
    return obj;
  },
  setHistoryObj: function(historyObj) {
    this.itemSize = makeClone(historyObj.itemSize);
    this.scale = makeClone(historyObj.scale);
    return console.log("setHistoryObj: itemSize: " + (JSON.stringify(this.itemSize)));
  }
};

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
        clearSelectedBorder();
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
    if (emtId === o.id) {
      return obj = o;
    }
  });
  return obj;
};


/* スライダーの作成 */

settingSlider = function(className, min, max, cssCode, cssStyle, root, stepValue) {
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

settingGradientSlider = function(className, values, cssCode, cssStyle, root) {
  var meterElement;
  meterElement = $('.' + className, root);
  return settingGradientSliderByElement(meterElement, values, cssCode, cssStyle);
};

settingGradientDegSlider = function(className, min, max, cssCode, cssStyle, root) {
  var d, defaultValue, meterElement, valueElement, webkitDeg, webkitValueElement;
  meterElement = $('.' + className, root);
  valueElement = $('.' + className + '-value', root);
  webkitValueElement = $('.' + className + '-value-webkit', root);
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
      itemId: itemType
    },
    success: function(data) {
      var option;
      if (data.css_info != null) {
        option = {
          isWorkTable: true,
          css_temp: data.css_info
        };
      }
      availJs(itemInitFuncName, data.js_src, option, callback);
      return addTimelineEventContents(data.te_actions, data.te_values);
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

addTimelineEventContents = function(te_actions, te_values) {
  var action_forms, className, li;
  if ((te_actions != null) && te_actions.length > 0) {
    className = Constant.ElementAttribute.TE_ACTION_CLASS.replace('@itemid', te_actions[0].item_id);
    action_forms = $('#timeline-config .action_forms');
    if (action_forms.find("." + className).length === 0) {
      li = '';
      te_actions.forEach(function(a) {
        var actionType;
        actionType = null;
        if (a.action_event_type_id === Constant.ActionEventType.SCROLL) {
          actionType = "scroll";
        } else if (a.action_event_type_id === Constant.ActionEventType.CLICK) {
          actionType = "click";
        }
        return li += "<li class='push method " + actionType + " " + a.method_name + "'>\n  " + a.options['name'] + "\n  <input class='item_id' type='hidden' value='" + a.item_id + "' >\n  <input class='method_name' type='hidden' value='" + a.method_name + "'>\n</li>";
      });
      $("<div class='" + className + "'><ul>" + li + "</ul></div>").appendTo(action_forms);
    }
  }
  if (te_values != null) {
    return $(te_values).appendTo($('#timeline-config .value_forms'));
  }
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
      return focusToTargetWhenSidebarOpen(target, selectedBorderType);
    }
  }
};

closeSidebar = function(callback) {
  var main;
  if (callback == null) {
    callback = null;
  }
  main = $('#main');
  if (!isClosedConfigSidebar()) {
    return $('#sidebar').fadeOut('1000', function() {
      var s;
      s = getPageValue(Constant.PageValueKey.CONFIG_OPENED_SCROLL);
      if (s != null) {
        scrollContents.animate({
          scrollTop: s.top,
          scrollLeft: s.left
        }, 500, null, function() {
          return removePageValue(Constant.PageValueKey.CONFIG_OPENED_SCROLL);
        });
      }
      main.switchClass('col-md-9', 'col-md-12', 500, 'swing', function() {
        if (callback != null) {
          return callback();
        }
      });
      return $('.sidebar-config').css('display', 'none');
    });
  }
};

isOpenedConfigSidebar = function() {
  return $('#main').hasClass('col-md-9');
};

isClosedConfigSidebar = function() {
  return $('#main').hasClass('col-md-12');
};

switchSidebarConfig = function(configType, item) {
  var animation;
  if (item == null) {
    item = null;
  }
  animation = isOpenedConfigSidebar();
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
      return $('#timeline-config').show();
    } else {
      return $('#timeline-config').css('display', '');
    }
  }
};

focusToTargetWhenSidebarOpen = function(target, selectedBorderType) {
  if (selectedBorderType == null) {
    selectedBorderType = "edit";
  }
  setSelectedBorder(target, selectedBorderType);
  setPageValue(Constant.PageValueKey.CONFIG_OPENED_SCROLL, {
    top: scrollContents.scrollTop(),
    left: scrollContents.scrollLeft()
  }, true);
  return focusToTarget(target);
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
      obj: obj.getMinimumObject()
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
      loaded_itemids: JSON.stringify(loadedItemTypeList)
    },
    dataType: "json",
    success: function(data) {
      var callback, loadedCount, self;
      self = this;
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
          item.reDrawByMinimumObject(obj);
          _results.push(setupEvents(item));
        }
        return _results;
      };
      if (data.length === 0) {
        callback.call(self);
        return;
      }
      loadedCount = 0;
      return data.forEach(function(d) {
        var itemInitFuncName, option;
        itemInitFuncName = getInitFuncName(d.item_id);
        if (window.itemInitFuncList[itemInitFuncName] != null) {
          window.itemInitFuncList[itemInitFuncName]();
          loadedCount += 1;
          if (loadedCount >= data.length) {
            callback.call(self);
          }
          return;
        }
        if (d.css_info != null) {
          option = {
            isWorkTable: true,
            css_temp: d.css_info
          };
        }
        availJs(itemInitFuncName, d.js_src, option, function() {
          loadedCount += 1;
          if (loadedCount >= data.length) {
            return callback.call(self);
          }
        });
        return addTimelineEventContents(d.te_actions, d.te_values);
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
  var item;
  item = itemObjectList[0];
  if (item.reDrawByObjPageValue()) {
    return setupEvents(item);
  }
};


/* タイムライン */

setupTimelineEvents = function() {
  var initEvents, self;
  self = this;
  initEvents = function(e) {
    var eId, emt, ieSelf, selectAction, selectItem, te_num, updateSelectItemMenu;
    ieSelf = this;
    updateSelectItemMenu = function() {
      var items, selectOptions, teItemSelect, teItemSelects;
      teItemSelects = $('#timeline-config .te_item_select');
      teItemSelect = teItemSelects[0];
      selectOptions = '';
      items = $('#page_values .item');
      items.children().each(function() {
        var id, itemType, name;
        id = $(this).find('input.id').val();
        name = $(this).find('input.name').val();
        itemType = $(this).find('input.itemType').val();
        return selectOptions += "<option value='" + id + "&" + itemType + "'>\n  " + name + "\n</option>";
      });
      return teItemSelects.each(function() {
        $(this).find('option').each(function() {
          if ($(this).val().length > 0 && $(this).val().indexOf('c_') !== 0) {
            return $(this).remove();
          }
        });
        return $(this).append($(selectOptions));
      });
    };
    selectItem = function(e) {
      var d, emt, i, teActionClassName, v, vEmt, values;
      clearSelectedBorder();
      emt = $(e).parents('.event');
      values = $(e).val().split('&');
      v = values[0];
      i = values[1];
      d = null;
      if (v.indexOf('c_') === 0) {
        d = "values_div";
      } else {
        d = "action_div";
        vEmt = $('#' + v);
        setSelectedBorder(vEmt, 'timeline');
        focusToTarget(vEmt);
      }
      teActionClassName = Constant.ElementAttribute.TE_ACTION_CLASS.replace('@itemid', i);
      $(".config.te_div", emt).css('display', 'none');
      $("." + d + " .forms", emt).children("div").css('display', 'none');
      $("." + teActionClassName, emt).css('display', '');
      return $("." + d, emt).css('display', '');
    };
    selectAction = function(e) {
      var emt, item_id, method_name, valueClassName;
      emt = $(e).parents('.event');
      item_id = $(e).find('input.item_id').val();
      method_name = $(e).find('input.method_name').val();
      valueClassName = Constant.ElementAttribute.TE_VALUES_CLASS.replace('@itemid', item_id).replace('@methodname', method_name);
      $(".values_div .forms", emt).children("div").css('display', 'none');
      $("." + valueClassName, emt).css('display', '');
      return $(".config.values_div", emt).css('display', '');
    };
    if ($(e).is('.ui-sortable-helper')) {
      return;
    }
    setSelectedBorder(e, "timeline");
    switchSidebarConfig("timeline");
    te_num = $(e).find('input.te_num').val();
    eId = Constant.ElementAttribute.TE_ITEM_ROOT_ID.replace('@te_num', te_num);
    emt = $('#' + eId);
    if (emt.length === 0) {
      emt = $('#timeline-config .timeline_temp .event').clone(true).attr('id', eId);
      $('#timeline-config').append(emt);
    }
    updateSelectItemMenu.call(ieSelf);
    (function(_this) {
      return (function() {
        var em;
        em = $('.te_item_select', emt);
        em.off('change');
        em.on('change', function(e) {
          return selectItem.call(ieSelf, this);
        });
        em = $('.action_forms li', emt);
        em.off('click');
        em.on('click', function(e) {
          return selectAction.call(ieSelf, this);
        });
        em = $('.push.button.cancel', emt);
        em.off('click');
        return em.on('click', function(e) {
          return closeSidebar(function() {
            return $(".config.te_div", emt).css('display', 'none');
          });
        });
      });
    })(this)();
    $('#timeline-config .event').css('display', 'none');
    emt.css('display', '');
    if (!isOpenedConfigSidebar()) {
      openConfigSidebar();
    }
    if ($(e).hasClass('blank')) {

    } else {

    }
  };
  $('.timeline_event').off('click');
  $('.timeline_event').on('click', function(e) {
    return initEvents.call(self, this);
  });
  return $('#timeline_events').sortable({
    revert: true,
    axis: 'x',
    containment: $('#timeline_events_container'),
    items: '.sortable',
    stop: function(event, ui) {}
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
      miniObj: item.getMinimumObject(),
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
