import Common from '../../base/common';
import EventPageValueBase from '../event_page_value/base/base';
import EventConfig from '../sidebar_config/event_config';
import ItemPreviewCommon from '../item_preview/item_preview_common';

export default class ItemPreviewEventConfig extends EventConfig {
  // 入力値を適用する
  applyAction() {
    if((this['actionType'] === null)) {
      if(window.debug) {
        console.log('ItemPreviewEventConfig validation error');
      }
      return false;
    }

    // 入力値を保存
    if((this['distId'] === null)) {
      this['distId'] = Common.generateId();
    }

    this['itemSizeDiff'] = {
      x: parseInt($('.item_position_diff_x:first', this.emt).val()),
      y: parseInt($('.item_position_diff_y:first', this.emt).val()),
      w: parseInt($('.item_diff_width:first', this.emt).val()),
      h: parseInt($('.item_diff_height:first', this.emt).val())
    };

    let checked = $('.show_will_chapter:first', this.emt).is(':checked');
    this['showWillChapter'] = (checked !== null) && checked;
    this['showWillChapterDuration'] = $('.show_will_chapter_duration:first', this.emt).val();
    checked = $('.hide_did_chapter:first', this.emt).is(':checked');
    this['hideDidChapter'] = (checked !== null) && checked;
    this['hideDidChapterDuration'] = $('.hide_did_chapter_duration:first', this.emt).val();

    this['finishPage'] = $('.finish_page', this.emt).is(":checked");
    this['jumppageNum'] = $('.finish_page_select', this.emt).val();
    this['doFocus'] = $('.do_focus', this.emt).prop('checked');
    this['isSync'] = false;
    const parallel = $(".parallel_div .parallel", this.emt);
    if(parallel !== null) {
      this['isSync'] = parallel.is(":checked");
    }
    const handlerDiv = $(".handler_div", this.emt);
    if(this['actionType'] === constant.ActionType.SCROLL) {
      this['scrollPointStart'] = handlerDiv.find('.scroll_point_start:first').val();
      this['scrollPointEnd'] = handlerDiv.find('.scroll_point_end:first').val();

      const topEmt = handlerDiv.find('.scroll_enabled_top:first');
      const bottomEmt = handlerDiv.find('.scroll_enabled_bottom:first');
      const leftEmt = handlerDiv.find('.scroll_enabled_left:first');
      const rightEmt = handlerDiv.find('.scroll_enabled_right:first');
      this['scrollEnabledDirections'] = {
        top: topEmt.find('.scroll_enabled:first').is(":checked"),
        bottom: bottomEmt.find('.scroll_enabled:first').is(":checked"),
        left: leftEmt.find('.scroll_enabled:first').is(":checked"),
        right: rightEmt.find('.scroll_enabled:first').is(":checked")
      };
      this['scrollForwardDirections'] = {
        top: topEmt.find('.scroll_forward:first').is(":checked"),
        bottom: bottomEmt.find('.scroll_forward:first').is(":checked"),
        left: leftEmt.find('.scroll_forward:first').is(":checked"),
        right: rightEmt.find('.scroll_forward:first').is(":checked")
      };

    } else if(this['actionType'] === constant.ActionType.CLICK) {
      this['eventDuration'] = handlerDiv.find('.click_duration:first').val();

      this['changeForknum'] = 0;
      checked = handlerDiv.find('.enable_fork:first').is(':checked');
      if((checked !== null) && checked) {
        const prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '');
        this['changeForknum'] = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''));
      }
    }

    const errorMes = EventPageValueBase.writeToPageValue(this);
    if((errorMes !== null) && (errorMes.length > 0)) {
      // エラー発生時
      this.showError(errorMes);
      return;
    }

    // キャッシュに保存
    window.lStorage.saveAllPageValues();
    // Run開始
    ItemPreviewCommon.switchRun();
    // サイドメニューのスクロールをTopに
    return window.sidebarWrapper.scrollTop(0);
  }
}

window.EventConfig = ItemPreviewEventConfig;