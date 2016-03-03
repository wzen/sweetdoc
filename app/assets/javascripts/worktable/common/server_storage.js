// Generated by CoffeeScript 1.9.2
var ServerStorage;

ServerStorage = (function() {
  var constant;

  function ServerStorage() {}

  constant = gon["const"];

  ServerStorage.Key = (function() {
    function Key() {}

    Key.PROJECT_ID = constant.ServerStorage.Key.PROJECT_ID;

    Key.PAGE_COUNT = constant.ServerStorage.Key.PAGE_COUNT;

    Key.GENERAL_COMMON_PAGE_VALUE = constant.ServerStorage.Key.GENERAL_COMMON_PAGE_VALUE;

    Key.GENERAL_PAGE_VALUE = constant.ServerStorage.Key.GENERAL_PAGE_VALUE;

    Key.INSTANCE_PAGE_VALUE = constant.ServerStorage.Key.INSTANCE_PAGE_VALUE;

    Key.EVENT_PAGE_VALUE = constant.ServerStorage.Key.EVENT_PAGE_VALUE;

    Key.SETTING_PAGE_VALUE = constant.ServerStorage.Key.SETTING_PAGE_VALUE;

    return Key;

  })();

  ServerStorage.ElementAttribute = (function() {
    function ElementAttribute() {}

    ElementAttribute.FILE_LOAD_CLASS = constant.ElementAttribute.FILE_LOAD_CLASS;

    ElementAttribute.LOAD_LIST_UPDATED_FLG = 'load_list_updated';

    ElementAttribute.LOADED_LOCALTIME = 'loaded_localtime';

    ElementAttribute.LOAD_LIST_INTERVAL_SECONDS = 60;

    return ElementAttribute;

  })();

  ServerStorage.LOAD_LIST_INTERVAL_SECONDS = 60;

  ServerStorage.save = function(callback) {
    var data, event, eventPagevalues, general, generalCommonPagevalues, generalPagevalues, instance, instancePagevalues, k, pageNum, v;
    if (callback == null) {
      callback = null;
    }
    if ((window.previewRunning != null) && window.previewRunning) {
      if (callback != null) {
        callback();
      }
      return;
    }
    if ((window.isItemPreview != null) && window.isItemPreview) {
      if (callback != null) {
        callback();
      }
      return;
    }
    window.workingAutoSave = true;
    data = {};
    data[this.Key.PAGE_COUNT] = parseInt(PageValue.getPageCount());
    data[this.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
    generalPagevalues = {};
    generalCommonPagevalues = {};
    general = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX);
    data[this.Key.GENERAL_PAGE_VALUE] = general;
    instancePagevalues = {};
    instance = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX);
    for (k in instance) {
      v = instance[k];
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''));
      instancePagevalues[pageNum] = JSON.stringify(v);
    }
    data[this.Key.INSTANCE_PAGE_VALUE] = Object.keys(instancePagevalues).length > 0 ? instancePagevalues : null;
    eventPagevalues = {};
    event = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT);
    for (k in event) {
      v = event[k];
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''));
      eventPagevalues[pageNum] = JSON.stringify(v);
    }
    data[this.Key.EVENT_PAGE_VALUE] = Object.keys(eventPagevalues).length > 0 ? eventPagevalues : null;
    data[this.Key.SETTING_PAGE_VALUE] = PageValue.getSettingPageValue(PageValue.Key.ST_PREFIX);
    if ((data[this.Key.INSTANCE_PAGE_VALUE] != null) || (data[this.Key.EVENT_PAGE_VALUE] != null) || (data[this.Key.SETTING_PAGE_VALUE] != null)) {
      return $.ajax({
        url: "/page_value_state/save_state",
        type: "POST",
        data: data,
        dataType: "json",
        success: function(data) {
          if (data.resultSuccess) {
            $("#" + Navbar.NAVBAR_ROOT).find("." + ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG).remove();
            Navbar.setLastUpdateTime(data.last_save_time);
            PageValue.setGeneralPageValue(PageValue.Key.LAST_SAVE_TIME, data.last_save_time);
            if (window.debug) {
              console.log(data.message);
            }
            if (callback != null) {
              callback(data);
            }
            return window.workingAutoSave = false;
          } else {
            console.log('/page_value_state/save_state server error');
            if (callback != null) {
              callback();
            }
            return Common.ajaxError(data);
          }
        },
        error: function(data) {
          console.log('/page_value_state/save_state ajax error');
          if (callback != null) {
            callback();
          }
          return Common.ajaxError(data);
        }
      });
    } else {
      if (callback != null) {
        return callback();
      }
    }
  };

  ServerStorage.load = function(user_pagevalue_id, callback) {
    if (callback == null) {
      callback = null;
    }
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return;
    }
    return $.ajax({
      url: "/page_value_state/load_state",
      type: "POST",
      data: {
        user_pagevalue_id: user_pagevalue_id,
        loaded_class_dist_tokens: JSON.stringify(PageValue.getLoadedclassDistTokens())
      },
      dataType: "json",
      success: function(data) {
        if (data.resultSuccess) {
          return Common.setupJsByList(data.itemJsList, function() {
            return WorktableCommon.removeAllItemAndEvent((function(_this) {
              return function() {
                if (data.general_pagevalue_data != null) {
                  PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, data.general_pagevalue_data);
                  Common.setTitle(data.general_pagevalue_data.title);
                }
                if (data.instance_pagevalue_data != null) {
                  PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, data.instance_pagevalue_data);
                }
                if (data.event_pagevalue_data != null) {
                  PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, data.event_pagevalue_data);
                }
                if (data.setting_pagevalue_data != null) {
                  PageValue.setSettingPageValue(PageValue.Key.ST_PREFIX, data.setting_pagevalue_data);
                }
                PageValue.adjustInstanceAndEventOnPage();
                window.lStorage.saveAllPageValues();
                if (callback != null) {
                  return callback(data);
                }
              };
            })(this));
          });
        } else {
          console.log('/page_value_state/load_state server error');
          return Common.ajaxError(data);
        }
      },
      error: function(data) {
        console.log('/page_value_state/load_state ajax error');
        return Common.ajaxError(data);
      }
    });
  };

  ServerStorage.get_load_data = function(successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return;
    }
    data = {};
    data[this.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
    return $.ajax({
      url: "/page_value_state/user_pagevalue_list_sorted_update",
      type: "GET",
      dataType: "json",
      data: data,
      success: function(data) {
        if (data.resultSuccess) {
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          console.log('/page_value_state/user_pagevalue_list_sorted_update server error');
          Common.ajaxError(data);
          if (errorCallback != null) {
            return errorCallback();
          }
        }
      },
      error: function(data) {
        console.log('/page_value_state/user_pagevalue_list_sorted_update ajax error');
        Common.ajaxError(data);
        if (errorCallback != null) {
          return errorCallback();
        }
      }
    });
  };

  ServerStorage.startSaveIdleTimer = function() {
    var time;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return;
    }
    if (((window.workingAutoSave != null) && window.workingAutoSave) || !window.initDone) {
      return;
    }
    if (window.saveIdleTimer != null) {
      clearTimeout(window.saveIdleTimer);
    }
    if (WorktableSetting.IdleSaveTimer.isEnabled()) {
      time = parseFloat(WorktableSetting.IdleSaveTimer.idleTime()) * 1000;
      return window.saveIdleTimer = setTimeout(function() {
        return ServerStorage.save();
      }, time);
    }
  };

  return ServerStorage;

})();

//# sourceMappingURL=server_storage.js.map
