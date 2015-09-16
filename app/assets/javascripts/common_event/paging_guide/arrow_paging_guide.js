// Generated by CoffeeScript 1.9.2
var ArrowPagingGuide;

ArrowPagingGuide = (function() {
  var _moveBackground, _showCanvas;

  ArrowPagingGuide.PAGE_CHANGE_SCROLL_DIST = 50;

  ArrowPagingGuide.CANVAS_WIDTH = 100;

  ArrowPagingGuide.CANVAS_HEIGHT = 70;

  function ArrowPagingGuide() {
    this.finishedScrollDistSum = 0;
    this.stopTimer = null;
    this.intervalTimer = null;
  }

  _showCanvas = function() {
    var emt, left, temp, top;
    emt = $('#arrow_paging_guide');
    if ((emt == null) || emt.length === 0) {
      top = window.mainWrapper.height() - ArrowPagingGuide.CANVAS_HEIGHT;
      left = window.mainWrapper.width() - ArrowPagingGuide.CANVAS_WIDTH;
      temp = "<div id='arrow_paging_guide' style='position: absolute;top:" + top + "px;left:" + left + "px;z-index:" + (Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT - 1)) + ";display:none;'>\n\n<canvas id='arrow_paging_guide_canvas' class='canvas' width='" + ArrowPagingGuide.CANVAS_WIDTH + "' height='" + ArrowPagingGuide.CANVAS_HEIGHT + "' style='width:100%;height:100%'></canvas>\n</div>";
      window.mainWrapper.append(temp);
      this.canvas = document.getElementById('arrow_paging_guide_canvas');
      this.context = this.canvas.getContext('2d');
    }
    return $('#arrow_paging_guide').css('display', 'block');
  };

  _moveBackground = function() {
    var x;
    x = ArrowPagingGuide.CANVAS_WIDTH * this.finishedScrollDistSum / ArrowPagingGuide.PAGE_CHANGE_SCROLL_DIST;
    this.context.globalCompositeOperation = "source-over";
    this.context.beginPath();
    this.context.moveTo(0, 20);
    this.context.lineTo(60, 20);
    this.context.lineTo(60, 0);
    this.context.lineTo(100, 35);
    this.context.lineTo(60, 70);
    this.context.lineTo(60, 50);
    this.context.lineTo(0, 50);
    this.context.lineTo(0, 20);
    this.context.fill();
    this.context.globalCompositeOperation = "source-in";
    this.context.beginPath();
    this.context.fillStyle = 'blue';
    this.context.moveTo(0, 0);
    this.context.lineTo(x, 0);
    this.context.lineTo(x, ArrowPagingGuide.CANVAS_HEIGHT);
    this.context.lineTo(0, ArrowPagingGuide.CANVAS_HEIGHT);
    this.context.lineTo(0, 0);
    return this.context.fill();
  };

  ArrowPagingGuide.prototype.scrollEvent = function(x, y) {
    _showCanvas.call(this);
    if (this.intervalTimer !== null) {
      clearInterval(this.intervalTimer);
      this.intervalTimer = null;
    }
    if (this.stopTimer !== null) {
      clearTimeout(this.stopTimer);
      this.stopTimer = null;
    }
    this.stopTimer = setTimeout((function(_this) {
      return function() {
        clearTimeout(_this.stopTimer);
        _this.stopTimer = null;
        return _this.intervalTimer = setInterval(function() {
          _this.finishedScrollDistSum -= 3;
          _moveBackground.call(_this);
          if (_this.finishedScrollDistSum <= 0) {
            _this.finishedScrollDistSum = 0;
            clearInterval(_this.intervalTimer);
            _this.intervalTimer = null;
            return $('#arrow_paging_guide').css('display', 'none');
          }
        }, 10);
      };
    })(this), 200);
    this.finishedScrollDistSum += x + y;
    _moveBackground.call(this);
    if (this.finishedScrollDistSum > this.constructor.PAGE_CHANGE_SCROLL_DIST) {
      if (this.intervalTimer !== null) {
        clearInterval(this.intervalTimer);
        this.intervalTimer = null;
      }
      if (this.stopTimer !== null) {
        clearTimeout(this.stopTimer);
        this.stopTimer = null;
      }
      return window.eventAction.nextPageIfFinishedAllChapter(function() {
        return $('#arrow_paging_guide').remove();
      });
    }
  };

  return ArrowPagingGuide;

})();

//# sourceMappingURL=arrow_paging_guide.js.map