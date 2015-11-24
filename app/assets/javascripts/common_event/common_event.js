// Generated by CoffeeScript 1.9.2
var CommonEvent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

CommonEvent = (function(superClass) {
  var instance;

  extend(CommonEvent, superClass);

  instance = null;

  function CommonEvent() {
    CommonEvent.__super__.constructor.call(this);
    return this.constructor.getInstance();
  }

  CommonEvent.PrivateClass = (function(superClass1) {
    extend(PrivateClass, superClass1);

    PrivateClass.actionProperties = null;

    function PrivateClass() {
      var ref, value, varName;
      PrivateClass.__super__.constructor.call(this);
      this.id = "c" + this.constructor.EVENT_ID + Common.generateId();
      if (this.constructor.actionProperties.modifiables != null) {
        ref = this.constructor.actionProperties.modifiables;
        for (varName in ref) {
          value = ref[varName];
          this[varName] = value["default"];
        }
      }
    }

    PrivateClass.prototype.getMinimumObject = function() {
      var mod, obj, ref, value, varName;
      obj = {
        id: Common.makeClone(this.id),
        eventId: Common.makeClone(this.constructor.EVENT_ID)
      };
      mod = {};
      if (this.constructor.actionProperties.modifiables != null) {
        ref = this.constructor.actionProperties.modifiables;
        for (varName in ref) {
          value = ref[varName];
          mod[varName] = Common.makeClone(this[varName]);
        }
      }
      $.extend(obj, mod);
      return obj;
    };

    PrivateClass.prototype.setMiniumObject = function(obj) {
      var ref, value, varName;
      delete window.instanceMap[this.id];
      this.id = Common.makeClone(obj.id);
      if (this.constructor.actionProperties.modifiables != null) {
        ref = this.constructor.actionProperties.modifiables;
        for (varName in ref) {
          value = ref[varName];
          this[varName] = Common.makeClone(obj[varName]);
        }
      }
      return window.instanceMap[this.id] = this;
    };

    return PrivateClass;

  })(CommonEventBase);

  CommonEvent.getInstance = function() {
    if (instance == null) {
      instance = new this.PrivateClass();
    }
    return instance;
  };

  CommonEvent.EVENT_ID = CommonEvent.PrivateClass.EVENT_ID;

  CommonEvent.actionProperties = CommonEvent.PrivateClass.actionProperties;

  return CommonEvent;

})(CommonEventBase);

//# sourceMappingURL=common_event.js.map
