// Generated by CoffeeScript 1.9.2
var ItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ItemBase = (function(superClass) {
  var constant;

  extend(ItemBase, superClass);

  ItemBase.NAME_PREFIX = "";

  ItemBase.DESIGN_CONFIG_ROOT_ID = 'design_config_@id';

  ItemBase.DESIGN_PAGEVALUE_ROOT = 'designs';

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    ItemBase.ActionPropertiesKey = (function() {
      function ActionPropertiesKey() {}

      ActionPropertiesKey.METHODS = constant.ItemActionPropertiesKey.METHODS;

      ActionPropertiesKey.DEFAULT_EVENT = constant.ItemActionPropertiesKey.DEFAULT_EVENT;

      ActionPropertiesKey.METHOD = constant.ItemActionPropertiesKey.METHOD;

      ActionPropertiesKey.DEFAULT_METHOD = constant.ItemActionPropertiesKey.DEFAULT_METHOD;

      ActionPropertiesKey.ACTION_TYPE = constant.ItemActionPropertiesKey.ACTION_TYPE;

      ActionPropertiesKey.SPECIFIC_METHOD_VALUES = constant.ItemActionPropertiesKey.SPECIFIC_METHOD_VALUES;

      ActionPropertiesKey.SCROLL_ENABLED_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_ENABLED_DIRECTION;

      ActionPropertiesKey.SCROLL_FORWARD_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_FORWARD_DIRECTION;

      ActionPropertiesKey.OPTIONS = constant.ItemActionPropertiesKey.OPTIONS;

      ActionPropertiesKey.EVENT_DURATION = constant.ItemActionPropertiesKey.EVENT_DURATION;

      return ActionPropertiesKey;

    })();
    ItemBase.ImageKey = (function() {
      function ImageKey() {}

      ImageKey.PROJECT_ID = constant.PreloadItemImage.Key.PROJECT_ID;

      ImageKey.ITEM_OBJ_ID = constant.PreloadItemImage.Key.ITEM_OBJ_ID;

      ImageKey.EVENT_DIST_ID = constant.PreloadItemImage.Key.EVENT_DIST_ID;

      ImageKey.SELECT_FILE = constant.PreloadItemImage.Key.SELECT_FILE;

      ImageKey.URL = constant.PreloadItemImage.Key.URL;

      ImageKey.SELECT_FILE_DELETE = constant.PreloadItemImage.Key.SELECT_FILE_DELETE;

      return ImageKey;

    })();
  }

  function ItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
    ItemBase.__super__.constructor.call(this);
    this.id = "i" + this.constructor.NAME_PREFIX + Common.generateId();
    this.itemToken = this.constructor.CLASS_DIST_TOKEN;
    this.name = null;
    this.visible = false;
    this.firstFocus = false;
    this._drawingSurfaceImageData = null;
    if (cood !== null) {
      this._mousedownCood = {
        x: cood.x,
        y: cood.y
      };
    }
    this.itemSize = null;
    this.zindex = Constant.Zindex.EVENTBOTTOM + 1;
    this._ohiRegist = [];
    this._ohiRegistIndex = 0;
    this.registCoord = [];
  }

  ItemBase.prototype.getJQueryElement = function() {
    return $('#' + this.id);
  };

  ItemBase.prototype.createItemElement = function(callback) {
    return callback();
  };

  ItemBase.prototype.removeItemElement = function() {
    return this.getJQueryElement().remove();
  };

  ItemBase.prototype.addContentsToScrollInside = function(contents, callback) {
    var createdElement;
    if (callback == null) {
      callback = null;
    }
    createdElement = Common.wrapCreateItemElement(this, $(contents));
    $(createdElement).appendTo(window.scrollInside);
    if (callback != null) {
      return callback();
    }
  };

  ItemBase.prototype.saveDrawingSurface = function() {
    return this._drawingSurfaceImageData = drawingContext.getImageData(0, 0, drawingCanvas.width, drawingCanvas.height);
  };

  ItemBase.prototype.restoreAllDrawingSurface = function() {
    return window.drawingContext.putImageData(this._drawingSurfaceImageData, 0, 0);
  };

  ItemBase.prototype.restoreDrawingSurface = function(size) {
    var padding;
    padding = 5;
    return window.drawingContext.putImageData(this._drawingSurfaceImageData, 0, 0, size.x - padding, size.y - padding, size.w + (padding * 2), size.h + (padding * 2));
  };

  ItemBase.prototype.itemDraw = function(show) {
    if (show == null) {
      show = true;
    }
  };

  ItemBase.prototype.reDraw = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('ItemBase reDraw id:' + this.id);
    }
    if ((this.reDrawing != null) && this.reDrawing) {
      this.reDrawStack = true;
      if (window.debug) {
        console.log('add stack');
      }
      return;
    }
    this.reDrawing = true;
    this.removeItemElement();
    return this.createItemElement((function(_this) {
      return function() {
        _this.itemDraw(show);
        if (_this.setupDragAndResizeEvents != null) {
          _this.setupDragAndResizeEvents();
        }
        _this.reDrawing = false;
        if ((_this.reDrawStack != null) && _this.reDrawStack) {
          _this.reDrawStack = false;
          if (window.debug) {
            console.log('stack redraw');
          }
          return _this.reDraw(show, callback);
        } else {
          if (callback != null) {
            return callback();
          }
        }
      };
    })(this));
  };

  ItemBase.prototype.reDrawIfItemNotExist = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('ItemBase reDrawIfItemNotExist id:' + this.id);
    }
    if (this.getJQueryElement().length === 0) {
      return this.reDraw(show, callback);
    } else {
      if (callback != null) {
        return callback();
      }
    }
  };

  ItemBase.prototype.applyDesignChange = function(doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    this.reDraw();
    if (doStyleSave) {
      return this.saveDesign();
    }
  };

  ItemBase.prototype.reDrawFromInstancePageValue = function(show, callback) {
    var obj;
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('ItemBase reDrawWithEventBefore id:' + this.id);
    }
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
    if (obj) {
      this.setMiniumObject(obj);
    }
    return this.reDraw(show, callback);
  };

  ItemBase.prototype.saveObj = function(newCreated) {
    var k, num, ref, self, v;
    if (newCreated == null) {
      newCreated = false;
    }
    if (newCreated) {
      num = 0;
      self = this;
      ref = Common.allItemInstances();
      for (k in ref) {
        v = ref[k];
        if (self.constructor.NAME_PREFIX === v.constructor.NAME_PREFIX) {
          num += 1;
        }
      }
      this.name = this.constructor.NAME_PREFIX + (" " + num);
    }
    this.setItemAllPropToPageValue();
    LocalStorage.saveAllPageValues();
    OperationHistory.add();
    if (window.debug) {
      console.log('save obj');
    }
    return EventConfig.updateSelectItemMenu();
  };

  ItemBase.prototype.getItemPropFromPageValue = function(prop, isCache) {
    var prefix_key;
    if (isCache == null) {
      isCache = false;
    }
    prefix_key = isCache ? PageValue.Key.instanceValueCache(this.id) : PageValue.Key.instanceValue(this.id);
    return PageValue.getInstancePageValue(prefix_key + (":" + prop));
  };

  ItemBase.prototype.setItemPropToPageValue = function(prop, value, isCache) {
    var prefix_key;
    if (isCache == null) {
      isCache = false;
    }
    prefix_key = isCache ? PageValue.Key.instanceValueCache(this.id) : PageValue.Key.instanceValue(this.id);
    PageValue.setInstancePageValue(prefix_key + (":" + prop), value);
    return LocalStorage.saveInstancePageValue();
  };

  ItemBase.prototype.originalItemElementSize = function() {
    var diff, obj;
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(this._event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
    $.extend(true, obj, diff);
    return obj.itemSize;
  };

  ItemBase.prototype.updateItemSize = function(w, h) {
    this.getJQueryElement().css({
      width: w,
      height: h
    });
    this.itemSize.w = parseInt(w);
    return this.itemSize.h = parseInt(h);
  };

  ItemBase.prototype.clearAllEventStyle = function() {};

  ItemBase.defaultMethodName = function() {
    if ((this.actionProperties != null) && (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
      return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.METHOD];
    } else {
      return null;
    }
  };

  ItemBase.defaultActionType = function() {
    return Common.getActionTypeByCodingActionType(this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.ACTION_TYPE]);
  };

  ItemBase.defaultSpecificMethodValue = function() {
    if ((this.actionProperties != null) && (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
      return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.SPECIFIC_METHOD_VALUES];
    } else {
      return null;
    }
  };

  ItemBase.defaultScrollEnabledDirection = function() {
    if ((this.actionProperties != null) && (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
      return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.SCROLL_ENABLED_DIRECTION];
    } else {
      return null;
    }
  };

  ItemBase.defaultScrollForwardDirection = function() {
    if ((this.actionProperties != null) && (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
      return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.SCROLL_FORWARD_DIRECTION];
    } else {
      return null;
    }
  };

  ItemBase.defaultClickDuration = function() {
    if ((this.actionProperties != null) && (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
      return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.EVENT_DURATION];
    } else {
      return null;
    }
  };

  ItemBase.prototype.applyDefaultDesign = function() {
    if (this.constructor.actionProperties.designConfigDefaultValues != null) {
      PageValue.setInstancePageValue(PageValue.Key.instanceDesignRoot(this.id), this.constructor.actionProperties.designConfigDefaultValues);
    }
    return this.designs = PageValue.getInstancePageValue(PageValue.Key.instanceDesignRoot(this.id));
  };

  ItemBase.prototype.updatePositionAndItemSize = function(itemSize, withSaveObj) {
    if (withSaveObj == null) {
      withSaveObj = true;
    }
    this.updateItemPosition(itemSize.x, itemSize.y);
    this.updateItemSize(itemSize.w, itemSize.h);
    if (withSaveObj) {
      return this.saveObj();
    }
  };

  ItemBase.prototype.updateItemPosition = function(x, y) {
    this.getJQueryElement().css({
      top: y,
      left: x
    });
    this.itemSize.x = parseInt(x);
    return this.itemSize.y = parseInt(y);
  };

  ItemBase.prototype.updateInstanceParamByStep = function(stepValue, immediate) {
    if (immediate == null) {
      immediate = false;
    }
    ItemBase.__super__.updateInstanceParamByStep.call(this, stepValue, immediate);
    return this.updateItemSizeByStep(stepValue, immediate);
  };

  ItemBase.prototype.updateInstanceParamByAnimation = function(immediate) {
    if (immediate == null) {
      immediate = false;
    }
    ItemBase.__super__.updateInstanceParamByAnimation.call(this, immediate);
    return this.updateItemSizeByAnimation();
  };

  ItemBase.prototype.updateItemSizeByStep = function(scrollValue, immediate) {
    var itemDiff, itemSize, originalItemElementSize, progressPercentage, scrollEnd, scrollStart;
    if (immediate == null) {
      immediate = false;
    }
    itemDiff = this._event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
    if ((itemDiff == null) || itemDiff === 'undefined') {
      return;
    }
    if (itemDiff.x === 0 && itemDiff.y === 0 && itemDiff.w === 0 && itemDiff.h === 0) {
      return;
    }
    originalItemElementSize = this.originalItemElementSize();
    if (immediate) {
      itemSize = {
        x: originalItemElementSize.x + itemDiff.x,
        y: originalItemElementSize.y + itemDiff.y,
        w: originalItemElementSize.w + itemDiff.w,
        h: originalItemElementSize.h + itemDiff.h
      };
      this.updatePositionAndItemSize(itemSize, false);
      return;
    }
    scrollEnd = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]);
    scrollStart = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
    progressPercentage = scrollValue / (scrollEnd - scrollStart);
    itemSize = {
      x: originalItemElementSize.x + (itemDiff.x * progressPercentage),
      y: originalItemElementSize.y + (itemDiff.y * progressPercentage),
      w: originalItemElementSize.w + (itemDiff.w * progressPercentage),
      h: originalItemElementSize.h + (itemDiff.h * progressPercentage)
    };
    return this.updatePositionAndItemSize(itemSize, false);
  };

  ItemBase.prototype.updateItemSizeByAnimation = function(immediate) {
    var count, duration, eventDuration, itemDiff, itemSize, loopMax, originalItemElementSize, perH, perW, perX, perY, timer;
    if (immediate == null) {
      immediate = false;
    }
    itemDiff = this._event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
    if ((itemDiff == null) || itemDiff === 'undefined') {
      return;
    }
    if (itemDiff.x === 0 && itemDiff.y === 0 && itemDiff.w === 0 && itemDiff.h === 0) {
      return;
    }
    originalItemElementSize = this.originalItemElementSize();
    if (immediate) {
      itemSize = {
        x: originalItemElementSize.x + itemDiff.x,
        y: originalItemElementSize.y + itemDiff.y,
        w: originalItemElementSize.w + itemDiff.w,
        h: originalItemElementSize.h + itemDiff.h
      };
      this.updatePositionAndItemSize(itemSize, false);
      return;
    }
    eventDuration = this._event[EventPageValueBase.PageValueKey.EVENT_DURATION];
    duration = 0.01;
    perX = itemDiff.x * (duration / eventDuration);
    perY = itemDiff.y * (duration / eventDuration);
    perW = itemDiff.w * (duration / eventDuration);
    perH = itemDiff.h * (duration / eventDuration);
    loopMax = Math.ceil(eventDuration / duration);
    count = 1;
    return timer = setInterval((function(_this) {
      return function() {
        itemSize = {
          x: originalItemElementSize.x + (perX * count),
          y: originalItemElementSize.y + (perY * count),
          w: originalItemElementSize.w + (perW * count),
          h: originalItemElementSize.h + (perH * count)
        };
        _this.updatePositionAndItemSize(itemSize, false);
        if (count >= loopMax) {
          clearInterval(timer);
          itemSize = {
            x: originalItemElementSize.x + itemDiff.x,
            y: originalItemElementSize.y + itemDiff.y,
            w: originalItemElementSize.w + itemDiff.w,
            h: originalItemElementSize.h + itemDiff.h
          };
          _this.updatePositionAndItemSize(itemSize, false);
        }
        return count += 1;
      };
    })(this), duration * 1000);
  };

  if (window.isWorkTable) {
    ItemBase.include(itemBaseWorktableExtend);
  }

  return ItemBase;

})(ItemEventBase);

//# sourceMappingURL=item_base.js.map
