// Generated by CoffeeScript 1.9.2
var EventDragPointing,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventDragPointing = (function() {
  var instance;

  instance = null;

  function EventDragPointing(cood) {
    if (cood == null) {
      cood = null;
    }
    return this.constructor.getInstance(cood);
  }

  EventDragPointing.PrivateClass = (function(superClass) {
    extend(PrivateClass, superClass);

    function PrivateClass() {
      return PrivateClass.__super__.constructor.apply(this, arguments);
    }

    PrivateClass.NAME_PREFIX = "EDPointing";

    PrivateClass.CLASS_DIST_TOKEN = 'EDPointing';

    PrivateClass.include(itemBaseWorktableExtend);

    PrivateClass.prototype.setDrawCallback = function(callback) {
      return this.drawCallback = callback;
    };

    PrivateClass.prototype.mouseDownDrawing = function(callback) {
      if (callback == null) {
        callback = null;
      }
      this.saveDrawingSurface();
      this.removeItemElement();
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

    PrivateClass.prototype.endDraw = function(callback) {
      if (callback == null) {
        callback = null;
      }
      this.itemSize.x += scrollContents.scrollLeft();
      this.itemSize.y += scrollContents.scrollTop();
      this.zindex = Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT) + 1;
      return this.refresh(true, (function(_this) {
        return function() {
          _this.getJQueryElement().addClass('drag_pointing');
          _this.setupDragAndResizeEvent();
          if (_this.drawCallback != null) {
            _this.drawCallback(_this.itemSize);
          }
          if (callback != null) {
            return callback();
          }
        };
      })(this));
    };

    PrivateClass.prototype.drag = function() {
      if (this.drawCallback != null) {
        return this.drawCallback(this.itemSize);
      }
    };

    PrivateClass.prototype.resize = function() {
      if (this.drawCallback != null) {
        return this.drawCallback(this.itemSize);
      }
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

  EventDragPointing.getInstance = function(cood) {
    if (cood == null) {
      cood = null;
    }
    if (instance == null) {
      instance = new this.PrivateClass();
    }
    instance.startCood(cood);
    return instance;
  };

  return EventDragPointing;

})();

$.fn.eventDragPointing = function(endDrawCallback) {
  return $(this).off('click').on('click', (function(_this) {
    return function(e) {
      var pointing;
      pointing = new EventDragPointing();
      pointing.setDrawCallback(function(pointingSize) {
        return endDrawCallback(pointingSize);
      });
      PointingHandwrite.initHandwrite();
      WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.DRAW);
      return FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, function() {
        Handwrite.initHandwrite();
        return WorktableCommon.changeEventPointingMode(Constant.EventInputPointingMode.NOT_SELECT);
      });
    };
  })(this));
};

//# sourceMappingURL=event_drag_pointing.js.map
