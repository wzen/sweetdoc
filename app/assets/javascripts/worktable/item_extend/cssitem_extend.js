// Generated by CoffeeScript 1.9.2
var WorkTableCssItemExtend;

WorkTableCssItemExtend = {
  draw: function(cood) {
    if (this.itemSize !== null) {
      this.restoreDrawingSurface(this.itemSize);
    }
    this.itemSize = {
      x: null,
      y: null,
      w: null,
      h: null
    };
    this.itemSize.w = Math.abs(cood.x - this.moveLoc.x);
    this.itemSize.h = Math.abs(cood.y - this.moveLoc.y);
    if (cood.x > this.moveLoc.x) {
      this.itemSize.x = this.moveLoc.x;
    } else {
      this.itemSize.x = cood.x;
    }
    if (cood.y > this.moveLoc.y) {
      this.itemSize.y = this.moveLoc.y;
    } else {
      this.itemSize.y = cood.y;
    }
    return drawingContext.strokeRect(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h);
  },
  endDraw: function(zindex, show) {
    if (show == null) {
      show = true;
    }
    this.zindex = zindex;
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    this.applyDefaultDesign();
    this.makeCss(true);
    this.drawAndMakeConfigsAndWritePageValue(show);
    return true;
  },
  applyDesignStyleChange: function(designKeyName, value, doStyleSave) {
    var cssCodeElement;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    cssCodeElement = $('.' + designKeyName + '_value', this.cssCode);
    cssCodeElement.html(value);
    return this.applyDesignChange(doStyleSave);
  },
  applyGradientStyleChange: function(index, designKeyName, value, doStyleSave) {
    var position;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    position = $('.design_bg_color' + (index + 2) + '_position', this.cssCode);
    position.html(("0" + value).slice(-2));
    return this.applyDesignStyleChange(designKeyName, value, doStyleSave);
  },
  applyGradientDegChange: function(designKeyName, value, doStyleSave) {
    var webkitDeg, webkitValueElement;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    webkitDeg = {
      0: 'left top, left bottom',
      45: 'right top, left bottom',
      90: 'right top, left top',
      135: 'right bottom, left top',
      180: 'left bottom, left top',
      225: 'left bottom, right top',
      270: 'left top, right top',
      315: 'left top, right bottom'
    };
    webkitValueElement = $('.' + className + '_value_webkit', this.cssCode);
    webkitValueElement.html(webkitDeg[ui.value]);
    return this.applyDesignStyleChange(designKeyName, value, doStyleSave);
  },
  applyGradientStepChange: function(target, doStyleSave) {
    var className, i, j, mh, mozCache, mozFlag, stepValue, webkitCache, webkitFlag, wh;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    this.changeGradientShow(target);
    stepValue = parseInt($(target).val());
    for (i = j = 2; j <= 4; i = ++j) {
      className = 'design_bg_color' + i;
      mozFlag = $("." + className + "_moz_flag", this.cssRoot);
      mozCache = $("." + className + "_moz_cache", this.cssRoot);
      webkitFlag = $("." + className + "_webkit_flag", this.cssRoot);
      webkitCache = $("." + className + "_webkit_cache", this.cssRoot);
      if (i > stepValue - 1) {
        mh = mozFlag.html();
        if (mh.length > 0) {
          mozCache.html(mh);
        }
        wh = webkitFlag.html();
        if (wh.length > 0) {
          webkitCache.html(wh);
        }
        $(mozFlag).empty();
        $(webkitFlag).empty();
      } else {
        mozFlag.html(mozCache.html());
        webkitFlag.html(webkitCache.html());
      }
    }
    return this.applyDesignChange(doStyleSave);
  },
  applyColorChangeByPicker: function(designKeyName, value, doStyleSave) {
    var codeEmt;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    codeEmt = $("." + designKeyName + "_value", this.cssCode);
    codeEmt.text(value);
    return this.applyDesignChange(doStyleSave);
  }
};

//# sourceMappingURL=cssitem_extend.js.map
