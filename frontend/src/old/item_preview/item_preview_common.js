import Common from '../../base/common';
import CommonVar from '../../base/common_var';
import FloatView from '../../base/float_view';
import Navbar from '../navbar/navbar';
import ItemPreviewHandwrite from './item_preview_handwrite';

let constant = undefined;
export default class ItemPreviewCommon {
  static initClass() {
    constant = gon.const;
    this.MAIN_TEMP_WORKTABLE_CLASS = constant.ElementAttribute.MAIN_TEMP_WORKTABLE_CLASS;
    this.MAIN_TEMP_RUN_CLASS = constant.ElementAttribute.MAIN_TEMP_RUN_CLASS;
  }

  // Mainコンテナを作成
  // @return [Boolean] ページを作成したか
  static createdMainContainerIfNeeded() {
    const root = $(`#${constant.Paging.ROOT_ID}`);
    let markClass = '';
    if(isWorkTable) {
      markClass = 'ws';
    } else {
      markClass = 'run';
    }
    const container = $(`.${markClass}`, root);
    const sectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', 1);
    const pageSection = $(`.${sectionClass}`, root);
    if((container === null) || (container.length === 0)) {
      // 現在のContainerを削除
      let temp;
      root.children('.section').remove();
      // Tempからコピー
      if(isWorkTable) {
        temp = $(`.${ItemPreviewCommon.MAIN_TEMP_WORKTABLE_CLASS}:first`).children(':first').clone(true);
      } else {
        temp = $(`.${ItemPreviewCommon.MAIN_TEMP_RUN_CLASS}:first`).children(':first').clone(true);
      }
      temp = $(temp).wrap(`<div class='${sectionClass} ${markClass} section'></div>`).parent();
      root.append(temp);
      return true;
    } else {
      return false;
    }
  }

  // Mainコンテナ初期化
  static initMainContainerAsWorktable(callback = null) {
    // 定数 & レイアウト & イベント系変数の初期化
    CommonVar.worktableCommonVar();
    Common.updateCanvasSize();
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT));
    // スクロールサイズ
    window.scrollInsideWrapper.width(window.scrollViewSize);
    window.scrollInsideWrapper.height(window.scrollViewSize);
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM + 1));
    // スクロールイベント設定
    window.scrollContents.off('scroll').on('scroll', function(e) {
      if((window.skipScrollEvent !== null) && window.skipScrollEvent) {
        window.skipScrollEvent = false;
        return;
      }
      if((window.skipScrollEventByAnimation !== null) && window.skipScrollEventByAnimation) {
        return;
      }
      e.preventDefault();
      e.stopPropagation();
      const top = window.scrollContents.scrollTop();
      const left = window.scrollContents.scrollLeft();
      FloatView.show(FloatView.scrollMessage(top, left), FloatView.Type.DISPLAY_POSITION);
      return Common.saveDisplayPosition(top, left, false, () => FloatView.hide());
    });
    // ドラッグ描画イベント
    ItemPreviewHandwrite.initHandwrite();
    // 環境設定
    this.applyEnvironmentFromPagevalue();
    // Mainビュー高さ設定
    WorktableCommon.updateMainViewSize();
    // ScrollHandler非表示
    $('.scroll_handle_wrapper').hide();

    if(callback !== null) {
      return callback();
    }
  }

  static applyEnvironmentFromPagevalue() {
    // スクロール位置設定
    return Common.initScrollContentsPosition();
  }

  static initMainContainerAsRun(callback = null) {
    CommonVar.runCommonVar();
    RunCommon.initView();
    RunCommon.initHandleScrollView();
    Common.applyEnvironmentFromPagevalue();
    // ProjectWrapperの幅、高さは親に合わせる
    $('#project_wrapper').removeAttr('style');
    // ScrollHandler表示
    $('.scroll_handle_wrapper').show();
    if(callback !== null) {
      return callback();
    }
  }

  // 初期化
  static initAfterLoadItem() {
    // 描画モード
    if(window.isCodingDebug) {
      window.selectItemMenu = window[constant.ITEM_CODING_TEMP_CLASS_NAME].CLASS_DIST_TOKEN;
    } else {
      const itemClassName = $(`.${constant.ITEM_GALLERY_ITEM_CLASSNAME}:first`).val();
      window.selectItemMenu = window[itemClassName].CLASS_DIST_TOKEN;
    }
    WorktableCommon.changeMode(constant.Mode.DRAW);
    this.initEvent();
    return Navbar.initItemPreviewNavbar();
  }

  // イベント設定
  static initEvent() {
    // ボタン
    $('#run_btn_wrapper .run_btn').off('click').on('click', e => {
      e.preventDefault();
      return this.switchRun();
    });
    return $('#stop_btn_wrapper .stop_btn').off('click').on('click', e => {
      e.preventDefault();
      return this.switchWorktable();
    });
  }

  // WS状態に変更
  static switchWorktable(callback = null) {
    if(!window.isWorkTable) {
      window.isWorkTable = true;
      window.initDone = false;
      RunCommon.shutdown();
      this.createdMainContainerIfNeeded();
      return this.initMainContainerAsWorktable(() => {
        return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(() => {
          window.initDone = true;
          // コンフィグのイベントを全て有効化
          $('#sidebar').find('.cover_touch_overlay').remove();
          WorktableCommon.changeMode(constant.Mode.EDIT);
          $('#run_btn_wrapper').show();
          $('#stop_btn_wrapper').hide();
          if(callback !== null) {
            return callback();
          }
        });
      });
    }
  }

  // Run状態に変更
  static switchRun(callback = null) {
    if(window.isWorkTable) {
      window.isWorkTable = false;
      window.initDone = false;
      // プロジェクトサイズ設定
      Project.initProjectValue('ItemPreviewRun');
      this.createdMainContainerIfNeeded();
      return this.initMainContainerAsRun(() => {
        window.eventAction = null;
        window.runPage = true;
        // コンフィグのイベントを全て無効化
        this.coverOverlayOnConfig();
        // イベント初期化
        RunCommon.initEventAction();
        // 初期化終了
        window.initDone = true;
        $('#run_btn_wrapper').hide();
        $('#stop_btn_wrapper').show();
        if(callback !== null) {
          return callback();
        }
      });
    }
  }

  static coverOverlayOnConfig() {
    const tabContent = $('#myTabContent');
    const nav = $('#tab-config ul.nav');
    const top = -(nav.height());
    const style = `top:${top}px;left:0;width:${tabContent.width()}px;height:${tabContent.height() + nav.height()}px;`;
    tabContent.append(`<div class='cover_touch_overlay' style='${style}'></div>`);
    return $('.cover_touch_overlay').off('click').on('click', function(e) {
      e.preventDefault();
    });
  }

  static showUploadItemConfirm() {
    //target = '_uploaditem'
    //window.open("about:blank", target)
    //document.upload_item_form.target = target
    return document.upload_item_form.submit();
  }

  static showAddItemConfirm() {
  }
};
ItemPreviewCommon.initClass();
