// Generated by CoffeeScript 1.10.0
$(function() {
  var is_reload;
  window.isWorkTable = false;
  window.eventAction = null;
  window.runPage = true;
  window.initDone = false;
  CommonVar.initVarWhenLoadedView();
  CommonVar.initCommonVar();
  PageValue.setPageNum(1);
  is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD);
  if (is_reload != null) {
    LocalStorage.loadAllPageValues();
  } else {
    LocalStorage.saveAllPageValues();
  }
  Common.createdMainContainerIfNeeded(PageValue.getPageNum());
  RunCommon.initMainContainer();
  return Common.loadJsFromInstancePageValue(function() {
    RunCommon.initEventAction();
    return window.initDone = true;
  });
});

//# sourceMappingURL=run.js.map
