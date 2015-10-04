// Generated by CoffeeScript 1.9.2
var ScreenEvent,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ScreenEvent = (function(superClass) {
  extend(ScreenEvent, superClass);

  ScreenEvent.EVENT_ID = '2';

  function ScreenEvent() {
    this.changeScreenPosition = bind(this.changeScreenPosition, this);
    ScreenEvent.__super__.constructor.call(this);
    this.beforeScrollTop = scrollContents.scrollTop();
    this.beforeScrollLeft = scrollContents.scrollLeft();
  }

  ScreenEvent.prototype.getJQueryElement = function() {
    return window.mainWrapper;
  };

  ScreenEvent.prototype.updateEventBefore = function() {
    var methodName;
    methodName = this.getEventMethodName();
    if (methodName === 'changeScreenPosition') {
      return Common.updateScrollContentsPosition(this.beforeScrollTop, this.beforeScrollLeft);
    }
  };

  ScreenEvent.prototype.updateEventAfter = function() {
    var methodName, scrollLeft, scrollTop;
    methodName = this.getEventMethodName();
    if (methodName === 'changeScreenPosition') {
      scrollTop = parseInt(this.event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.X]);
      scrollLeft = parseInt(this.event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Y]);
      return Common.updateScrollContentsPosition(this.beforeScrollTop + scrollTop, this.beforeScrollLeft + scrollLeft);
    }
  };

  ScreenEvent.prototype.changeScreenPosition = function(e, complete) {
    var actionType, finished_count, scale, scrollLeft, scrollTop;
    this.updateEventBefore();
    actionType = this.getEventActionType();
    if (actionType === Constant.ActionType.CLICK) {
      finished_count = 0;
      scrollTop = parseInt(this.event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.X]);
      scrollLeft = parseInt(this.event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Y]);
      Common.updateScrollContentsPosition(scrollContents.scrollTop() + scrollTop, scrollContents.scrollLeft() + scrollLeft, false, function() {
        finished_count += 1;
        if (finished_count >= 2) {
          this.isFinishedEvent = true;
          if (complete != null) {
            return complete();
          }
        }
      });
      scale = this.event[EventPageValueBase.PageValueKey.VALUE][EPVScreenPosition.Z];
      if (scale !== 0) {
        return this.getJQueryElement().transition({
          scale: "+=" + scale
        }, 'normal', 'linear', function() {
          finished_count += 1;
          if (finished_count >= 2) {
            this.isFinishedEvent = true;
            if (complete != null) {
              return complete();
            }
          }
        });
      } else {
        finished_count += 1;
        if (finished_count >= 2) {
          this.isFinishedEvent = true;
          if (complete != null) {
            return complete();
          }
        }
      }
    }
  };

  return ScreenEvent;

})(CommonEvent);

Common.setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent);

//# sourceMappingURL=screen_event.js.map
