// Generated by CoffeeScript 1.9.2
var CommonEventListener, EventListener, ItemEventListener,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventListener = (function(superClass) {
  extend(EventListener, superClass);

  function EventListener() {
    return EventListener.__super__.constructor.apply(this, arguments);
  }

  EventListener.prototype.setEvent = function(timelineEvent) {
    this.timelineEvent = timelineEvent;
    this.isFinishedEvent = false;
    this.doPreviewLoop = false;
    return this.setMethod();
  };

  EventListener.prototype.setMethod = function() {
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
  };

  EventListener.prototype.reset = function() {
    this.isFinishedEvent = false;
  };

  EventListener.prototype.preview = function(timelineEvent) {
    var _draw, _loop, actionType, drawDelay, loopCount, loopDelay, loopMaxCount, method, methodName, p;
    this.setEvent(timelineEvent);
    this.stopPreview(timelineEvent);
    drawDelay = 30;
    loopDelay = 1000;
    loopMaxCount = 5;
    methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
    this.appendCssIfNeeded(methodName);
    method = this.constructor.prototype[methodName];
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    this.doPreviewLoop = true;
    loopCount = 0;
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      p = 0;
      _draw = (function(_this) {
        return function() {
          return setTimeout(function() {
            if (_this.doPreviewLoop) {
              method.call(_this, p);
              p += 1;
              if (p >= _this.scrollLength()) {
                p = 0;
                return _loop.call(_this);
              } else {
                return _draw.call(_this);
              }
            }
          }, drawDelay);
        };
      })(this);
      _loop = (function(_this) {
        return function() {
          loopCount += 1;
          if (loopCount >= loopMaxCount) {
            _this.stopPreview(timelineEvent);
          }
          return setTimeout(function() {
            if (_this.doPreviewLoop) {
              return _draw.call(_this);
            }
          }, loopDelay);
        };
      })(this);
      return _draw.call(this);
    } else if (actionType === Constant.ActionEventHandleType.CLICK) {
      _loop = (function(_this) {
        return function() {
          loopCount += 1;
          if (loopCount >= loopMaxCount) {
            _this.stopPreview(timelineEvent);
          }
          return setTimeout(function() {
            if (_this.doPreviewLoop) {
              return method.call(_this, null, _loop);
            }
          }, loopDelay);
        };
      })(this);
      return method.call(this, null, _loop);
    }
  };

  EventListener.prototype.stopPreview = function(timelineEvent) {
    var actionType;
    this.doPreviewLoop = false;
    actionType = timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      return this.restoreAllNewDrawedSurface();
    }
  };

  EventListener.prototype.getJQueryElement = function() {
    return null;
  };

  EventListener.prototype.nextChapter = function() {
    if (window.timeLine != null) {
      return window.timeLine.nextChapter();
    }
  };

  EventListener.prototype.willChapter = function(methodName) {
    var actionType;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      this.scrollValue = 0;
    }
  };

  EventListener.prototype.didChapter = function(methodName) {};

  EventListener.prototype.scrollRootFunc = function(x, y, complete) {
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
  };

  EventListener.prototype.scrollLength = function() {
    return parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]);
  };

  EventListener.prototype.cssElement = function(methodName) {
    return null;
  };

  EventListener.prototype.appendCssIfNeeded = function(methodName) {
    var ce, funcName;
    ce = this.cssElement(methodName);
    if (ce != null) {
      this.removeCss(methodName);
      funcName = methodName + "_" + this.id;
      return window.cssCode.append("<div class='" + funcName + "'><style type='text/css'> " + ce + " </style></div>");
    }
  };

  EventListener.prototype.removeCss = function(methodName) {
    var funcName;
    funcName = methodName + "_" + this.id;
    return window.cssCode.find("." + funcName).remove();
  };

  EventListener.prototype.updateEventAfter = function() {
    var actionType, methodName;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
      return this.constructor.prototype[methodName].call(this, this.scrollLength() - 1);
    } else if (actionType === Constant.ActionEventHandleType.CLICK) {
      return this.getJQueryElement().css({
        '-webkit-animation-duration': '0',
        '-moz-animation-duration': '-moz-animation-duration',
        '0': '0'
      });
    }
  };

  EventListener.prototype.updateEventBefore = function() {
    var actionType;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      return this.willChapter(this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME]);
    } else if (actionType === Constant.ActionEventHandleType.CLICK) {
      return this.getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration');
    }
  };

  EventListener.prototype.clearPaging = function(methodName) {
    return this.removeCss(methodName);
  };

  return EventListener;

})(Extend);

CommonEventListener = (function(superClass) {
  extend(CommonEventListener, superClass);

  function CommonEventListener() {
    return CommonEventListener.__super__.constructor.apply(this, arguments);
  }

  CommonEventListener.prototype.initWithEvent = function(timelineEvent) {};

  return CommonEventListener;

})(EventListener);

ItemEventListener = (function(superClass) {
  extend(ItemEventListener, superClass);

  function ItemEventListener() {
    return ItemEventListener.__super__.constructor.apply(this, arguments);
  }

  ItemEventListener.prototype.initWithEvent = function(timelineEvent) {
    return this.setMiniumObject(timelineEvent[TLEItemChange.minObj]);
  };

  ItemEventListener.prototype.setMiniumObject = function(obj) {};

  return ItemEventListener;

})(EventListener);

//# sourceMappingURL=event_listener.js.map
