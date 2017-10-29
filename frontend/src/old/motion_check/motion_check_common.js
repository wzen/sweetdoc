import Common from '../../base/common';
import Navbar from '../navbar/navbar';
import PageValue from '../../base/page_value';
import ServerStorage from '../worktable/common/server_storage';

export default class MotionCheckCommon {
  // 新タブで閲覧を実行する
  static run(newWindow) {
    // イベント存在チェック
    //h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
//      if h? && Object.keys(h).length > 0
    // Runのキャッシュを削除
    if(newWindow === null) {
      newWindow = false;
    }
    window.lStorage.clearRun();
    let target = '';
    if(newWindow) {
      // 実行確認ページを新規ウィンドウで表示
      const size = Common.getScreenSize();
      const navbarHeight = $(`#${Navbar.NAVBAR_ROOT}`).outerHeight(true);
      const left = Number((window.screen.width - size.width) / 2);
      const top = Number((window.screen.height - (size.height + navbarHeight)) / 2);
      target = "_runwindow";
      window.open("about:blank", target, `top=${top},left=${left},width=${size.width},height=${size.height + navbarHeight},menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no`);
      document.run_form.action = '/motion_check/new_window';
    } else {
      // 実行確認ページを新規タブで表示
      target = "_runtab";
      if(window.name === target) {
        target = "_runtab2";
      }
      window.open("about:blank", target);
      document.run_form.action = '/motion_check';
    }
    document.run_form.target = target;

    if(window.isWorkTable && !Project.isSampleProject()) {
      // データ保存してから実行
      return ServerStorage.save(function(data) {
        if(data.resultSuccess) {
          PageValue.setGeneralPageValue(PageValue.Key.RUNNING_USER_PAGEVALUE_ID, data.updated_user_pagevalue_id);
          return document.run_form.submit();
        } else {
          return console.log('ServerStorage save error');
        }
      });
    } else {
      return document.run_form.submit();
    }
  }
}

//      else
//        # イベントが存在しない場合は表示しない
//        Message.showWarn('No event')
