// Generated by CoffeeScript 1.10.0
var EventDragPointingRect,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventDragPointingRect = (function() {
  var instance;

  instance = null;

  function EventDragPointingRect(cood) {
    if (cood == null) {
      cood = null;
    }
    return this.constructor.getInstance(cood);
  }

  EventDragPointingRect.PrivateClass = (function(superClass) {
    extend(PrivateClass, superClass);

    function PrivateClass() {
      return PrivateClass.__super__.constructor.apply(this, arguments);
    }

    PrivateClass.NAME_PREFIX = "EDPointingRect";

    PrivateClass.CLASS_DIST_TOKEN = 'EDPointingRect';

    PrivateClass.include(itemBaseWorktableExtend);

    PrivateClass.prototype.setApplyCallback = function(callback) {
      return this.applyCallback = callback;
    };

    PrivateClass.prototype.clearDraw = function() {
      return this.removeItemElement();
    };

    PrivateClass.prototype.applyDraw = function() {
      if (this.applyCallback != null) {
        return this.applyCallback(this.itemSize);
      }
    };

    PrivateClass.prototype.mouseDownDrawing = function(callback) {
      if (callback == null) {
        callback = null;
      }
      this.removeItemElement();
      this.saveDrawingSurface();
      if (callback != null) {
        return callback();
      }
    };

    PrivateClass.prototype.mouseUpDrawing = function(zindex, callback) {
      if (callback == null) {
        callback = null;
      }
      this.restoreAllDrawingSurface();
      return this.endDraw(callback);
    };

    PrivateClass.prototype.startCood = function(cood) {
      if (cood != null) {
        this._moveLoc = {
          x: cood.x,
          y: cood.y
        };
      }
      return this.itemSize = null;
    };

    PrivateClass.prototype.draw = function(cood) {
      if (this.itemSize !== null) {
        this.restoreRefreshingSurface(this.itemSize);
      }
      this.itemSize = {
        x: null,
        y: null,
        w: null,
        h: null
      };
      this.itemSize.w = Math.abs(cood.x - this._moveLoc.x);
      this.itemSize.h = Math.abs(cood.y - this._moveLoc.y);
      if (cood.x > this._moveLoc.x) {
        this.itemSize.x = this._moveLoc.x;
      } else {
        this.itemSize.x = cood.x;
      }
      if (cood.y > this._moveLoc.y) {
        this.itemSize.y = this._moveLoc.y;
      } else {
        this.itemSize.y = cood.y;
      }
      return drawingContext.strokeRect(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h);
    };

    PrivateClass.prototype.endDraw = function(zindex, show, callback) {
      if (show == null) {
        show = true;
      }
      if (callback == null) {
        callback = null;
      }
      this.itemSize.x += scrollContents.scrollLeft();
      this.itemSize.y += scrollContents.scrollTop();
      this.zindex = Common.plusPagingZindex(constant.Zindex.EVENTFLOAT) + 1;
      return this.refresh(true, (function(_this) {
        return function() {
          _this.getJQueryElement().addClass('drag_pointing');
          FloatView.showPointingController(_this);
          if (callback != null) {
            return callback();
          }
        };
      })(this), false);
    };

    PrivateClass.prototype.saveObj = function(newCreated) {
      if (newCreated == null) {
        newCreated = false;
      }
    };

    PrivateClass.prototype.getItemPropFromPageValue = function(prop, isCache) {
      if (isCache == null) {
        isCache = false;
      }
    };

    PrivateClass.prototype.setItemPropToPageValue = function(prop, value, isCache) {
      if (isCache == null) {
        isCache = false;
      }
    };

    PrivateClass.prototype.applyDefaultDesign = function() {};

    PrivateClass.prototype.makeCss = function(forceUpdate) {
      if (forceUpdate == null) {
        forceUpdate = false;
      }
    };

    return PrivateClass;

  })(CssItemBase);

  EventDragPointingRect.getInstance = function(cood) {
    if (cood == null) {
      cood = null;
    }
    if (instance == null) {
      instance = new this.PrivateClass();
    }
    instance.startCood(cood);
    return instance;
  };

  EventDragPointingRect.run = function(opt) {
    var applyDrawCallback, closeCallback, pointing;
    applyDrawCallback = opt.applyDrawCallback;
    closeCallback = opt.closeCallback;
    pointing = new this();
    pointing.setApplyCallback((function(_this) {
      return function(pointingSize) {
        applyDrawCallback(pointingSize);
        Handwrite.initHandwrite();
        WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
        return EventDragPointingRect.draw(pointingSize);
      };
    })(this));
    PointingHandwrite.initHandwrite(this);
    WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.DRAW);
    FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, (function(_this) {
      return function() {
        if (closeCallback != null) {
          closeCallback();
        } else {
          pointing = new _this();
          pointing.getJQueryElement().remove();
        }
        Handwrite.initHandwrite();
        return WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
      };
    })(this));
    return this.clear();
  };

  EventDragPointingRect.draw = function(size) {
    var pointing;
    if (size != null) {
      pointing = new this();
      pointing.itemSize = size;
      pointing.zindex = Common.plusPagingZindex(constant.Zindex.EVENTFLOAT) + 1;
      return pointing.refresh(true, (function(_this) {
        return function() {
          return pointing.getJQueryElement().addClass('drag_pointing');
        };
      })(this), false);
    }
  };

  EventDragPointingRect.clear = function() {
    var pointing;
    pointing = new this();
    return pointing.clearDraw();
  };

  return EventDragPointingRect;

})();

$.fn.eventDragPointingRect = function(opt, eventType) {
  if (eventType == null) {
    eventType = 'click';
  }
  if (eventType === 'click') {
    return $(this).off('click.event_pointing_rect').on('click.event_pointing_rect', (function(_this) {
      return function(e) {
        return EventDragPointingRect.run(opt);
      };
    })(this));
  }
};

//# sourceMappingURL=event_drag_pointing_rect.js.map
