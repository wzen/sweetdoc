// Generated by CoffeeScript 1.9.2
var CanvasItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

CanvasItemBase = (function(superClass) {
  extend(CanvasItemBase, superClass);

  function CanvasItemBase() {
    CanvasItemBase.__super__.constructor.call(this);
    this.newDrawingSurfaceImageData = null;
    this.newDrawedSurfaceImageData = null;
    this.scale = {
      w: 1.0,
      h: 1.0
    };
    if (window.isWorkTable) {
      this.constructor.include(WorkTableCanvasItemExtend);
    }
  }

  CanvasItemBase.prototype.canvasElementId = function() {
    return this.id + '_canvas';
  };

  CanvasItemBase.prototype.setScale = function() {
    var canvas, context, element;
    element = $("#" + this.id);
    canvas = $("#" + (this.canvasElementId()));
    element.width(this.itemSize.w * this.scale.w);
    element.height(this.itemSize.h * this.scale.h);
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    context = canvas[0].getContext('2d');
    return context.scale(this.scale.w, this.scale.h);
  };

  CanvasItemBase.prototype.initCanvas = function() {
    return this.setScale();
  };

  CanvasItemBase.prototype.makeNewCanvas = function() {
    $(ElementCode.get().createItemElement(this)).appendTo(window.scrollInside);
    this.initCanvas();
    return this.saveNewDrawingSurface();
  };

  CanvasItemBase.prototype.saveNewDrawingSurface = function() {
    var canvas, context;
    canvas = document.getElementById(this.canvasElementId());
    if (canvas != null) {
      context = canvas.getContext('2d');
      return this.newDrawingSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height);
    }
  };

  CanvasItemBase.prototype.saveNewDrawedSurface = function() {
    var canvas, context;
    canvas = document.getElementById(this.canvasElementId());
    if (canvas != null) {
      context = canvas.getContext('2d');
      return this.newDrawedSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height);
    }
  };

  CanvasItemBase.prototype.restoreAllNewDrawingSurface = function() {
    var canvas, context;
    if (this.newDrawingSurfaceImageData != null) {
      canvas = document.getElementById(this.canvasElementId());
      if (canvas != null) {
        context = canvas.getContext('2d');
        return context.putImageData(this.newDrawingSurfaceImageData, 0, 0);
      }
    }
  };

  CanvasItemBase.prototype.restoreAllNewDrawedSurface = function() {
    var canvas, context;
    if (this.newDrawedSurfaceImageData) {
      canvas = document.getElementById(this.canvasElementId());
      if (canvas != null) {
        context = canvas.getContext('2d');
        return context.putImageData(this.newDrawedSurfaceImageData, 0, 0);
      }
    }
  };

  CanvasItemBase.prototype.clearDraw = function() {
    var canvas, context;
    canvas = document.getElementById(this.canvasElementId());
    if (canvas != null) {
      context = canvas.getContext('2d');
      context.clearRect(0, 0, canvas.width, canvas.height);
      return this.initCanvas();
    }
  };

  CanvasItemBase.prototype.stateEventBefore = function(isForward) {
    var h, itemDiff, obj, scale, sh, sw, w;
    obj = this.getMinimumObject();
    if (!isForward) {
      scale = obj.scale;
      itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
      obj.itemSize.x -= itemDiff.x;
      obj.itemSize.y -= itemDiff.y;
      w = scale.w * obj.itemSize.w;
      h = scale.h * obj.itemSize.h;
      sw = (w - itemDiff.w) / obj.itemSize.w;
      sh = (h - itemDiff.h) / obj.itemSize.h;
      obj.scale.w = sw;
      obj.scale.h = sh;
    }
    return obj;
  };

  CanvasItemBase.prototype.stateEventAfter = function(isForward) {
    var h, itemDiff, obj, scale, sh, sw, w;
    obj = this.getMinimumObject();
    if (isForward) {
      scale = obj.scale;
      itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
      obj.itemSize.x += itemDiff.x;
      obj.itemSize.y += itemDiff.y;
      w = scale.w * obj.itemSize.w;
      h = scale.h * obj.itemSize.h;
      sw = (w + itemDiff.w) / obj.itemSize.w;
      sh = (h + itemDiff.h) / obj.itemSize.h;
      obj.scale.w = sw;
      obj.scale.h = sh;
    }
    return obj;
  };

  CanvasItemBase.prototype.updateEventBefore = function() {
    var capturedEventBeforeObject, itemSize;
    CanvasItemBase.__super__.updateEventBefore.call(this);
    capturedEventBeforeObject = this.getCapturedEventBeforeObject();
    if (capturedEventBeforeObject) {
      itemSize = Common.makeClone(capturedEventBeforeObject.itemSize);
      itemSize.w *= capturedEventBeforeObject.scale.w;
      itemSize.h *= capturedEventBeforeObject.scale.h;
      return this.updatePositionAndItemSize(itemSize, false);
    }
  };

  CanvasItemBase.prototype.updateEventAfter = function() {
    var capturedEventAfterObject, itemSize;
    CanvasItemBase.__super__.updateEventAfter.call(this);
    capturedEventAfterObject = this.getCapturedEventAfterObject();
    if (capturedEventAfterObject) {
      itemSize = Common.makeClone(capturedEventAfterObject.itemSize);
      itemSize.w *= capturedEventAfterObject.scale.w;
      itemSize.h *= capturedEventAfterObject.scale.h;
      return this.updatePositionAndItemSize(itemSize, false);
    }
  };

  CanvasItemBase.prototype.updateItemSize = function(w, h) {
    var canvas, drawingCanvas, drawingContext, element, scaleH, scaleW;
    element = $('#' + this.id);
    element.css({
      width: w,
      height: h
    });
    canvas = $('#' + this.canvasElementId());
    scaleW = element.width() / this.itemSize.w;
    scaleH = element.height() / this.itemSize.h;
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    drawingContext.scale(scaleW, scaleH);
    this.scale.w = scaleW;
    this.scale.h = scaleH;
    return this.drawNewCanvas();
  };

  CanvasItemBase.prototype.originalItemElementSize = function() {
    var capturedEventBeforeObject, itemSize, originalScale;
    capturedEventBeforeObject = this.getCapturedEventBeforeObject();
    itemSize = capturedEventBeforeObject.itemSize;
    originalScale = capturedEventBeforeObject.scale;
    return {
      x: itemSize.x,
      y: itemSize.y,
      w: itemSize.w * originalScale.w,
      h: itemSize.h * originalScale.h
    };
  };

  CanvasItemBase.prototype.applyDesignChange = function(doStyleSave) {
    this.reDraw();
    if (doStyleSave) {
      return this.saveDesign();
    }
  };

  CanvasItemBase.prototype.applyDesignTool = function() {
    var drawingCanvas, drawingContext;
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    (function(_this) {
      return (function() {
        var centorCood, deg, endX, endY, gradient, halfSlopLength, l1, pi, startX, startY, tanX, tanY;
        halfSlopLength = Math.sqrt(Math.pow(drawingCanvas.width / 2.0, 2) + Math.pow(drawingCanvas.height / 2.0, 2));
        deg = _this.designs.values.design_slider_gradient_deg_value;
        pi = deg / 180.0 * Math.PI;
        tanX = drawingCanvas.width * (Math.sin(pi) >= 0 ? Math.ceil(Math.sin(pi)) : Math.floor(Math.sin(pi)));
        tanY = drawingCanvas.height * (Math.cos(pi) >= 0 ? Math.ceil(Math.cos(pi)) : Math.floor(Math.cos(pi)));
        l1 = halfSlopLength * Math.cos(Math.abs((Math.atan2(tanX, tanY) * 180.0 / Math.PI) - deg) / 180.0 * Math.PI);
        centorCood = {
          x: drawingCanvas.width / 2.0,
          y: drawingCanvas.height / 2.0
        };
        startX = centorCood.x + parseInt(l1 * Math.sin(pi));
        startY = centorCood.y - parseInt(l1 * Math.cos(pi));
        endX = centorCood.x + parseInt(l1 * Math.sin(pi + Math.PI));
        endY = centorCood.y - parseInt(l1 * Math.cos(pi + Math.PI));
        gradient = drawingContext.createLinearGradient(startX, startY, endX, endY);
        gradient.addColorStop(0, "#" + _this.designs.values.design_bg_color1_value);
        if (_this.designs.flags.design_bg_color2_flag) {
          gradient.addColorStop(_this.designs.values.design_bg_color2_position_value / 100, "#" + _this.designs.values.design_bg_color2_value);
        }
        if (_this.designs.flags.design_bg_color3_flag) {
          gradient.addColorStop(_this.designs.values.design_bg_color3_position_value / 100, "#" + _this.designs.values.design_bg_color3_value);
        }
        if (_this.designs.flags.design_bg_color4_flag) {
          gradient.addColorStop(_this.designs.values.design_bg_color4_position_value / 100, "#" + _this.designs.values.design_bg_color4_value);
        }
        gradient.addColorStop(1, "#" + _this.designs.values.design_bg_color5_value);
        return drawingContext.fillStyle = gradient;
      });
    })(this)();
    (function(_this) {
      return (function() {
        drawingContext.shadowColor = "rgba(" + _this.designs.values.design_shadow_color_value + "," + _this.designs.values.design_slider_shadow_opacity_value + ")";
        drawingContext.shadowOffsetX = _this.designs.values.design_slider_shadow_left_value;
        drawingContext.shadowOffsetY = _this.designs.values.design_slider_shadow_top_value;
        return drawingContext.shadowBlur = _this.designs.values.design_slider_shadow_size_value;
      });
    })(this)();
    return drawingContext.fill();
  };

  return CanvasItemBase;

})(ItemBase);

//# sourceMappingURL=canvas_item_base.js.map
