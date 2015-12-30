// Generated by CoffeeScript 1.9.2
var EventBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventBase = (function(superClass) {
  var constant;

  extend(EventBase, superClass);

  EventBase.CLASS_DIST_TOKEN = "";

  EventBase.STEP_INTERVAL_DURATION = 0.01;

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    EventBase.BEFORE_MODIFY_VAR_SUFFIX = constant.BEFORE_MODIFY_VAR_SUFFIX;
    EventBase.AFTER_MODIFY_VAR_SUFFIX = constant.AFTER_MODIFY_VAR_SUFFIX;
    EventBase.ActionPropertiesKey = (function() {
      function ActionPropertiesKey() {}

      ActionPropertiesKey.TYPE = constant.ItemActionPropertiesKey.TYPE;

      ActionPropertiesKey.METHODS = constant.ItemActionPropertiesKey.METHODS;

      ActionPropertiesKey.DEFAULT_EVENT = constant.ItemActionPropertiesKey.DEFAULT_EVENT;

      ActionPropertiesKey.METHOD = constant.ItemActionPropertiesKey.METHOD;

      ActionPropertiesKey.DEFAULT_METHOD = constant.ItemActionPropertiesKey.DEFAULT_METHOD;

      ActionPropertiesKey.ACTION_TYPE = constant.ItemActionPropertiesKey.ACTION_TYPE;

      ActionPropertiesKey.SPECIFIC_METHOD_VALUES = constant.ItemActionPropertiesKey.SPECIFIC_METHOD_VALUES;

      ActionPropertiesKey.SCROLL_ENABLED_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_ENABLED_DIRECTION;

      ActionPropertiesKey.SCROLL_FORWARD_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_FORWARD_DIRECTION;

      ActionPropertiesKey.OPTIONS = constant.ItemActionPropertiesKey.OPTIONS;

      ActionPropertiesKey.EVENT_DURATION = constant.ItemActionPropertiesKey.EVENT_DURATION;

      ActionPropertiesKey.MODIFIABLE_VARS = constant.ItemActionPropertiesKey.MODIFIABLE_VARS;

      ActionPropertiesKey.MODIFIABLE_CHILDREN = constant.ItemActionPropertiesKey.MODIFIABLE_CHILDREN;

      ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE = constant.ItemActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE;

      return ActionPropertiesKey;

    })();
  }

  function EventBase() {
    var ref, value, varName;
    if ((this.constructor.actionProperties != null) && (this.constructor.actionPropertiesModifiableVars() != null)) {
      ref = this.constructor.actionPropertiesModifiableVars();
      for (varName in ref) {
        value = ref[varName];
        this[varName] = value["default"];
      }
    }
  }

  EventBase.prototype.refresh = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
  };

  EventBase.prototype.refreshFromInstancePageValue = function(show, callback) {
    var obj;
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('EventBase refreshWithEventBefore id:' + this.id);
    }
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
    if (obj) {
      this.setMiniumObject(obj);
    }
    return this.refresh(show, callback);
  };

  EventBase.prototype.initEvent = function(event) {
    this._event = event;
    this._isFinishedEvent = false;
    this._skipEvent = true;
    this._doPreviewLoop = false;
    this._enabledDirections = this._event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS];
    this._forwardDirections = this._event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS];
    this._specificMethodValues = this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES];
    if (this.getEventActionType() === Constant.ActionType.SCROLL) {
      return this.scrollEvent = this.scrollHandlerFunc;
    } else if (this.getEventActionType() === Constant.ActionType.CLICK) {
      return this.clickEvent = this.clickHandlerFunc;
    }
  };

  EventBase.prototype.getEventMethodName = function() {
    var methodName;
    if (this._event != null) {
      methodName = this._event[EventPageValueBase.PageValueKey.METHODNAME];
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
    if (this._event != null) {
      return this._event[EventPageValueBase.PageValueKey.ACTIONTYPE];
    }
  };

  EventBase.prototype.getChangeForkNum = function() {
    var num;
    if (this._event != null) {
      num = this._event[EventPageValueBase.PageValueKey.CHANGE_FORKNUM];
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
    this._isFinishedEvent = false;
    return this._skipEvent = false;
  };

  EventBase.prototype.preview = function(event, loopFinishCallback) {
    var _preview;
    if (loopFinishCallback == null) {
      loopFinishCallback = null;
    }
    if (window.runDebug) {
      console.log('EventBase preview id:' + this.id);
    }
    _preview = function(event) {
      var _draw, _loop, drawDelay, loopCount, loopDelay, loopMaxCount, p, progressMax;
      this._runningPreview = true;
      drawDelay = this.constructor.STEP_INTERVAL_DURATION * 1000;
      loopDelay = 1000;
      loopMaxCount = 5;
      progressMax = this.progressMax();
      this.willChapter();
      this._doPreviewLoop = true;
      loopCount = 0;
      this._previewTimer = null;
      FloatView.show(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW);
      if (!this.isDrawByAnimationMethod()) {
        p = 0;
        _draw = (function(_this) {
          return function() {
            if (_this._doPreviewLoop) {
              if (_this._previewTimer != null) {
                clearTimeout(_this._previewTimer);
                _this._previewTimer = null;
              }
              return _this._previewTimer = setTimeout(function() {
                if (_this._runningPreview) {
                  _this.execMethod({
                    isPreview: true,
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
                }
              }, drawDelay);
            } else {
              return _this.stopPreview(loopFinishCallback);
            }
          };
        })(this);
        _loop = (function(_this) {
          return function() {
            if (_this._doPreviewLoop) {
              loopCount += 1;
              if (loopCount >= loopMaxCount) {
                _this.stopPreview(loopFinishCallback);
              }
              if (_this._previewTimer != null) {
                clearTimeout(_this._previewTimer);
                _this._previewTimer = null;
              }
              _this._previewTimer = setTimeout(function() {
                if (_this._runningPreview) {
                  _this.resetEvent();
                  return _draw.call(_this);
                }
              }, loopDelay);
              if (!_this._doPreviewLoop) {
                return _this.stopPreview(loopFinishCallback);
              }
            } else {
              return _this.stopPreview(loopFinishCallback);
            }
          };
        })(this);
        return _draw.call(this);
      } else {
        _loop = (function(_this) {
          return function() {
            if (_this._doPreviewLoop) {
              loopCount += 1;
              if (loopCount >= loopMaxCount) {
                _this.stopPreview(loopFinishCallback);
              }
              if (_this._previewTimer != null) {
                clearTimeout(_this._previewTimer);
                _this._previewTimer = null;
              }
              return _this._previewTimer = setTimeout(function() {
                if (_this._runningPreview) {
                  _this.resetEvent();
                  return _this.execMethod({
                    isPreview: true,
                    complete: _loop
                  });
                }
              }, loopDelay);
            } else {
              return _this.stopPreview(loopFinishCallback);
            }
          };
        })(this);
        return this.execMethod({
          isPreview: true,
          complete: _loop
        });
      }
    };
    return this.stopPreview(loopFinishCallback, (function(_this) {
      return function() {
        return _preview.call(_this, event);
      };
    })(this));
  };

  EventBase.prototype.stopPreview = function(loopFinishCallback, callback) {
    if (loopFinishCallback == null) {
      loopFinishCallback = null;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('EventBase stopPreview id:' + this.id);
    }
    if ((this._runningPreview == null) || !this._runningPreview) {
      if (callback != null) {
        callback(false);
      }
      return;
    }
    this._runningPreview = false;
    return (function(_this) {
      return function() {
        if (_this._previewTimer != null) {
          clearTimeout(_this._previewTimer);
          FloatView.hide();
          _this._previewTimer = null;
        }
        if (loopFinishCallback != null) {
          loopFinishCallback();
        }
        if (callback != null) {
          return callback(true);
        }
      };
    })(this)();
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
    PageValue.saveInstanceObjectToFootprint(this.id, true, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
    this.updateEventBefore();
    return this.setModifyBeforeAndAfterVar();
  };

  EventBase.prototype.didChapter = function() {
    var k, v;
    for (k in this) {
      v = this[k];
      if (k.lastIndexOf('__Cache') >= 0) {
        delete this[k];
      }
    }
    return PageValue.saveInstanceObjectToFootprint(this.id, false, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
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
    if (this._isFinishedEvent || this._skipEvent) {
      return;
    }
    if (window.eventAction != null) {
      window.eventAction.thisPage().thisChapter().doMoveChapter = true;
    }
    plusX = 0;
    plusY = 0;
    if (x > 0 && this._enabledDirections.right) {
      plusX = parseInt((x + 9) / 10);
    } else if (x < 0 && this._enabledDirections.left) {
      plusX = parseInt((x - 9) / 10);
    }
    if (y > 0 && this._enabledDirections.bottom) {
      plusY = parseInt((y + 9) / 10);
    } else if (y < 0 && this._enabledDirections.top) {
      plusY = parseInt((y - 9) / 10);
    }
    if ((plusX > 0 && !this._forwardDirections.right) || (plusX < 0 && this._forwardDirections.left)) {
      plusX = -plusX;
    }
    if ((plusY > 0 && !this._forwardDirections.bottom) || (plusY < 0 && this._forwardDirections.top)) {
      plusY = -plusY;
    }
    this.scrollValue += plusX + plusY;
    sPoint = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
    ePoint = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]);
    if (this.scrollValue < sPoint) {
      return;
    } else if (this.scrollValue >= ePoint) {
      this.scrollValue = ePoint;
      if (!this._isFinishedEvent) {
        if (!this.isDrawByAnimationMethod()) {
          this._isFinishedEvent = true;
          ScrollGuide.hideGuide();
          if (complete != null) {
            complete();
          }
        } else {
          this._skipEvent = true;
          this.execMethod({
            isPreview: false,
            complete: function() {
              this._isFinishedEvent = true;
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
        isPreview: false,
        progress: this.scrollValue - sPoint,
        progressMax: this.progressMax()
      });
    }
  };

  EventBase.prototype.scrollLength = function() {
    return parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
  };

  EventBase.prototype.clickHandlerFunc = function(e, complete) {
    var count, progressMax, timer;
    if (complete == null) {
      complete = null;
    }
    e.preventDefault();
    if (this._isFinishedEvent || this._skipEvent) {
      return;
    }
    this._skipEvent = true;
    if (window.eventAction != null) {
      window.eventAction.thisPage().thisChapter().doMoveChapter = true;
    }
    if (!this.isDrawByAnimationMethod()) {
      progressMax = this.progressMax();
      count = 1;
      return timer = setInterval((function(_this) {
        return function() {
          _this.execMethod({
            isPreview: false,
            progress: count,
            progressMax: progressMax
          });
          count += 1;
          if (progressMax < count) {
            clearInterval(timer);
            _this._isFinishedEvent = true;
            if (complete != null) {
              return complete();
            }
          }
        };
      })(this), this.constructor.STEP_INTERVAL_DURATION * 1000);
    } else {
      return this.execMethod({
        isPreview: false,
        complete: function() {
          this._isFinishedEvent = true;
          if (complete != null) {
            return complete();
          }
        }
      });
    }
  };

  EventBase.prototype.getMinimumObjectEventBefore = function() {
    var diff, obj;
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(this._event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
    return $.extend(true, obj, diff);
  };

  EventBase.prototype.updateEventBefore = function() {
    var actionType;
    if (this._event == null) {
      return;
    }
    if (window.runDebug) {
      console.log('EventBase updateEventBefore id:' + this.id);
    }
    this.setMiniumObject(this.getMinimumObjectEventBefore());
    actionType = this.getEventActionType();
    if (actionType === Constant.ActionType.SCROLL) {
      return this.scrollValue = 0;
    }
  };

  EventBase.prototype.updateEventAfter = function() {
    var actionType;
    if (this._event == null) {
      return;
    }
    if (window.runDebug) {
      console.log('EventBase updateEventAfter id:' + this.id);
    }
    actionType = this.getEventActionType();
    if (actionType === Constant.ActionType.SCROLL) {
      this.scrollValue = this.scrollLength();
    }
    if (!this.isDrawByAnimationMethod()) {
      this.updateInstanceParamByStep(null, true);
    } else {
      this.updateInstanceParamByAnimation(true);
    }
    return PageValue.saveInstanceObjectToFootprint(this.id, false, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
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
    mod = this.constructor.actionPropertiesModifiableVars(this.getEventMethodName());
    results = [];
    for (varName in mod) {
      value = mod[varName];
      if ((this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
        before = eventBeforeObj[varName];
        after = this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
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
                  colorType = this.constructor.actionPropertiesModifiableVars()[varName].colorType;
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
    mod = this.constructor.actionPropertiesModifiableVars(this.getEventMethodName());
    if (immediate) {
      for (varName in mod) {
        value = mod[varName];
        if ((this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
          after = this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
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
          if ((_this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (_this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
            before = eventBeforeObj[varName];
            after = _this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
            if ((before != null) && (after != null)) {
              if (value.varAutoChange) {
                if (value.type === Constant.ItemDesignOptionType.NUMBER) {
                  _this[varName] = before + (after - before) * progressPercentage;
                } else if (value.type === Constant.ItemDesignOptionType.COLOR) {
                  colorCacheVarName = varName + "ColorChange__Cache";
                  if (_this[colorCacheVarName] == null) {
                    colorType = _this.constructor.actionPropertiesModifiableVars()[varName].colorType;
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
            if ((_this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (_this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
              after = _this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
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

  EventBase.prototype.setModifyBeforeAndAfterVar = function() {
    var afterObj, beforeObj, mod, results, value, varName;
    if (this._event == null) {
      return;
    }
    beforeObj = this.getMinimumObjectEventBefore();
    mod = this.constructor.actionPropertiesModifiableVars(this.getEventMethodName());
    results = [];
    for (varName in mod) {
      value = mod[varName];
      if (beforeObj != null) {
        this[varName + this.constructor.BEFORE_MODIFY_VAR_SUFFIX] = beforeObj[varName];
      }
      if (this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) {
        afterObj = this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
        if (afterObj != null) {
          results.push(this[varName + this.constructor.AFTER_MODIFY_VAR_SUFFIX] = afterObj);
        } else {
          results.push(void 0);
        }
      } else {
        results.push(void 0);
      }
    }
    return results;
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
    if (this._event[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.SCROLL) {
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
    d = this._event[EventPageValueBase.PageValueKey.EVENT_DURATION];
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

  EventBase.initSpecificConfig = function(specificRoot) {};

  EventBase.actionPropertiesModifiableVars = function(methodName, isDefault) {
    var k, modifiableRoot, ret, v;
    if (methodName == null) {
      methodName = null;
    }
    if (isDefault == null) {
      isDefault = false;
    }
    ret = {};
    if (methodName != null) {
      if (isDefault) {
        modifiableRoot = this.actionProperties[methodName][this.ActionPropertiesKey.MODIFIABLE_VARS];
      } else {
        modifiableRoot = this.actionProperties.methods[methodName][this.ActionPropertiesKey.MODIFIABLE_VARS];
      }
    } else {
      modifiableRoot = this.actionProperties[this.ActionPropertiesKey.MODIFIABLE_VARS];
    }
    if (modifiableRoot != null) {
      for (k in modifiableRoot) {
        v = modifiableRoot[k];
        ret[k] = v;
        if (v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN] != null) {
          ret = $.extend(ret, this.actionPropertiesModifiableVars(v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN]));
        }
      }
    }
    return ret;
  };

  return EventBase;

})(Extend);

//# sourceMappingURL=event_base.js.map
