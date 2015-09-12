// Generated by CoffeeScript 1.9.2
var CommonVar;

CommonVar = (function() {
  function CommonVar() {}

  CommonVar.initVarWhenLoadedView = function() {
    window.instanceMap = {};
    window.itemInitFuncList = [];
    window.debug = true;
    window.copiedInstance = null;
    window.operationHistories = {};
    window.operationHistoryTailIndexes = {};
    return window.operationHistoryIndexes = {};
  };

  CommonVar.initCommonVar = function() {
    window.scrollViewSize = 30000;
    return window.pageNumMax = 10000;
  };

  CommonVar.updateWorktableBaseElement = function(pageNum) {
    var page;
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    window.sidebarWrapper = $("#sidebar-wrapper");
    window.scrollContents = $("#pages ." + page + " .scroll_contents:first");
    window.scrollInside = $("#pages ." + page + " .scroll_inside:first");
    window.mainWrapper = $("#pages ." + page + " .main-wrapper:first");
    window.drawingCanvas = $("#pages ." + page + " .canvas_container:first")[0];
    window.drawingContext = drawingCanvas.getContext('2d');
    return window.cssCode = $("#cssCode");
  };

  CommonVar.updateRunBaseElement = function(pageNum) {
    var page;
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    window.scrollWrapper = $("#sidebar-wrapper");
    window.mainWrapper = $("#pages ." + page + " .main-wrapper:first");
    window.scrollContents = $("#pages ." + page + " .scroll_contents:first");
    window.scrollHandleWrapper = $("#pages ." + page + " .scroll_handle_wrapper:first");
    window.scrollHandle = $("#pages ." + page + " .scroll_handle:first");
    window.scrollInsideCover = $("#pages ." + page + " .scroll_inside_cover:first");
    window.scrollInside = $("#pages ." + page + " .scroll_inside:first");
    window.canvasWrapper = $("#pages ." + page + " .canvas_wrapper:first");
    window.drawingCanvas = $("#pages ." + page + " .canvas_container:first")[0];
    window.drawingContext = drawingCanvas.getContext('2d');
    return window.cssCode = $("#cssCode");
  };

  CommonVar.worktableCommonVar = function() {
    this.initCommonVar();
    window.messageTimer = null;
    window.flushMessageTimer = null;
    window.mode = Constant.Mode.DRAW;
    window.selectedObjId = null;
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

//# sourceMappingURL=common_var.js.map
