// Generated by CoffeeScript 1.9.2
var changeMode, clearAllItemStyle, clearSelectedBorder, clearWorkTable, focusToTargetWhenSidebarOpen, getInitFuncName, initKeyEvent, initMainContainer, runDebug, setSelectedBorder;

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
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.MAX));
  } else if (mode === Constant.Mode.EDIT) {
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM));
  } else if (mode === Constant.Mode.OPTION) {
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.MAX));
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
  LocalStorage.saveInstancePageValue();
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

initMainContainer = function() {
  var borderWidth, menu, padding, page, timelineTopPadding;
  CommonVar.worktableCommonVar();
  $('#contents').css('height', $('#contents').height() - $("#" + Constant.ElementAttribute.NAVBAR_ROOT).height());
  borderWidth = 5;
  timelineTopPadding = 5;
  padding = borderWidth * 4 + timelineTopPadding;
  window.mainWrapper.height($('#contents').height() - $('#timeline').height() - padding);
  $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM));
  $(window.drawingCanvas).attr('width', window.mainWrapper.width());
  $(window.drawingCanvas).attr('height', window.mainWrapper.height());
  scrollInside.width(window.scrollViewSize);
  scrollInside.height(window.scrollViewSize);
  scrollContents.scrollLeft(scrollInside.width() * 0.5);
  scrollContents.scrollTop(scrollInside.height() * 0.5);
  $('.dropdown-toggle').dropdown();
  Navbar.initWorktableNavbar();
  initKeyEvent();
  Handwrite.initHandwrite();
  menu = [
    {
      title: "Default",
      cmd: "default",
      uiIcon: "ui-icon-scissors"
    }
  ];
  page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', window.pageNum);
  WorktableCommon.setupContextMenu($('#main'), "#pages ." + page + " .main-wrapper:first", menu);
  return $('#main').on("mousedown", function() {
    return clearAllItemStyle();
  });
};

$(function() {
  var existedCache;
  if (!Common.checkBlowserEnvironment()) {
    alert('ブラウザ非対応です。');
    return;
  }
  window.pageNum = PageValue.getPageNum();
  existedCache = !LocalStorage.isOverWorktableSaveTimeLimit();
  if (existedCache) {
    LocalStorage.loadValueForWorktable();
  }
  window.pageNum = PageValue.getPageNum();
  Common.createdMainContainerIfNeeded(window.pageNum);
  initMainContainer();
  if (existedCache) {
    PageValue.adjustInstanceAndEventOnThisPage();
    WorktableCommon.drawAllItemFromEventPageValue();
  } else {
    LocalStorage.clearWorktable();
    Timeline.refreshAllTimeline();
  }
  OperationHistory.add(true);
  PageValue.updatePageCount();
  return Paging.initPaging();
});

//# sourceMappingURL=worktable.js.map
