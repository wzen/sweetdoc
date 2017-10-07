/*
 * decaffeinate suggestions:
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

// チャプターガイド基底
class GuideBase {
  static initClass() {
    // ガイドのZindex
    this.GUIDE_ZINDEX = 199999999;
    // 表示用タイマー
    this.timer = null;
    // アイドル時間
    this.IDLE_TIMER = 1500;
    // 1.5秒
  }

  // ガイド表示
  // @abstract
  static showGuide() {
  }

  // ガイド非表示
  // @abstract
  static hideGuide() {
  }
}

GuideBase.initClass();
