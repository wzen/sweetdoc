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

      Key.pageRoot = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return this.P_PREFIX + pn;
      };

      Key.PAGE_COUNT = constant.PageValueKey.PAGE_COUNT;

      Key.PAGE_NUM = constant.PageValueKey.PAGE_NUM;

      Key.FORK_COUNT = constant.PageValueKey.FORK_COUNT;

      Key.FORK_NUM = constant.PageValueKey.FORK_NUM;

      Key.IS_ROOT = constant.PageValueKey.IS_ROOT;

      Key.FORK_STACK = "" + Key.G_PREFIX + Key.PAGE_VALUES_SEPERATOR + "fork_stack";

      Key.PROJECT_ID = "" + Key.G_PREFIX + Key.PAGE_VALUES_SEPERATOR + Constant.Project.Key.PROJECT_ID;

      Key.PROJECT_NAME = "" + Key.G_PREFIX + Key.PAGE_VALUES_SEPERATOR + Constant.Project.Key.TITLE;

      Key.SCREEN_SIZE = "" + Key.G_PREFIX + Key.PAGE_VALUES_SEPERATOR + Constant.Project.Key.SCREEN_SIZE;

      Key.INSTANCE_PREFIX = constant.PageValueKey.INSTANCE_PREFIX;

      Key.instancePagePrefix = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return this.INSTANCE_PREFIX + this.PAGE_VALUES_SEPERATOR + this.pageRoot(pn);
      };

      Key.INSTANCE_VALUE_ROOT = constant.PageValueKey.INSTANCE_VALUE_ROOT;

      Key.instanceValue = function(objId) {
        return this.instancePagePrefix() + this.PAGE_VALUES_SEPERATOR + objId + this.PAGE_VALUES_SEPERATOR + this.INSTANCE_VALUE_ROOT;
      };

      Key.instanceValueCache = function(objId) {
        return this.instancePagePrefix() + this.PAGE_VALUES_SEPERATOR + 'cache' + this.PAGE_VALUES_SEPERATOR + objId + this.PAGE_VALUES_SEPERATOR + this.INSTANCE_VALUE_ROOT;
      };

      Key.ITEM_LOADED_PREFIX = 'itemloaded';

      Key.itemLoaded = function(itemId) {
        return "" + this.ITEM_LOADED_PREFIX + this.PAGE_VALUES_SEPERATOR + itemId;
      };

      Key.E_ROOT = constant.PageValueKey.E_ROOT;

      Key.E_SUB_ROOT = constant.PageValueKey.E_SUB_ROOT;

      Key.E_MASTER_ROOT = constant.PageValueKey.E_MASTER_ROOT;

      Key.E_FORK_ROOT = constant.PageValueKey.E_FORK_ROOT;

      Key.eventPageRoot = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return "" + this.E_SUB_ROOT + this.PAGE_VALUES_SEPERATOR + (this.pageRoot(pn));
      };

      Key.eventPageMainRoot = function(fn, pn) {
        var root;
        if (fn == null) {
          fn = PageValue.getForkNum();
        }
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        root = '';
        if (fn > 0) {
          root = this.EF_PREFIX + fn;
        } else {
          root = this.E_MASTER_ROOT;
        }
        return "" + (this.eventPageRoot(pn)) + this.PAGE_VALUES_SEPERATOR + root;
      };

      Key.eventNumber = function(num, fn, pn) {
        if (fn == null) {
          fn = PageValue.getForkNum();
        }
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return "" + (this.eventPageMainRoot(fn, pn)) + this.PAGE_VALUES_SEPERATOR + this.E_NUM_PREFIX + num;
      };

      Key.eventCount = function(fn, pn) {
        if (fn == null) {
          fn = PageValue.getForkNum();
        }
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return "" + (this.eventPageMainRoot(fn, pn)) + this.PAGE_VALUES_SEPERATOR + "count";
      };

      Key.E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX;

      Key.EF_PREFIX = constant.PageValueKey.EF_PREFIX;

      Key.IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD;

      Key.EF_MASTER_FORKNUM = constant.PageValueKey.EF_MASTER_FORKNUM;

      Key.UPDATED = 'updated';

      Key.generalPagePrefix = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return this.G_PREFIX + this.PAGE_VALUES_SEPERATOR + this.pageRoot(pn);
      };

      Key.displayPosition = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return "" + (this.generalPagePrefix(pn)) + this.PAGE_VALUES_SEPERATOR + "display_position";
      };

      Key.zoom = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return "" + (this.generalPagePrefix(pn)) + this.PAGE_VALUES_SEPERATOR + "zoom";
      };

      Key.itemVisible = function(pn) {
        if (pn == null) {
          pn = PageValue.getPageNum();
        }
        return "" + (this.generalPagePrefix(pn)) + this.PAGE_VALUES_SEPERATOR + "item_visible";
      };

      return Key;

    })();
  }

  PageValue.addItemInfo = function(itemId) {
    return this.setInstancePageValue(this.Key.itemLoaded(itemId), true);
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
      $("#" + this.Key.E_ROOT).children("." + this.Key.E_SUB_ROOT).remove();
    }
    results = [];
    for (k in value) {
      v = value[k];
      results.push(this.setEventPageValue(PageValue.Key.E_SUB_ROOT + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v, giveUpdate));
    }
    return results;
  };

  PageValue.setEventPageValueByPageRootHash = function(value, fn, pn, refresh, giveUpdate) {
    var contensRoot, k, results, v;
    if (fn == null) {
      fn = this.getForkNum();
    }
    if (pn == null) {
      pn = this.getPageNum();
    }
    if (refresh == null) {
      refresh = true;
    }
    if (giveUpdate == null) {
      giveUpdate = false;
    }
    if (refresh) {
      contensRoot = fn > 0 ? this.Key.EF_PREFIX + fn : this.Key.E_MASTER_ROOT;
      $("#" + this.Key.E_ROOT).children("." + this.Key.E_SUB_ROOT).children("." + (this.Key.pageRoot())).children("." + contensRoot).remove();
    }
    results = [];
    for (k in value) {
      v = value[k];
      results.push(this.setEventPageValue(PageValue.Key.eventPageMainRoot(fn, pn) + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v, giveUpdate));
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

  PageValue.getEventPageValueSortedListByNum = function(fn, pn) {
    var count, eventObjList, eventPageValues, index, k, v;
    if (fn == null) {
      fn = PageValue.getForkNum();
    }
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    eventPageValues = PageValue.getEventPageValue(this.Key.eventPageMainRoot(fn, pn));
    if (eventPageValues == null) {
      return [];
    }
    count = PageValue.getEventPageValue(this.Key.eventCount(fn, pn));
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
    itemInfoPageValues = PageValue.getInstancePageValue(this.Key.ITEM_LOADED_PREFIX);
    for (k in itemInfoPageValues) {
      v = itemInfoPageValues[k];
      if ($.inArray(parseInt(k), ret) < 0) {
        ret.push(parseInt(k));
      }
    }
    return ret;
  };

  PageValue.removeAllGeneralAndInstanceAndEventPageValue = function() {
    $("#" + this.Key.G_ROOT).children("." + this.Key.G_PREFIX).remove();
    $("#" + this.Key.IS_ROOT).children("." + this.Key.INSTANCE_PREFIX).remove();
    return $("#" + this.Key.E_ROOT).children("." + this.Key.E_SUB_ROOT).remove();
  };

  PageValue.removeAllInstanceAndEventPageValueOnPage = function() {
    $("#" + this.Key.IS_ROOT).children("." + this.Key.INSTANCE_PREFIX).children("." + (this.Key.pageRoot())).remove();
    return $("#" + this.Key.E_ROOT).children("." + this.Key.E_SUB_ROOT).children("." + (this.Key.pageRoot())).remove();
  };

  PageValue.adjustInstanceAndEventOnPage = function() {
    var adjust, ePageValueRoot, ePageValues, i, iPageValues, instanceObjIds, j, k, kNum, kk, max, min, obj, ref, ref1, results, teCount, v;
    iPageValues = this.getInstancePageValue(PageValue.Key.instancePagePrefix());
    instanceObjIds = [];
    for (k in iPageValues) {
      v = iPageValues[k];
      if ($.inArray(v.value.id, instanceObjIds) < 0) {
        instanceObjIds.push(v.value.id);
      }
    }
    ePageValueRoot = this.getEventPageValue(PageValue.Key.eventPageRoot());
    results = [];
    for (kk in ePageValueRoot) {
      ePageValues = ePageValueRoot[kk];
      if (this.isContentsRoot(kk)) {
        adjust = {};
        min = 9999999;
        max = 0;
        for (k in ePageValues) {
          v = ePageValues[k];
          if (k.indexOf(this.Key.E_NUM_PREFIX) === 0) {
            kNum = parseInt(k.replace(this.Key.E_NUM_PREFIX, ''));
            if (min > kNum) {
              min = kNum;
            }
            if (max < kNum) {
              max = kNum;
            }
          } else {
            adjust[k] = v;
          }
        }
        teCount = 0;
        if (min <= max) {
          for (i = j = ref = min, ref1 = max; ref <= ref1 ? j <= ref1 : j >= ref1; i = ref <= ref1 ? ++j : --j) {
            obj = ePageValues[this.Key.E_NUM_PREFIX + i];
            if ((obj != null) && $.inArray(obj[EventPageValueBase.PageValueKey.ID], instanceObjIds) >= 0) {
              teCount += 1;
              adjust[this.Key.E_NUM_PREFIX + teCount] = obj;
            }
          }
        }
        this.setEventPageValueByPageRootHash(adjust, this.getForkNumByRootKey(kk));
        results.push(PageValue.setEventPageValue(this.Key.eventCount(this.getForkNumByRootKey(kk)), teCount));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  PageValue.updatePageCount = function() {
    var ePageValues, k, page_count, v;
    page_count = 0;
    ePageValues = this.getEventPageValue(this.Key.E_SUB_ROOT);
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

  PageValue.updateForkCount = function(pn) {
    var ePageValues, fork_count, k, v;
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    fork_count = 0;
    ePageValues = this.getEventPageValue(this.Key.eventPageRoot(pn));
    for (k in ePageValues) {
      v = ePageValues[k];
      if (k.indexOf(this.Key.EF_PREFIX) >= 0) {
        fork_count += 1;
      }
    }
    return PageValue.setEventPageValue("" + (this.Key.eventPageRoot()) + this.Key.PAGE_VALUES_SEPERATOR + this.Key.FORK_COUNT, fork_count);
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

  PageValue.getForkNum = function(pn) {
    var ret;
    if (pn == null) {
      pn = this.getPageNum();
    }
    ret = PageValue.getEventPageValue("" + (this.Key.eventPageRoot(pn)) + this.Key.PAGE_VALUES_SEPERATOR + this.Key.FORK_NUM);
    if (ret != null) {
      return parseInt(ret);
    } else {
      return parseInt(this.Key.EF_MASTER_FORKNUM);
    }
  };

  PageValue.setForkNum = function(num) {
    return PageValue.setEventPageValue("" + (this.Key.eventPageRoot()) + this.Key.PAGE_VALUES_SEPERATOR + this.Key.FORK_NUM, parseInt(num));
  };

  PageValue.getForkCount = function(pn) {
    var ret;
    if (pn == null) {
      pn = this.getPageNum();
    }
    ret = PageValue.getEventPageValue("" + (this.Key.eventPageRoot(pn)) + this.Key.PAGE_VALUES_SEPERATOR + this.Key.FORK_COUNT);
    if (ret != null) {
      return parseInt(ret);
    } else {
      return 0;
    }
  };

  PageValue.isContentsRoot = function(key) {
    return key === this.Key.E_MASTER_ROOT || key.indexOf(this.Key.EF_PREFIX) >= 0;
  };

  PageValue.getForkNumByRootKey = function(key) {
    if (key.indexOf(this.Key.EF_PREFIX) >= 0) {
      return parseInt(key.replace(this.Key.EF_PREFIX, ''));
    }
    return null;
  };

  PageValue.itemCssOnPage = function(pageNum) {
    var css, eventPageValueRoot, eventPageValues, index, instance, k, kk, objId, v;
    css = '';
    eventPageValueRoot = PageValue.getEventPageValue(this.Key.eventPageRoot(pageNum));
    for (kk in eventPageValueRoot) {
      eventPageValues = eventPageValueRoot[kk];
      if (this.isContentsRoot(kk)) {
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
      }
    }
    return css;
  };

  PageValue.sortEventPageValue = function(beforeNum, afterNum) {
    var e, eventPageValues, i, idx, j, len, m, n, num, ref, ref1, ref2, ref3, results, w;
    eventPageValues = PageValue.getEventPageValueSortedListByNum();
    w = eventPageValues[beforeNum - 1];
    w[EventPageValueBase.PageValueKey.IS_SYNC] = false;
    if (beforeNum < afterNum) {
      for (num = j = ref = beforeNum, ref1 = afterNum - 1; ref <= ref1 ? j <= ref1 : j >= ref1; num = ref <= ref1 ? ++j : --j) {
        i = num - 1;
        eventPageValues[i] = eventPageValues[i + 1];
      }
    } else {
      for (num = m = ref2 = beforeNum, ref3 = afterNum + 1; m >= ref3; num = m += -1) {
        i = num - 1;
        eventPageValues[i] = eventPageValues[i - 1];
      }
    }
    eventPageValues[afterNum - 1] = w;
    results = [];
    for (idx = n = 0, len = eventPageValues.length; n < len; idx = ++n) {
      e = eventPageValues[idx];
      results.push(this.setEventPageValue(this.Key.eventNumber(idx + 1), e));
    }
    return results;
  };

  PageValue.getCreatedItems = function(pn) {
    var instances, k, ret, v;
    if (pn == null) {
      pn = null;
    }
    instances = this.getInstancePageValue(this.Key.instancePagePrefix(pn));
    ret = {};
    for (k in instances) {
      v = instances[k];
      if ((window.instanceMap[k] != null) && window.instanceMap[k] instanceof ItemBase) {
        ret[k] = v;
      }
    }
    return ret;
  };

  PageValue.getScrollContentsPosition = function() {
    var l, position, screenSize, t;
    if (window.scrollContents != null) {
      position = this.getGeneralPageValue(this.Key.displayPosition());
      if (position == null) {
        position = {
          top: 0,
          left: 0
        };
      }
      screenSize = this.getGeneralPageValue(this.Key.SCREEN_SIZE);
      if (screenSize == null) {
        screenSize = {
          width: window.mainWrapper.width(),
          height: window.mainWrapper.height()
        };
      }
      t = (window.scrollInside.height() + screenSize.height) * 0.5 - position.top;
      l = (window.scrollInside.width() + screenSize.width) * 0.5 - position.left;
      return {
        top: t,
        left: l
      };
    } else {
      return null;
    }
  };

  PageValue.setDisplayPosition = function(top, left) {
    var l, screenSize, t;
    screenSize = this.getGeneralPageValue(this.Key.SCREEN_SIZE);
    if (screenSize == null) {
      screenSize = {
        width: window.mainWrapper.width(),
        height: window.mainWrapper.height()
      };
    }
    t = (window.scrollInside.height() + screenSize.height) * 0.5 - top;
    l = (window.scrollInside.width() + screenSize.width) * 0.5 - left;
    return this.setGeneralPageValue(this.Key.displayPosition(), {
      top: t,
      left: l
    });
  };

  PageValue.removeEventPageValue = function(eNum) {
    var eventPageValues, i, idx, j, m, ref, ref1;
    eventPageValues = this.getEventPageValueSortedListByNum();
    if (eventPageValues.length >= 2) {
      for (i = j = 0, ref = eventPageValues.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
        if (i >= eNum - 1) {
          eventPageValues[i] = eventPageValues[i + 1];
        }
      }
    }
    this.setEventPageValue(this.Key.eventPageMainRoot(), {});
    if (eventPageValues.length >= 2) {
      for (idx = m = 0, ref1 = eventPageValues.length - 2; 0 <= ref1 ? m <= ref1 : m >= ref1; idx = 0 <= ref1 ? ++m : --m) {
        this.setEventPageValue(this.Key.eventNumber(idx + 1), eventPageValues[idx]);
      }
    }
    return PageValue.setEventPageValue(this.Key.eventCount(), eventPageValues.length - 1);
  };

  PageValue.removeEventPageValueSync = function(objId) {
    var dFlg, idx, j, len, results, te, tes, type;
    tes = this.getEventPageValueSortedListByNum();
    dFlg = false;
    type = null;
    results = [];
    for (idx = j = 0, len = tes.length; j < len; idx = ++j) {
      te = tes[idx];
      if (te.id === objId) {
        dFlg = true;
        results.push(type = te.actiontype);
      } else {
        if (dFlg && type === te[EventPageValueBase.PageValueKey.ACTIONTYPE]) {
          te[EventPageValueBase.PageValueKey.IS_SYNC] = false;
          this.setEventPageValue(this.Key.eventNumber(idx + 1), te);
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
