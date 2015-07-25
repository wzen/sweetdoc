// Generated by CoffeeScript 1.9.2
var CommonEventListener, EventListener, ItemEventListener;

EventListener = {
  setEvent: function(timelineEvent) {
    this.timelineEvent = timelineEvent;
    return this.setMethod();
  },
  setMethod: function() {
    var actionType, methodName;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
    if (this.constructor.prototype[methodName] == null) {
      return;
    }
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      return this.scrollEvent = this.scrollRootFunc;
    } else if (actionType === Constant.ActionEventHandleType.CLICK) {
      return this.clickEvent = this.constructor.prototype[methodName];
    }
  },
  reset: function() {},
  getJQueryElement: function() {
    return null;
  },
  nextChapter: function() {
    if (window.timeLine != null) {
      return window.timeLine.nextChapter();
    }
  },
  willChapter: function() {
    var actionType;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      this.scrollValue = 0;
    }
  },
  didChapter: function(methodName) {},
  finishedScroll: function(scrollValue) {
    return false;
  },
  scrollRootFunc: function(x, y) {
    var methodName, scrollLength;
    if (this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME] == null) {
      return;
    }
    console.log("y:" + y);
    if (y >= 0) {
      this.scrollValue += parseInt((y + 9) / 10);
    } else {
      this.scrollValue += parseInt((y - 9) / 10);
    }
    this.scrollValue = this.scrollValue < 0 ? 0 : this.scrollValue;
    scrollLength = this.scrollLength();
    this.scrollValue = this.scrollValue >= scrollLength ? scrollLength - 1 : this.scrollValue;
    methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
    this.constructor.prototype[methodName].call(this, this.scrollValue);
    if (this.finishedScroll(this.scrollValue)) {
      console.log('scroll nextChapter');
      return this.nextChapter();
    }
  },
  scrollLength: function() {
    return parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]);
  }
};

CommonEventListener = {
  initWithEvent: function(timelineEvent) {}
};

ItemEventListener = {
  initWithEvent: function(timelineEvent) {
    return this.setMiniumObject(timelineEvent[TLEItemChange.minObj]);
  },
  setMiniumObject: function(obj) {}
};

//# sourceMappingURL=event_listener.js.map
