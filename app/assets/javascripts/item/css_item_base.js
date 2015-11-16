// Generated by CoffeeScript 1.9.2
var CssItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

CssItemBase = (function(superClass) {
  var constant;

  extend(CssItemBase, superClass);

  if (window.loadedItemId != null) {
    CssItemBase.ITEM_ID = window.loadedItemId;
  }

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    CssItemBase.DESIGN_ROOT_CLASSNAME = constant.DesignConfig.ROOT_CLASSNAME;
  }

  function CssItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
    CssItemBase.__super__.constructor.call(this, cood);
    this.cssRoot = null;
    this.cssCache = null;
    this.cssCode = null;
    this.cssStyle = null;
    if (cood !== null) {
      this.moveLoc = {
        x: cood.x,
        y: cood.y
      };
    }
    this.cssStypeReflectTimer = null;
    if (window.isWorkTable) {
      this.constructor.include(WorkTableCssItemExtend);
    }
  }

  CssItemBase.jsLoaded = function(option) {};

  CssItemBase.prototype.reDraw = function(show) {
    if (show == null) {
      show = true;
    }
    CssItemBase.__super__.reDraw.call(this, show);
    this.clearDraw();
    $(ElementCode.get().createItemElement(this)).appendTo(window.scrollInside);
    if (!show) {
      this.getJQueryElement().css('opacity', 0);
    }
    if (this.setupDragAndResizeEvents != null) {
      return this.setupDragAndResizeEvents();
    }
  };

  CssItemBase.prototype.clearDraw = function() {
    return this.getJQueryElement().remove();
  };

  CssItemBase.prototype.getMinimumObject = function() {
    var newobj, obj;
    obj = CssItemBase.__super__.getMinimumObject.call(this);
    newobj = {
      itemId: this.constructor.ITEM_ID,
      mousedownCood: Common.makeClone(this.mousedownCood)
    };
    $.extend(obj, newobj);
    return obj;
  };

  CssItemBase.prototype.setMiniumObject = function(obj) {
    CssItemBase.__super__.setMiniumObject.call(this, obj);
    return this.mousedownCood = Common.makeClone(obj.mousedownCood);
  };

  CssItemBase.prototype.stateEventBefore = function(isForward) {
    var itemDiff, itemSize, obj;
    obj = this.getMinimumObject();
    if (!isForward) {
      itemSize = obj.itemSize;
      itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
      obj.itemSize = {
        x: itemSize.x - itemDiff.x,
        y: itemSize.y - itemDiff.y,
        w: itemSize.w - itemDiff.w,
        h: itemSize.h - itemDiff.h
      };
    }
    console.log("stateEventBefore");
    console.log(obj);
    return obj;
  };

  CssItemBase.prototype.stateEventAfter = function(isForward) {
    var itemDiff, itemSize, obj;
    obj = this.getMinimumObject();
    if (isForward) {
      obj = this.getMinimumObject();
      itemSize = obj.itemSize;
      itemDiff = this.event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
      obj.itemSize = {
        x: itemSize.x + itemDiff.x,
        y: itemSize.y + itemDiff.y,
        w: itemSize.w + itemDiff.w,
        h: itemSize.h + itemDiff.h
      };
    }
    console.log("stateEventAfter");
    console.log(obj);
    return obj;
  };

  CssItemBase.prototype.updateEventBefore = function() {
    var capturedEventBeforeObject;
    CssItemBase.__super__.updateEventBefore.call(this);
    capturedEventBeforeObject = this.getCapturedEventBeforeObject();
    if (capturedEventBeforeObject) {
      return this.updatePositionAndItemSize(Common.makeClone(capturedEventBeforeObject.itemSize), false);
    }
  };

  CssItemBase.prototype.updateEventAfter = function() {
    var capturedEventAfterObject;
    CssItemBase.__super__.updateEventAfter.call(this);
    capturedEventAfterObject = this.getCapturedEventAfterObject();
    if (capturedEventAfterObject) {
      return this.updatePositionAndItemSize(Common.makeClone(capturedEventAfterObject.itemSize), false);
    }
  };

  CssItemBase.prototype.updateItemSize = function(w, h) {
    this.getJQueryElement().css({
      width: w,
      height: h
    });
    this.itemSize.w = parseInt(w);
    return this.itemSize.h = parseInt(h);
  };

  CssItemBase.prototype.originalItemElementSize = function() {
    var capturedEventBeforeObject;
    capturedEventBeforeObject = this.getCapturedEventBeforeObject();
    return capturedEventBeforeObject.itemSize;
  };

  CssItemBase.prototype.getCssRootElementId = function() {
    return "css_" + this.id;
  };

  CssItemBase.prototype.getCssAnimElementId = function() {
    return "css_anim_style";
  };

  CssItemBase.prototype.makeCss = function(fromTemp) {
    var _applyCss;
    if (fromTemp == null) {
      fromTemp = false;
    }
    _applyCss = function(designs) {
      var k, ref, ref1, temp, v;
      if (designs == null) {
        return;
      }
      temp = $('.cssdesign_temp:first').clone(true).attr('class', '');
      temp.attr('id', this.getCssRootElementId());
      if (designs.values != null) {
        ref = designs.values;
        for (k in ref) {
          v = ref[k];
          temp.find("." + k).html("" + v);
        }
      }
      if (designs.flags != null) {
        ref1 = designs.flags;
        for (k in ref1) {
          v = ref1[k];
          if (!v) {
            temp.find("." + k).empty();
          }
        }
      }
      temp.find('.design_item_id').html(this.id);
      return temp.appendTo(window.cssCode);
    };
    $("" + (this.getCssRootElementId())).remove();
    if (!fromTemp && (this.designs != null)) {
      _applyCss.call(this, this.designs);
    } else {
      _applyCss.call(this, this.constructor.actionProperties.designConfigDefaultValues);
    }
    this.cssRoot = $('#' + this.getCssRootElementId());
    this.cssCache = $(".css_cache", this.cssRoot);
    this.cssCode = $(".css_code", this.cssRoot);
    this.cssStyle = $(".css_style", this.cssRoot);
    return this.applyDesignChange(false);
  };

  CssItemBase.prototype.applyDesignChange = function(doStyleSave) {
    this.reDraw();
    this.cssStyle.text(this.cssCode.text());
    if (doStyleSave) {
      return this.saveDesign();
    }
  };

  CssItemBase.prototype.cssAnimationElement = function() {
    return null;
  };

  CssItemBase.prototype.appendAnimationCssIfNeeded = function() {
    var ce, funcName, methodName;
    ce = this.cssAnimationElement();
    if (ce != null) {
      methodName = this.getEventMethodName();
      this.removeAnimationCss();
      funcName = methodName + "_" + this.id;
      return window.cssCode.append("<div class='" + funcName + "'><style type='text/css'> " + ce + " </style></div>");
    }
  };

  CssItemBase.prototype.removeAnimationCss = function() {
    var funcName, methodName;
    methodName = this.getEventMethodName();
    funcName = methodName + "_" + this.id;
    return window.cssCode.find("." + funcName).remove();
  };

  return CssItemBase;

})(ItemBase);

//# sourceMappingURL=css_item_base.js.map
