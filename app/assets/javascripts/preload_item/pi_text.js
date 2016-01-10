// Generated by CoffeeScript 1.9.2
var PreloadItemText,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PreloadItemText = (function(superClass) {
  var _calcFontSizeAbout, _calcWordMeasure, _drawBalloon, _drawText, _isWordNeedRotate, _isWordSmallJapanease, _measureImage, _prepareEditModal, _setNoTextStyle, _setTextStyle, _setTextToCanvas, _settingTextDbclickEvent, _showInputModal, constant;

  extend(PreloadItemText, superClass);

  PreloadItemText.NAME_PREFIX = "text";

  PreloadItemText.CLASS_DIST_TOKEN = 'PreloadItemText';

  PreloadItemText.NO_TEXT = 'No Text';

  PreloadItemText.WRITE_TEXT_BLUR_LENGTH = 3;

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    PreloadItemText.BalloonType = (function() {
      function BalloonType() {}

      BalloonType.NONE = constant.PreloadItemText.BalloonType.NONE;

      BalloonType.FREE = constant.PreloadItemText.BalloonType.FREE;

      BalloonType.ARC = constant.PreloadItemText.BalloonType.ARC;

      BalloonType.RECT = constant.PreloadItemText.BalloonType.RECT;

      BalloonType.BROKEN_ARC = constant.PreloadItemText.BalloonType.BROKEN_ARC;

      BalloonType.BROKEN_RECT = constant.PreloadItemText.BalloonType.BROKEN_RECT;

      BalloonType.SHOUT = constant.PreloadItemText.BalloonType.SHOUT;

      BalloonType.THINK = constant.PreloadItemText.BalloonType.THINK;

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
        "default": {
          r: 0,
          g: 0,
          b: 0
        },
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
          name: 'changeText',
          desc: "changeText",
          ja: {
            name: 'テキスト',
            desc: 'テキスト変更'
          }
        }
      },
      writeText: {
        options: {
          id: 'writeText',
          name: 'writeText',
          desc: "writeText",
          ja: {
            name: 'テキスト',
            desc: 'テキスト描画'
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
    this._fontMeatureCache = {};
  }

  PreloadItemText.prototype.updateItemSize = function(w, h) {
    return PreloadItemText.__super__.updateItemSize.call(this, w, h);
  };

  PreloadItemText.prototype.itemDraw = function(show) {
    if (show == null) {
      show = true;
    }
    PreloadItemText.__super__.itemDraw.call(this, show);
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
    var canvas, context, opa;
    opa = opt.progress / opt.progressMax;
    canvas = document.getElementById(this.canvasElementId());
    context = canvas.getContext('2d');
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.fillStyle = "rgb(" + this.textColor.r + "," + this.textColor.g + "," + this.textColor.b + ")";
    context.globalAlpha = 1 - opa;
    _setTextToCanvas.call(this, this.inputText__before);
    context.globalAlpha = opa;
    return _setTextToCanvas.call(this, this.inputText__after);
  };

  PreloadItemText.prototype.writeText = function(opt) {
    var canvas, context;
    canvas = document.getElementById(this.canvasElementId());
    context = canvas.getContext('2d');
    context.clearRect(0, 0, canvas.width, canvas.height);
    if ((this.inputText != null) && this.inputText.length > 0) {
      _setTextStyle.call(this);
      return _setTextToCanvas.call(this, this.inputText, this.inputText.length * opt.progress / opt.progressMax);
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

  _setTextToCanvas = function(text, writingLength) {
    var canvas, context;
    if (text == null) {
      return;
    }
    canvas = document.getElementById(this.canvasElementId());
    context = canvas.getContext('2d');
    if (this.fontSize == null) {
      _calcFontSizeAbout.call(this, text, canvas.width, canvas.height);
    }
    context.font = this.fontSize + "px " + this.fontFamily;
    context.save();
    _drawText.call(this, context, text, canvas.width, canvas.height, writingLength);
    return context.restore();
  };

  _drawBalloon = function(context, width, height) {
    var _drawArc, _drawBArc, _drawBRect, _drawRect, _drawShout, _drawThink;
    _drawArc = function() {
      context.save();
      context.beginPath();
      context.translate(width * 0.5, height * 0.5);
      if (width > height) {
        context.scale(width / height, 1);
        context.arc(0, 0, height * 0.5, 0, Math.PI * 2);
      } else {
        context.scale(1, height / width);
        context.arc(0, 0, width * 0.5, 0, Math.PI * 2);
      }
      return context.restore();
    };
    _drawRect = function() {
      context.beginPath();
      context.fillStyle = 'rgba(0, 0, 255, 0.5)';
      return context.fillRect(0, 0, width, height);
    };
    _drawBArc = function() {
      var l, per, sum, x, y;
      context.save();
      context.beginPath();
      context.translate(width * 0.5, height * 0.5);
      per = Math.PI * 2 / 360;
      if (width > height) {
        context.scale(width / height, 1);
        sum = 0;
        x = 0;
        while (sum < Math.PI * 2) {
          l = ((2 * Math.cos(x)) + 1) * per;
          y = x + l;
          context.arc(0, 0, height * 0.5, x, y);
          sum += l;
          l = ((1 * Math.cos(x)) + 1) * per;
          y = x + l;
          sum += l;
        }
      } else {
        context.scale(1, height / width);
        sum = 0;
        x = 0;
        while (sum < Math.PI * 2) {
          l = ((2 * Math.sin(x)) + 1) * per;
          y = x + l;
          context.arc(0, 0, height * 0.5, x, y);
          sum += l;
          l = ((1 * Math.sin(x)) + 1) * per;
          y = x + l;
          sum += l;
        }
        context.arc(0, 0, width * 0.5, 0, Math.PI * 2);
      }
      return context.restore();
    };
    _drawBRect = function() {};
    _drawShout = function() {};
    _drawThink = function() {};
    if (this.balloonType === this.constructor.BalloonType.ARC) {
      return _drawArc.call(this);
    } else if (this.balloonType === this.constructor.BalloonType.RECT) {
      return _drawRect.call(this);
    } else if (this.balloonType === this.constructor.BalloonType.BROKEN_ARC) {
      return _drawBArc.call(this);
    } else if (this.balloonType === this.constructor.BalloonType.BROKEN_RECT) {
      return _drawBRect.call(this);
    } else if (this.balloonType === this.constructor.BalloonType.SHOUT) {
      return _drawShout.call(this);
    } else if (this.balloonType === this.constructor.BalloonType.THINK) {
      return _drawThink.call(this);
    }
  };

  _drawText = function(context, text, width, height, writingLength) {
    var _calcSize, _calcVerticalColumnHeight, _calcVerticalColumnHeightMax, _calcVerticalColumnWidth, _calcVerticalColumnWidthMax, _preTextStyle, _writeLength, c, char, column, h, heightLine, heightMax, hl, i, idx, j, k, len, len1, line, m, measure, n, o, p, ref, ref1, ref2, ref3, ref4, results, results1, sizeSum, w, widthLine, widthMax, wl, wordSum, wordWidth;
    if (writingLength == null) {
      writingLength = text.length;
    }
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
        return context.measureText('W').width;
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
    _preTextStyle = function(context, idx, writingLength) {
      var ga;
      if (writingLength === 0) {
        return context.globalAlpha = 0;
      } else if (idx <= writingLength) {
        return context.globalAlpha = 1;
      } else {
        ga = 1 - ((idx - writingLength) / this.constructor.WRITE_TEXT_BLUR_LENGTH);
        if (ga < 0) {
          ga = 0;
        }
        return context.globalAlpha = ga;
      }
    };
    _writeLength = function(column, writingLength, wordSum) {
      var v;
      v = parseInt(writingLength - wordSum);
      if (v > column.length) {
        v = column.length;
      } else if (v < 0) {
        v = 0;
      }
      return v;
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
    wordSum = 0;
    if (this.isDrawHorizontal) {
      heightLine = (height - wordWidth * column.length) * 0.5;
      widthMax = _calcVerticalColumnWidthMax.call(this, column);
      results = [];
      for (j = m = 0, ref1 = column.length - 1; 0 <= ref1 ? m <= ref1 : m >= ref1; j = 0 <= ref1 ? ++m : --m) {
        heightLine += wordWidth;
        w = null;
        if (this.wordAlign === this.constructor.WordAlign.LEFT) {
          w = (width - widthMax) * 0.5;
        } else if (this.wordAlign === this.constructor.WordAlign.CENTER) {
          w = (width - _calcVerticalColumnWidth.call(this, column[j])) * 0.5;
        } else {
          w = (width + widthMax) * 0.5 - _calcVerticalColumnWidth.call(this, column[j]);
        }
        context.beginPath();
        wl = 0;
        ref2 = column[j].split('');
        for (idx = n = 0, len = ref2.length; n < len; idx = ++n) {
          c = ref2[idx];
          _preTextStyle.call(this, context, idx + wordSum + 1, writingLength);
          context.fillText(c, w + wl, heightLine);
          wl += context.measureText(c).width;
        }
        results.push(wordSum += column[j].length);
      }
      return results;
    } else {
      widthLine = (width + wordWidth * column.length) * 0.5;
      heightMax = _calcVerticalColumnHeightMax.call(this, column);
      results1 = [];
      for (j = o = 0, ref3 = column.length - 1; 0 <= ref3 ? o <= ref3 : o >= ref3; j = 0 <= ref3 ? ++o : --o) {
        widthLine -= wordWidth;
        h = null;
        if (this.wordAlign === this.constructor.WordAlign.LEFT) {
          h = (height - heightMax) * 0.5;
        } else if (this.wordAlign === this.constructor.WordAlign.CENTER) {
          h = (height - _calcVerticalColumnHeight.call(this, column[j])) * 0.5;
        } else {
          h = (height + heightMax) * 0.5 - _calcVerticalColumnHeight.call(this, column[j]);
        }
        context.beginPath();
        hl = 0;
        ref4 = column[j].split('');
        for (idx = p = 0, len1 = ref4.length; p < len1; idx = ++p) {
          c = ref4[idx];
          measure = _calcWordMeasure.call(this, c, this.fontSize, this.fontFamily, wordWidth);
          _preTextStyle.call(this, context, idx + wordSum + 1, writingLength);
          if (_isWordSmallJapanease.call(this, c)) {
            context.fillText(c, widthLine + (wordWidth - measure.width) * 0.5, h + wordWidth + hl - (wordWidth - measure.height));
            hl += measure.height;
          } else if (_isWordNeedRotate.call(this, c)) {
            context.save();
            context.beginPath();
            context.translate(widthLine + wordWidth * 0.5, h + hl + measure.height);
            context.rotate(Math.PI / 2);
            context.fillText(c, -measure.width * 0.5, wordWidth * 0.75 * 0.5);
            context.restore();
            hl += measure.width;
          } else {
            context.fillText(c, widthLine, h + wordWidth + hl);
            hl += measure.height;
          }
        }
        results1.push(wordSum += column[j].length);
      }
      return results1;
    }
  };

  _calcWordMeasure = function(char, fontSize, fontFamily, wordSize) {
    var fontSizeKey, mi, nCanvas, nContext, writedImage;
    fontSizeKey = "" + fontSize;
    if ((this._fontMeatureCache[fontSizeKey] != null) && (this._fontMeatureCache[fontSizeKey][fontFamily] != null) && (this._fontMeatureCache[fontSizeKey][fontFamily][char] != null)) {
      return this._fontMeatureCache[fontSizeKey][fontFamily][char];
    }
    nCanvas = document.createElement('canvas');
    nCanvas.width = wordSize;
    nCanvas.height = wordSize;
    nContext = nCanvas.getContext('2d');
    nContext.font = fontSize + "px " + fontFamily;
    nContext.textBaseline = 'top';
    nContext.fillStyle = nCanvas.strokeStyle = '#ff0000';
    nContext.fillText(char, 0, 0);
    writedImage = nContext.getImageData(0, 0, wordSize, wordSize);
    mi = _measureImage.call(this, writedImage);
    if (window.debug) {
      console.log('char: ' + char + ' textWidth:' + mi.width + ' textHeight:' + mi.height);
    }
    if (this._fontMeatureCache[fontSizeKey] == null) {
      this._fontMeatureCache[fontSizeKey] = {};
    }
    if (this._fontMeatureCache[fontSizeKey][fontFamily] == null) {
      this._fontMeatureCache[fontSizeKey][fontFamily] = {};
    }
    this._fontMeatureCache[fontSizeKey][fontFamily][char] = mi;
    return mi;
  };

  _measureImage = function(_writedImage) {
    var i, k, maxX, maxY, minX, minY, ref, w, x, y;
    w = _writedImage.width;
    x = 0;
    y = 0;
    minX = 0;
    maxX = 1;
    minY = 0;
    maxY = 1;
    for (i = k = 0, ref = _writedImage.data.length - 1; k <= ref; i = k += 4) {
      if (_writedImage.data[i + 0] > 128) {
        if (x < minX) {
          minX = x;
        }
        if (x > maxX) {
          maxX = x;
        }
        if (y < minY) {
          minY = y;
        }
        if (y > maxY) {
          maxY = y;
        }
      }
      x += 1;
      if (x >= w) {
        x = 0;
        y += 1;
      }
    }
    return {
      width: maxX - minX + 1,
      height: maxY - minY + 1
    };
  };

  _isWordSmallJapanease = function(char) {
    var list, regex;
    list = '、。ぁぃぅぇぉっゃゅょゎァィゥェォっャュョヮヵヶ'.split('');
    list = list.concat([',', '\\.']);
    regex = new RegExp(list.join('|'));
    return char.match(regex);
  };

  _isWordNeedRotate = function(char) {
    var list, regex;
    if (char.charCodeAt(0) < 256) {
      return true;
    }
    list = 'ー＝';
    regex = new RegExp(list.split('').join('|'));
    return char.match(regex);
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
