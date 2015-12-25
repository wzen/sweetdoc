// Generated by CoffeeScript 1.9.2
var BackgroundEvent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

BackgroundEvent = (function(superClass) {
  extend(BackgroundEvent, superClass);

  function BackgroundEvent() {
    return BackgroundEvent.__super__.constructor.apply(this, arguments);
  }

  BackgroundEvent.PrivateClass = (function(superClass1) {
    extend(PrivateClass, superClass1);

    function PrivateClass() {
      return PrivateClass.__super__.constructor.apply(this, arguments);
    }

    PrivateClass.EVENT_ID = '1';

    PrivateClass.CLASS_DIST_TOKEN = "PI_BackgroundEvent";

    PrivateClass.actionProperties = {
      methods: {
        changeBackgroundColor: {
          options: {
            id: 'changeColorClick_Design',
            name: 'Changing backgroundcolor',
            ja: {
              name: '背景色変更'
            }
          },
          modifiables: {
            backgroundColor: {
              name: "Background Color",
              type: 'color',
              varAutoChange: true,
              ja: {
                name: "背景色"
              }
            }
          }
        }
      }
    };

    PrivateClass.prototype.initEvent = function(event) {
      return PrivateClass.__super__.initEvent.call(this, event);
    };

    PrivateClass.prototype.refresh = function(show, callback) {
      if (show == null) {
        show = true;
      }
      if (callback == null) {
        callback = null;
      }
      window.scrollInside.css('backgroundColor', '');
      if (callback != null) {
        return callback();
      }
    };

    PrivateClass.prototype.updateEventBefore = function() {
      var methodName;
      PrivateClass.__super__.updateEventBefore.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeBackgroundColor') {
        return window.scrollInside.css('backgroundColor', this.backgroundColor);
      }
    };

    PrivateClass.prototype.updateEventAfter = function() {
      var methodName;
      PrivateClass.__super__.updateEventAfter.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeBackgroundColor') {
        return window.scrollInside.css('backgroundColor', this.backgroundColor);
      }
    };

    PrivateClass.prototype.changeBackgroundColor = function(opt) {
      return window.scrollInside.css('backgroundColor', this.backgroundColor);
    };

    return PrivateClass;

  })(CommonEvent.PrivateClass);

  BackgroundEvent.EVENT_ID = BackgroundEvent.PrivateClass.EVENT_ID;

  BackgroundEvent.CLASS_DIST_TOKEN = BackgroundEvent.PrivateClass.CLASS_DIST_TOKEN;

  BackgroundEvent.actionProperties = BackgroundEvent.PrivateClass.actionProperties;

  return BackgroundEvent;

})(CommonEvent);

Common.setClassToMap(BackgroundEvent.CLASS_DIST_TOKEN, BackgroundEvent);

//# sourceMappingURL=background_event.js.map
