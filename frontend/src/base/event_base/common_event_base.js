/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class CommonEventBase extends EventBase {

  // イベントの初期化
  // @param [Object] event 設定イベント
  initEvent(event) {
    return super.initEvent(event);
  }

  // メソッド実行
  execMethod(opt, callback = null) {
    return super.execMethod(opt, () => {
      (this.constructor.prototype[this.getEventMethodName()]).call(this, opt);
      if(callback !== null) {
        return callback();
      }
    });
  }
}
    