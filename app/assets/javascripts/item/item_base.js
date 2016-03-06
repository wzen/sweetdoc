// Generated by CoffeeScript 1.9.2
var ItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ItemBase = (function(superClass) {
  var constant;

  extend(ItemBase, superClass);

  ItemBase.ID_PREFIX = "i";

  ItemBase.NAME_PREFIX = "";

  ItemBase.DESIGN_CONFIG_ROOT_ID = 'design_config_@id';

  ItemBase.DESIGN_PAGEVALUE_ROOT = 'designs';

  constant = gon["const"];

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

  function ItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
    ItemBase.__super__.constructor.call(this);
    this.id = this.constructor.ID_PREFIX + '_' + this.constructor.NAME_PREFIX + '_' + Common.generateId();
    this.classDistToken = this.constructor.CLASS_DIST_TOKEN;
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
    this.zindex = constant.Zindex.EVENTBOTTOM + 1;
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
    if ((this.getJQueryElement() != null) && this.getJQueryElement().length > 0) {
      if (callback != null) {
        callback();
      }
      return;
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

  ItemBase.prototype.restoreRefreshingSurface = function(size) {
    var padding;
    padding = 5;
    return window.drawingContext.putImageData(this._drawingSurfaceImageData, 0, 0, size.x - padding, size.y - padding, size.w + (padding * 2), size.h + (padding * 2));
  };

  ItemBase.prototype.showItem = function(callback, immediate, duration) {
    if (callback == null) {
      callback = null;
    }
    if (immediate == null) {
      immediate = true;
    }
    if (duration == null) {
      duration = 0;
    }
    if (immediate || (window.isWorkTable && window.previewRunning)) {
      this.getJQueryElement().css({
        'opacity': 1,
        'z-index': Common.plusPagingZindex(this.zindex)
      });
      if (callback != null) {
        return callback();
      }
    } else {
      this._skipEvent = true;
      return this.getJQueryElement().css('z-index', Common.plusPagingZindex(this.zindex)).animate({
        'opacity': 1
      }, duration, function() {
        this._skipEvent = false;
        if (callback != null) {
          return callback();
        }
      });
    }
  };

  ItemBase.prototype.hideItem = function(callback, immediate, duration) {
    if (callback == null) {
      callback = null;
    }
    if (immediate == null) {
      immediate = true;
    }
    if (duration == null) {
      duration = 0;
    }
    if (immediate || (window.isWorkTable && window.previewRunning)) {
      this.getJQueryElement().css({
        'opacity': 0,
        'z-index': Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM)
      });
      if (callback != null) {
        return callback();
      }
    } else {
      this._skipEvent = true;
      return this.getJQueryElement().css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM)).animate({
        'opacity': 0
      }, duration, function() {
        this._skipEvent = false;
        if (callback != null) {
          return callback();
        }
      });
    }
  };

  ItemBase.prototype.itemDraw = function(show) {
    if (show == null) {
      show = true;
    }
    if (show) {
      return this.showItem();
    } else {
      return this.hideItem();
    }
  };

  ItemBase.prototype.willChapter = function(callback) {
    var d;
    if (callback == null) {
      callback = null;
    }
    if ((this._event[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER] == null) || this._event[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER]) {
      d = this._event[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER_DURATION];
      if (d == null) {
        d = 0;
      }
      return this.showItem((function(_this) {
        return function() {
          return ItemBase.__super__.willChapter.call(_this, callback);
        };
      })(this), d <= 0, d * 1000);
    } else {
      return ItemBase.__super__.willChapter.call(this, callback);
    }
  };

  ItemBase.prototype.didChapter = function(callback) {
    if (callback == null) {
      callback = null;
    }
    return ItemBase.__super__.didChapter.call(this, (function(_this) {
      return function() {
        var d;
        if ((_this._event[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER] != null) && _this._event[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER]) {
          d = _this._event[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER_DURATION];
          return _this.hideItem(function() {
            return ItemBase.__super__.didChapter.call(_this, callback);
          }, d <= 0, d * 1000);
        } else {
          if (callback != null) {
            return callback();
          }
        }
      };
    })(this));
  };

  ItemBase.prototype.refresh = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    return requestAnimationFrame((function(_this) {
      return function() {
        if (window.runDebug) {
          console.log('ItemBase refresh id:' + _this.id);
        }
        _this.removeItemElement();
        return _this.createItemElement(function() {
          _this.itemDraw(show);
          if (_this.setupItemEvents != null) {
            _this.setupItemEvents();
          }
          if (callback != null) {
            return callback(_this);
          }
        });
      };
    })(this));
  };

  ItemBase.prototype.refreshIfItemNotExist = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('ItemBase refreshIfItemNotExist id:' + this.id);
    }
    if (this.getJQueryElement().length === 0) {
      return this.refresh(show, callback);
    } else {
      if (callback != null) {
        return callback(this);
      }
    }
  };

  ItemBase.prototype.applyDesignChange = function(doStyleSave) {
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    this.refresh();
    if (doStyleSave) {
      return this.saveDesign();
    }
  };

  ItemBase.prototype.saveObj = function(newCreated) {
    var k, num, ref, v;
    if (newCreated == null) {
      newCreated = false;
    }
    if (newCreated) {
      num = 0;
      ref = Common.allItemInstances();
      for (k in ref) {
        v = ref[k];
        if (this.constructor.NAME_PREFIX === v.constructor.NAME_PREFIX) {
          num += 1;
        }
      }
      this.name = this.constructor.NAME_PREFIX + (" " + num);
    }
    this.setItemAllPropToPageValue();
    window.lStorage.saveAllPageValues();
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
    return window.lStorage.saveInstancePageValue();
  };

  ItemBase.prototype.originalItemElementSize = function() {
    var obj;
    obj = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceBefore(this._event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
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
    var ret;
    if ((this.actionProperties != null) && (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
      ret = this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.SPECIFIC_METHOD_VALUES];
      if (ret != null) {
        return ret;
      } else {
        return {};
      }
    } else {
      return {};
    }
  };

  ItemBase.defaultModifiableVars = function() {
    var mod;
    if ((this.actionProperties != null) && (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
      mod = this.actionPropertiesModifiableVars(this.ActionPropertiesKey.DEFAULT_EVENT, true);
      if (mod != null) {
        return mod;
      } else {
        return {};
      }
    } else {
      return {};
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

  ItemBase.prototype.updatePositionAndItemSize = function(itemSize, withSaveObj, withRefresh) {
    if (withSaveObj == null) {
      withSaveObj = true;
    }
    if (withRefresh == null) {
      withRefresh = false;
    }
    this.updateItemPosition(itemSize.x, itemSize.y);
    this.updateItemSize(itemSize.w, itemSize.h);
    if (withSaveObj) {
      this.saveObj();
    }
    if (withRefresh) {
      return refresh(this.isItemVisible());
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
      this.updatePositionAndItemSize(itemSize, false, true);
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
    return this.updatePositionAndItemSize(itemSize, false, true);
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
      this.updatePositionAndItemSize(itemSize, false, true);
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
        _this.updatePositionAndItemSize(itemSize, false, true);
        if (count >= loopMax) {
          clearInterval(timer);
          itemSize = {
            x: originalItemElementSize.x + itemDiff.x,
            y: originalItemElementSize.y + itemDiff.y,
            w: originalItemElementSize.w + itemDiff.w,
            h: originalItemElementSize.h + itemDiff.h
          };
          _this.updatePositionAndItemSize(itemSize, false, true);
        }
        return count += 1;
      };
    })(this), duration * 1000);
  };

  ItemBase.switchChildrenConfig = function(e, varName, openValue, targetValue) {
    var cKey, cValue, openClassName, root;
    for (cKey in openValue) {
      cValue = openValue[cKey];
      if (cValue == null) {
        return;
      }
      if (typeof targetValue === 'object') {
        return;
      }
      if (typeof cValue === 'string' && (cValue === 'true' || cValue === 'false')) {
        cValue = cValue === 'true';
      }
      if (typeof targetValue === 'string' && (targetValue === 'true' || targetValue === 'false')) {
        targetValue = targetValue === 'true';
      }
      root = e.closest("." + constant.DesignConfig.ROOT_CLASSNAME);
      openClassName = ConfigMenu.Modifiable.CHILDREN_WRAPPER_CLASS.replace('@parentvarname', varName).replace('@childrenkey', cKey);
      if (cValue === targetValue) {
        $(root).find("." + openClassName).show();
      } else {
        $(root).find("." + openClassName).hide();
      }
    }
  };

  if (window.isWorkTable) {
    ItemBase.include(itemBaseWorktableExtend);
  }

  return ItemBase;

})(ItemEventBase);

//# sourceMappingURL=item_base.js.map
