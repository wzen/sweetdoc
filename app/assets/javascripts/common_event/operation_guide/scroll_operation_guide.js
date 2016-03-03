// Generated by CoffeeScript 1.9.2
var ScrollOperationGuide;

ScrollOperationGuide = (function() {
  ScrollOperationGuide.Type = (function() {
    function Type() {}

    Type.PAGING = 0;

    Type.REWIND = 1;

    return Type;

  })();

  ScrollOperationGuide.Direction = (function() {
    function Direction() {}

    Direction.FORWORD = 0;

    Direction.REVERSE = 1;

    return Direction;

  })();

  function ScrollOperationGuide(type, direction) {
    this.type = type;
    this.direction = direction != null ? direction : this.constructor.Direction.FORWORD;
    if ($('#main').hasClass('fullscreen')) {
      this.iconWidth = 30;
    } else {
      this.iconWidth = 50;
    }
    if (this.type === this.constructor.Type.PAGING) {
      this.runScrollDist = 50;
    } else if (this.type === this.constructor.Type.REWIND) {
      this.runScrollDist = 120;
    }
    this.perWidth = this.iconWidth / this.runScrollDist;
    this.finishedScrollDistSum = 0;
    this.stopTimer = null;
    this.intervalTimer = null;
    this.runningTargetId = null;
    this.wrapper = $('#pages .operation_guide_wrapper:first');
    if (this.type === this.constructor.Type.PAGING) {
      this.emt = $('#pages .paging_parent:first');
    } else if (this.type === this.constructor.Type.REWIND) {
      this.emt = $('#pages .rewind_parent:first');
    }
  }

  ScrollOperationGuide.prototype.scrollEvent = function(x, y, target) {
    if (target == null) {
      target = null;
    }
    return this.scrollEventByDistSum(x + y, target);
  };

  ScrollOperationGuide.prototype.scrollEventByDistSum = function(distSum, target) {
    if (target == null) {
      target = null;
    }
    if ((target != null) && (this.runningTargetId != null) && this.runningTargetId !== target.id) {
      return;
    }
    if (target != null) {
      this.runningTargetId = target.id;
    }
    this.wrapper.show();
    $('#pages .operation_guide').hide();
    this.emt.show();
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
          _this.update(_this.finishedScrollDistSum * _this.perWidth);
          if (_this.finishedScrollDistSum <= 0) {
            _this.clear();
            return _this.wrapper.hide();
          }
        }, 10);
      };
    })(this), 200);
    this.finishedScrollDistSum += distSum;
    this.update(this.finishedScrollDistSum * this.perWidth);
    if (this.finishedScrollDistSum > this.runScrollDist) {
      if (this.intervalTimer !== null) {
        clearInterval(this.intervalTimer);
        this.intervalTimer = null;
      }
      if (this.stopTimer !== null) {
        clearTimeout(this.stopTimer);
        this.stopTimer = null;
      }
      if (this.type === this.constructor.Type.PAGING) {
        return window.eventAction.nextPageIfFinishedAllChapter((function(_this) {
          return function() {
            return _this.wrapper.hide();
          };
        })(this));
      } else if (this.type === this.constructor.Type.REWIND) {
        return window.eventAction.thisPage().rewindChapter((function(_this) {
          return function() {
            return _this.clear();
          };
        })(this));
      }
    }
  };

  ScrollOperationGuide.prototype.update = function(value) {
    var v;
    v = value + 'px';
    return this.emt.css('width', v);
  };

  ScrollOperationGuide.prototype.clear = function(target) {
    if (target == null) {
      target = null;
    }
    if ((target != null) && (this.runningTargetId != null) && this.runningTargetId !== target.id) {
      return;
    }
    this.update(0);
    this.finishedScrollDistSum = 0;
    this.runningTargetId = null;
    if (this.stopTimer !== null) {
      clearTimeout(this.stopTimer);
      this.stopTimer = null;
    }
    if (this.intervalTimer !== null) {
      clearInterval(this.intervalTimer);
      return this.intervalTimer = null;
    }
  };

  return ScrollOperationGuide;

})();

//# sourceMappingURL=scroll_operation_guide.js.map
