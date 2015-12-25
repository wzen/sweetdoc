// Generated by CoffeeScript 1.9.2
$(function() {
  return $('.worktable.index').ready(function() {
    var _callback, existedCache;
    window.isItemPreview = false;
    window.initDone = false;
    if (!Common.checkBlowserEnvironment()) {
      alert('ブラウザ非対応です。');
      return;
    }
    $.ajaxSetup({
      beforeSend: function(xhr) {
        return xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      }
    });
    existedCache = !LocalStorage.isOverWorktableSaveTimeLimit();
    if (existedCache) {
      LocalStorage.loadAllPageValues();
    }
    CommonVar.initVarWhenLoadedView();
    CommonVar.initCommonVar();
    Common.createdMainContainerIfNeeded(PageValue.getPageNum());
    WorktableCommon.initMainContainer();
    Common.initResize(WorktableCommon.resizeEvent);
    _callback = function() {
      OperationHistory.add(true);
      PageValue.updatePageCount();
      PageValue.updateForkCount();
      return Paging.initPaging();
    };
    if (existedCache) {
      PageValue.adjustInstanceAndEventOnPage();
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
        WorktableCommon.createCommonEventInstancesIfNeeded();
        _callback.call(this);
        return window.initDone = true;
      });
      return Timeline.refreshAllTimeline();
    } else {
      LocalStorage.clearWorktable();
      Timeline.refreshAllTimeline();
      _callback.call(this);
      return Common.showModalView(Constant.ModalViewType.INIT_PROJECT, false, Project.initProjectModal);
    }
  });
});

//# sourceMappingURL=worktable.js.map
