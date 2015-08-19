// Generated by CoffeeScript 1.9.2
var PageValue;

PageValue = (function() {
  var _getPageValue, _setPageValue, constant;

  function PageValue() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    PageValue.Key = (function() {
      function Key() {}

      Key.PV_ROOT = constant.PageValueKey.PV_ROOT;

      Key.E_ROOT = constant.PageValueKey.E_ROOT;

      Key.E_PREFIX = constant.PageValueKey.E_PREFIX;

      Key.E_COUNT = constant.PageValueKey.E_COUNT;

      Key.E_CSS = constant.PageValueKey.E_CSS;

      Key.PAGE_VALUES_SEPERATOR = constant.PageValueKey.PAGE_VALUES_SEPERATOR;

      Key.E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX;

      Key.INSTANCE_PREFIX = 'item';

      Key.INSTANCE_VALUE = Key.INSTANCE_PREFIX + ':@id:value';

      Key.INSTANCE_VALUE_CACHE = Key.INSTANCE_PREFIX + ':cache:@id:value';

      Key.ITEM_INFO_PREFIX = 'iteminfo';

      Key.ITEM_DEFAULT_METHODNAME = Key.ITEM_INFO_PREFIX + ':@item_id:default:methodname';

      Key.ITEM_DEFAULT_ACTIONTYPE = Key.ITEM_INFO_PREFIX + ':@item_id:default:actiontype';

      Key.ITEM_DEFAULT_ANIMATIONTYPE = Key.ITEM_INFO_PREFIX + ':@item_id:default:animationtype';

      Key.CONFIG_OPENED_SCROLL = 'config_opened_scroll';

      Key.IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD;

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
            _this.setPageValue(_this.Key.ITEM_DEFAULT_METHODNAME.replace('@item_id', item_id), a.method_name);
            _this.setPageValue(_this.Key.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', item_id), a.action_event_type_id);
            _this.setPageValue(_this.Key.ITEM_DEFAULT_ANIMATIONTYPE.replace('@item_id', item_id), a.action_animation_type_id);
            return isSet = true;
          }
        };
      })(this));
      if (isSet) {
        return LocalStorage.savePageValue();
      }
    }
  };

  PageValue.getPageValue = function(key, withRemove) {
    if (withRemove == null) {
      withRemove = false;
    }
    return _getPageValue.call(this, key, withRemove, this.Key.PV_ROOT);
  };

  PageValue.getEventPageValue = function(key) {
    return _getPageValue.call(this, key, false, this.Key.E_ROOT);
  };

  PageValue.getSettingPageValue = function(key) {
    return _getPageValue.call(this, key, false, Setting.PageValueKey.ROOT);
  };

  _getPageValue = function(key, withRemove, rootId) {
    var f, keys, root, takeValue, value;
    f = this;
    takeValue = function(element) {
      var c, ret;
      ret = null;
      c = $(element).children();
      if ((c != null) && c.length > 0) {
        $(c).each(function(e) {
          var k, v;
          k = this.classList[0];
          if (ret == null) {
            if (jQuery.isNumeric(k)) {
              ret = [];
            } else {
              ret = {};
            }
          }
          v = null;
          if (this.tagName === "INPUT") {
            v = Common.sanitaizeDecode($(this).val());
            if (jQuery.isNumeric(v)) {
              v = Number(v);
            } else if (v === "true" || v === "false") {
              v = v === "true" ? true : false;
            }
          } else {
            v = takeValue.call(f, this);
          }
          if (jQuery.type(ret) === "array" && jQuery.isNumeric(k)) {
            k = Number(k);
          }
          ret[k] = v;
          return true;
        });
        return ret;
      } else {
        return null;
      }
    };
    value = null;
    root = $("#" + rootId);
    keys = key.split(this.Key.PAGE_VALUES_SEPERATOR);
    keys.forEach(function(k, index) {
      root = $("." + k, root);
      if ((root == null) || root.length === 0) {
        value = null;
        return;
      }
      if (keys.length - 1 === index) {
        if (root[0].tagName === "INPUT") {
          value = Common.sanitaizeDecode(root.val());
          if (jQuery.isNumeric(value)) {
            value = Number(value);
          }
        } else {
          value = takeValue.call(f, root);
        }
        if (withRemove) {
          return root.remove();
        }
      }
    });
    return value;
  };

  PageValue.setPageValue = function(key, value, isCache) {
    if (isCache == null) {
      isCache = false;
    }
    return _setPageValue.call(this, key, value, isCache, this.Key.PV_ROOT, false);
  };

  PageValue.setEventPageValue = function(key, value) {
    return _setPageValue.call(this, key, value, false, this.Key.E_ROOT, true);
  };

  PageValue.setSettingPageValue = function(key, value, giveName) {
    if (giveName == null) {
      giveName = false;
    }
    return _setPageValue.call(this, key, value, false, Setting.PageValueKey.ROOT, giveName);
  };

  _setPageValue = function(key, value, isCache, rootId, giveName) {
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
        root = jQuery(makeElementStr.call(f, k, value, parentClassName)).appendTo(parent);
        if (isCache) {
          return root.addClass(cacheClassName);
        }
      }
    });
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

  PageValue.removePageValue = function(key) {
    return this.getPageValue(key, true);
  };

  PageValue.removeAllItemAndEventPageValue = function() {
    $("#" + this.Key.PV_ROOT).children("." + this.Key.INSTANCE_PREFIX).remove();
    return $("#" + this.Key.E_ROOT).children().remove();
  };

  return PageValue;

})();

//# sourceMappingURL=page_value.js.map
