// Generated by CoffeeScript 1.9.2
var EventDragPointingDraw,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventDragPointingDraw = (function() {
  var instance;

  instance = null;

  function EventDragPointingDraw(cood) {
    if (cood == null) {
      cood = null;
    }
    return this.constructor.getInstance(cood);
  }

  EventDragPointingDraw.PrivateClass = (function(superClass) {
    extend(PrivateClass, superClass);

    function PrivateClass() {
      return PrivateClass.__super__.constructor.apply(this, arguments);
    }

    PrivateClass.NAME_PREFIX = "EDPointingDraw";

    PrivateClass.CLASS_DIST_TOKEN = 'EDPointingDraw';

    PrivateClass.include(itemBaseWorktableExtend);

    PrivateClass.prototype.setApplyCallback = function(callback) {
      return this.applyCallback = callback;
    };

    PrivateClass.prototype.setEndDrawCallback = function(callback) {
      return this.endDrawCallback = callback;
    };

    PrivateClass.prototype.clearDraw = function() {
      drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height);
      this.drawPaths = [];
      return this.drawPathIndex = 0;
    };

    PrivateClass.prototype.applyDraw = function() {
      drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height);
      if (this.applyCallback != null) {
        return this.applyCallback(this.drawPaths);
      }
    };

    PrivateClass.prototype.initData = function(multiDraw1) {
      this.multiDraw = multiDraw1;
      this.drawPaths = [];
      return this.drawPathIndex = 0;
    };

    PrivateClass.prototype.mouseDownDrawing = function(callback) {
      if (callback == null) {
        callback = null;
      }
      if (callback != null) {
        return callback();
      }
    };

    PrivateClass.prototype.mouseUpDrawing = function(zindex, callback) {
      if (callback == null) {
        callback = null;
      }
      return this.endDraw(callback);
    };

    PrivateClass.prototype.startCood = function(cood) {
      if (cood != null) {
        this._moveLoc = {
          x: cood.x,
          y: cood.y
        };
      }
      if (this.multiDraw && this.drawPaths.length > 0) {
        this.drawPathIndex += 1;
      } else {
        this.drawPaths = [];
        this.drawPathIndex = 0;
      }
      this.drawPaths[this.drawPathIndex] = [];
      return this.itemSize = null;
    };

    PrivateClass.prototype.draw = function(cood) {
      var d, i, idx, j, len, len1, p, ref, results;
      this.drawPaths[this.drawPathIndex].push(cood);
      ref = this.drawPaths;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        d = ref[i];
        drawingContext.beginPath();
        for (idx = j = 0, len1 = d.length; j < len1; idx = ++j) {
          p = d[idx];
          if (idx === 0) {
            drawingContext.moveTo(p.x, p.y);
          } else {
            drawingContext.lineTo(p.x, p.y);
          }
        }
        results.push(drawingContext.stroke());
      }
      return results;
    };

    PrivateClass.prototype.endDraw = function(zindex, show, callback) {
      if (show == null) {
        show = true;
      }
      if (callback == null) {
        callback = null;
      }
      if (this.endDrawCallback != null) {
        this.endDrawCallback(this.drawPaths);
      }
      FloatView.showPointingController(this);
      if (callback != null) {
        return callback();
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

  EventDragPointingDraw.getInstance = function(cood) {
    if (cood == null) {
      cood = null;
    }
    if (instance == null) {
      instance = new this.PrivateClass();
    }
    instance.startCood(cood);
    return instance;
  };

  EventDragPointingDraw.run = function(opt) {
    var applyDrawCallback, endDrawCallback, multiDraw, pointing;
    endDrawCallback = opt.endDrawCallback;
    applyDrawCallback = opt.applyDrawCallback;
    multiDraw = opt.multiDraw;
    if (multiDraw == null) {
      multiDraw = false;
    }
    pointing = new this();
    pointing.setApplyCallback((function(_this) {
      return function(pointingPaths) {
        var _cb;
        _cb = function() {
          pointing = new _this();
          pointing.getJQueryElement().remove();
          Handwrite.initHandwrite();
          return WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
        };
        if (applyDrawCallback != null) {
          if (applyDrawCallback(pointingPaths)) {
            return _cb.call(_this);
          }
        } else {
          return _cb.call(_this);
        }
      };
    })(this));
    pointing.setEndDrawCallback((function(_this) {
      return function(pointingPaths) {
        if (endDrawCallback != null) {
          return endDrawCallback(pointingPaths);
        }
      };
    })(this));
    pointing.initData(multiDraw);
    PointingHandwrite.initHandwrite(this);
    WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.DRAW);
    return FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, (function(_this) {
      return function() {
        pointing = new _this();
        pointing.getJQueryElement().remove();
        Handwrite.initHandwrite();
        return WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
      };
    })(this));
  };

  return EventDragPointingDraw;

})();

$.fn.eventDragPointingDraw = function(opt, eventType) {
  if (eventType == null) {
    eventType = 'click';
  }
  if (eventType === 'click') {
    return $(this).off('click.event_pointing_draw').on('click.event_pointing_draw', (function(_this) {
      return function(e) {
        return EventDragPointingDraw.run(opt);
      };
    })(this));
  } else if (eventType === 'change') {
    return $(this).off('change.event_pointing_draw').on('change.event_pointing_draw', (function(_this) {
      return function(e) {
        if ($(e.target).val === opt.targetValue) {
          return EventDragPointingDraw.run(opt);
        }
      };
    })(this));
  }
};

//# sourceMappingURL=event_drag_pointing_draw.js.map
