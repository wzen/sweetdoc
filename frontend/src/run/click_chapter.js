/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

// クリックチャプター
class ClickChapter extends Chapter {

  // コンストラクタ
  // @param [Array] list イベント情報
  constructor(list) {
    super(list);
    this.changeForkNum = null;
  }

  // チャプターの前処理
  willChapter(callback = null) {
    return super.willChapter(() => {
      this.disableScrollHandleViewEvent();
      // イベント設定
      this.eventObjList.forEach(event => {
        return event.clickTargetElement().off('click').on('click', e => {
          return this.clickEvent(e);
        });
      });
      this.showGuide();
      if(callback !== null) {
        return callback();
      }
    });
  }

  // チャプターの後処理
  didChapter(callback = null) {
    return super.didChapter(() => {
      this.enableScrollHandleViewEvent();
      this.hideGuide();
      if(callback !== null) {
        return callback();
      }
    });
  }

  // クリックイベント
  // @param [Object] e クリックオブジェクト
  clickEvent(e) {
    this.hideGuide();
    if(window.disabledEventHandler) {
      return;
    }
    return this.eventObjList.forEach(event => {
      if(event.clickTargetElement().get(0) === $(e.currentTarget).get(0)) {
        return event.clickEvent(e, () => {
          // クリックしたイベントのフォーク番号を保存
          this.changeForkNum = event.getChangeForkNum();
          if(window.eventAction !== null) {
            // 次のチャプターへ
            return window.eventAction.thisPage().nextChapter();
          }
        });
      }
    });
  }

  // ガイド表示
  showGuide() {
    if(!super.showGuide()) {
      return false;
    }
    this.hideGuide();

    let idleTime = ClickGuide.IDLE_TIMER;
    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は即表示
      idleTime = 0;
    }

    return this.constructor.guideTimer = setTimeout(() => {
        // ガイド表示
        const items = [];
        this.eventObjList.forEach(function(event) {
          if(event instanceof ItemBase) {
            return items.push(event);
          }
        });
        return ClickGuide.showGuide(items);
      }
      , idleTime);
  }

  // ガイド非表示
  hideGuide() {
    if(this.constructor.guideTimer !== null) {
      clearTimeout(this.constructor.guideTimer);
      this.constructor.guideTimer = null;
    }
    ScrollGuide.hideGuide();
    return ClickGuide.hideGuide();
  }
}