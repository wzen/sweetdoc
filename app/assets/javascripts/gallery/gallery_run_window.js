// Generated by CoffeeScript 1.9.2
$(function() {
  window.isWorkTable = false;
  window.eventAction = null;
  window.runPage = true;
  window.initDone = false;
  CommonVar.initVarWhenLoadedView();
  CommonVar.initCommonVar();
  PageValue.setPageNum(1);
  Common.createdMainContainerIfNeeded(PageValue.getPageNum());
  RunCommon.initMainContainer();
  return Common.loadJsFromInstancePageValue(function() {
    RunCommon.initEventAction();
    return window.initDone = true;
  });
});

//# sourceMappingURL=gallery_run_window.js.map
