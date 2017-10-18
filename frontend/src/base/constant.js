window.constant = gon.const;
window.serverenv = gon.serverenv;
window.locale = gon.locale;
window.userLogined = gon.user_logined;
window.isMobileAccess = gon.is_mobile_access;
window.isIosAccess = gon.is_ios_access;
window.utoken = gon.u_token;
if (window.isWorkTable === undefined) {
  window.isWorkTable = false;
}

// アプリ共通定数
const Constant = {
  ITEM_PREVIEW_CLASS_DIST_TOKEN: 'dummy',
  CANVAS_ITEM_COORDINATE_VAR_SURFIX: 'Coord',
  EventBase: {
    PREVIEW_STEP: 3
  },
  Zindex: {
    GRID: 5
  },
  ModalView: {
    HEIGHT_RATE: 0.7
  },
  Paging: {
    NAV_MENU_PAGE_CLASS: 'paging-@pagenum',
    NAV_MENU_FORK_CLASS: 'fork-@forknum',
    NAV_MENU_ADDPAGE_CLASS: 'paging-new',
    NAV_MENU_DELETEPAGE_CLASS: 'paging-delete',
    NAV_MENU_ADDFORK_CLASS: 'fork-new',
    PRELOAD_PAGEVALUE_NUM: 0
  }
};