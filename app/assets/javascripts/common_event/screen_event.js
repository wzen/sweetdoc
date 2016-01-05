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
    var _convertCenterCoodToSize, _drawKeepDispRect, _getScale, _overlay, _setScale;

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
      PrivateClass.__super__.constructor.call(this);
      this.name = 'Screen';
      this.initConfigX = 0;
      this.initConfigY = 0;
      this.initConfigScale = 1.0;
      this.nowX = null;
      this.nowY = null;
      this.nowScale = null;
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
      Common.updateWorktableScrollContentsFromPageValue();
      _setScale.call(this, 1.0);
      $('#preview_position_overlay').remove();
      $('.keep_mag_base').remove();
      this.scale = 1.0;
      if (callback != null) {
        return callback();
      }
    };

    PrivateClass.prototype.updateEventBefore = function() {
      var methodName, scrollContentsSize, size;
      PrivateClass.__super__.updateEventBefore.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        if (!this.keepDispMag) {
          _setScale.call(this, this.nowScale);
          size = _convertCenterCoodToSize.call(this, this.nowX, this.nowY, this.nowScale);
          scrollContentsSize = Common.scrollContentsSizeUnderScreenEventScale();
          return Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false);
        }
      }
    };

    PrivateClass.prototype.updateEventAfter = function() {
      var methodName, scrollContentsSize, size;
      PrivateClass.__super__.updateEventAfter.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        this._progressX = parseFloat(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX);
        this._progressY = parseFloat(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY);
        this._progressScale = parseFloat(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ);
        if (this.keepDispMag) {
          _setScale.call(this, 1.0);
          return _overlay.call(this, this._progressX, this._progressY, this._progressScale);
        } else {
          _setScale.call(this, this._progressScale);
          size = _convertCenterCoodToSize.call(this, this._progressX, this._progressY, this._progressScale);
          scrollContentsSize = Common.scrollContentsSizeUnderScreenEventScale();
          return Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false);
        }
      }
    };

    PrivateClass.prototype.changeScreenPosition = function(opt) {
      var scrollContentsSize, size;
      this._progressScale = (parseFloat(this._specificMethodValues.afterZ) - this.nowScale) * (opt.progress / opt.progressMax) + this.nowScale;
      this._progressX = ((parseFloat(this._specificMethodValues.afterX) - this.nowX) * (opt.progress / opt.progressMax)) + this.nowX;
      this._progressY = ((parseFloat(this._specificMethodValues.afterY) - this.nowY) * (opt.progress / opt.progressMax)) + this.nowY;
      if (opt.isPreview) {
        _overlay.call(this, this._progressX, this._progressY, this._progressScale);
        if (this.keepDispMag) {
          _setScale.call(this, 1.0);
        }
      }
      if (!this.keepDispMag) {
        _setScale.call(this, this._progressScale);
        size = _convertCenterCoodToSize.call(this, this._progressX, this._progressY, this._progressScale);
        scrollContentsSize = Common.scrollContentsSizeUnderScreenEventScale();
        return Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false);
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

    PrivateClass.prototype.willChapter = function() {
      this.nowScale = this.scale;
      return PrivateClass.__super__.willChapter.call(this);
    };

    PrivateClass.prototype.didChapter = function() {
      this.nowX = this._progressX;
      this.nowY = this._progressY;
      this.nowScale = this._progressScale;
      this._progressScale = null;
      this.scale = this.nowScale;
      return PrivateClass.__super__.didChapter.call(this);
    };

    PrivateClass.prototype.getNowScale = function() {
      if (this.scale == null) {
        this.scale = this.initConfigScale;
      }
      return this.scale;
    };

    PrivateClass.prototype.getNowProgressScale = function() {
      if (this._progressScale != null) {
        return this._progressScale;
      } else {
        return this.getNowScale();
      }
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

    PrivateClass.setNowXAndY = function(x, y) {
      var ins, se;
      if (ScreenEvent.hasInstanceCache()) {
        se = new ScreenEvent();
        ins = PageValue.getInstancePageValue(PageValue.Key.instanceValue(se.id));
        if (ins != null) {
          ins.nowX = x;
          ins.nowY = y;
          PageValue.setInstancePageValue(PageValue.Key.instanceValue(se.id), ins);
        }
        se.nowX = x;
        return se.nowY = y;
      }
    };

    PrivateClass.resetNowScale = function() {
      var se;
      if (ScreenEvent.hasInstanceCache()) {
        se = new ScreenEvent();
        return se.scale = 1.0;
      }
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

    _setScale = function(scale) {
      this.scale = scale;
      return Common.applyViewScale();
    };

    _getScale = function() {
      return this.scale;
    };

    return PrivateClass;

  })(CommonEvent.PrivateClass);

  ScreenEvent.CLASS_DIST_TOKEN = ScreenEvent.PrivateClass.CLASS_DIST_TOKEN;

  return ScreenEvent;

})(CommonEvent);

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent);

//# sourceMappingURL=screen_event.js.map
