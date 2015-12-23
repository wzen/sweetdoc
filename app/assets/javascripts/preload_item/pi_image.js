// Generated by CoffeeScript 1.9.2
var PreloadItemImage,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PreloadItemImage = (function(superClass) {
  var UPLOAD_FORM_HEIGHT, UPLOAD_FORM_WIDTH, _initModalEvent, _makeImageObjectIfNeed, _sizeOfKeepAspect;

  extend(PreloadItemImage, superClass);

  UPLOAD_FORM_WIDTH = 350;

  UPLOAD_FORM_HEIGHT = 200;

  PreloadItemImage.NAME_PREFIX = "image";

  PreloadItemImage.CLASS_DIST_TOKEN = 'PreloadItemImage';

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
    this.isKeepAspect = true;
    if (cood !== null) {
      this._moveLoc = {
        x: cood.x,
        y: cood.y
      };
    }
    this.visible = true;
  }

  PreloadItemImage.prototype.updateItemSize = function(w, h) {
    var img, size;
    PreloadItemImage.__super__.updateItemSize.call(this, w, h);
    size = _sizeOfKeepAspect.call(this);
    img = this.getJQueryElement().find('img');
    img.width(size.width);
    return img.height(size.height);
  };

  PreloadItemImage.prototype.reDraw = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
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
    })(this), false);
  };

  PreloadItemImage.prototype.removeItemElement = function() {
    return PreloadItemImage.__super__.removeItemElement.call(this);
  };

  PreloadItemImage.prototype.createItemElement = function(callback, showModal) {
    if (showModal == null) {
      showModal = true;
    }
    return _makeImageObjectIfNeed.call(this, (function(_this) {
      return function() {
        var contents, height, size, width;
        if (_this._image != null) {
          if (_this.isKeepAspect) {
            size = _sizeOfKeepAspect.call(_this);
            width = size.width;
            height = size.height;
          } else {
            width = _this.itemSize.w;
            height = _this.itemSize.h;
          }
          contents = "<img class='put_center' src='" + _this.imagePath + "' width='" + width + "' height='" + height + "' />";
          return _this.addContentsToScrollInside(contents, callback);
        } else {
          contents = "<div class='no_image'><div class='center_image put_center'></div></div>";
          _this.addContentsToScrollInside(contents, callback);
          if (showModal) {
            return Common.showModalView(Constant.ModalViewType.ITEM_IMAGE_UPLOAD, true, function(modalEmt, params, callback) {
              if (callback == null) {
                callback = null;
              }
              $(modalEmt).find('form').off().on('ajax:complete', function(e, data, status, error) {
                var d;
                Common.hideModalView();
                d = JSON.parse(data.responseText);
                _this.imagePath = d.image_url;
                _this.saveObj();
                return _this.reDraw();
              });
              _initModalEvent.call(_this, modalEmt);
              if (callback != null) {
                return callback();
              }
            });
          }
        }
      };
    })(this));
  };

  _makeImageObjectIfNeed = function(callback) {
    if (this._image != null) {
      callback();
      return;
    }
    if (this.imagePath == null) {
      callback();
      return;
    }
    this._image = new Image();
    this._image.src = this.imagePath;
    this._image.onload = function() {
      return callback();
    };
    return this._image.onerror = (function(_this) {
      return function() {
        _this.imagePath = null;
        _this._image = null;
        return _this.reDraw();
      };
    })(this);
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

  _initModalEvent = function(emt) {
    return this.initModifiableSelectFile(emt);
  };

  return PreloadItemImage;

})(ItemBase);

Common.setClassToMap(PreloadItemImage.CLASS_DIST_TOKEN, PreloadItemImage);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[PreloadItemImage.CLASS_DIST_TOKEN] == null)) {
  if (typeof EventConfig !== "undefined" && EventConfig !== null) {
    EventConfig.addEventConfigContents(PreloadItemImage.CLASS_DIST_TOKEN);
  }
  if (window.debug) {
    console.log('PreloadImage loaded');
  }
  window.itemInitFuncList[PreloadItemImage.CLASS_DIST_TOKEN] = function(option) {
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
