import PageValue from '../../../base/page_value';
import Timeline from '../event/timeline.jsx';
import WorktableCommon from './worktable_common';

let _pop = undefined;
let _popRedo = undefined;
export default class OperationHistory {

  static get KEYS() {
    return {
      INSTANCE: 'iv',
      EVENT: 'ev'
    }
  }

  static get OPERATION_STORE_MAX() {
    return 30;
  }

  // 操作履歴を取り出し
  // @return [Boolean] 処理したか
  _pop = function() {
    if((window.operationHistoryIndexes[this.operationHistoryIndex()] === null)) {
      return false;
    }

    let hIndex = window.operationHistoryIndexes[this.operationHistoryIndex()];
    if(hIndex <= 0) {
      hIndex = this.OPERATION_STORE_MAX - 1;
    } else {
      hIndex -= 1;
    }

    if((window.operationHistories[this.operationHistoryIndex()] !== null) && (window.operationHistories[this.operationHistoryIndex()][hIndex] !== null)) {
      const obj = window.operationHistories[this.operationHistoryIndex()][hIndex];
      // 全描画を消去
      WorktableCommon.removeAllItemAndEventOnThisPage(() => {
        const instancePageValue = obj[OperationHistory.KEYS.INSTANCE];
        const eventPageValue = obj[OperationHistory.KEYS.EVENT];
        if(instancePageValue !== null) {
          PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue);
        }
        if(eventPageValue !== null) {
          PageValue.setEventPageValueByPageRootHash(eventPageValue);
        }
        window.operationHistoryIndexes[this.operationHistoryIndex()] = hIndex;
        // キャッシュ保存 & 描画 & タイムライン更新
        PageValue.adjustInstanceAndEventOnPage();
        window.lStorage.saveAllPageValues();
        WorktableCommon.createAllInstanceAndDrawFromInstancePageValue();
        return Timeline.refreshAllTimeline();
      });
      return true;
    } else {
      return false;
    }
  };

  // 操作履歴を取り出してIndexを進める(redo処理)
  // @return [Boolean] 処理したか
  _popRedo = function() {
    if((window.operationHistoryIndexes[this.operationHistoryIndex()] === null)) {
      return false;
    }

    const hIndex = (window.operationHistoryIndexes[this.operationHistoryIndex()] + 1) % this.OPERATION_STORE_MAX;
    if((window.operationHistories[this.operationHistoryIndex()] !== null) && (window.operationHistories[this.operationHistoryIndex()][hIndex] !== null)) {
      const obj = window.operationHistories[this.operationHistoryIndex()][hIndex];
      // 全描画を消去
      WorktableCommon.removeAllItemAndEventOnThisPage(() => {
        const instancePageValue = obj[OperationHistory.KEYS.INSTANCE];
        const eventPageValue = obj[OperationHistory.KEYS.EVENT];
        if(instancePageValue !== null) {
          PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue);
        }
        if(eventPageValue !== null) {
          PageValue.setEventPageValueByPageRootHash(eventPageValue);
        }
        window.operationHistoryIndexes[this.operationHistoryIndex()] = hIndex;

        // キャッシュ保存 & 描画 & タイムライン更新
        PageValue.adjustInstanceAndEventOnPage();
        window.lStorage.saveAllPageValues();
        WorktableCommon.createAllInstanceAndDrawFromInstancePageValue();
        return Timeline.refreshAllTimeline();
      });
      return true;
    } else {
      return false;
    }
  };

  static operationHistoryIndex() {
    const pageNum = PageValue.getPageNum();
    const forkNum = PageValue.getForkNum();
    return pageNum + '-' + forkNum;
  }

  // 操作履歴を追加
  // @param [Boolean] isInit 初期化処理か
  static add(isInit) {
    if(isInit === null) {
      isInit = false;
    }
  }

  // undo処理
  static undo() {
  }

  // redo処理
  static redo() {
  }
};
