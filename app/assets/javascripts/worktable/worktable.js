// Generated by CoffeeScript 1.9.2
var changeMode, clearAllItemStyle, clearSelectedBorder, clearWorkTable, focusToTargetWhenSidebarOpen, getInitFuncName, initKeyEvent, runDebug, setSelectedBorder;

window.worktablePage = true;

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
    $(window.drawingCanvas).css('z-index', Constant.Zindex.MAX);
  } else if (mode === Constant.Mode.EDIT) {
    $(window.drawingCanvas).css('z-index', Constant.Zindex.EVENTBOTTOM);
  } else if (mode === Constant.Mode.OPTION) {
    $(window.drawingCanvas).css('z-index', Constant.Zindex.MAX);
  }
  return window.mode = mode;
};

clearAllItemStyle = function() {
  var k, ref, v;
  ref = Common.getCreatedItemObject();
  for (k in ref) {
    v = ref[k];
    if (v instanceof ItemBase) {
      v.clearAllEventStyle();
    }
  }
  clearSelectedBorder();
  return $('.colorPicker').ColorPickerHide();
};

focusToTargetWhenSidebarOpen = function(target, selectedBorderType) {
  if (selectedBorderType == null) {
    selectedBorderType = "edit";
  }
  setSelectedBorder(target, selectedBorderType);
  PageValue.setInstancePageValue(PageValue.Key.CONFIG_OPENED_SCROLL, {
    top: scrollContents.scrollTop(),
    left: scrollContents.scrollLeft()
  }, true);
  LocalStorage.savePageValue();
  return Common.focusToTarget(target);
};

initKeyEvent = function() {
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

clearWorkTable = function() {
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

runDebug = function() {};

$(function() {
  var borderWidth, menu, padding, timelineTopPadding;
  if (!Common.checkBlowserEnvironment()) {
    alert('ブラウザ非対応です。');
    return;
  }
  worktableCommonVar();
  $('#contents').css('height', $('#contents').height() - $("#" + Constant.ElementAttribute.NAVBAR_ROOT).height());
  borderWidth = 5;
  timelineTopPadding = 5;
  padding = borderWidth * 4 + timelineTopPadding;
  window.mainWrapper.height($('#contents').height() - $('#timeline').height() - padding);
  $('#canvas_container').attr('width', window.mainWrapper.width());
  $('#canvas_container').attr('height', window.mainWrapper.height());
  scrollInside.width(window.scrollViewSize);
  scrollInside.height(window.scrollViewSize);
  scrollContents.scrollLeft(scrollInside.width() * 0.5);
  scrollContents.scrollTop(scrollInside.height() * 0.5);
  $('.dropdown-toggle').dropdown();
  initHeaderMenu();
  initKeyEvent();
  Handwrite.initHandwrite();
  menu = [
    {
      title: "Default",
      cmd: "default",
      uiIcon: "ui-icon-scissors"
    }
  ];
  WorktableCommon.setupContextMenu($('#main'), '#main-wrapper', menu);
  $('#main').on("mousedown", function() {
    return clearAllItemStyle();
  });
  if (!LocalStorage.isOverWorktableSaveTimeLimit()) {
    LocalStorage.loadValueForWorktable();
    PageValue.adjustInstanceAndEvent();
    WorktableCommon.drawAllItemFromEventPageValue();
  } else {
    LocalStorage.clearWorktable();
    Timeline.refreshAllTimeline();
  }
  return OperationHistory.add();
});

//# sourceMappingURL=worktable.js.map
