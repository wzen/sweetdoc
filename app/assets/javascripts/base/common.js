// Generated by CoffeeScript 1.9.2
var Common;

Common = (function() {
  var constant;

  function Common() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    Common.MAIN_TEMP_ID = constant.ElementAttribute.MAIN_TEMP_ID;
  }

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

  Common.isEqualObject = function(obj1, obj2) {
    var _func;
    _func = function(o1, o2) {
      var k, ret, v;
      if (typeof o1 !== typeof o2) {
        return false;
      } else if (typeof o1 !== 'object') {
        return o1 === o2;
      } else {
        if (Object.keys(o1).length !== Object.keys(o2).length) {
          return false;
        }
        ret = true;
        for (k in o1) {
          v = o1[k];
          if (_func(v, o2[k]) === false) {
            ret = false;
            break;
          }
        }
        return ret;
      }
    };
    return _func(obj1, obj2);
  };

  Common.diffEventObject = function(obj1, obj2) {
    var _func, obj;
    _func = function(o1, o2) {
      var f, k, ret, v;
      if (typeof o1 !== typeof o2) {
        return o2;
      } else if (typeof o1 !== 'object') {
        if (o1 !== o2) {
          return o2;
        } else {
          return null;
        }
      } else {
        ret = {};
        for (k in o1) {
          v = o1[k];
          f = _func(v, o2[k]);
          if (f != null) {
            ret[k] = f;
          }
        }
        if (Object.keys(ret).length > 0) {
          return ret;
        } else {
          return null;
        }
      }
    };
    obj = _func(obj1, obj2);
    console.log('diffEventObject');
    console.log(obj);
    return obj;
  };

  Common.isElement = function(obj) {
    return (typeof obj === "object") && (obj.length === 1) && (obj.get(0).nodeType === 1) && (typeof obj.get(0).style === "object") && (typeof obj.get(0).ownerDocument === "object");
  };

  Common.applyEnvironmentFromPagevalue = function() {
    Common.setTitle(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_NAME));
    this.initScreenSize();
    this.initScrollContentsPosition();
    return this.initZoom();
  };

  Common.resetEnvironment = function() {
    Common.setTitle('');
    return this.initScreenSize(true);
  };

  Common.setTitle = function(title_name) {
    if (title_name != null) {
      Navbar.setTitle(title_name);
      if (!window.isWorkTable) {
        return RunCommon.setTitle(title_name);
      }
    }
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

  Common.initScrollContentsPosition = function() {
    var position;
    position = PageValue.getScrollContentsPosition();
    if (position != null) {
      return this.updateScrollContentsPosition(position.top, position.left);
    } else {
      return PageValue.setGeneralPageValue(PageValue.Key.displayPosition(), {
        top: 0,
        left: 0
      });
    }
  };

  Common.initZoom = function() {
    var zoom;
    zoom = PageValue.getGeneralPageValue(PageValue.Key.zoom());
    if (zoom != null) {
      return window.mainWrapper.css('transform', "scale(" + zoom + ", " + zoom + ")");
    } else {
      return PageValue.setGeneralPageValue(PageValue.Key.zoom(), 1);
    }
  };

  Common.updateCanvasSize = function() {
    if (window.drawingCanvas != null) {
      $(window.drawingCanvas).attr('width', $('#pages').width());
      return $(window.drawingCanvas).attr('height', $('#pages').height());
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

  Common.focusToTarget = function(target, callback, immediate) {
    var diff;
    if (callback == null) {
      callback = null;
    }
    if (immediate == null) {
      immediate = false;
    }
    diff = {
      top: (scrollContents.scrollTop() + (scrollContents.height() - $(target).height()) * 0.5) - $(target).get(0).offsetTop,
      left: (scrollContents.scrollLeft() + (scrollContents.width() - $(target).width()) * 0.5) - $(target).get(0).offsetLeft
    };
    return this.updateScrollContentsPosition(scrollContents.scrollTop() - diff.top, scrollContents.scrollLeft() - diff.left, immediate, callback);
  };

  Common.updateScrollContentsPosition = function(top, left, immediate, callback) {
    if (immediate == null) {
      immediate = true;
    }
    if (callback == null) {
      callback = null;
    }
    PageValue.setDisplayPosition(top, left);
    if (immediate) {
      window.scrollContents.scrollTop(top);
      window.scrollContents.scrollLeft(left);
      if (callback != null) {
        return callback();
      }
    } else {
      return window.scrollContents.animate({
        scrollTop: top,
        scrollLeft: left
      }, 500, function() {
        if (callback != null) {
          return callback();
        }
      });
    }
  };

  Common.updateScrollContentsFromPagevalue = function() {
    var position;
    position = PageValue.getScrollContentsPosition();
    if (position == null) {
      position = {
        top: window.scrollInsideWrapper.height() * 0.5,
        left: window.scrollInsideWrapper.width() * 0.5
      };
      PageValue.setDisplayPosition(position.top, position.left);
    }
    return this.updateScrollContentsPosition(position.top, position.left);
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

  Common.getClassFromMap = function(isCommon, dist) {
    var c, i;
    if (window.classMap == null) {
      window.classMap = {};
    }
    c = isCommon;
    i = dist;
    if (typeof c === "boolean") {
      if (c) {
        c = "1";
      } else {
        c = "0";
      }
    }
    if (typeof i !== "string") {
      i = String(dist);
    }
    if ((window.classMap[c] == null) || (window.classMap[c][i] == null)) {
      return null;
    }
    return window.classMap[c][i];
  };

  Common.setClassToMap = function(isCommon, dist, value) {
    var c, i;
    c = isCommon;
    i = dist;
    if (typeof c === "boolean") {
      if (c) {
        c = "1";
      } else {
        c = "0";
      }
    }
    if (typeof i !== "string") {
      i = String(dist);
    }
    if (window.classMap == null) {
      window.classMap = {};
    }
    if (window.classMap[c] == null) {
      window.classMap[c] = {};
    }
    return window.classMap[c][i] = value;
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
    var instance, obj;
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
      obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(id));
      if (obj) {
        instance.setMiniumObject(obj);
      }
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

  Common.getActionTypeByCodingActionType = function(actionType) {
    if (actionType === 'click') {
      return Constant.ActionType.CLICK;
    } else if (actionType === 'scroll') {
      return Constant.ActionType.SCROLL;
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
    if (ret == null) {
      ret = '';
    }
    return ret;
  };

  Common.displayLastUpdateTime = function(update_at) {
    var date, diff;
    date = new Date(update_at);
    diff = Common.calculateDiffTime($.now(), date);
    if (diff.day > 0) {
      return this.formatDate(date, 'YYYY/MM/DD');
    } else {
      return this.formatDate(date, 'hh:mm:ss');
    }
  };

  Common.showModalView = function(type, enableOverlayClose, prepareShowFunc, prepareShowFuncParams) {
    var _show, emt, self;
    if (enableOverlayClose == null) {
      enableOverlayClose = true;
    }
    if (prepareShowFunc == null) {
      prepareShowFunc = null;
    }
    if (prepareShowFuncParams == null) {
      prepareShowFuncParams = {};
    }
    self = this;
    emt = $('body').children(".modal-content." + type);
    $(this).blur();
    if ($("#modal-overlay")[0] != null) {
      return false;
    }
    _show = function() {
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
          if (data.resultSuccess) {
            $('body').append(data.modalHtml);
            emt = $('body').children(".modal-content." + type);
            emt.hide();
            if (prepareShowFunc != null) {
              return prepareShowFunc(emt, prepareShowFuncParams, function() {
                return _show.call(self);
              });
            } else {
              _show.call(self);
              return console.log('/modal_view/show server error');
            }
          }
        },
        error: function(data) {
          return console.log('/modal_view/show ajax error');
        }
      });
    } else {
      if (prepareShowFunc != null) {
        return prepareShowFunc(emt, prepareShowFuncParams, function() {
          return _show.call(self);
        });
      } else {
        return _show.call(self);
      }
    }
  };

  Common.modalCentering = function(animation, b, c) {
    var callback, ch, cw, emt, h, height, w, width;
    if (animation == null) {
      animation = false;
    }
    if (b == null) {
      b = null;
    }
    if (c == null) {
      c = null;
    }
    emt = $('body').children(".modal-content");
    if (emt != null) {
      w = $(window).width();
      h = $(window).height();
      callback = null;
      width = emt.outerWidth();
      height = emt.outerHeight();
      if (b != null) {
        if ($.type(b) === 'function') {
          callback = b;
        } else if ($.type(b) === 'object') {
          width = b.width;
          height = b.height;
        }
      }
      if (c != null) {
        callback = c;
      }
      cw = width;
      ch = height;
      if (ch > h * Constant.ModalView.HEIGHT_RATE) {
        ch = h * Constant.ModalView.HEIGHT_RATE;
      }
      if (animation) {
        return emt.animate({
          "left": ((w - cw) / 2) + "px",
          "top": ((h - ch) / 2 - 80) + "px"
        }, 300, 'linear', callback);
      } else {
        return emt.css({
          "left": ((w - cw) / 2) + "px",
          "top": ((h - ch) / 2 - 80) + "px"
        });
      }
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
    var itemToken, k, obj, objId, pageValues, ref, results, v;
    if (pageNum == null) {
      pageNum = null;
    }
    if (pageNum != null) {
      pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum));
      results = [];
      for (k in pageValues) {
        obj = pageValues[k];
        objId = obj.value.id;
        itemToken = obj.value.itemToken;
        if (objId != null) {
          $("#" + objId).remove();
          if (window.instanceMap[objId] instanceof CommonEvent) {
            CommonEvent.deleteInstance(objId);
          }
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
      window.instanceMap = {};
      return CommonEvent.deleteAllInstance();
    }
  };

  Common.loadItemJs = function(itemTokens, callback) {
    var callbackCount, data, itemToken, j, len, needReaditemTokens;
    if (callback == null) {
      callback = null;
    }
    if (jQuery.type(itemTokens) !== "array") {
      itemTokens = [itemTokens];
    }
    itemTokens = $.grep(itemTokens, function(n) {
      return n >= 0;
    });
    if (itemTokens.length === 0) {
      if (callback != null) {
        callback();
      }
      return;
    }
    callbackCount = 0;
    needReaditemTokens = [];
    for (j = 0, len = itemTokens.length; j < len; j++) {
      itemToken = itemTokens[j];
      if (itemToken != null) {
        if (window.itemInitFuncList[itemToken] != null) {
          window.itemInitFuncList[itemToken]();
          callbackCount += 1;
          if (callbackCount >= itemTokens.length) {
            if (callback != null) {
              callback();
            }
            return;
          }
        } else {
          needReaditemTokens.push(itemToken);
        }
      } else {
        callbackCount += 1;
      }
    }
    data = {};
    data[Constant.ItemGallery.Key.ITEM_GALLERY_ACCESS_TOKEN] = needReaditemTokens;
    return $.ajax({
      url: "/item_js/index",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        var _cb, dataIdx;
        if (data.resultSuccess) {
          callbackCount = 0;
          dataIdx = 0;
          _cb = function(d) {
            var option;
            option = {};
            return Common.availJs(d.item_access_token, d.js_src, option, (function(_this) {
              return function() {
                PageValue.addItemInfo(d.item_access_token);
                if (window.isWorkTable && (typeof EventConfig !== "undefined" && EventConfig !== null)) {
                  EventConfig.addEventConfigContents(d.item_access_token);
                }
                dataIdx += 1;
                if (dataIdx >= data.indexes.length) {
                  if (callback != null) {
                    return callback();
                  }
                } else {
                  return _cb.call(_this, data.indexes[dataIdx]);
                }
              };
            })(this));
          };
          return _cb.call(this, data.indexes[dataIdx]);
        } else {
          return console.log('/item_js/index server error');
        }
      },
      error: function(data) {
        return console.log('/item_js/index ajax error');
      }
    });
  };

  Common.loadJsFromInstancePageValue = function(callback, pageNum) {
    var k, needitemTokens, obj, pageValues;
    if (callback == null) {
      callback = null;
    }
    if (pageNum == null) {
      pageNum = PageValue.getPageNum();
    }
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum));
    needitemTokens = [];
    for (k in pageValues) {
      obj = pageValues[k];
      if (obj.value.itemToken != null) {
        if ($.inArray(obj.value.itemToken, needitemTokens) < 0) {
          needitemTokens.push(obj.value.itemToken);
        }
      }
    }
    return this.loadItemJs(needitemTokens, function() {
      if (callback != null) {
        return callback();
      }
    });
  };

  Common.availJs = function(itemToken, jsSrc, option, callback) {
    var firstScript, s, t;
    if (option == null) {
      option = {};
    }
    if (callback == null) {
      callback = null;
    }
    window.loadedItemToken = itemToken;
    s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = jsSrc;
    firstScript = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(s, firstScript);
    return t = setInterval(function() {
      if (window.itemInitFuncList[itemToken] != null) {
        clearInterval(t);
        window.itemInitFuncList[itemToken](option);
        window.loadedItemToken = null;
        if (callback != null) {
          return callback();
        }
      }
    }, 500);
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

  Common.setupJsByList = function(itemJsList, callback) {
    var _addItem, _func, d, loadedIndex;
    if (callback == null) {
      callback = null;
    }
    _addItem = function(item_access_token) {
      if (item_access_token == null) {
        item_access_token = null;
      }
      if (item_access_token != null) {
        PageValue.addItemInfo(item_access_token);
        if (typeof EventConfig !== "undefined" && EventConfig !== null) {
          return EventConfig.addEventConfigContents(item_access_token);
        }
      }
    };
    if (itemJsList.length === 0) {
      if (callback != null) {
        callback();
      }
      return;
    }
    loadedIndex = 0;
    d = itemJsList[loadedIndex];
    _func = function() {
      var itemToken, option;
      itemToken = d.item_access_token;
      if (window.itemInitFuncList[itemToken] != null) {
        window.itemInitFuncList[itemToken]();
        loadedIndex += 1;
        if (loadedIndex >= itemJsList.length) {
          if (callback != null) {
            callback();
          }
        } else {
          d = itemJsList[loadedIndex];
          _func.call();
        }
        return;
      }
      option = {};
      return Common.availJs(itemToken, d.js_src, option, function() {
        _addItem.call(this, itemToken);
        loadedIndex += 1;
        if (loadedIndex >= itemJsList.length) {
          if (callback != null) {
            return callback();
          }
        } else {
          d = itemJsList[loadedIndex];
          return _func.call();
        }
      });
    };
    return _func.call();
  };

  Common.setupContextMenu = function(element, contextSelector, option) {
    var data;
    data = {
      preventContextMenuForPopup: true,
      preventSelect: true
    };
    $.extend(data, option);
    return element.contextmenu(data);
  };

  Common.colorChangeCacheData = function(beforeColor, afterColor, length, colorType) {
    var b, bColors, bPer, bp, cColors, g, gPer, gp, i, index, j, l, len, len1, len2, len3, m, o, p, q, r, rPer, ref, ref1, ret, rp, u, val;
    if (colorType == null) {
      colorType = 'hex';
    }
    ret = [];
    cColors = new Array(3);
    if (afterColor.indexOf('rgb') >= 0) {
      cColors = afterColor.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',');
      for (index = j = 0, len = cColors.length; j < len; index = ++j) {
        val = cColors[index];
        cColors[index] = parseInt(val);
      }
    }
    if (afterColor.length === 6 || (afterColor.length === 7 && afterColor.indexOf('#') === 0)) {
      afterColor = afterColor.replace('#', '');
      cColors[0] = afterColor.substring(0, 2);
      cColors[1] = afterColor.substring(2, 4);
      cColors[2] = afterColor.substring(4, 6);
      for (index = l = 0, len1 = cColors.length; l < len1; index = ++l) {
        val = cColors[index];
        cColors[index] = parseInt(val, 16);
      }
    }
    if (beforeColor === 'transparent') {
      for (i = m = 0, ref = length; 0 <= ref ? m <= ref : m >= ref; i = 0 <= ref ? ++m : --m) {
        ret[i] = "rgba(" + cColors[0] + "," + cColors[1] + "," + cColors[2] + ", " + (i / length) + ")";
      }
    } else {
      bColors = new Array(3);
      if (beforeColor.indexOf('rgb') >= 0) {
        bColors = beforeColor.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',');
        for (index = p = 0, len2 = bColors.length; p < len2; index = ++p) {
          val = bColors[index];
          bColors[index] = parseInt(val);
        }
      }
      if (beforeColor.length === 6 || (beforeColor.length === 7 && beforeColor.indexOf('#') === 0)) {
        beforeColor = beforeColor.replace('#', '');
        bColors[0] = beforeColor.substring(0, 2);
        bColors[1] = beforeColor.substring(2, 4);
        bColors[2] = beforeColor.substring(4, 6);
        for (index = q = 0, len3 = bColors.length; q < len3; index = ++q) {
          val = bColors[index];
          bColors[index] = parseInt(val, 16);
        }
      }
      rPer = (cColors[0] - bColors[0]) / length;
      gPer = (cColors[1] - bColors[1]) / length;
      bPer = (cColors[2] - bColors[2]) / length;
      rp = rPer;
      gp = gPer;
      bp = bPer;
      for (i = u = 0, ref1 = length; 0 <= ref1 ? u <= ref1 : u >= ref1; i = 0 <= ref1 ? ++u : --u) {
        r = parseInt(bColors[0] + rp);
        g = parseInt(bColors[1] + gp);
        b = parseInt(bColors[2] + bp);
        if (colorType === 'hex') {
          o = "#" + (r.toString(16)) + (g.toString(16)) + (b.toString(16));
        } else if (colorType === 'rgb') {
          o = "rgb(" + r + "," + g + "," + b + ")";
        }
        ret[i] = o;
        rp += rPer;
        gp += gPer;
        bp += bPer;
      }
    }
    return ret;
  };

  return Common;

})();

(function() {
  return window.classMap = {};
})();

//# sourceMappingURL=common.js.map
