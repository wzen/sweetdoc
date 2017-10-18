import Common from './common';
import EventPageValueBase from '../event_page_value/base/base';

// メニューをサーバから読み込み
let constant = undefined;
export default class ConfigMenu {
  static initClass() {
    constant = gon.const;

    this.ROOT_ID = constant.ConfigMenu.ROOT_ID;
    let Cls = (this.Action = class Action {
      static initClass() {
        this.PRELOAD_IMAGE_PATH_SELECT = constant.ConfigMenu.Action.PRELOAD_IMAGE_PATH_SELECT;
      }
    });
    Cls.initClass();
    Cls = (this.Modifiable = class Modifiable {
      static initClass() {
        this.CHILDREN_WRAPPER_CLASS = constant.ConfigMenu.Modifiable.CHILDREN_WRAPPER_CLASS;
      }
    });
    Cls.initClass();
  }

  // デザインコンフィグ
  static getDesignConfig(obj, successCallback = null, errorCallback = null) {
    let designConfigRoot = $(`#${obj.getDesignConfigId()}`);
    if((designConfigRoot === null) || (designConfigRoot.length === 0)) {
      Promise.all([
        import('../item/canvas_item_base'),
        import('../item/css_item_base')
      ]).then(([loaded, loaded2]) => {
        const CanvasItemBase = loaded.default;
        const CssItemBase = loaded2.default;
        let itemType = null;
        if(obj instanceof CanvasItemBase) {
          itemType = 'canvas';
        } else if(obj instanceof CssItemBase) {
          itemType = 'css';
        } else {
          itemType = 'other';
        }

        return $.ajax(
          {
            url: "/config_menu/design_config",
            type: "POST",
            data: {
              designConfig: obj.constructor.actionProperties.designConfig,
              itemType,
              modifiables: JSON.stringify(obj.constructor.actionProperties[obj.constructor.ActionPropertiesKey.MODIFIABLE_VARS])
            },
            dataType: "json",
            success(data) {
              if(data.resultSuccess) {
                designConfigRoot = $(`#${obj.getDesignConfigId()}`);
                if((designConfigRoot === null) || (designConfigRoot.length === 0)) {
                  const html = $(data.html).attr('id', obj.getDesignConfigId());
                  $('#design-config').append(html);
                  designConfigRoot = $(`#${obj.getDesignConfigId()}`);
                }
                if(successCallback !== null) {
                  return successCallback(designConfigRoot);
                }
              } else {
                if(errorCallback !== null) {
                  errorCallback(data);
                }
                console.log('/config_menu/design_config server error');
                return Common.ajaxError(data);
              }
            },
            error(data) {
              if(errorCallback !== null) {
                errorCallback(data);
              }
              console.log('/config_menu/design_config ajax error');
              return Common.ajaxError(data);
            }
          }
        );
      });
    } else {
      if(successCallback !== null) {
        return successCallback(designConfigRoot);
      }
    }
  }

  // メソッド変数コンフィグ読み込み
  static loadEventMethodValueConfig(eventConfigObj, itemObjClass, successCallback = null, errorCallback = null) {
    if((itemObjClass.actionProperties.methods[eventConfigObj[EventPageValueBase.PageValueKey.METHODNAME]] === null)) {
      // メソッド無し
      if(successCallback !== null) {
        successCallback();
      }
      return;
    }

    // HTML存在チェック
    const valueClassName = eventConfigObj.methodClassName();
    const emt = $(`.value_forms .${valueClassName}`, eventConfigObj.emt);
    if(emt.length > 0) {
      // 変数編集コンフィグの初期化
      eventConfigObj.initEventVarModifyConfig(itemObjClass);
      eventConfigObj.initEventSpecificConfig(itemObjClass);
      if(successCallback !== null) {
        successCallback();
      }
      return;
    }

    return $.ajax(
      {
        url: "/config_menu/method_values_config",
        type: "POST",
        data: {
          classDistToken: itemObjClass.CLASS_DIST_TOKEN,
          methodName: eventConfigObj[EventPageValueBase.PageValueKey.METHODNAME],
          modifiables: JSON.stringify(itemObjClass.actionProperties.methods[eventConfigObj[EventPageValueBase.PageValueKey.METHODNAME]][itemObjClass.ActionPropertiesKey.MODIFIABLE_VARS])
        },
        dataType: "json",
        success(data) {
          if(data.resultSuccess) {
            // コンフィグ追加
            $(".value_forms", eventConfigObj.emt).append($(`<div class='${valueClassName}'><div class='${eventConfigObj.constructor.METHOD_VALUE_MODIFY_ROOT}'>${data.modify_html}</div><div class='${eventConfigObj.constructor.METHOD_VALUE_SPECIFIC_ROOT}'>${data.specific_html}</div></div>`));
            // コンフィグの初期化
            eventConfigObj.initEventVarModifyConfig(itemObjClass);
            eventConfigObj.initEventSpecificConfig(itemObjClass);
            if(successCallback !== null) {
              return successCallback(data);
            }
          } else {
            if(errorCallback !== null) {
              errorCallback(data);
            }
            console.log('/config_menu/method_values_config server error');
            return Common.ajaxError(data);
          }
        },
        error(data) {
          if(errorCallback !== null) {
            errorCallback(data);
          }
          console.log('/config_menu/method_values_config ajax error');
          return Common.ajaxError(data);
        }
      }
    );
  }

  // コンフィグを読み込み(汎用的に使用)
  static loadConfig(serverActionName, sendData, successCallback = null, errorCallback = null) {
    // 存在チェック
    let emt = $(`#${this.ROOT_ID} .${serverActionName}`);
    if((emt !== null) && (emt.length > 0)) {
      if(successCallback !== null) {
        successCallback(emt.children(':first'));
      }
      return;
    }

    return $.ajax(
      {
        url: `/config_menu/${serverActionName}`,
        type: "POST",
        data: sendData,
        dataType: "json",
        success: data => {
          if(data.resultSuccess) {
            // コンフィグ追加
            $(`#${this.ROOT_ID}`).append(`<div class='${serverActionName}'>${data.html}</div>`);
            emt = $(`#${this.ROOT_ID} .${serverActionName}`);
            if(successCallback !== null) {
              return successCallback(emt.children(':first'));
            }
          } else {
            if(errorCallback !== null) {
              errorCallback(data);
            }
            return console.log(`/config_menu/${serverActionName} server error`);
          }
        },
        error(data) {
          if(errorCallback !== null) {
            errorCallback(data);
          }
          return console.log(`/config_menu/${serverActionName} ajax error`);
        }
      }
    );
  }
};
ConfigMenu.initClass();
