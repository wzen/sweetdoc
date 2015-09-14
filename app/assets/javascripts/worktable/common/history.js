// Generated by CoffeeScript 1.9.2
var OperationHistory;

OperationHistory = (function() {
  var _pop, _popRedo;

  function OperationHistory() {}

  OperationHistory.OPERATION_STORE_MAX = 30;

  OperationHistory.Key = (function() {
    function Key() {}

    Key.INSTANCE = 'iv';

    Key.EVENT = 'ev';

    return Key;

  })();

  OperationHistory.add = function(isInit) {
    var obj;
    if (isInit == null) {
      isInit = false;
    }
    if ((window.operationHistoryIndexes[PageValue.getPageNum()] != null) && !isInit) {
      window.operationHistoryIndexes[PageValue.getPageNum()] = (window.operationHistoryIndexes[PageValue.getPageNum()] + 1) % this.OPERATION_STORE_MAX;
    } else {
      window.operationHistoryIndexes[PageValue.getPageNum()] = 0;
    }
    window.operationHistoryTailIndexes[PageValue.getPageNum()] = window.operationHistoryIndexes[PageValue.getPageNum()];
    obj = {};
    obj[this.Key.INSTANCE] = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix());
    obj[this.Key.EVENT] = PageValue.getEventPageValue(PageValue.Key.eventPageContentsRoot());
    if (window.operationHistories[PageValue.getPageNum()] == null) {
      window.operationHistories[PageValue.getPageNum()] = [];
    }
    return window.operationHistories[PageValue.getPageNum()][window.operationHistoryIndexes[PageValue.getPageNum()]] = obj;
  };

  _pop = function() {
    var eventPageValue, hIndex, instancePageValue, obj;
    if (window.operationHistoryIndexes[PageValue.getPageNum()] == null) {
      return false;
    }
    hIndex = window.operationHistoryIndexes[PageValue.getPageNum()];
    if (hIndex <= 0) {
      hIndex = this.OPERATION_STORE_MAX - 1;
    } else {
      hIndex -= 1;
    }
    if ((window.operationHistories[PageValue.getPageNum()] != null) && (window.operationHistories[PageValue.getPageNum()][hIndex] != null)) {
      obj = window.operationHistories[PageValue.getPageNum()][hIndex];
      WorktableCommon.removeAllItemAndEventOnThisPage();
      instancePageValue = obj[this.Key.INSTANCE];
      eventPageValue = obj[this.Key.EVENT];
      if (instancePageValue != null) {
        PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue);
      }
      if (eventPageValue != null) {
        PageValue.setEventPageValueByPageRootHash(eventPageValue);
      }
      window.operationHistoryIndexes[PageValue.getPageNum()] = hIndex;
      PageValue.adjustInstanceAndEventOnPage();
      LocalStorage.saveAllPageValues();
      WorktableCommon.drawAllItemFromInstancePageValue();
      return true;
    } else {
      return false;
    }
  };

  _popRedo = function() {
    var eventPageValue, hIndex, instancePageValue, obj;
    if (window.operationHistoryIndexes[PageValue.getPageNum()] == null) {
      return false;
    }
    hIndex = (window.operationHistoryIndexes[PageValue.getPageNum()] + 1) % this.OPERATION_STORE_MAX;
    if ((window.operationHistories[PageValue.getPageNum()] != null) && (window.operationHistories[PageValue.getPageNum()][hIndex] != null)) {
      obj = window.operationHistories[PageValue.getPageNum()][hIndex];
      WorktableCommon.removeAllItemAndEventOnThisPage();
      instancePageValue = obj[this.Key.INSTANCE];
      eventPageValue = obj[this.Key.EVENT];
      if (instancePageValue != null) {
        PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue);
      }
      if (eventPageValue != null) {
        PageValue.setEventPageValueByPageRootHash(eventPageValue);
      }
      window.operationHistoryIndexes[PageValue.getPageNum()] = hIndex;
      PageValue.adjustInstanceAndEventOnPage();
      LocalStorage.saveAllPageValues();
      WorktableCommon.drawAllItemFromInstancePageValue();
      return true;
    } else {
      return false;
    }
  };

  OperationHistory.undo = function() {
    var nextTailIndex;
    nextTailIndex = (window.operationHistoryTailIndexes[PageValue.getPageNum()] + 1) % this.OPERATION_STORE_MAX;
    if ((window.operationHistoryIndexes[PageValue.getPageNum()] == null) || nextTailIndex === window.operationHistoryIndexes[PageValue.getPageNum()] || !_pop.call(this)) {
      return Message.flushWarn("Can't Undo");
    }
  };

  OperationHistory.redo = function() {
    if ((window.operationHistoryIndexes[PageValue.getPageNum()] == null) || window.operationHistoryTailIndexes[PageValue.getPageNum()] === window.operationHistoryIndexes[PageValue.getPageNum()] || !_popRedo.call(this)) {
      return Message.flushWarn("Can't Redo");
    }
  };

  return OperationHistory;

})();

//# sourceMappingURL=history.js.map
