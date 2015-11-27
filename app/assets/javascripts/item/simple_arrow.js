// Generated by CoffeeScript 1.9.2
var SimpleArrowItem,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

SimpleArrowItem = (function(superClass) {
  var ARROW_HALF_WIDTH, ARROW_WIDTH, HEADER_HEIGHT, HEADER_WIDTH, PADDING_SIZE, calDrection, calTrianglePath, clearArrow, coodLength, coodLog, drawCoodToCanvas, updateArrowRect;

  extend(SimpleArrowItem, superClass);

  SimpleArrowItem.IDENTITY = "simplearrow";

  if (window.loadedItemId != null) {
    SimpleArrowItem.ITEM_ID = window.loadedItemId;
  }

  ARROW_WIDTH = 30;

  ARROW_HALF_WIDTH = ARROW_WIDTH / 2.0;

  HEADER_WIDTH = 50;

  HEADER_HEIGHT = 50;

  PADDING_SIZE = HEADER_WIDTH + 5;

  function SimpleArrowItem(cood) {
    if (cood == null) {
      cood = null;
    }
    SimpleArrowItem.__super__.constructor.call(this, cood);
    this.direction = {
      x: 0,
      y: 0
    };
    this.coodRegist = [];
    this._coodHeadPart = [];
  }

  SimpleArrowItem.prototype.canvasElementId = function() {
    return this.id + '_canvas';
  };

  SimpleArrowItem.prototype.draw = function(moveCood) {
    var b, mid;
    calDrection.call(this, this.coodRegist[this.coodRegist.length - 1], moveCood);
    if (this.coodRegist.length >= 2) {
      b = this.coodRegist[this.coodRegist.length - 2];
      mid = {
        x: (b.x + moveCood.x) / 2.0,
        y: (b.y + moveCood.y) / 2.0
      };
      this.coodRegist[this.coodRegist - 1] = mid;
    }
    this.coodRegist.push(moveCood);
    updateArrowRect.call(this, moveCood);
    clearArrow.call(this);
    calTrianglePath.call(this);
    return drawCoodToCanvas.call(this, window.drawingContext);
  };

  SimpleArrowItem.prototype.endDraw = function(zindex, show, callback) {
    var j, k, l, len, len1, ref, ref1;
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (!SimpleArrowItem.__super__.endDraw.call(this, zindex)) {
      return false;
    }
    ref = this.coodRegist;
    for (j = 0, len = ref.length; j < len; j++) {
      l = ref[j];
      l.x -= this.itemSize.x;
      l.y -= this.itemSize.y;
    }
    ref1 = this._coodHeadPart;
    for (k = 0, len1 = ref1.length; k < len1; k++) {
      l = ref1[k];
      l.x -= this.itemSize.x;
      l.y -= this.itemSize.y;
    }
    this.drawAndMakeConfigs(show);
    return true;
  };

  SimpleArrowItem.prototype.reDraw = function(show) {
    if (show == null) {
      show = true;
    }
    return this.drawAndMakeConfigs(show);
  };

  SimpleArrowItem.prototype.drawAndMakeConfigs = function(show) {
    var drawingCanvas, drawingContext;
    if (show == null) {
      show = true;
    }
    $(ElementCode.get().createItemElement(this)).appendTo(window.scrollInside);
    $('#' + this.canvasElementId()).attr('width', $('#' + this.id).width());
    $('#' + this.canvasElementId()).attr('height', $('#' + this.id).height());
    this.setupDragAndResizeEvents();
    if (show) {
      drawingCanvas = document.getElementById(this.canvasElementId());
      drawingContext = drawingCanvas.getContext('2d');
      return drawCoodToCanvas.call(this, drawingContext);
    }
  };

  SimpleArrowItem.prototype.getMinimumObject = function() {
    var obj;
    obj = {
      itemId: this.constructor.ITEM_ID,
      a: this.itemSize,
      b: this.zindex,
      c: this.coodRegist,
      d: this._coodHeadPart
    };
    return obj;
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

  calTrianglePath = function() {
    var lastBodyCood, leftTop, r, rightTop, sita, sitaLeft, sitaMid, sitaRight, top;
    if (this.coodRegist.length < 4) {
      return null;
    }
    lastBodyCood = this.coodRegist[this.coodRegist.length - 1];
    r = {
      x: this.coodRegist[this.coodRegist.length - 4].x - lastBodyCood.x,
      y: this.coodRegist[this.coodRegist.length - 4].y - lastBodyCood.y
    };
    sita = Math.atan2(r.y, r.x);
    sitaLeft = sita - Math.PI / 2.0;
    leftTop = {
      x: Math.cos(sitaLeft) * HEADER_WIDTH + lastBodyCood.x,
      y: Math.sin(sitaLeft) * HEADER_WIDTH + lastBodyCood.y
    };
    sitaRight = sita + Math.PI / 2.0;
    rightTop = {
      x: Math.cos(sitaRight) * HEADER_WIDTH + lastBodyCood.x,
      y: Math.sin(sitaRight) * HEADER_WIDTH + lastBodyCood.y
    };
    sitaMid = sita + Math.PI;
    top = {
      x: Math.cos(sitaMid) * HEADER_HEIGHT + lastBodyCood.x,
      y: Math.sin(sitaMid) * HEADER_HEIGHT + lastBodyCood.y
    };
    return this._coodHeadPart = [rightTop, top, leftTop];
  };

  drawCoodToCanvas = function(drawingContext) {
    var i, j, k, ref, ref1;
    if (this.coodRegist.length < 2) {
      return;
    }
    drawingContext.beginPath();
    drawingContext.lineWidth = ARROW_WIDTH;
    drawingContext.strokeStyle = 'red';
    drawingContext.lineCap = 'round';
    drawingContext.lineJoin = 'round';
    drawingContext.moveTo(this.coodRegist[0].x, this.coodRegist[0].y);
    for (i = j = 1, ref = this.coodRegist.length - 1; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
      drawingContext.lineTo(this.coodRegist[i].x, this.coodRegist[i].y);
    }
    drawingContext.stroke();
    if (this._coodHeadPart.length < 2) {
      return;
    }
    drawingContext.beginPath();
    drawingContext.fillStyle = 'red';
    drawingContext.lineWidth = 1.0;
    drawingContext.moveTo(this._coodHeadPart[0].x, this._coodHeadPart[0].y);
    for (i = k = 1, ref1 = this._coodHeadPart.length - 1; 1 <= ref1 ? k <= ref1 : k >= ref1; i = 1 <= ref1 ? ++k : --k) {
      drawingContext.lineTo(this._coodHeadPart[i].x, this._coodHeadPart[i].y);
    }
    drawingContext.closePath();
    drawingContext.fill();
    return drawingContext.stroke();
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

  return SimpleArrowItem;

})(ItemBase);

//# sourceMappingURL=simple_arrow.js.map
