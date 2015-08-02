// Generated by CoffeeScript 1.9.2
var ScreenEvent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ScreenEvent = (function(superClass) {
  extend(ScreenEvent, superClass);

  function ScreenEvent() {
    return ScreenEvent.__super__.constructor.apply(this, arguments);
  }

  ScreenEvent.EVENT_ID = '2';

  ScreenEvent.prototype.changeScreenPosition = function() {
    var actionType;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (actionType === Constant.ActionEventHandleType.CLICK) {
      return $('#main-wrapper');
    }
  };

  ScreenEvent.prototype.cssElement = function(methodName) {
    var actionType, css, funcName, zoom;
    actionType = this.timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE];
    if (methodName === 'changeScreenPosition') {
      if (actionType === Constant.ActionEventHandleType.CLICK) {
        funcName = methodName + "_" + this.id;
        zoom = this.timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Z];
        css = "." + funcName + "\n{\n-moz-transition: all 0.5s ease 0;\n-webkit-transition: all 0.5s ease 0;\n-webkit-transform : scale(" + zoom + ");\ntransform : scale(" + zoom + ");\n}";
        return css;
      }
    }
    return null;
  };

  ScreenEvent.prototype.zoom = function(zoom, x, y) {
    $(".content").css({
      "-moz-transition": "all 0s ease 0",
      "-webkit-transition": "all 0s ease 0",
      "-webkit-transform-origin": x + "px " + y + "px",
      "transform-origin": x + "px " + y + "px"
    });
    return setTimeout(function() {
      return $(".content").css({
        "-moz-transition": "all 0.5s ease 0",
        "-webkit-transition": "all 0.5s ease 0",
        "-webkit-transform": "scale(" + zoom + ")",
        "transform": "scale(" + zoom + ")"
      });
    }, 1);
  };

  return ScreenEvent;

})(CommonEvent);

setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent);

//# sourceMappingURL=screen_event.js.map
