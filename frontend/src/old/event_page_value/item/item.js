import Common from '../../../base/common';
import PageValue from '../../../base/page_value';
import EventPageValueBase from '../base/base';

// EventPageValue アイテム
export default class EPVItem extends EventPageValueBase {
  static initClass() {
    this.itemSize = 'item_size';
  }

  // アイテムのデフォルトイベントをPageValueに書き込み
  // @param [Object] item アイテムオブジェクト
  // @return [String] エラーメッセージ
  static writeDefaultToPageValue(item, teNum, distId) {
    if(window.isItemPreview) {
      // アイテムプレビュー時は暫定の値を入れる
      teNum = 1;
      distId = Common.generateId();
    }

    const errorMes = "";
    const writeValue = {};
    writeValue[this.PageValueKey.DIST_ID] = distId;
    writeValue['id'] = item.id;
    writeValue[this.PageValueKey.CLASS_DIST_TOKEN] = item.constructor.CLASS_DIST_TOKEN;
    writeValue[this.PageValueKey.ITEM_SIZE_DIFF] = {x: 0, y: 0, w: 0, h: 0};
    writeValue[this.PageValueKey.DO_FOCUS] = true;
    writeValue[this.PageValueKey.IS_COMMON_EVENT] = false;
    writeValue[this.PageValueKey.FINISH_PAGE] = false;
    writeValue[this.PageValueKey.METHODNAME] = item.constructor.defaultMethodName();
    const actionType = item.constructor.defaultActionType();
    writeValue['actionType'] = actionType;
    let start = this.getAllScrollLength();
    // FIXME: スクロールの長さは要調整
    const adjust = 4.0;
    let end = start + (item.registCoord.length * adjust);
    if(start > end) {
      start = null;
      end = null;
    }
    writeValue['scrollPointStart'] = start;
    writeValue['scrollPointEnd'] = end;
    writeValue[this.PageValueKey.IS_SYNC] = false;
    writeValue[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS] = item.constructor.defaultScrollEnabledDirection();
    writeValue[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS] = item.constructor.defaultScrollForwardDirection();
    writeValue[this.PageValueKey.EVENT_DURATION] = item.constructor.defaultClickDuration();
    writeValue[this.PageValueKey.SPECIFIC_METHOD_VALUES] = item.constructor.defaultSpecificMethodValue();
    writeValue[this.PageValueKey.MODIFIABLE_VARS] = item.constructor.defaultModifiableVars();

    if(errorMes.length === 0) {
      // イベントとイベント数をPageValueに書き込み
      PageValue.setEventPageValue(PageValue.Key.eventNumber(teNum), writeValue);
      PageValue.setEventPageValue(PageValue.Key.eventCount(), teNum);

      // Storageに保存
      window.lStorage.saveAllPageValues();
    }

    return errorMes;
  }
}

EPVItem.initClass();
