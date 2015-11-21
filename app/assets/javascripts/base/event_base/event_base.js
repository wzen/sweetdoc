// Generated by CoffeeScript 1.9.2
var EventBase,
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
    if (this.getEventActionType() === Constant.ActionType.SCROLL) {
      return this.scrollEvent = this.scrollHandlerFunc;
    } else if (this.getEventActionType() === Constant.ActionType.CLICK) {
      return this.clickEvent = this.clickHandlerFunc;
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

  EventBase.prototype.getChangeForkNum = function() {
    var num;
    if (this.event != null) {
      num = this.event[EventPageValueBase.PageValueKey.CHANGE_FORKNUM];
      if (num != null) {
        return parseInt(num);
      } else {
        return null;
      }
    } else {
      return null;
    }
  };

  EventBase.prototype.resetEvent = function() {
    this.willChapter();
    return this.isFinishedEvent = false;
  };

  EventBase.prototype.preview = function(event) {
    var _preview;
    _preview = function(event) {
      var _draw, _loop, actionType, drawDelay, loopCount, loopDelay, loopMaxCount, p;
      drawDelay = 30;
      loopDelay = 1000;
      loopMaxCount = 5;
      this.initEvent(event);
      this.willChapter();
      if (this instanceof CssItemBase) {
        this.appendAnimationCssIfNeeded();
      }
      actionType = this.getEventActionType();
      this.doPreviewLoop = true;
      loopCount = 0;
      this.previewTimer = null;
      FloatView.show(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW);
      if (actionType === Constant.ActionType.SCROLL) {
        p = 0;
        _draw = (function(_this) {
          return function() {
            if (_this.doPreviewLoop) {
              if (_this.previewTimer != null) {
                clearTimeout(_this.previewTimer);
                _this.previewTimer = null;
              }
              return _this.previewTimer = setTimeout(function() {
                _this.execMethod(p);
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
                _this.resetEvent();
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
      } else if (actionType === Constant.ActionType.CLICK) {
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
                _this.resetEvent();
                return _this.execMethod(null, _loop);
              }, loopDelay);
            } else {
              if (_this.previewFinished != null) {
                _this.previewFinished();
                return _this.previewFinished = null;
              }
            }
          };
        })(this);
        return this.execMethod(null, _loop);
      }
    };
    return this.stopPreview((function(_this) {
      return function() {
        window.runningPreview = true;
        return _preview.call(_this, event);
      };
    })(this));
  };

  EventBase.prototype.stopPreview = function(callback) {
    if (callback == null) {
      callback = null;
    }
    if (this.previewTimer != null) {
      clearTimeout(this.previewTimer);
      FloatView.hide();
      this.previewTimer = null;
      this.doPreviewLoop = false;
    }
    if (callback != null) {
      return callback();
    }
  };

  EventBase.prototype.getJQueryElement = function() {
    return null;
  };

  EventBase.prototype.nextChapter = function() {
    if (window.eventAction != null) {
      return window.eventAction.thisPage().progressChapter();
    }
  };

  EventBase.prototype.willChapter = function() {
    return this.updateEventBefore();
  };

  EventBase.prototype.didChapter = function() {
    return PageValue.saveInstanceObjectToFootprint(this.id, false, this.event[EventPageValueBase.PageValueKey.DIST_ID]);
  };

  EventBase.prototype.execMethod = function(params, complete) {
    var actionType, methodName;
    if (complete == null) {
      complete = null;
    }
    methodName = this.getEventMethodName();
    if (methodName == null) {
      return;
    }
    actionType = Common.getActionTypeByCodingActionType(this.constructor.actionProperties.methods[methodName].actionType);
    if (actionType === Constant.ActionType.SCROLL) {
      this.updateInstanceParamByScroll(params);
    } else if (actionType === Constant.ActionType.CLICK) {
      setTimeout((function(_this) {
        return function() {
          return _this.updateInstanceParamByClick();
        };
      })(this), 0);
    }
    return this.constructor.prototype[methodName].call(this, params, complete);
  };

  EventBase.prototype.scrollHandlerFunc = function(x, y, complete) {
    var ePoint, methodName, plusX, plusY, sPoint;
    if (complete == null) {
      complete = null;
    }
    methodName = this.getEventMethodName();
    if (methodName == null) {
      return;
    }
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
    return this.execMethod(this.scrollValue - sPoint);
  };

  EventBase.prototype.scrollLength = function() {
    return parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
  };

  EventBase.prototype.clickHandlerFunc = function(e, complete) {
    if (complete == null) {
      complete = null;
    }
    e.preventDefault();
    if (window.eventAction != null) {
      window.eventAction.thisPage().thisChapter().doMoveChapter = true;
    }
    return this.execMethod(e, complete);
  };

  EventBase.prototype.getMinimumObjectEventBefore = function() {
    var diff, obj;
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(this.event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
    return $.extend(true, obj, diff);
  };

  EventBase.prototype.updateEventBefore = function() {
    var actionType;
    this.setMiniumObject(this.getMinimumObjectEventBefore());
    actionType = this.getEventActionType();
    if (actionType === Constant.ActionType.SCROLL) {
      return this.scrollValue = 0;
    }
  };

  EventBase.prototype.updateEventAfter = function() {
    var actionType;
    actionType = Common.getActionTypeByCodingActionType(this.constructor.actionProperties.methods[this.getEventMethodName()].actionType);
    if (actionType === Constant.ActionType.SCROLL) {
      this.updateInstanceParamByScroll(null, true);
    } else if (actionType === Constant.ActionType.CLICK) {
      this.updateInstanceParamByClick(true);
    }
    return PageValue.saveInstanceObjectToFootprint(this.id, false, this.event[EventPageValueBase.PageValueKey.DIST_ID]);
  };

  EventBase.prototype.updateInstanceParamByScroll = function(scrollValue, immediate) {
    var after, before, colorCacheVarName, eventBeforeObj, mod, progressPercentage, results, value, varName;
    if (immediate == null) {
      immediate = false;
    }
    progressPercentage = scrollValue / this.scrollLength();
    eventBeforeObj = this.getMinimumObjectEventBefore();
    mod = this.constructor.actionProperties.methods[this.getEventMethodName()].modifiables;
    results = [];
    for (varName in mod) {
      value = mod[varName];
      if ((this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
        before = eventBeforeObj[varName];
        after = this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
        if ((before != null) && (after != null)) {
          if (immediate) {
            results.push(this[varName] = after);
          } else {
            if (value.varAutoChange) {
              if (value.type === Constant.ItemDesignOptionType.NUMBER) {
                results.push(this[varName] = before + (after - before) * progressPercentage);
              } else if (value.type === Constant.ItemDesignOptionType.COLOR) {
                colorCacheVarName = varName + "ColorChangeCache";
                if (this[colorCacheVarName] == null) {
                  this[colorCacheVarName] = Common.colorChangeCacheData(before, after, this.scrollLength());
                }
                results.push(this[varName] = this[colorCacheVarName][scrollValue]);
              } else {
                results.push(void 0);
              }
            } else {
              results.push(void 0);
            }
          }
        } else {
          results.push(void 0);
        }
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  EventBase.prototype.updateInstanceParamByClick = function(immediate) {
    var after, clickAnimationDuration, count, duration, eventBeforeObj, loopMax, mod, timer, value, varName;
    if (immediate == null) {
      immediate = false;
    }
    clickAnimationDuration = this.constructor.actionProperties.methods[this.getEventMethodName()].clickAnimationDuration;
    duration = 0.01;
    loopMax = Math.ceil(clickAnimationDuration / duration);
    eventBeforeObj = this.getMinimumObjectEventBefore();
    mod = this.constructor.actionProperties.methods[this.getEventMethodName()].modifiables;
    if (immediate) {
      for (varName in mod) {
        value = mod[varName];
        if ((this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
          after = this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
          if (after != null) {
            this[varName] = after;
          }
        }
      }
      return;
    }
    count = 1;
    return timer = setInterval((function(_this) {
      return function() {
        var before, colorCacheVarName, progressPercentage;
        progressPercentage = duration * count / clickAnimationDuration;
        for (varName in mod) {
          value = mod[varName];
          if ((_this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (_this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
            before = eventBeforeObj[varName];
            after = _this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
            if ((before != null) && (after != null)) {
              if (value.varAutoChange) {
                if (value.type === Constant.ItemDesignOptionType.NUMBER) {
                  _this[varName] = before + (after - before) * progressPercentage;
                } else if (value.type === Constant.ItemDesignOptionType.COLOR) {
                  colorCacheVarName = varName + "ColorChangeCache";
                  if (_this[colorCacheVarName] == null) {
                    _this[colorCacheVarName] = Common.colorChangeCacheData(before, after, loopMax);
                  }
                  _this[varName] = _this[colorCacheVarName][count];
                }
              }
            }
          }
        }
        if (count >= loopMax) {
          clearInterval(timer);
          for (varName in mod) {
            value = mod[varName];
            if ((_this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (_this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
              after = _this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
              if (after != null) {
                _this[varName] = after;
              }
            }
          }
        }
        return count += 1;
      };
    })(this), duration * 1000);
  };

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

//# sourceMappingURL=event_base.js.map
