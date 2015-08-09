// Generated by CoffeeScript 1.9.2
var CommonEventBase, EventBase, ItemEventBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventBase = (function(superClass) {
  extend(EventBase, superClass);

  function EventBase() {
    return EventBase.__super__.constructor.apply(this, arguments);
  }

  EventBase.prototype.initWithEvent = function(timelineEvent) {
    return this.setEvent(timelineEvent);
  };

  EventBase.prototype.setEvent = function(timelineEvent) {
    this.timelineEvent = timelineEvent;
    this.isFinishedEvent = false;
    this.doPreviewLoop = false;
    return this.setMethod();
  };

  EventBase.prototype.setMethod = function() {
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

  EventBase.prototype.reset = function() {
    this.isFinishedEvent = false;
  };

  EventBase.prototype.preview = function(timelineEvent) {
    var _draw, _loop, actionType, drawDelay, loopCount, loopDelay, loopMaxCount, method, methodName, p;
    drawDelay = 30;
    loopDelay = 1000;
    loopMaxCount = 5;
    methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
    this.initWithEvent(timelineEvent);
    this.willChapter(methodName);
    this.stopPreview(timelineEvent);
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

  EventBase.prototype.stopPreview = function(timelineEvent) {
    this.doPreviewLoop = false;
    if (this instanceof CanvasItemBase) {
      return this.restoreAllNewDrawedSurface();
    }
  };

  EventBase.prototype.getJQueryElement = function() {
    return null;
  };

  EventBase.prototype.nextChapter = function() {
    if (window.timeLine != null) {
      return window.timeLine.nextChapter();
    }
  };

  EventBase.prototype.willChapter = function(methodName) {
    var actionType;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      this.scrollValue = 0;
    }
  };

  EventBase.prototype.didChapter = function(methodName) {};

  EventBase.prototype.scrollRootFunc = function(x, y, complete) {
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
    this.scrollValue = this.scrollValue > ePoint ? ePoint : this.scrollValue;
    this.constructor.prototype[methodName].call(this, this.scrollValue - sPoint);
    if (this.scrollValue === ePoint) {
      this.isFinishedEvent = true;
      if (complete != null) {
        return complete();
      }
    }
  };

  EventBase.prototype.scrollLength = function() {
    return parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]);
  };

  EventBase.prototype.cssElement = function(methodName) {
    return null;
  };

  EventBase.prototype.appendCssIfNeeded = function(methodName) {
    var ce, funcName;
    ce = this.cssElement(methodName);
    if (ce != null) {
      this.removeCss(methodName);
      funcName = methodName + "_" + this.id;
      return window.cssCode.append("<div class='" + funcName + "'><style type='text/css'> " + ce + " </style></div>");
    }
  };

  EventBase.prototype.removeCss = function(methodName) {
    var funcName;
    funcName = methodName + "_" + this.id;
    return window.cssCode.find("." + funcName).remove();
  };

  EventBase.prototype.updateEventAfter = function() {
    var actionType, methodName;
    if (this instanceof CanvasItemBase) {
      return this.restoreAllNewDrawedSurface();
    } else if (this instanceof CssItemBase) {
      return this.getJQueryElement().css({
        '-webkit-animation-duration': '0',
        '-moz-animation-duration': '-moz-animation-duration',
        '0': '0'
      });
    } else if (this instanceof CommonEventBase) {
      actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
      if (actionType === Constant.ActionEventHandleType.SCROLL) {
        methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
        return this.constructor.prototype[methodName].call(this, this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]);
      } else if (actionType === Constant.ActionEventHandleType.CLICK) {

      }
    }
  };

  EventBase.prototype.updateEventBefore = function() {
    var actionType, methodName;
    if (this instanceof CanvasItemBase) {
      return this.restoreAllNewDrawingSurface();
    } else if (this instanceof CssItemBase) {
      return this.getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration');
    } else if (this instanceof CommonEventBase) {
      actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
      if (actionType === Constant.ActionEventHandleType.SCROLL) {
        methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
        return this.constructor.prototype[methodName].call(this, this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]);
      } else if (actionType === Constant.ActionEventHandleType.CLICK) {

      }
    }
  };

  EventBase.prototype.clearPaging = function(methodName) {
    return this.removeCss(methodName);
  };

  return EventBase;

})(Extend);

CommonEventBase = (function(superClass) {
  extend(CommonEventBase, superClass);

  function CommonEventBase() {
    return CommonEventBase.__super__.constructor.apply(this, arguments);
  }

  CommonEventBase.prototype.initWithEvent = function(timelineEvent) {
    return CommonEventBase.__super__.initWithEvent.call(this, timelineEvent);
  };

  return CommonEventBase;

})(EventBase);

ItemEventBase = (function(superClass) {
  extend(ItemEventBase, superClass);

  function ItemEventBase() {
    return ItemEventBase.__super__.constructor.apply(this, arguments);
  }

  ItemEventBase.prototype.initWithEvent = function(timelineEvent) {
    ItemEventBase.__super__.initWithEvent.call(this, timelineEvent);
    this.setMiniumObject(timelineEvent[TLEItemChange.minObj]);
    return this.reDraw(false);
  };

  ItemEventBase.prototype.setMiniumObject = function(obj) {};

  return ItemEventBase;

})(EventBase);

//# sourceMappingURL=event_base.js.map
