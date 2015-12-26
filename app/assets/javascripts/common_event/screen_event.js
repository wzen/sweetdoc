// Generated by CoffeeScript 1.9.2
var ScreenEvent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ScreenEvent = (function(superClass) {
  extend(ScreenEvent, superClass);

  function ScreenEvent() {
    return ScreenEvent.__super__.constructor.apply(this, arguments);
  }

  ScreenEvent.instance = {};

  ScreenEvent.PrivateClass = (function(superClass1) {
    var _convertCenterCoodToSize, _convertTopLeftToCenterCood, _drawKeepDispRect;

    extend(PrivateClass, superClass1);

    PrivateClass.EVENT_ID = '2';

    PrivateClass.CLASS_DIST_TOKEN = "PI_ScreenEvent";

    PrivateClass.actionProperties = {
      methods: {
        changeScreenPosition: {
          options: {
            id: 'changeScreenPosition',
            name: 'Changing position',
            ja: {
              name: '表示位置変更'
            }
          },
          specificValues: {
            afterX: 0,
            afterY: 0,
            afterZ: 1
          }
        }
      }
    };

    PrivateClass.prototype.getJQueryElement = function() {
      return window.mainWrapper;
    };

    function PrivateClass() {
      this.changeScreenPosition = bind(this.changeScreenPosition, this);
      var cood;
      PrivateClass.__super__.constructor.call(this);
      this.name = 'Screen';
      this.beforeScale = 1.0;
      cood = _convertTopLeftToCenterCood.call(this, scrollContents.scrollTop(), scrollContents.scrollLeft(), this.beforeScale);
      this.beforeX = cood.x;
      this.beforeY = cood.y;
    }

    PrivateClass.prototype.initEvent = function(event, keepDispMag) {
      this.keepDispMag = keepDispMag != null ? keepDispMag : false;
      return PrivateClass.__super__.initEvent.call(this, event);
    };

    PrivateClass.prototype.refresh = function(show, callback) {
      var displayPosition;
      if (show == null) {
        show = true;
      }
      if (callback == null) {
        callback = null;
      }
      displayPosition = PageValue.getScrollContentsPosition();
      Common.updateScrollContentsPosition(displayPosition.top, displayPosition.left, true, function() {
        if (callback != null) {
          return callback();
        }
      });
      return $('.keep_mag_base').remove();
    };

    PrivateClass.prototype.updateEventBefore = function() {
      var methodName, size;
      PrivateClass.__super__.updateEventBefore.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        size = _convertCenterCoodToSize.call(this, this.beforeX, this.beforeY, this.beforeScale);
        _drawKeepDispRect.call(this, this.beforeX, this.beforeY, this.beforeScale);
        return Common.updateScrollContentsPosition(size.top, size.left);
      }
    };

    PrivateClass.prototype.updateEventAfter = function() {
      var methodName, scale, size, x, y;
      PrivateClass.__super__.updateEventAfter.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        x = parseInt(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX);
        y = parseInt(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY);
        scale = parseFloat(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ);
        size = _convertCenterCoodToSize.call(this, x, y, scale);
        _drawKeepDispRect.call(this, x, y, scale);
        return Common.updateScrollContentsPosition(size.top, size.left);
      }
    };

    PrivateClass.prototype.changeScreenPosition = function(opt) {
      var _drawOverlay, canvas, canvasContext, overlay, scale, size, x, y;
      _drawOverlay = function(context, x, y, scale) {
        var _rect, size;
        _rect = function(context, x, y, w, h) {
          context.beginPath();
          context.moveTo(x, y);
          context.lineTo(x + w, y);
          context.lineTo(x + w, y + h);
          context.lineTo(x, y + h);
          return context.closePath();
        };
        context.fillStyle = 'gray';
        context.clearRect(0, 0, context.canvas.width, context.canvas.height);
        context.save();
        context.rect(0, 0, context.canvas.width, context.canvas.height);
        size = _convertCenterCoodToSize.call(this, x, y, scale);
        _rect.call(this, context, size.left, size.top, size.width, size.height);
        context.fill();
        return context.restore();
      };
      x = (parseInt(this._specificMethodValues.afterX) - this.beforeX) * (opt.progress / opt.progressMax) + this.beforeX;
      y = (parseInt(this._specificMethodValues.afterY) - this.beforeY) * (opt.progress / opt.progressMax) + this.beforeY;
      scale = (parseFloat(this._specificMethodValues.afterZ) - this.beforeScale) * (opt.progress / opt.progressMax) + this.beforeScale;
      if (opt.isPreview) {
        if (this.keepDispMag && scale < 1.0) {
          overlay = $('#preview_position_overlay');
          if ((overlay == null) || overlay.length === 0) {
            canvas = $("<canvas id='preview_position_overlay' style='background-color: transparent; width: 100%; height: 100%; z-index: " + (Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1) + "'></canvas>");
            $(window.drawingCanvas).parent().append(canvas);
            overlay = $('#preview_position_overlay');
          }
          canvasContext = overlay[0].getContent('2d');
          _drawOverlay.call(canvasContext, x, y, scale);
        } else {
          $('#preview_position_overlay').remove();
        }
      }
      size = _convertCenterCoodToSize.call(this, x, y, scale);
      Common.updateScrollContentsPosition(size.top, size.left, true);
      return this.getJQueryElement().css('scale', scale);
    };

    PrivateClass.prototype.stopPreview = function(callback) {
      if (callback == null) {
        callback = null;
      }
      $('#preview_position_overlay').remove();
      return PrivateClass.__super__.stopPreview.call(this, callback);
    };

    PrivateClass.initSpecificConfig = function(specificRoot) {
      var _updateConfigInput, emt;
      _updateConfigInput = function(emt, pointingSize) {
        var screenSize, x, y, z;
        x = pointingSize.x + pointingSize.w / 2.0;
        y = pointingSize.y + pointingSize.h / 2.0;
        z = null;
        screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
        if (pointingSize.w > pointingSize.h) {
          z = pointingSize.w / screenSize.width;
        } else {
          z = pointingSize.h / screenSize.height;
        }
        emt.find('.afterX:first').val(x);
        emt.find('.afterY:first').val(y);
        return emt.find('.afterZ:first').val(z);
      };
      emt = specificRoot['changeScreenPosition'];
      return emt.find('event_pointing:first').off('click').on('click', (function(_this) {
        return function(e) {
          var pointing;
          pointing = new EventDragPointing();
          pointing.setDrawCallback(function(pointingSize) {
            return _updateConfigInput.call(_this, emt, pointingSize);
          });
          WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.DRAW);
          return FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, function() {
            return WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT);
          });
        };
      })(this));
    };

    _drawKeepDispRect = function(x, y, scale) {
      var emt, size, style;
      $('.keep_mag_base').remove();
      if (scale < 1.0) {
        size = _convertCenterCoodToSize.call(this, x, y, scale);
        style = "position:absolute;top:" + size.top + "px;left:" + size.left + "px;width:" + size.width + "px;height:" + size.height + "px;";
        emt = $("<div class='keep_mag_base' style='" + style + "'></div>");
        return window.scrollInside.append(emt);
      }
    };

    _convertCenterCoodToSize = function(x, y, scale) {
      var height, left, screenSize, top, width;
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
      width = screenSize.width * scale;
      height = screenSize.height * scale;
      top = y - height / 2.0;
      left = x - width / 2.0;
      return {
        top: top,
        left: left,
        width: width,
        height: height
      };
    };

    _convertTopLeftToCenterCood = function(top, left, scale) {
      var height, screenSize, width, x, y;
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
      width = screenSize.width * scale;
      height = screenSize.height * scale;
      y = top + height / 2.0;
      x = left + width / 2.0;
      return {
        x: x,
        y: y
      };
    };

    return PrivateClass;

  })(CommonEvent.PrivateClass);

  ScreenEvent.EVENT_ID = ScreenEvent.PrivateClass.EVENT_ID;

  ScreenEvent.CLASS_DIST_TOKEN = ScreenEvent.PrivateClass.CLASS_DIST_TOKEN;

  ScreenEvent.actionProperties = ScreenEvent.PrivateClass.actionProperties;

  return ScreenEvent;

})(CommonEvent);

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent);

//# sourceMappingURL=screen_event.js.map
