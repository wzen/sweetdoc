// Generated by CoffeeScript 1.9.2
var ServerStorage;

ServerStorage = (function() {
  var constant;

  function ServerStorage() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    ServerStorage.Key = (function() {
      function Key() {}

      Key.USER_ID = constant.ServerStorage.Key.USER_ID;

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
    instancePagevalues = [];
    instance = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX);
    for (k in instance) {
      v = instance[k];
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''));
      instancePagevalues.push({
        pageNum: pageNum,
        pagevalue: JSON.stringify(v)
      });
    }
    data[this.Key.INSTANCE_PAGE_VALUE] = instancePagevalues.length > 0 ? instancePagevalues : null;
    eventPagevalues = [];
    event = PageValue.getEventPageValue(PageValue.Key.E_PREFIX);
    for (k in event) {
      v = event[k];
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''));
      eventPagevalues.push({
        pageNum: pageNum,
        pagevalue: JSON.stringify(v)
      });
    }
    data[this.Key.EVENT_PAGE_VALUE] = eventPagevalues.length > 0 ? eventPagevalues : null;
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

  ServerStorage.load = function(user_pagevalue_id) {
    return $.ajax({
      url: "/page_value_state/load_state",
      type: "POST",
      data: {
        user_pagevalue_id: user_pagevalue_id,
        loaded_itemids: JSON.stringify(PageValue.getLoadedItemIds())
      },
      dataType: "json",
      success: function(data) {
        var callback, item_js_list, loadedCount, self;
        self = this;
        item_js_list = data.item_js_list;
        callback = function() {
          var d, k, ref, ref1, v;
          WorktableCommon.removeAllItemOnWorkTable();
          if (data.instance_pagevalue_data != null) {
            d = {};
            ref = data.instance_pagevalue_data;
            for (k in ref) {
              v = ref[k];
              d[k] = JSON.parse(v);
            }
            PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, d);
          }
          if (data.event_pagevalue_data != null) {
            d = {};
            ref1 = data.event_pagevalue_data;
            for (k in ref1) {
              v = ref1[k];
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
            Setting.initConfig();
            PageValue.updatePageCount();
            return Paging.initPaging();
          });
        };
        if (item_js_list.length === 0) {
          callback.call(self);
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
              callback.call(self);
            }
            return;
          }
          if (d.css_info != null) {
            option = {
              css_temp: d.css_info
            };
          }
          Common.availJs(itemId, d.js_src, option, function() {
            loadedCount += 1;
            if (loadedCount >= item_js_list.length) {
              return callback.call(self);
            }
          });
          PageValue.addItemInfo(d.item_id, d.te_actions);
          return EventConfig.addEventConfigContents(d.item_id, d.te_actions, d.te_values);
        });
      },
      error: function(data) {
        if (window.debug) {
          return console.log(data.message);
        }
      }
    });
  };

  ServerStorage.get_load_list = function() {
    var diffTime, loadEmt, loadedLocalTime, s, updateFlg;
    loadEmt = $("#" + Navbar.NAVBAR_ROOT).find("." + this.ElementAttribute.FILE_LOAD_CLASS);
    updateFlg = loadEmt.find("." + this.ElementAttribute.LOAD_LIST_UPDATED_FLG).length > 0;
    if (updateFlg) {
      loadedLocalTime = loadEmt.find("." + this.ElementAttribute.LOADED_LOCALTIME);
      if (loadedLocalTime != null) {
        diffTime = Common.calculateDiffTime($.now(), parseInt(loadedLocalTime.val()));
        s = diffTime.seconds;
        if (window.debug) {
          console.log('loadedLocalTime diff ' + s);
        }
        if (parseInt(s) <= this.LOAD_LIST_INTERVAL_SECONDS) {
          return;
        }
      }
    }
    loadEmt.children().remove();
    $("<li><a class='menu-item'>Loading...</a></li>").appendTo(loadEmt);
    return $.ajax({
      url: "/page_value_state/user_pagevalue_list",
      type: "POST",
      dataType: "json",
      success: function(data) {
        var d, e, i, len, list, n, p, user_pagevalue_list;
        user_pagevalue_list = data;
        if (user_pagevalue_list.length > 0) {
          list = '';
          n = $.now();
          for (i = 0, len = user_pagevalue_list.length; i < len; i++) {
            p = user_pagevalue_list[i];
            d = new Date(p.updated_at);
            e = "<li><a class='menu-item'>" + (Common.displayDiffAlmostTime(n, d.getTime())) + " (" + (Common.formatDate(d)) + ")</a><input type='hidden' class='user_pagevalue_id' value=" + p.user_pagevalue_id + "></li>";
            list += e;
          }
          loadEmt.children().remove();
          $(list).appendTo(loadEmt);
          loadEmt.find('li').click(function(e) {
            var user_pagevalue_id;
            user_pagevalue_id = $(this).find('.user_pagevalue_id:first').val();
            return ServerStorage.load(user_pagevalue_id);
          });
          loadEmt.find("." + ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG).remove();
          loadEmt.find("." + ServerStorage.ElementAttribute.LOADED_LOCALTIME).remove();
          $("<input type='hidden' class=" + ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG + " value='1'>").appendTo(loadEmt);
          return $("<input type='hidden' class=" + ServerStorage.ElementAttribute.LOADED_LOCALTIME + " value=" + ($.now()) + ">").appendTo(loadEmt);
        } else {
          loadEmt.children().remove();
          return $("<li><a class='menu-item'>No Data</a></li>").appendTo(loadEmt);
        }
      },
      error: function(data) {
        if (window.debug) {
          console.log(data.responseText);
        }
        loadEmt.children().remove();
        return $("<li><a class='menu-item'>Server Access Error</a></li>").appendTo(loadEmt);
      }
    });
  };

  return ServerStorage;

})();

//# sourceMappingURL=server_storage.js.map
