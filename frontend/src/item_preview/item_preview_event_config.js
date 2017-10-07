/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class ItemPreviewEventConfig extends EventConfig {
  // 入力値を適用する
  applyAction() {
    if((this[EventPageValueBase.PageValueKey.ACTIONTYPE] == null)) {
      if(window.debug) {
        console.log('ItemPreviewEventConfig validation error');
      }
      return false;
    }

    // 入力値を保存
    if((this[EventPageValueBase.PageValueKey.DIST_ID] == null)) {
      this[EventPageValueBase.PageValueKey.DIST_ID] = Common.generateId();
    }

    this[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF] = {
      x: parseInt($('.item_position_diff_x:first', this.emt).val()),
      y: parseInt($('.item_position_diff_y:first', this.emt).val()),
      w: parseInt($('.item_diff_width:first', this.emt).val()),
      h: parseInt($('.item_diff_height:first', this.emt).val())
    };

    let checked = $('.show_will_chapter:first', this.emt).is(':checked');
    this[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER] = (checked != null) && checked;
    this[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER_DURATION] = $('.show_will_chapter_duration:first', this.emt).val();
    checked = $('.hide_did_chapter:first', this.emt).is(':checked');
    this[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER] = (checked != null) && checked;
    this[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER_DURATION] = $('.hide_did_chapter_duration:first', this.emt).val();

    this[EventPageValueBase.PageValueKey.FINISH_PAGE] = $('.finish_page', this.emt).is(":checked");
    this[EventPageValueBase.PageValueKey.JUMPPAGE_NUM] = $('.finish_page_select', this.emt).val();
    this[EventPageValueBase.PageValueKey.DO_FOCUS] = $('.do_focus', this.emt).prop('checked');
    this[EventPageValueBase.PageValueKey.IS_SYNC] = false;
    const parallel = $(".parallel_div .parallel", this.emt);
    if(parallel != null) {
      this[EventPageValueBase.PageValueKey.IS_SYNC] = parallel.is(":checked");
    }
    const handlerDiv = $(".handler_div", this.emt);
    if(this[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.SCROLL) {
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = handlerDiv.find('.scroll_point_start:first').val();
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = handlerDiv.find('.scroll_point_end:first').val();

      const topEmt = handlerDiv.find('.scroll_enabled_top:first');
      const bottomEmt = handlerDiv.find('.scroll_enabled_bottom:first');
      const leftEmt = handlerDiv.find('.scroll_enabled_left:first');
      const rightEmt = handlerDiv.find('.scroll_enabled_right:first');
      this[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS] = {
        top: topEmt.find('.scroll_enabled:first').is(":checked"),
        bottom: bottomEmt.find('.scroll_enabled:first').is(":checked"),
        left: leftEmt.find('.scroll_enabled:first').is(":checked"),
        right: rightEmt.find('.scroll_enabled:first').is(":checked")
      };
      this[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS] = {
        top: topEmt.find('.scroll_forward:first').is(":checked"),
        bottom: bottomEmt.find('.scroll_forward:first').is(":checked"),
        left: leftEmt.find('.scroll_forward:first').is(":checked"),
        right: rightEmt.find('.scroll_forward:first').is(":checked")
      };

    } else if(this[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.CLICK) {
      this[EventPageValueBase.PageValueKey.EVENT_DURATION] = handlerDiv.find('.click_duration:first').val();

      this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = 0;
      checked = handlerDiv.find('.enable_fork:first').is(':checked');
      if((checked != null) && checked) {
        const prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '');
        this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''));
      }
    }

    const errorMes = EventPageValueBase.writeToPageValue(this);
    if((errorMes != null) && (errorMes.length > 0)) {
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