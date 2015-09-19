// Generated by CoffeeScript 1.9.2
var ArrowItem, WorkTableArrowItem,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ArrowItem = (function(superClass) {
  var ARROW_WIDTH, HEADER_HEIGHT, HEADER_WIDTH, _calBodyPath, _calDrection, _calTailDrawPath, _calTrianglePath, _coodLength, _coodLog, _drawCoodToBaseCanvas, _drawCoodToCanvas, _drawCoodToNewCanvas;

  extend(ArrowItem, superClass);

  ArrowItem.IDENTITY = "Arrow";

  if (window.loadedItemId != null) {
    ArrowItem.ITEM_ID = window.loadedItemId;
  }

  ARROW_WIDTH = 37;

  HEADER_WIDTH = 100;

  HEADER_HEIGHT = 50;

  ArrowItem.actionProperties = function() {
    return {
      defaultMethod: 'scrollDraw',
      methods: {
        scrollDraw: {
          actionType: Constant.ActionType.SCROLL,
          actionAnimationType: Constant.ActionAnimationType.JQUERY_ANIMATION,
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
          actionType: Constant.ActionType.CLICK,
          actionAnimationType: Constant.ActionAnimationType.JQUERY_ANIMATION,
          options: {
            id: 'changeColorClick_Design',
            name: 'Changing color by click'
          }
        }
      }
    };
  };

  function ArrowItem(cood) {
    if (cood == null) {
      cood = null;
    }
    this.changeColorClick = bind(this.changeColorClick, this);
    ArrowItem.__super__.constructor.call(this, cood);
    this.direction = {
      x: 0,
      y: 0
    };
    this.coodHeadPart = [];
    this.coodLeftBodyPart = [];
    this.coodRightBodyPart = [];
    this.arrow_width = ARROW_WIDTH;
    this.arrow_half_width = this.arrow_width / 2.0;
    this.header_width = HEADER_WIDTH;
    this.header_height = HEADER_HEIGHT;
    this.padding_size = this.header_width;
    this.drawCoodRegist = [];
  }

  ArrowItem.prototype.drawPath = function(moveCood) {
    _calDrection.call(this, this.drawCoodRegist[this.drawCoodRegist.length - 1], moveCood);
    this.drawCoodRegist.push(moveCood);
    _calTailDrawPath.call(this);
    _calBodyPath.call(this, moveCood);
    return _calTrianglePath.call(this, this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1], this.coodRightBodyPart[this.coodRightBodyPart.length - 1]);
  };

  ArrowItem.prototype.drawLine = function() {
    drawingContext.beginPath();
    _drawCoodToBaseCanvas.call(this);
    drawingContext.globalAlpha = 0.3;
    return drawingContext.stroke();
  };

  ArrowItem.prototype.reDraw = function(show) {
    var canvas, j, len, r, ref;
    if (show == null) {
      show = true;
    }
    ArrowItem.__super__.reDraw.call(this, show);
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

  ArrowItem.prototype.resetDrawPath = function() {
    this.coodHeadPart = [];
    this.coodLeftBodyPart = [];
    this.coodRightBodyPart = [];
    return this.drawCoodRegist = [];
  };

  ArrowItem.prototype.getMinimumObject = function() {
    var newobj, obj;
    obj = ArrowItem.__super__.getMinimumObject.call(this);
    newobj = {
      itemId: this.constructor.ITEM_ID,
      arrow_width: Common.makeClone(this.arrow_width),
      header_width: Common.makeClone(this.header_width),
      header_height: Common.makeClone(this.header_height),
      scale: Common.makeClone(this.scale)
    };
    $.extend(obj, newobj);
    return obj;
  };

  ArrowItem.prototype.setMiniumObject = function(obj) {
    ArrowItem.__super__.setMiniumObject.call(this, obj);
    this.arrow_width = Common.makeClone(obj.arrow_width);
    this.arrow_half_width = Common.makeClone(this.arrow_width / 2.0);
    this.header_width = Common.makeClone(obj.header_width);
    this.header_height = Common.makeClone(obj.header_height);
    this.padding_size = Common.makeClone(this.header_width);
    return this.scale = Common.makeClone(obj.scale);
  };

  ArrowItem.prototype.updateEventBefore = function() {
    var methodName;
    methodName = this.getEventMethodName();
    if (methodName === 'scrollDraw') {
      return this.reDraw(false);
    }
  };

  ArrowItem.prototype.updateEventAfter = function() {
    var methodName;
    methodName = this.getEventMethodName();
    if (methodName === 'scrollDraw') {
      this.reDraw(false);
      return this.constructor.prototype[methodName].call(this, this.event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]);
    }
  };

  ArrowItem.prototype.scrollDraw = function(scrollValue) {
    var j, len, r, ref;
    r = scrollValue / this.scrollLength();
    this.resetDrawPath();
    this.restoreAllNewDrawingSurface();
    ref = this.coodRegist.slice(0, parseInt((this.coodRegist.length - 1) * r));
    for (j = 0, len = ref.length; j < len; j++) {
      r = ref[j];
      this.drawPath(r);
    }
    return this.drawNewCanvas();
  };

  ArrowItem.prototype.changeColorClick = function(e) {};

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
    return this.direction = {
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
      x: Math.cos(sita) * (this.header_width + this.arrow_width) / 2.0 + rightCood.x,
      y: Math.sin(sita) * (this.header_width + this.arrow_width) / 2.0 + rightCood.y
    };
    sitaRight = sita + Math.PI;
    rightTop = {
      x: Math.cos(sitaRight) * (this.header_width - this.arrow_width) / 2.0 + rightCood.x,
      y: Math.sin(sitaRight) * (this.header_width - this.arrow_width) / 2.0 + rightCood.y
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
    return this.coodHeadPart = [rightTop, top, leftTop];
  };

  _calTailDrawPath = function() {

    /* 検証 */
    var _validate, locSub, locTail, rad;
    _validate = function() {
      return this.drawCoodRegist.length === 2;
    };
    if (!_validate.call(this)) {
      return;
    }
    locTail = this.drawCoodRegist[0];
    locSub = this.drawCoodRegist[1];
    rad = Math.atan2(locSub.y - locTail.y, locSub.x - locTail.x);
    this.coodRightBodyPart.push({
      x: -(Math.sin(rad) * this.arrow_half_width) + locTail.x,
      y: Math.cos(rad) * this.arrow_half_width + locTail.y
    });
    return this.coodLeftBodyPart.push({
      x: Math.sin(rad) * this.arrow_half_width + locTail.x,
      y: -(Math.cos(rad) * this.arrow_half_width) + locTail.y
    });
  };

  _calBodyPath = function() {

    /* 検証 */
    var _calCenterBodyCood, _suitCoodBasedDirection, _validate, centerBodyCood, locLeftBody, locRightBody;
    _validate = function() {
      return this.drawCoodRegist.length >= 3;
    };

    /* 3点から引く座標を求める */
    _calCenterBodyCood = function(left, center, right) {
      var cos, l, leftLength, leftX, leftY, r, rad, ret, rightLength, rightX, rightY, vectorRad;
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
      leftX = parseInt(Math.cos(rad + Math.PI) * this.arrow_half_width + center.x);
      leftY = parseInt(Math.sin(rad + Math.PI) * this.arrow_half_width + center.y);
      rightX = parseInt(Math.cos(rad) * this.arrow_half_width + center.x);
      rightY = parseInt(Math.sin(rad) * this.arrow_half_width + center.y);
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
        if (this.direction.x < 0 && beforeCood.x < cood.x) {
          cood.x = beforeCood.x;
        } else if (this.direction.x > 0 && beforeCood.x > cood.x) {
          cood.x = beforeCood.x;
        }
        if (this.direction.y < 0 && beforeCood.y < cood.y) {
          cood.y = beforeCood.y;
        } else if (this.direction.y > 0 && beforeCood.y > cood.y) {
          cood.y = beforeCood.y;
        }
        return cood;
      };
      beforeLeftCood = this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1];
      beforeRightCood = this.coodRightBodyPart[this.coodRightBodyPart.length - 1];
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
    locLeftBody = this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1];
    locRightBody = this.coodRightBodyPart[this.coodRightBodyPart.length - 1];
    centerBodyCood = _calCenterBodyCood.call(this, this.drawCoodRegist[this.drawCoodRegist.length - 3], this.drawCoodRegist[this.drawCoodRegist.length - 2], this.drawCoodRegist[this.drawCoodRegist.length - 1]);
    centerBodyCood = _suitCoodBasedDirection.call(this, centerBodyCood);
    this.coodLeftBodyPart.push(centerBodyCood.coodLeftPart);
    return this.coodRightBodyPart.push(centerBodyCood.coodRightPart);
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
    if (this.coodLeftBodyPart.length <= 0 || this.coodRightBodyPart.length <= 0) {
      return;
    }
    drawingContext.moveTo(this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1].x, this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1].y);
    if (this.coodLeftBodyPart.length >= 2) {
      for (i = j = ref = this.coodLeftBodyPart.length - 2; ref <= 0 ? j <= 0 : j >= 0; i = ref <= 0 ? ++j : --j) {
        drawingContext.lineTo(this.coodLeftBodyPart[i].x, this.coodLeftBodyPart[i].y);
      }
    }
    for (i = k = 0, ref1 = this.coodRightBodyPart.length - 1; 0 <= ref1 ? k <= ref1 : k >= ref1; i = 0 <= ref1 ? ++k : --k) {
      drawingContext.lineTo(this.coodRightBodyPart[i].x, this.coodRightBodyPart[i].y);
    }
    for (i = m = 0, ref2 = this.coodHeadPart.length - 1; 0 <= ref2 ? m <= ref2 : m >= ref2; i = 0 <= ref2 ? ++m : --m) {
      drawingContext.lineTo(this.coodHeadPart[i].x, this.coodHeadPart[i].y);
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

  ArrowItem.prototype.drawNewCanvas = function() {
    var drawingCanvas, drawingContext;
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    drawingContext.beginPath();
    _drawCoodToNewCanvas.call(this);
    drawingContext.fillStyle = "#00008B";
    return drawingContext.fill();
  };

  _coodLog = function(cood, name) {
    if (window.debug) {
      return console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y);
    }
  };

  return ArrowItem;

})(CanvasItemBase);

