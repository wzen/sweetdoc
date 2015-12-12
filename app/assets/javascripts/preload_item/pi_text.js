// Generated by CoffeeScript 1.9.2
var PreloadItemText,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PreloadItemText = (function(superClass) {
  var _initModalEvent, _makeImageObjectIfNeed, _sizeOfKeepAspect;

  extend(PreloadItemText, superClass);

  PreloadItemText.NAME_PREFIX = "text";

  PreloadItemText.ITEM_ACCESS_TOKEN = 'PreloadItemImage';

  PreloadItemText.actionProperties = {
    modifiables: {
      fontType: {
        name: "Select Font",
        type: 'select',
        ja: {
          name: 'フォント選択'
        },
        options: ['sans-serif', 'arial', 'arial black', 'arial narrow', 'arial unicode ms', 'Century Gothic', 'Franklin Gothic Medium', 'Gulim', 'Dotum', 'Haettenschweiler', 'Impact', 'Ludica Sans Unicode', 'Microsoft Sans Serif', 'MS Sans Serif', 'MV Boil', 'New Gulim', 'Tahoma', 'Trebuchet', 'Verdana', 'serif', 'Batang', 'Book Antiqua', 'Bookman Old Style', 'Century', 'Estrangelo Edessa', 'Garamond', 'Gautami', 'Georgia', 'Gungsuh', 'Latha', 'Mangal', 'MS Serif', 'PMingLiU', 'Palatino Linotype', 'Raavi', 'Roman', 'Shruti', 'Sylfaen', 'Times New Roman', 'Tunga', 'monospace', 'BatangChe', 'Courier', 'Courier New', 'DotumChe', 'GulimChe', 'GungsuhChe', 'HG行書体', 'Lucida Console', 'MingLiU', 'ＭＳ ゴシック', 'ＭＳ 明朝', 'OCRB', 'SimHei', 'SimSun', 'Small Fonts', 'Terminal', 'fantasy', 'alba', 'alba matter', 'alba super', 'baby kruffy', 'Chick', 'Croobie', 'Fat', 'Freshbot', 'Frosty', 'Gloo Gun', 'Jokewood', 'Modern', 'Monotype Corsiva', 'Poornut', 'Pussycat Snickers', 'Weltron Urban', 'cursive', 'Comic Sans MS', 'HGP行書体', 'HG正楷書体-PRO', 'Jenkins v2.0', 'Script', ['ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro'], ['ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN'], ['ヒラギノ角ゴ Pro W6', 'HiraKakuPro-W6'], ['ヒラギノ角ゴ ProN W6', 'HiraKakuProN-W6'], ['ヒラギノ角ゴ Std W8', 'Hiragino Kaku Gothic Std'], ['ヒラギノ角ゴ StdN W8', 'Hiragino Kaku Gothic StdN'], ['ヒラギノ丸ゴ Pro W4', 'Hiragino Maru Gothic Pro'], ['ヒラギノ丸ゴ ProN W4', 'Hiragino Maru Gothic ProN'], ['ヒラギノ明朝 Pro W3', 'Hiragino Mincho Pro'], ['ヒラギノ明朝 ProN W3', 'Hiragino Mincho ProN'], ['ヒラギノ明朝 Pro W6', 'HiraMinPro-W6'], ['ヒラギノ明朝 ProN W6', 'HiraMinProN-W6'], 'Osaka', ['Osaka－等幅', 'Osaka-Mono'], 'MS UI Gothic', ['ＭＳ Ｐゴシック', 'MS PGothic'], ['ＭＳ ゴシック', 'MS Gothic'], ['ＭＳ Ｐ明朝', 'MS PMincho'], ['ＭＳ 明朝', 'MS Mincho'], ['メイリオ', 'Meiryo'], 'Meiryo UI']
      },
      imagePath: {
        name: "Text",
        type: 'string',
        ja: {
          name: "画像を選択"
        }
      }
    }
  };

  function PreloadItemText(cood) {
    if (cood == null) {
      cood = null;
    }
    PreloadItemText.__super__.constructor.call(this, cood);
    this.imagePath = null;
    this._image = null;
    this.isKeepAspect = true;
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
    this.visible = true;
    if (window.isWorkTable) {
      this.constructor.include(WorkTableCommonInclude);
    }
  }

  PreloadItemText.prototype.draw = function(cood) {
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

  PreloadItemText.prototype.endDraw = function(zindex, show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    this.zindex = zindex;
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    return this.createItemElement(true, (function(_this) {
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

  PreloadItemText.prototype.reDraw = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    return PreloadItemText.__super__.reDraw.call(this, show, (function(_this) {
      return function() {
        _this.clearDraw();
        return _this.createItemElement(false, function(createdElement) {
          $(createdElement).appendTo(window.scrollInside);
          if (!show) {
            _this.getJQueryElement().css('opacity', 0);
          }
          if (_this.setupDragAndResizeEvents != null) {
            _this.setupDragAndResizeEvents();
          }
          if (callback != null) {
            return callback();
          }
        });
      };
    })(this));
  };

  PreloadItemText.prototype.applyDesignChange = function(doStyleSave) {
    return this.reDraw();
  };

  PreloadItemText.prototype.clearDraw = function() {
    return this.getJQueryElement().remove();
  };

  PreloadItemText.prototype.updateItemSize = function(w, h) {
    var img, size;
    this.getJQueryElement().css({
      width: w,
      height: h
    });
    this.itemSize.w = parseInt(w);
    this.itemSize.h = parseInt(h);
    size = _sizeOfKeepAspect.call(this);
    img = this.getJQueryElement().find('img');
    img.width(size.width);
    return img.height(size.height);
  };

  PreloadItemText.prototype.originalItemElementSize = function() {
    var diff, obj;
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(this.event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
    $.extend(true, obj, diff);
    return obj.itemSize;
  };

  PreloadItemText.prototype.createItemElement = function(showModal, callback) {
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
          return callback(Common.wrapCreateItemElement(_this, $(contents)));
        } else {
          contents = "<div class='no_image'><div class='center_image put_center'></div></div>";
          if (showModal) {
            Common.showModalView(Constant.ModalViewType.ITEM_IMAGE_UPLOAD, true, function(modalEmt, params, callback) {
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
          return callback(Common.wrapCreateItemElement(_this, $(contents)));
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

  return PreloadItemText;

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

//# sourceMappingURL=pi_text.js.map
