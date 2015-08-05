// Generated by CoffeeScript 1.9.2
var ScreenEvent,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ScreenEvent = (function(superClass) {
  extend(ScreenEvent, superClass);

  function ScreenEvent() {
    this.changeScreenPosition = bind(this.changeScreenPosition, this);
    return ScreenEvent.__super__.constructor.apply(this, arguments);
  }

  ScreenEvent.EVENT_ID = '2';

  ScreenEvent.prototype.getJQueryElement = function() {
    return window.mainWrapper;
  };

  ScreenEvent.prototype.changeScreenPosition = function(e) {
    var actionType, finished_count, scale, scrollLeft, scrollTop;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.CLICK) {
      finished_count = 0;
      scrollTop = this.timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.X];
      scrollLeft = this.timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Y];
      scrollContents.animate({
        scrollTop: scrollContents.scrollTop() + scrollTop,
        scrollLeft: scrollContents.scrollLeft() + scrollLeft
      }, 'normal', 'linear', function() {
        finished_count += 1;
        if (finished_count >= 2) {
          this.isFinishedEvent = true;
          if (window.timeLine != null) {
            return window.timeLine.nextChapterIfFinishedAllEvent();
          }
        }
      });
      scale = this.timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Z];
      return this.getJQueryElement().transition({
        scale: "+=" + scale
      }, 'normal', 'linear', function() {
        finished_count += 1;
        if (finished_count >= 2) {
          this.isFinishedEvent = true;
          if (window.timeLine != null) {
            return window.timeLine.nextChapterIfFinishedAllEvent();
          }
        }
      });
    }
  };

  ScreenEvent.prototype.clearPaging = function(methodName) {
    ScreenEvent.__super__.clearPaging.call(this, methodName);
    return this.getJQueryElement().removeClass('changeScreenPosition_' + this.id);
  };

  return ScreenEvent;

})(CommonEvent);

setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent);

//# sourceMappingURL=screen_event.js.map
