// Generated by CoffeeScript 1.8.0
var ArrowItem, WorkTableArrowItem,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.loadedItemTypeList.push(Constant.ItemType.ARROW);

ArrowItem = (function(_super) {
  var ARROW_WIDTH, HEADER_HEIGHT, HEADER_WIDTH, calBodyPath, calDrection, calTailDrawPath, calTrianglePath, coodLength, coodLog, drawCoodToBaseCanvas, drawCoodToCanvas, drawCoodToNewCanvas, updateArrowRect;

  __extends(ArrowItem, _super);

  ArrowItem.IDENTITY = "arrow";

  ArrowItem.ITEMTYPE = Constant.ItemType.ARROW;

  ARROW_WIDTH = 37;

  HEADER_WIDTH = 100;

  HEADER_HEIGHT = 50;

  function ArrowItem(cood) {
    if (cood == null) {
      cood = null;
    }
    this.scrollDraw = __bind(this.scrollDraw, this);
    ArrowItem.__super__.constructor.call(this, cood);
    this.direction = {
      x: 0,
      y: 0
    };
    this.coodRegist = [];
    this.coodHeadPart = [];
    this.coodLeftBodyPart = [];
    this.coodRightBodyPart = [];
    this.arrow_width = ARROW_WIDTH;
    this.arrow_half_width = this.arrow_width / 2.0;
    this.header_width = HEADER_WIDTH;
    this.header_height = HEADER_HEIGHT;
    this.padding_size = this.header_width;
    this.scale = {
      w: 1.0,
      h: 1.0
    };
    this.drawCoodRegist = [];
    this.actionEventFunc.scrollDraw = this.scrollDraw;
  }

  ArrowItem.prototype.drawPath = function(moveCood) {
    calDrection.call(this, this.drawCoodRegist[this.drawCoodRegist.length - 1], moveCood);
    this.drawCoodRegist.push(moveCood);
    calTailDrawPath.call(this);
    calBodyPath.call(this, moveCood);
    return calTrianglePath.call(this, this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1], this.coodRightBodyPart[this.coodRightBodyPart.length - 1]);
  };

  ArrowItem.prototype.drawLine = function() {
    drawingContext.beginPath();
    drawCoodToBaseCanvas.call(this);
    drawingContext.globalAlpha = 0.3;
    return drawingContext.stroke();
  };

  ArrowItem.prototype.draw = function(moveCood) {
    this.coodRegist.push(moveCood);
    updateArrowRect.call(this, moveCood);
    this.drawPath(moveCood);
    this.restoreDrawingSurface(this.itemSize);
    return this.drawLine();
  };

  ArrowItem.prototype.endDraw = function(zindex, show) {
    if (show == null) {
      show = true;
    }
    if (!ArrowItem.__super__.endDraw.call(this, zindex)) {
      return false;
    }
    this.makeElement(show);
    return true;
  };

  ArrowItem.prototype.reDraw = function(show) {
    var canvas, r, _i, _len, _ref;
    if (show == null) {
      show = true;
    }
    canvas = document.getElementById(this.canvasElementId());
    if (canvas == null) {
      this.makeNewCanvas();
    } else {
      this.clearDraw();
    }
    this.resetDrawPath();
    if (show) {
      _ref = this.coodRegist;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        r = _ref[_i];
        this.drawPath(r);
      }
      return this.drawNewCanvas();
    }
  };

  ArrowItem.prototype.resetDrawPath = function() {
    this.coodHeadPart = [];
    this.coodLeftBodyPart = [];
    this.coodRightBodyPart = [];
    return this.drawCoodRegist = [];
  };

  ArrowItem.prototype.makeElement = function(show) {
    if (show == null) {
      show = true;
    }
    this.makeNewCanvas();
    (function(_this) {
      return (function() {
        _this.coodRegist.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        _this.coodLeftBodyPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        _this.coodRightBodyPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
        return _this.coodHeadPart.forEach(function(e) {
          e.x -= _this.itemSize.x;
          return e.y -= _this.itemSize.y;
        });
      });
    })(this)();
    if (show) {
      return this.drawNewCanvas();
    }
  };

  ArrowItem.prototype.generateMinimumObject = function() {
    var obj;
    obj = {
      id: makeClone(this.id),
      itemType: Constant.ItemType.ARROW,
      itemSize: makeClone(this.itemSize),
      zindex: makeClone(this.zindex),
      coodRegist: makeClone(this.coodRegist),
      arrow_width: makeClone(this.arrow_width),
      header_width: makeClone(this.header_width),
      header_height: makeClone(this.header_height),
      scale: makeClone(this.scale)
    };
    return obj;
  };

  ArrowItem.prototype.loadByMinimumObject = function(obj) {
    this.setMiniumObject(obj);
    this.reDraw();
    return this.saveObj(Constant.ItemActionType.MAKE);
  };

  ArrowItem.prototype.setMiniumObject = function(obj) {
    this.id = makeClone(obj.id);
    this.itemSize = makeClone(obj.itemSize);
    this.zindex = makeClone(obj.zindex);
    this.coodRegist = makeClone(obj.coodRegist);
    this.arrow_width = makeClone(obj.arrow_width);
    this.arrow_half_width = makeClone(this.arrow_width / 2.0);
    this.header_width = makeClone(obj.header_width);
    this.header_height = makeClone(obj.header_height);
    this.padding_size = makeClone(this.header_width);
    return this.scale = makeClone(obj.scale);
  };

  ArrowItem.prototype.scrollDraw = function(x, y) {
    var r, _i, _len, _ref;
    if (this.scrollValue == null) {
      console.log('scroll init');
      this.saveNewDrawingSurface();
      this.scrollValue = 0;
    } else {
      console.log("y:" + y);
      if (y >= 0) {
        this.scrollValue += parseInt((y + 9) / 10);
      } else {
        this.scrollValue += parseInt((y - 9) / 10);
      }
    }
    this.scrollValue = this.scrollValue < 0 ? 0 : this.scrollValue;
    this.scrollValue = this.scrollValue >= this.coodRegist.length ? this.coodRegist.length - 1 : this.scrollValue;
    this.resetDrawPath();
    this.restoreAllNewDrawingSurface();
    _ref = this.coodRegist.slice(0, this.scrollValue);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      r = _ref[_i];
      this.drawPath(r);
    }
    this.drawNewCanvas();
    if (this.scrollValue >= this.coodRegist.length - 1) {
      console.log('scroll nextChapter');
      return this.nextChapter();
    }
  };

  coodLength = function(locA, locB) {
    return parseInt(Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2)));
  };

  calDrection = function(beforeLoc, cood) {
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

  calTrianglePath = function(leftCood, rightCood) {
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

  calTailDrawPath = function() {

    /* 検証 */
    var locSub, locTail, rad, validate;
    validate = function() {
      return this.drawCoodRegist.length === 2;
    };
    if (!validate.call(this)) {
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

  calBodyPath = function() {

    /* 検証 */
    var calCenterBodyCood, centerBodyCood, locLeftBody, locRightBody, suitCoodBasedDirection, validate;
    validate = function() {
      return this.drawCoodRegist.length >= 3;
    };

    /* 3点から引く座標を求める */
    calCenterBodyCood = function(left, center, right) {
      var cos, l, leftLength, leftX, leftY, r, rad, ret, rightLength, rightX, rightY, vectorRad;
      leftLength = coodLength.call(this, left, center);
      rightLength = coodLength.call(this, right, center);
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
    suitCoodBasedDirection = function(cood) {
      var beforeLeftCood, beforeRightCood, leftCood, ret, rightCood, suitCood;
      suitCood = function(cood, beforeCood) {
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
      leftCood = suitCood.call(this, cood.coodLeftPart, beforeLeftCood);
      rightCood = suitCood.call(this, cood.coodRightPart, beforeRightCood);
      ret = {
        coodLeftPart: leftCood,
        coodRightPart: rightCood
      };
      return ret;
    };
    if (!validate.call(this)) {
      return;
    }
    locLeftBody = this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1];
    locRightBody = this.coodRightBodyPart[this.coodRightBodyPart.length - 1];
    centerBodyCood = calCenterBodyCood.call(this, this.drawCoodRegist[this.drawCoodRegist.length - 3], this.drawCoodRegist[this.drawCoodRegist.length - 2], this.drawCoodRegist[this.drawCoodRegist.length - 1]);
    centerBodyCood = suitCoodBasedDirection.call(this, centerBodyCood);
    this.coodLeftBodyPart.push(centerBodyCood.coodLeftPart);
    return this.coodRightBodyPart.push(centerBodyCood.coodRightPart);
  };

  drawCoodToCanvas = function(dc) {
    var drawingContext, i, _i, _j, _k, _ref, _ref1, _ref2;
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
      for (i = _i = _ref = this.coodLeftBodyPart.length - 2; _ref <= 0 ? _i <= 0 : _i >= 0; i = _ref <= 0 ? ++_i : --_i) {
        drawingContext.lineTo(this.coodLeftBodyPart[i].x, this.coodLeftBodyPart[i].y);
      }
    }
    for (i = _j = 0, _ref1 = this.coodRightBodyPart.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
      drawingContext.lineTo(this.coodRightBodyPart[i].x, this.coodRightBodyPart[i].y);
    }
    for (i = _k = 0, _ref2 = this.coodHeadPart.length - 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; i = 0 <= _ref2 ? ++_k : --_k) {
      drawingContext.lineTo(this.coodHeadPart[i].x, this.coodHeadPart[i].y);
    }
    return drawingContext.closePath();
  };

  drawCoodToBaseCanvas = function() {
    return drawCoodToCanvas.call(this);
  };

  drawCoodToNewCanvas = function() {
    var drawingCanvas, drawingContext;
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    return drawCoodToCanvas.call(this, drawingContext);
  };

  ArrowItem.prototype.drawNewCanvas = function() {
    var drawingCanvas, drawingContext;
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    drawingContext.beginPath();
    drawCoodToNewCanvas.call(this);
    drawingContext.fillStyle = "#00008B";
    return drawingContext.fill();
  };

  updateArrowRect = function(cood) {
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

  coodLog = function(cood, name) {
    return console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y);
  };

  return ArrowItem;

})(CanvasItemBase);

WorkTableArrowItem = (function(_super) {
  __extends(WorkTableArrowItem, _super);

  function WorkTableArrowItem() {
    return WorkTableArrowItem.__super__.constructor.apply(this, arguments);
  }

  WorkTableArrowItem.prototype.showOptionMenu = function() {
    return $('#canvas-config').css('display', '');
  };

  WorkTableArrowItem.prototype.drag = function() {
    var element;
    element = $('#' + this.getElementId());
    this.itemSize.x = element.position().left;
    this.itemSize.y = element.position().top;
    return console.log("drag: itemSize: " + (JSON.stringify(this.itemSize)));
  };

  WorkTableArrowItem.prototype.resize = function() {
    var canvas, drawingCanvas, drawingContext, element;
    canvas = $('#' + this.canvasElementId());
    element = $('#' + this.getElementId());
    this.scale.w = element.width() / this.itemSize.w;
    this.scale.h = element.height() / this.itemSize.h;
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    drawingContext.scale(this.scale.w, this.scale.h);
    this.drawNewCanvas();
    return console.log("resize: itemSize: " + (JSON.stringify(this.itemSize)));
  };

  WorkTableArrowItem.prototype.getHistoryObj = function(action) {
    var obj;
    obj = {
      obj: this,
      action: action,
      itemSize: makeClone(this.itemSize),
      scale: makeClone(this.scale)
    };
    console.log("getHistory: scale:" + this.scale.w + "," + this.scale.h);
    return obj;
  };

  WorkTableArrowItem.prototype.setHistoryObj = function(historyObj) {
    this.itemSize = makeClone(historyObj.itemSize);
    this.scale = makeClone(historyObj.scale);
    return console.log("setHistoryObj: itemSize: " + (JSON.stringify(this.itemSize)));
  };

  return WorkTableArrowItem;

})(ArrowItem);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList.arrowInit == null)) {
  window.itemInitFuncList.arrowInit = function(option) {
    if (option == null) {
      option = {};
    }
  };
}

//# sourceMappingURL=arrow.js.map
