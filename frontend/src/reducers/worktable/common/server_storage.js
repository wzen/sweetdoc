import PageValue from '../../../base/page_value';

let constant = undefined;
export default class ServerStorage {
  static initClass() {
    // 定数
    constant = gon.const;
    // ページ内値保存キー
    let Cls = (this.Key = class Key {
      static initClass() {
        this.PROJECT_ID = constant.ServerStorage.Key.PROJECT_ID;
        this.PAGE_COUNT = constant.ServerStorage.Key.PAGE_COUNT;
        this.GENERAL_COMMON_PAGE_VALUE = constant.ServerStorage.Key.GENERAL_COMMON_PAGE_VALUE;
        this.GENERAL_PAGE_VALUE = constant.ServerStorage.Key.GENERAL_PAGE_VALUE;
        this.INSTANCE_PAGE_VALUE = constant.ServerStorage.Key.INSTANCE_PAGE_VALUE;
        this.EVENT_PAGE_VALUE = constant.ServerStorage.Key.EVENT_PAGE_VALUE;
        this.SETTING_PAGE_VALUE = constant.ServerStorage.Key.SETTING_PAGE_VALUE;
      }
    });
    Cls.initClass();

    Cls = (this.ElementAttribute = class ElementAttribute {
      static initClass() {
        this.FILE_LOAD_CLASS = constant.ElementAttribute.FILE_LOAD_CLASS;
        this.LOAD_LIST_UPDATED_FLG = 'load_list_updated';
        this.LOADED_LOCALTIME = 'loaded_localtime';
        this.LOAD_LIST_INTERVAL_SECONDS = 60;
      }
    });
    Cls.initClass();

    // 60秒が過ぎたらLoadリスト一覧を取得可にする
    this.LOAD_LIST_INTERVAL_SECONDS = 60;
  }

  // サーバにアイテムの情報を保存
  static save(callback = null) {
    let pageNum, v;
    if((window.previewRunning !== null) && window.previewRunning) {
      // プレビュー時は処理しない
      if(callback !== null) {
        callback();
      }
      return;
    }
    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー画面では処理しない
      if(callback !== null) {
        callback();
      }
      return;
    }

