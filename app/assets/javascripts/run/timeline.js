// Generated by CoffeeScript 1.9.2
var TimeLine;

TimeLine = (function() {
  function TimeLine(chapterList) {
    this.chapterList = chapterList;
    this.chapterIndex = 0;
    this.finished = false;
  }

  TimeLine.prototype.start = function() {
    return this.chapterList[this.chapterIndex].willChapter();
  };

  TimeLine.prototype.nextChapter = function() {
    this.chapterList[this.chapterIndex].didChapter();
    this.chapterIndex += 1;
    if (this.chapterList.length <= this.chapterIndex) {
      return this.finishTimeline();
    } else {
      return this.chapterList[this.chapterIndex].willChapter();
    }
  };

  TimeLine.prototype.backChapter = function() {
    this.resetChapter(this.chapterIndex);
    if (this.chapterIndex > 0) {
      this.chapterIndex -= 1;
      return this.chapterList[this.chapterIndex].focusToActor();
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

  TimeLine.prototype.handleClickEvent = function(e) {
    if (!this.finished) {
      return this.chapterList[this.chapterIndex].clickEvent(e);
    }
  };

  TimeLine.prototype.finishTimeline = function() {
    this.finished = true;
    return console.log('Finish!');
  };

  return TimeLine;

})();

//# sourceMappingURL=timeline.js.map
