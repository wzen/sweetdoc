// Generated by CoffeeScript 1.9.2
var ServerStorage;

ServerStorage = (function() {
  var constant;

  function ServerStorage() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    ServerStorage.Key = (function() {
      function Key() {}

      Key.PROJECT_ID = constant.ServerStorage.Key.PROJECT_ID;

      Key.PAGE_COUNT = constant.ServerStorage.Key.PAGE_COUNT;

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

      return ElementAttribute;

    })();
    ServerStorage.LOAD_LIST_INTERVAL_SECONDS = 60;
  }

  ServerStorage.save = function() {
    var data, event, eventPagevalues, instance, instancePagevalues, k, pageNum, v;
    data = {};
    data[this.Key.PAGE_COUNT] = parseInt(PageValue.getPageCount());
    data[this.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
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
    data[this.Key.SETTING_PAGE_VALUE] = JSON.stringify(PageValue.getSettingPageValue(Setting.PageValueKey.PREFIX));
    if ((data[this.Key.INSTANCE_PAGE_VALUE] != null) || (data[this.Key.EVENT_PAGE_VALUE] != null) || (data[this.Key.SETTING_PAGE_VALUE] != null)) {
      return $.ajax({
        url: "/page_value_state/save_state",
        type: "POST",
        data: data,
        dataType: "json",
        success: function(data) {
          $("#" + Navbar.NAVBAR_ROOT).find("." + ServerStorage.ElementAttribute.FILE_LOAD_CLASS + " ." + ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG).remove();
          if (window.debug) {
            return console.log(data.message);
          }
        },
        error: function(data) {
          if (window.debug) {
            return console.log(data.message);
          }
        }
      });
    }
  };

  ServerStorage.load = function(user_pagevalue_id, callback) {
    if (callback == null) {
      callback = null;
    }
    return $.ajax({
      url: "/page_value_state/load_state",
      type: "POST",
      data: {
        user_pagevalue_id: user_pagevalue_id,
        loaded_itemids: JSON.stringify(PageValue.getLoadedItemIds())
      },
      dataType: "json",
      success: function(data) {
        var _callback, item_js_list, loadedCount, self;
        self = this;
        item_js_list = data.item_js_list;
        _callback = function() {
          var d, k, ref, ref1, ref2, v;
          WorktableCommon.removeAllItemOnWorkTable();
          if (data.project_pagevalue_data != null) {
            ref = data.project_pagevalue_data;
            for (k in ref) {
              v = ref[k];
              PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v);
            }
            Navbar.setTitle(data.project_pagevalue_data.title);
          }
          if (data.instance_pagevalue_data != null) {
            d = {};
            ref1 = data.instance_pagevalue_data;
            for (k in ref1) {
              v = ref1[k];
              d[k] = JSON.parse(v);
            }
            PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, d);
          }
          if (data.event_pagevalue_data != null) {
            d = {};
            ref2 = data.event_pagevalue_data;
            for (k in ref2) {
              v = ref2[k];
              d[k] = JSON.parse(v);
            }
            PageValue.setEventPageValueByRootHash(d);
          }
          if (data.setting_pagevalue_data != null) {
            d = JSON.parse(data.setting_pagevalue_data);
            PageValue.setSettingPageValue(Setting.PageValueKey.PREFIX, d);
          }
          PageValue.adjustInstanceAndEventOnPage();
          LocalStorage.saveAllPageValues();
          return WorktableCommon.drawAllItemFromInstancePageValue(function() {
            Timeline.refreshAllTimeline();
            Setting.initConfig();
            PageValue.updatePageCount();
            PageValue.updateForkCount();
            Paging.initPaging();
            if (callback != null) {
              return callback();
            }
          });
        };
        if (item_js_list.length === 0) {
          _callback.call(self);
          return;
        }
        loadedCount = 0;
        return item_js_list.forEach(function(d) {
          var itemId, option;
          itemId = d.item_id;
          if (window.itemInitFuncList[itemId] != null) {
            window.itemInitFuncList[itemId]();
            loadedCount += 1;
            if (loadedCount >= item_js_list.length) {
              _callback.call(self);
            }
            return;
          }
          if (d.css_temp != null) {
            option = {
              css_temp: d.css_temp
            };
          }
          Common.availJs(itemId, d.js_src, option, function() {
            loadedCount += 1;
            if (loadedCount >= item_js_list.length) {
              return _callback.call(self);
            }
          });
          PageValue.addItemInfo(d.item_id);
          return EventConfig.addEventConfigContents(d.item_id);
        });
      },
      error: function(data) {
        if (window.debug) {
          return console.log(data.message);
        }
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
    data = {};
    data[this.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
    return $.ajax({
      url: "/page_value_state/user_pagevalue_list",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          return errorCallback();
        }
      }
    });
  };

  return ServerStorage;

})();

//# sourceMappingURL=server_storage.js.map
