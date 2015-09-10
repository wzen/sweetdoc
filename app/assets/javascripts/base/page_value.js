// Generated by CoffeeScript 1.9.2
var PageValue;

PageValue = (function() {
  var _getPageValue, _setPageValue, constant;

  function PageValue() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    PageValue.Key = (function() {
      function Key() {}

      Key.PAGE_VALUES_SEPERATOR = constant.PageValueKey.PAGE_VALUES_SEPERATOR;

      Key.G_ROOT = constant.PageValueKey.G_ROOT;

      Key.G_PREFIX = constant.PageValueKey.G_PREFIX;

      Key.P_PREFIX = constant.PageValueKey.P_PREFIX;

      Key.pagePrefix = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return this.P_PREFIX + pn;
      };

      Key.PAGE_COUNT = constant.PageValueKey.PAGE_COUNT;

      Key.PAGE_NUM = constant.PageValueKey.PAGE_NUM;

      Key.IS_ROOT = constant.PageValueKey.IS_ROOT;

      Key.INSTANCE_PREFIX = constant.PageValueKey.INSTANCE_PREFIX;

      Key.instancePagePrefix = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return this.INSTANCE_PREFIX + this.PAGE_VALUES_SEPERATOR + this.pagePrefix(pn);
      };

      Key.INSTANCE_VALUE_ROOT = constant.PageValueKey.INSTANCE_VALUE_ROOT;

      Key.instanceValue = function(objId) {
        return this.instancePagePrefix() + this.PAGE_VALUES_SEPERATOR + objId + this.PAGE_VALUES_SEPERATOR + this.INSTANCE_VALUE_ROOT;
      };

      Key.instanceValueCache = function(objId) {
        return this.instancePagePrefix() + this.PAGE_VALUES_SEPERATOR + 'cache' + this.PAGE_VALUES_SEPERATOR + objId + this.PAGE_VALUES_SEPERATOR + this.INSTANCE_VALUE_ROOT;
      };

      Key.ITEM_INFO_PREFIX = 'iteminfo';

      Key.ITEM_DEFAULT_METHODNAME = Key.ITEM_INFO_PREFIX + ':@item_id:default:methodname';

      Key.ITEM_DEFAULT_ACTIONTYPE = Key.ITEM_INFO_PREFIX + ':@item_id:default:actiontype';

      Key.ITEM_DEFAULT_ANIMATIONTYPE = Key.ITEM_INFO_PREFIX + ':@item_id:default:animationtype';

      Key.ITEM_DEFAULT_SCROLL_ENABLED_DIRECTION = Key.ITEM_INFO_PREFIX + ':@item_id:default:scroll_enabled_direction';

      Key.ITEM_DEFAULT_SCROLL_FORWARD_DIRECTION = Key.ITEM_INFO_PREFIX + ':@item_id:default:scroll_forward_direction';

      Key.E_ROOT = constant.PageValueKey.E_ROOT;

      Key.E_PREFIX = constant.PageValueKey.E_PREFIX;

      Key.eventPagePrefix = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return this.E_PREFIX + this.PAGE_VALUES_SEPERATOR + this.pagePrefix(pn);
      };

      Key.eventCount = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return "" + this.E_PREFIX + this.PAGE_VALUES_SEPERATOR + (this.pagePrefix(pn)) + this.PAGE_VALUES_SEPERATOR + "count";
      };

      Key.E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX;

      Key.IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD;

      Key.UPDATED = 'updated';

      return Key;

    })();
  }

  PageValue.addItemInfo = function(itemId, itemInfos) {
    var isSet;
    if ((itemInfos != null) && itemInfos.length > 0) {
      isSet = false;
      itemInfos.forEach((function(_this) {
        return function(itemInfo) {
          if ((itemInfo.is_default != null) && itemInfo.is_default) {
            _this.setInstancePageValue(_this.Key.ITEM_DEFAULT_METHODNAME.replace('@item_id', itemId), itemInfo.method_name);
            _this.setInstancePageValue(_this.Key.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', itemId), itemInfo.action_event_type_id);
            _this.setInstancePageValue(_this.Key.ITEM_DEFAULT_ANIMATIONTYPE.replace('@item_id', itemId), itemInfo.action_animation_type_id);
            _this.setInstancePageValue(_this.Key.ITEM_DEFAULT_SCROLL_ENABLED_DIRECTION.replace('@item_id', itemId), itemInfo.scroll_enabled_direction != null ? JSON.parse(itemInfo.scroll_enabled_direction) : null);
            _this.setInstancePageValue(_this.Key.ITEM_DEFAULT_SCROLL_FORWARD_DIRECTION.replace('@item_id', itemId), itemInfo.scroll_forward_direction != null ? JSON.parse(itemInfo.scroll_forward_direction) : null);
            return isSet = true;
          }
        };
      })(this));
      if (isSet) {
        return LocalStorage.saveInstancePageValue();
      }
    }
  };

  PageValue.getGeneralPageValue = function(key, updateOnly) {
    if (updateOnly == null) {
      updateOnly = false;
    }
    return _getPageValue.call(this, key, this.Key.G_ROOT, updateOnly);
  };

  PageValue.getInstancePageValue = function(key, updateOnly) {
    if (updateOnly == null) {
      updateOnly = false;
    }
    return _getPageValue.call(this, key, this.Key.IS_ROOT, updateOnly);
  };

  PageValue.getEventPageValue = function(key, updateOnly) {
    if (updateOnly == null) {
      updateOnly = false;
    }
    return _getPageValue.call(this, key, this.Key.E_ROOT, updateOnly);
  };

  PageValue.getSettingPageValue = function(key, updateOnly) {
    if (updateOnly == null) {
      updateOnly = false;
    }
    return _getPageValue.call(this, key, Setting.PageValueKey.ROOT, updateOnly);
  };

  _getPageValue = function(key, rootId, updateOnly) {
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
              return value = Number(value);
            }
          } else {
            return null;
          }
        } else {
          return value = takeValue.call(f, root, hasUpdate);
        }
      }
    });
    return value;
  };

  PageValue.setGeneralPageValue = function(key, value, giveUpdate) {
    if (giveUpdate == null) {
      giveUpdate = false;
    }
    return _setPageValue.call(this, key, value, false, this.Key.G_ROOT, true, giveUpdate);
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
      $("#" + this.Key.E_ROOT).children("." + this.Key.E_PREFIX).remove();
    }
    results = [];
    for (k in value) {
      v = value[k];
      results.push(this.setEventPageValue(PageValue.Key.E_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v, giveUpdate));
    }
    return results;
  };

  PageValue.setEventPageValueByPageRootHash = function(value, refresh, giveUpdate) {
    var k, results, v;
    if (refresh == null) {
      refresh = true;
    }
    if (giveUpdate == null) {
      giveUpdate = false;
    }
    if (refresh) {
      $("#" + this.Key.E_ROOT).children("." + this.Key.E_PREFIX).children("." + (this.Key.pagePrefix())).remove();
    }
    results = [];
    for (k in value) {
      v = value[k];
      results.push(this.setEventPageValue(PageValue.Key.eventPagePrefix() + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v, giveUpdate));
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

  PageValue.removeInstancePageValue = function(objId) {
    return $("#" + this.Key.IS_ROOT + " ." + objId).remove();
  };

  PageValue.clearAllUpdateFlg = function() {
    $("#" + this.Key.IS_ROOT).find("." + PageValue.Key.UPDATED).removeClass(PageValue.Key.UPDATED);
    $("#" + this.Key.E_ROOT).find("." + PageValue.Key.UPDATED).removeClass(PageValue.Key.UPDATED);
    return $("#" + Setting.PageValueKey.ROOT).find("." + PageValue.Key.UPDATED).removeClass(PageValue.Key.UPDATED);
  };

  PageValue.getEventPageValueSortedListByNum = function(pn) {
    var count, eventObjList, eventPageValues, index, k, v;
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    eventPageValues = PageValue.getEventPageValue(this.Key.eventPagePrefix(pn));
    if (eventPageValues == null) {
      return [];
    }
    count = PageValue.getEventPageValue(this.Key.eventCount(pn));
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

  PageValue.removeAllItemAndEventPageValue = function() {
    $("#" + this.Key.G_ROOT).children("." + this.Key.G_PREFIX).remove();
    $("#" + this.Key.IS_ROOT).children("." + this.Key.INSTANCE_PREFIX).remove();
    return $("#" + this.Key.E_ROOT).children("." + this.Key.E_PREFIX).remove();
  };

  PageValue.removeAllItemAndEventPageValueOnThisPage = function() {
    $("#" + this.Key.IS_ROOT).children("." + this.Key.INSTANCE_PREFIX).children("." + (this.Key.pagePrefix())).remove();
    return $("#" + this.Key.E_ROOT).children("." + this.Key.E_PREFIX).children("." + (this.Key.pagePrefix())).remove();
  };

  PageValue.adjustInstanceAndEventOnThisPage = function() {
    var adjust, ePageValues, iPageValues, instanceObjIds, k, teCount, v;
    iPageValues = this.getInstancePageValue(PageValue.Key.instancePagePrefix());
    instanceObjIds = [];
    for (k in iPageValues) {
      v = iPageValues[k];
      if ($.inArray(v.value.id, instanceObjIds) < 0) {
        instanceObjIds.push(v.value.id);
      }
    }
    ePageValues = this.getEventPageValue(PageValue.Key.eventPagePrefix());
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
    this.setEventPageValueByPageRootHash(adjust);
    return PageValue.setEventPageValue(this.Key.eventCount(), teCount);
  };

  PageValue.updatePageCount = function() {
    var ePageValues, k, page_count, v;
    page_count = 0;
    ePageValues = this.getEventPageValue(this.Key.E_PREFIX);
    for (k in ePageValues) {
      v = ePageValues[k];
      if (k.indexOf(this.Key.P_PREFIX) >= 0) {
        page_count += 1;
      }
    }
    if (page_count === 0) {
      page_count = 1;
    }
    return this.setGeneralPageValue("" + this.Key.G_PREFIX + this.Key.PAGE_VALUES_SEPERATOR + this.Key.PAGE_COUNT, page_count);
  };

  PageValue.getPageCount = function() {
    var ret;
    ret = PageValue.getGeneralPageValue("" + this.Key.G_PREFIX + this.Key.PAGE_VALUES_SEPERATOR + this.Key.PAGE_COUNT);
    if (ret != null) {
      return parseInt(ret);
    } else {
      return 1;
    }
  };

  PageValue.getPageNum = function() {
    var ret;
    ret = PageValue.getGeneralPageValue("" + this.Key.G_PREFIX + this.Key.PAGE_VALUES_SEPERATOR + this.Key.PAGE_NUM);
    if (ret != null) {
      ret = parseInt(ret);
    } else {
      ret = 1;
      this.setPageNum(ret);
    }
    return ret;
  };

  PageValue.setPageNum = function(num) {
    return PageValue.setGeneralPageValue("" + this.Key.G_PREFIX + this.Key.PAGE_VALUES_SEPERATOR + this.Key.PAGE_NUM, parseInt(num));
  };

  PageValue.addPagenum = function(addNum) {
    return this.setPageNum(this.getPageNum() + addNum);
  };

  PageValue.itemCssOnPage = function(pageNum) {
    var css, eventPageValues, index, instance, k, objId, v;
    eventPageValues = PageValue.getEventPageValue(this.Key.eventPagePrefix(pageNum));
    css = '';
    for (k in eventPageValues) {
      v = eventPageValues[k];
      if (k.indexOf(this.Key.E_NUM_PREFIX) === 0) {
        index = parseInt(k.substring(this.Key.E_NUM_PREFIX.length)) - 1;
        objId = v.id;
        instance = PageValue.getInstancePageValue(this.Key.instanceValue(objId));
        if (instance.css != null) {
          css += instance.css;
        }
      }
    }
    return css;
  };

  PageValue.removeEventPageValueSync = function(objId) {
    var dFlg, i, idx, len, results, te, tes, type;
    tes = this.getEventPageValueSortedListByNum();
    dFlg = false;
    type = null;
    results = [];
    for (idx = i = 0, len = tes.length; i < len; idx = ++i) {
      te = tes[idx];
      if (te.id === objId) {
        dFlg = true;
        results.push(type = te.actiontype);
      } else {
        if (dFlg && type === te[EventPageValueBase.PageValueKey.ACTIONTYPE]) {
          te[EventPageValueBase.PageValueKey.IS_PARALLEL] = false;
          this.setEventPageValue(this.Key.eventPagePrefix() + this.Key.PAGE_VALUES_SEPERATOR + this.Key.E_NUM_PREFIX + (idx + 1), te);
          dFlg = false;
          results.push(type = null);
        } else {
          results.push(void 0);
        }
      }
    }
    return results;
  };

  return PageValue;

})();

//# sourceMappingURL=page_value.js.map
