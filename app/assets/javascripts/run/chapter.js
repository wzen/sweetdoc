// Generated by CoffeeScript 1.9.2
var Chapter;

Chapter = (function() {
  function Chapter(list) {
    this.eventList = list.eventList;
    this.timelineEventList = list.timelineEventList;
  }

  Chapter.prototype.willChapter = function() {
    var event, i, idx, len, methodName, ref;
    ref = this.eventList;
    for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
      event = ref[idx];
      event.initWithEvent(this.timelineEventList[idx]);
      methodName = event.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
      event.willChapter(methodName);
      event.appendCssIfNeeded(methodName);
    }
    this.sinkFrontAllActor();
    return this.focusToActorIfNeed(false);
  };

  Chapter.prototype.didChapter = function() {
    return this.eventList.forEach(function(event) {
      var methodName;
      methodName = event.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
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
    this.eventList.forEach((function(_this) {
      return function(e, idx) {
        if (_this.timelineEventList[idx][TimelineEvent.PageValueKey.IS_COMMON_EVENT] === false) {
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

  Chapter.prototype.riseFrontAllActor = function() {
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.off);
    scrollContents.css('z-index', scrollViewSwitchZindex.on);
    return this.eventList.forEach(function(event) {
      if (event.timelineEvent[TimelineEvent.PageValueKey.IS_COMMON_EVENT] === false) {
        return event.getJQueryElement().css('z-index', scrollInsideCoverZindex + 1);
      }
    });
  };

  Chapter.prototype.sinkFrontAllActor = function() {
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
    scrollContents.css('z-index', scrollViewSwitchZindex.off);
    return this.eventList.forEach(function(event) {
      if (event.timelineEvent[TimelineEvent.PageValueKey.IS_COMMON_EVENT] === false) {
        return event.getJQueryElement().css('z-index', Constant.Zindex.EVENTBOTTOM);
      }
    });
  };

  Chapter.prototype.finishedAllEvent = function() {
    return true;
  };

  return Chapter;

})();

//# sourceMappingURL=chapter.js.map
