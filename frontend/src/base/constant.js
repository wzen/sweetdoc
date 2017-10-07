/*
 * decaffeinate suggestions:
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const constant = gon.const;
const {serverenv} = gon;
const {locale} = gon;
const userLogined = gon.user_logined;
const isMobileAccess = gon.is_mobile_access;
const isIosAccess = gon.is_ios_access;
const utoken = gon.u_token;

// アプリ共通定数
class Constant {
  static initClass() {
    this.ITEM_PREVIEW_CLASS_DIST_TOKEN = 'dummy';
    this.CANVAS_ITEM_COORDINATE_VAR_SURFIX = 'Coord';

    let Cls = (this.EventBase = class EventBase {
      static initClass() {
        this.PREVIEW_STEP = 3;
      }
    });
    Cls.initClass();

    // ZIndex
    Cls = (this.Zindex = class Zindex {
      static initClass() {
        // @property GRID グリッド線
        this.GRID = 5;
      }
    });
    Cls.initClass();

    Cls = (this.ModalView = class ModalView {
      static initClass() {
        this.HEIGHT_RATE = 0.7;
      }
    });
    Cls.initClass();

    // ページング
    (function() {
      Cls = (this.Paging = class Paging {
        static initClass() {
          this.NAV_MENU_PAGE_CLASS = 'paging-@pagenum';
          this.NAV_MENU_FORK_CLASS = 'fork-@forknum';
          this.NAV_MENU_ADDPAGE_CLASS = 'paging-new';
          this.NAV_MENU_DELETEPAGE_CLASS = 'paging-delete';
          this.NAV_MENU_ADDFORK_CLASS = 'fork-new';
          this.PRELOAD_PAGEVALUE_NUM = 0;
        }
      });
      Cls.initClass();
      return Cls;
    })();
  }
}

Constant.initClass();
