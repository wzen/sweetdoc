// Generated by CoffeeScript 1.8.0
var TimeLine;

TimeLine = (function() {
  function TimeLine(chapterList) {
    this.chapterList = chapterList;
    this.chapterIndex = 0;
    this.finished = false;
  }

  TimeLine.prototype.nextChapter = function() {
    this.chapterList[this.chapterIndex].settleChapter();
    this.chapterIndex += 1;
    if (this.chapterList.length <= this.chapterIndex) {
      return this.finishTimeline();
    }
  };

  TimeLine.prototype.backChapter = function() {
    this.resetChapter(this.chapterIndex);
    if (this.chapterIndex > 0) {
      return this.chapterIndex -= 1;
    }
  };

  TimeLine.prototype.resetChapter = function(chapterIndex) {
    return this.chapterList[chapterIndex].reset();
  };

  TimeLine.prototype.handleScrollEvent = function(x, y) {
    if (!this.finished) {
      return this.chapterList[this.chapterIndex].scrollEvent(x, y);
    }
  };

  TimeLine.prototype.handleClickEvent = function() {
    if (!this.finished) {
      return this.chapterList[this.chapterIndex].clickEvent(e);
    }
  };

  TimeLine.prototype.finishTimeline = function() {
    this.finished = true;
    return alert('Finish!');
  };

  return TimeLine;

})();

//# sourceMappingURL=time_line.js.map
