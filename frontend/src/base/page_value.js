import ServerStorage from '../worktable/common/server_storage';

if (gon.run_pagevalue !== null) {
  window.pageValue = gon.run_pagevalue;
} else {
  window.pageValue = {};
}

// PageValue
export default class PageValue {
  static initClass() {
    // 定数
    let constant = gon.const;
    // ページ内値保存キー
    const Cls = (this.Key = class Key {
      static initClass() {
        // @property [String] PAGE_VALUES_SEPERATOR ページ値のセパレータ
        this.PAGE_VALUES_SEPERATOR = constant.PageValueKey.PAGE_VALUES_SEPERATOR;
        // @property [String] G_ROOT 汎用情報ルート
        this.G_ROOT = constant.PageValueKey.G_ROOT;
        // @property [String] G_ROOT 汎用情報プレフィックス
        this.G_PREFIX = constant.PageValueKey.G_PREFIX;
        // @property [String] P_PREFIX ページ番号プレフィックス
        this.P_PREFIX = constant.PageValueKey.P_PREFIX;
        // @property [String] ST_ROOT 設定Root
        this.ST_ROOT = constant.PageValueKey.ST_ROOT;
        // @property [String] ST_PREFIX 設定プレフィックス
        this.ST_PREFIX = constant.PageValueKey.ST_PREFIX;
        // @property [String] PAGE_COUNT ページ総数
        this.PAGE_COUNT = constant.PageValueKey.PAGE_COUNT;
        // @property [String] PAGE_NUM 現在のページ番号
        this.PAGE_NUM = constant.PageValueKey.PAGE_NUM;
        // @property [String] FORK_NUM フォーク総数
        this.FORK_COUNT = constant.PageValueKey.FORK_COUNT;
        // @property [String] FORK_NUM 現在のフォーク番号
        this.FORK_NUM = constant.PageValueKey.FORK_NUM;
        // @property [String] IS_ROOT ページ値ルート
        this.IS_ROOT = constant.PageValueKey.IS_ROOT;
        // @property [String] PROJECT_NAME プロジェクトID
        this.PROJECT_ID = `${this.G_PREFIX}${this.PAGE_VALUES_SEPERATOR}${constant.Project.Key.PROJECT_ID}`;
        // @property [String] PROJECT_NAME プロジェクト名
        this.PROJECT_NAME = `${this.G_PREFIX}${this.PAGE_VALUES_SEPERATOR}${constant.Project.Key.TITLE}`;
        // @property [String] IS_SAMPLE_PROJECT サンプルプロジェクトか
        this.IS_SAMPLE_PROJECT = `${this.G_PREFIX}${this.PAGE_VALUES_SEPERATOR}${constant.Project.Key.IS_SAMPLE_PROJECT}`;
        // @property [String] SCREEN_SIZE プロジェクトサイズ
        this.SCREEN_SIZE = `${this.G_PREFIX}${this.PAGE_VALUES_SEPERATOR}${constant.Project.Key.SCREEN_SIZE}`;
        // @property [String] LAST_SAVE_TIME 最終保存時刻
        this.LAST_SAVE_TIME = `${this.G_PREFIX}${this.PAGE_VALUES_SEPERATOR}last_save_time`;
        // @property [String] LAST_SAVE_TIME 最終保存時刻
        this.RUNNING_USER_PAGEVALUE_ID = `${this.G_PREFIX}${this.PAGE_VALUES_SEPERATOR}${constant.Project.Key.USER_PAGEVALUE_ID}`;
        // @property [String] WORKTABLE_ITEM_HIDE_BY_SETTING Worktable設定によるアイテム非表示
        this.WORKTABLE_ITEM_HIDE_BY_SETTING = constant.PageValueKey.WORKTABLE_ITEM_HIDE_BY_SETTING;
        // @property [String] INSTANCE_PREFIX インスタンスプレフィックス
        this.INSTANCE_PREFIX = constant.PageValueKey.INSTANCE_PREFIX;
        // @property [String] INSTANCE_VALUE_ROOT インスタンスROOT
        this.INSTANCE_VALUE_ROOT = constant.PageValueKey.INSTANCE_VALUE_ROOT;
        // @property [String] ITEM_LOADED_PREFIX アイテム読み込み済みプレフィックス
        this.ITEM_LOADED_PREFIX = 'itemloaded';
        // @property [String] E_ROOT イベント値ルート
        this.E_ROOT = constant.PageValueKey.E_ROOT;
        // @property [String] E_SUB_ROOT イベントプレフィックス
        this.E_SUB_ROOT = constant.PageValueKey.E_SUB_ROOT;
        // @property [String] E_MASTER_ROOT イベントコンテンツルート
        this.E_MASTER_ROOT = constant.PageValueKey.E_MASTER_ROOT;
        // @property [String] E_FORK_ROOT イベントフォークルート
        this.E_FORK_ROOT = constant.PageValueKey.E_FORK_ROOT;
        // @property [String] E_NUM_PREFIX イベント番号プレフィックス
        this.E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX;
        // @property [String] EF_PREFIX イベントフォークプレフィックス
        this.EF_PREFIX = constant.PageValueKey.EF_PREFIX;
        // @property [String] IS_RUNWINDOW_RELOAD Runビューをリロードしたか
        this.IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD;
        // @property [String] EF_MASTER_FORKNUM Masterのフォーク番号
        this.EF_MASTER_FORKNUM = constant.PageValueKey.EF_MASTER_FORKNUM;
        // @property [String] UPDATED 更新フラグ
        this.UPDATED = 'updated';
        // @property [String] F_ROOT 履歴情報ルート
        this.F_ROOT = constant.PageValueKey.F_ROOT;
        // @property [String] F_PREFIX 履歴情報プレフィックス
        this.F_PREFIX = constant.PageValueKey.F_PREFIX;
        // @property [String] F_PREFIX 履歴情報イベント一意IDプレフィックス
        this.FED_PREFIX = constant.PageValueKey.FED_PREFIX;
      }

      // @property [return] 現在のページのページ番号ルート
      static pageRoot(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return this.P_PREFIX + pn;
      }

      // @property [return] インスタンスページプレフィックスを取得
      static instancePagePrefix(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return this.INSTANCE_PREFIX + this.PAGE_VALUES_SEPERATOR + this.pageRoot(pn);
      }

      // @property [return] インスタンス値Root
      static instanceObjRoot(objId) {
        return this.instancePagePrefix() + this.PAGE_VALUES_SEPERATOR + objId;
      }

      // @property [return] インスタンス値
      static instanceValue(objId) {
        return this.instanceObjRoot(objId) + this.PAGE_VALUES_SEPERATOR + this.INSTANCE_VALUE_ROOT;
      }

      // @property [return] インスタンスキャッシュ値
      static instanceValueCache(objId) {
        return this.instancePagePrefix() + this.PAGE_VALUES_SEPERATOR + 'cache' + this.PAGE_VALUES_SEPERATOR + objId + this.PAGE_VALUES_SEPERATOR + this.INSTANCE_VALUE_ROOT;
      }

      // @property [return] インスタンスデザインRoot
      static instanceDesignRoot(objId) {
        return this.instanceValue(objId) + this.PAGE_VALUES_SEPERATOR + 'designs';
      }

      // @property [return] インスタンスデザイン
      static instanceDesign(objId, designKey) {
        return this.instanceDesignRoot(objId) + this.PAGE_VALUES_SEPERATOR + designKey;
      }

      static itemLoaded(classDistToken) {
        return `${this.ITEM_LOADED_PREFIX}${this.PAGE_VALUES_SEPERATOR}${classDistToken}`;
      }

      // @property [return] イベントページルート
      static eventPageRoot(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.E_SUB_ROOT}${this.PAGE_VALUES_SEPERATOR}${this.pageRoot(pn)}`;
      }

      // @property [return] イベントページプレフィックス
      static eventPageMainRoot(fn, pn) {
        if (fn === null) {
          fn = PageValue.getForkNum();
        }
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        let root = '';
        if (fn > 0) {
          root = this.EF_PREFIX + fn;
        } else {
          root = this.E_MASTER_ROOT;
        }
        return `${this.eventPageRoot(pn)}${this.PAGE_VALUES_SEPERATOR}${root}`;
      }

      // @property [return] イベントページプレフィックス
      static eventNumber(num, fn, pn) {
        if (fn === null) {
          fn = PageValue.getForkNum();
        }
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.eventPageMainRoot(fn, pn)}${this.PAGE_VALUES_SEPERATOR}${this.E_NUM_PREFIX}${num}`;
      }

      // @property [return] イベント数
      static eventCount(fn, pn) {
        if (fn === null) {
          fn = PageValue.getForkNum();
        }
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.eventPageMainRoot(fn, pn)}${this.PAGE_VALUES_SEPERATOR}count`;
      }

      // @property [return] 設定値ページプレフィックスを取得
      static generalPagePrefix(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return this.G_PREFIX + this.PAGE_VALUES_SEPERATOR + this.pageRoot(pn);
      }

      // @property [return] Worktableプロジェクト表示位置
      static worktableDisplayPosition(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.generalPagePrefix(pn)}${this.PAGE_VALUES_SEPERATOR}ws_display_position`;
      }

      // @property [return] Zoom
      static worktableScale(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.generalPagePrefix(pn)}${this.PAGE_VALUES_SEPERATOR}ws_scale`;
      }

      // @property [return] アイテム表示状態
      static itemVisible(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.generalPagePrefix(pn)}${this.PAGE_VALUES_SEPERATOR}item_visible`;
      }

