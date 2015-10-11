// Generated by CoffeeScript 1.10.0
var CommonEvent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

CommonEvent = (function(superClass) {
  extend(CommonEvent, superClass);

  CommonEvent.EVENT_ID = '';

  function CommonEvent() {
    CommonEvent.__super__.constructor.call(this);
    this.id = "c" + this.constructor.EVENT_ID + Common.generateId();
  }

  CommonEvent.prototype.getMinimumObject = function() {
    var obj;
    obj = {
      id: Common.makeClone(this.id),
      eventId: Common.makeClone(this.constructor.EVENT_ID)
    };
    return obj;
  };

  return CommonEvent;

})(CommonEventBase);

//# sourceMappingURL=common_event.js.map
