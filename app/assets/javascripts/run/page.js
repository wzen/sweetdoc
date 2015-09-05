// Generated by CoffeeScript 1.9.2
var Page;

Page = (function() {
  Page.PAGE_CHANGE_SCROLL_DIST = 50;

  function Page(eventPageValueList) {
    var eventList;
    this.chapterList = [];
    if (eventPageValueList != null) {
      eventList = [];
      $.each(eventPageValueList, (function(_this) {
        return function(idx, obj) {
          var beforeEvent, chapter, parallel;
          eventList.push(obj);
          parallel = false;
          if (idx < eventPageValueList.length - 1) {
            beforeEvent = eventPageValueList[idx + 1];
            if (beforeEvent[EventPageValueBase.PageValueKey.IS_PARALLEL]) {
              parallel = true;
            }
          }
          if (!parallel) {
            chapter = null;
            if (obj[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionEventHandleType.CLICK) {
              chapter = new ClickChapter({
                eventList: eventList,
                num: idx
              });
            } else {
              chapter = new ScrollChapter({
                eventList: eventList,
                num: idx
              });
            }
            _this.chapterList.push(chapter);
            eventList = [];
          }
          return true;
        };
      })(this));
    }
    this.chapterIndex = 0;
    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
  }

  Page.prototype.thisChapter = function() {
    return this.chapterList[this.chapterIndex];
  };

  Page.prototype.start = function() {
    Navbar.setChapterNum(this.chapterIndex + 1);
    this.sinkFrontAllChapterObj();
    return this.thisChapter().willChapter();
  };

  Page.prototype.nextChapterIfFinishedAllEvent = function() {
    if (this.thisChapter().finishedAllEvent()) {
      return this.nextChapter();
    }
  };

  Page.prototype.nextChapter = function() {
    this.thisChapter().didChapter();
    if (this.chapterList.length <= this.chapterIndex + 1) {
      return this.finishAllChapters();
    } else {
      this.chapterIndex += 1;
      Navbar.setChapterNum(this.chapterIndex + 1);
      return this.thisChapter().willChapter();
    }
  };

  Page.prototype.rewindChapter = function() {
    this.resetChapter(this.chapterIndex);
    if (!this.thisChapter().doMoveChapter) {
      if (this.chapterIndex > 0) {
        this.chapterIndex -= 1;
        this.resetChapter(this.chapterIndex);
        Navbar.setChapterNum(this.chapterIndex + 1);
      } else {
        window.eventAction.rewindPage();
        return;
      }
    }
    return this.thisChapter().willChapter();
  };

  Page.prototype.resetChapter = function(chapterIndex) {
    if (chapterIndex == null) {
      chapterIndex = this.chapterIndex;
    }
    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
    return this.chapterList[chapterIndex].resetAllEvents();
  };

  Page.prototype.rewindAllChapters = function() {
    var chapter, i, j, ref;
    for (i = j = ref = this.chapterList.length - 1; j >= 0; i = j += -1) {
      chapter = this.chapterList[i];
      chapter.resetAllEvents();
    }
    this.chapterIndex = 0;
    Navbar.setChapterNum(this.chapterIndex + 1);
    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
    return this.start();
  };

  Page.prototype.handleScrollEvent = function(x, y) {
    var stopTimer;
    if (!this.finishedAllChapters) {
      if (this.isScrollChapter()) {
        return this.thisChapter().scrollEvent(x, y);
      }
    } else {
      if (stopTimer !== null) {
        clearTimeout(stopTimer);
      }
      stopTimer = setTimeout((function(_this) {
        return function() {
          _this.finishedScrollDistSum = 0;
          clearTimeout(stopTimer);
          return stopTimer = null;
        };
      })(this), 200);
      this.finishedScrollDistSum += x + y;
      console.log('finishedScrollDistSum:' + this.finishedScrollDistSum);
      if (this.finishedScrollDistSum > Page.PAGE_CHANGE_SCROLL_DIST) {
        return window.eventAction.nextPageIfFinishedAllChapter();
      }
    }
  };

  Page.prototype.isScrollChapter = function() {
    return this.thisChapter().scrollEvent != null;
  };

  Page.prototype.sinkFrontAllChapterObj = function() {
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
    scrollContents.css('z-index', scrollViewSwitchZindex.off);
    return this.chapterList.forEach(function(chapter) {
      return chapter.sinkFrontAllObj();
    });
  };

  Page.prototype.willPage = function() {
    this.initChapterEvent();
    this.initFocus();
    this.resetAllChapters();
    Navbar.setChapterMax(this.chapterList.length);
    return LocalStorage.saveValueForRun();
  };

  Page.prototype.willPageFromRewind = function(beforeScrollWindowSize) {
    this.initChapterEvent();
    this.initFocus(false);
    this.forwardAllChapters();
    this.chapterList[this.chapterList.length - 1].resetAllEvents();
    Navbar.setChapterMax(this.chapterList.length);
    this.chapterIndex = this.chapterList.length - 1;
    this.resetChapter();
    return LocalStorage.saveValueForRun();
  };

  Page.prototype.didPage = function() {};

  Page.prototype.initChapterEvent = function() {
    var chapter, event, i, j, len, ref, results;
    ref = this.chapterList;
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      chapter = ref[j];
      results.push((function() {
        var k, ref1, results1;
        results1 = [];
        for (i = k = 0, ref1 = chapter.eventObjList.length - 1; 0 <= ref1 ? k <= ref1 : k >= ref1; i = 0 <= ref1 ? ++k : --k) {
          event = chapter.eventObjList[i];
          results1.push(event.initWithEvent(chapter.eventList[i]));
        }
        return results1;
      })());
    }
    return results;
  };

  Page.prototype.initFocus = function(focusToFirst) {
    var chapter, event, flg, i, j, k, l, len, len1, len2, m, ref, ref1, ref2, ref3;
    if (focusToFirst == null) {
      focusToFirst = true;
    }
    flg = false;
    if (focusToFirst) {
      ref = this.chapterList;
      for (j = 0, len = ref.length; j < len; j++) {
        chapter = ref[j];
        if (flg) {
          return false;
        }
        ref1 = chapter.eventList;
        for (k = 0, len1 = ref1.length; k < len1; k++) {
          event = ref1[k];
          if (flg) {
            return false;
          }
          if (!event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
            chapter.focusToActorIfNeed(true);
            flg = true;
          }
        }
      }
    } else {
      for (i = l = ref2 = this.chapterList.length - 1; l >= 0; i = l += -1) {
        chapter = this.chapterList[i];
        if (flg) {
          return false;
        }
        ref3 = chapter.eventList;
        for (m = 0, len2 = ref3.length; m < len2; m++) {
          event = ref3[m];
          if (flg) {
            return false;
          }
          if (!event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
            chapter.focusToActorIfNeed(true);
            flg = true;
          }
        }
      }
    }
  };

  Page.prototype.resetAllChapters = function() {
    return this.chapterList.forEach(function(chapter) {
      return chapter.resetAllEvents();
    });
  };

  Page.prototype.forwardAllChapters = function() {
    return this.chapterList.forEach(function(chapter) {
      return chapter.forwardAllEvents();
    });
  };

  Page.prototype.finishAllChapters = function() {
    this.finishedAllChapters = true;
    if (window.debug) {
      console.log('Finish All Chapters!');
    }
    return this.sinkFrontAllChapterObj();
  };

  return Page;

})();

//# sourceMappingURL=page.js.map