// Generated by CoffeeScript 1.8.0
var ArrowItem,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.itemLoadedJsPathList['arrow'] = true;

ArrowItem = (function(_super) {
  var ARROW_HALF_WIDTH, ARROW_WIDTH, HEADER_HEIGHT, HEADER_WIDTH, PADDING_SIZE, calBodyPath, calDrection, calTailDrawPath, calTrianglePath, clearArrow, coodLength, coodLog, drawCoodToCanvas, updateArrowRect;

  __extends(ArrowItem, _super);

  ArrowItem.IDENTITY = "arrow";

  ArrowItem.ITEMTYPE = Constant.ItemType.ARROW;

  ARROW_WIDTH = 37;

  ARROW_HALF_WIDTH = ARROW_WIDTH / 2.0;

  HEADER_WIDTH = 100;

  HEADER_HEIGHT = 50;

  PADDING_SIZE = HEADER_WIDTH;

  function ArrowItem(cood) {
    if (cood == null) {
      cood = null;
    }
    ArrowItem.__super__.constructor.call(this, cood);
    this.direction = {
      x: 0,
      y: 0
    };
    this.coodRegist = [];
    this.coodHeadPart = [];
    this.coodLeftBodyPart = [];
    this.coodRightBodyPart = [];
    this.drawCoodRegist = [];
  }

  ArrowItem.prototype.canvasElementId = function() {
    return this.getElementId() + '_canvas';
  };

  ArrowItem.prototype.drawPath = function(moveCood) {
    calDrection.call(this, this.drawCoodRegist[this.drawCoodRegist.length - 1], moveCood);
    this.drawCoodRegist.push(moveCood);
    updateArrowRect.call(this, moveCood);
    calTailDrawPath.call(this);
    calBodyPath.call(this, moveCood);
    return calTrianglePath.call(this, this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1], this.coodRightBodyPart[this.coodRightBodyPart.length - 1]);
  };

  ArrowItem.prototype.drawLine = function() {
    drawingContext.beginPath();
    drawCoodToCanvas.call(this, true);
    drawingContext.globalAlpha = 0.3;
    return drawingContext.stroke();
  };

  ArrowItem.prototype.draw = function(moveCood) {
    this.coodRegist.push(moveCood);
    this.drawPath(moveCood);
    clearArrow.call(this);
    return this.drawLine();
  };

  ArrowItem.prototype.endDraw = function(zindex) {
    if (!ArrowItem.__super__.endDraw.call(this, zindex)) {
      return false;
    }
    this.makeElement();
    return true;
  };

  ArrowItem.prototype.reDraw = function() {
    var r, _i, _len, _ref;
    this.saveDrawingSurface();
    this.drawCoodRegist = [];
    _ref = this.coodRegist;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      r = _ref[_i];
      this.drawPath(r);
    }
    this.drawLine();
    this.restoreDrawingSurface(this.itemSize);
    return this.endDraw(this.zindex);
  };

  ArrowItem.prototype.resetDrawPath = function() {
    this.coodHeadPart = [];
    this.coodLeftBodyPart = [];
    this.coodRightBodyPart = [];
    return this.drawCoodRegist = [];
  };

  ArrowItem.prototype.makeElement = function() {
    var drawingCanvas, drawingContext;
    $(ElementCode.get().createItemElement(this)).appendTo('#main-wrapper');
    $('#' + this.canvasElementId()).attr('width', $('#' + this.getElementId()).width());
    $('#' + this.canvasElementId()).attr('height', $('#' + this.getElementId()).height());
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    drawingContext.beginPath();
    drawCoodToCanvas.call(this, false, drawingContext);
    drawingContext.fillStyle = "#00008B";
    return drawingContext.fill();
  };

  ArrowItem.prototype.generateMinimumObject = function() {
    var obj;
    obj = {
      itemType: Constant.ItemType.ARROW,
      zindex: this.zindex,
      coodRegist: this.coodRegist
    };
    return obj;
  };

  ArrowItem.prototype.loadByMinimumObject = function(obj) {
    this.setMiniumObject(obj);
    this.reDraw();
    return this.saveObj(Constant.ItemActionType.MAKE);
  };

  ArrowItem.prototype.setMiniumObject = function(obj) {
    this.zindex = obj.zindex;
    return this.coodRegist = obj.coodRegist;
  };

  ArrowItem.prototype.actorScrollEvent = function(x, y) {
    var r, _i, _len, _ref;
    if (this.scrollValue == null) {
      console.log('scroll init');
      this.saveDrawingSurface();
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
    console.log("scrollY: " + this.scrollValue);
    this.resetDrawPath();
    this.restoreDrawingSurface(this.actorSize);
    _ref = this.coodRegist.slice(0, this.scrollValue);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      r = _ref[_i];
      this.drawPath(r);
    }
    drawingContext.beginPath();
    drawCoodToCanvas.call(this, true);
    drawingContext.fillStyle = "#00008B";
    drawingContext.fill();
    if (this.scrollValue >= this.coodRegist.length - 1) {
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
    if (beforeLoc.x < cood.x) {
      x = 1;
    } else if (beforeLoc.x === cood.x) {
      x = 0;
    } else {
      x = -1;
    }
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
      x: Math.cos(sita) * (HEADER_WIDTH + ARROW_WIDTH) / 2.0 + rightCood.x,
      y: Math.sin(sita) * (HEADER_WIDTH + ARROW_WIDTH) / 2.0 + rightCood.y
    };
    sitaRight = sita + Math.PI;
    rightTop = {
      x: Math.cos(sitaRight) * (HEADER_WIDTH - ARROW_WIDTH) / 2.0 + rightCood.x,
      y: Math.sin(sitaRight) * (HEADER_WIDTH - ARROW_WIDTH) / 2.0 + rightCood.y
    };
    sitaTop = sita + Math.PI / 2.0;
    mid = {
      x: (leftCood.x + rightCood.x) / 2.0,
      y: (leftCood.y + rightCood.y) / 2.0
    };
    top = {
      x: Math.cos(sitaTop) * HEADER_HEIGHT + mid.x,
      y: Math.sin(sitaTop) * HEADER_HEIGHT + mid.y
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
      x: -(Math.sin(rad) * ARROW_HALF_WIDTH) + locTail.x,
      y: Math.cos(rad) * ARROW_HALF_WIDTH + locTail.y
    });
    return this.coodLeftBodyPart.push({
      x: Math.sin(rad) * ARROW_HALF_WIDTH + locTail.x,
      y: -(Math.cos(rad) * ARROW_HALF_WIDTH) + locTail.y
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
      leftX = parseInt(Math.cos(rad + Math.PI) * ARROW_HALF_WIDTH + center.x);
      leftY = parseInt(Math.sin(rad + Math.PI) * ARROW_HALF_WIDTH + center.y);
      rightX = parseInt(Math.cos(rad) * ARROW_HALF_WIDTH + center.x);
      rightY = parseInt(Math.sin(rad) * ARROW_HALF_WIDTH + center.y);
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

  drawCoodToCanvas = function(isBaseCanvas, dc) {
    var drawingContext, i, marginX, marginY, _i, _j, _k, _ref, _ref1, _ref2;
    if (dc == null) {
      dc = null;
    }
    if (isBaseCanvas) {
      drawingContext = window.drawingContext;
      marginX = 0;
      marginY = 0;
    } else if (dc !== null) {
      drawingContext = dc;
      marginX = this.itemSize.x;
      marginY = this.itemSize.y;
    }
    if (this.coodLeftBodyPart.length <= 0 || this.coodRightBodyPart.length <= 0) {
      return;
    }
    drawingContext.moveTo(this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1].x - marginX, this.coodLeftBodyPart[this.coodLeftBodyPart.length - 1].y - marginY);
    if (this.coodLeftBodyPart.length >= 2) {
      for (i = _i = _ref = this.coodLeftBodyPart.length - 2; _ref <= 0 ? _i <= 0 : _i >= 0; i = _ref <= 0 ? ++_i : --_i) {
        drawingContext.lineTo(this.coodLeftBodyPart[i].x - marginX, this.coodLeftBodyPart[i].y - marginY);
      }
    }
    for (i = _j = 0, _ref1 = this.coodRightBodyPart.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
      drawingContext.lineTo(this.coodRightBodyPart[i].x - marginX, this.coodRightBodyPart[i].y - marginY);
    }
    for (i = _k = 0, _ref2 = this.coodHeadPart.length - 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; i = 0 <= _ref2 ? ++_k : --_k) {
      drawingContext.lineTo(this.coodHeadPart[i].x - marginX, this.coodHeadPart[i].y - marginY);
    }
    return drawingContext.closePath();
  };

  clearArrow = function() {
    return this.restoreDrawingSurface(this.itemSize);
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
      minX = cood.x - PADDING_SIZE;
      minX = minX < 0 ? 0 : minX;
      minY = cood.y - PADDING_SIZE;
      minY = minY < 0 ? 0 : minY;
      maxX = cood.x + PADDING_SIZE;
      maxX = maxX > drawingCanvas.width ? drawingCanvas.width : maxX;
      maxY = cood.y + PADDING_SIZE;
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

})(ItemBase);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList.arrowInit == null)) {
  window.itemInitFuncList.arrowInit = function() {};
}

//# sourceMappingURL=arrow.js.map
