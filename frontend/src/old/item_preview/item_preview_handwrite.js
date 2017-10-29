import Common from '../base/common';
import Handwrite from '../worktable/handwrite/handwrite';
import Sidebar from '../sidebar_config/sidebar_ui'
import ItemPreviewEventConfig from './item_preview_event_config';
import WorktableCommon from '../worktable/common/worktable_common';

export default class ItemPreviewHandwrite extends Handwrite {
  // マウスアップ時の描画イベント
  static mouseUpDrawing() {
    if(window.handwritingItem !== null) {
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

    WorktableCommon.changeMode(constant.Mode.EDIT);
  }
}