Common.setClassToMap(false, ArrowItem.ITEM_ID, ArrowItem);

if (window.isWorkTable) {
  WorkTableArrowItem = (function(superClass) {
    var _updateArrowRect;

    extend(WorkTableArrowItem, superClass);

    function WorkTableArrowItem() {
      return WorkTableArrowItem.__super__.constructor.apply(this, arguments);
    }

    WorkTableArrowItem.include(WorkTableCommonExtend);

    WorkTableArrowItem.include(WorkTableCanvasItemExtend);

    WorkTableArrowItem.prototype.draw = function(moveCood) {
      this.coodRegist.push(moveCood);
      _updateArrowRect.call(this, moveCood);
      this.drawPath(moveCood);
      this.restoreDrawingSurface(this.itemSize);
      return this.drawLine();
    };

    WorkTableArrowItem.prototype.endDraw = function(zindex, show) {
      if (show == null) {
        show = true;
      }
      if (!WorkTableArrowItem.__super__.endDraw.call(this, zindex)) {
        return false;
      }
      this.drawAndMakeConfigsAndWritePageValue(show);
      this.saveNewDrawedSurface();
      return true;
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

    return WorkTableArrowItem;

  })(ArrowItem);
  Common.setClassToMap(false, WorkTableArrowItem.ITEM_ID, WorkTableArrowItem);
}

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[ArrowItem.ITEM_ID] == null)) {
  window.itemInitFuncList[ArrowItem.ITEM_ID] = function(option) {
    if (option == null) {
      option = {};
    }
    if (window.debug) {
      return console.log('arrow loaded');
    }
  };
}

//# sourceMappingURL=arrow.js.map
