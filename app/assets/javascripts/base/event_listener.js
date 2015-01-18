// Generated by CoffeeScript 1.8.0
var EventListener;

EventListener = (function() {
  function EventListener() {}

  EventListener.prototype.initListener = function(miniObj, itemSize) {
    this.setMiniumObject(miniObj);
    this.itemSize = itemSize;
    return this.delay = null;
  };

  EventListener.prototype.setEvents = function(sEventFuncName, cEventFuncName) {
    var clickEventFunc;
    if ((sEventFuncName != null) && (this.constructor.prototype[sEventFuncName] != null)) {
      this.scrollEvent = this.constructor.prototype[sEventFuncName];
    }
    if ((cEventFuncName != null) && (this.constructor.prototype[cEventFuncName] != null)) {
      clickEventFunc = this.constructor.prototype[cEventFuncName];
      return this.getJQueryElement().on('click', (function(_this) {
        return function(e) {
          return clickEventFunc.call(_this, e);
        };
      })(this));
    }
  };

  EventListener.prototype.setMiniumObject = function(obj) {};

  EventListener.prototype.reset = function() {};

  EventListener.prototype.getJQueryElement = function() {};

  EventListener.prototype.nextChapter = function() {
    if (window.timeLine != null) {
      return window.timeLine.nextChapter();
    }
  };

  return EventListener;

})();

//# sourceMappingURL=event_listener.js.map