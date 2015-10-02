// Generated by CoffeeScript 1.9.2
$(function() {
  var _callback, existedCache;
  window.isWorkTable = true;
  if (!Common.checkBlowserEnvironment()) {
    alert('ブラウザ非対応です。');
    return;
  }
  existedCache = !LocalStorage.isOverWorktableSaveTimeLimit();
  if (existedCache) {
    LocalStorage.loadAllPageValues();
    Common.applyEnvironmentFromPagevalue();
  }
  CommonVar.initVarWhenLoadedView();
  CommonVar.initCommonVar();
  Common.createdMainContainerIfNeeded(PageValue.getPageNum());
  WorktableCommon.initMainContainer();
  WorktableCommon.updateMainViewSize();
  WorktableCommon.initResize();
  _callback = function() {
    OperationHistory.add(true);
    PageValue.updatePageCount();
    PageValue.updateForkCount();
    return Paging.initPaging();
  };
  if (existedCache) {
    PageValue.adjustInstanceAndEventOnPage();
    WorktableCommon.drawAllItemFromInstancePageValue(_callback);
    return Timeline.refreshAllTimeline();
  } else {
    LocalStorage.clearWorktable();
    Timeline.refreshAllTimeline();
    _callback.call(this);
    return Common.showModalView(Constant.ModalViewType.INIT_PROJECT, WorktableCommon.initProjectModal, false);
  }
});

//# sourceMappingURL=worktable.js.map
