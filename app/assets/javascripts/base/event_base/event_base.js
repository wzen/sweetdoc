// Generated by CoffeeScript 1.9.2
var EventBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventBase = (function(superClass) {
  extend(EventBase, superClass);

  function EventBase() {
    return EventBase.__super__.constructor.apply(this, arguments);
  }

  EventBase.STEP_INTERVAL_DURATION = 0.01;

  EventBase.prototype.initEvent = function(event) {
    this.event = event;
    this.isFinishedEvent = false;
    this.skipEvent = false;
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
    this.updateEventBefore();
    this.isFinishedEvent = false;
    return this.skipEvent = false;
  };

  EventBase.prototype.preview = function(event) {
    var _preview;
    _preview = function(event) {
      var _draw, _loop, drawDelay, loopCount, loopDelay, loopMaxCount, p, stepMax;
      drawDelay = this.constructor.STEP_INTERVAL_DURATION * 1000;
      loopDelay = 1000;
      loopMaxCount = 5;
      this.initEvent(event);
      stepMax = this.stepMax();
      this.willChapter();
      if (this instanceof CssItemBase) {
        this.appendAnimationCssIfNeeded();
      }
      this.doPreviewLoop = true;
      loopCount = 0;
      this.previewTimer = null;
      FloatView.show(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW);
      if (!this.isDrawByAnimationMethod()) {
        p = 0;
        _draw = (function(_this) {
          return function() {
            if (_this.doPreviewLoop) {
              if (_this.previewTimer != null) {
                clearTimeout(_this.previewTimer);
                _this.previewTimer = null;
              }
              return _this.previewTimer = setTimeout(function() {
                _this.execMethod({
                  step: p
                });
                p += 1;
                if (p >= stepMax) {
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
                _this.willChapter();
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
      } else {
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
                _this.willChapter();
                return _this.execMethod({
                  complete: _loop
                });
              }, loopDelay);
            } else {
              if (_this.previewFinished != null) {
                _this.previewFinished();
                return _this.previewFinished = null;
              }
            }
          };
        })(this);
        return this.execMethod({
          complete: _loop
        });
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
    var _stop;
    if (callback == null) {
      callback = null;
    }
    _stop = function() {
      if (this.previewTimer != null) {
        clearTimeout(this.previewTimer);
        FloatView.hide();
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
      return window.eventAction.thisPage().progressChapter();
    }
  };

  EventBase.prototype.willChapter = function() {
    return this.updateEventBefore();
  };

  EventBase.prototype.didChapter = function() {
    return PageValue.saveInstanceObjectToFootprint(this.id, false, this.event[EventPageValueBase.PageValueKey.DIST_ID]);
  };

  EventBase.prototype.execMethod = function(opt) {
    var methodName;
    methodName = this.getEventMethodName();
    if (methodName == null) {
      return;
    }
    if (!this.isDrawByAnimationMethod()) {
      this.updateInstanceParamByStep(opt.step);
    } else {
      setTimeout((function(_this) {
        return function() {
          return _this.updateInstanceParamByAnimation();
        };
      })(this), 0);
    }
    return this.constructor.prototype[methodName].call(this, opt);
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
    if (this.isFinishedEvent || this.skipEvent) {
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
      if (!this.isDrawByAnimationMethod() && !this.isFinishedEvent) {
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
    if (!this.isDrawByAnimationMethod()) {
      return this.execMethod({
        step: this.scrollValue - sPoint
      });
    } else {
      this.skipEvent = true;
      return this.execMethod({
        complete: function() {
          this.isFinishedEvent = true;
          ScrollGuide.hideGuide();
          if (complete != null) {
            return complete();
          }
        }
      });
    }
  };

  EventBase.prototype.scrollLength = function() {
    return parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
  };

  EventBase.prototype.clickHandlerFunc = function(e, complete) {
    var clickDuration, count, stepMax, timer;
    if (complete == null) {
      complete = null;
    }
    e.preventDefault();
    if (this.isFinishedEvent || this.skipEvent) {
      return;
    }
    this.skipEvent = true;
    if (window.eventAction != null) {
      window.eventAction.thisPage().thisChapter().doMoveChapter = true;
    }
    if (!this.isDrawByAnimationMethod()) {
      clickDuration = this.constructor.actionProperties.methods[this.getEventMethodName()][EventPageValueBase.PageValueKey.CLICK_DURATION];
      stepMax = this.stepMax();
      count = 1;
      return timer = setInterval((function(_this) {
        return function() {
          _this.execMethod({
            step: count
          });
          count += 1;
          if (stepMax < count) {
            clearInterval(timer);
            _this.isFinishedEvent = true;
            if (complete != null) {
              return complete();
            }
          }
        };
      })(this), this.constructor.STEP_INTERVAL_DURATION);
    } else {
      return this.execMethod({
        complete: complete
      });
    }
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
    if (!this.isDrawByAnimationMethod()) {
      this.updateInstanceParamByStep(null, true);
    } else {
      this.updateInstanceParamByAnimation(true);
    }
    return PageValue.saveInstanceObjectToFootprint(this.id, false, this.event[EventPageValueBase.PageValueKey.DIST_ID]);
  };

  EventBase.prototype.updateInstanceParamByStep = function(stepValue, immediate) {
    var after, before, colorCacheVarName, eventBeforeObj, mod, progressPercentage, results, stepMax, value, varName;
    if (immediate == null) {
      immediate = false;
    }
    stepMax = this.stepMax();
    if (stepMax == null) {
      stepMax = 1;
    }
    progressPercentage = stepValue / stepMax;
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
                  this[colorCacheVarName] = Common.colorChangeCacheData(before, after, stepMax);
                }
                results.push(this[varName] = this[colorCacheVarName][stepValue]);
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

  EventBase.prototype.updateInstanceParamByAnimation = function(immediate) {
    var after, clickDuration, count, eventBeforeObj, mod, stepMax, timer, value, varName;
    if (immediate == null) {
      immediate = false;
    }
    clickDuration = this.constructor.actionProperties.methods[this.getEventMethodName()][EventPageValueBase.PageValueKey.CLICK_DURATION];
    stepMax = this.stepMax();
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
        var before, colorCacheVarName, progressPercentage, results;
        progressPercentage = _this.constructor.STEP_INTERVAL_DURATION * count / clickDuration;
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
                    _this[colorCacheVarName] = Common.colorChangeCacheData(before, after, stepMax);
                  }
                  _this[varName] = _this[colorCacheVarName][count];
                }
              }
            }
          }
        }
        count += 1;
        if (count > stepMax) {
          clearInterval(timer);
          results = [];
          for (varName in mod) {
            value = mod[varName];
            if ((_this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (_this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
              after = _this.event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
              if (after != null) {
                results.push(_this[varName] = after);
              } else {
                results.push(void 0);
              }
            } else {
              results.push(void 0);
            }
          }
          return results;
        }
      };
    })(this), this.constructor.STEP_INTERVAL_DURATION * 1000);
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

  EventBase.prototype.isDrawByAnimationMethod = function() {
    return (this.constructor.actionProperties.methods[this.getEventMethodName()][EventPageValueBase.PageValueKey.IS_DRAW_BY_ANIMATION] != null) && this.constructor.actionProperties.methods[this.getEventMethodName()][EventPageValueBase.PageValueKey.IS_DRAW_BY_ANIMATION];
  };

  EventBase.prototype.stepMax = function() {
    var actionType;
    actionType = Common.getActionTypeByCodingActionType(this.constructor.actionProperties.methods[this.getEventMethodName()].actionType);
    if (actionType === Constant.ActionType.SCROLL) {
      return this.scrollLength();
    } else {
      return this.clickDurationStepMax();
    }
  };

  EventBase.prototype.clickDurationStepMax = function() {
    var clickDuration;
    clickDuration = this.constructor.actionProperties.methods[this.getEventMethodName()][EventPageValueBase.PageValueKey.CLICK_DURATION];
    return Math.ceil(clickDuration / this.constructor.STEP_INTERVAL_DURATION);
  };

  return EventBase;

})(Extend);

//# sourceMappingURL=event_base.js.map
