/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class ScrollOperationGuide {
  static initClass() {
    let Cls = (this.Type = class Type {
      static initClass() {
        this.PAGING = 0;
        this.REWIND = 1;
      }
    });
    Cls.initClass();
    Cls = (this.Direction = class Direction {
      static initClass() {
        this.FORWORD = 0;
        this.REVERSE = 1;
      }
    });
    Cls.initClass();
  }

  constructor(type, direction) {
    this.type = type;
    if(direction == null) {
      direction = this.constructor.Direction.FORWORD;
    }
    this.direction = direction;
    if($('#main').hasClass('fullscreen')) {
      this.iconWidth = 30;
    } else {
      this.iconWidth = 50;
    }
    if(this.type === this.constructor.Type.PAGING) {
      this.runScrollDist = 50;
    } else if(this.type === this.constructor.Type.REWIND) {
      this.runScrollDist = 80;
    }
    this.perWidth = this.iconWidth / this.runScrollDist;
    this.finishedScrollDistSum = 0;
    this.stopTimer = null;
    this.intervalTimer = null;
    this.runningTargetId = null;
    this.wrapper = $('#pages .operation_guide_wrapper:first');
    if(this.type === this.constructor.Type.PAGING) {
      this.emt = $('#pages .paging_parent:first');
    } else if(this.type === this.constructor.Type.REWIND) {
      this.emt = $('#pages .rewind_parent:first');
    }
  }

  // スクロールイベント
  // @param [Int] x X軸の動作値
  // @param [Int] y Y軸の動作値
  scrollEvent(x, y, target = null) {
    return this.scrollEventByDistSum(x + y, target);
  }

  // スクロールイベント
  // @param [Int] x X軸の動作値
  // @param [Int] y Y軸の動作値
  scrollEventByDistSum(distSum, target = null) {
    if((target != null) && (this.runningTargetId != null) && (this.runningTargetId !== target.id)) {
      return;
    }
    if(target != null) {
      this.runningTargetId = target.id;
    }
    this.wrapper.show();
    $('#pages .operation_guide').hide();
    this.emt.show();
    if(this.intervalTimer !== null) {
      clearInterval(this.intervalTimer);
      this.intervalTimer = null;
    }
    if(this.stopTimer !== null) {
      clearTimeout(this.stopTimer);
      this.stopTimer = null;
    }
    this.stopTimer = setTimeout(() => {
        clearTimeout(this.stopTimer);
        this.stopTimer = null;
        return this.intervalTimer = setInterval(() => {
            // Width短くする
            this.finishedScrollDistSum -= parseInt(this.runScrollDist * 0.2);
            this.update(this.finishedScrollDistSum * this.perWidth);
            if(this.finishedScrollDistSum <= 0) {
              return this.clear();
            }
          }
          , 10);
      }
      , 200);
    this.finishedScrollDistSum += distSum;
    this.update(this.finishedScrollDistSum * this.perWidth);
    //if window.debug
    //console.log('finishedScrollDistSum:' + @finishedScrollDistSum)
    if(this.finishedScrollDistSum > this.runScrollDist) {
      if(this.intervalTimer !== null) {
        clearInterval(this.intervalTimer);
        this.intervalTimer = null;
      }
      if(this.stopTimer !== null) {
        clearTimeout(this.stopTimer);
        this.stopTimer = null;
      }
      if(this.type === this.constructor.Type.PAGING) {
        // 次のページに移動
        return window.eventAction.nextPageIfFinishedAllChapter(() => {
          return this.wrapper.hide();
        });
      } else if(this.type === this.constructor.Type.REWIND) {
        // チャプター戻し
        return window.eventAction.thisPage().rewindChapter(() => {
          return this.clear();
        });
      }
    }
  }

  update(value) {
    const v = value + 'px';
    return this.emt.css('width', v);
  }

  clear(target = null) {
    if((target != null) && (this.runningTargetId != null) && (this.runningTargetId !== target.id)) {
      return;
    }
    this.update(0);
    this.wrapper.hide();
    this.finishedScrollDistSum = 0;
    this.runningTargetId = null;
    if(this.stopTimer !== null) {
      clearTimeout(this.stopTimer);
      this.stopTimer = null;
    }
    if(this.intervalTimer !== null) {
      clearInterval(this.intervalTimer);
      return this.intervalTimer = null;
    }
  }
}

ScrollOperationGuide.initClass();

