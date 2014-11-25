// Generated by CoffeeScript 1.8.0
var ItemBase;

ItemBase = (function() {
  ItemBase.IDENTITY = "";

  ItemBase.ITEMTYPE = "";

  function ItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
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

  ItemBase.prototype.getId = function() {
    return this.id;
  };

  ItemBase.prototype.getElementId = function() {
    return this.constructor.IDENTITY + '_' + this.id;
  };

  ItemBase.prototype.getJQueryElement = function() {
    return $('#' + this.getElementId());
  };

  ItemBase.prototype.getSize = function() {
    return this.itemSize;
  };

  ItemBase.prototype.setSize = function(size) {
    return this.itemSize = size;
  };

  ItemBase.prototype.getZIndex = function() {
    return this.zindex;
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
    return drawingContext.putImageData(this.drawingSurfaceImageData, 0, 0, size.x - Constant.SURFACE_IMAGE_MARGIN, size.y - Constant.SURFACE_IMAGE_MARGIN, size.w + Constant.SURFACE_IMAGE_MARGIN * 2, size.h + Constant.SURFACE_IMAGE_MARGIN * 2);
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

  ItemBase.prototype.setupEvents = function() {
    (function(_this) {
      return (function() {
        return _this.getJQueryElement().mousedown(function(e) {
          if (e.which === 1) {
            e.stopPropagation();
            $(this).find('.editSelected').remove();
            return $(this).append('<div class="editSelected" />');
          }
        });
      });
    })(this)();
    return (function(_this) {
      return function() {
        _this.getJQueryElement().draggable({
          containment: mainWrapper,
          stop: function(event, ui) {
            var rect;
            rect = {
              x: ui.position.left,
              y: ui.position.top,
              w: _this.getSize().w,
              h: _this.getSize().h
            };
            _this.setSize(rect);
            return _this.saveObj(Constant.ItemActionType.MOVE);
          }
        });
        return _this.getJQueryElement().resizable({
          containment: mainWrapper,
          stop: function(event, ui) {
            var rect;
            rect = {
              x: _this.getSize().x,
              y: _this.getSize().y,
              w: ui.size.width,
              h: ui.size.height
            };
            _this.setSize(rect);
            return _this.saveObj(Constant.ItemActionType.MOVE);
          }
        });
      };
    })(this)();
  };

  ItemBase.prototype.clearAllEventStyle = function() {};

  return ItemBase;

})();

//# sourceMappingURL=item_base.js.map
