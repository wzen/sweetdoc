// Generated by CoffeeScript 1.9.2
var Common;

Common = (function() {
  function Common() {}

  Common.MAIN_TEMP_ID = constant.ElementAttribute.MAIN_TEMP_ID;

  Common.checkBlowserEnvironment = function() {
    var c, e;
    if (!localStorage) {
      return false;
    } else {
      try {
        localStorage.setItem('test', 'test');
        c = localStorage.getItem('test');
        localStorage.removeItem('test');
      } catch (_error) {
        e = _error;
        return false;
      }
    }
    if (!File) {
      return false;
    }
    if (!window.URL) {
      return false;
    }
    return true;
  };

  Common.typeOfValue = (function() {
    var classToType, j, len, name, ref;
    classToType = {};
    ref = "Boolean Number String Function Array Date RegExp Undefined Null".split(" ");
    for (j = 0, len = ref.length; j < len; j++) {
      name = ref[j];
      classToType["[object " + name + "]"] = name.toLowerCase();
    }
    return function(obj) {
      var strType;
      strType = Object.prototype.toString.call(obj);
      return classToType[strType] || "object";
    };
  })();

  Common.generateId = function() {
    var BaseString, RandomString, i, j, n, numb, ref;
    numb = 10;
    RandomString = '';
    BaseString = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    n = 62;
    for (i = j = 0, ref = numb; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
      RandomString += BaseString.charAt(Math.floor(Math.random() * n));
    }
    return RandomString;
  };

  Common.applyEnvironmentFromPagevalue = function() {
    Navbar.setTitle(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_NAME));
    return this.initScreenSize();
  };

  Common.resetEnvironment = function() {
    Navbar.setTitle('');
    return this.initScreenSize(true);
  };

  Common.initScreenSize = function(reset) {
    var css, size;
    if (reset == null) {
      reset = false;
    }
    size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
    if (!reset && (size != null) && (size.width != null) && (size.height != null)) {
      css = {
        width: size.width,
        height: size.height
      };
      $('#project_wrapper').css(css);
    } else {
      $('#project_wrapper').removeAttr('style');
      PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {});
    }
    return this.updateCanvasSize();
  };

  Common.updateCanvasSize = function() {
    if ((window.mainWrapper != null) && (window.drawingCanvas != null)) {
      $(window.drawingCanvas).attr('width', window.mainWrapper.width());
      return $(window.drawingCanvas).attr('height', window.mainWrapper.height());
    }
  };

  Common.initResize = function(resizeEvent) {
    if (resizeEvent == null) {
      resizeEvent = null;
    }
    return $(window).resize(function() {
      Common.modalCentering();
      if (resizeEvent != null) {
        return resizeEvent();
      }
    });
  };

  Common.makeClone = function(obj) {
    var flags, key, newInstance;
    if ((obj == null) || typeof obj !== 'object') {
      return obj;
    }
    if (obj instanceof Date) {
      return new Date(obj.getTime());
    }
    if (obj instanceof RegExp) {
      flags = '';
      if (obj.global != null) {
        flags += 'g';
      }
      if (obj.ignoreCase != null) {
        flags += 'i';
      }
      if (obj.multiline != null) {
        flags += 'm';
      }
      if (obj.sticky != null) {
        flags += 'y';
      }
      return new RegExp(obj.source, flags);
    }
    newInstance = new obj.constructor();
    for (key in obj) {
      newInstance[key] = clone(obj[key]);
    }
    return newInstance;
  };

  Common.createdMainContainerIfNeeded = function(pageNum, collapsed) {
    var pageSection, root, sectionClass, style, temp, width;
    if (collapsed == null) {
      collapsed = false;
    }
    root = $("#" + Constant.Paging.ROOT_ID);
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    pageSection = $("." + sectionClass, root);
    if ((pageSection == null) || pageSection.length === 0) {
      temp = $("#" + Common.MAIN_TEMP_ID).children(':first').clone(true);
      style = '';
      style += "z-index:" + (Common.plusPagingZindex(0, pageNum)) + ";";
      width = collapsed ? 'width: 0px;' : '';
      style += width;
      temp = $(temp).wrap("<div class='" + sectionClass + " section' style='" + style + "'></div>").parent();
      root.append(temp);
      return true;
    } else {
      return false;
    }
  };

  Common.removeMainContainer = function(pageNum) {
    var root, sectionClass;
    root = $("#" + Constant.Paging.ROOT_ID);
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    return $("." + sectionClass, root).remove();
  };

  Common.focusToTarget = function(target) {
    var scrollLeft, scrollTop, targetMiddle;
    targetMiddle = {
      top: $(target).offset().top + $(target).height() * 0.5,
      left: $(target).offset().left + $(target).width() * 0.5
    };
    scrollTop = targetMiddle.top - scrollContents.height() * 0.5;
    scrollLeft = targetMiddle.left - scrollContents.width() * 0.75 * 0.5;
    return scrollContents.animate({
      scrollTop: scrollContents.scrollTop() + scrollTop,
      scrollLeft: scrollContents.scrollLeft() + scrollLeft
    }, 500);
  };

  Common.sanitaizeEncode = function(str) {
    if ((str != null) && typeof str === "string") {
      return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    } else {
      return str;
    }
  };

  Common.sanitaizeDecode = function(str) {
    if ((str != null) && typeof str === "string") {
      return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, '\'').replace(/&amp;/g, '&');
    } else {
      return str;
    }
  };

  Common.getClassFromMap = function(isCommon, id) {
    var c, i;
    if (window.classMap == null) {
      window.classMap = {};
    }
    c = isCommon;
    i = id;
    if (typeof c === "boolean") {
      if (c) {
        c = "1";
      } else {
        c = "0";
      }
    }
    if (typeof i !== "string") {
      i = String(id);
    }
    if ((window.classMap[c] == null) || (window.classMap[c][i] == null)) {
      return null;
    }
    return window.classMap[c][i];
  };

  Common.setClassToMap = function(isCommon, id, value) {
    var c, i;
    c = isCommon;
    i = id;
    if (typeof c === "boolean") {
      if (c) {
        c = "1";
      } else {
        c = "0";
      }
    }
    if (typeof i !== "string") {
      i = String(id);
    }
    if (window.classMap == null) {
      window.classMap = {};
    }
    if (window.classMap[c] == null) {
      window.classMap[c] = {};
    }
    return window.classMap[c][i] = value;
  };

  Common.newInstance = function(isCommonEvent, classMapId) {
    var id, instance;
    if (typeof isCommonEvent === "boolean") {
      if (isCommonEvent) {
        isCommonEvent = "1";
      } else {
        isCommonEvent = "0";
      }
    }
    if (typeof id !== "string") {
      id = String(id);
    }
    if (window.instanceMap == null) {
      window.instanceMap = {};
    }
    instance = new (Common.getClassFromMap(isCommonEvent, classMapId))();
    window.instanceMap[instance.id] = instance;
    return instance;
  };

  Common.getInstanceFromMap = function(isCommonEvent, id, classMapId) {
    if (typeof isCommonEvent === "boolean") {
      if (isCommonEvent) {
        isCommonEvent = "1";
      } else {
        isCommonEvent = "0";
      }
    }
    if (typeof id !== "string") {
      id = String(id);
    }
    Common.setInstanceFromMap(isCommonEvent, id, classMapId);
    return window.instanceMap[id];
  };

  Common.setInstanceFromMap = function(isCommonEvent, id, classMapId) {
    var instance;
    if (typeof isCommonEvent === "boolean") {
      if (isCommonEvent) {
        isCommonEvent = "1";
      } else {
        isCommonEvent = "0";
      }
    }
    if (typeof id !== "string") {
      id = String(id);
    }
    if (window.instanceMap == null) {
      window.instanceMap = {};
    }
    if (window.instanceMap[id] == null) {
      instance = new (Common.getClassFromMap(isCommonEvent, classMapId))();
      instance.id = id;
      return window.instanceMap[id] = instance;
    }
  };

  Common.getCreatedItemInstances = function() {
    var k, ret, v;
    ret = {};
    for (k in instanceMap) {
      v = instanceMap[k];
      if (v instanceof CommonEventBase === false) {
        ret[k] = v;
      }
    }
    return ret;
  };

  Common.clearAllEventAction = function(callback) {
    var _callback, callbackCount, forkNum, i, idx, item, j, l, len, previewinitCount, ref, results, self, te, tes, tesArray;
    if (callback == null) {
      callback = null;
    }
    self = this;
    tesArray = [];
    tesArray.push(PageValue.getEventPageValueSortedListByNum(PageValue.Key.EF_MASTER_FORKNUM));
    forkNum = PageValue.getForkNum();
    if (forkNum > 0) {
      for (i = j = 1, ref = forkNum; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
        tesArray.push(PageValue.getEventPageValueSortedListByNum(i));
      }
    }
    callbackCount = 0;
    _callback = function() {
      callbackCount += 1;
      if (callbackCount >= tesArray.length) {
        if (callback != null) {
          return callback();
        }
      }
    };
    results = [];
    for (l = 0, len = tesArray.length; l < len; l++) {
      tes = tesArray[l];
      previewinitCount = 0;
      if (tes.length <= 0) {
        _callback.call(self);
        break;
      }
      results.push((function() {
        var m, ref1, results1;
        results1 = [];
        for (idx = m = ref1 = tes.length - 1; m >= 0; idx = m += -1) {
          te = tes[idx];
          item = window.instanceMap[te.id];
          if (item != null) {
            item.initEvent(te);
            results1.push(item.stopPreview(function() {
              item.updateEventBefore();
              previewinitCount += 1;
              if (previewinitCount >= tes.length) {
                return _callback.call(self);
              }
            }));
          } else {
            previewinitCount += 1;
            if (previewinitCount >= tes.length) {
              results1.push(_callback.call(self));
            } else {
              results1.push(void 0);
            }
          }
        }
        return results1;
      })());
    }
    return results;
  };

  Common.getActionTypeClassNameByActionType = function(actionType) {
    if (parseInt(actionType) === Constant.ActionType.CLICK) {
      return Constant.TimelineActionTypeClassName.CLICK;
    } else if (parseInt(actionType) === Constant.ActionType.SCROLL) {
      return Constant.TimelineActionTypeClassName.SCROLL;
    }
    return null;
  };

  Common.formatDate = function(date, format) {
    var i, j, length, milliSeconds, ref;
    if (format == null) {
      format = 'YYYY-MM-DD hh:mm:ss';
    }
    format = format.replace(/YYYY/g, date.getFullYear());
    format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
    format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2));
    format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
    format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
    format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
    if (format.match(/S/g)) {
      milliSeconds = ('00' + date.getMilliseconds()).slice(-3);
      length = format.match(/S/g).length;
      for (i = j = 0, ref = length; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
        format = format.replace(/S/, milliSeconds.substring(i, i + 1));
      }
    }
    return format;
  };

  Common.calculateDiffTime = function(future, past) {
    var diff, ret;
    diff = future - past;
    ret = {};
    ret.seconds = parseInt(diff / 1000);
    ret.minutes = parseInt(ret.seconds / 60);
    ret.hours = parseInt(ret.minutes / 60);
    ret.day = parseInt(ret.hours / 24);
    ret.week = parseInt(ret.day / 7);
    ret.month = parseInt(ret.day / 30);
    ret.year = parseInt(ret.day / 365);
    return ret;
  };

  Common.displayDiffAlmostTime = function(future, past) {
    var day, diffTime, hours, minutes, month, ret, seconds, span, week, year;
    diffTime = this.calculateDiffTime(future, past);
    span = null;
    ret = null;
    seconds = diffTime.seconds;
    if (seconds > 0) {
      span = seconds === 1 ? 'second' : 'seconds';
      ret = seconds + " " + span + " ago";
    }
    minutes = diffTime.minutes;
    if (minutes > 0) {
      span = minutes === 1 ? 'minute' : 'minutes';
      ret = minutes + " " + span + " ago";
    }
    hours = diffTime.hours;
    if (hours > 0) {
      span = hours === 1 ? 'hour' : 'hours';
      ret = hours + " " + span + " ago";
    }
    day = diffTime.day;
    if (day > 0) {
      span = day === 1 ? 'day' : 'days';
      ret = day + " " + span + " ago";
    }
    week = diffTime.week;
    if (week > 0) {
      span = week === 1 ? 'week' : 'weeks';
      ret = week + " " + span + " ago";
    }
    month = diffTime.month;
    if (month > 0) {
      span = month === 1 ? 'month' : 'months';
      ret = month + " " + span + " ago";
    }
    year = diffTime.year;
    if (year > 0) {
      span = year === 1 ? 'year' : 'years';
      ret = year + " " + span + " ago";
    }
    return ret;
  };

  Common.showModalView = function(type, prepareShowFunc, enableOverlayClose) {
    var _show, emt, self;
    if (prepareShowFunc == null) {
      prepareShowFunc = null;
    }
    if (enableOverlayClose == null) {
      enableOverlayClose = true;
    }
    self = this;
    emt = $('body').children(".modal-content." + type);
    $(this).blur();
    if ($("#modal-overlay")[0] != null) {
      return false;
    }
    _show = function() {
      if (prepareShowFunc != null) {
        prepareShowFunc(emt);
      }
      $("body").append('<div id="modal-overlay"></div>');
      $("#modal-overlay").show();
      Common.modalCentering.call(this);
      emt.css('max-height', $(window).height() * Constant.ModalView.HEIGHT_RATE);
      emt.show();
      return $("#modal-overlay,#modal-close").unbind().click(function() {
        if (enableOverlayClose) {
          return Common.hideModalView();
        }
      });
    };
    if ((emt == null) || emt.length === 0) {
      return $.ajax({
        url: "/modal_view/show",
        type: "GET",
        data: {
          type: type
        },
        dataType: "json",
        success: function(data) {
          $('body').append(data.modalHtml);
          emt = $('body').children(".modal-content." + type);
          return _show.call(self);
        },
        error: function(data) {}
      });
    } else {
      return _show.call(self);
    }
  };

  Common.modalCentering = function() {
    var ch, cw, emt, h, w;
    emt = $('body').children(".modal-content");
    if (emt != null) {
      w = $(window).width();
      h = $(window).height();
      cw = emt.outerWidth();
      ch = emt.outerHeight();
      if (ch > h * Constant.ModalView.HEIGHT_RATE) {
        ch = h * Constant.ModalView.HEIGHT_RATE;
      }
      return emt.css({
        "left": ((w - cw) / 2) + "px",
        "top": ((h - ch) / 2) + "px"
      });
    }
  };

  Common.hideModalView = function() {
    $(".modal-content,#modal-overlay").hide();
    return $('#modal-overlay').remove();
  };

  Common.plusPagingZindex = function(zindex, pn) {
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    return (window.pageNumMax - pn) * (Constant.Zindex.EVENTFLOAT + 1) + zindex;
  };

  Common.minusPagingZindex = function(zindex, pn) {
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    return zindex - (window.pageNumMax - pn) * (Constant.Zindex.EVENTFLOAT + 1);
  };

  Common.removeAllItem = function(pageNum) {
    var itemId, k, obj, objId, pageValues, ref, results, v;
    if (pageNum == null) {
      pageNum = null;
    }
    if (pageNum != null) {
      pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum));
      results = [];
      for (k in pageValues) {
        obj = pageValues[k];
        objId = obj.value.id;
        itemId = obj.value.itemId;
        if (objId != null) {
          $("#" + objId).remove();
          results.push(delete window.instanceMap[objId]);
        } else {
          results.push(void 0);
        }
      }
      return results;
    } else {
      ref = Common.getCreatedItemInstances();
      for (k in ref) {
        v = ref[k];
        if (v.getJQueryElement != null) {
          v.getJQueryElement().remove();
        }
      }
      return window.instanceMap = {};
    }
  };

  Common.loadItemJs = function(itemIds, callback) {
    var callbackCount, itemId, j, len, needReadItemIds;
    if (callback == null) {
      callback = null;
    }
    if (jQuery.type(itemIds) !== "array") {
      itemIds = [itemIds];
    }
    if (itemIds.length === 0) {
      if (callback != null) {
        callback();
      }
      return;
    }
    callbackCount = 0;
    needReadItemIds = [];
    for (j = 0, len = itemIds.length; j < len; j++) {
      itemId = itemIds[j];
      if (itemId != null) {
        if (window.itemInitFuncList[itemId] != null) {
          window.itemInitFuncList[itemId]();
          callbackCount += 1;
          if (callbackCount >= itemIds.length) {
            if (callback != null) {
              callback();
            }
            return;
          }
        } else {
          needReadItemIds.push(itemId);
        }
      } else {
        callbackCount += 1;
      }
    }
    return $.ajax({
      url: "/item_js/index",
      type: "POST",
      dataType: "json",
      data: {
        itemIds: needReadItemIds
      },
      success: function(data) {
        var _cb, dataIdx;
        callbackCount = 0;
        dataIdx = 0;
        _cb = function(d) {
          var option;
          if (d.css_temp != null) {
            option = {
              css_temp: d.css_temp
            };
          }
          return Common.availJs(d.item_id, d.js_src, option, (function(_this) {
            return function() {
              PageValue.addItemInfo(d.item_id);
              if (window.isWorkTable && (typeof EventConfig !== "undefined" && EventConfig !== null)) {
                EventConfig.addEventConfigContents(d.item_id);
              }
              dataIdx += 1;
              if (dataIdx >= data.length) {
                if (callback != null) {
                  return callback();
                }
              } else {
                return _cb.call(_this, data[dataIdx]);
              }
            };
          })(this));
        };
        return _cb.call(this, data[dataIdx]);
      },
      error: function(data) {}
    });
  };

  Common.loadJsFromInstancePageValue = function(callback, pageNum) {
    var k, needItemIds, obj, pageValues;
    if (callback == null) {
      callback = null;
    }
    if (pageNum == null) {
      pageNum = PageValue.getPageNum();
    }
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum));
    needItemIds = [];
    for (k in pageValues) {
      obj = pageValues[k];
      if (obj.value.itemId != null) {
        if ($.inArray(obj.value.itemId, needItemIds) < 0) {
          needItemIds.push(obj.value.itemId);
        }
      }
    }
    return this.loadItemJs(needItemIds, function() {
      if (callback != null) {
        return callback();
      }
    });
  };

  Common.availJs = function(itemId, jsSrc, option, callback) {
    var firstScript, s, t;
    if (option == null) {
      option = {};
    }
    if (callback == null) {
      callback = null;
    }
    window.loadedItemId = itemId;
    s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = jsSrc;
    firstScript = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(s, firstScript);
    return t = setInterval(function() {
      if (window.itemInitFuncList[itemId] != null) {
        clearInterval(t);
        window.itemInitFuncList[itemId](option);
        window.loadedItemId = null;
        if (callback != null) {
          return callback();
        }
      }
    }, '500');
  };

  Common.canvasToBlob = function(canvas) {
    var bin, buffer, dataurl, i, j, ref, type;
    type = 'image/jpeg';
    dataurl = canvas.toDataURL(type);
    bin = atob(dataurl.split(',')[1]);
    buffer = new Uint8Array(bin.length);
    for (i = j = 0, ref = bin.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
      buffer[i] = bin.charCodeAt(i);
    }
    return new Blob([buffer.buffer], {
      type: type
    });
  };

  return Common;

})();

(function() {
  return window.classMap = {};
})();

//# sourceMappingURL=common.js.map
