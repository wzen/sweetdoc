// Generated by CoffeeScript 1.9.2
var Chapter;

Chapter = (function() {
  Chapter.guideTimer = null;

  function Chapter(list) {
    var distId, event, i, id, len, obj, ref;
    this.eventList = list.eventList;
    this.num = list.num;
    this.eventObjList = [];
    ref = this.eventList;
    for (i = 0, len = ref.length; i < len; i++) {
      obj = ref[i];
      id = obj[EventPageValueBase.PageValueKey.ID];
      distId = obj[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN];
      event = Common.getInstanceFromMap(id, distId);
      this.eventObjList.push(event);
    }
    this.doMoveChapter = false;
  }

  Chapter.prototype.willChapter = function(callback) {
    var count, event, i, idx, len, ref, results;
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Chapter willChapter');
    }
    count = 0;
    ref = this.eventObjList;
    results = [];
    for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
      event = ref[idx];
      event.initEvent(this.eventList[idx]);
      results.push(event.willChapter((function(_this) {
        return function() {
          _this.doMoveChapter = false;
          count += 1;
          if (count >= _this.eventObjList.length) {
            _this.focusToActorIfNeed(false);
            _this.enableEventHandle();
            if (callback != null) {
              return callback();
            }
          }
        };
      })(this)));
    }
    return results;
  };

  Chapter.prototype.didChapter = function(callback) {
    var count;
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Chapter didChapter');
    }
    count = 0;
    return this.eventObjList.forEach((function(_this) {
      return function(event) {
        return event.didChapter(function() {
          count += 1;
          if (count >= _this.eventObjList.length) {
            if (callback != null) {
              return callback();
            }
          }
        });
      };
    })(this));
  };

  Chapter.prototype.focusToActorIfNeed = function(isImmediate, type) {
    var item;
    if (type == null) {
      type = "center";
    }
    window.disabledEventHandler = true;
    item = null;
    this.eventObjList.forEach((function(_this) {
      return function(e, idx) {
        if (_this.eventList[idx][EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === false && _this.eventList[idx][EventPageValueBase.PageValueKey.DO_FOCUS]) {
          item = e;
          return false;
        }
      };
    })(this));
    if (item != null) {
      if (type === 'center') {
        return Common.focusToTarget(item.getJQueryElement(), function() {
          return window.disabledEventHandler = false;
        }, isImmediate);
      }
    } else {
      return window.disabledEventHandler = false;
    }
  };

  Chapter.prototype.disableScrollHandleViewEvent = function() {
    if (window.runDebug) {
      console.log('Chapter floatAllChapterEvents');
    }
    return window.scrollHandleWrapper.css('pointer-events', 'none');
  };

  Chapter.prototype.enableScrollHandleViewEvent = function() {
    if (window.runDebug) {
      console.log('Chapter floatScrollHandleCanvas');
    }
    return window.scrollHandleWrapper.css('pointer-events', '');
  };

  Chapter.prototype.resetAllEvents = function(callback) {
    var count, e, i, idx, len, max, ref, results;
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Chapter resetAllEvents');
    }
    count = 0;
    max = this.eventObjList.length;
    if (max === 0) {
      if (callback != null) {
        return callback();
      }
    } else {
      ref = this.eventObjList;
      results = [];
      for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
        e = ref[idx];
        e.initEvent(this.eventList[idx]);
        e.updateEventBefore();
        e.resetProgress();
        results.push(e.refresh(e.visible, (function(_this) {
          return function() {
            count += 1;
            if (count >= max) {
              if (callback != null) {
                return callback();
              }
            }
          };
        })(this)));
      }
      return results;
    }
  };

  Chapter.prototype.forwardAllEvents = function(callback) {
    var count, e, i, idx, len, ref, results;
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Chapter forwardAllEvents');
    }
    count = 0;
    ref = this.eventObjList;
    results = [];
    for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
      e = ref[idx];
      e.initEvent(this.eventList[idx]);
      e.updateEventAfter();
      results.push(e.execLastStep((function(_this) {
        return function() {
          e.didChapter();
          count += 1;
          if (count >= _this.eventObjList.length) {
            if (callback != null) {
              return callback();
            }
          }
        };
      })(this)));
    }
    return results;
  };

  Chapter.prototype.showGuide = function(calledByWillChapter) {
    if (calledByWillChapter == null) {
      calledByWillChapter = false;
    }
    return RunSetting.isShowGuide();
  };

  Chapter.prototype.hideGuide = function() {};

  Chapter.prototype.enableEventHandle = function() {
    return this.eventObjList.forEach((function(_this) {
      return function(e) {
        return e._skipEvent = false;
      };
    })(this));
  };

  Chapter.prototype.disableEventHandle = function() {
    return this.eventObjList.forEach((function(_this) {
      return function(e) {
        return e._skipEvent = true;
      };
    })(this));
  };

  Chapter.prototype.isFinishedAllEvent = function() {
    return false;
  };

  Chapter.prototype.reverseDoMoveChapterFlgIfAllEventOnHeader = function() {
    this.eventObjList.forEach((function(_this) {
      return function(e) {
        if (e._runningEvent) {
          return false;
        }
      };
    })(this));
    this.doMoveChapter = false;
    return true;
  };

  Chapter.prototype.showRewindOperationGuide = function(target, value) {
    if (this.reverseDoMoveChapterFlgIfAllEventOnHeader()) {
      return window.eventAction.rewindOperationGuide.scrollEventByDistSum(value, target);
    }
  };

  Chapter.prototype.hideRewindOperationGuide = function(target) {
    return window.eventAction.rewindOperationGuide.clear(target);
  };

  return Chapter;

})();

//# sourceMappingURL=chapter.js.map
