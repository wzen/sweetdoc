// Generated by CoffeeScript 1.9.2
var CanvasItemBase, CssItemBase, ItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ItemBase = (function(superClass) {
  extend(ItemBase, superClass);

  ItemBase.IDENTITY = "";

  ItemBase.ITEM_ID = "";

  function ItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
    ItemBase.__super__.constructor.call(this);
    this.id = "i" + this.constructor.IDENTITY + generateId();
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
    this.coodRegist = [];
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
    var history, k, num, self, v;
    history = this.getHistoryObj(action);
    this.pushOhi(operationHistoryIndex - 1);
    pushOperationHistory(history);
    if (action === Constant.ItemActionType.MAKE) {
      num = 1;
      self = this;
      for (k in createdObject) {
        v = createdObject[k];
        if (self.constructor.IDENTITY === v.constructor.IDENTITY) {
          num += 1;
        }
      }
      this.name = this.constructor.IDENTITY + (" " + num);
      createdObject[this.id] = this;
    }
    this.setAllItemPropToPageValue();
    console.log('save obj:' + JSON.stringify(this.itemSize));
    return updateSelectItemMenu();
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

  ItemBase.prototype.getMinimumObject = function() {
    var obj;
    obj = {
      id: makeClone(this.id),
      name: makeClone(this.name),
      itemSize: makeClone(this.itemSize),
      zindex: makeClone(this.zindex),
      coodRegist: JSON.stringify(makeClone(this.coodRegist))
    };
    return obj;
  };

  ItemBase.prototype.setMiniumObject = function(obj) {
    this.id = makeClone(obj.id);
    this.name = makeClone(obj.name);
    this.itemSize = makeClone(obj.itemSize);
    this.zindex = makeClone(obj.zindex);
    return this.coodRegist = makeClone(JSON.parse(obj.coodRegist));
  };

  ItemBase.prototype.reDrawByMinimumObject = function(obj) {};

  ItemBase.prototype.drawForLookaround = function(obj) {};

  ItemBase.prototype.clearAllEventStyle = function() {};

  ItemBase.defaultMethodName = function() {
    return getPageValue(Constant.PageValueKey.ITEM_DEFAULT_METHODNAME.replace('@item_id', this.ITEM_ID));
  };

  ItemBase.defaultActionType = function() {
    return getPageValue(Constant.PageValueKey.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', this.ITEM_ID));
  };

  ItemBase.timelineDefaultConfigValue = function() {
    return null;
  };

  ItemBase.prototype.timelineConfigValue = function() {
    return null;
  };

  ItemBase.prototype.objWriteTimeline = function() {
    var obj;
    obj = {};
    obj[TLEItemChange.minObj] = this.getMinimumObject();
    return obj;
  };

  return ItemBase;

})(ItemEventBase);

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
    this.newDrawingSurfaceImageData = null;
    this.newDrawedSurfaceImageData = null;
    this.scale = {
      w: 1.0,
      h: 1.0
    };
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
    element = $("#" + this.id);
    canvas = $("#" + (this.canvasElementId()));
    element.width(this.itemSize.w * this.scale.w);
    element.height(this.itemSize.h * this.scale.h);
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    drawingContext.scale(this.scale.w, this.scale.h);
    return console.log("setScale: itemSize: " + (JSON.stringify(this.itemSize)));
  };

  CanvasItemBase.prototype.initCanvas = function() {
    var canvas, context;
    canvas = document.getElementById(this.canvasElementId());
    context = canvas.getContext('2d');
    return this.setScale(context);
  };

  CanvasItemBase.prototype.makeNewCanvas = function() {
    $(ElementCode.get().createItemElement(this)).appendTo('#scroll_inside');
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

  return CanvasItemBase;

})(ItemBase);

//# sourceMappingURL=item_base.js.map
