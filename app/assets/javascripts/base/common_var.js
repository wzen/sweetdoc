// Generated by CoffeeScript 1.9.2
var CommonVar;

CommonVar = (function() {
  function CommonVar() {}

  CommonVar.initVarWhenLoadedView = function() {
    window.instanceMap = {};
    window.copiedInstance = null;
    window.operationHistories = {};
    window.operationHistoryTailIndexes = {};
    window.operationHistoryIndexes = {};
    return window.mode = Constant.Mode.NOT_SELECT;
  };

  CommonVar.initCommonVar = function() {
    window.appName = 'SugerDoc';
    window.scrollViewSize = 30000;
    return window.pageNumMax = 10000;
  };

  CommonVar.updateWorktableBaseElement = function(pageNum) {
    var page;
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    window.sidebarWrapper = $("#sidebar-wrapper");
    window.scrollContents = $("#pages ." + page + " .scroll_contents:first");
    window.scrollInsideWrapper = $("#pages ." + page + " .scroll_inside_wrapper:first");
    window.scrollInside = $("#pages ." + page + " .scroll_inside:first");
    window.mainWrapper = $("#pages ." + page + " .main-wrapper:first");
    window.drawingCanvas = $("#pages ." + page + " .canvas_container:first")[0];
    window.drawingContext = drawingCanvas.getContext('2d');
    return window.cssCode = $("#cssCode");
  };

  CommonVar.updateRunBaseElement = function(pageNum) {
    var page;
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    window.mainWrapper = $("#pages ." + page + " .main-wrapper:first");
    window.scrollContents = $("#pages ." + page + " .scroll_contents:first");
    window.scrollHandleWrapper = $("#pages ." + page + " .scroll_handle_wrapper:first");
    window.scrollHandle = $("#pages ." + page + " .scroll_handle:first");
    window.scrollInsideCover = $("#pages ." + page + " .scroll_inside_cover:first");
    window.scrollInsideWrapper = $("#pages ." + page + " .scroll_inside_wrapper:first");
    window.scrollInside = $("#pages ." + page + " .scroll_inside:first");
    window.canvasWrapper = $("#pages ." + page + " .canvas_wrapper:first");
    window.drawingCanvas = $("#pages ." + page + " .canvas_container:first")[0];
    window.drawingContext = drawingCanvas.getContext('2d');
    return window.cssCode = $("#cssCode");
  };

  CommonVar.updateItemPreviewBaseElement = function() {
    window.sidebarWrapper = $("#sidebar-wrapper");
    window.mainWrapper = $("#main .main-wrapper:first");
    window.scrollContents = $("#main .scroll_contents:first");
    window.scrollHandleWrapper = $("#main .scroll_handle_wrapper:first");
    window.scrollHandle = $("#main .scroll_handle:first");
    window.scrollInsideCover = $("#main .scroll_inside_cover:first");
    window.scrollInsideWrapper = $("#main .scroll_inside_wrapper:first");
    window.scrollInside = $("#main .scroll_inside:first");
    window.canvasWrapper = $("#main .canvas_wrapper:first");
    window.drawingCanvas = $("#main .canvas_container:first")[0];
    window.drawingContext = drawingCanvas.getContext('2d');
    return window.cssCode = $("#cssCode");
  };

  CommonVar.worktableCommonVar = function() {
    this.initCommonVar();
    window.messageTimer = null;
    window.flushMessageTimer = null;
    window.selectedObjId = null;
    window.runningPreview = false;
    return this.updateWorktableBaseElement(PageValue.getPageNum());
  };

  CommonVar.runCommonVar = function() {
    this.initCommonVar();
    window.distX = 0;
    window.distY = 0;
    window.resizeTimer = false;
    window.scrollViewSwitchZindex = {
      'on': Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT),
      'off': Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM)
    };
    window.disabledEventHandler = false;
    window.firstItemFocused = false;
    return this.updateRunBaseElement(PageValue.getPageNum());
  };

  return CommonVar;

})();

(function() {
  var constant;
  window.itemInitFuncList = {};
  window.debug = false;
  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    window.debug = constant.DEBUG_JS;
  }
  return window.runDebug = false;
})();

//# sourceMappingURL=common_var.js.map
