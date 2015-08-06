// Generated by CoffeeScript 1.9.2
var CommonEventListener, EventListener, ItemEventListener;

EventListener = {
  setEvent: function(timelineEvent) {
    this.timelineEvent = timelineEvent;
    this.isFinishedEvent = false;
    if (this.previewTimer != null) {
      clearInterval(this.previewTimer);
    }
    this.previewTimer = null;
    return this.setMethod();
  },
  setMethod: function() {
    var actionType, methodName;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
    if (this.constructor.prototype[methodName] == null) {
      return;
    }
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      return this.scrollEvent = this.scrollRootFunc;
    } else if (actionType === Constant.ActionEventHandleType.CLICK) {
      return this.clickEvent = this.constructor.prototype[methodName];
    }
  },
  reset: function() {
    this.isFinishedEvent = false;
  },
  preview: function(timelineEvent) {
    var _loop, actionType, func, p;
    this.setEvent(timelineEvent);
    actionType = timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      p = 0;
      return this.previewTimer = setInterval((function(_this) {
        return function() {
          _this.constructor.prototype[methodName](p);
          p += 1;
          if (p >= _this.scrollLength() - 1) {
            return p = 0;
          }
        };
      })(this), 500);
    } else if (actionType === Constant.ActionEventHandleType.CLICK) {
      _loop = function() {
        if (this.previewTimer != null) {
          return func(null, func);
        }
      };
      func = this.constructor.prototype[methodName];
      this.previewTimer = true;
      return func(null, _loop.call(this));
    }
  },
  getJQueryElement: function() {
    return null;
  },
  nextChapter: function() {
    if (window.timeLine != null) {
      return window.timeLine.nextChapter();
    }
  },
  willChapter: function(methodName) {
    var actionType;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      this.scrollValue = 0;
    }
  },
  didChapter: function(methodName) {},
  scrollRootFunc: function(x, y, complete) {
    var ePoint, methodName, sPoint;
    if (complete == null) {
      complete = null;
    }
    if (this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME] == null) {
      return;
    }
    methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
    if (this.isFinishedEvent) {
      return;
    }
    console.log("y:" + y);
    if (y >= 0) {
      this.scrollValue += parseInt((y + 9) / 10);
    } else {
      this.scrollValue += parseInt((y - 9) / 10);
    }
    sPoint = parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]);
    ePoint = parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]);
    if (this.scrollValue < sPoint || this.scrollValue > ePoint) {
      return;
    }
    this.scrollValue = this.scrollValue < sPoint ? sPoint : this.scrollValue;
    this.scrollValue = this.scrollValue >= ePoint ? ePoint - 1 : this.scrollValue;
    this.constructor.prototype[methodName].call(this, this.scrollValue - sPoint);
    if (this.scrollValue - sPoint >= this.scrollLength() - 1) {
      this.isFinishedEvent = true;
      if (complete != null) {
        return complete();
      }
    }
  },
  scrollLength: function() {
    return parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]);
  },
  cssElement: function(methodName) {
    return null;
  },
  appendCssIfNeeded: function(methodName) {
    var ce, funcName;
    ce = this.cssElement(methodName);
    if (ce != null) {
      this.removeCss(methodName);
      funcName = methodName + "_" + this.id;
      return window.cssCode.append("<div class='" + funcName + "'><style type='text/css'> " + ce + " </style></div>");
    }
  },
  removeCss: function(methodName) {
    var funcName;
    funcName = methodName + "_" + this.id;
    return window.cssCode.find("." + funcName).remove();
  },
  clearPaging: function(methodName) {
    return this.removeCss(methodName);
  }
};

CommonEventListener = {
  initWithEvent: function(timelineEvent) {}
};

ItemEventListener = {
  initWithEvent: function(timelineEvent) {
    return this.setMiniumObject(timelineEvent[TLEItemChange.minObj]);
  },
  setMiniumObject: function(obj) {}
};

//# sourceMappingURL=event_listener.js.map
