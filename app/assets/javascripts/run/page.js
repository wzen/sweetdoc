// Generated by CoffeeScript 1.9.2
var Page;

Page = (function() {
  function Page(eventPageValueArray) {
    var _setupChapterList, forkEventPageValueList, k, ref;
    _setupChapterList = function(eventPageValueList, chapterList) {
      var eventList;
      if (eventPageValueList != null) {
        eventList = [];
        return $.each(eventPageValueList, (function(_this) {
          return function(idx, obj) {
            var beforeEvent, chapter, sync;
            eventList.push(obj);
            sync = false;
            if (idx < eventPageValueList.length - 1) {
              beforeEvent = eventPageValueList[idx + 1];
              if (beforeEvent[EventPageValueBase.PageValueKey.IS_SYNC]) {
                sync = true;
              }
            }
            if (!sync) {
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
              chapterList.push(chapter);
              eventList = [];
            }
            return true;
          };
        })(this));
      }
    };
    this.forkChapterList = {};
    this.forkChapterIndex = {};
    ref = eventPageValueArray.forks;
    for (k in ref) {
      forkEventPageValueList = ref[k];
      this.forkChapterList[k] = [];
      this.forkChapterIndex[k] = 0;
      _setupChapterList.call(this, forkEventPageValueList, this.forkChapterList[k]);
    }
    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
  }

  Page.prototype.getForkChapterList = function() {
    var lastForkNum;
    lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum());
    if (lastForkNum != null) {
      return this.forkChapterList[lastForkNum];
    } else {
      return [];
    }
  };

  Page.prototype.getProgressChapterList = function() {
    var cIndex, chapter, j, l, len, len1, ref, ret, s, sIndex, stack;
    ret = [];
    stack = RunCommon.getForkStack(window.eventAction.thisPageNum());
    for (sIndex = j = 0, len = stack.length; j < len; sIndex = ++j) {
      s = stack[sIndex];
      ref = this.forkChapterList[s.forkNum];
      for (cIndex = l = 0, len1 = ref.length; l < len1; cIndex = ++l) {
        chapter = ref[cIndex];
        if ((stack[sIndex + 1] != null) && cIndex > stack[sIndex + 1].changedChapterIndex) {
          break;
        }
        ret.push(chapter);
      }
    }
    return ret;
  };

  Page.prototype.getAllChapterList = function() {
    var chapter, forkList, j, k, len, ref, ret;
    ret = [];
    ref = this.forkChapterList;
    for (k in ref) {
      forkList = ref[k];
      for (j = 0, len = forkList.length; j < len; j++) {
        chapter = forkList[j];
        ret.push(chapter);
      }
    }
    return ret;
  };

  Page.prototype.getChapterIndex = function() {
    var lastForkNum;
    lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum());
    if (lastForkNum != null) {
      return this.forkChapterIndex[lastForkNum];
    } else {
      return 0;
    }
  };

  Page.prototype.setChapterIndex = function(num) {
    var lastForkNum;
    lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum());
    if (lastForkNum != null) {
      return this.forkChapterIndex[lastForkNum] = num;
    }
  };

  Page.prototype.addChapterIndex = function(addNum) {
    var lastForkNum;
    lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum());
    if (lastForkNum != null) {
      return this.forkChapterIndex[lastForkNum] = this.forkChapterIndex[lastForkNum] + addNum;
    }
  };

  Page.prototype.thisChapter = function() {
    return this.getForkChapterList()[this.getChapterIndex()];
  };

  Page.prototype.thisChapterNum = function() {
    return this.getChapterIndex() + 1;
  };

  Page.prototype.start = function() {
    this.pagingGuide = new ArrowPagingGuide();
    Navbar.setChapterNum(this.thisChapterNum());
    this.floatPageScrollHandleCanvas();
    return this.thisChapter().willChapter();
  };

  Page.prototype.nextChapterIfFinishedAllEvent = function() {
    if ((this.thisChapter().finishedAllEvent == null) || this.thisChapter().finishedAllEvent()) {
      return this.nextChapter();
    }
  };

  Page.prototype.nextChapter = function() {
    if ((this.thisChapter().changeForkNum != null) && this.thisChapter().changeForkNum !== RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum())) {
      return this.switchFork();
    } else {
      return this.progressChapter();
    }
  };

  Page.prototype.progressChapter = function() {
    this.hideAllGuide();
    this.thisChapter().didChapter();
    if (this.getForkChapterList().length <= this.getChapterIndex() + 1) {
      return this.finishAllChapters();
    } else {
      this.addChapterIndex(1);
      Navbar.setChapterNum(this.thisChapterNum());
      return this.thisChapter().willChapter();
    }
  };

  Page.prototype.switchFork = function() {
    var nfn;
    this.hideAllGuide();
    this.thisChapter().didChapter();
    if (this.thisChapter().changeForkNum != null) {
      nfn = this.thisChapter().changeForkNum;
      if (RunCommon.addForkNumToStack(nfn, this.getChapterIndex(), window.eventAction.thisPageNum())) {
        Navbar.setForkNum(nfn);
      }
    }
    Navbar.setChapterNum(this.thisChapterNum());
    Navbar.setChapterMax(this.getForkChapterList().length);
    return this.thisChapter().willChapter();
  };

  Page.prototype.rewindChapter = function() {
    var lastForkObj, nfn, oneBeforeForkObj;
    this.hideAllGuide();
    this.resetChapter(this.getChapterIndex());
    if (!this.thisChapter().doMoveChapter) {
      if (this.getChapterIndex() > 0) {
        this.addChapterIndex(-1);
        this.resetChapter(this.getChapterIndex());
        Navbar.setChapterNum(this.thisChapterNum());
      } else {
        oneBeforeForkObj = RunCommon.getOneBeforeObjestFromStack(window.eventAction.thisPageNum());
        lastForkObj = RunCommon.getLastObjestFromStack(window.eventAction.thisPageNum());
        if (oneBeforeForkObj && oneBeforeForkObj.forkNum !== lastForkObj.forkNum) {
          RunCommon.popLastForkNumInStack(window.eventAction.thisPageNum());
          nfn = oneBeforeForkObj.forkNum;
          Navbar.setForkNum(nfn);
          this.setChapterIndex(lastForkObj.changedChapterIndex);
          this.resetChapter(this.getChapterIndex());
          Navbar.setChapterNum(this.thisChapterNum());
          Navbar.setChapterMax(this.getForkChapterList().length);
        } else {
          window.eventAction.rewindPage();
          return;
        }
      }
    }
    return this.thisChapter().willChapter();
  };

  Page.prototype.resetChapter = function(chapterIndex) {
    if (chapterIndex == null) {
      chapterIndex = this.getChapterIndex();
    }
    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
    return this.getForkChapterList()[chapterIndex].resetAllEvents();
  };

  Page.prototype.rewindAllChapters = function() {
    var chapter, i, j, ref;
    for (i = j = ref = this.getForkChapterList().length - 1; j >= 0; i = j += -1) {
      chapter = this.getForkChapterList()[i];
      chapter.resetAllEvents();
    }
    this.setChapterIndex(0);
    Navbar.setChapterNum(this.thisChapterNum());
    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
    return this.start();
  };

  Page.prototype.handleScrollEvent = function(x, y) {
    if (!this.finishedAllChapters) {
      if (this.isScrollChapter()) {
        return this.thisChapter().scrollEvent(x, y);
      }
    } else {
      if (window.eventAction.hasNextPage()) {
        if (this.pagingGuide != null) {
          return this.pagingGuide.scrollEvent(x, y);
        }
      }
    }
  };

  Page.prototype.isScrollChapter = function() {
    return this.thisChapter().scrollEvent != null;
  };

  Page.prototype.floatPageScrollHandleCanvas = function() {
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
    scrollContents.css('z-index', scrollViewSwitchZindex.off);
    return this.getForkChapterList().forEach(function(chapter) {
      return chapter.floatScrollHandleCanvas();
    });
  };

  Page.prototype.willPage = function() {
    this.initChapterEvent();
    this.initFocus();
    this.resetAllChapters();
    Navbar.setChapterMax(this.getForkChapterList().length);
    return LocalStorage.saveAllPageValues();
  };

  Page.prototype.willPageFromRewind = function(beforeScrollWindowSize) {
    this.initChapterEvent();
    this.initFocus(false);
    this.forwardProgressChapters();
    this.getForkChapterList()[this.getForkChapterList().length - 1].resetAllEvents();
    Navbar.setChapterMax(this.getForkChapterList().length);
    this.setChapterIndex(this.getForkChapterList().length - 1);
    Navbar.setForkNum(RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum()));
    this.resetChapter();
    return LocalStorage.saveAllPageValues();
  };

  Page.prototype.didPage = function() {};

  Page.prototype.initChapterEvent = function() {
    var chapter, event, i, j, len, ref, results;
    ref = this.getProgressChapterList();
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      chapter = ref[j];
      results.push((function() {
        var l, ref1, results1;
        results1 = [];
        for (i = l = 0, ref1 = chapter.eventObjList.length - 1; 0 <= ref1 ? l <= ref1 : l >= ref1; i = 0 <= ref1 ? ++l : --l) {
          event = chapter.eventObjList[i];
          results1.push(event.initEvent(chapter.eventList[i]));
        }
        return results1;
      })());
    }
    return results;
  };

  Page.prototype.initFocus = function(focusToFirst) {
    var chapter, event, flg, i, j, l, len, len1, len2, m, n, ref, ref1, ref2, ref3;
    if (focusToFirst == null) {
      focusToFirst = true;
    }
    flg = false;
    if (focusToFirst) {
      ref = this.getForkChapterList();
      for (j = 0, len = ref.length; j < len; j++) {
        chapter = ref[j];
        if (flg) {
          return false;
        }
        ref1 = chapter.eventList;
        for (l = 0, len1 = ref1.length; l < len1; l++) {
          event = ref1[l];
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
      for (i = m = ref2 = this.getForkChapterList().length - 1; m >= 0; i = m += -1) {
        chapter = this.getForkChapterList()[i];
        if (flg) {
          return false;
        }
        ref3 = chapter.eventList;
        for (n = 0, len2 = ref3.length; n < len2; n++) {
          event = ref3[n];
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
    return this.getAllChapterList().forEach(function(chapter) {
      return chapter.resetAllEvents();
    });
  };

  Page.prototype.forwardProgressChapters = function() {
    return this.getProgressChapterList().forEach(function(chapter) {
      return chapter.forwardAllEvents();
    });
  };

  Page.prototype.hideAllGuide = function() {
    return this.getForkChapterList().forEach(function(chapter) {
      return chapter.hideGuide();
    });
  };

  Page.prototype.finishAllChapters = function() {
    this.finishedAllChapters = true;
    if (window.debug) {
      console.log('Finish All Chapters!');
    }
    if (window.eventAction.hasNextPage()) {
      return this.floatPageScrollHandleCanvas();
    } else {
      return window.eventAction.finishAllPages();
    }
  };

  return Page;

})();

//# sourceMappingURL=page.js.map
