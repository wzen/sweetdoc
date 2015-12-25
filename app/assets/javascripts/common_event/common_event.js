// Generated by CoffeeScript 1.9.2
var CommonEvent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

CommonEvent = (function() {
  CommonEvent.instance = null;

  function CommonEvent() {
    return this.constructor.getInstance();
  }

  CommonEvent.PrivateClass = (function(superClass) {
    extend(PrivateClass, superClass);

    PrivateClass.actionProperties = null;

    function PrivateClass() {
      PrivateClass.__super__.constructor.call(this);
      this.id = "c" + this.constructor.EVENT_ID + Common.generateId();
      this.eventId = this.constructor.EVENT_ID;
      this.classDistToken = this.constructor.CLASS_DIST_TOKEN;
    }

    PrivateClass.prototype.getJQueryElement = function() {
      return $('#common_event_click_overlay');
    };

    PrivateClass.prototype.willChapter = function() {
      var z_index;
      if (this._event[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.CLICK) {
        z_index = Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT);
        return $('body').append("<div id='common_event_click_overlay' style='z-index:" + z_index + "'></div>");
      }
    };

    PrivateClass.prototype.didChapter = function() {
      if (this._event[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.CLICK) {
        return $('#common_event_click_overlay').remove();
      }
    };

    return PrivateClass;

  })(CommonEventBase);

  CommonEvent.getInstance = function() {
    if (this.instance[PageValue.getPageNum()] == null) {
      this.instance[PageValue.getPageNum()] = new this.PrivateClass();
    }
    return this.instance[PageValue.getPageNum()];
  };

  CommonEvent.deleteInstance = function(objId) {
    var k, ref, results, v;
    ref = this.instance;
    results = [];
    for (k in ref) {
      v = ref[k];
      if (v.id === objId) {
        results.push(delete this.instance[k]);
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  CommonEvent.deleteAllInstance = function() {
    var k, ref, results, v;
    ref = this.instance;
    results = [];
    for (k in ref) {
      v = ref[k];
      results.push(delete this.instance[k]);
    }
    return results;
  };

  CommonEvent.EVENT_ID = CommonEvent.PrivateClass.EVENT_ID;

  CommonEvent.CLASS_DIST_TOKEN = CommonEvent.PrivateClass.CLASS_DIST_TOKEN;

  CommonEvent.actionProperties = CommonEvent.PrivateClass.actionProperties;

  return CommonEvent;

})();

//# sourceMappingURL=common_event.js.map
