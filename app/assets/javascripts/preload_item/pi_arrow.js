// Generated by CoffeeScript 1.9.2
var PreloadItemArrow,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PreloadItemArrow = (function(superClass) {
  var HEADER_HEIGHT, HEADER_WIDTH, _calBodyPath, _calDrection, _calTailDrawPath, _calTrianglePath, _coodLength, _coodLog, _drawCoodToBaseCanvas, _drawCoodToCanvas, _drawCoodToNewCanvas, _updateArrowRect;

  extend(PreloadItemArrow, superClass);

  PreloadItemArrow.IDENTITY = "Arrow";

  PreloadItemArrow.ITEM_ACCESS_TOKEN = 'PreloadItemArrow';

  HEADER_WIDTH = 100;

  HEADER_HEIGHT = 50;

  PreloadItemArrow.actionProperties = {
    defaultMethod: 'scrollDraw',
    designConfig: true,
    designConfigDefaultValues: {
      values: {
        design_slider_font_size_value: 14,
        design_font_color_value: 'ffffff',
        design_slider_padding_top_value: 10,
        design_slider_padding_left_value: 20,
        design_slider_gradient_deg_value: 0,
        design_bg_color1_value: 'ffbdf5',
        design_bg_color2_value: 'ff82ec',
        design_bg_color2_position_value: 25,
        design_bg_color3_value: 'fc46e1',
        design_bg_color3_position_value: 50,
        design_bg_color4_value: 'fc46e1',
        design_bg_color4_position_value: 75,
        design_bg_color5_value: 'fc46e1',
        design_border_color_value: 'ffffff',
        design_slider_border_radius_value: 30,
        design_slider_border_width_value: 3,
        design_slider_shadow_left_value: 3,
        design_slider_shadow_top_value: 3,
        design_slider_shadow_size_value: 11,
        design_shadow_color_value: '000,000,000',
        design_slider_shadow_opacity_value: 0.5
      },
      flags: {
        design_bg_color2_flag: false,
        design_bg_color3_flag: false,
        design_bg_color4_flag: false
      }
    },
    modifiables: {
      arrowWidth: {
        name: "Arrow's width",
        "default": 37,
        type: 'number',
        min: 1,
        max: 99,
        ja: {
          name: "矢印の幅"
        }
      }
    },
    methods: {
      scrollDraw: {
        actionType: 'scroll',
        scrollEnabledDirection: {
          top: true,
          bottom: true,
          left: false,
          right: false
        },
        scrollForwardDirection: {
          top: false,
          bottom: true,
          left: false,
          right: false
        },
        modifiables: {
          arrowWidth: {
            name: "Arrow's width",
            type: 'number',
            min: 1,
            max: 99,
            varAutoChange: true,
            ja: {
              name: "矢印の幅"
            }
          }
        },
        options: {
          id: 'drawScroll',
          name: 'Drawing by scroll',
          desc: "Draw by scroll action",
          ja: {
            name: 'スクロールで描画',
            desc: 'スクロールで矢印を描画'
          }
        }
      },
      changeColorClick: {
        actionType: 'click',
        options: {
          id: 'changeColorClick_Design',
          name: 'Changing color by click'
        }
      }
    }
  };

  function PreloadItemArrow(cood) {
    if (cood == null) {
      cood = null;
    }
    this.changeColorClick = bind(this.changeColorClick, this);
    PreloadItemArrow.__super__.constructor.call(this, cood);
    this._direction = {
      x: 0,
      y: 0
    };
    this._coodHeadPart = [];
    this._coodLeftBodyPart = [];
    this._coodRightBodyPart = [];
    this.header_width = HEADER_WIDTH;
    this.header_height = HEADER_HEIGHT;
    this.padding_size = this.header_width;
    this._drawCoodRegist = [];
  }

  PreloadItemArrow.prototype.drawPath = function(moveCood) {
    _calDrection.call(this, this._drawCoodRegist[this._drawCoodRegist.length - 1], moveCood);
    this._drawCoodRegist.push(moveCood);
    _calTailDrawPath.call(this);
    _calBodyPath.call(this, moveCood);
    return _calTrianglePath.call(this, this._coodLeftBodyPart[this._coodLeftBodyPart.length - 1], this._coodRightBodyPart[this._coodRightBodyPart.length - 1]);
  };

  PreloadItemArrow.prototype.drawLine = function() {
    drawingContext.beginPath();
    _drawCoodToBaseCanvas.call(this);
    drawingContext.globalAlpha = 0.3;
    return drawingContext.stroke();
  };

  PreloadItemArrow.prototype.reDraw = function(show) {
    var canvas, j, len, r, ref;
    if (show == null) {
      show = true;
    }
    PreloadItemArrow.__super__.reDraw.call(this, show);
    canvas = document.getElementById(this.canvasElementId());
    if (canvas == null) {
      this.makeNewCanvas();
    } else {
      this.clearDraw();
    }
    this.resetDrawPath();
    if (show) {
      ref = this.coodRegist;
      for (j = 0, len = ref.length; j < len; j++) {
        r = ref[j];
        this.drawPath(r);
      }
      this.drawNewCanvas();
    }
    if (this.setupDragAndResizeEvents != null) {
      return this.setupDragAndResizeEvents();
    }
  };

  PreloadItemArrow.prototype.resetDrawPath = function() {
    this._coodHeadPart = [];
    this._coodLeftBodyPart = [];
    this._coodRightBodyPart = [];
    return this._drawCoodRegist = [];
  };

  PreloadItemArrow.prototype.updateEventBefore = function() {
    var methodName;
    PreloadItemArrow.__super__.updateEventBefore.call(this);
    methodName = this.getEventMethodName();
    if (methodName === 'scrollDraw') {
      return this.reDraw(false);
    }
  };

  PreloadItemArrow.prototype.updateEventAfter = function() {
    var methodName;
    PreloadItemArrow.__super__.updateEventAfter.call(this);
    methodName = this.getEventMethodName();
    if (methodName === 'scrollDraw') {
      return this.reDraw();
    }
  };

  PreloadItemArrow.prototype.scrollDraw = function(opt) {
    var j, len, r, ref;
    r = opt.step / this.stepMax();
    this.resetDrawPath();
    this.restoreAllNewDrawingSurface();
    ref = this.coodRegist.slice(0, parseInt((this.coodRegist.length - 1) * r));
    for (j = 0, len = ref.length; j < len; j++) {
      r = ref[j];
      this.drawPath(r);
    }
    return this.drawNewCanvas();
  };

  PreloadItemArrow.prototype.changeColorClick = function(e) {};

  _coodLength = function(locA, locB) {
    return parseInt(Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2)));
  };

  _calDrection = function(beforeLoc, cood) {
    var x, y;
    if ((beforeLoc == null) || (cood == null)) {
      return;
    }
    x = null;
    if (beforeLoc.x < cood.x) {
      x = 1;
    } else if (beforeLoc.x === cood.x) {
      x = 0;
    } else {
      x = -1;
    }
    y = null;
    if (beforeLoc.y < cood.y) {
      y = 1;
    } else if (beforeLoc.y === cood.y) {
      y = 0;
    } else {
      y = -1;
    }
    return this._direction = {
      x: x,
      y: y
    };
  };

  _calTrianglePath = function(leftCood, rightCood) {
    var leftTop, mid, r, rightTop, sita, sitaRight, sitaTop, top;
    if ((leftCood == null) || (rightCood == null)) {
      return null;
    }
    r = {
      x: leftCood.x - rightCood.x,
      y: leftCood.y - rightCood.y
    };
    sita = Math.atan2(r.y, r.x);
    leftTop = {
      x: Math.cos(sita) * (this.header_width + this.arrowWidth) / 2.0 + rightCood.x,
      y: Math.sin(sita) * (this.header_width + this.arrowWidth) / 2.0 + rightCood.y
    };
    sitaRight = sita + Math.PI;
    rightTop = {
      x: Math.cos(sitaRight) * (this.header_width - this.arrowWidth) / 2.0 + rightCood.x,
      y: Math.sin(sitaRight) * (this.header_width - this.arrowWidth) / 2.0 + rightCood.y
    };
    sitaTop = sita + Math.PI / 2.0;
    mid = {
      x: (leftCood.x + rightCood.x) / 2.0,
      y: (leftCood.y + rightCood.y) / 2.0
    };
    top = {
      x: Math.cos(sitaTop) * this.header_height + mid.x,
      y: Math.sin(sitaTop) * this.header_height + mid.y
    };
    return this._coodHeadPart = [rightTop, top, leftTop];
  };

  _calTailDrawPath = function() {

    /* 検証 */
    var _validate, arrowHalfWidth, locSub, locTail, rad;
    _validate = function() {
      return this._drawCoodRegist.length === 2;
    };
    if (!_validate.call(this)) {
      return;
    }
    locTail = this._drawCoodRegist[0];
    locSub = this._drawCoodRegist[1];
    rad = Math.atan2(locSub.y - locTail.y, locSub.x - locTail.x);
    arrowHalfWidth = this.arrowWidth / 2.0;
    this._coodRightBodyPart.push({
      x: -(Math.sin(rad) * arrowHalfWidth) + locTail.x,
      y: Math.cos(rad) * arrowHalfWidth + locTail.y
    });
    return this._coodLeftBodyPart.push({
      x: Math.sin(rad) * arrowHalfWidth + locTail.x,
      y: -(Math.cos(rad) * arrowHalfWidth) + locTail.y
    });
  };

  _calBodyPath = function() {

    /* 検証 */
    var _calCenterBodyCood, _suitCoodBasedDirection, _validate, centerBodyCood, locLeftBody, locRightBody;
    _validate = function() {
      return this._drawCoodRegist.length >= 3;
    };

    /* 3点から引く座標を求める */
    _calCenterBodyCood = function(left, center, right) {
      var arrowHalfWidth, cos, l, leftLength, leftX, leftY, r, rad, ret, rightLength, rightX, rightY, vectorRad;
      leftLength = _coodLength.call(this, left, center);
      rightLength = _coodLength.call(this, right, center);
      l = {
        x: left.x - center.x,
        y: left.y - center.y
      };
      r = {
        x: right.x - center.x,
        y: right.y - center.y
      };
      cos = (l.x * r.x + l.y * r.y) / (leftLength * rightLength);
      if (cos < -1) {
        cos = -1.0;
      }
      if (cos > 1) {
        cos = 1.0;
      }
      vectorRad = Math.acos(cos);
      rad = Math.atan2(r.y, r.x) + (vectorRad / 2.0);
      arrowHalfWidth = this.arrowWidth / 2.0;
      leftX = parseInt(Math.cos(rad + Math.PI) * arrowHalfWidth + center.x);
      leftY = parseInt(Math.sin(rad + Math.PI) * arrowHalfWidth + center.y);
      rightX = parseInt(Math.cos(rad) * arrowHalfWidth + center.x);
      rightY = parseInt(Math.sin(rad) * arrowHalfWidth + center.y);
      ret = {
        coodLeftPart: {
          x: leftX,
          y: leftY
        },
        coodRightPart: {
          x: rightX,
          y: rightY
        }
      };
      return ret;
    };

    /* 進行方向から最適化 */
    _suitCoodBasedDirection = function(cood) {
      var _suitCood, beforeLeftCood, beforeRightCood, leftCood, ret, rightCood;
      _suitCood = function(cood, beforeCood) {
        if (this._direction.x < 0 && beforeCood.x < cood.x) {
          cood.x = beforeCood.x;
        } else if (this._direction.x > 0 && beforeCood.x > cood.x) {
          cood.x = beforeCood.x;
        }
        if (this._direction.y < 0 && beforeCood.y < cood.y) {
          cood.y = beforeCood.y;
        } else if (this._direction.y > 0 && beforeCood.y > cood.y) {
          cood.y = beforeCood.y;
        }
        return cood;
      };
      beforeLeftCood = this._coodLeftBodyPart[this._coodLeftBodyPart.length - 1];
      beforeRightCood = this._coodRightBodyPart[this._coodRightBodyPart.length - 1];
      leftCood = _suitCood.call(this, cood.coodLeftPart, beforeLeftCood);
      rightCood = _suitCood.call(this, cood.coodRightPart, beforeRightCood);
      ret = {
        coodLeftPart: leftCood,
        coodRightPart: rightCood
      };
      return ret;
    };
    if (!_validate.call(this)) {
      return;
    }
    locLeftBody = this._coodLeftBodyPart[this._coodLeftBodyPart.length - 1];
    locRightBody = this._coodRightBodyPart[this._coodRightBodyPart.length - 1];
    centerBodyCood = _calCenterBodyCood.call(this, this._drawCoodRegist[this._drawCoodRegist.length - 3], this._drawCoodRegist[this._drawCoodRegist.length - 2], this._drawCoodRegist[this._drawCoodRegist.length - 1]);
    centerBodyCood = _suitCoodBasedDirection.call(this, centerBodyCood);
    this._coodLeftBodyPart.push(centerBodyCood.coodLeftPart);
    return this._coodRightBodyPart.push(centerBodyCood.coodRightPart);
  };

  _drawCoodToCanvas = function(dc) {
    var drawingContext, i, j, k, m, ref, ref1, ref2;
    if (dc == null) {
      dc = null;
    }
    drawingContext = null;
    if (dc != null) {
      drawingContext = dc;
    } else {
      drawingContext = window.drawingContext;
    }
    if (this._coodLeftBodyPart.length <= 0 || this._coodRightBodyPart.length <= 0) {
      return;
    }
    drawingContext.moveTo(this._coodLeftBodyPart[this._coodLeftBodyPart.length - 1].x, this._coodLeftBodyPart[this._coodLeftBodyPart.length - 1].y);
    if (this._coodLeftBodyPart.length >= 2) {
      for (i = j = ref = this._coodLeftBodyPart.length - 2; ref <= 0 ? j <= 0 : j >= 0; i = ref <= 0 ? ++j : --j) {
        drawingContext.lineTo(this._coodLeftBodyPart[i].x, this._coodLeftBodyPart[i].y);
      }
    }
    for (i = k = 0, ref1 = this._coodRightBodyPart.length - 1; 0 <= ref1 ? k <= ref1 : k >= ref1; i = 0 <= ref1 ? ++k : --k) {
      drawingContext.lineTo(this._coodRightBodyPart[i].x, this._coodRightBodyPart[i].y);
    }
    for (i = m = 0, ref2 = this._coodHeadPart.length - 1; 0 <= ref2 ? m <= ref2 : m >= ref2; i = 0 <= ref2 ? ++m : --m) {
      drawingContext.lineTo(this._coodHeadPart[i].x, this._coodHeadPart[i].y);
    }
    return drawingContext.closePath();
  };

  _drawCoodToBaseCanvas = function() {
    return _drawCoodToCanvas.call(this);
  };

  _drawCoodToNewCanvas = function() {
    var drawingCanvas, drawingContext;
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    return _drawCoodToCanvas.call(this, drawingContext);
  };

  PreloadItemArrow.prototype.drawNewCanvas = function() {
    var drawingCanvas, drawingContext;
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    drawingContext.beginPath();
    _drawCoodToNewCanvas.call(this);
    return this.applyDesignTool();
  };

  _coodLog = function(cood, name) {
    if (window.debug) {
      return console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y);
    }
  };

  PreloadItemArrow.prototype.draw = function(moveCood) {
    this.coodRegist.push(moveCood);
    _updateArrowRect.call(this, moveCood);
    this.drawPath(moveCood);
    this.restoreDrawingSurface(this.itemSize);
    return this.drawLine();
  };

  _updateArrowRect = function(cood) {
    var maxX, maxY, minX, minY;
    if (this.itemSize === null) {
      return this.itemSize = {
        x: cood.x,
        y: cood.y,
        w: 0,
        h: 0
      };
    } else {
      minX = cood.x - this.padding_size;
      minX = minX < 0 ? 0 : minX;
      minY = cood.y - this.padding_size;
      minY = minY < 0 ? 0 : minY;
      maxX = cood.x + this.padding_size;
      maxX = maxX > drawingCanvas.width ? drawingCanvas.width : maxX;
      maxY = cood.y + this.padding_size;
      maxY = maxY > drawingCanvas.height ? drawingCanvas.height : maxY;
      if (this.itemSize.x > minX) {
        this.itemSize.w += this.itemSize.x - minX;
        this.itemSize.x = minX;
      }
      if (this.itemSize.x + this.itemSize.w < maxX) {
        this.itemSize.w += maxX - (this.itemSize.x + this.itemSize.w);
      }
      if (this.itemSize.y > minY) {
        this.itemSize.h += this.itemSize.y - minY;
        this.itemSize.y = minY;
      }
      if (this.itemSize.y + this.itemSize.h < maxY) {
        return this.itemSize.h += maxY - (this.itemSize.y + this.itemSize.h);
      }
    }
  };

  return PreloadItemArrow;

})(CanvasItemBase);

Common.setClassToMap(false, PreloadItemArrow.ITEM_ACCESS_TOKEN, PreloadItemArrow);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[PreloadItemArrow.ITEM_ACCESS_TOKEN] == null)) {
  if (typeof EventConfig !== "undefined" && EventConfig !== null) {
    EventConfig.addEventConfigContents(PreloadItemArrow.ITEM_ACCESS_TOKEN);
  }
  console.log('arrow loaded');
  window.itemInitFuncList[PreloadItemArrow.ITEM_ACCESS_TOKEN] = function(option) {
    if (option == null) {
      option = {};
    }
    if (window.isWorkTable && (PreloadItemArrow.jsLoaded != null)) {
      PreloadItemArrow.jsLoaded(option);
    }
    if (window.debug) {
      return console.log('arrow init Finish');
    }
  };
}

//# sourceMappingURL=pi_arrow.js.map