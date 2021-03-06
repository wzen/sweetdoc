// Generated by CoffeeScript 1.9.2
var EventBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventBase = (function(superClass) {
  var constant;

  extend(EventBase, superClass);

  EventBase.CLASS_DIST_TOKEN = "";

  EventBase.STEP_INTERVAL_DURATION = 0.01;

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

    ActionPropertiesKey.COLOR_TYPE = constant.ItemActionPropertiesKey.COLOR_TYPE;

    ActionPropertiesKey.SPECIFIC_METHOD_VALUES = constant.ItemActionPropertiesKey.SPECIFIC_METHOD_VALUES;

    ActionPropertiesKey.SCROLL_ENABLED_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_ENABLED_DIRECTION;

    ActionPropertiesKey.SCROLL_FORWARD_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_FORWARD_DIRECTION;

    ActionPropertiesKey.OPTIONS = constant.ItemActionPropertiesKey.OPTIONS;

    ActionPropertiesKey.EVENT_DURATION = constant.ItemActionPropertiesKey.EVENT_DURATION;

    ActionPropertiesKey.MODIFIABLE_VARS = constant.ItemActionPropertiesKey.MODIFIABLE_VARS;

    ActionPropertiesKey.MODIFIABLE_CHILDREN = constant.ItemActionPropertiesKey.MODIFIABLE_CHILDREN;

    ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE = constant.ItemActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE;

    ActionPropertiesKey.FINISH_WITH_HAND = constant.ItemActionPropertiesKey.FINISH_WITH_HAND;

    return ActionPropertiesKey;

  })();

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

  EventBase.prototype.changeInstanceVarByConfig = function(varName, value) {
    this[varName] = value;
    return this.clearAllCache();
  };

  EventBase.prototype.refresh = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (callback != null) {
      return callback();
    }
  };

  EventBase.prototype.isItemVisible = function() {
    var op;
    op = this.getJQueryElement().css('opacity');
    if (op.length > 0) {
      return parseInt(op) === 1;
    }
    return true;
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
    this._runningEvent = false;
    this._isScrollHeader = true;
    this._doPreviewLoop = false;
    this._handlerFuncComplete = null;
    this._enabledDirections = this._event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS];
    this._forwardDirections = this._event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS];
    return this._specificMethodValues = this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES];
  };

  EventBase.prototype.scrollEvent = function(x, y, complete) {
    if (complete == null) {
      complete = null;
    }
    if (this._handlerFuncComplete == null) {
      this._handlerFuncComplete = complete;
    }
    return this.scrollHandlerFunc(false, x, y);
  };

  EventBase.prototype.clickEvent = function(e, complete) {
    if (complete == null) {
      complete = null;
    }
    if (this._handlerFuncComplete == null) {
      this._handlerFuncComplete = complete;
    }
    return this.clickHandlerFunc(false, e);
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

  EventBase.prototype.initPreview = function() {};

  EventBase.prototype.preview = function(loopFinishCallback) {
    this.loopFinishCallback = loopFinishCallback != null ? loopFinishCallback : null;
    if (window.runDebug) {
      console.log('EventBase preview id:' + this.id);
    }
    return this.stopPreview((function(_this) {
      return function() {
        _this._runningPreview = true;
        _this.initPreview();
        return _this.willChapter(function() {
          _this._doPreviewLoop = false;
          _this._skipEvent = false;
          _this._loopCount = 0;
          _this._previewTimer = null;
          _this._runningEvent = false;
          FloatView.showWithCloseButton(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW, function() {
            if (_this.loopFinishCallback != null) {
              return _this.loopFinishCallback();
            }
          }, true);
          _this._progress = 0;
          if (window.debug) {
            console.log('start previewStepDraw');
          }
          return _this.previewStepDraw();
        });
      };
    })(this));
  };

  EventBase.prototype.previewStepDraw = function() {
    if (!this._skipEvent) {
      this._stepLoopCount = 0;
      if (this.getEventActionType() === constant.ActionType.SCROLL) {
        if (this._previewTimer != null) {
          clearTimeout(this._previewTimer);
          this._previewTimer = null;
        }
        return this._previewTimer = setTimeout((function(_this) {
          return function() {
            if (_this._progress + Constant.EventBase.PREVIEW_STEP > _this.progressMax()) {
              _this._doPreviewLoop = false;
              clearTimeout(_this._previewTimer);
              _this._previewTimer = null;
            }
            _this.scrollHandlerFunc(true);
            if (_this._progress + Constant.EventBase.PREVIEW_STEP > _this.progressMax()) {
              if (!_this.isFinishedWithHand()) {
                return _this.finishEvent();
              }
            } else {
              _this._progress += Constant.EventBase.PREVIEW_STEP;
              if (_this._progress > _this.progressMax()) {
                _this._progress = _this.progressMax();
              }
              return _this.previewStepDraw();
            }
          };
        })(this), this.constructor.STEP_INTERVAL_DURATION * 1000);
      } else if (this.getEventActionType() === constant.ActionType.CLICK) {
        this.clickHandlerFunc(true);
        return this._doPreviewLoop = false;
      }
    } else if (!this._isFinishedEvent && ((this._stepLoopCount == null) || this._stepLoopCount < 20)) {
      if (this._stepLoopCount == null) {
        this._stepLoopCount = 0;
      }
      return setTimeout((function(_this) {
        return function() {
          _this._stepLoopCount += 1;
          return _this.previewStepDraw();
        };
      })(this), 300);
    }
  };

  EventBase.prototype.previewLoop = function() {
    var loopDelay, loopMaxCount;
    if (this._doPreviewLoop) {
      return;
    }
    loopDelay = 1000;
    loopMaxCount = 3;
    this._doPreviewLoop = true;
    this._loopCount += 1;
    if (window.debug) {
      console.log('_loopCount:' + this._loopCount);
    }
    if (this._loopCount >= loopMaxCount) {
      this.stopPreview();
      if (this.loopFinishCallback != null) {
        this.loopFinishCallback();
        this.loopFinishCallback = null;
      }
    }
    if (this._previewTimer != null) {
      clearTimeout(this._previewTimer);
      this._previewTimer = null;
    }
    return this._previewTimer = setTimeout((function(_this) {
      return function() {
        if (_this._runningPreview) {
          _this.updateEventBefore();
          return _this.refresh(_this.visible, function() {
            return _this.willChapter(function() {
              _this._progress = 0;
              return _this.previewStepDraw();
            });
          });
        }
      };
    })(this), loopDelay);
  };

  EventBase.prototype.stopPreview = function(callback) {
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
    if (this._previewTimer != null) {
      clearTimeout(this._previewTimer);
      FloatView.hide();
      this._previewTimer = null;
    }
    if (this._clickIntervalTimer != null) {
      clearInterval(this._clickIntervalTimer);
      this._clickIntervalTimer = null;
    }
    if (callback != null) {
      return callback(true);
    }
  };

  EventBase.prototype.getJQueryElement = function() {
    return null;
  };

  EventBase.prototype.clickTargetElement = function() {
    return this.getJQueryElement();
  };

  EventBase.prototype.saveCache = function(key, value) {
    if (this['__saveCache'] == null) {
      this['__saveCache'] = {};
    }
    if ($.isArray(key)) {
      key = key.join('__');
    }
    this['__saveCache'][key + ''] = value;
    return true;
  };

  EventBase.prototype.loadCache = function(key) {
    if (this['__saveCache'] == null) {
      return null;
    }
    if ($.isArray(key)) {
      key = key.join('__');
    }
    return this['__saveCache'][key + ''];
  };

  EventBase.prototype.clearAllCache = function() {
    if (this['__saveCache'] != null) {
      return delete this['__saveCache'];
    }
  };

  EventBase.prototype.willChapter = function(callback) {
    if (callback == null) {
      callback = null;
    }
    this.saveToFootprint(this.id, true, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
    this.setModifyBeforeAndAfterVar();
    this.resetProgress();
    if (callback != null) {
      return callback();
    }
  };

  EventBase.prototype.didChapter = function(callback) {
    var k, v;
    if (callback == null) {
      callback = null;
    }
    for (k in this) {
      v = this[k];
      if (k.lastIndexOf('__Cache') >= 0) {
        delete this[k];
      }
    }
    this.saveToFootprint(this.id, false, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
    if (callback != null) {
      return callback();
    }
  };

  EventBase.prototype.execMethod = function(opt, callback) {
    if (callback == null) {
      callback = null;
    }
    this.updateInstanceParamByStep(opt.progress);
    if (callback != null) {
      return callback();
    }
  };

  EventBase.prototype.scrollHandlerFunc = function(isPreview, x, y) {
    var chapter, ePoint, page, plusX, plusY, sPoint;
    if (isPreview == null) {
      isPreview = false;
    }
    if (x == null) {
      x = 0;
    }
    if (y == null) {
      y = 0;
    }
    if (this._skipEvent || (!isPreview && window.eventAction.thisPage().thisChapter().isFinishedAllEvent(true))) {
      return;
    }
    if (isPreview) {
      this.stepValue += Constant.EventBase.PREVIEW_STEP;
      this.forward = true;
    } else {
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
      this.stepValue += parseInt((plusX + plusY) * 3.5);
      this.forward = plusX + plusY >= 0;
      if (this._isFinishedEvent) {
        if (!this.forward) {
          this._isFinishedEvent = false;
          if (!isPreview) {
            window.eventAction.thisPage().thisChapter().isFinishedAllEvent(false);
          }
        } else {
          return;
        }
      }
    }
    sPoint = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
    ePoint = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) + 1;
    if (this.stepValue < sPoint && !isPreview) {
      if (this.stepValue < 0) {
        if (!this._runningEvent) {
          page = window.eventAction.thisPage();
          chapter = page.thisChapter();
          if (window.eventAction.pageIndex > 0 || page.getChapterIndex() > 0) {
            chapter.showRewindOperationGuide(this, -this.stepValue);
          }
        }
        this.stepValue = 0;
        this._runningEvent = false;
      }
      if (!this._isScrollHeader) {
        this.execMethod({
          isPreview: isPreview,
          progress: 0,
          progressMax: this.progressMax(),
          forward: this.forward
        });
        this._isScrollHeader = true;
      }
      return;
    } else if (this.stepValue >= ePoint) {
      this._runningEvent = true;
      this._isScrollHeader = false;
      if (!isPreview) {
        window.eventAction.thisPage().thisChapter().doMoveChapter = true;
      }
      if (!this._isFinishedEvent) {
        this.execMethod({
          isPreview: isPreview,
          progress: this.progressMax(),
          progressMax: this.progressMax(),
          forward: this.forward
        }, (function(_this) {
          return function() {
            if (!_this.isFinishedWithHand()) {
              _this.finishEvent();
            }
            if (!isPreview) {
              return ScrollGuide.hideGuide();
            }
          };
        })(this));
      }
      return;
    }
    this._runningEvent = true;
    this._isScrollHeader = false;
    if (!isPreview) {
      window.eventAction.thisPage().thisChapter().doMoveChapter = true;
      window.eventAction.thisPage().thisChapter().hideRewindOperationGuide(this);
    }
    this.canForward = this.stepValue < ePoint;
    this.canReverse = this.stepValue > sPoint;
    return this.execMethod({
      isPreview: isPreview,
      progress: this.stepValue - sPoint,
      progressMax: this.progressMax(),
      forward: this.forward
    });
  };

  EventBase.prototype.scrollLength = function() {
    return parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
  };

  EventBase.prototype.clickHandlerFunc = function(isPreview, e) {
    var progressMax;
    if (isPreview == null) {
      isPreview = false;
    }
    if (e == null) {
      e = null;
    }
    if (e != null) {
      e.preventDefault();
    }
    if (this._isFinishedEvent || this._skipEvent || this._runningEvent) {
      return;
    }
    this._runningEvent = true;
    if (window.eventAction != null) {
      window.eventAction.thisPage().thisChapter().doMoveChapter = true;
    }
    progressMax = this.progressMax();
    this.stepValue = 0;
    return this._clickIntervalTimer = setInterval((function(_this) {
      return function() {
        if (!_this._skipEvent) {
          return _this.execMethod({
            isPreview: isPreview,
            progress: _this.stepValue,
            progressMax: progressMax,
            forward: true
          }, function() {
            _this.stepValue += 1;
            if (progressMax < _this.stepValue) {
              clearInterval(_this._clickIntervalTimer);
              if (!_this.isFinishedWithHand()) {
                return _this.finishEvent();
              }
            }
          });
        }
      };
    })(this), this.constructor.STEP_INTERVAL_DURATION * 1000);
  };

  EventBase.prototype.resetProgress = function(withResetFinishedEventFlg) {
    if (withResetFinishedEventFlg == null) {
      withResetFinishedEventFlg = true;
    }
    this.stepValue = 0;
    this._skipEvent = false;
    this._runningEvent = false;
    if (withResetFinishedEventFlg) {
      return this._isFinishedEvent = false;
    }
  };

  EventBase.prototype.enableHandleResponse = function() {
    return this._skipEvent = false;
  };

  EventBase.prototype.disableHandleResponse = function() {
    return this._skipEvent = true;
  };

  EventBase.prototype.finishEvent = function() {
    if (this._isFinishedEvent) {
      return;
    }
    this._isFinishedEvent = true;
    if (this._clickIntervalTimer != null) {
      clearInterval(this._clickIntervalTimer);
      this._clickIntervalTimer = null;
    }
    if (this._runningPreview) {
      return this.previewLoop();
    } else {
      if (window.eventAction != null) {
        if (this._event[EventPageValueBase.PageValueKey.FINISH_PAGE]) {
          if (this._event[EventPageValueBase.PageValueKey.JUMPPAGE_NUM] !== EventPageValueBase.NO_JUMPPAGE) {
            return window.eventAction.thisPage().finishAllChapters(this._event[EventPageValueBase.PageValueKey.JUMPPAGE_NUM] - 1);
          } else {
            return window.eventAction.finishAllPages();
          }
        } else {
          if (this._handlerFuncComplete != null) {
            this._handlerFuncComplete();
            return this._handlerFuncComplete = null;
          }
        }
      }
    }
  };

  EventBase.prototype.getMinimumObjectEventBefore = function() {
    return PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceBefore(this._event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
  };

  EventBase.prototype.updateEventBefore = function() {
    if (this._event == null) {
      return;
    }
    if (window.runDebug) {
      console.log('EventBase updateEventBefore id:' + this.id);
    }
    this.setMiniumObject(this.getMinimumObjectEventBefore());
    if (this._event[EventPageValueBase.PageValueKey.DO_FOCUS] && this instanceof ScreenEvent.PrivateClass === false) {
      Common.focusToTarget(this.getJQueryElement(), null, true);
    }
    return this.resetProgress();
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
    if (actionType === constant.ActionType.SCROLL) {
      this.stepValue = this.scrollLength();
    }
    this.updateInstanceParamByStep(null, true);
    return this.saveToFootprint(this.id, false, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
  };

  EventBase.prototype.execLastStep = function(callback) {
    var progressMax;
    if (callback == null) {
      callback = null;
    }
    progressMax = this.progressMax();
    return this.execMethod({
      isPreview: false,
      progress: progressMax,
      progressMax: progressMax,
      forward: true
    }, callback);
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
            results.push(this.changeInstanceVarByConfig(varName, after));
          } else {
            if (value.varAutoChange) {
              if (value.type === constant.ItemDesignOptionType.NUMBER) {
                results.push(this.changeInstanceVarByConfig(varName, before + (after - before) * progressPercentage));
              } else if (value.type === constant.ItemDesignOptionType.COLOR) {
                colorCacheVarName = varName + "ColorChange__Cache";
                if (this[colorCacheVarName] == null) {
                  colorType = this.constructor.actionPropertiesModifiableVars()[varName].colorType;
                  if (colorType == null) {
                    colorType = 'hex';
                  }
                  this[colorCacheVarName] = Common.colorChangeCacheData(before, after, progressMax, colorType);
                }
                results.push(this.changeInstanceVarByConfig(varName, this[colorCacheVarName][progressValue]));
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
            this.changeInstanceVarByConfig(varName, after);
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
                if (value.type === constant.ItemDesignOptionType.NUMBER) {
                  _this.changeInstanceVarByConfig(varName, before + (after - before) * progressPercentage);
                } else if (value.type === constant.ItemDesignOptionType.COLOR) {
                  colorCacheVarName = varName + "ColorChange__Cache";
                  if (_this[colorCacheVarName] == null) {
                    colorType = _this.constructor.actionPropertiesModifiableVars()[varName].colorType;
                    if (colorType == null) {
                      colorType = 'hex';
                    }
                    _this[colorCacheVarName] = Common.colorChangeCacheData(before, after, progressMax, colorType);
                  }
                  _this.changeInstanceVarByConfig(varName, _this[colorCacheVarName][count]);
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
                results.push(_this.changeInstanceVarByConfig(varName, after));
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

  EventBase.prototype.progressMax = function() {
    if (this._event[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.SCROLL) {
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
    var _actionPropertiesModifiableVars, modifiableRoot, ret;
    if (methodName == null) {
      methodName = null;
    }
    if (isDefault == null) {
      isDefault = false;
    }
    _actionPropertiesModifiableVars = function(modifiableRoot, ret) {
      var ck, cv, k, ref, v;
      if (modifiableRoot != null) {
        for (k in modifiableRoot) {
          v = modifiableRoot[k];
          ret[k] = v;
          if (v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN] != null) {
            ref = v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN];
            for (ck in ref) {
              cv = ref[ck];
              if (cv != null) {
                ret = $.extend(ret, _actionPropertiesModifiableVars.call(this, cv, ret));
              }
            }
          }
        }
      }
      return ret;
    };
    ret = {};
    modifiableRoot = {};
    if (methodName != null) {
      if (isDefault) {
        if (this.actionProperties[methodName] != null) {
          modifiableRoot = this.actionProperties[methodName][this.ActionPropertiesKey.MODIFIABLE_VARS];
        }
      } else {
        if ((this.actionProperties.methods != null) && (this.actionProperties.methods[methodName] != null)) {
          modifiableRoot = this.actionProperties.methods[methodName][this.ActionPropertiesKey.MODIFIABLE_VARS];
        }
      }
    } else {
      modifiableRoot = this.actionProperties[this.ActionPropertiesKey.MODIFIABLE_VARS];
    }
    return _actionPropertiesModifiableVars.call(this, modifiableRoot, ret);
  };

  EventBase.prototype.isFinishedWithHand = function() {
    var m, methodName;
    methodName = this.getEventMethodName();
    if ((methodName != null) && (this.constructor.actionProperties.methods != null) && (this.constructor.actionProperties.methods[methodName] != null)) {
      m = this.constructor.actionProperties.methods[methodName];
      return (m[this.constructor.ActionPropertiesKey.FINISH_WITH_HAND] != null) && m[this.constructor.ActionPropertiesKey.FINISH_WITH_HAND];
    }
    return false;
  };

  EventBase.prototype.saveToFootprint = function(targetObjId, isChangeBefore, eventDistNum, pageNum) {
    if (pageNum == null) {
      pageNum = PageValue.getPageNum();
    }
    return PageValue.saveToFootprint(targetObjId, isChangeBefore, eventDistNum);
  };

  return EventBase;

})(Extend);

//# sourceMappingURL=event_base.js.map
