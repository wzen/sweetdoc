// Generated by CoffeeScript 1.9.2
var PageValue;

PageValue = (function() {
  var _getPageValue, _setPageValue, constant;

  function PageValue() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    PageValue.Key = (function() {
      function Key() {}

      Key.IS_ROOT = constant.PageValueKey.IS_ROOT;

      Key.E_ROOT = constant.PageValueKey.E_ROOT;

      Key.E_PREFIX = constant.PageValueKey.E_PREFIX;

      Key.E_COUNT = constant.PageValueKey.E_COUNT;

      Key.E_CSS = constant.PageValueKey.E_CSS;

      Key.PAGE_VALUES_SEPERATOR = constant.PageValueKey.PAGE_VALUES_SEPERATOR;

      Key.E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX;

      Key.INSTANCE_PREFIX = constant.PageValueKey.INSTANCE_PREFIX;

      Key.INSTANCE_VALUE_ROOT = constant.PageValueKey.INSTANCE_VALUE_ROOT;

      Key.INSTANCE_VALUE = Key.INSTANCE_PREFIX + ':@id:value';

      Key.INSTANCE_VALUE_CACHE = Key.INSTANCE_PREFIX + ':cache:@id:value';

      Key.ITEM_INFO_PREFIX = 'iteminfo';

      Key.ITEM_DEFAULT_METHODNAME = Key.ITEM_INFO_PREFIX + ':@item_id:default:methodname';

      Key.ITEM_DEFAULT_ACTIONTYPE = Key.ITEM_INFO_PREFIX + ':@item_id:default:actiontype';

      Key.ITEM_DEFAULT_ANIMATIONTYPE = Key.ITEM_INFO_PREFIX + ':@item_id:default:animationtype';

      Key.CONFIG_OPENED_SCROLL = 'config_opened_scroll';

      Key.IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD;

      Key.UPDATED = 'updated';

      return Key;

    })();
  }

  PageValue.addItemInfo = function(item_id, te_actions) {
    var isSet;
    if ((te_actions != null) && te_actions.length > 0) {
      isSet = false;
      te_actions.forEach((function(_this) {
        return function(a) {
          if ((a.is_default != null) && a.is_default) {
            _this.setInstancePageValue(_this.Key.ITEM_DEFAULT_METHODNAME.replace('@item_id', item_id), a.method_name);
            _this.setInstancePageValue(_this.Key.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', item_id), a.action_event_type_id);
            _this.setInstancePageValue(_this.Key.ITEM_DEFAULT_ANIMATIONTYPE.replace('@item_id', item_id), a.action_animation_type_id);
            return isSet = true;
          }
        };
      })(this));
      if (isSet) {
        return LocalStorage.savePageValue();
      }
    }
  };

  PageValue.getInstancePageValue = function(key, updateOnly, withRemove) {
    if (updateOnly == null) {
      updateOnly = false;
    }
    if (withRemove == null) {
      withRemove = false;
    }
    return _getPageValue.call(this, key, withRemove, this.Key.IS_ROOT, updateOnly);
  };

  PageValue.getEventPageValue = function(key, updateOnly) {
    if (updateOnly == null) {
      updateOnly = false;
    }
    return _getPageValue.call(this, key, false, this.Key.E_ROOT, updateOnly);
  };

  PageValue.getSettingPageValue = function(key, updateOnly) {
    if (updateOnly == null) {
      updateOnly = false;
    }
    return _getPageValue.call(this, key, false, Setting.PageValueKey.ROOT, updateOnly);
  };

  _getPageValue = function(key, withRemove, rootId, updateOnly) {
    var f, hasUpdate, keys, root, takeValue, value;
    f = this;
    takeValue = function(element, hasUpdate) {
      var c, ret;
      ret = null;
      c = $(element).children();
      if ((c != null) && c.length > 0) {
        $(c).each(function(e) {
          var cList, hu, k, v;
          cList = this.classList;
          hu = hasUpdate;
          if ($(this).hasClass(PageValue.Key.UPDATED)) {
            hu = true;
            cList = cList.filter(function(f) {
              return f !== PageValue.Key.UPDATED;
            });
          }
          k = cList[0];
          if (ret == null) {
            if (jQuery.isNumeric(k)) {
              ret = [];
            } else {
              ret = {};
            }
          }
          v = null;
          if (this.tagName === "INPUT") {
            if ((updateOnly && !hasUpdate) === false) {
              v = Common.sanitaizeDecode($(this).val());
              if (jQuery.isNumeric(v)) {
                v = Number(v);
              } else if (v === "true" || v === "false") {
                v = v === "true" ? true : false;
              }
            }
          } else {
            v = takeValue.call(f, this, hu);
          }
          if (v !== null) {
            if (jQuery.type(ret) === "array" && jQuery.isNumeric(k)) {
              k = Number(k);
            }
            ret[k] = v;
          }
          return true;
        });
        if ((jQuery.type(ret) === "object" && !$.isEmptyObject(ret)) || (jQuery.type(ret) === "array" && ret.length > 0)) {
          return ret;
        } else {
          return null;
        }
      } else {
        return null;
      }
    };
    value = null;
    hasUpdate = false;
    root = $("#" + rootId);
    keys = key.split(this.Key.PAGE_VALUES_SEPERATOR);
    keys.forEach(function(k, index) {
      root = $("." + k, root);
      if ($(root).hasClass(PageValue.Key.UPDATED)) {
        hasUpdate = true;
      }
      if ((root == null) || root.length === 0) {
        value = null;
        return;
      }
      if (keys.length - 1 === index) {
        if (root[0].tagName === "INPUT") {
          if ((updateOnly && !hasUpdate) === false) {
            value = Common.sanitaizeDecode(root.val());
            if (jQuery.isNumeric(value)) {
              value = Number(value);
            }
          } else {
            return null;
          }
        } else {
          value = takeValue.call(f, root, hasUpdate);
        }
        if (withRemove) {
          return root.remove();
        }
      }
    });
    return value;
  };

  PageValue.setInstancePageValue = function(key, value, isCache, giveUpdate) {
    if (isCache == null) {
      isCache = false;
    }
    if (giveUpdate == null) {
      giveUpdate = false;
    }
    return _setPageValue.call(this, key, value, isCache, this.Key.IS_ROOT, true, giveUpdate);
  };

  PageValue.setEventPageValue = function(key, value, giveUpdate) {
    if (giveUpdate == null) {
      giveUpdate = false;
    }
    return _setPageValue.call(this, key, value, false, this.Key.E_ROOT, true, giveUpdate);
  };

  PageValue.setEventPageValueByRootHash = function(value, refresh, giveUpdate) {
    var k, results, v;
    if (refresh == null) {
      refresh = true;
    }
    if (giveUpdate == null) {
      giveUpdate = false;
    }
    if (refresh) {
      $("#" + this.Key.E_ROOT).children().remove();
    }
    results = [];
    for (k in value) {
      v = value[k];
      results.push(this.setEventPageValue(PageValue.Key.E_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v, giveUpdate));
    }
    return results;
  };

  PageValue.setSettingPageValue = function(key, value, giveUpdate) {
    if (giveUpdate == null) {
      giveUpdate = false;
    }
    return _setPageValue.call(this, key, value, false, Setting.PageValueKey.ROOT, true, giveUpdate);
  };

  _setPageValue = function(key, value, isCache, rootId, giveName, giveUpdate) {
    var cacheClassName, f, keys, makeElementStr, parentClassName, root;
    f = this;
    makeElementStr = function(ky, val, kyName) {
      var k, name, ret, v;
      if (val === null || val === "null") {
        return '';
      }
      kyName += "[" + ky + "]";
      if (jQuery.type(val) !== "object" && jQuery.type(val) !== "array") {
        val = Common.sanitaizeEncode(val);
        name = "";
        if (giveName) {
          name = "name = " + kyName;
        }
        if (ky === 'w') {
          console.log(val);
        }
        return "<input type='hidden' class='" + ky + "' value='" + val + "' " + name + " />";
      }
      ret = "";
      for (k in val) {
        v = val[k];
        ret += makeElementStr.call(f, k, v, kyName);
      }
      return "<div class=" + ky + ">" + ret + "</div>";
    };
    cacheClassName = 'cache';
    root = $("#" + rootId);
    parentClassName = null;
    keys = key.split(this.Key.PAGE_VALUES_SEPERATOR);
    return keys.forEach(function(k, index) {
      var element, parent;
      parent = root;
      element = '';
      if (keys.length - 1 > index) {
        element = 'div';
      } else {
        if (jQuery.type(value) === "object") {
          element = 'div';
        } else {
          element = 'input';
        }
      }
      root = $(element + "." + k, parent);
      if (keys.length - 1 > index) {
        if ((root == null) || root.length === 0) {
          root = jQuery("<div class=" + k + "></div>").appendTo(parent);
        }
        if (parentClassName === null) {
          return parentClassName = k;
        } else {
          return parentClassName += "[" + k + "]";
        }
      } else {
        if ((root != null) && root.length > 0) {
          root.remove();
        }
        if (giveUpdate) {
          parent.addClass(PageValue.Key.UPDATED);
        }
        root = jQuery(makeElementStr.call(f, k, value, parentClassName)).appendTo(parent);
        if (isCache) {
          return root.addClass(cacheClassName);
        }
      }
    });
  };

  PageValue.clearAllUpdateFlg = function() {
    $("#" + this.Key.IS_ROOT).find("." + PageValue.Key.UPDATED).removeClass(PageValue.Key.UPDATED);
    $("#" + this.Key.E_ROOT).find("." + PageValue.Key.UPDATED).removeClass(PageValue.Key.UPDATED);
    return $("#" + Setting.PageValueKey.ROOT).find("." + PageValue.Key.UPDATED).removeClass(PageValue.Key.UPDATED);
  };

  PageValue.getEventPageValueSortedListByNum = function() {
    var count, eventObjList, eventPageValues, index, k, v;
    eventPageValues = PageValue.getEventPageValue(this.Key.E_PREFIX);
    if (eventPageValues == null) {
      return [];
    }
    count = PageValue.getEventPageValue(this.Key.E_COUNT);
    eventObjList = new Array(count);
    for (k in eventPageValues) {
      v = eventPageValues[k];
      if (k.indexOf(this.Key.E_NUM_PREFIX) === 0) {
        index = parseInt(k.substring(this.Key.E_NUM_PREFIX.length)) - 1;
        eventObjList[index] = v;
      }
    }
    return eventObjList;
  };

  PageValue.getLoadedItemIds = function() {
    var itemInfoPageValues, k, ret, v;
    ret = [];
    itemInfoPageValues = PageValue.getInstancePageValue(this.Key.ITEM_INFO_PREFIX);
    for (k in itemInfoPageValues) {
      v = itemInfoPageValues[k];
      if ($.inArray(parseInt(k), ret) < 0) {
        ret.push(parseInt(k));
      }
    }
    return ret;
  };

  PageValue.removePageValue = function(key) {
    return this.getInstancePageValue(key, true);
  };

  PageValue.removeAllItemAndEventPageValue = function() {
    $("#" + this.Key.IS_ROOT).children("." + this.Key.INSTANCE_PREFIX).remove();
    return $("#" + this.Key.E_ROOT).children().remove();
  };

  PageValue.adjustInstanceAndEvent = function() {
    var adjust, ePageValues, iPageValues, instanceObjIds, k, teCount, v;
    iPageValues = this.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX);
    instanceObjIds = [];
    for (k in iPageValues) {
      v = iPageValues[k];
      if ($.inArray(v.value.id, instanceObjIds) < 0) {
        instanceObjIds.push(v.value.id);
      }
    }
    ePageValues = this.getEventPageValue(PageValue.Key.E_PREFIX);
    adjust = {};
    teCount = 0;
    for (k in ePageValues) {
      v = ePageValues[k];
      if (k.indexOf(this.Key.E_NUM_PREFIX) === 0) {
        if ($.inArray(v[EventPageValueBase.PageValueKey.ID], instanceObjIds) >= 0) {
          teCount += 1;
          adjust[this.Key.E_NUM_PREFIX + teCount] = v;
        }
      } else {
        adjust[k] = v;
      }
    }
    this.setEventPageValueByRootHash(adjust);
    return PageValue.setEventPageValue(PageValue.Key.E_COUNT, teCount);
  };

  return PageValue;

})();

//# sourceMappingURL=page_value.js.map
