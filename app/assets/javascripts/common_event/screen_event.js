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
    var _convertCenterCoodToSize, _convertTopLeftToCenterCood, _drawKeepDispRect, _getScale, _overlay, _setScale;

    extend(PrivateClass, superClass1);

    PrivateClass.EVENT_ID = '2';

    PrivateClass.CLASS_DIST_TOKEN = "PI_ScreenEvent";

    PrivateClass.scale = 1.0;

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
            afterX: '',
            afterY: '',
            afterZ: ''
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
      this.initScale = _getScale.call(this);
      cood = _convertTopLeftToCenterCood.call(this, scrollContents.scrollTop(), scrollContents.scrollLeft(), this.initScale);
      this._originalX = cood.x;
      this._originalY = cood.y;
      this.initX = cood.x;
      this.initY = cood.y;
      this.beforeX = this.initX;
      this.beforeY = this.initY;
      this.beforeScale = this.initScale;
    }

    PrivateClass.prototype.initEvent = function(event, keepDispMag) {
      this.keepDispMag = keepDispMag != null ? keepDispMag : false;
      return PrivateClass.__super__.initEvent.call(this, event);
    };

    PrivateClass.prototype.refresh = function(show, callback) {
      if (show == null) {
        show = true;
      }
      if (callback == null) {
        callback = null;
      }
      Common.updateScrollContentsFromPagevalue();
      _setScale.call(this, Common.scaleFromViewRate);
      $('#preview_position_overlay').remove();
      $('.keep_mag_base').remove();
      if (callback != null) {
        return callback();
      }
    };

    PrivateClass.prototype.updateEventBefore = function() {
      var methodName, size;
      PrivateClass.__super__.updateEventBefore.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        if (!this.keepDispMag) {
          _setScale.call(this, this.beforeScale);
          size = _convertCenterCoodToSize.call(this, this.beforeX, this.beforeY, this.beforeScale);
          return Common.updateScrollContentsPosition(size.top, size.left);
        }
      }
    };

    PrivateClass.prototype.updateEventAfter = function() {
      var methodName, size;
      PrivateClass.__super__.updateEventAfter.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        this._nowX = parseInt(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX);
        this._nowY = parseInt(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY);
        this._nowScale = parseFloat(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ);
        if (this.keepDispMag) {
          _setScale.call(this, Common.scaleFromViewRate);
          return _overlay.call(this, this._nowX, this._nowY, this._nowScale);
        } else {
          _setScale.call(this, this._nowScale);
          size = _convertCenterCoodToSize.call(this, this._nowX, this._nowY, this._nowScale);
          return Common.updateScrollContentsPosition(size.top, size.left);
        }
      }
    };

    PrivateClass.prototype.changeScreenPosition = function(opt) {
      var size;
      this._nowScale = (parseFloat(this._specificMethodValues.afterZ) - this.beforeScale) * (opt.progress / opt.progressMax) + this.beforeScale;
      this._nowX = ((parseFloat(this._specificMethodValues.afterX) - this.beforeX) * (opt.progress / opt.progressMax)) + this.beforeX;
      this._nowY = ((parseFloat(this._specificMethodValues.afterY) - this.beforeY) * (opt.progress / opt.progressMax)) + this.beforeY;
      if (opt.isPreview) {
        _overlay.call(this, this._nowX, this._nowY, this._nowScale);
        if (this.keepDispMag) {
          _setScale.call(this, Common.scaleFromViewRate);
        }
      }
      if (!this.keepDispMag) {
        _setScale.call(this, this._nowScale);
        size = _convertCenterCoodToSize.call(this, this._nowX, this._nowY, this._nowScale);
        return Common.updateScrollContentsPosition(size.top, size.left, true);
      }
    };

    PrivateClass.prototype.stopPreview = function(loopFinishCallback, callback) {
      if (loopFinishCallback == null) {
        loopFinishCallback = null;
      }
      if (callback == null) {
        callback = null;
      }
      setTimeout(function() {
        return $('#preview_position_overlay').remove();
      }, 0);
      return PrivateClass.__super__.stopPreview.call(this, loopFinishCallback, callback);
    };

    PrivateClass.prototype.didChapter = function() {
      this.beforeX = this._nowX;
      this.beforeY = this._nowY;
      this.beforeScale = this._nowScale;
      return PrivateClass.__super__.didChapter.call(this);
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
          z = screenSize.width / pointingSize.w;
        } else {
          z = screenSize.height / pointingSize.h;
        }
        emt.find('.afterX:first').val(x);
        emt.find('.afterY:first').val(y);
        return emt.find('.afterZ:first').val(z);
      };
      emt = specificRoot['changeScreenPosition'];
      return emt.find('.event_pointing:first').eventDragPointing((function(_this) {
        return function(pointingSize) {
          return _updateConfigInput.call(_this, emt, pointingSize);
        };
      })(this));
    };

    _overlay = function(x, y, scale) {
      var _drawOverlay, canvas, canvasContext, h, overlay, w;
      _drawOverlay = function(context, x, y, width, height, scale) {
        var _rect, h, left, size, top, w;
        _rect = function(context, x, y, w, h) {
          context.moveTo(x, y);
          context.lineTo(x, y + h);
          context.lineTo(x + w, y + h);
          context.lineTo(x + w, y);
          return context.closePath();
        };
        context.clearRect(0, 0, width, height);
        context.save();
        context.fillStyle = "rgba(33, 33, 33, 0.5)";
        context.beginPath();
        context.rect(0, 0, width, height);
        size = _convertCenterCoodToSize.call(this, x, y, Common.scaleFromViewRate);
        w = size.width / scale;
        h = size.height / scale;
        top = y - h / 2.0;
        left = x - w / 2.0;
        _rect.call(this, context, left - window.scrollContents.scrollLeft(), top - window.scrollContents.scrollTop(), w, h);
        context.fill();
        return context.restore();
      };
      if (this.keepDispMag && scale > Common.scaleFromViewRate) {
        overlay = $('#preview_position_overlay');
        if ((overlay == null) || overlay.length === 0) {
          w = $(window.drawingCanvas).attr('width');
          h = $(window.drawingCanvas).attr('height');
          canvas = $("<canvas id='preview_position_overlay' class='canvas_container canvas' width='" + w + "' height='" + h + "' style='z-index: " + (Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1) + "'></canvas>");
          $(window.drawingCanvas).parent().append(canvas);
          overlay = $('#preview_position_overlay');
        }
        canvasContext = overlay[0].getContext('2d');
        return _drawOverlay.call(this, canvasContext, x, y, overlay.width(), overlay.height(), scale);
      } else {
        return $('#preview_position_overlay').remove();
      }
    };

    _drawKeepDispRect = function(x, y, scale) {
      var emt, size, style;
      $('.keep_mag_base').remove();
      if (scale > Common.scaleFromViewRate) {
        size = _convertCenterCoodToSize.call(this, x, y, scale);
        style = "position:absolute;top:" + size.top + "px;left:" + size.left + "px;width:" + size.width + "px;height:" + size.height + "px;";
        emt = $("<div class='keep_mag_base' style='" + style + "'></div>");
        return window.scrollInside.append(emt);
      }
    };

    _convertCenterCoodToSize = function(x, y, scale) {
      var height, left, screenSize, top, width;
      screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
      width = screenSize.width / scale;
      height = screenSize.height / scale;
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
      width = screenSize.width / scale;
      height = screenSize.height / scale;
      y = top + height / 2.0;
      x = left + width / 2.0;
      return {
        x: x,
        y: y
      };
    };

    _setScale = function(scale) {
      this.constructor.scale = scale;
      return Common.applyViewScale();
    };

    _getScale = function() {
      return this.constructor.scale;
    };

    return PrivateClass;

  })(CommonEvent.PrivateClass);

  ScreenEvent.CLASS_DIST_TOKEN = ScreenEvent.PrivateClass.CLASS_DIST_TOKEN;

  return ScreenEvent;

})(CommonEvent);

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent);

//# sourceMappingURL=screen_event.js.map
