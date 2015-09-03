// Generated by CoffeeScript 1.9.2
var Worktable;

Worktable = (function() {
  function Worktable() {}

  window.worktablePage = true;

  return Worktable;

})();

$(function() {
  var _callback, existedCache;
  if (!Common.checkBlowserEnvironment()) {
    alert('ブラウザ非対応です。');
    return;
  }
  existedCache = !LocalStorage.isOverWorktableSaveTimeLimit();
  if (existedCache) {
    LocalStorage.loadValueForWorktable();
  }
  CommonVar.initVarWhenLoadedView();
  CommonVar.initCommonVar();
  Common.createdMainContainerIfNeeded(PageValue.getPageNum());
  WorktableCommon.initMainContainer();
  WorktableCommon.initResize();
  _callback = function() {
    OperationHistory.add(true);
    PageValue.updatePageCount();
    return Paging.initPaging();
  };
  if (existedCache) {
    PageValue.adjustInstanceAndEventOnThisPage();
    return WorktableCommon.drawAllItemFromEventPageValue(_callback);
  } else {
    LocalStorage.clearWorktable();
    Timeline.refreshAllTimeline();
    return _callback.call(this);
  }
});

//# sourceMappingURL=worktable.js.map
