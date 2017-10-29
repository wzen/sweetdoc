import PageValue from '../../base/page_value';
import CommonEventBase from '../../base/event_base/common_event_base';

// 共通イベント基底クラス
export default class CommonEvent {
  static initClass() {

    // インスタンスはページ毎持つ
    // TODO: サブクラスでオブジェクト宣言
    // @abstract
    this.instance = null;

    const Cls = (this.PrivateClass = class PrivateClass extends CommonEventBase {
      static initClass() {
        // @property [String] ID_PREFIX IDプレフィックス
        this.ID_PREFIX = "c";
        this.actionProperties = null;
      }

      constructor() {
        super();
        // @property [Int] id ID
        this.id = this.constructor.ID_PREFIX + this.constructor.EVENT_ID + Common.generateId();
        // @property [Int] eventId 共通イベントID
        this.eventId = this.constructor.EVENT_ID;
        // @property [ItemType] CLASS_DIST_TOKEN アイテム種別
        this.classDistToken = this.constructor.CLASS_DIST_TOKEN;
      }

      getJQueryElement() {
        return $('#common_event_click_overlay');
      }

      clickTargetElement() {
        return $('#common_event_click_overlay');
      }

      willChapter(callback = null) {
        if(this._event[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.CLICK) {
          // クリック用オーバーレイを追加
          const z_index = Common.plusPagingZindex(constant.Zindex.EVENTFLOAT);
          if($('#common_event_click_overlay').length === 0) {
            $('body').append(`<div id='common_event_click_overlay' style='z-index:${z_index}'></div>`);
          }
        }
        return super.willChapter(callback);
      }

      didChapter(callback = null) {
        if(this._event[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.CLICK) {
          // クリック用オーバーレイを削除
          $('#common_event_click_overlay').remove();
        }
        return super.didChapter(callback);
      }
    });
    Cls.initClass();

    // TODO: サブクラスで定義必須
    // @abstract
    this.CLASS_DIST_TOKEN = this.PrivateClass.CLASS_DIST_TOKEN;
  }

  constructor() {
    return this.constructor.getInstance();
  }

  static getInstance() {
    if((this.instance[PageValue.getPageNum()] === null)) {
      this.instance[PageValue.getPageNum()] = new this.PrivateClass();
    }
    return this.instance[PageValue.getPageNum()];
  }

  static hasInstanceCache(pn) {
    if(pn === null) {
      pn = PageValue.getPageNum();
    }
    return (this.instance[pn] !== null);
  }

  static deleteInstance(objId) {
    return (() => {
      const result = [];
      for(let k in this.instance) {
        const v = this.instance[k];
        if(v.id === objId) {
          result.push(delete this.instance[k]);
        } else {
          result.push(undefined);
        }
      }
      return result;
    })();
  }

  static deleteAllInstance() {
    for(let k in this.instance) {
      const v = this.instance[k];
      delete this.instance[k];
    }
    return this.instance = {};
  }

  static deleteInstanceOnPage(pageNum) {
    // 後ページのデータをずらす
    for(let p = pageNum, end = PageValue.getPageCount(), asc = pageNum <= end; asc ? p < end : p > end; asc ? p++ : p--) {
      this.instance[p] = this.instance[p + 1];
    }
    // 末尾ページのデータを削除
    return delete this.instance[PageValue.getPageCount()];
  }
}

CommonEvent.initClass();