      // @property [return] 履歴ページルート
      static footprintPageRoot(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.F_PREFIX}${this.PAGE_VALUES_SEPERATOR}${this.pageRoot(pn)}`;
      }

      // @property [return] インスタンス履歴(変更前)
      static footprintInstanceBefore(eventDistNum, objId, pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.footprintPageRoot(pn)}${this.PAGE_VALUES_SEPERATOR}${this.FED_PREFIX}${this.PAGE_VALUES_SEPERATOR}${eventDistNum}${this.PAGE_VALUES_SEPERATOR}${objId}${this.PAGE_VALUES_SEPERATOR}instanceBefore`;
      }

      // @property [return] インスタンス履歴(変更後)
      static footprintInstanceAfter(eventDistNum, objId, pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.footprintPageRoot(pn)}${this.PAGE_VALUES_SEPERATOR}${this.FED_PREFIX}${this.PAGE_VALUES_SEPERATOR}${eventDistNum}${this.PAGE_VALUES_SEPERATOR}${objId}${this.PAGE_VALUES_SEPERATOR}instanceAfter`;
      }

      // @property [return] 共通インスタンス履歴(変更前)
      static footprintCommonBefore(eventDistNum, pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.footprintPageRoot(pn)}${this.PAGE_VALUES_SEPERATOR}${this.FED_PREFIX}${this.PAGE_VALUES_SEPERATOR}${eventDistNum}${this.PAGE_VALUES_SEPERATOR}commonInstanceBefore`;
      }

      // @property [return] 共通インスタンス履歴(変更後)
      static footprintCommonAfter(eventDistNum, pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.footprintPageRoot(pn)}${this.PAGE_VALUES_SEPERATOR}${this.FED_PREFIX}${this.PAGE_VALUES_SEPERATOR}${eventDistNum}${this.PAGE_VALUES_SEPERATOR}commonInstanceAfter`;
      }

      // @property [return] フォーク番号スタック
      static forkStack(pn) {
        if (pn === null) {
          pn = PageValue.getPageNum();
        }
        return `${this.footprintPageRoot(pn)}${this.PAGE_VALUES_SEPERATOR}fork_stack`;
      }
    });
    Cls.initClass();


    // ページが持つ値を取得
    // @param [String] key キー値
    // @param [String] rootId Root要素ID
    // @return [Object] ハッシュ配列または値で返す
    let _getPageValue = function (key, rootId) {
      //    if window.debug
      return _getPageValueDebug.call(this, key, rootId);
    };
    //    else
    //      _getPageValueProduction.call(@, key, rootId)

    // ページが持つ値を取得
    // @param [String] key キー値
    // @param [String] rootId Root要素ID
    // @return [Object] ハッシュ配列または値で返す
    let _getPageValueDebug = function (key, rootId) {
      const f = this;
      // div以下の値をハッシュとしてまとめる
      var takeValue = function (element) {
        let ret = null;
        const c = $(element).children();
        if ((c !== null) && (c.length > 0)) {
          $(c).each(function (e) {
            let cList = this.classList;
            if ($(this).hasClass(PageValue.Key.UPDATED)) {
              cList = cList.filter(f => f !== PageValue.Key.UPDATED);
            }
            let k = cList[0];

            if ((ret === null)) {
              if (jQuery.isNumeric(k)) {
                ret = [];
              } else {
                ret = {};
              }
            }

            let v = null;
            if (this.tagName === "INPUT") {
              // サニタイズをデコード
              v = Common.sanitaizeDecode($(this).val());
              if (jQuery.isNumeric(v)) {
                v = Number(v);
              } else if ((v === "true") || (v === "false")) {
                v = v === "true" ? true : false;
              }
            } else {
              v = takeValue.call(f, this);
            }

            // nullの場合は返却データに含めない
            if (v !== null) {
              if ((jQuery.type(ret) === "array") && jQuery.isNumeric(k)) {
                k = Number(k);
              }
              ret[k] = v;
            }

            return true;
          });

          // 空配列の場合はnullとする
          if (((jQuery.type(ret) === "object") && !$.isEmptyObject(ret)) || ((jQuery.type(ret) === "array") && (ret.length > 0))) {
            return ret;
          } else {
            return null;
          }
        } else {
          return null;
        }
      };

      let value = null;
      let root = $(`#${rootId}`);
      const keys = key.split(this.Key.PAGE_VALUES_SEPERATOR);
      keys.forEach(function (k, index) {
        root = $(`.${k}`, root);
        if ((root === null) || (root.length === 0)) {
          value = null;
          return;
        }
        if ((keys.length - 1) === index) {
          if (root[0].tagName === "INPUT") {
            value = Common.sanitaizeDecode(root.val());
            if (jQuery.isNumeric(value)) {
              return value = Number(value);
            }
          } else {
            return value = takeValue.call(f, root);
          }
        }
      });
      return value;
    };

    // ページが持つ値を取得
    // @param [String] key キー値
    // @param [String] rootId Root要素ID
    // @return [Object] ハッシュ配列または値で返す
    let _getPageValueProduction = function (key, rootId) {
      // TODO: JS変数から取得
      const f = this;
      // div以下の値をハッシュとしてまとめる
      var takeValue = function (element) {
        let ret = null;
        const c = $(element).children();
        if ((c !== null) && (c.length > 0)) {
          $(c).each(function (e) {
            let cList = this.classList;
            if ($(this).hasClass(PageValue.Key.UPDATED)) {
              cList = cList.filter(f => f !== PageValue.Key.UPDATED);
            }
            let k = cList[0];

            if ((ret === null)) {
              if (jQuery.isNumeric(k)) {
                ret = [];
              } else {
                ret = {};
              }
            }

            let v = null;
            if (this.tagName === "INPUT") {
              // サニタイズをデコード
              v = Common.sanitaizeDecode($(this).val());
              if (jQuery.isNumeric(v)) {
                v = Number(v);
              } else if ((v === "true") || (v === "false")) {
                v = v === "true" ? true : false;
              }
            } else {
              v = takeValue.call(f, this);
            }

            // nullの場合は返却データに含めない
            if (v !== null) {
              if ((jQuery.type(ret) === "array") && jQuery.isNumeric(k)) {
                k = Number(k);
              }
              ret[k] = v;
            }

            return true;
          });

          // 空配列の場合はnullとする
          if (((jQuery.type(ret) === "object") && !$.isEmptyObject(ret)) || ((jQuery.type(ret) === "array") && (ret.length > 0))) {
            return ret;
          } else {
            return null;
          }
        } else {
          return null;
        }
      };

      let value = null;
      let root = $(`#${rootId}`);
      const keys = key.split(this.Key.PAGE_VALUES_SEPERATOR);
      keys.forEach(function (k, index) {
        root = $(`.${k}`, root);
        if ((root === null) || (root.length === 0)) {
          value = null;
          return;
        }
        if ((keys.length - 1) === index) {
          if (root[0].tagName === "INPUT") {
            value = Common.sanitaizeDecode(root.val());
            if (jQuery.isNumeric(value)) {
              return value = Number(value);
            }
          } else {
            return value = takeValue.call(f, root);
          }
        }
      });
      return value;
    };

    // ページが持つ値を設定
    // @param [String] key キー値
    // @param [Object] value 設定値(ハッシュ配列または値)
    // @param [Boolean] isCache このページでのみ保持させるか
    // @param [String] rootId Root要素ID
    // @param [Boolean] giveName name属性を付与するか
    // @param [Boolean] doAdded 上書きでなく追加する
    let _setPageValue = function (key, value, isCache, rootId, giveName, doAdded) {
      //    if window.debug
      _setPageValueDebug.call(this, key, value, isCache, rootId, giveName, doAdded);
      //    else
      //      _setPageValueProduction.call(@, key, value, isCache, rootId, giveName, doAdded)
      if (window.isWorkTable && !Project.isSampleProject()) {
        // 自動保存実行
        return ServerStorage.startSaveIdleTimer();
      }
    };

    // ページが持つ値を設定
    // @param [String] key キー値
    // @param [Object] value 設定値(ハッシュ配列または値)
    // @param [Boolean] isCache このページでのみ保持させるか
    // @param [String] rootId Root要素ID
    // @param [Boolean] giveName name属性を付与するか
    // @param [Boolean] doAdded 上書きでなく追加する
    let _setPageValueDebug = function (key, value, isCache, rootId, giveName, doAdded) {
      const f = this;

      if (doAdded) {
        const n = _getPageValue.call(this, key, rootId);
        $.extend(value, n);
      }

      // ハッシュを要素の文字列に変換
      var makeElementStr = function (ky, val, kyName) {
        if ((val === null) || (val === "null")) {
          return '';
        }

        if (kyName !== null) {
          kyName += `[${ky}]`;
        } else {
          kyName = ky;
        }
        if ((jQuery.type(val) !== "object") && (jQuery.type(val) !== "array")) {
          // サニタイズする
          val = Common.sanitaizeEncode(val);
          let name = "";
          if (giveName) {
            name = `name = ${kyName}`;
          }

          return `<input type='hidden' class='${ky}' value='${val}' ${name} />`;
        }

        let ret = "";
        for (let k in val) {
          const v = val[k];
          ret += makeElementStr.call(f, k, v, kyName);
        }

        return `<div class=${ky}>${ret}</div>`;
      };

      const cacheClassName = 'cache';
      let root = $(`#${rootId}`);
      let parentClassName = null;
      const keys = key.split(this.Key.PAGE_VALUES_SEPERATOR);
      return keys.forEach(function (k, index) {
        const parent = root;
        let element = '';
        if ((keys.length - 1) > index) {
          element = 'div';
        } else {
          if ((jQuery.type(value) === "object") || (jQuery.type(value) === "array")) {
            element = 'div';
          } else {
            element = 'input';
          }
        }
        root = $(`${element}.${k}`, parent);
        if ((keys.length - 1) > index) {
          if ((root === null) || (root.length === 0)) {
            // 親要素のdiv作成
            root = jQuery(`<div class=${k}></div>`).appendTo(parent);
          }
          if (parentClassName === null) {
            return parentClassName = k;
          } else {
            return parentClassName += `[${k}]`;
          }
        } else {
          if ((root !== null) && (root.length > 0)) {
            // 要素が存在する場合は消去して上書き
            root.remove();
          }
          // 要素作成
          root = jQuery(makeElementStr.call(f, k, value, parentClassName)).appendTo(parent);
          if (isCache) {
            return root.addClass(cacheClassName);
          }
        }
      });
    };

    // ページが持つ値を設定
    // @param [String] key キー値
    // @param [Object] value 設定値(ハッシュ配列または値)
    // @param [Boolean] isCache このページでのみ保持させるか
    // @param [String] rootId Root要素ID
    // @param [Boolean] giveName name属性を付与するか
    // @param [Boolean] doAdded 上書きでなく追加する
    let _setPageValueProduction = function (key, value, isCache, rootId, giveName, doAdded) {
      // TODO: HTML要素でなく変数に持たせる

      const f = this;

      if (doAdded) {
        const n = _getPageValue.call(this, key, rootId);
        $.extend(value, n);
      }

      // ハッシュを要素の文字列に変換
      var makeElementStr = function (ky, val, kyName) {
        if ((val === null) || (val === "null")) {
          return '';
        }

        if (kyName !== null) {
          kyName += `[${ky}]`;
        } else {
          kyName = ky;
        }
        if ((jQuery.type(val) !== "object") && (jQuery.type(val) !== "array")) {
          // サニタイズする
          val = Common.sanitaizeEncode(val);
          let name = "";
          if (giveName) {
            name = `name = ${kyName}`;
          }

          return `<input type='hidden' class='${ky}' value='${val}' ${name} />`;
        }

        let ret = "";
        for (let k in val) {
          const v = val[k];
          ret += makeElementStr.call(f, k, v, kyName);
        }

        return `<div class=${ky}>${ret}</div>`;
      };

      const cacheClassName = 'cache';
      let root = $(`#${rootId}`);
      let parentClassName = null;
      const keys = key.split(this.Key.PAGE_VALUES_SEPERATOR);
      return keys.forEach(function (k, index) {
        const parent = root;
        let element = '';
        if ((keys.length - 1) > index) {
          element = 'div';
        } else {
          if (jQuery.type(value) === "object") {
            element = 'div';
          } else {
            element = 'input';
          }
        }
        root = $(`${element}.${k}`, parent);
        if ((keys.length - 1) > index) {
          if ((root === null) || (root.length === 0)) {
            // 親要素のdiv作成
            root = jQuery(`<div class=${k}></div>`).appendTo(parent);
          }
          if (parentClassName === null) {
            return parentClassName = k;
          } else {
            return parentClassName += `[${k}]`;
          }
        } else {
          if ((root !== null) && (root.length > 0)) {
            // 要素が存在する場合は消去して上書き
            root.remove();
          }
          // 要素作成
          root = jQuery(makeElementStr.call(f, k, value, parentClassName)).appendTo(parent);
          if (isCache) {
            return root.addClass(cacheClassName);
          }
        }
      });
    };
  }

  // サーバから読み込んだアイテム情報を追加
  // @param [Integer] classDistToken アイテムID
  static addItemInfo(classDistToken) {
    return this.setInstancePageValue(this.Key.itemLoaded(classDistToken), true);
  }

  // 汎用値を取得
  // @param [String] key キー値
  // @param [Boolean] updateOnly updateクラス付与のみ取得するか
  static getGeneralPageValue(key) {
    return _getPageValue.call(this, key, this.Key.G_ROOT);
  }

  // インスタンス値を取得
  // @param [String] key キー値
  // @param [Boolean] updateOnly updateクラス付与のみ取得するか
  static getInstancePageValue(key) {
    return _getPageValue.call(this, key, this.Key.IS_ROOT);
  }

  // イベントの値を取得
  // @param [String] key キー値
  // @param [Boolean] updateOnly updateクラス付与のみ取得するか
  static getEventPageValue(key) {
    return _getPageValue.call(this, key, this.Key.E_ROOT);
  }

  // 共通設定値を取得
  // @param [String] key キー値
  // @param [Boolean] updateOnly updateクラス付与のみ取得するか
  static getSettingPageValue(key) {
    return _getPageValue.call(this, key, this.Key.ST_ROOT);
  }

  // 操作履歴値を取得
  // @param [String] key キー値
  // @param [Boolean] updateOnly updateクラス付与のみ取得するか
  static getFootprintPageValue(key) {
    return _getPageValue.call(this, key, this.Key.F_ROOT);
  }

  // 汎用値を設定
  // @param [String] key キー値
  // @param [Object] value 設定値(ハッシュ配列または値)
  // @param [Boolean] doAdded 上書きでなく追加する
  static setGeneralPageValue(key, value, doAdd) {
    if (doAdd === null) {
      doAdd = false;
    }
    return _setPageValue.call(this, key, value, false, this.Key.G_ROOT, true, doAdd);
  }

  // インスタンス値を設定
  // @param [String] key キー値
  // @param [Object] value 設定値(ハッシュ配列または値)
  // @param [Boolean] doAdded 上書きでなく追加する
  static setInstancePageValue(key, value, doAdd) {
    if (doAdd === null) {
      doAdd = false;
    }
    return _setPageValue.call(this, key, value, false, this.Key.IS_ROOT, true, doAdd);
  }

  // イベントの値を設定
  // @param [String] key キー値
  // @param [Object] value 設定値(ハッシュ配列または値)
  // @param [Boolean] doAdded 上書きでなく追加する
  static setEventPageValue(key, value, doAdd) {
    if (doAdd === null) {
      doAdd = false;
    }
    return _setPageValue.call(this, key, value, false, this.Key.E_ROOT, true, doAdd);
  }

  // イベントの値をページルート値から設定
  // @param [Object] value 設定値(E_PREFIXで取得したハッシュ配列または値)
  // @param [Integer] fn フォーク番号
  // @param [Integer] pn ページ番号
  static setEventPageValueByPageRootHash(value, fn, pn) {
    // 内容を一旦消去
    if (fn === null) {
      fn = this.getForkNum();
    }
    if (pn === null) {
      pn = this.getPageNum();
    }
    const contensRoot = fn > 0 ? this.Key.EF_PREFIX + fn : this.Key.E_MASTER_ROOT;
    $(`#${this.Key.E_ROOT}`).children(`.${this.Key.E_SUB_ROOT}`).children(`.${this.Key.pageRoot()}`).children(`.${contensRoot}`).remove();
    return this.setEventPageValue(PageValue.Key.eventPageMainRoot(fn, pn), value);
  }

  // 共通設定値を設定
  // @param [String] key キー値
  // @param [Object] value 設定値(ハッシュ配列または値)
  // @param [Boolean] doAdded 上書きでなく追加する
  static setSettingPageValue(key, value, doAdd) {
    if (doAdd === null) {
      doAdd = false;
    }
    return _setPageValue.call(this, key, value, false, this.Key.ST_ROOT, true, doAdd);
  }

  // 操作履歴を設定
  // @param [String] key キー値
  // @param [Object] value 設定値(ハッシュ配列または値)
  // @param [Boolean] doAdded 上書きでなく追加する
  static setFootprintPageValue(key, value, doAdd) {
    if (doAdd === null) {
      doAdd = false;
    }
    return _setPageValue.call(this, key, value, false, this.Key.F_ROOT, true, doAdd);
  }

  // 汎用値を削除
  static removeAndShiftGeneralPageValueOnPage(pageNum) {
    // 後ページのデータをずらす
    for (let p = pageNum, end = this.getPageCount(), asc = pageNum <= end; asc ? p < end : p > end; asc ? p++ : p--) {
      this.setGeneralPageValue(this.Key.generalPagePrefix(p), this.getGeneralPageValue(this.Key.generalPagePrefix(p + 1)));
    }
    return this.setGeneralPageValue(this.Key.generalPagePrefix(this.getPageCount()), {});
  }

  // インスタンス値を削除
  static removeAndShiftInstancePageValueOnPage(pageNum) {
    // 後ページのデータをずらす
    for (let p = pageNum, end = this.getPageCount(), asc = pageNum <= end; asc ? p < end : p > end; asc ? p++ : p--) {
      this.setInstancePageValue(this.Key.instancePagePrefix(p), this.getInstancePageValue(this.Key.instancePagePrefix(p + 1)));
    }
    return this.setInstancePageValue(this.Key.instancePagePrefix(this.getPageCount()), {});
  }

  // イベントの値を削除
  static removeAndShiftEventPageValueOnPage(pageNum) {
    // 後ページのデータをずらす
    for (let p = pageNum, end = this.getPageCount(), asc = pageNum <= end; asc ? p < end : p > end; asc ? p++ : p--) {
      this.setEventPageValue(this.Key.eventPageRoot(p), this.getEventPageValue(this.Key.eventPageRoot(p + 1)));
    }
    return this.setEventPageValue(this.Key.eventPageRoot(this.getPageCount()), {});
  }

  // 足跡を削除
  static removeAndShiftFootprintPageValueOnPage(pageNum) {
    // 後ページのデータをずらす
    for (let p = pageNum, end = this.getPageCount(), asc = pageNum <= end; asc ? p < end : p > end; asc ? p++ : p--) {
      this.setFootprintPageValue(this.Key.footprintPageRoot(p), this.getFootprintPageValue(this.Key.footprintPageRoot(p + 1)));
    }
    return this.setFootprintPageValue(this.Key.footprintPageRoot(this.getPageCount()), {});
  }

  // インスタンス値を削除
  // @param [Integer] objId オブジェクトID
  static removeInstancePageValue(objId) {
    return $(`#${this.Key.IS_ROOT} .${objId}`).remove();
  }

  // updateが付与しているクラスからupdateクラスを除去する
  static clearAllUpdateFlg() {
    $(`#${this.Key.IS_ROOT}`).find(`.${PageValue.Key.UPDATED}`).removeClass(PageValue.Key.UPDATED);
    $(`#${this.Key.E_ROOT}`).find(`.${PageValue.Key.UPDATED}`).removeClass(PageValue.Key.UPDATED);
    return $(`#${this.Key.ST_ROOT}`).find(`.${PageValue.Key.UPDATED}`).removeClass(PageValue.Key.UPDATED);
  }

  // イベント番号で昇順ソートした配列を取得
  // @param [Integer] fn フォーク番号
  // @param [Integer] pn ページ番号
  static getEventPageValueSortedListByNum(fn, pn) {
    if (fn === null) {
      fn = PageValue.getForkNum();
    }
    if (pn === null) {
      pn = PageValue.getPageNum();
    }
    const eventPageValues = PageValue.getEventPageValue(this.Key.eventPageMainRoot(fn, pn));
    if ((eventPageValues === null)) {
      return [];
    }

    const count = PageValue.getEventPageValue(this.Key.eventCount(fn, pn));
    const eventObjList = new Array(count);

    // 番号でソート
    for (let k in eventPageValues) {
      const v = eventPageValues[k];
      if (k.indexOf(this.Key.E_NUM_PREFIX) === 0) {
        const index = parseInt(k.substring(this.Key.E_NUM_PREFIX.length)) - 1;
        eventObjList[index] = v;
      }
    }

    return eventObjList;
  }

  // 読み込み済みclassDistToken取得
  static getLoadedclassDistTokens() {
    const ret = [];
    // インスタンスPageValueを参照
    const itemInfoPageValues = PageValue.getInstancePageValue(this.Key.ITEM_LOADED_PREFIX);
    for (let k in itemInfoPageValues) {
      const v = itemInfoPageValues[k];
      if ($.inArray(parseInt(k), ret) < 0) {
        ret.push(parseInt(k));
      }
    }
    return ret;
  }

  // 設定値以外の情報を全削除
  static removeAllGeneralAndInstanceAndEventPageValue() {
    // page_value消去
    $(`#${this.Key.G_ROOT}`).children(`.${this.Key.G_PREFIX}`).remove();
    $(`#${this.Key.IS_ROOT}`).children(`.${this.Key.INSTANCE_PREFIX}`).remove();
    return $(`#${this.Key.E_ROOT}`).children(`.${this.Key.E_SUB_ROOT}`).remove();
  }

  // ページ上のインスタンスとイベント情報を全削除
  static removeAllInstanceAndEventPageValueOnPage() {
    // ページ内のpage_value消去
    $(`#${this.Key.IS_ROOT}`).children(`.${this.Key.INSTANCE_PREFIX}`).children(`.${this.Key.pageRoot()}`).remove();
    return $(`#${this.Key.E_ROOT}`).children(`.${this.Key.E_SUB_ROOT}`).children(`.${this.Key.pageRoot()}`).remove();
  }

  // InstancePageValueとEventPageValueを最適化
  static adjustInstanceAndEventOnPage() {
    // Instance調整
    let v;
    const iPageValues = this.getInstancePageValue(PageValue.Key.instancePagePrefix());
    const killKeyList = [];
    const instanceObjIds = [];
    for (var k in iPageValues) {
      v = iPageValues[k];
      if ((v.value !== null) && (v.value.id !== null) && ($.inArray(v.value.id, instanceObjIds) < 0)) {
        // IDが存在する & 重複してない
        instanceObjIds.push(v.value.id);
      } else {
        if ((v.value === null) || (v.value.id === null)) {
          // IDがNULLのものはInstanceから削除
          killKeyList.push(k);
        }
      }
    }
    // Instanceを更新
    for (let key of Array.from(killKeyList)) {
      delete iPageValues[key];
    }
    this.setInstancePageValue(PageValue.Key.instancePagePrefix(), iPageValues);

    // Instanceに無いイベントを削除
    const ePageValueRoot = this.getEventPageValue(PageValue.Key.eventPageRoot());
    return (() => {
      const result = [];
      for (let kk in ePageValueRoot) {
        const ePageValues = ePageValueRoot[kk];
        if (this.isContentsRoot(kk)) {
          const adjust = {};
          let min = 9999999;
          let max = 0;
          for (k in ePageValues) {
            v = ePageValues[k];
            if (k.indexOf(this.Key.E_NUM_PREFIX) === 0) {
              const kNum = parseInt(k.replace(this.Key.E_NUM_PREFIX, ''));
              if (min > kNum) {
                min = kNum;
              }
              if (max < kNum) {
                max = kNum;
              }
            } else {
              // イベント番号の付いていないキーはそのままにする
              adjust[k] = v;
            }
          }

          let teCount = 0;
          if (min <= max) {
            for (let i = min, end = max, asc = min <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
              const obj = ePageValues[this.Key.E_NUM_PREFIX + i];
              if ((obj !== null) &&
                ($.inArray(obj[EventPageValueBase.PageValueKey.ID], instanceObjIds) >= 0)) {
                teCount += 1;
                // 番号を連番に振り直し
                adjust[this.Key.E_NUM_PREFIX + teCount] = obj;
              }
            }
          }

          this.setEventPageValueByPageRootHash(adjust, this.getForkNumByRootKey(kk));
          result.push(PageValue.setEventPageValue(this.Key.eventCount(this.getForkNumByRootKey(kk)), teCount));
        } else {
          result.push(undefined);
        }
      }
      return result;
    })();
  }

  // ページ総数更新
  static updatePageCount() {
    // EventPageValueの「p_」を参照してカウント

    let page_count = 0;
    const ePageValues = this.getEventPageValue(this.Key.E_SUB_ROOT);
    for (let k in ePageValues) {
      const v = ePageValues[k];
      if (k.indexOf(this.Key.P_PREFIX) >= 0) {
        page_count += 1;
      }
    }

    if (page_count === 0) {
      // 初期表示時のページ総数は1
      page_count = 1;
    }
    return this.setGeneralPageValue(`${this.Key.G_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.PAGE_COUNT}`, page_count);
  }


  // Worktable設定による非表示状態の取得
  static getWorktableItemHide() {
    let state = this.getGeneralPageValue(`${this.Key.G_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.WORKTABLE_ITEM_HIDE_BY_SETTING}`);
    if (!state) {
      state = {};
    }
    return state;
  }

  // Worktable設定による非表示状態の設定
  static setWorktableItemHide(itemObjId, showState) {
    let state = this.getGeneralPageValue(`${this.Key.G_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.WORKTABLE_ITEM_HIDE_BY_SETTING}`);
    if ((state === null)) {
      state = {};
    }
    if (showState) {
      delete state[itemObjId];
    } else {
      state[itemObjId] = true;
    }
    return this.setGeneralPageValue(`${this.Key.G_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.WORKTABLE_ITEM_HIDE_BY_SETTING}`, state);
  }

  // フォーク総数カウント
  static updateForkCount(pn) {
    // EventPageValueの「ef_」を参照してカウント

    if (pn === null) {
      pn = PageValue.getPageNum();
    }
    let fork_count = 0;
    const ePageValues = this.getEventPageValue(this.Key.eventPageRoot(pn));
    for (let k in ePageValues) {
      const v = ePageValues[k];
      if (k.indexOf(this.Key.EF_PREFIX) >= 0) {
        fork_count += 1;
      }
    }
    return PageValue.setEventPageValue(`${this.Key.eventPageRoot()}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.FORK_COUNT}`, fork_count);
  }

  // ページ総数を取得
  // @return [Integer] ページ総数
  static getPageCount() {
    const ret = PageValue.getGeneralPageValue(`${this.Key.G_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.PAGE_COUNT}`);
    if (ret !== null) {
      return parseInt(ret);
    } else {
      return 1;
    }
  }

  // 現在のページ番号を取得
  // @return [Integer] ページ番号
  static getPageNum() {
    let ret;
    if (window.isWorkTable) {
      ret = PageValue.getGeneralPageValue(`${this.Key.G_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.PAGE_NUM}`);
    } else {
      ret = PageValue.getFootprintPageValue(`${this.Key.F_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.PAGE_NUM}`);
    }
    if (ret !== null) {
      ret = parseInt(ret);
    } else {
      ret = 1;
      this.setPageNum(ret);
    }
    return ret;
  }

  // 現在のページ番号を設定
  // @param [Integer] num 設定値
  static setPageNum(num) {
    if (window.isWorkTable) {
      return PageValue.setGeneralPageValue(`${this.Key.G_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.PAGE_NUM}`, parseInt(num));
    } else {
      // Run時は操作履歴に保存
      return PageValue.setFootprintPageValue(`${this.Key.F_PREFIX}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.PAGE_NUM}`, parseInt(num));
    }
  }

  // 現在のページ番号を追加
  // @param [Integer] addNum 追加値
  static addPagenum(addNum) {
    return this.setPageNum(this.getPageNum() + addNum);
  }

  // 現在のフォーク番号を取得
  static getForkNum(pn) {
    if (pn === null) {
      pn = this.getPageNum();
    }
    const ret = PageValue.getEventPageValue(`${this.Key.eventPageRoot(pn)}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.FORK_NUM}`);
    if (ret !== null) {
      return parseInt(ret);
    } else {
      return parseInt(this.Key.EF_MASTER_FORKNUM);
    }
  }

  // 現在のフォーク番号を設定
  // @param [Integer] num 設定値
  static setForkNum(num) {
    return PageValue.setEventPageValue(`${this.Key.eventPageRoot()}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.FORK_NUM}`, parseInt(num));
  }

  // フォーク総数を取得
  // @return [Integer] フォーク総数
  static getForkCount(pn) {
    if (pn === null) {
      pn = this.getPageNum();
    }
    const ret = PageValue.getEventPageValue(`${this.Key.eventPageRoot(pn)}${this.Key.PAGE_VALUES_SEPERATOR}${this.Key.FORK_COUNT}`);
    if (ret !== null) {
      return parseInt(ret);
    } else {
      return 0;
    }
  }

  // コンテンツルートのハッシュキーか判定
  // @param [String] key ハッシュキー
  // @return [Boolean] 判定結果
  static isContentsRoot(key) {
    return (key === this.Key.E_MASTER_ROOT) || (key.indexOf(this.Key.EF_PREFIX) >= 0);
  }

  // コンテンツルートのハッシュキーからフォーク数を取得
  // @param [String] key ハッシュキー
  // @return [Integer] フォーク数 or null
  static getForkNumByRootKey(key) {
    if (key.indexOf(this.Key.EF_PREFIX) >= 0) {
      return parseInt(key.replace(this.Key.EF_PREFIX, ''));
    }
    return null;
  }

  // EventPageValueをソート
  // @param [Integer] beforeNum 移動前イベント番号
  // @param [Integer] afterNum 移動後イベント番号
  static sortEventPageValue(beforeNum, afterNum) {
    let i, num;
    const eventPageValues = PageValue.getEventPageValueSortedListByNum();
    const w = eventPageValues[beforeNum - 1];
    // Syncを解除する
    w[EventPageValueBase.PageValueKey.IS_SYNC] = false;
    if (beforeNum < afterNum) {
      let asc, end;
      for (num = beforeNum, end = afterNum - 1, asc = beforeNum <= end; asc ? num <= end : num >= end; asc ? num++ : num--) {
        i = num - 1;
        eventPageValues[i] = eventPageValues[i + 1];
      }
    } else {
      let end1;
      for (num = beforeNum, end1 = afterNum + 1; num >= end1; num--) {
        i = num - 1;
        eventPageValues[i] = eventPageValues[i - 1];
      }
    }
    eventPageValues[afterNum - 1] = w;
    return Array.from(eventPageValues).map((e, idx) =>
      this.setEventPageValue(this.Key.eventNumber(idx + 1), e));
  }

  // 作成アイテム一覧を取得
  // @param [Integer] pn 取得するページ番号
  static getCreatedItems(pn = null) {
    const instances = this.getInstancePageValue(this.Key.instancePagePrefix(pn));
    const ret = {};
    for (let k in instances) {
      const v = instances[k];
      if ((window.instanceMap[k] !== null) && window.instanceMap[k] instanceof ItemBase) {
        ret[k] = v;
      }
    }

    return ret;
  }

  // ワークテーブル画面表示位置を取得する
  static getWorktableScrollContentsPosition() {
    if (window.scrollContents !== null) {
      const key = this.Key.worktableDisplayPosition();
      let position = this.getGeneralPageValue(key);
      if ((position === null)) {
        position = {top: 0, left: 0};
      }
      const screenSize = Common.getScreenSize();
      const t = ((window.scrollInsideWrapper.height() + screenSize.height) * 0.5) - position.top;
      const l = ((window.scrollInsideWrapper.width() + screenSize.width) * 0.5) - position.left;
      if (window.debug) {
        console.log(`getWorktableScrollContentsPosition top:${t} left:${l}`);
      }
      return {top: t, left: l};
    } else {
      return null;
    }
  }

  // ワークテーブル画面表示位置を設定する
  // @param [Float] top ScrollViewのY座標
  // @param [Float] left ScrollViewのX座標
  static setWorktableScrollContentsPosition(top, left) {
    if (window.debug) {
      console.log(`setWorktableDisplayPosition top:${top} left:${left}`);
    }
    const screenSize = Common.getScreenSize();
    const t = ((window.scrollInsideWrapper.height() + screenSize.height) * 0.5) - top;
    const l = ((window.scrollInsideWrapper.width() + screenSize.width) * 0.5) - left;
    // 中央位置からの差を設定
    const key = this.Key.worktableDisplayPosition();
    return this.setGeneralPageValue(key, {top: t, left: l});
  }

  // 対象イベントを削除する
  // @param [Integer] eNum 削除するイベント番号
  static removeEventPageValue(eNum) {
    const eventPageValues = this.getEventPageValueSortedListByNum();
    if (eventPageValues.length >= 2) {
      for (let i = 0, end = eventPageValues.length - 1, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
        if (i >= (eNum - 1)) {
          eventPageValues[i] = eventPageValues[i + 1];
        }
      }
    }

    this.setEventPageValue(this.Key.eventPageMainRoot(), {});
    if (eventPageValues.length >= 2) {
      for (let idx = 0, end1 = eventPageValues.length - 2, asc1 = 0 <= end1; asc1 ? idx <= end1 : idx >= end1; asc1 ? idx++ : idx--) {
        this.setEventPageValue(this.Key.eventNumber(idx + 1), eventPageValues[idx]);
      }
    }
    return this.setEventPageValue(this.Key.eventCount(), eventPageValues.length - 1);
  }

  // 対象イベントのSyncを解除する
  // @param [Integer] objId オブジェクトID
  static removeEventPageValueSync(objId) {
    const tes = this.getEventPageValueSortedListByNum();
    let dFlg = false;
    let type = null;
    return (() => {
      const result = [];
      for (let idx = 0; idx < tes.length; idx++) {
        const te = tes[idx];
        if (te.id === objId) {
          dFlg = true;
          result.push(type = te.actiontype);
        } else {
          if (dFlg && (type === te[EventPageValueBase.PageValueKey.ACTIONTYPE])) {
            te[EventPageValueBase.PageValueKey.IS_SYNC] = false;
            this.setEventPageValue(this.Key.eventNumber(idx + 1), te);
            dFlg = false;
            result.push(type = null);
          } else {
            result.push(undefined);
          }
        }
      }
      return result;
    })();
  }

  // Footprintに保存
  static saveToFootprint(targetObjId, isChangeBefore, eventDistNum, pageNum) {
    if (pageNum === null) {
      pageNum = PageValue.getPageNum();
    }
    return this.saveInstanceObjectToFootprint(targetObjId, isChangeBefore, eventDistNum, pageNum);
  }

  // インスタンスの変数値を保存
  static saveInstanceObjectToFootprint(targetObjId, isChangeBefore, eventDistNum, pageNum) {
    // オブジェクト
    if (pageNum === null) {
      pageNum = PageValue.getPageNum();
    }
    const obj = window.instanceMap[targetObjId];
    const key = isChangeBefore ? this.Key.footprintInstanceBefore(eventDistNum, targetObjId, pageNum) : this.Key.footprintInstanceAfter(eventDistNum, targetObjId, pageNum);
    return this.setFootprintPageValue(key, obj.getMinimumObject());
  }

  // 共通インスタンスの変数値を保存
  // FIXME: 未使用
  static saveCommonStateToFootprint(isChangeBefore, eventDistNum, pageNum) {
    // 画面State
    if (pageNum === null) {
      pageNum = PageValue.getPageNum();
    }
    const se = new ScreenEvent();
    const footprint = {};
    footprint[se.id] = se.getMinimumObject();
    const key = isChangeBefore ? this.Key.footprintCommonBefore(eventDistNum, pageNum) : this.Key.footprintCommonAfter(eventDistNum, pageNum);
    return this.setFootprintPageValue(key, footprint);
  }

  // 全ての操作履歴を削除
  static removeAllFootprint() {
    return this.setFootprintPageValue(this.Key.F_PREFIX, {});
  }
};
PageValue.initClass();
