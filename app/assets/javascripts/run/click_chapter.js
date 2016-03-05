// Generated by CoffeeScript 1.9.2
var ClickChapter,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ClickChapter = (function(superClass) {
  extend(ClickChapter, superClass);

  function ClickChapter(list) {
    ClickChapter.__super__.constructor.call(this, list);
    this.changeForkNum = null;
  }

  ClickChapter.prototype.willChapter = function(callback) {
    if (callback == null) {
      callback = null;
    }
    return ClickChapter.__super__.willChapter.call(this, (function(_this) {
      return function() {
        _this.disableScrollHandleViewEvent();
        _this.eventObjList.forEach(function(event) {
          return event.clickTargetElement().off('click').on('click', function(e) {
            return _this.clickEvent(e);
          });
        });
        _this.showGuide();
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  ClickChapter.prototype.didChapter = function(callback) {
    if (callback == null) {
      callback = null;
    }
    return ClickChapter.__super__.didChapter.call(this, (function(_this) {
      return function() {
        _this.enableScrollHandleViewEvent();
        _this.hideGuide();
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  ClickChapter.prototype.clickEvent = function(e) {
    this.hideGuide();
    if (window.disabledEventHandler) {
      return;
    }
    return this.eventObjList.forEach((function(_this) {
      return function(event) {
        if (event.clickTargetElement().get(0) === $(e.currentTarget).get(0)) {
          return event.clickEvent(e, function() {
            _this.changeForkNum = event.getChangeForkNum();
            if (window.eventAction != null) {
              return window.eventAction.thisPage().nextChapter();
            }
          });
        }
      };
    })(this));
  };

  ClickChapter.prototype.showGuide = function() {
    var idleTime;
    if (!ClickChapter.__super__.showGuide.call(this)) {
      return false;
    }
    this.hideGuide();
    idleTime = ClickGuide.IDLE_TIMER;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      idleTime = 0;
    }
    return this.constructor.guideTimer = setTimeout((function(_this) {
      return function() {
        var items;
        items = [];
        _this.eventObjList.forEach(function(event) {
          if (event instanceof ItemBase) {
            return items.push(event);
          }
        });
        return ClickGuide.showGuide(items);
      };
    })(this), idleTime);
  };

  ClickChapter.prototype.hideGuide = function() {
    if (this.constructor.guideTimer != null) {
      clearTimeout(this.constructor.guideTimer);
      this.constructor.guideTimer = null;
    }
    ScrollGuide.hideGuide();
    return ClickGuide.hideGuide();
  };

  return ClickChapter;

})(Chapter);

//# sourceMappingURL=click_chapter.js.map
