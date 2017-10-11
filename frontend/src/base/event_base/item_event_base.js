/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class ItemEventBase extends EventBase {

  // イベントの初期化
  // @param [Object] event 設定イベント
  initEvent(event) {
    super.initEvent(event);
    return this.initEventPrepare();
  }

  // 描画してアイテムを作成
  // 表示非表示はwillChapterで切り替え
  // 何故必要か調査中
  //@refresh(false)

  // initEvent前の処理
  // @abstract
  initEventPrepare() {
  }

  // メソッド実行
  execMethod(opt, callback = null) {
    return super.execMethod(opt, () => {
      const methodName = this.getEventMethodName();
      if(methodName !== EventPageValueBase.NO_METHOD) {
        (this.constructor.prototype[methodName]).call(this, opt);
        if(callback != null) {
          return callback();
        }
      } else {
        // アイテム状態の表示反映
        this.updatePositionAndItemSize(this.itemSize, false, false);
        if(callback != null) {
          return callback();
        }
      }
    });
  }
}