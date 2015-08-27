// Generated by CoffeeScript 1.9.2
var Common;

Common = (function() {
  function Common() {}

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

  Common.focusToTarget = function(target) {
    var scrollLeft, scrollTop, targetMiddle;
    targetMiddle = {
      top: $(target).offset().top + $(target).height() * 0.5,
      left: $(target).offset().left + $(target).width() * 0.5
    };
    scrollTop = targetMiddle.top - scrollContents.height() * 0.5;
    if (scrollTop < 0) {
      scrollTop = 0;
    } else if (scrollTop > scrollContents.height() * 0.25) {
      scrollTop = scrollContents.height() * 0.25;
    }
    scrollLeft = targetMiddle.left - scrollContents.width() * 0.75 * 0.5;
    if (scrollLeft < 0) {
      scrollLeft = 0;
    } else if (scrollLeft > scrollContents.width() * 0.25) {
      scrollLeft = scrollContents.width() * 0.25;
    }
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

  Common.getCreatedItemObject = function() {
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

  Common.clearAllEventChange = function(callback) {
    var idx, item, j, previewinitCount, ref, results, te, tes;
    if (callback == null) {
      callback = null;
    }
    previewinitCount = 0;
    tes = PageValue.getEventPageValueSortedListByNum();
    if (tes.length <= 0) {
      if (callback != null) {
        callback();
        return;
      }
    }
    results = [];
    for (idx = j = ref = tes.length - 1; j >= 0; idx = j += -1) {
      te = tes[idx];
      item = window.instanceMap[te.id];
      if (item != null) {
        item.initWithEvent(te);
        results.push(item.stopPreview(function() {
          item.updateEventBefore();
          previewinitCount += 1;
          if (previewinitCount >= tes.length && (callback != null)) {
            return callback();
          }
        }));
      } else {
        previewinitCount += 1;
        if (previewinitCount >= tes.length && (callback != null)) {
          results.push(callback());
        } else {
          results.push(void 0);
        }
      }
    }
    return results;
  };

  Common.getActionTypeClassNameByActionType = function(actionType) {
    if (parseInt(actionType) === Constant.ActionEventHandleType.CLICK) {
      return Constant.ActionEventTypeClassName.CLICK;
    } else if (parseInt(actionType) === Constant.ActionEventHandleType.SCROLL) {
      return Constant.ActionEventTypeClassName.SCROLL;
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

  Common.diffTime = function(future, past) {
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

  Common.diffAlmostTime = function(future, past) {
    var day, diffTime, hours, minutes, month, ret, seconds, span, week, year;
    diffTime = this.diffTime(future, past);
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

  Common.showModalView = function(type) {
    var _centering, _show, emt, self;
    self = this;
    _centering = function() {
      var ch, content, cw, h, w;
      w = $(window).width();
      h = $(window).height();
      content = $("#modal-content");
      cw = content.outerWidth();
      ch = content.outerHeight();
      return content.css({
        "left": ((w - cw) / 2) + "px",
        "top": ((h - ch) / 2) + "px"
      });
    };
    _show = function() {
      $("body").append('<div id="modal-overlay"></div>');
      $("#modal-overlay").css('display', 'block');
      _centering.call(this);
      $("#modal-content").css('display', 'block');
      return $("#modal-overlay,#modal-close").unbind().click(function() {
        $("#modal-content,#modal-overlay").css('display', 'none');
        return $('#modal-overlay').remove();
      });
    };
    $(this).blur();
    if ($("#modal-overlay")[0] != null) {
      return false;
    }
    emt = $("#modal-content");
    if (emt[0] == null) {
      return $.ajax({
        url: "/modal_view/show",
        type: "GET",
        data: {
          type: type
        },
        dataType: "json",
        success: function(data) {
          $('body').append(data.modalHtml);
          return _show.call(self);
        },
        error: function(data) {}
      });
    } else {
      return _show.call(self);
    }
  };

  return Common;

})();

(function() {
  window.loadedClassList = {};
  return window.classMap = {};
})();

$(function() {
  window.drawingCanvas = document.getElementById('canvas_container');
  return window.drawingContext = drawingCanvas.getContext('2d');
});

//# sourceMappingURL=common.js.map
