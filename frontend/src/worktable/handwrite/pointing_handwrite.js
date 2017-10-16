import Handwrite from './handwrite';

export default class PointingHandwrite extends Handwrite {

  // 手書きイベント初期化
  static initHandwrite(targetClass) {
    this.targetClass = targetClass;
    return super.initHandwrite();
  }

  // マウスダウン時の描画イベント
  // @param [Array] loc Canvas座標
  static mouseDownDrawing(loc) {
    if(window.eventPointingMode === constant.EventInputPointingMode.DRAW) {
      // イベント入力描画
      window.handwritingItem = new (this.targetClass)(loc);
      return window.handwritingItem.mouseDownDrawing();
    }
  }

  static isDrawMode() {
    return window.eventPointingMode === constant.EventInputPointingMode.DRAW;
  }
}
