/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class ItemPreviewHandwrite extends Handwrite {
  // マウスアップ時の描画イベント
  static mouseUpDrawing() {
    if(window.handwritingItem != null) {
      // 表示アイテムは一つのみ
      if(window.scrollInside.find('.item').length === 0) {
        window.handwritingItem.restoreAllDrawingSurface();
        window.handwritingItem.endDraw(this.zindex, true, () => {
          window.handwritingItem.setupItemEvents();
          window.handwritingItem.saveObj(true);
          this.zindex += 1;
          // デザインコンフィグを初期化
          Sidebar.initItemEditConfig(window.handwritingItem);
          // イベントコンフィグを初期化
          ItemPreviewEventConfig.addEventConfigContents(window.handwritingItem.classDistToken);
          // EventConfigのDistIdは適当
          Sidebar.initEventConfig(Common.generateId());
          return window.handwritingItem = null;
        });
      }
    }

    return WorktableCommon.changeMode(constant.Mode.EDIT);
  }
}
