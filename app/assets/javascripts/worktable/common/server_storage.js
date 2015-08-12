// Generated by CoffeeScript 1.9.2
var loadFromServer, saveToServer;

saveToServer = function() {
  var j, jsonList, k, ref, v;
  jsonList = [];
  ref = getCreatedItemObject();
  for (k in ref) {
    v = ref[k];
    j = {
      id: makeClone(v.id),
      obj: v.getMinimumObject()
    };
    jsonList.push(j);
  }
  return $.ajax({
    url: "/item_state/save_itemstate",
    type: "POST",
    data: {
      user_id: 0,
      state: JSON.stringify(jsonList)
    },
    dataType: "json",
    success: function(data) {
      return console.log(data.message);
    },
    error: function(data) {
      return console.log(data.message);
    }
  });
};

loadFromServer = function() {
  return $.ajax({
    url: "/item_state/load_itemstate",
    type: "POST",
    data: {
      user_id: 0,
      loaded_itemids: JSON.stringify(loadedItemTypeList)
    },
    dataType: "json",
    success: function(data) {
      var callback, loadedCount, self;
      self = this;
      callback = function() {
        var i, item, itemList, j, len, obj, results;
        clearWorkTable();
        itemList = JSON.parse(data.item_list);
        results = [];
        for (i = 0, len = itemList.length; i < len; i++) {
          j = itemList[i];
          obj = j.obj;
          item = null;
          if (obj.itemId === Constant.ItemId.BUTTON) {
            item = new WorkTableButtonItem();
          } else if (obj.itemId === Constant.ItemId.ARROW) {
            item = new WorkTableArrowItem();
          }
          item.reDrawByMinimumObject(obj);
          results.push(setupEvents(item));
        }
        return results;
      };
      if (data.length === 0) {
        callback.call(self);
        return;
      }
      loadedCount = 0;
      return data.forEach(function(d) {
        var itemInitFuncName, option;
        itemInitFuncName = getInitFuncName(d.item_id);
        if (window.itemInitFuncList[itemInitFuncName] != null) {
          window.itemInitFuncList[itemInitFuncName]();
          loadedCount += 1;
          if (loadedCount >= data.length) {
            callback.call(self);
          }
          return;
        }
        if (d.css_info != null) {
          option = {
            isWorkTable: true,
            css_temp: d.css_info
          };
        }
        availJs(itemInitFuncName, d.js_src, option, function() {
          loadedCount += 1;
          if (loadedCount >= data.length) {
            return callback.call(self);
          }
        });
        return addTimelineEventContents(d.te_actions, d.te_values);
      });
    },
    error: function(data) {
      return console.log(data.message);
    }
  });
};

//# sourceMappingURL=server_storage.js.map