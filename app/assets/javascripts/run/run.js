// Generated by CoffeeScript 1.9.2
var Run;

Run = (function() {
  function Run() {}

  window.runPage = true;

  return Run;

})();

$(function() {
  CommonVar.initVarWhenLoadedView();
  CommonVar.initCommonVar();
  window.eventAction = null;
  Common.createdMainContainerIfNeeded(PageValue.getPageNum());
  RunCommon.initMainContainer();
  return RunCommon.initEventAction();
});

//# sourceMappingURL=run.js.map
