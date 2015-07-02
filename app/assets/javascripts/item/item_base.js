// Generated by CoffeeScript 1.9.2
var CanvasItemBase, CssItemBase, ItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ItemBase = (function(superClass) {
  extend(ItemBase, superClass);

  ItemBase.include(EventListener);

  ItemBase.IDENTITY = "";

  ItemBase.ITEM_ID = "";

  function ItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
    ItemBase.__super__.constructor.call(this);
    this.id = generateId();
    this.name = null;
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

  ItemBase.prototype.getDesignConfigId = function() {
    return Constant.ElementAttribute.DESIGN_CONFIG_ROOT_ID.replace('@id', this.id);
  };

  ItemBase.prototype.getJQueryElement = function() {
    return $('#' + this.id);
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
    var padding;
    padding = 5;
    return drawingContext.putImageData(this.drawingSurfaceImageData, 0, 0, size.x - padding, size.y - padding, size.w + (padding * 2), size.h + (padding * 2));
  };

  ItemBase.prototype.startDraw = function() {};

  ItemBase.prototype.draw = function(cood) {};

  ItemBase.prototype.endDraw = function(zindex) {
    this.zindex = zindex;
    return true;
  };

  ItemBase.prototype.reDraw = function() {};

  ItemBase.prototype.saveObj = function(action) {
    var history, num, self;
    history = this.getHistoryObj(action);
    this.pushOhi(operationHistoryIndex - 1);
    pushOperationHistory(history);
    if (action === Constant.ItemActionType.MAKE) {
      num = 1;
      self = this;
      itemObjectList.forEach(function(obj) {
        if (self.constructor.IDENTITY === obj.constructor.IDENTITY) {
          return num += 1;
        }
      });
      this.name = this.constructor.IDENTITY + (" " + num);
      itemObjectList.push(this);
    }
    this.setAllItemPropToPageValue();
    return console.log('save obj:' + JSON.stringify(this.itemSize));
  };

  ItemBase.prototype.setAllItemPropToPageValue = function(isCache) {
    var obj, prefix_key;
    if (isCache == null) {
      isCache = false;
    }
    prefix_key = isCache ? Constant.PageValueKey.ITEM_VALUE_CACHE : Constant.PageValueKey.ITEM_VALUE;
    prefix_key = prefix_key.replace('@id', this.id);
    obj = this.getMinimumObject();
    return setPageValue(prefix_key, obj);
  };

  ItemBase.prototype.reDrawByObjPageValue = function(isCache) {
    var obj, prefix_key;
    if (isCache == null) {
      isCache = false;
    }
    prefix_key = isCache ? Constant.PageValueKey.ITEM_VALUE_CACHE : Constant.PageValueKey.ITEM_VALUE;
    prefix_key = prefix_key.replace('@id', this.id);
    obj = getPageValue(prefix_key);
    if (obj != null) {
      this.reDrawByMinimumObject(obj);
      return true;
    }
    return false;
  };

  ItemBase.prototype.getItemPropFromPageValue = function(prop, isCache) {
    var prefix_key;
    if (isCache == null) {
      isCache = false;
    }
    prefix_key = isCache ? Constant.PageValueKey.ITEM_VALUE_CACHE : Constant.PageValueKey.ITEM_VALUE;
    prefix_key = prefix_key.replace('@id', this.id);
    return getPageValue(prefix_key + (":" + prop));
  };

  ItemBase.prototype.setItemPropToPageValue = function(prop, value, isCache) {
    var prefix_key;
    if (isCache == null) {
      isCache = false;
    }
    prefix_key = isCache ? Constant.PageValueKey.ITEM_VALUE_CACHE : Constant.PageValueKey.ITEM_VALUE;
    prefix_key = prefix_key.replace('@id', this.id);
    return setPageValue(prefix_key + (":" + prop), value);
  };

  ItemBase.prototype.getHistoryObj = function(action) {
    return null;
  };

  ItemBase.prototype.setHistoryObj = function(historyObj) {};

  ItemBase.prototype.getMinimumObject = function() {};

  ItemBase.prototype.reDrawByMinimumObject = function(obj) {};

  ItemBase.prototype.drawForLookaround = function(obj) {};

  ItemBase.prototype.clearAllEventStyle = function() {};

  return ItemBase;

})(Extend);

CssItemBase = (function(superClass) {
  extend(CssItemBase, superClass);

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

  CssItemBase.prototype.endDraw = function(zindex, show) {
    if (show == null) {
      show = true;
    }
    if (!CssItemBase.__super__.endDraw.call(this, zindex)) {
      return false;
    }
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    return true;
  };

  return CssItemBase;

})(ItemBase);

CanvasItemBase = (function(superClass) {
  extend(CanvasItemBase, superClass);

  function CanvasItemBase() {
    CanvasItemBase.__super__.constructor.call(this);
    this.newDrawingCanvas = null;
    this.newDrawingContext = null;
    this.newDrawingSurfaceImageData = null;
  }

  CanvasItemBase.prototype.endDraw = function(zindex, show) {
    if (show == null) {
      show = true;
    }
    if (!CanvasItemBase.__super__.endDraw.call(this, zindex)) {
      return false;
    }
    (function(_this) {
      return (function() {
        _this.coodRegist.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        _this.coodLeftBodyPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        _this.coodRightBodyPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        return _this.coodHeadPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
      });
    })(this)();
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    return true;
  };

  CanvasItemBase.prototype.canvasElementId = function() {
    return this.id + '_canvas';
  };

  CanvasItemBase.prototype.setScale = function(drawingContext) {
    var canvas, element;
    element = $('#' + this.id);
    canvas = $('#' + this.canvasElementId());
    element.width(this.itemSize.w * this.scale.w);
    element.height(this.itemSize.h * this.scale.h);
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    drawingContext.scale(this.scale.w, this.scale.h);
    return console.log("setScale: itemSize: " + (JSON.stringify(this.itemSize)));
  };

  CanvasItemBase.prototype.initCanvas = function() {
    var drawingCanvas, drawingContext;
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    return this.setScale(drawingContext);
  };

  CanvasItemBase.prototype.makeNewCanvas = function() {
    $(ElementCode.get().createItemElement(this)).appendTo('#scroll_inside');
    return this.initCanvas();
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
      drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height);
      return this.initCanvas();
    }
  };

  return CanvasItemBase;

})(ItemBase);

//# sourceMappingURL=item_base.js.map
