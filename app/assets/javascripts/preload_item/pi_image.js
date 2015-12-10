// Generated by CoffeeScript 1.9.2
var PreloadItemImage,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PreloadItemImage = (function(superClass) {
  var _loadImageUploadConfig, _sizeOfKeepAspect, constant;

  extend(PreloadItemImage, superClass);

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    PreloadItemImage.Key = (function() {
      function Key() {}

      Key.PROJECT_ID = constant.PreloadItemImage.Key.PROJECT_ID;

      Key.ITEM_OBJ_ID = constant.PreloadItemImage.Key.ITEM_OBJ_ID;

      Key.EVENT_DIST_ID = constant.PreloadItemImage.Key.EVENT_DIST_ID;

      Key.URL = constant.PreloadItemImage.Key.URL;

      return Key;

    })();
  }

  PreloadItemImage.IDENTITY = "image";

  PreloadItemImage.ITEM_ACCESS_TOKEN = 'PreloadItemImage';

  PreloadItemImage.actionProperties = {
    modifiables: {
      imagePath: {
        name: "Select image",
        type: 'select_file',
        ja: {
          name: "画像を選択"
        }
      }
    }
  };

  function PreloadItemImage(cood) {
    if (cood == null) {
      cood = null;
    }
    PreloadItemImage.__super__.constructor.call(this, cood);
    this.imagePath = null;
    this._image = null;
    this.isKeepAspect = false;
    this.scale = {
      w: 1.0,
      h: 1.0
    };
    if (cood !== null) {
      this._moveLoc = {
        x: cood.x,
        y: cood.y
      };
    }
  }

  PreloadItemImage.prototype.draw = function(cood) {
    if (this.itemSize !== null) {
      this.restoreDrawingSurface(this.itemSize);
    }
    this.itemSize = {
      x: null,
      y: null,
      w: null,
      h: null
    };
    this.itemSize.w = Math.abs(cood.x - this._moveLoc.x);
    this.itemSize.h = Math.abs(cood.y - this._moveLoc.y);
    if (cood.x > this._moveLoc.x) {
      this.itemSize.x = this._moveLoc.x;
    } else {
      this.itemSize.x = cood.x;
    }
    if (cood.y > this._moveLoc.y) {
      this.itemSize.y = this._moveLoc.y;
    } else {
      this.itemSize.y = cood.y;
    }
    return drawingContext.strokeRect(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h);
  };

  PreloadItemImage.prototype.endDraw = function(zindex, show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    this.zindex = zindex;
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    return this.reDraw();
  };

  PreloadItemImage.prototype.reDraw = function(show) {
    if (show == null) {
      show = true;
    }
    PreloadItemImage.__super__.reDraw.call(this, show);
    this.clearDraw();
    return this.createItemElement((function(_this) {
      return function(createdElement) {
        $(createdElement).appendTo(window.scrollInside);
        if (!show) {
          _this.getJQueryElement().css('opacity', 0);
        }
        if (_this.setupDragAndResizeEvents != null) {
          return _this.setupDragAndResizeEvents();
        }
      };
    })(this));
  };

  PreloadItemImage.prototype.clearDraw = function() {
    return this.getJQueryElement().remove();
  };

  PreloadItemImage.prototype.updateItemSize = function(w, h) {
    this.getJQueryElement().css({
      width: w,
      height: h
    });
    this.itemSize.w = parseInt(w);
    return this.itemSize.h = parseInt(h);
  };

  PreloadItemImage.prototype.originalItemElementSize = function() {
    var diff, obj;
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(this.event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
    $.extend(true, obj, diff);
    return obj.itemSize;
  };

  PreloadItemImage.prototype.createItemElement = function(callback) {
    var contents, height, size, width;
    if (this._image != null) {
      if (this.isKeepAspect) {
        size = _sizeOfKeepAspect.call(this);
        width = size.width;
        height = size.height;
      } else {
        width = this.itemSize.w;
        height = this.itemSize.h;
      }
      contents = "<img src='" + this.imagePath + "' width='" + width + "' height='" + height + "' />";
      return callback(Common.wrapCreateItemElement(this, contents));
    } else {
      return _loadImageUploadConfig.call(this, (function(_this) {
        return function(config) {
          var left, style, top;
          style = '';
          top = _this.itemSize.h - $(config).height() / 2.0;
          left = _this.itemSize.w - $(config).width() / 2.0;
          contents = "<div style='position:absolute;top:" + top + "px;left:" + left + "px;'>" + config + "</div>";
          return callback(Common.wrapCreateItemElement(_this, contents));
        };
      })(this));
    }
  };

  _loadImageUploadConfig = function(callback) {
    return ConfigMenu.loadConfig(ConfigMenu.Action.PRELOAD_IMAGE_PATH_SELECT, function(config) {
      $(config).find("." + this.Key.PROJECT_ID).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID));
      $(config).find("." + this.Key.ITEM_OBJ_ID).val(this.id);
      $(config).off().on('ajax:complete', function(e, data, status, error) {
        console.log(data);
        return console.log(data.responseText);
      });
      return callback(config);
    });
  };

  _sizeOfKeepAspect = function() {
    if (this.itemSize.w / this.itemSize.h > this._image.naturalWidth / this._image.naturalHeight) {
      return {
        width: this._image.naturalWidth * this.itemSize.h / this._image.naturalHeight,
        height: this.itemSize.h
      };
    } else {
      return {
        width: this.itemSize.w,
        height: this._image.naturalHeight * this.itemSize.w / this._image.naturalWidth
      };
    }
  };

  return PreloadItemImage;

})(ItemBase);

Common.setClassToMap(false, PreloadItemImage.ITEM_ACCESS_TOKEN, PreloadItemImage);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[PreloadItemImage.ITEM_ACCESS_TOKEN] == null)) {
  if (typeof EventConfig !== "undefined" && EventConfig !== null) {
    EventConfig.addEventConfigContents(PreloadItemImage.ITEM_ACCESS_TOKEN);
  }
  console.log('PreloadImage loaded');
  window.itemInitFuncList[PreloadItemImage.ITEM_ACCESS_TOKEN] = function(option) {
    if (option == null) {
      option = {};
    }
    if (window.isWorkTable && (PreloadItemImage.jsLoaded != null)) {
      PreloadItemArrow.jsLoaded(option);
    }
    if (window.debug) {
      return console.log('PreloadImage init Finish');
    }
  };
}

//# sourceMappingURL=pi_image.js.map
