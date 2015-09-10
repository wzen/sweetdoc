// Generated by CoffeeScript 1.9.2
var CommonEventBase, EventBase, ItemEventBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventBase = (function(superClass) {
  extend(EventBase, superClass);

  function EventBase() {
    return EventBase.__super__.constructor.apply(this, arguments);
  }

  EventBase.prototype.initEvent = function(event) {
    this.event = event;
    this.isFinishedEvent = false;
    this.doPreviewLoop = false;
    this.enabledDirections = this.event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS];
    this.forwardDirections = this.event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS];
    if (this.constructor.prototype[this.getEventMethodName()] == null) {
      return;
    }
    if (this.getEventActionType() === Constant.ActionEventHandleType.SCROLL) {
      return this.scrollEvent = this.scrollRootFunc;
    } else if (this.getEventActionType() === Constant.ActionEventHandleType.CLICK) {
      return this.clickEvent = this.clickRootFunc;
    }
  };

  EventBase.prototype.getEventMethodName = function() {
    if (this.event != null) {
      return this.event[EventPageValueBase.PageValueKey.METHODNAME];
    }
  };

  EventBase.prototype.getEventActionType = function() {
    if (this.event != null) {
      return this.event[EventPageValueBase.PageValueKey.ACTIONTYPE];
    }
  };

  EventBase.prototype.resetEvent = function() {
    this.updateEventBefore();
    return this.isFinishedEvent = false;
  };

  EventBase.prototype.forwardEvent = function() {
    return this.updateEventAfter();
  };

  EventBase.prototype.preview = function(event) {
    var _preview;
    _preview = function(event) {
      var _draw, _loop, actionType, drawDelay, loopCount, loopDelay, loopMaxCount, method, p;
      drawDelay = 30;
      loopDelay = 1000;
      loopMaxCount = 5;
      this.initEvent(event);
      this.willChapter();
      if (this instanceof CssItemBase) {
        this.appendCssIfNeeded();
      }
      method = this.constructor.prototype[this.getEventMethodName()];
      actionType = this.getEventActionType();
      this.doPreviewLoop = true;
      loopCount = 0;
      this.previewTimer = null;
      if (actionType === Constant.ActionEventHandleType.SCROLL) {
        p = 0;
        _draw = (function(_this) {
          return function() {
            if (_this.doPreviewLoop) {
              if (_this.previewTimer != null) {
                clearTimeout(_this.previewTimer);
                _this.previewTimer = null;
              }
              return _this.previewTimer = setTimeout(function() {
                method.call(_this, p);
                p += 1;
                if (p >= _this.scrollLength()) {
                  p = 0;
                  return _loop.call(_this);
                } else {
                  return _draw.call(_this);
                }
              }, drawDelay);
            } else {
              if (_this.previewFinished != null) {
                _this.previewFinished();
                return _this.previewFinished = null;
              }
            }
          };
        })(this);
        _loop = (function(_this) {
          return function() {
            if (_this.doPreviewLoop) {
              loopCount += 1;
              if (loopCount >= loopMaxCount) {
                _this.stopPreview();
              }
              if (_this.previewTimer != null) {
                clearTimeout(_this.previewTimer);
                _this.previewTimer = null;
              }
              _this.previewTimer = setTimeout(function() {
                return _draw.call(_this);
              }, loopDelay);
              if (!_this.doPreviewLoop) {
                return _this.stopPreview();
              }
            } else {
              if (_this.previewFinished != null) {
                _this.previewFinished();
                return _this.previewFinished = null;
              }
            }
          };
        })(this);
        return _draw.call(this);
      } else if (actionType === Constant.ActionEventHandleType.CLICK) {
        _loop = (function(_this) {
          return function() {
            if (_this.doPreviewLoop) {
              loopCount += 1;
              if (loopCount >= loopMaxCount) {
                _this.stopPreview();
              }
              if (_this.previewTimer != null) {
                clearTimeout(_this.previewTimer);
                _this.previewTimer = null;
              }
              return _this.previewTimer = setTimeout(function() {
                return method.call(_this, null, _loop);
              }, loopDelay);
            } else {
              if (_this.previewFinished != null) {
                _this.previewFinished();
                return _this.previewFinished = null;
              }
            }
          };
        })(this);
        return method.call(this, null, _loop);
      }
    };
    return this.stopPreview((function(_this) {
      return function() {
        return _preview.call(_this, event);
      };
    })(this));
  };

  EventBase.prototype.stopPreview = function(callback) {
    var _stop;
    if (callback == null) {
      callback = null;
    }
    _stop = function() {
      if (this.previewTimer != null) {
        clearTimeout(this.previewTimer);
        this.previewTimer = null;
      }
      if (callback != null) {
        return callback();
      }
    };
    if (this.doPreviewLoop) {
      this.doPreviewLoop = false;
      return this.previewFinished = (function(_this) {
        return function() {
          return _stop.call(_this);
        };
      })(this);
    } else {
      return _stop.call(this);
    }
  };

  EventBase.prototype.getJQueryElement = function() {
    return null;
  };

  EventBase.prototype.nextChapter = function() {
    if (window.eventAction != null) {
      return window.eventAction.thisPage().nextChapter();
    }
  };

  EventBase.prototype.willChapter = function() {
    var actionType;
    actionType = this.event[EventPageValueBase.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      this.scrollValue = 0;
    }
    return this.updateEventBefore();
  };

  EventBase.prototype.didChapter = function() {};

  EventBase.prototype.scrollRootFunc = function(x, y, complete) {
    var ePoint, methodName, plusX, plusY, sPoint;
    if (complete == null) {
      complete = null;
    }
    if (this.event[EventPageValueBase.PageValueKey.METHODNAME] == null) {
      return;
    }
    methodName = this.event[EventPageValueBase.PageValueKey.METHODNAME];
    if (this.isFinishedEvent) {
      return;
    }
    if (window.eventAction != null) {
      window.eventAction.thisPage().thisChapter().doMoveChapter = true;
    }
    plusX = 0;
    plusY = 0;
    if (x > 0 && this.enabledDirections.right) {
      plusX = parseInt((x + 9) / 10);
    } else if (x < 0 && this.enabledDirections.left) {
      plusX = parseInt((x - 9) / 10);
    }
    if (y > 0 && this.enabledDirections.bottom) {
      plusY = parseInt((y + 9) / 10);
    } else if (y < 0 && this.enabledDirections.top) {
      plusY = parseInt((y - 9) / 10);
    }
    if ((plusX > 0 && !this.forwardDirections.right) || (plusX < 0 && this.forwardDirections.left)) {
      plusX = -plusX;
    }
    if ((plusY > 0 && !this.forwardDirections.bottom) || (plusY < 0 && this.forwardDirections.top)) {
      plusY = -plusY;
    }
    this.scrollValue += plusX + plusY;
    sPoint = parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
    ePoint = parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]);
    if (this.scrollValue < sPoint) {
      this.scrollValue = sPoint;
      return;
    } else if (this.scrollValue >= ePoint) {
      this.scrollValue = ePoint;
      if (!this.isFinishedEvent) {
        this.isFinishedEvent = true;
        ScrollGuide.hideGuide();
        if (complete != null) {
          complete();
        }
      }
      return;
    }
    this.canForward = this.scrollValue < ePoint;
    this.canReverse = this.scrollValue > sPoint;
    return this.constructor.prototype[methodName].call(this, this.scrollValue - sPoint);
  };

  EventBase.prototype.scrollLength = function() {
    return parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
  };

  EventBase.prototype.clickRootFunc = function(e, complete) {
    var methodName;
    if (complete == null) {
      complete = null;
    }
    e.preventDefault();
    if (window.eventAction != null) {
      window.eventAction.thisPage().thisChapter().doMoveChapter = true;
    }
    methodName = this.event[EventPageValueBase.PageValueKey.METHODNAME];
    return this.constructor.prototype[methodName].call(this, e, complete);
  };

  EventBase.prototype.updateEventAfter = function() {};

  EventBase.prototype.updateEventBefore = function() {};

  EventBase.prototype.setItemAllPropToPageValue = function(isCache) {
    var obj, prefix_key;
    if (isCache == null) {
      isCache = false;
    }
    prefix_key = isCache ? PageValue.Key.instanceValueCache(this.id) : PageValue.Key.instanceValue(this.id);
    obj = this.getMinimumObject();
    return PageValue.setInstancePageValue(prefix_key, obj);
  };

  return EventBase;

})(Extend);

CommonEventBase = (function(superClass) {
  extend(CommonEventBase, superClass);

  function CommonEventBase() {
    return CommonEventBase.__super__.constructor.apply(this, arguments);
  }

  CommonEventBase.prototype.initEvent = function(event) {
    return CommonEventBase.__super__.initEvent.call(this, event);
  };

  return CommonEventBase;

})(EventBase);

ItemEventBase = (function(superClass) {
  extend(ItemEventBase, superClass);

  function ItemEventBase() {
    return ItemEventBase.__super__.constructor.apply(this, arguments);
  }

  ItemEventBase.prototype.initEvent = function(event) {
    var instance, objId;
    ItemEventBase.__super__.initEvent.call(this, event);
    objId = event[EventPageValueBase.PageValueKey.ID];
    instance = PageValue.getInstancePageValue(PageValue.Key.instanceValue(objId));
    this.setMiniumObject(instance);
    return this.reDraw(false);
  };

  ItemEventBase.prototype.setMiniumObject = function(obj) {};

  return ItemEventBase;

})(EventBase);

//# sourceMappingURL=event_base.js.map
