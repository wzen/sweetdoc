// Generated by CoffeeScript 1.9.2
var Chapter;

Chapter = (function() {
  function Chapter(list) {
    this.eventObjList = list.eventObjList;
    this.eventList = list.eventList;
    this.num = list.num;
    this.doMoveChapter = false;
  }

  Chapter.prototype.willChapter = function() {
    var event, i, idx, len, methodName, ref;
    ref = this.eventObjList;
    for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
      event = ref[idx];
      event.initWithEvent(this.eventList[idx]);
      methodName = event.event[EventPageValueBase.PageValueKey.METHODNAME];
      event.willChapter(methodName);
      event.appendCssIfNeeded(methodName);
      this.doMoveChapter = false;
    }
    this.sinkFrontAllObj();
    return this.focusToActorIfNeed(false);
  };

  Chapter.prototype.didChapter = function() {
    return this.eventObjList.forEach(function(event) {
      var methodName;
      methodName = event.event[EventPageValueBase.PageValueKey.METHODNAME];
      return event.didChapter(methodName);
    });
  };

  Chapter.prototype.focusToActorIfNeed = function(isImmediate, type) {
    var height, item, left, top, width;
    if (type == null) {
      type = "center";
    }
    window.disabledEventHandler = true;
    item = null;
    this.eventObjList.forEach((function(_this) {
      return function(e, idx) {
        if (_this.eventList[idx][EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === false) {
          item = e;
          return false;
        }
      };
    })(this));
    if (item != null) {
      width = item.itemSize.w;
      height = item.itemSize.h;
      if (item.scale != null) {
        width *= item.scale.w;
        height *= item.scale.h;
      }
      left = null;
      top = null;
      if (type === "center") {
        left = item.itemSize.x + width * 0.5 - (scrollContents.width() * 0.5);
        top = item.itemSize.y + height * 0.5 - (scrollContents.height() * 0.5);
      }
      if (isImmediate) {
        scrollContents.scrollTop(top);
        scrollContents.scrollLeft(left);
        return window.disabledEventHandler = false;
      } else {
        return scrollContents.animate({
          scrollTop: top,
          scrollLeft: left
        }, 'normal', 'linear', function() {
          return window.disabledEventHandler = false;
        });
      }
    } else {
      return window.disabledEventHandler = false;
    }
  };

  Chapter.prototype.riseFrontAllObj = function(eventObjList) {
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.off);
    scrollContents.css('z-index', scrollViewSwitchZindex.on);
    return eventObjList.forEach(function(e) {
      if (e.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === false) {
        return e.getJQueryElement().css('z-index', Constant.Zindex.EVENTFLOAT);
      }
    });
  };

  Chapter.prototype.sinkFrontAllObj = function() {
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
    scrollContents.css('z-index', scrollViewSwitchZindex.off);
    return this.eventObjList.forEach((function(_this) {
      return function(e) {
        if (e.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === false) {
          return e.getJQueryElement().css('z-index', Constant.Zindex.EVENTBOTTOM + _this.num);
        }
      };
    })(this));
  };

  Chapter.prototype.finishedAllEvent = function() {
    return true;
  };

  Chapter.prototype.reset = function() {
    return this.eventObjList.forEach((function(_this) {
      return function(e) {
        return e.reset();
      };
    })(this));
  };

  return Chapter;

})();

//# sourceMappingURL=chapter.js.map
