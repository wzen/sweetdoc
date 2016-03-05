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
    var _getInitScale, _overlay, _setScaleAndUpdateViewing;

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
      this.initConfigX = null;
      this.initConfigY = null;
      this.initConfigScale = 1.0;
      this.eventBaseX = null;
      this.eventBaseY = null;
      this.eventBaseScale = null;
      this.previewLaunchBaseScale = null;
      this._notMoving = true;
      this._initDone = false;
    }

    PrivateClass.prototype.initEvent = function(event, _keepDispMag) {
      this._keepDispMag = _keepDispMag != null ? _keepDispMag : false;
      return PrivateClass.__super__.initEvent.call(this, event);
    };

    PrivateClass.prototype.initPreview = function() {
      this.previewLaunchBaseScale = this.eventBaseScale;
      if (this._notMoving) {
        this.previewLaunchBaseScale = _getInitScale.call(this);
        if (this.hasInitConfig()) {
          if (!this._keepDispMag) {
            Common.updateScrollContentsPosition(this.initConfigY, this.initConfigX, true, false);
          }
          this.eventBaseX = this.initConfigX;
          this.eventBaseY = this.initConfigY;
          return this.eventBaseScale = this.initConfigScale;
        }
      }
    };

    PrivateClass.prototype.refresh = function(show, callback) {
      var s;
      if (show == null) {
        show = true;
      }
      if (callback == null) {
        callback = null;
      }
      s = null;
      if (window.isWorkTable && (!window.previewRunning || this._keepDispMag)) {
        this.resetNowScaleToWorktableScale();
        _setScaleAndUpdateViewing.call(this, WorktableCommon.getWorktableViewScale());
        if (!window.previewRunning) {
          this._notMoving = true;
        }
      } else if (this._notMoving) {
        _setScaleAndUpdateViewing.call(this, _getInitScale.call(this));
      } else {
        _setScaleAndUpdateViewing.call(this, this.eventBaseScale);
      }
      $('#preview_position_overlay').remove();
      $('.keep_mag_base').remove();
      if (callback != null) {
        return callback(this);
      }
    };

    PrivateClass.prototype.updateEventBefore = function() {
      var methodName, scrollContentsSize, size;
      PrivateClass.__super__.updateEventBefore.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        if (!this._keepDispMag && (this.eventBaseScale != null)) {
          _setScaleAndUpdateViewing.call(this, this.eventBaseScale);
          size = Common.convertCenterCoodToSize(this.eventBaseX, this.eventBaseY, this.eventBaseScale);
          scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
          return Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false);
        }
      }
    };

    PrivateClass.prototype.updateEventAfter = function() {
      var methodName, p, scrollContentsSize, size;
      PrivateClass.__super__.updateEventAfter.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        p = Common.calcScrollTopLeftPosition(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY, this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX);
        this._progressX = parseFloat(p.left);
        this._progressY = parseFloat(p.top);
        this._progressScale = parseFloat(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ);
        if (this._keepDispMag) {
          _setScaleAndUpdateViewing.call(this, WorktableCommon.getWorktableViewScale());
          return _overlay.call(this, this._progressX, this._progressY, this._progressScale);
        } else {
          _setScaleAndUpdateViewing.call(this, this._progressScale);
          size = Common.convertCenterCoodToSize(this._progressX, this._progressY, this._progressScale);
          scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
          return Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false);
        }
      }
    };

    PrivateClass.prototype.changeScreenPosition = function(opt) {
      var p, scrollContentsSize, size;
      p = Common.calcScrollTopLeftPosition(this._specificMethodValues.afterY, this._specificMethodValues.afterX);
      this._progressScale = (parseFloat(this._specificMethodValues.afterZ) - this.eventBaseScale) * (opt.progress / opt.progressMax) + this.eventBaseScale;
      this._progressX = ((parseFloat(p.left) - this.eventBaseX) * (opt.progress / opt.progressMax)) + this.eventBaseX;
      this._progressY = ((parseFloat(p.top) - this.eventBaseY) * (opt.progress / opt.progressMax)) + this.eventBaseY;
      if (window.isWorkTable && opt.isPreview) {
        _overlay.call(this, this._progressX, this._progressY, this._progressScale);
        if (this._keepDispMag) {
          _setScaleAndUpdateViewing.call(this, WorktableCommon.getWorktableViewScale());
        }
      }
      if (!this._keepDispMag) {
        _setScaleAndUpdateViewing.call(this, this._progressScale);
        size = Common.convertCenterCoodToSize(this._progressX, this._progressY, this._progressScale);
        scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
        return Common.updateScrollContentsPosition(size.top + scrollContentsSize.height * 0.5, size.left + scrollContentsSize.width * 0.5, true, false);
      }
    };

    PrivateClass.prototype.stopPreview = function(callback) {
      if (callback == null) {
        callback = null;
      }
      setTimeout(function() {
        return $('#preview_position_overlay').remove();
      }, 0);
      return PrivateClass.__super__.stopPreview.call(this, callback);
    };

    PrivateClass.prototype.willChapter = function(callback) {
      if (callback == null) {
        callback = null;
      }
      if (window.previewRunning) {
        this.eventBaseScale = this.previewLaunchBaseScale;
      } else {
        if (this._notMoving) {
          this.eventBaseScale = _getInitScale.call(this);
        }
      }
      return PrivateClass.__super__.willChapter.call(this, callback);
    };

    PrivateClass.prototype.didChapter = function(callback) {
      if (callback == null) {
        callback = null;
      }
      this.eventBaseX = this._progressX;
      this.eventBaseY = this._progressY;
      this.eventBaseScale = this._progressScale;
      this._progressScale = null;
      return PrivateClass.__super__.didChapter.call(this, callback);
    };

    PrivateClass.prototype.setMiniumObject = function(obj) {
      PrivateClass.__super__.setMiniumObject.call(this, obj);
      if (!this._initDone) {
        if (!window.isWorkTable) {
          Common.initScrollContentsPosition();
          _setScaleAndUpdateViewing.call(this, _getInitScale.call(this));
          this.eventBaseScale = _getInitScale.call(this);
          RunCommon.updateMainViewSize();
        } else {
          WorktableCommon.initScrollContentsPosition();
          WorktableCommon.updateMainViewSize();
        }
        this._initDone = true;
        return this._notMoving = true;
      }
    };

    PrivateClass.prototype.getNowScreenEventScale = function() {
      if (this._nowScreenEventScale == null) {
        this._nowScreenEventScale = _getInitScale.call(this);
      }
      return this._nowScreenEventScale;
    };

    PrivateClass.prototype.hasInitConfig = function() {
      return (this.initConfigX != null) && (this.initConfigY != null);
    };

    PrivateClass.prototype.setInitConfig = function(x, y, scale) {
      this.initConfigX = x;
      this.initConfigY = y;
      this.initConfigScale = scale;
      this.eventBaseScale = this.initConfigScale;
      return this.setItemAllPropToPageValue();
    };

    PrivateClass.prototype.clearInitConfig = function() {
      var s;
      this.initConfigX = null;
      this.initConfigY = null;
      s = 1.0;
      this.initConfigScale = s;
      this.eventBaseScale = s;
      return this.setItemAllPropToPageValue();
    };

    PrivateClass.prototype.resetNowScaleToWorktableScale = function() {
      return this.eventBaseScale = WorktableCommon.getWorktableViewScale();
    };

    PrivateClass.prototype.setEventBaseXAndY = function(x, y) {
      var ins;
      if (ScreenEvent.hasInstanceCache()) {
        ins = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
        if (ins != null) {
          ins.eventBaseX = x;
          ins.eventBaseY = y;
          PageValue.setInstancePageValue(PageValue.Key.instanceValue(this.id), ins);
        }
        this.eventBaseX = x;
        return this.eventBaseY = y;
      }
    };

    PrivateClass.initSpecificConfig = function(specificRoot) {
      var _updateConfigInput, c, emt, h, screenSize, size, w, x, xVal, y, yVal, z, zVal;
      _updateConfigInput = function(emt, pointingSize) {
        var center, screenSize, x, y, z;
        x = pointingSize.x + pointingSize.w * 0.5;
        y = pointingSize.y + pointingSize.h * 0.5;
        z = null;
        screenSize = Common.getScreenSize();
        if (pointingSize.w > pointingSize.h) {
          z = screenSize.width / pointingSize.w;
        } else {
          z = screenSize.height / pointingSize.h;
        }
        center = Common.calcScrollCenterPosition(y, x);
        emt.find('.afterX:first').removeClass('empty').val(center.left);
        emt.find('.afterY:first').removeClass('empty').val(center.top);
        return emt.find('.afterZ:first').removeClass('empty').val(z);
      };
      emt = specificRoot['changeScreenPosition'];
      x = emt.find('.afterX:first');
      xVal = null;
      yVal = null;
      zVal = null;
      size = null;
      if (x.val().length === 0) {
        x.attr('disabled', 'disabled').addClass('empty');
      } else {
        xVal = parseFloat(x.val());
      }
      y = emt.find('.afterY:first');
      if (y.val().length === 0) {
        y.attr('disabled', 'disabled').addClass('empty');
      } else {
        yVal = parseFloat(y.val());
      }
      z = emt.find('.afterZ:first');
      if (z.val().length === 0) {
        z.attr('disabled', 'disabled').addClass('empty');
      } else {
        zVal = parseFloat(z.val());
      }
      if ((xVal != null) && (yVal != null) && (zVal != null)) {
        c = Common.calcScrollTopLeftPosition(yVal, xVal);
        screenSize = Common.getScreenSize();
        w = screenSize.width / zVal;
        h = screenSize.height / zVal;
        size = {
          x: c.left - w * 0.5,
          y: c.top - h * 0.5,
          w: w,
          h: h
        };
        EventDragPointingRect.draw(size);
      } else {
        EventDragPointingRect.clear();
      }
      return emt.find('.event_pointing:first').eventDragPointingRect({
        applyDrawCallback: (function(_this) {
          return function(pointingSize) {
            return _updateConfigInput.call(_this, emt, pointingSize);
          };
        })(this),
        closeCallback: (function(_this) {
          return function() {
            return EventDragPointingRect.draw(size);
          };
        })(this)
      });
    };

    _overlay = function(x, y, scale) {
      var _drawOverlay, canvas, canvasContext, h, overlay, w;
      _drawOverlay = function(context, x, y, width, height, scale) {
        var _rect, h, left, size, top, w, wScale;
        _rect = function(context, x, y, w, h) {
          context.moveTo(x, y);
          context.lineTo(x, y + h);
          context.lineTo(x + w, y + h);
          context.lineTo(x + w, y);
          return context.closePath();
        };
        context.save();
        context.fillStyle = "rgba(33, 33, 33, 0.5)";
        context.beginPath();
        context.rect(0, 0, width, height);
        wScale = WorktableCommon.getWorktableViewScale();
        size = Common.convertCenterCoodToSize(x, y, wScale);
        w = size.width * wScale / scale;
        h = size.height * wScale / scale;
        top = y - h / 2.0;
        left = x - w / 2.0;
        context.clearRect(0, 0, width, height);
        _rect.call(this, context, left - window.scrollContents.scrollLeft(), top - window.scrollContents.scrollTop(), w, h);
        context.fill();
        return context.restore();
      };
      if (this._keepDispMag && scale > WorktableCommon.getWorktableViewScale()) {
        overlay = $('#preview_position_overlay');
        if ((overlay == null) || overlay.length === 0) {
          w = $(window.drawingCanvas).attr('width');
          h = $(window.drawingCanvas).attr('height');
          canvas = $("<canvas id='preview_position_overlay' class='canvas_container canvas' width='" + w + "' height='" + h + "' style='z-index: " + (Common.plusPagingZindex(constant.Zindex.EVENTFLOAT) + 1) + "'></canvas>");
          $(window.drawingCanvas).parent().append(canvas);
          overlay = $('#preview_position_overlay');
        }
        canvasContext = overlay[0].getContext('2d');
        return _drawOverlay.call(this, canvasContext, x, y, overlay.width(), overlay.height(), scale);
      } else {
        return $('#preview_position_overlay').remove();
      }
    };

    _setScaleAndUpdateViewing = function(scale) {
      this._nowScreenEventScale = scale;
      this._notMoving = false;
      return Common.applyViewScale();
    };

    _getInitScale = function() {
      if (window.isWorkTable && !window.previewRunning) {
        return WorktableCommon.getWorktableViewScale();
      } else if (this.initConfigScale != null) {
        return this.initConfigScale;
      } else {
        return 1.0;
      }
    };

    return PrivateClass;

  })(CommonEvent.PrivateClass);

  ScreenEvent.CLASS_DIST_TOKEN = ScreenEvent.PrivateClass.CLASS_DIST_TOKEN;

  return ScreenEvent;

})(CommonEvent);

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent);

//# sourceMappingURL=screen_event.js.map
