// Generated by CoffeeScript 1.9.2
var CommonEventListener, EventListener, ItemEventListener;

EventListener = {
  setEvent: function(timelineEvent) {
    this.timelineEvent = timelineEvent;
    this.isFinishedEvent = false;
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
  reset: function() {
    this.isFinishedEvent = false;
  },
  getJQueryElement: function() {
    return null;
  },
  nextChapter: function() {
    if (window.timeLine != null) {
      return window.timeLine.nextChapter();
    }
  },
  willChapter: function(methodName) {
    var actionType;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.SCROLL) {
      this.scrollValue = 0;
    }
  },
  didChapter: function(methodName) {},
  scrollRootFunc: function(x, y) {
    var methodName, scrollLength;
    if (this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME] == null) {
      return;
    }
    methodName = this.timelineEvent[TimelineEvent.PageValueKey.METHODNAME];
    if (this.isFinishedEvent) {
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
    if (this.scrollValue < parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]) || this.scrollValue > parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END])) {
      return;
    }
    this.constructor.prototype[methodName].call(this, this.scrollValue);
    if (this.scrollValue >= this.scrollLength() - 1) {
      this.isFinishedEvent = true;
      if (window.timeLine != null) {
        return window.timeLine.nextChapterIfFinishedAllEvent();
      }
    }
  },
  scrollLength: function() {
    return parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]);
  },
  cssElement: function(methodName) {
    return null;
  },
  appendCssIfNeeded: function(methodName) {
    var ce, funcName;
    ce = this.cssElement(methodName);
    if (ce != null) {
      this.removeCss(methodName);
      funcName = methodName + "_" + this.id;
      return window.cssCode.append("<div class='" + funcName + "'><style type='text/css'> " + ce + " </style></div>");
    }
  },
  removeCss: function(methodName) {
    var funcName;
    funcName = methodName + "_" + this.id;
    return window.cssCode.find("." + funcName).remove();
  },
  clearPaging: function(methodName) {
    return this.removeCss(methodName);
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
