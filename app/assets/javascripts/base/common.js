// Generated by CoffeeScript 1.9.2
var Common;

Common = (function() {
  var constant;

  function Common() {}

  Common.scaleFromViewRate = 1.0;

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
      if (o1 == null) {
        return o2;
      }
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
        for (k in o2) {
          v = o2[k];
          f = _func(o1[k], v);
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
    if (window.debug) {
      console.log('diffEventObject');
      console.log(obj);
    }
    return obj;
  };

  Common.isElement = function(obj) {
    return (typeof obj === "object") && (obj.length === 1) && (obj.get(0).nodeType === 1) && (typeof obj.get(0).style === "object") && (typeof obj.get(0).ownerDocument === "object");
  };

  Common.applyEnvironmentFromPagevalue = function() {
    Common.setTitle(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_NAME));
    this.initScreenSize();
    this.initScrollContentsPosition();
    return this.applyViewScale();
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

  Common.applyViewScale = function() {
    var scale, scaleFromStateConfig, updateMainWrapperPercent;
    scaleFromStateConfig = PageValue.getGeneralPageValue(PageValue.Key.scaleFromStateConfig());
    if (scaleFromStateConfig == null) {
      scaleFromStateConfig = 1.0;
    }
    scale = scaleFromStateConfig * Common.scaleFromViewRate * ScreenEvent.PrivateClass.scale;
    updateMainWrapperPercent = 100 / Common.scaleFromViewRate;
    return window.mainWrapper.css({
      transform: "scale(" + scale + ", " + scale + ")",
      width: updateMainWrapperPercent + "%",
      height: updateMainWrapperPercent + "%"
    });
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

  Common.instancesInPage = function(pn, withCreateInstance, withInitFromPageValue) {
    var instance, instances, key, obj, ret, value;
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    if (withCreateInstance == null) {
      withCreateInstance = false;
    }
    if (withInitFromPageValue == null) {
      withInitFromPageValue = false;
    }
    ret = [];
    instances = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pn));
    for (key in instances) {
      instance = instances[key];
      value = instance.value;
      if (withCreateInstance) {
        obj = Common.getInstanceFromMap(value.id, value.classDistToken);
        if (withInitFromPageValue) {
          obj.setMiniumObject(value);
        }
      } else {
        obj = window.instanceMap[value.id];
      }
      ret.push(obj);
    }
    return ret;
  };

  Common.itemInstancesInPage = function(pn, withCreateInstance, withInitFromPageValue) {
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    if (withCreateInstance == null) {
      withCreateInstance = false;
    }
    if (withInitFromPageValue == null) {
      withInitFromPageValue = false;
    }
    return $.grep(this.instancesInPage(pn, withCreateInstance, withInitFromPageValue), function(n) {
      return n instanceof ItemBase;
    });
  };

  Common.firstFocusItemObj = function(pn) {
    var j, len, o, obj, objs;
    if (pn == null) {
      pn = PageValue.getPageNum();
    }
    objs = this.itemInstancesInPage(pn);
    obj = null;
    for (j = 0, len = objs.length; j < len; j++) {
      o = objs[j];
      if (o.visible && o.firstFocus) {
        obj = o;
        return obj;
      }
    }
    return obj;
  };

  Common.wrapCreateItemElement = function(item, contents) {
    var w;
    w = "<div id=\"" + item.id + "\" class=\"item draggable resizable\" style=\"position: absolute;top:" + item.itemSize.y + "px;left:" + item.itemSize.x + "px;width:" + item.itemSize.w + "px;height:" + item.itemSize.h + "px;z-index:" + (Common.plusPagingZindex(item.zindex)) + "\"><div class=\"item_wrapper\"><div class='item_contents'></div></div></div>";
    return $(contents).wrap(w).closest('.item');
  };

  Common.focusToTarget = function(target, callback, immediate) {
    var diff;
    if (callback == null) {
      callback = null;
    }
    if (immediate == null) {
      immediate = false;
    }
    if ((target == null) || target.length === 0) {
      return;
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

  Common.getClassFromMap = function(dist) {
    var d;
    if (window.classMap == null) {
      window.classMap = {};
    }
    d = dist;
    if (typeof d !== "string") {
      d = String(dist);
    }
    return window.classMap[d];
  };

  Common.setClassToMap = function(dist, value) {
    var d;
    d = dist;
    if (typeof d !== "string") {
      d = String(dist);
    }
    if (window.classMap == null) {
      window.classMap = {};
    }
    return window.classMap[d] = value;
  };

  Common.getContentClass = function(classDistToken) {
    var cls;
    cls = this.getClassFromMap(classDistToken);
    if (cls.prototype instanceof CommonEvent) {
      return cls.PrivateClass;
    } else {
      return cls;
    }
  };

  Common.getInstanceFromMap = function(id, classDistToken) {
    if (typeof id !== "string") {
      id = String(id);
    }
    Common.setInstanceFromMap(id, classDistToken);
    return window.instanceMap[id];
  };

  Common.setInstanceFromMap = function(id, classDistToken) {
    var instance, obj;
    if (typeof id !== "string") {
      id = String(id);
    }
    if (window.instanceMap == null) {
      window.instanceMap = {};
    }
    if (window.instanceMap[id] == null) {
      instance = new (Common.getClassFromMap(classDistToken))();
      instance.id = id;
      obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(id));
      if (obj) {
        instance.setMiniumObject(obj);
      }
      return window.instanceMap[id] = instance;
    }
  };

  Common.allItemInstances = function() {
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

  Common.updateAllEventsToBefore = function(callback) {
    var _updateEventBefore, forkNum, i, j, ref, self, tesArray;
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
    _updateEventBefore = function() {
      var idx, item, l, len, m, ref1, results, te, tes;
      results = [];
      for (l = 0, len = tesArray.length; l < len; l++) {
        tes = tesArray[l];
        for (idx = m = ref1 = tes.length - 1; m >= 0; idx = m += -1) {
          te = tes[idx];
          item = window.instanceMap[te.id];
          if (item != null) {
            item.initEvent(te);
            item.updateEventBefore();
          }
        }
        if (callback != null) {
          results.push(callback());
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    if (window.isWorkTable) {
      return WorktableCommon.stopAllEventPreview((function(_this) {
        return function() {
          return _updateEventBefore.call(_this);
        };
      })(this));
    } else {
      return _updateEventBefore.call(this);
    }
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

  Common.displayLastUpdateDiffAlmostTime = function(update_at) {
    var d, lastSaveTime, n;
    if (update_at == null) {
      update_at = null;
    }
    lastSaveTime = update_at != null ? update_at : PageValue.getGeneralPageValue(PageValue.Key.LAST_SAVE_TIME);
    if (lastSaveTime != null) {
      n = $.now();
      d = new Date(lastSaveTime);
      return Common.displayDiffAlmostTime(n, d.getTime());
    } else {
      return null;
    }
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
    var item, items, j, k, len, ref, results, v;
    if (pageNum == null) {
      pageNum = null;
    }
    if (pageNum != null) {
      items = this.instancesInPage(pageNum);
      results = [];
      for (j = 0, len = items.length; j < len; j++) {
        item = items[j];
        if (item != null) {
          if (item instanceof CommonEventBase) {
            CommonEvent.deleteInstance(item.id);
          } else {
            item.removeItemElement();
          }
          results.push(delete window.instanceMap[item.id]);
        } else {
          results.push(void 0);
        }
      }
      return results;
    } else {
      ref = Common.allItemInstances();
      for (k in ref) {
        v = ref[k];
        if (v != null) {
          v.removeItemElement();
        }
      }
      window.instanceMap = {};
      return CommonEvent.deleteAllInstance();
    }
  };

  Common.loadItemJs = function(classDistTokens, callback) {
    var callbackCount, classDistToken, data, j, len, needReadclassDistTokens;
    if (callback == null) {
      callback = null;
    }
    if (jQuery.type(classDistTokens) !== "array") {
      classDistTokens = [classDistTokens];
    }
    classDistTokens = $.grep(classDistTokens, function(n) {
      return window.itemInitFuncList[n] == null;
    });
    if (classDistTokens.length === 0) {
      if (callback != null) {
        callback();
      }
      return;
    }
    callbackCount = 0;
    needReadclassDistTokens = [];
    for (j = 0, len = classDistTokens.length; j < len; j++) {
      classDistToken = classDistTokens[j];
      if (classDistToken != null) {
        if (window.itemInitFuncList[classDistToken] != null) {
          window.itemInitFuncList[classDistToken]();
          callbackCount += 1;
          if (callbackCount >= classDistTokens.length) {
            if (callback != null) {
              callback();
            }
            return;
          }
        } else {
          needReadclassDistTokens.push(classDistToken);
        }
      } else {
        callbackCount += 1;
      }
    }
    data = {};
    data[Constant.ItemGallery.Key.ITEM_GALLERY_ACCESS_TOKEN] = needReadclassDistTokens;
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
            return Common.availJs(d.class_dist_token, d.js_src, option, (function(_this) {
              return function() {
                PageValue.addItemInfo(d.class_dist_token);
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
    var k, needclassDistTokens, obj, pageValues;
    if (callback == null) {
      callback = null;
    }
    if (pageNum == null) {
      pageNum = PageValue.getPageNum();
    }
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum));
    needclassDistTokens = [];
    for (k in pageValues) {
      obj = pageValues[k];
      if (obj.value.id.indexOf(ItemBase.ID_PREFIX) === 0) {
        if ($.inArray(obj.value.classDistToken, needclassDistTokens) < 0) {
          needclassDistTokens.push(obj.value.classDistToken);
        }
      }
    }
    return this.loadItemJs(needclassDistTokens, function() {
      if (callback != null) {
        return callback();
      }
    });
  };

  Common.availJs = function(classDistToken, jsSrc, option, callback) {
    var firstScript, s, t;
    if (option == null) {
      option = {};
    }
    if (callback == null) {
      callback = null;
    }
    window.loadedClassDistToken = classDistToken;
    s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = jsSrc;
    firstScript = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(s, firstScript);
    return t = setInterval(function() {
      if (window.itemInitFuncList[classDistToken] != null) {
        clearInterval(t);
        window.itemInitFuncList[classDistToken](option);
        window.loadedClassDistToken = null;
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
    _addItem = function(class_dist_token) {
      if (class_dist_token == null) {
        class_dist_token = null;
      }
      if (class_dist_token != null) {
        return PageValue.addItemInfo(class_dist_token);
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
      var classDistToken, option;
      classDistToken = d.class_dist_token;
      if (window.itemInitFuncList[classDistToken] != null) {
        window.itemInitFuncList[classDistToken]();
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
      return Common.availJs(classDistToken, d.js_src, option, function() {
        _addItem.call(this, classDistToken);
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
