// Generated by CoffeeScript 1.9.2
var CommonEventBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

CommonEventBase = (function(superClass) {
  extend(CommonEventBase, superClass);

  function CommonEventBase() {
    return CommonEventBase.__super__.constructor.apply(this, arguments);
  }

  CommonEventBase.prototype.initEvent = function(event) {
    return CommonEventBase.__super__.initEvent.call(this, event);
  };

  CommonEventBase.prototype.execMethod = function(opt) {
    CommonEventBase.__super__.execMethod.call(this, opt);
    return this.constructor.prototype[this.getEventMethodName()].call(this, opt);
  };

  return CommonEventBase;

})(EventBase);

//# sourceMappingURL=common_event_base.js.map
