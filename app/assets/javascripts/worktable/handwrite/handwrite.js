// Generated by CoffeeScript 1.9.2
var Handwrite;

Handwrite = (function() {
  function Handwrite() {}

  Handwrite.drag = false;

  Handwrite.click = false;

  Handwrite.enableMoveEvent = true;

  Handwrite.queueLoc = null;

  Handwrite.zindex = null;

  Handwrite.initHandwrite = function() {
    var MOVE_FREQUENCY, _windowToCanvas, lastX, lastY;
    this.drag = false;
    this.click = false;
    window.handwritingItem = null;
    lastX = null;
    lastY = null;
    this.enableMoveEvent = true;
    this.queueLoc = null;
    this.zindex = Constant.Zindex.EVENTBOTTOM + window.scrollInside.children().length + 1;
    MOVE_FREQUENCY = 7;
    _windowToCanvas = function(canvas, x, y) {
      var bbox;
      bbox = canvas.getBoundingClientRect();
      return {
        x: x - bbox.left * (canvas.width / bbox.width),
        y: y - bbox.top * (canvas.height / bbox.height)
      };
    };
    return (function(_this) {
      return function() {
        var _calcCanvasLoc, _saveLastLoc;
        _calcCanvasLoc = function(e) {
          var scaleFromStateConfig, x, y;
          scaleFromStateConfig = PageValue.getGeneralPageValue(PageValue.Key.scaleFromStateConfig());
          if (!scaleFromStateConfig) {
            scaleFromStateConfig = 1.0;
          }
          x = (e.x || e.clientX) / scaleFromStateConfig;
          y = (e.y || e.clientY) / scaleFromStateConfig;
          return _windowToCanvas(drawingCanvas, x, y);
        };
        _saveLastLoc = function(loc) {
          lastX = loc.x;
          return lastY = loc.y;
        };
        drawingCanvas.onmousedown = function(e) {
          var loc;
          if (e.which === 1) {
            loc = _calcCanvasLoc.call(_this, e);
            _saveLastLoc(loc);
            _this.click = true;
            if (_this.isDrawMode(_this)) {
              e.preventDefault();
              return _this.mouseDownDrawing(loc);
            }
          }
        };
        drawingCanvas.onmousemove = function(e) {
          var loc;
          if (e.which === 1) {
            loc = _calcCanvasLoc.call(_this, e);
            if (_this.click && Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY) {
              if (_this.isDrawMode(_this)) {
                e.preventDefault();
                _this.mouseMoveDrawing(loc);
              }
              return _saveLastLoc(loc);
            }
          }
        };
        return drawingCanvas.onmouseup = function(e) {
          if (e.which === 1) {
            if (_this.drag && _this.isDrawMode(_this)) {
              e.preventDefault();
              _this.mouseUpDrawing();
            }
          }
          _this.drag = false;
          return _this.click = false;
        };
      };
    })(this)();
  };

  Handwrite.mouseDownDrawing = function(loc) {
    if (window.mode === Constant.Mode.DRAW) {
      WorktableCommon.refreshAllItemsFromInstancePageValueIfChanging();
      if (typeof selectItemMenu !== "undefined" && selectItemMenu !== null) {
        window.handwritingItem = new (Common.getClassFromMap(selectItemMenu))(loc);
        window.instanceMap[window.handwritingItem.id] = window.handwritingItem;
        return window.handwritingItem.mouseDownDrawing();
      }
    }
  };

  Handwrite.mouseMoveDrawing = function(loc) {
    var q;
    if (window.handwritingItem != null) {
      if (this.enableMoveEvent) {
        this.enableMoveEvent = false;
        this.drag = true;
        window.handwritingItem.draw(loc);
        if (this.queueLoc !== null) {
          q = this.queueLoc;
          this.queueLoc = null;
          window.handwritingItem.draw(q);
        }
        return this.enableMoveEvent = true;
      } else {
        return this.queueLoc = loc;
      }
    }
  };

  Handwrite.mouseUpDrawing = function() {
    if (window.handwritingItem != null) {
      return window.handwritingItem.mouseUpDrawing(this.zindex, (function(_this) {
        return function() {
          _this.zindex += 1;
          return window.handwritingItem = null;
        };
      })(this));
    }
  };

  Handwrite.isDrawMode = function() {
    return window.mode === Constant.Mode.DRAW;
  };

  return Handwrite;

})();

//# sourceMappingURL=handwrite.js.map
