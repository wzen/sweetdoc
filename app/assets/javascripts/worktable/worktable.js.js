// Generated by CoffeeScript 1.9.2
var changeMode, clearAllItemStyle, clearSelectedBorder, clearWorkTable, focusToTargetWhenSidebarOpen, getInitFuncName, initKeyEvent, runDebug, setSelectedBorder, setupEvents;

window.worktablePage = true;

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
    contextSelector = null;
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

getInitFuncName = function(itemId) {
  var itemName;
  itemName = Constant.ITEM_PATH_LIST[itemId];
  return itemName + "Init";
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
  var k, v;
  for (k in createdObject) {
    v = createdObject[k];
    v.clearAllEventStyle();
  }
  clearSelectedBorder();
  return $('.colorPicker').ColorPickerHide();
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

clearWorkTable = function() {
  var k, results, v;
  results = [];
  for (k in createdObject) {
    v = createdObject[k];
    results.push(v.getJQueryElement().remove());
  }
  return results;
};


/* デバッグ */

runDebug = function() {
  var item, k, v;
  for (k in createdObject) {
    v = createdObject[k];
    item = v;
    return false;
  }
  if (item.reDrawByObjPageValue()) {
    return setupEvents(item);
  }
};

$(function() {
  var menu;
  if (!checkBlowserEnvironment()) {
    alert('ブラウザ非対応です。');
    return;
  }
  worktableCommonVar();
  lstorage.clear();
  window.selectItemMenu = Constant.ItemId.BUTTON;
  loadItemJs(Constant.ItemId.BUTTON);
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
  return setupTimelineEventConfig();
});

//# sourceMappingURL=worktable.js.js.map
