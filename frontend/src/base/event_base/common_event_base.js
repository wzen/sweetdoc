import EventBase from './event_base';
export default class CommonEventBase extends EventBase {

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
    