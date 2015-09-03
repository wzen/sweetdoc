// Generated by CoffeeScript 1.9.2
var Handwrite;

Handwrite = (function() {
  function Handwrite() {}

  Handwrite.initHandwrite = function() {
    var MOVE_FREQUENCY, click, drag, enableMoveEvent, item, lastX, lastY, mouseDownDrawing, mouseMoveDrawing, mouseUpDrawing, queueLoc, windowToCanvas, zindex;
    drag = false;
    click = false;
    lastX = null;
    lastY = null;
    item = null;
    enableMoveEvent = true;
    queueLoc = null;
    zindex = Constant.Zindex.EVENTBOTTOM + window.scrollInside.children().length + 1;
    MOVE_FREQUENCY = 7;
    windowToCanvas = function(canvas, x, y) {
      var bbox;
      bbox = canvas.getBoundingClientRect();
      return {
        x: x - bbox.left * (canvas.width / bbox.width),
        y: y - bbox.top * (canvas.height / bbox.height)
      };
    };
    mouseDownDrawing = function(loc) {
      if (typeof selectItemMenu !== "undefined" && selectItemMenu !== null) {
        item = new (Common.getClassFromMap(false, selectItemMenu))(loc);
        window.instanceMap[item.id] = item;
        item.saveDrawingSurface();
        WorktableCommon.changeMode(Constant.Mode.DRAW);
        return item.startDraw();
      }
    };
    mouseMoveDrawing = function(loc) {
      var q;
      if (item != null) {
        if (enableMoveEvent) {
          enableMoveEvent = false;
          drag = true;
          item.draw(loc);
          if (queueLoc !== null) {
            q = queueLoc;
            queueLoc = null;
            item.draw(q);
          }
          return enableMoveEvent = true;
        } else {
          return queueLoc = loc;
        }
      }
    };
    mouseUpDrawing = function() {
      if (item != null) {
        item.restoreAllDrawingSurface();
        item.endDraw(zindex);
        item.setupDragAndResizeEvents();
        WorktableCommon.changeMode(Constant.Mode.EDIT);
        item.saveObj(true);
        return zindex += 1;
      }
    };
    return (function(_this) {
      return function() {
        var calcCanvasLoc, saveLastLoc;
        calcCanvasLoc = function(e) {
          var x, y;
          x = e.x || e.clientX;
          y = e.y || e.clientY;
          return windowToCanvas(drawingCanvas, x, y);
        };
        saveLastLoc = function(loc) {
          lastX = loc.x;
          return lastY = loc.y;
        };
        drawingCanvas.onmousedown = function(e) {
          var loc;
          if (e.which === 1) {
            loc = calcCanvasLoc(e);
            saveLastLoc(loc);
            click = true;
            if (mode === Constant.Mode.DRAW) {
              e.preventDefault();
              return mouseDownDrawing(loc);
            } else if (mode === Constant.Mode.OPTION) {
              Sidebar.closeSidebar();
              return WorktableCommon.changeMode(Constant.Mode.EDIT);
            }
          }
        };
        drawingCanvas.onmousemove = function(e) {
          var loc;
          if (e.which === 1) {
            loc = calcCanvasLoc(e);
            if (click && Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY) {
              if (mode === Constant.Mode.DRAW) {
                e.preventDefault();
                mouseMoveDrawing(loc);
              }
              return saveLastLoc(loc);
            }
          }
        };
        return drawingCanvas.onmouseup = function(e) {
          if (e.which === 1) {
            if (drag && mode === Constant.Mode.DRAW) {
              e.preventDefault();
              mouseUpDrawing();
            }
          }
          drag = false;
          return click = false;
        };
      };
    })(this)();
  };

  return Handwrite;

})();

//# sourceMappingURL=handwrite.js.map
