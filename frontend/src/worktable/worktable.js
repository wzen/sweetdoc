import Common from '../base/common';
import CommonVar from '../base/common_var';
import Navbar from '../navbar/navbar';
import PageValue from '../base/page_value';
import Project from '../base/project';
import Timeline from './event/timeline';
import OperationHistory from './common/history';
import WorktableCommon from './common/worktable_common';

$(() =>
  $('.worktable.index').ready(function() {
    window.isItemPreview = false;
    window.initDone = false;

    // ブラウザ対応チェック
    if(!Common.checkBlowserEnvironment()) {
      Common.showModalView(constant.ModalViewType.ENVIRONMENT_NOT_SUPPORT, false);
      return;
    }

    $.ajaxSetup({
        beforeSend(xhr) {
          return xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
      }
    );

    // キャッシュチェック
    const loadWorktableFromCache = WorktableCommon.checkLoadWorktableFromCache();
    if(loadWorktableFromCache) {
      // キャッシュが存在する場合PageValueに読み込み
      window.lStorage.loadAllPageValues();
    }
    // 変数初期化
    CommonVar.initVarWhenLoadedView();
    CommonVar.initCommonVar();
    // ナビバーイベント
    Navbar.initWorktableNavbar();
    if(loadWorktableFromCache) {
      // メッセージ表示
      Common.showModalFlashMessage('Loading cache');
      // キャッシュが存在する場合
      // Mainコンテナ作成
      Common.createdMainContainerIfNeeded(PageValue.getPageNum());
      // コンテナ初期化
      WorktableCommon.initMainContainer();
      // リサイズイベント
      Common.initResize(WorktableCommon.resizeEvent);
      PageValue.adjustInstanceAndEventOnPage();
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
        // 共通イベントのインスタンス作成
        WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded();
        // スクロール位置更新
        WorktableCommon.initScrollContentsPosition();
        // 履歴に画面初期時を状態を保存
        OperationHistory.add(true);
        // ナビバーをプロジェクト作成後状態に
        Navbar.switchWorktableNavbarWhenProjectCreated(true);
        // モーダルを削除
        Common.hideModalView();
        // 初期化終了
        return window.initDone = true;
      });
      // タイムライン更新
      return Timeline.refreshAllTimeline();
    } else {
      window.lStorage.clearWorktable();
      // タイムライン更新
      Timeline.refreshAllTimeline();
      // 履歴に画面初期時を状態を保存
      OperationHistory.add(true);
      // プロジェクトモーダル表示
      Common.showModalView(constant.ModalViewType.INIT_PROJECT, true, Project.initProjectModal);
      // モーダル用にリサイズイベントを設定
      return Common.initResize();
    }
  })
);
