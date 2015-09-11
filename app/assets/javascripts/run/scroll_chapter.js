// Generated by CoffeeScript 1.9.2
var ScrollChapter,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ScrollChapter = (function(superClass) {
  extend(ScrollChapter, superClass);

  function ScrollChapter() {
    return ScrollChapter.__super__.constructor.apply(this, arguments);
  }

  ScrollChapter.prototype.willChapter = function() {
    ScrollChapter.__super__.willChapter.call(this);
    this.floatScrollHandleCanvas();
    return this.showGuide(true);
  };

  ScrollChapter.prototype.didChapter = function() {
    ScrollChapter.__super__.didChapter.call(this);
    return this.hideGuide();
  };

  ScrollChapter.prototype.scrollEvent = function(x, y) {
    if (window.disabledEventHandler) {
      return;
    }
    this.eventObjList.forEach((function(_this) {
      return function(event) {
        if (event.scrollEvent != null) {
          return event.scrollEvent(x, y, function() {
            _this.hideGuide();
            if (window.eventAction != null) {
              return window.eventAction.thisPage().nextChapterIfFinishedAllEvent();
            }
          });
        }
      };
    })(this));
    if (!this.finishedAllEvent()) {
      return this.showGuide();
    }
  };

  ScrollChapter.prototype.showGuide = function(calledByWillChapter) {
    if (calledByWillChapter == null) {
      calledByWillChapter = false;
    }
    this.hideGuide();
    return this.constructor.guideTimer = setTimeout((function(_this) {
      return function() {
        _this.adjustGuideParams(calledByWillChapter);
        return ScrollGuide.showGuide(_this.enabledDirections, _this.forwardDirections, _this.canForward, _this.canReverse);
      };
    })(this), ScrollGuide.IDLE_TIMER);
  };

  ScrollChapter.prototype.hideGuide = function() {
    if (this.constructor.guideTimer != null) {
      clearTimeout(this.constructor.guideTimer);
      this.constructor.guideTimer = null;
    }
    return ScrollGuide.hideGuide();
  };

  ScrollChapter.prototype.adjustGuideParams = function(calledByWillChapter) {
    this.enabledDirections = {
      top: false,
      bottom: false,
      left: false,
      right: false
    };
    this.forwardDirections = {
      top: false,
      bottom: false,
      left: false,
      right: false
    };
    this.canForward = false;
    this.canReverse = false;
    this.eventObjList.forEach((function(_this) {
      return function(event) {
        var k, ref, ref1, v;
        if (!event.isFinishedEvent) {
          ref = event.enabledDirections;
          for (k in ref) {
            v = ref[k];
            if (!_this.enabledDirections[k]) {
              _this.enabledDirections[k] = v;
            }
          }
          ref1 = event.forwardDirections;
          for (k in ref1) {
            v = ref1[k];
            if (!_this.forwardDirections[k]) {
              _this.forwardDirections[k] = v;
            }
          }
          if (!calledByWillChapter) {
            if ((event.canForward != null) && event.canForward) {
              _this.canForward = true;
            }
            if ((event.canReverse != null) && event.canReverse) {
              return _this.canReverse = true;
            }
          }
        }
      };
    })(this));
    if (calledByWillChapter) {
      this.canForward = true;
      return this.canReverse = false;
    }
  };

  ScrollChapter.prototype.finishedAllEvent = function() {
    var ret;
    ret = true;
    this.eventObjList.forEach(function(event) {
      var methodName;
      methodName = event.event[EventPageValueBase.PageValueKey.METHODNAME];
      if (!event.isFinishedEvent) {
        ret = false;
        return false;
      }
    });
    return ret;
  };

  return ScrollChapter;

})(Chapter);

//# sourceMappingURL=scroll_chapter.js.map
