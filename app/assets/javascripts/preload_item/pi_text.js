// Generated by CoffeeScript 1.9.2
var PreloadItemText,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PreloadItemText = (function(superClass) {
  var _calcFontSizeAbout, _draw, _drawText, _prepareEditModal, _setNoTextStyle, _setTextStyle, _setTextToCanvas, _settingTextDbclickEvent, _showInputModal, constant;

  extend(PreloadItemText, superClass);

  PreloadItemText.NAME_PREFIX = "text";

  PreloadItemText.CLASS_DIST_TOKEN = 'PreloadItemText';

  PreloadItemText.NO_TEXT = 'No Text';

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    PreloadItemText.BalloonType = (function() {
      function BalloonType() {}

      BalloonType.NONE = constant.PreloadItemText.BalloonType.NONE;

      BalloonType.FREE = constant.PreloadItemText.BalloonType.FREE;

      BalloonType.NORMAL = constant.PreloadItemText.BalloonType.NORMAL;

      BalloonType.RECT = constant.PreloadItemText.BalloonType.RECT;

      BalloonType.THINK = constant.PreloadItemText.BalloonType.THINK;

      BalloonType.SHOUT = constant.PreloadItemText.BalloonType.SHOUT;

      return BalloonType;

    })();
    PreloadItemText.WordAlign = (function() {
      function WordAlign() {}

      WordAlign.LEFT = constant.PreloadItemText.WordAlign.LEFT;

      WordAlign.CENTER = constant.PreloadItemText.WordAlign.CENTER;

      WordAlign.RIGHT = constant.PreloadItemText.WordAlign.RIGHT;

      return WordAlign;

    })();
  }

  PreloadItemText.actionProperties = {
    modifiables: {
      textColor: {
        name: 'TextColor',
        "default": 'rgb(0, 0, 0)',
        colorType: 'rgb',
        type: 'color',
        ja: {
          name: '文字色'
        }
      },
      showBalloon: {
        name: 'Show Balloon',
        "default": false,
        type: 'boolean',
        openChildrenValue: true,
        ja: {
          name: '吹き出し表示'
        },
        children: {
          balloonColor: {
            name: 'BalloonColor',
            "default": '#fff',
            type: 'color',
            colorType: 'hex',
            ja: {
              name: '吹き出しの色'
            }
          },
          balloonRadius: {
            name: 'BalloonRadius',
            "default": 30,
            type: 'integer',
            min: 1,
            max: 100,
            ja: {
              name: '吹き出しの角丸'
            }
          }
        }
      },
      fontFamily: {
        name: "Select Font",
        type: 'select',
        ja: {
          name: 'フォント選択'
        },
        'options[]': ['sans-serif', 'arial', 'arial black', 'arial narrow', 'arial unicode ms', 'Century Gothic', 'Franklin Gothic Medium', 'Gulim', 'Dotum', 'Haettenschweiler', 'Impact', 'Ludica Sans Unicode', 'Microsoft Sans Serif', 'MS Sans Serif', 'MV Boil', 'New Gulim', 'Tahoma', 'Trebuchet', 'Verdana', 'serif', 'Batang', 'Book Antiqua', 'Bookman Old Style', 'Century', 'Estrangelo Edessa', 'Garamond', 'Gautami', 'Georgia', 'Gungsuh', 'Latha', 'Mangal', 'MS Serif', 'PMingLiU', 'Palatino Linotype', 'Raavi', 'Roman', 'Shruti', 'Sylfaen', 'Times New Roman', 'Tunga', 'monospace', 'BatangChe', 'Courier', 'Courier New', 'DotumChe', 'GulimChe', 'GungsuhChe', 'HG行書体', 'Lucida Console', 'MingLiU', 'ＭＳ ゴシック', 'ＭＳ 明朝', 'OCRB', 'SimHei', 'SimSun', 'Small Fonts', 'Terminal', 'fantasy', 'alba', 'alba matter', 'alba super', 'baby kruffy', 'Chick', 'Croobie', 'Fat', 'Freshbot', 'Frosty', 'Gloo Gun', 'Jokewood', 'Modern', 'Monotype Corsiva', 'Poornut', 'Pussycat Snickers', 'Weltron Urban', 'cursive', 'Comic Sans MS', 'HGP行書体', 'HG正楷書体-PRO', 'Jenkins v2.0', 'Script', ['ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro'], ['ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN'], ['ヒラギノ角ゴ Pro W6', 'HiraKakuPro-W6'], ['ヒラギノ角ゴ ProN W6', 'HiraKakuProN-W6'], ['ヒラギノ角ゴ Std W8', 'Hiragino Kaku Gothic Std'], ['ヒラギノ角ゴ StdN W8', 'Hiragino Kaku Gothic StdN'], ['ヒラギノ丸ゴ Pro W4', 'Hiragino Maru Gothic Pro'], ['ヒラギノ丸ゴ ProN W4', 'Hiragino Maru Gothic ProN'], ['ヒラギノ明朝 Pro W3', 'Hiragino Mincho Pro'], ['ヒラギノ明朝 ProN W3', 'Hiragino Mincho ProN'], ['ヒラギノ明朝 Pro W6', 'HiraMinPro-W6'], ['ヒラギノ明朝 ProN W6', 'HiraMinProN-W6'], 'Osaka', ['Osaka－等幅', 'Osaka-Mono'], 'MS UI Gothic', ['ＭＳ Ｐゴシック', 'MS PGothic'], ['ＭＳ ゴシック', 'MS Gothic'], ['ＭＳ Ｐ明朝', 'MS PMincho'], ['ＭＳ 明朝', 'MS Mincho'], ['メイリオ', 'Meiryo'], 'Meiryo UI']
      }
    },
    methods: {
      changeText: {
        modifiables: {
          inputText: {
            name: "Text",
            type: 'string',
            ja: {
              name: "文字"
            }
          }
        },
        options: {
          id: 'changeText',
          name: 'Text',
          desc: "Text",
          ja: {
            name: 'テキスト',
            desc: 'テキスト変更'
          }
        }
      }
    }
  };

  function PreloadItemText(cood) {
    if (cood == null) {
      cood = null;
    }
    PreloadItemText.__super__.constructor.call(this, cood);
    if (cood !== null) {
      this._moveLoc = {
        x: cood.x,
        y: cood.y
      };
    }
    this.inputText = null;
    this.isDrawHorizontal = true;
    this.fontFamily = 'Times New Roman';
    this.fontSize = null;
    this.isFixedFontSize = false;
    this.isDrawBalloon = false;
    this.balloonType = this.constructor.BalloonType.NONE;
    this.textPositions = null;
    this.wordAlign = this.constructor.WordAlign.LEFT;
  }

  PreloadItemText.prototype.updateItemSize = function(w, h) {
    return PreloadItemText.__super__.updateItemSize.call(this, w, h);
  };

  PreloadItemText.prototype.itemDraw = function(show) {
    if (show == null) {
      show = true;
    }
    PreloadItemText.__super__.itemDraw.call(this, show);
    return _draw.call(this);
  };

  PreloadItemText.prototype.refresh = function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    return PreloadItemText.__super__.refresh.call(this, show, (function(_this) {
      return function() {
        _settingTextDbclickEvent.call(_this);
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  PreloadItemText.prototype.mouseUpDrawing = function(zindex, callback) {
    if (callback == null) {
      callback = null;
    }
    this.restoreAllDrawingSurface();
    return this.endDraw(zindex, true, (function(_this) {
      return function() {
        _this.setupItemEvents();
        _this.saveObj(true);
        _this.firstFocus = Common.firstFocusItemObj() === null;
        Navbar.setModeEdit();
        WorktableCommon.changeMode(Constant.Mode.EDIT);
        _showInputModal.call(_this);
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  PreloadItemText.prototype.changeText = function(opt) {
    var changeAfter, changeBefore, opa;
    changeBefore = this.getJQueryElement().find('.change_before:first');
    changeAfter = this.getJQueryElement().find('.change_after:first');
    if (changeAfter.find('span:first').text().length === 0) {
      changeBefore.find('span:first').html(this.inputText__before);
      changeBefore.css('opacity', 1);
      changeAfter.find('span:first').html(this.inputText__after);
      return changeAfter.css('opacity', 0);
    } else {
      opa = 1 * opt.progress / opt.progressMax;
      changeBefore.css('opacity', 1 - opa);
      return changeAfter.css('opacity', opa);
    }
  };

  _draw = function() {
    if (this.inputText != null) {
      _setTextStyle.call(this);
    } else {
      _setNoTextStyle.call(this);
    }
    if (this.inputText != null) {
      return _setTextToCanvas.call(this, this.inputText);
    } else {
      return _setTextToCanvas.call(this, this.constructor.NO_TEXT);
    }
  };

  _setTextStyle = function() {
    var canvas, context;
    canvas = document.getElementById(this.canvasElementId());
    context = canvas.getContext('2d');
    return context.fillStyle = this.textColor;
  };

  _setNoTextStyle = function() {
    var canvas, context;
    canvas = document.getElementById(this.canvasElementId());
    context = canvas.getContext('2d');
    return context.fillStyle = 'rgba(33, 33, 33, 0.3)';
  };

  _setTextToCanvas = function(text) {
    var canvas, canvasHeight, canvasWidth, context;
    canvas = document.getElementById(this.canvasElementId());
    context = canvas.getContext('2d');
    canvasWidth = $(canvas).attr('width');
    canvasHeight = $(canvas).attr('height');
    if (this.fontSize == null) {
      _calcFontSizeAbout.call(this, text, canvasWidth, canvasHeight);
    }
    context.font = this.fontSize + "px " + this.fontFamily;
    context.save();
    _drawText.call(this, context, text, canvasWidth, canvasHeight);
    return context.restore();
  };

  _drawText = function(context, text, width, height) {
    var _calcSize, _calcVerticalColumnHeight, _calcVerticalColumnHeightMax, _calcVerticalColumnWidth, _calcVerticalColumnWidthMax, char, column, h, heightLine, heightMax, i, j, k, l, line, m, ref, ref1, ref2, results, results1, sizeSum, w, widthLine, widthMax, wordWidth;
    _calcSize = function(columnText) {
      var hasJapanease, i, k, ref;
      hasJapanease = false;
      for (i = k = 0, ref = columnText.length - 1; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
        if (columnText.charAt(i).charCodeAt(0) >= 256) {
          hasJapanease = true;
          break;
        }
      }
      if (hasJapanease) {
        return context.measureText('あ').width;
      } else {
        return context.measureText('M').width;
      }
    };
    _calcVerticalColumnWidth = function(columnText) {
      var char, k, len, ref, sum;
      sum = 0;
      ref = columnText.split('');
      for (k = 0, len = ref.length; k < len; k++) {
        char = ref[k];
        sum += context.measureText(char).width;
      }
      return sum;
    };
    _calcVerticalColumnHeight = function(columnText) {
      return columnText.length * context.measureText('あ').width;
    };
    _calcVerticalColumnWidthMax = function(columns) {
      var c, k, len, r, ret;
      ret = 0;
      for (k = 0, len = columns.length; k < len; k++) {
        c = columns[k];
        r = _calcVerticalColumnWidth.call(this, c);
        if (ret < r) {
          ret = r;
        }
      }
      return ret;
    };
    _calcVerticalColumnHeightMax = function(columns) {
      var c, k, len, r, ret;
      ret = 0;
      for (k = 0, len = columns.length; k < len; k++) {
        c = columns[k];
        r = _calcVerticalColumnHeight.call(this, c);
        if (ret < r) {
          ret = r;
        }
      }
      return ret;
    };
    column = [''];
    line = 0;
    text = text.replace("{br}", "\n", "gm");
    for (i = k = 0, ref = text.length - 1; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
      char = text.charAt(i);
      if (char === "\n" || (this.isDrawHorizontal && context.measureText(column[line] + char).width > width) || (!this.isDrawHorizontal && _calcVerticalColumnHeight.call(this, column[line] + char) > height)) {
        line += 1;
        column[line] = '';
        if (char === "\n") {
          char = '';
        }
      }
      column[line] += char;
    }
    sizeSum = 0;
    wordWidth = context.measureText('あ').width;
    if (this.isDrawHorizontal) {
      heightLine = (height - wordWidth * column.length) * 0.5;
      widthMax = _calcVerticalColumnWidthMax.call(this, column);
      results = [];
      for (j = l = 0, ref1 = column.length - 1; 0 <= ref1 ? l <= ref1 : l >= ref1; j = 0 <= ref1 ? ++l : --l) {
        heightLine += wordWidth;
        w = null;
        if (this.wordAlign === this.constructor.WordAlign.LEFT) {
          w = (width - widthMax) * 0.5;
        } else if (this.wordAlign === this.constructor.WordAlign.CENTER) {
          w = (width - _calcVerticalColumnWidth.call(this, column[j])) * 0.5;
        } else {
          w = (width + widthMax) * 0.5 - _calcVerticalColumnWidth.call(this, column[j]);
        }
        results.push(context.fillText(column[j], w, heightLine));
      }
      return results;
    } else {
      widthLine = (width + wordWidth * column.length) * 0.5 + wordWidth;
      heightMax = _calcVerticalColumnHeightMax.call(this, column);
      results1 = [];
      for (j = m = 0, ref2 = column.length - 1; 0 <= ref2 ? m <= ref2 : m >= ref2; j = 0 <= ref2 ? ++m : --m) {
        widthLine -= wordWidth;
        h = null;
        if (this.wordAlign === this.constructor.WordAlign.LEFT) {
          h = (height - heightMax) * 0.5;
        } else if (this.wordAlign === this.constructor.WordAlign.CENTER) {
          h = (height - _calcVerticalColumnHeight.call(this, column[j])) * 0.5;
        } else {
          h = (height + heightMax) * 0.5 - _calcVerticalColumnHeight.call(this, column[j]);
        }
        results1.push(context.fillText(column[j], widthLine, h + wordWidth));
      }
      return results1;
    }
  };

  _calcFontSizeAbout = function(text, width, height) {
    var a, fontSize, h, newLineCount, w;
    a = text.length;
    text = text.replace(/\n+$/g, '');
    if (!this.isFixedFontSize) {
      newLineCount = text.split('\n').length - 1;
      if (this.isDrawHorizontal) {
        w = height;
        h = width;
      } else {
        w = width;
        h = height;
      }
      fontSize = (Math.sqrt(Math.pow(newLineCount, 2) + (w * 4 * (a + 1)) / h) - newLineCount) * h / ((a + 1) * 2);
      if (debug) {
        console.log(fontSize);
      }
      this.fontSize = parseInt(fontSize / 1.5);
      if (this.fontSize < 1) {
        return this.fontSize = 1;
      }
    }
  };

  _showInputModal = function() {
    return Common.showModalView(Constant.ModalViewType.ITEM_TEXT_EDITING, false, (function(_this) {
      return function(modalEmt, params, callback) {
        if (callback == null) {
          callback = null;
        }
        _prepareEditModal.call(_this, modalEmt);
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  _settingTextDbclickEvent = function() {
    return this.getJQueryElement().off('dblclick').on('dblclick', (function(_this) {
      return function(e) {
        e.preventDefault();
        return _showInputModal.call(_this);
      };
    })(this));
  };

  _prepareEditModal = function(modalEmt) {
    if (this.inputText != null) {
      $('.textarea:first', modalEmt).val(this.inputText);
    } else {
      $('.textarea:first', modalEmt).val('');
    }
    $('.create_button', modalEmt).off('click').on('click', (function(_this) {
      return function(e) {
        var emt;
        emt = $(e.target).closest('.modal-content');
        _this.inputText = $('.textarea:first', emt).val();
        _this.saveObj();
        return Navbar.setModeDraw(_this.classDistToken, function() {
          WorktableCommon.changeMode(Constant.Mode.DRAW);
          return _this.refresh(true, function() {
            return Common.hideModalView();
          });
        });
      };
    })(this));
    return $('.back_button', modalEmt).off('click').on('click', (function(_this) {
      return function(e) {
        return Common.hideModalView();
      };
    })(this));
  };

  return PreloadItemText;

})(CanvasItemBase);

Common.setClassToMap(PreloadItemText.CLASS_DIST_TOKEN, PreloadItemText);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[PreloadItemText.CLASS_DIST_TOKEN] == null)) {
  if (window.debug) {
    console.log('PreloadItemText loaded');
  }
  window.itemInitFuncList[PreloadItemText.CLASS_DIST_TOKEN] = function(option) {
    if (option == null) {
      option = {};
    }
    if (window.isWorkTable && (PreloadItemText.jsLoaded != null)) {
      PreloadItemArrow.jsLoaded(option);
    }
    if (window.debug) {
      return console.log('PreloadItemText init Finish');
    }
  };
}

//# sourceMappingURL=pi_text.js.map
