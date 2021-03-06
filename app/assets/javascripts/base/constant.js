// Generated by CoffeeScript 1.9.2
var Constant, constant, isIosAccess, isMobileAccess, locale, serverenv, userLogined, utoken;

constant = gon["const"];

serverenv = gon.serverenv;

locale = gon.locale;

userLogined = gon.user_logined;

isMobileAccess = gon.is_mobile_access;

isIosAccess = gon.is_ios_access;

utoken = gon.u_token;

Constant = (function() {
  function Constant() {}

  Constant.ITEM_PREVIEW_CLASS_DIST_TOKEN = 'dummy';

  Constant.CANVAS_ITEM_COORDINATE_VAR_SURFIX = 'Coord';

  Constant.EventBase = (function() {
    function EventBase() {}

    EventBase.PREVIEW_STEP = 3;

    return EventBase;

  })();

  Constant.Zindex = (function() {
    function Zindex() {}

    Zindex.GRID = 5;

    return Zindex;

  })();

  Constant.ModalView = (function() {
    function ModalView() {}

    ModalView.HEIGHT_RATE = 0.7;

    return ModalView;

  })();

  Constant.Paging = (function() {
    function Paging() {}

    Paging.NAV_MENU_PAGE_CLASS = 'paging-@pagenum';

    Paging.NAV_MENU_FORK_CLASS = 'fork-@forknum';

    Paging.NAV_MENU_ADDPAGE_CLASS = 'paging-new';

    Paging.NAV_MENU_DELETEPAGE_CLASS = 'paging-delete';

    Paging.NAV_MENU_ADDFORK_CLASS = 'fork-new';

    Paging.PRELOAD_PAGEVALUE_NUM = 0;

    return Paging;

  })();

  return Constant;

})();

//# sourceMappingURL=constant.js.map