    window.workingAutoSave = true;
    const data = {};
    data[this.Key.PAGE_COUNT] = parseInt(PageValue.getPageCount());
    data[this.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
    const generalPagevalues = {};
    const generalCommonPagevalues = {};
    const general = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX);
    data[this.Key.GENERAL_PAGE_VALUE] = general;
    const instancePagevalues = {};
    const instance = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX);
    for(var k in instance) {
      v = instance[k];
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''));
      instancePagevalues[pageNum] = JSON.stringify(v);
    }
    data[this.Key.INSTANCE_PAGE_VALUE] = Object.keys(instancePagevalues).length > 0 ? instancePagevalues : null;
    const eventPagevalues = {};
    const event = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT);
    for(k in event) {
      v = event[k];
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''));
      eventPagevalues[pageNum] = JSON.stringify(v);
    }
    data[this.Key.EVENT_PAGE_VALUE] = Object.keys(eventPagevalues).length > 0 ? eventPagevalues : null;
    data[this.Key.SETTING_PAGE_VALUE] = PageValue.getSettingPageValue(PageValue.Key.ST_PREFIX);
    if((data[this.Key.INSTANCE_PAGE_VALUE] !== null) || (data[this.Key.EVENT_PAGE_VALUE] !== null) || (data[this.Key.SETTING_PAGE_VALUE] !== null)) {
      return $.ajax(
        {
          url: "/page_value_state/save_state",
          type: "POST",
          data,
          dataType: "json",
          success(data) {
            if(data.resultSuccess) {
              Promise.all()
              // 「Load」マウスオーバーで取得させるためupdateフラグを消去
              $(`#${Navbar.NAVBAR_ROOT}`).find(`.${ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}`).remove();
              // 最終保存時刻更新
              Navbar.setLastUpdateTime(data.last_save_time);
              PageValue.setGeneralPageValue(PageValue.Key.LAST_SAVE_TIME, data.last_save_time);
              if(window.debug) {
                console.log(data.message);
              }
              if(callback !== null) {
                callback(data);
              }
              return window.workingAutoSave = false;
            } else {
              console.log('/page_value_state/save_state server error');
              // 保存エラー時にもコールバックは呼ぶ
              if(callback !== null) {
                callback(data);
              }
              System.import('../../../base/common').then(loaded => {
                const Common = loaded.default;
                return Common.ajaxError(data);
              });
            }
          },
          error(data) {
            console.log('/page_value_state/save_state ajax error');
            // 保存エラー時にもコールバックは呼ぶ
            if(callback !== null) {
              callback(data);
            }
            System.import('../../../base/common').then(loaded => {
              const Common = loaded.default;
              return Common.ajaxError(data);
            });
          }
        }
      );
    } else {
      if(callback !== null) {
        return callback();
      }
    }
  }

  // サーバからアイテムの情報を取得して描画
  // @param [Integer] user_pagevalue_id 取得するUserPageValueのID
  static load(user_pagevalue_id, callback = null) {
    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は処理しない
      return;
    }

    return $.ajax(
      {
        url: "/page_value_state/load_state",
        type: "POST",
        data: {
          user_pagevalue_id,
          loaded_class_dist_tokens: JSON.stringify(PageValue.getLoadedclassDistTokens())
        },
        dataType: "json",
        success(data) {
          if(data.resultSuccess) {
            // JSを適用
            return Common.setupJsByList(data.itemJsList, () =>
              WorktableCommon.removeAllItemAndEvent(() => {
                // Pagevalue設置
                if(data.general_pagevalue_data !== null) {
                  PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, data.general_pagevalue_data);
                  Common.setTitle(data.general_pagevalue_data.title);
                }
                if(data.instance_pagevalue_data !== null) {
                  PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, data.instance_pagevalue_data);
                }
                if(data.event_pagevalue_data !== null) {
                  PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, data.event_pagevalue_data);
                }
                if(data.setting_pagevalue_data !== null) {
                  PageValue.setSettingPageValue(PageValue.Key.ST_PREFIX, data.setting_pagevalue_data);
                }

                PageValue.adjustInstanceAndEventOnPage();
                window.lStorage.saveAllPageValues();
                if(callback !== null) {
                  return callback(data);
                }
              })
            );

          } else {
            console.log('/page_value_state/load_state server error');
            return Common.ajaxError(data);
          }
        },

        error(data) {
          console.log('/page_value_state/load_state ajax error');
          return Common.ajaxError(data);
        }
      }
    );
  }

  static get_load_data(successCallback = null, errorCallback = null) {
    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は処理しない
      return;
    }

    const data = {};
    data[this.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
    return $.ajax(
      {
        url: "/page_value_state/user_pagevalue_list_sorted_update",
        type: "GET",
        dataType: "json",
        data,
        success(data) {
          if(data.resultSuccess) {
            if(successCallback !== null) {
              return successCallback(data);
            }
          } else {
            console.log('/page_value_state/user_pagevalue_list_sorted_update server error');
            Common.ajaxError(data);
            if(errorCallback !== null) {
              return errorCallback();
            }
          }
        },
        error(data) {
          console.log('/page_value_state/user_pagevalue_list_sorted_update ajax error');
          Common.ajaxError(data);
          if(errorCallback !== null) {
            return errorCallback();
          }
        }
      }
    );
  }

  static startSaveIdleTimer() {
    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は処理しない
      return;
    }

    if(((window.workingAutoSave !== null) && window.workingAutoSave) || !window.initDone) {
      // AutoSave実行中 or 画面初期化時は実行しない
      return;
    }

    System.import('./worktable_setting').then(loaded => {
      const WorktableSetting = loaded.default;
      if(window.saveIdleTimer !== null) {
        clearTimeout(window.saveIdleTimer);
      }
      if(WorktableSetting.IdleSaveTimer.isEnabled()) {
        const time = parseFloat(WorktableSetting.IdleSaveTimer.idleTime()) * 1000;
        return window.saveIdleTimer = setTimeout(() => ServerStorage.save()
          , time);
      }
    });
  }
};
ServerStorage.initClass();
