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
    return this.sinkFrontAllActor();
  };

  ScrollChapter.prototype.didChapter = function() {
    return ScrollChapter.__super__.didChapter.call(this);
  };

  ScrollChapter.prototype.scrollEvent = function(x, y) {
    if (window.disabledEventHandler) {
      return;
    }
    return this.eventList.forEach(function(event) {
      if (event.scrollEvent != null) {
        return event.scrollEvent(x, y, function() {
          if (window.timeLine != null) {
            return window.timeLine.nextChapterIfFinishedAllEvent();
          }
        });
      }
    });
  };

  ScrollChapter.prototype.finishedAllEvent = function() {
    var ret;
    ret = true;
    this.eventList.forEach(function(event) {
      var methodName;
      methodName = event.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
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
