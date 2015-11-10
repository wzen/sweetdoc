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
    if (window.isWorkTable) {
      this.constructor.include(WorkTableCommonExtend);
    }
  }

  ItemBase.prototype.getDesignConfigId = function() {
    return this.constructor.DESIGN_CONFIG_ROOT_ID.replace('@id', this.id);
  };

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
    var obj;
    obj = {
      id: Common.makeClone(this.id),
      itemId: Common.makeClone(this.constructor.ITEM_ID),
      name: Common.makeClone(this.name),
      itemSize: Common.makeClone(this.itemSize),
      zindex: Common.makeClone(this.zindex),
      coodRegist: JSON.stringify(Common.makeClone(this.coodRegist))
    };
    return obj;
  };

  ItemBase.prototype.setMiniumObject = function(obj) {
    delete window.instanceMap[this.id];
    this.id = Common.makeClone(obj.id);
    this.name = Common.makeClone(obj.name);
    this.itemSize = Common.makeClone(obj.itemSize);
    this.zindex = Common.makeClone(obj.zindex);
    this.coodRegist = Common.makeClone(JSON.parse(obj.coodRegist));
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

  ItemBase.prototype.eventConfigValue = function() {
    return null;
  };

  ItemBase.prototype.updateEventAfter = function() {
    var itemDiff;
    itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
    return this.updatePositionAndItemSize(this.itemSize.x + itemDiff.x, this.itemSize.y + itemDiff.y, this.itemSize.w + itemDiff.w, this.itemSize.h + itemDiff.h, false, false);
  };

  ItemBase.prototype.updateEventBefore = function() {
    return this.updatePositionAndItemSize(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h, false, false);
  };

  ItemBase.prototype.updatePositionAndItemSize = function(x, y, w, h, withSaveObj, updateInstanceInfo) {
    if (withSaveObj == null) {
      withSaveObj = true;
    }
    if (updateInstanceInfo == null) {
      updateInstanceInfo = true;
    }
    this.updateItemPosition(x, y, updateInstanceInfo);
    this.updateItemSize(w, h, updateInstanceInfo);
    if (withSaveObj) {
      return this.saveObj();
    }
  };

  ItemBase.prototype.updateItemPosition = function(x, y, updateInstanceInfo) {
    if (updateInstanceInfo == null) {
      updateInstanceInfo = true;
    }
    this.getJQueryElement().css({
      top: y,
      left: x
    });
    if (updateInstanceInfo) {
      this.itemSize.x = parseInt(x);
      return this.itemSize.y = parseInt(y);
    }
  };

  ItemBase.prototype.updateItemCommonByScroll = function(scrollValue) {
    return this.updateItemSizeByScroll(scrollValue);
  };

  ItemBase.prototype.updateItemCommonByClick = function() {
    var clickAnimationDuration;
    clickAnimationDuration = this.constructor.actionProperties.methods[this.getEventMethodName()].clickAnimationDuration;
    return this.updateItemSizeByClick(clickAnimationDuration);
  };

  ItemBase.prototype.updateItemSizeByScroll = function(scrollValue) {
    var beforeItemSize, h, itemDiff, progressPercentage, scrollEnd, scrollStart, w, x, y;
    scrollEnd = parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]);
    scrollStart = parseInt(this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
    progressPercentage = scrollValue / (scrollEnd - scrollStart);
    itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
    beforeItemSize = this.originalItemElementSize();
    x = beforeItemSize.x + (itemDiff.x * progressPercentage);
    y = beforeItemSize.y + (itemDiff.y * progressPercentage);
    w = beforeItemSize.w + (itemDiff.w * progressPercentage);
    h = beforeItemSize.h + (itemDiff.h * progressPercentage);
    return this.updatePositionAndItemSize(x, y, w, h, false, false);
  };

  ItemBase.prototype.updateItemSizeByClick = function(clickAnimationDuration) {
    var beforeItemSize, count, duration, itemDiff, loopMax, perH, perW, perX, perY, timer;
    this.updatePositionAndItemSize(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h, false, false);
    duration = 0.01;
    beforeItemSize = this.originalItemElementSize();
    itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
    if ((itemDiff == null) || (itemDiff.x === 0 && itemDiff.y === 0 && itemDiff.w === 0 && itemDiff.h === 0)) {
      return;
    }
    perX = itemDiff.x * (duration / clickAnimationDuration);
    perY = itemDiff.y * (duration / clickAnimationDuration);
    perW = itemDiff.w * (duration / clickAnimationDuration);
    perH = itemDiff.h * (duration / clickAnimationDuration);
    loopMax = Math.ceil(clickAnimationDuration / duration);
    count = 1;
    timer = setInterval((function(_this) {
      return function() {
        var h, w, x, y;
        x = beforeItemSize.x + (perX * count);
        y = beforeItemSize.y + (perY * count);
        w = beforeItemSize.w + (perW * count);
        h = beforeItemSize.h + (perH * count);
        _this.updatePositionAndItemSize(x, y, w, h, false, false);
        if (count >= loopMax) {
          clearInterval(timer);
        }
        return count += 1;
      };
    })(this), duration * 1000);
    return this.updatePositionAndItemSize(this.itemSize.x + itemDiff.x, this.itemSize.y + itemDiff.y, this.itemSize.w + itemDiff.w, this.itemSize.h + itemDiff.h, false, false);
  };

  ItemBase.prototype.setupOptionMenu = function() {
    var h, name, w, x, y;
    this.designConfigRoot = $('#' + this.getDesignConfigId());
    if ((this.designConfigRoot == null) || this.designConfigRoot.length === 0) {
      this.makeDesignConfig();
      this.designConfigRoot = $('#' + this.getDesignConfigId());
    }
    name = $('.item-name', this.designConfigRoot);
    name.val(this.name);
    name.off('change').on('change', (function(_this) {
      return function() {
        _this.name = name.val();
        return _this.setItemPropToPageValue('name', _this.name);
      };
    })(this));
    x = this.getJQueryElement().position().left;
    y = this.getJQueryElement().position().top;
    w = this.getJQueryElement().width();
    h = this.getJQueryElement().height();
    $('.item_position_x:first', this.designConfigRoot).val(x);
    $('.item_position_y:first', this.designConfigRoot).val(y);
    $('.item_width:first', this.designConfigRoot).val(w);
    $('.item_height:first', this.designConfigRoot).val(h);
    return $('.item_position_x:first, .item_position_y:first, .item_width:first, .item_height:first', this.designConfigRoot).off('change').on('change', (function(_this) {
      return function() {
        x = parseInt($('.item_position_x:first', _this.designConfigRoot).val());
        y = parseInt($('.item_position_y:first', _this.designConfigRoot).val());
        w = parseInt($('.item_width:first', _this.designConfigRoot).val());
        h = parseInt($('.item_height:first', _this.designConfigRoot).val());
        return _this.updatePositionAndItemSize(x, y, w, h);
      };
    })(this));
  };

  return ItemBase;

})(ItemEventBase);

//# sourceMappingURL=item_base.js.map
