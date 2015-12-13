// Generated by CoffeeScript 1.9.2
var EventBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventBase = (function(superClass) {
  extend(EventBase, superClass);

  EventBase.STEP_INTERVAL_DURATION = 0.01;

  function EventBase() {
    var ref, value, varName;
    if (this.constructor.actionProperties.modifiables != null) {
      ref = this.constructor.actionProperties.modifiables;
      for (varName in ref) {
        value = ref[varName];
        this[varName] = value["default"];
      }
    }
  }

  EventBase.prototype.initEvent = function(event) {
    this.event = event;
    this.isFinishedEvent = false;
    this.skipEvent = true;
    this.doPreviewLoop = false;
    this.enabledDirections = this.event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS];
    this.forwardDirections = this.event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS];
    if (this.getEventActionType() === Constant.ActionType.SCROLL) {
      return this.scrollEvent = this.scrollHandlerFunc;
    } else if (this.getEventActionType() === Constant.ActionType.CLICK) {
      return this.clickEvent = this.clickHandlerFunc;
    }
  };

  EventBase.prototype.getEventMethodName = function() {
    var methodName;
    if (this.event != null) {
      methodName = this.event[EventPageValueBase.PageValueKey.METHODNAME];
      if (methodName != null) {
        return methodName;
      } else {
        return EventPageValueBase.NO_METHOD;
      }
    } else {
      return EventPageValueBase.NO_METHOD;
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
      var _draw, _loop, drawDelay, loopCount, loopDelay, loopMaxCount, p, progressMax;
      drawDelay = this.constructor.STEP_INTERVAL_DURATION * 1000;
      loopDelay = 1000;
      loopMaxCount = 5;
      this.initEvent(event);
      progressMax = this.progressMax();
      this.willChapter();
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
                  progress: p,
                  progressMax: progressMax
                });
                p += 1;
                if (p >= progressMax) {
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
    var k, v;
    for (k in this) {
      v = this[k];
      if (k.lastIndexOf('__Cache') >= 0) {
        delete this[k];
      }
    }
    return PageValue.saveInstanceObjectToFootprint(this.id, false, this.event[EventPageValueBase.PageValueKey.DIST_ID]);
  };

  EventBase.prototype.execMethod = function(opt) {
    if (!this.isDrawByAnimationMethod()) {
      return this.updateInstanceParamByStep(opt.progress);
    } else {
      return setTimeout((function(_this) {
        return function() {
          return _this.updateInstanceParamByAnimation();
        };
      })(this), 0);
    }
  };

  EventBase.prototype.scrollHandlerFunc = function(x, y, complete) {
    var ePoint, plusX, plusY, sPoint;
    if (complete == null) {
      complete = null;
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
      if (!this.isFinishedEvent) {
        if (!this.isDrawByAnimationMethod()) {
          this.isFinishedEvent = true;
          ScrollGuide.hideGuide();
          if (complete != null) {
            complete();
          }
        } else {
          this.skipEvent = true;
          this.execMethod({
            complete: function() {
              this.isFinishedEvent = true;
              ScrollGuide.hideGuide();
              if (complete != null) {
                return complete();
              }
            }
          });
        }
      }
      return;
    }
    this.canForward = this.scrollValue < ePoint;
    this.canReverse = this.scrollValue > sPoint;
    if (!this.isDrawByAnimationMethod()) {
      return this.execMethod({
        progress: this.scrollValue - sPoint,
        progressMax: this.progressMax()
      });
    }
  };

  EventBase.prototype.scrollLength = function() {
    return parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
  };

  EventBase.prototype.clickHandlerFunc = function(e, complete) {
    var count, progressMax, timer;
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
      progressMax = this.progressMax();
      count = 1;
      return timer = setInterval((function(_this) {
        return function() {
          _this.execMethod({
            progress: count,
            progressMax: progressMax
          });
          count += 1;
          if (progressMax < count) {
            clearInterval(timer);
            _this.isFinishedEvent = true;
            if (complete != null) {
              return complete();
            }
          }
        };
      })(this), this.constructor.STEP_INTERVAL_DURATION * 1000);
    } else {
      return this.execMethod({
        complete: function() {
          this.isFinishedEvent = true;
          if (complete != null) {
            return complete();
          }
        }
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
    var actionType;
    actionType = this.getEventActionType();
    if (actionType === Constant.ActionType.SCROLL) {
      this.scrollValue = this.scrollLength();
    }
    if (!this.isDrawByAnimationMethod()) {
      this.updateInstanceParamByStep(null, true);
    } else {
      this.updateInstanceParamByAnimation(true);
    }
    return PageValue.saveInstanceObjectToFootprint(this.id, false, this.event[EventPageValueBase.PageValueKey.DIST_ID]);
  };

  EventBase.prototype.updateInstanceParamByStep = function(progressValue, immediate) {
    var after, before, colorCacheVarName, colorType, eventBeforeObj, mod, progressMax, progressPercentage, results, value, varName;
    if (immediate == null) {
      immediate = false;
    }
    if (this.getEventMethodName() === EventPageValueBase.NO_METHOD) {
      return;
    }
    progressMax = this.progressMax();
    if (progressMax == null) {
      progressMax = 1;
    }
    progressPercentage = progressValue / progressMax;
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
                colorCacheVarName = varName + "ColorChange__Cache";
                if (this[colorCacheVarName] == null) {
                  colorType = this.constructor.actionProperties.modifiables[varName].colorType;
                  if (colorType == null) {
                    colorType = 'hex';
                  }
                  this[colorCacheVarName] = Common.colorChangeCacheData(before, after, progressMax, colorType);
                }
                results.push(this[varName] = this[colorCacheVarName][progressValue]);
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
    var after, count, ed, eventBeforeObj, mod, progressMax, timer, value, varName;
    if (immediate == null) {
      immediate = false;
    }
    if (this.getEventMethodName() === EventPageValueBase.NO_METHOD) {
      return;
    }
    ed = this.eventDuration();
    progressMax = this.progressMax();
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
        var before, colorCacheVarName, colorType, progressPercentage, results;
        progressPercentage = _this.constructor.STEP_INTERVAL_DURATION * count / ed;
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
                  colorCacheVarName = varName + "ColorChange__Cache";
                  if (_this[colorCacheVarName] == null) {
                    colorType = _this.constructor.actionProperties.modifiables[varName].colorType;
                    if (colorType == null) {
                      colorType = 'hex';
                    }
                    _this[colorCacheVarName] = Common.colorChangeCacheData(before, after, progressMax, colorType);
                  }
                  _this[varName] = _this[colorCacheVarName][count];
                }
              }
            }
          }
        }
        count += 1;
        if (count > progressMax) {
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
    if (this.getEventMethodName() !== EventPageValueBase.NO_METHOD) {
      return (this.constructor.actionProperties.methods[this.getEventMethodName()][EventPageValueBase.PageValueKey.IS_DRAW_BY_ANIMATION] != null) && this.constructor.actionProperties.methods[this.getEventMethodName()][EventPageValueBase.PageValueKey.IS_DRAW_BY_ANIMATION];
    } else {
      return false;
    }
  };

  EventBase.prototype.progressMax = function() {
    if (this.event[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.SCROLL) {
      return this.scrollLength();
    } else {
      return this.clickDurationStepMax();
    }
  };

  EventBase.prototype.clickDurationStepMax = function() {
    var ed;
    ed = this.eventDuration();
    return Math.ceil(ed / this.constructor.STEP_INTERVAL_DURATION);
  };

  EventBase.prototype.eventDuration = function() {
    var d;
    d = this.event[EventPageValueBase.PageValueKey.EVENT_DURATION];
    if (d === 'undefined') {
      d = null;
    }
    return d;
  };

  EventBase.prototype.getMinimumObject = function() {
    var k, obj, v;
    obj = {};
    for (k in this) {
      v = this[k];
      if (v != null) {
        if (k.indexOf('_') !== 0 && (v instanceof ImageData) === false && !Common.isElement(v) && typeof v !== 'function') {
          obj[k] = Common.makeClone(v);
        }
      }
    }
    return obj;
  };

  EventBase.prototype.setMiniumObject = function(obj) {
    var k, v;
    delete window.instanceMap[this.id];
    for (k in obj) {
      v = obj[k];
      if (v != null) {
        if (k.indexOf('_') !== 0 && (v instanceof ImageData) === false && !Common.isElement(v) && typeof v !== 'function') {
          this[k] = Common.makeClone(v);
        }
      }
    }
    return window.instanceMap[this.id] = this;
  };

  return EventBase;

})(Extend);

//# sourceMappingURL=event_base.js.map
