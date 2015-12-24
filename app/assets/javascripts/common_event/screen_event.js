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

  ScreenEvent.PrivateClass = (function(superClass1) {
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
            afterX: scrollContents.scrollTop(),
            afterY: scrollContents.scrollLeft(),
            afterZ: 1
          }
        }
      }
    };

    function PrivateClass() {
      this.changeScreenPosition = bind(this.changeScreenPosition, this);
      PrivateClass.__super__.constructor.call(this);
      this.beforeScrollTop = scrollContents.scrollTop();
      this.beforeScrollLeft = scrollContents.scrollLeft();
      this.beforeZoom = 1.0;
    }

    PrivateClass.prototype.updateEventBefore = function() {
      var methodName;
      PrivateClass.__super__.updateEventBefore.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        return Common.updateScrollContentsPosition(this.beforeScrollTop, this.beforeScrollLeft);
      }
    };

    PrivateClass.prototype.updateEventAfter = function() {
      var methodName, scrollLeft, scrollTop;
      PrivateClass.__super__.updateEventAfter.call(this);
      methodName = this.getEventMethodName();
      if (methodName === 'changeScreenPosition') {
        scrollTop = parseInt(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX);
        scrollLeft = parseInt(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY);
        return Common.updateScrollContentsPosition(scrollTop, scrollLeft);
      }
    };

    PrivateClass.prototype.changeScreenPosition = function(opt) {
      var _drawOverlay, actionType, canvas, canvasContext, finished_count, overlay, scale, scrollLeft, scrollTop, x, y;
      _drawOverlay = function(context, x, y, scale) {
        var _rect, left, screenSize, top;
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
        screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
        top = y - (screenSize.height * scale) / 2.0;
        left = x - (screenSize.width * scale) / 2.0;
        _rect(context, left, top, screenSize.width * scale, screenSize.height * scale);
        context.fill();
        return context.restore();
      };
      x = (this._specificMethodValues.afterX - this.beforeScrollLeft) * (opt.progress / opt.progressMax) + this.beforeScrollLeft;
      y = (this._specificMethodValues.afterY - this.beforeScrollTop) * (opt.progress / opt.progressMax) + this.beforeScrollTop;
      scale = (this._specificMethodValues.afterZ - this.beforeZoom) * (opt.progress / opt.progressMax) + this.beforeZoom;
      if (opt.isPreview) {
        if (opt.keepDispMag && scale < 1.0) {
          overlay = $('#preview_position_overlay');
          if ((overlay == null) || overlay.length === 0) {
            canvas = $("<canvas id='preview_position_overlay' style='background-color: transparent; width: 100%; height: 100%; z-index: " + (Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1) + "'></canvas>");
            window.drawingCanvas.parent().append(canvas);
            overlay = $('#preview_position_overlay');
          }
          canvasContext = overlay[0].getContent('2d');
          _drawOverlay.call(canvasContext, x, y, scale);
        } else {
          $('#preview_position_overlay').remove();
        }
      }
      actionType = this.getEventActionType();
      if (actionType === Constant.ActionType.CLICK) {
        finished_count = 0;
        scrollLeft = parseInt(x);
        scrollTop = parseInt(y);
        Common.updateScrollContentsPosition(scrollTop, scrollLeft, false, function() {
          finished_count += 1;
          if (finished_count >= 2) {
            this._isFinishedEvent = true;
            if (opt.complete != null) {
              return opt.complete();
            }
          }
        });
        return this.getJQueryElement().transition({
          scale: "" + scale
        }, 'normal', 'linear', function() {
          finished_count += 1;
          if (finished_count >= 2) {
            this._isFinishedEvent = true;
            if (opt.complete != null) {
              return opt.complete();
            }
          }
        });
      }
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
          pointing.setDrawEndCallback(function(pointingSize) {
            return _updateConfigInput.call(_this, emt, pointingSize);
          });
          pointing.setDragCallback(function(pointingSize) {
            return _updateConfigInput.call(_this, emt, pointingSize);
          });
          pointing.setResizeCallback(function(pointingSize) {
            return _updateConfigInput.call(_this, emt, pointingSize);
          });
          WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.DRAW);
          return FloatView.showFixed('Drag position', FloatView.Type.INFO, function() {
            return WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT);
          });
        };
      })(this));
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
