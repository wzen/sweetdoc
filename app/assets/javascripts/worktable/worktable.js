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
  }
  CommonVar.initVarWhenLoadedView();
  CommonVar.initCommonVar();
  Common.applyEnvironmentFromPagevalue();
  Common.createdMainContainerIfNeeded(PageValue.getPageNum());
  WorktableCommon.initMainContainer();
  WorktableCommon.updateMainViewSize();
  Common.initResize(WorktableCommon.resizeEvent);
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
    return Common.showModalView(Constant.ModalViewType.INIT_PROJECT, Project.initProjectModal, false);
  }
});

//# sourceMappingURL=worktable.js.map
