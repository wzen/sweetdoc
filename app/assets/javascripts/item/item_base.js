// Generated by CoffeeScript 1.8.0
var CanvasItemBase, CssItemBase, ItemBase,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ItemBase = (function(_super) {
  __extends(ItemBase, _super);

  ItemBase.IDENTITY = "";

  ItemBase.ITEMTYPE = "";

  ItemBase.getIdByElementId = function(elementId) {
    return elementId.replace(this.IDENTITY + '_', '');
  };

  function ItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
    ItemBase.__super__.constructor.call(this);
    this.id = generateId();
    this.drawingSurfaceImageData = null;
    if (cood !== null) {
      this.mousedownCood = {
        x: cood.x,
        y: cood.y
      };
    }
    this.itemSize = null;
    this.zindex = 0;
    this.ohiRegist = [];
    this.ohiRegistIndex = 0;
    this.jqueryElement = null;
  }

  ItemBase.prototype.getElementId = function() {
    return this.constructor.IDENTITY + '_' + this.id;
  };

  ItemBase.prototype.getJQueryElement = function() {
    return $('#' + this.getElementId());
  };

  ItemBase.prototype.pushOhi = function(obj) {
    this.ohiRegist[this.ohiRegistIndex] = obj;
    return this.ohiRegistIndex += 1;
  };

  ItemBase.prototype.incrementOhiRegistIndex = function() {
    return this.ohiRegistIndex += 1;
  };

  ItemBase.prototype.popOhi = function() {
    this.ohiRegistIndex -= 1;
    return this.ohiRegist[this.ohiRegistIndex];
  };

  ItemBase.prototype.lastestOhi = function() {
    return this.ohiRegist[this.ohiRegist.length - 1];
  };

  ItemBase.prototype.saveDrawingSurface = function() {
    return this.drawingSurfaceImageData = drawingContext.getImageData(0, 0, drawingCanvas.width, drawingCanvas.height);
  };

  ItemBase.prototype.restoreAllDrawingSurface = function() {
    return drawingContext.putImageData(this.drawingSurfaceImageData, 0, 0);
  };

  ItemBase.prototype.restoreDrawingSurface = function(size) {
    return drawingContext.putImageData(this.drawingSurfaceImageData, 0, 0, size.x, size.y, size.w, size.h);
  };

  ItemBase.prototype.startDraw = function() {};

  ItemBase.prototype.draw = function(cood) {};

  ItemBase.prototype.endDraw = function(zindex) {
    this.zindex = zindex;
    return true;
  };

  ItemBase.prototype.reDraw = function() {};

  ItemBase.prototype.saveObj = function(action) {
    var history;
    history = {
      obj: this,
      action: action,
      itemSize: this.itemSize
    };
    this.pushOhi(operationHistoryIndex - 1);
    pushOperationHistory(history);
    if (action === Constant.ItemActionType.MAKE) {
      itemObjectList.push(this);
    }
    return console.log('save obj:' + JSON.stringify(this.itemSize));
  };

  ItemBase.prototype.generateMinimumObject = function() {};

  ItemBase.prototype.loadByMinimumObject = function(obj) {};

  ItemBase.prototype.drawForLookaround = function(obj) {};

  ItemBase.prototype.clearAllEventStyle = function() {};

  return ItemBase;

})(Actor);

CssItemBase = (function(_super) {
  __extends(CssItemBase, _super);

  function CssItemBase() {
    return CssItemBase.__super__.constructor.apply(this, arguments);
  }

  CssItemBase.prototype.getCssRootElementId = function() {
    return "css-" + this.id;
  };

  CssItemBase.prototype.getCssAnimElementId = function() {
    return "css-anim-style";
  };

  CssItemBase.prototype.setupOptionMenu = function() {};

  return CssItemBase;

})(ItemBase);

CanvasItemBase = (function(_super) {
  __extends(CanvasItemBase, _super);

  function CanvasItemBase() {
    CanvasItemBase.__super__.constructor.call(this);
    this.newDrawingCanvas = null;
    this.newDrawingContext = null;
    this.newDrawingSurfaceImageData = null;
  }

  CanvasItemBase.prototype.canvasElementId = function() {
    return this.getElementId() + '_canvas';
  };

  CanvasItemBase.prototype.makeNewCanvas = function() {
    $(ElementCode.get().createItemElement(this)).appendTo('#main-wrapper');
    $('#' + this.canvasElementId()).attr('width', $('#' + this.getElementId()).width());
    $('#' + this.canvasElementId()).attr('height', $('#' + this.getElementId()).height());
    return (function(_this) {
      return function() {
        var drawingCanvas, drawingContext;
        drawingCanvas = document.getElementById(_this.canvasElementId());
        drawingContext = drawingCanvas.getContext('2d');
        return drawingContext.scale(_this.scale.w, _this.scale.h);
      };
    })(this)();
  };

  CanvasItemBase.prototype.saveNewDrawingSurface = function() {
    this.newDrawingCanvas = document.getElementById(this.canvasElementId());
    this.newDrawingContext = this.newDrawingCanvas.getContext('2d');
    return this.newDrawingSurfaceImageData = this.newDrawingContext.getImageData(0, 0, this.newDrawingCanvas.width, this.newDrawingCanvas.height);
  };

  CanvasItemBase.prototype.restoreAllNewDrawingSurface = function() {
    if (this.newDrawingSurfaceImageData != null) {
      return this.newDrawingContext.putImageData(this.newDrawingSurfaceImageData, 0, 0);
    }
  };

  CanvasItemBase.prototype.clearDraw = function() {
    var drawingCanvas, drawingContext;
    drawingCanvas = document.getElementById(this.canvasElementId());
    if (drawingCanvas != null) {
      drawingContext = this.newDrawingCanvas.getContext('2d');
      return drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height);
    }
  };

  return CanvasItemBase;

})(ItemBase);

//# sourceMappingURL=item_base.js.map
