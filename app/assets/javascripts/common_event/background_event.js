// Generated by CoffeeScript 1.9.2
var BackgroundEvent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

BackgroundEvent = (function(superClass) {
  extend(BackgroundEvent, superClass);

  function BackgroundEvent() {
    return BackgroundEvent.__super__.constructor.apply(this, arguments);
  }

  BackgroundEvent.EVENT_ID = '1';

  BackgroundEvent.prototype.willChapter = function(methodName) {
    var b, bColor, bColors, bPer, bp, cColor, cColors, g, gPer, gp, i, index, j, k, l, len, len1, r, rPer, ref, rgb, rp, scrollEnd, scrollLength, scrollStart, val;
    BackgroundEvent.__super__.willChapter.call(this);
    if (methodName === 'changeBackgroundColor') {
      this.scrollEvents = [];
      bColor = this.timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEBackgroundColorChange.BASE_COLOR];
      cColor = this.timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEBackgroundColorChange.CHANGE_COLOR];
      scrollStart = parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]);
      scrollEnd = parseInt(this.timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]);
      bColors = bColor.replace('rgb', '').replace('(', '').replace(')', '').split(',');
      for (index = j = 0, len = bColors.length; j < len; index = ++j) {
        val = bColors[index];
        bColors[index] = parseInt(val);
      }
      cColors = cColor.replace('rgb', '').replace('(', '').replace(')', '').split(',');
      for (index = k = 0, len1 = cColors.length; k < len1; index = ++k) {
        val = cColors[index];
        cColors[index] = parseInt(val);
      }
      scrollLength = scrollEnd - scrollStart;
      rPer = (cColors[0] - bColors[0]) / scrollLength;
      gPer = (cColors[1] - bColors[1]) / scrollLength;
      bPer = (cColors[2] - bColors[2]) / scrollLength;
      rp = rPer;
      gp = gPer;
      bp = bPer;
      for (i = l = 0, ref = scrollLength; 0 <= ref ? l <= ref : l >= ref; i = 0 <= ref ? ++l : --l) {
        r = parseInt(bColors[0] + rp);
        g = parseInt(bColors[1] + gp);
        b = parseInt(bColors[2] + bp);
        rgb = "rgb(" + r + "," + g + "," + b + ")";
        this.scrollEvents[i] = rgb;
        rp += rPer;
        gp += gPer;
        bp += bPer;
      }
      return this.targetBackground = $('#main-wrapper');
    }
  };

  BackgroundEvent.prototype.changeBackgroundColor = function(scrollValue) {
    return this.targetBackground.css('backgroundColor', this.scrollEvents[scrollValue]);
  };

  BackgroundEvent.prototype.finishedScroll = function(methodName, scrollValue) {
    if (methodName === 'changeBackgroundColor') {
      return scrollValue >= this.scrollLength() - 1;
    }
    return false;
  };

  return BackgroundEvent;

})(CommonEvent);

setClassToMap(true, BackgroundEvent.EVENT_ID, BackgroundEvent);

//# sourceMappingURL=background_event.js.map
