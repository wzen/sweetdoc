// Generated by CoffeeScript 1.9.2
var CommonVar;

CommonVar = (function() {
  function CommonVar() {}

  CommonVar.initVarWhenLoadedView = function() {
    window.instanceMap = {};
    return window.itemInitFuncList = [];
  };

  CommonVar.initCommonVar = function() {
    window.scrollViewSize = 30000;
    window.pageNumMax = 10000;
    return window.pageZindexMax = 10000;
  };

  CommonVar.initHistoryVar = function() {
    window.operationHistories = [];
    window.operationHistories[window.pageNum] = [];
    window.operationHistoryLimit = 30;
    window.operationHistoryTailIndex = null;
    window.operationHistoryIndexes = [];
    return window.operationHistoryIndexes[window.pageNum] = null;
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
    this.initHistoryVar();
    return this.updateWorktableBaseElement(window.pageNum);
  };

  CommonVar.runCommonVar = function() {
    this.initCommonVar();
    window.distX = 0;
    window.distY = 0;
    window.resizeTimer = false;
    window.eventAction = null;
    window.scrollViewSwitchZindex = {
      'on': Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT),
      'off': Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM)
    };
    window.disabledEventHandler = false;
    window.firstItemFocused = false;
    return this.updateRunBaseElement(window.pageNum);
  };

  return CommonVar;

})();

//# sourceMappingURL=common_var.js.map
