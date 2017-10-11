/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class FloatView {
  static initClass() {

    this.showTimer = null;

    const Cls = (this.Type = class Type {
      static initClass() {
        this.PREVIEW = 'preview';
        this.DISPLAY_POSITION = 'display_position';
        this.INFO = 'info';
        this.WARN = 'warn';
        this.ERROR = 'error';
        this.APPLY = 'apply';
        this.POINTING_CLICK = 'pointing_click';
        this.POINTING_DRAG = 'pointing_drag';
        this.SCALE = 'scale';
        this.REWIND_CHAPTER = 'rewind_chapter';
        this.REWIND_ALL_CHAPTER = 'rewind_all_chapter';
        this.NEXT_PAGE = 'next_page';
        this.FINISH = 'finish';
      }
    });
    Cls.initClass();
  }

  static show(message, type, showSeconds) {
    if(showSeconds === null) {
      showSeconds = -1;
    }
    if(window.isWorkTable && !window.initDone) {
      // 初期化が終了していない場合は無視
      return;
    }

    const main = $('#main');
    let root = $(`.float_view.${type}:first`, main);
    if(root.length === 0) {
      $(".float_view", main).remove();
      $('.float_view_temp', main).clone(true).attr('class', 'float_view').appendTo(main);
      root = $('.float_view:first', main);
      root.removeClass((index, className) => className !== 'float_view').addClass(type);
      $('.message', root).removeClass((index, className) => className !== 'message').addClass(type);
      root.fadeIn('fast');
    } else {
      root.show();
    }
    $('.message', root).html(message);

    if(showSeconds >= 0) {
      // 非表示タイマーセット
      if(this.showTimer !== null) {
        clearTimeout(this.showTimer);
        this.showTimer = null;
      }
      return this.showTimer = setTimeout(() => {
          this.hide();
          clearTimeout(this.showTimer);
          return this.showTimer = null;
        }
        , showSeconds * 1000);
    }
  }

  static hide() {
    return $(".float_view:not('.fixed')").fadeOut('fast');
  }

  static showWithCloseButton(message, type, closeFunc = null, withDisableOperation) {
    if(withDisableOperation === null) {
      withDisableOperation = false;
    }
    if(window.isWorkTable && !window.initDone) {
      return;
    }

    const main = $('#main');
    let root = $(`.float_view.fixed.${type}:first`, main);
    if(withDisableOperation) {
      // オーバーレイを被せる
      if($('#modal-overlay').length === 0) {
        $("body").append('<div id="modal-overlay"></div>');
      }
      $("#modal-overlay").off('click').on('click', e => {
        e.preventDefault();
        e.stopPropagation();
        return false;
      }).show();
    }

    if(root.length > 0) {
      // 既に表示されている場合はshow
      root.show();
      return;
    }

    $(".float_view", main).remove();
    $('.float_view_fixed_temp', main).clone(true).attr('class', 'float_view fixed').appendTo(main);
    root = $('.float_view.fixed:first', main);
    root.find('.close_button').off('click').on('click', e => {
      e.preventDefault();
      e.stopPropagation();
      if(closeFunc !== null) {
        closeFunc();
      }
      return FloatView.hideWithCloseButtonView();
    });
    root.removeClass((index, className) => (className !== 'float_view') && (className !== 'fixed')).addClass(type);
    $('.message', root).removeClass((index, className) => className !== 'message').addClass(type);
    root.show();

    return $('.message', root).html(message);
  }

  static hideWithCloseButtonView() {
    $(".float_view.fixed").fadeOut('fast');
    $('#modal-overlay').remove();
    // コントローラも消去
    return this.hidePointingController();
  }

  static showPointingController(pointintObj) {
    if(window.isWorkTable && !window.initDone) {
      return;
    }
    const main = $('#main');
    let root = $(".float_view.fixed:visible", main);
    if(root.length === 0) {
      // Fixedビューが表示されていない場合は無視
      return;
    }

    root = $(".float_view.pointing_controller:first", main);
    if(root.length === 0) {
      // ビュー作成
      $('.float_view_pointing_controller_temp', main).clone(true).attr('class', 'float_view pointing_controller').appendTo(main);
      root = $('.float_view.pointing_controller:first', main);
    }
    // イベント設定
    root.find('.clear_button').off('click').on('click', e => {
      e.preventDefault();
      e.stopPropagation();
      // 描画を削除
      pointintObj.clearDraw();
      // コントローラー非表示
      return FloatView.hidePointingController();
    });
    root.find('.apply_button').off('click').on('click', e => {
      e.preventDefault();
      e.stopPropagation();
      // 描画を適用
      pointintObj.applyDraw();
      // 画面上のポイントアイテムを削除
      pointintObj.getJQueryElement().remove();
      // ビュー非表示
      return FloatView.hideWithCloseButtonView();
    });
    return root.show();
  }

  static hidePointingController() {
    return $(".float_view.pointing_controller").fadeOut('fast');
  }

  static scrollMessage(top, left) {
    if(window.isWorkTable && !window.initDone) {
      return '';
    }
    return `X: ${left}  Y:${top}`;
  }

  static displayPositionMessage() {
    return 'Preview';
  }
}

FloatView.initClass();
