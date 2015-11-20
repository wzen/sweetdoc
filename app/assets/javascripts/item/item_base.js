// Generated by CoffeeScript 1.9.2
var ItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ItemBase = (function(superClass) {
  var constant;

  extend(ItemBase, superClass);

  ItemBase.IDENTITY = "";

  ItemBase.ITEM_ID = "";

  ItemBase.DESIGN_CONFIG_ROOT_ID = 'design_config_@id';

  ItemBase.DESIGN_PAGEVALUE_ROOT = 'designs';

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    ItemBase.ActionPropertiesKey = (function() {
      function ActionPropertiesKey() {}

      ActionPropertiesKey.METHODS = constant.ItemActionPropertiesKey.METHODS;

      ActionPropertiesKey.DEFAULT_METHOD = constant.ItemActionPropertiesKey.DEFAULT_METHOD;

      ActionPropertiesKey.ACTION_TYPE = constant.ItemActionPropertiesKey.ACTION_TYPE;

      ActionPropertiesKey.SCROLL_ENABLED_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_ENABLED_DIRECTION;

      ActionPropertiesKey.SCROLL_FORWARD_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_FORWARD_DIRECTION;

      ActionPropertiesKey.OPTIONS = constant.ItemActionPropertiesKey.OPTIONS;

      return ActionPropertiesKey;

    })();
  }

  function ItemBase(cood) {
    var ref, value, varName;
    if (cood == null) {
      cood = null;
    }
    ItemBase.__super__.constructor.call(this);
    this.id = "i" + this.constructor.IDENTITY + Common.generateId();
    this.name = null;
    this.drawingSurfaceImageData = null;
    if (cood !== null) {
      this.mousedownCood = {
        x: cood.x,
        y: cood.y
      };
    }
    this.itemSize = null;
    this.zindex = Constant.Zindex.EVENTBOTTOM + 1;
    this.ohiRegist = [];
    this.ohiRegistIndex = 0;
    this.jqueryElement = null;
    this.coodRegist = [];
    if (this.constructor.actionProperties.modifiables != null) {
      ref = this.constructor.actionProperties.modifiables;
      for (varName in ref) {
        value = ref[varName];
        this[varName] = value["default"];
      }
    }
    if (window.isWorkTable) {
      this.constructor.include(WorkTableCommonInclude);
    }
  }

  ItemBase.prototype.getJQueryElement = function() {
    return $('#' + this.id);
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

  ItemBase.prototype.reDraw = function(show) {
    if (show == null) {
      show = true;
    }
  };

  ItemBase.prototype.reDrawWithEventBefore = function(show) {
    var obj;
    if (show == null) {
      show = true;
    }
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
    if (obj) {
      this.setMiniumObject(obj);
    }
    return this.reDraw(show);
  };

  ItemBase.prototype.saveObj = function(newCreated) {
    var k, num, ref, self, v;
    if (newCreated == null) {
      newCreated = false;
    }
    if (newCreated) {
      num = 0;
      self = this;
      ref = Common.getCreatedItemInstances();
      for (k in ref) {
        v = ref[k];
        if (self.constructor.IDENTITY === v.constructor.IDENTITY) {
          num += 1;
        }
      }
      this.name = this.constructor.IDENTITY + (" " + num);
    }
    this.setItemAllPropToPageValue();
    LocalStorage.saveAllPageValues();
    OperationHistory.add();
    if (window.debug) {
      console.log('save obj');
    }
    return Timeline.updateSelectItemMenu();
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

  ItemBase.prototype.getMinimumObject = function() {
    var mod, obj, ref, value, varName;
    obj = {
      id: Common.makeClone(this.id),
      itemId: Common.makeClone(this.constructor.ITEM_ID),
      name: Common.makeClone(this.name),
      itemSize: Common.makeClone(this.itemSize),
      zindex: Common.makeClone(this.zindex),
      coodRegist: JSON.stringify(Common.makeClone(this.coodRegist)),
      designs: Common.makeClone(this.designs)
    };
    mod = {};
    if (this.constructor.actionProperties.modifiables != null) {
      ref = this.constructor.actionProperties.modifiables;
      for (varName in ref) {
        value = ref[varName];
        mod[varName] = Common.makeClone(this[varName]);
      }
    }
    $.extend(obj, mod);
    return obj;
  };

  ItemBase.prototype.setMiniumObject = function(obj) {
    var ref, value, varName;
    delete window.instanceMap[this.id];
    this.id = Common.makeClone(obj.id);
    this.name = Common.makeClone(obj.name);
    this.itemSize = Common.makeClone(obj.itemSize);
    this.zindex = Common.makeClone(obj.zindex);
    this.coodRegist = Common.makeClone(JSON.parse(obj.coodRegist));
    this.designs = Common.makeClone(obj.designs);
    if (this.constructor.actionProperties.modifiables != null) {
      ref = this.constructor.actionProperties.modifiables;
      for (varName in ref) {
        value = ref[varName];
        this[varName] = Common.makeClone(obj[varName]);
      }
    }
    return window.instanceMap[this.id] = this;
  };

  ItemBase.prototype.clearAllEventStyle = function() {};

  ItemBase.defaultMethodName = function() {
    return this.actionProperties[this.ActionPropertiesKey.DEFAULT_METHOD];
  };

  ItemBase.defaultActionType = function() {
    return Common.getActionTypeByCodingActionType(this.actionProperties[this.ActionPropertiesKey.METHODS][this.defaultMethodName()][this.ActionPropertiesKey.ACTION_TYPE]);
  };

  ItemBase.defaultEventConfigValue = function() {
    return null;
  };

  ItemBase.defaultScrollEnabledDirection = function() {
    return this.actionProperties[this.ActionPropertiesKey.METHODS][this.defaultMethodName()][this.ActionPropertiesKey.SCROLL_ENABLED_DIRECTION];
  };

  ItemBase.defaultScrollForwardDirection = function() {
    return this.actionProperties[this.ActionPropertiesKey.METHODS][this.defaultMethodName()][this.ActionPropertiesKey.SCROLL_FORWARD_DIRECTION];
  };

  ItemBase.prototype.applyDefaultDesign = function() {
    if (this.constructor.actionProperties.designConfigDefaultValues != null) {
      PageValue.setInstancePageValue(PageValue.Key.instanceDesignRoot(this.id), this.constructor.actionProperties.designConfigDefaultValues);
    }
    return this.designs = PageValue.getInstancePageValue(PageValue.Key.instanceDesignRoot(this.id));
  };

  ItemBase.prototype.eventConfigValue = function() {
    return null;
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

  ItemBase.prototype.updateInstanceParamByScroll = function(scrollValue, immediate) {
    if (immediate == null) {
      immediate = false;
    }
    ItemBase.__super__.updateInstanceParamByScroll.call(this, scrollValue, immediate);
    return this.updateItemSizeByScroll(scrollValue, immediate);
  };

  ItemBase.prototype.updateInstanceParamByClick = function(immediate) {
    if (immediate == null) {
      immediate = false;
    }
    ItemBase.__super__.updateInstanceParamByClick.call(this, immediate);
    return this.updateItemSizeByClick();
  };

  ItemBase.prototype.updateItemSizeByScroll = function(scrollValue, immediate) {
    var itemDiff, itemSize, originalItemElementSize, progressPercentage, scrollEnd, scrollStart;
    if (immediate == null) {
      immediate = false;
    }
    itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
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
    scrollEnd = parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]);
    scrollStart = parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
    progressPercentage = scrollValue / (scrollEnd - scrollStart);
    itemSize = {
      x: originalItemElementSize.x + (itemDiff.x * progressPercentage),
      y: originalItemElementSize.y + (itemDiff.y * progressPercentage),
      w: originalItemElementSize.w + (itemDiff.w * progressPercentage),
      h: originalItemElementSize.h + (itemDiff.h * progressPercentage)
    };
    return this.updatePositionAndItemSize(itemSize, false);
  };

  ItemBase.prototype.updateItemSizeByClick = function(immediate) {
    var clickAnimationDuration, count, duration, itemDiff, itemSize, loopMax, originalItemElementSize, perH, perW, perX, perY, timer;
    if (immediate == null) {
      immediate = false;
    }
    itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
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
    clickAnimationDuration = this.constructor.actionProperties.methods[this.getEventMethodName()].clickAnimationDuration;
    duration = 0.01;
    perX = itemDiff.x * (duration / clickAnimationDuration);
    perY = itemDiff.y * (duration / clickAnimationDuration);
    perW = itemDiff.w * (duration / clickAnimationDuration);
    perH = itemDiff.h * (duration / clickAnimationDuration);
    loopMax = Math.ceil(clickAnimationDuration / duration);
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

  return ItemBase;

})(ItemEventBase);

//# sourceMappingURL=item_base.js.map
