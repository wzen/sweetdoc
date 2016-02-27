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
              if (obj[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.CLICK) {
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
    if (window.runDebug) {
      console.log('Page Start');
    }
    this.pagingGuide = new ArrowPagingGuide();
    RunCommon.setChapterNum(this.thisChapterNum());
    this.floatPageScrollHandleCanvas();
    if (this.thisChapter() != null) {
      return this.thisChapter().willChapter();
    } else {
      return this.finishAllChapters();
    }
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
      RunCommon.setChapterNum(this.thisChapterNum());
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
        RunCommon.setForkNum(nfn);
      }
    }
    RunCommon.setChapterNum(this.thisChapterNum());
    RunCommon.setChapterMax(this.getForkChapterList().length);
    return this.thisChapter().willChapter();
  };

  Page.prototype.rewindChapter = function() {
    if (window.runDebug) {
      console.log('Page rewindChapter');
    }
    if ((window.runningOperation != null) && window.runningOperation) {
      return;
    }
    window.runningOperation = true;
    this.hideAllGuide();
    return this.resetChapter(this.getChapterIndex(), (function(_this) {
      return function() {
        var beforePage, lastForkObj, nfn, oneBeforeForkObj;
        if (!_this.thisChapter().doMoveChapter) {
          if (_this.getChapterIndex() > 0) {
            _this.addChapterIndex(-1);
            return _this.resetChapter(_this.getChapterIndex(), function() {
              RunCommon.setChapterNum(_this.thisChapterNum());
              _this.thisChapter().willChapter();
              FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0);
              return window.runningOperation = false;
            });
          } else {
            oneBeforeForkObj = RunCommon.getOneBeforeObjestFromStack(window.eventAction.thisPageNum());
            lastForkObj = RunCommon.getLastObjestFromStack(window.eventAction.thisPageNum());
            if (oneBeforeForkObj && oneBeforeForkObj.forkNum !== lastForkObj.forkNum) {
              RunCommon.popLastForkNumInStack(window.eventAction.thisPageNum());
              nfn = oneBeforeForkObj.forkNum;
              RunCommon.setForkNum(nfn);
              _this.setChapterIndex(lastForkObj.changedChapterIndex);
              return _this.resetChapter(_this.getChapterIndex(), function() {
                RunCommon.setChapterNum(_this.thisChapterNum());
                RunCommon.setChapterMax(_this.getForkChapterList().length);
                _this.thisChapter().willChapter();
                FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0);
                return window.runningOperation = false;
              });
            } else {
              beforePage = window.eventAction.beforePage();
              if (beforePage != null) {
                return window.eventAction.rewindPage(function() {
                  FloatView.show('Rewind previous page', FloatView.Type.REWIND_CHAPTER, 1.0);
                  return window.runningOperation = false;
                });
              } else {
                _this.thisChapter().willChapter();
                FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0);
                return window.runningOperation = false;
              }
            }
          }
        } else {
          _this.thisChapter().willChapter();
          FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0);
          return window.runningOperation = false;
        }
      };
    })(this));
  };

  Page.prototype.resetChapter = function(chapterIndex, callback) {
    if (chapterIndex == null) {
      chapterIndex = this.getChapterIndex();
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Page resetChapter');
    }
    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
    return this.getForkChapterList()[chapterIndex].resetAllEvents(callback);
  };

  Page.prototype.rewindAllChapters = function(rewindPageIfNeed, callback) {
    var _callback, beforePage, count, i, j, ref, results;
    if (rewindPageIfNeed == null) {
      rewindPageIfNeed = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Page rewindAllChapters');
    }
    if (rewindPageIfNeed && (window.runningOperation != null) && window.runningOperation) {
      return;
    }
    window.runningOperation = true;
    this.hideAllGuide();
    if (!this.thisChapter().doMoveChapter && rewindPageIfNeed) {
      beforePage = window.eventAction.beforePage();
      if (beforePage != null) {
        return window.eventAction.rewindPage((function(_this) {
          return function() {
            return beforePage.rewindAllChapters(false, function() {
              FloatView.show('Rewind previous page', FloatView.Type.REWIND_CHAPTER, 1.0);
              window.runningOperation = false;
              if (callback != null) {
                return callback();
              }
            });
          };
        })(this));
      } else {
        window.runningOperation = false;
        if (callback != null) {
          return callback();
        }
      }
    } else {
      _callback = function() {
        this.setChapterIndex(0);
        RunCommon.setChapterNum(this.thisChapterNum());
        this.finishedAllChapters = false;
        this.finishedScrollDistSum = 0;
        this.start();
        if (rewindPageIfNeed) {
          FloatView.show('Rewind all events', FloatView.Type.REWIND_ALL_CHAPTER, 1.0);
          window.runningOperation = false;
        }
        if (callback != null) {
          return callback();
        }
      };
      if (this.getForkChapterList().length === 0) {
        return _callback.call(this);
      } else {
        count = 0;
        results = [];
        for (i = j = ref = this.getForkChapterList().length - 1; j >= 0; i = j += -1) {
          this.setChapterIndex(i);
          results.push(this.resetChapter(i, (function(_this) {
            return function() {
              count += 1;
              if (count >= _this.getForkChapterList().length) {
                return _callback.call(_this);
              }
            };
          })(this)));
        }
        return results;
      }
    }
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
    if (window.runDebug) {
      console.log('Page floatPageScrollHandleCanvas');
    }
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
    scrollContents.css('z-index', scrollViewSwitchZindex.off);
    return this.getForkChapterList().forEach(function(chapter) {
      return chapter.enableScrollHandleViewEvent();
    });
  };

  Page.prototype.willPage = function(callback) {
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Page willPage');
    }
    this.initChapterEvent();
    return this.resetAllChapters((function(_this) {
      return function() {
        return _this.initItemDrawingInPage(function() {
          _this.initFocus(true);
          RunCommon.setChapterMax(_this.getForkChapterList().length);
          LocalStorage.saveAllPageValues();
          if (callback != null) {
            return callback();
          }
        });
      };
    })(this));
  };

  Page.prototype.willPageFromRewind = function(callback) {
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Page willPageFromRewind');
    }
    this.initChapterEvent();
    return this.initItemDrawingInPage((function(_this) {
      return function() {
        _this.initFocus(false);
        _this.forwardProgressChapters();
        return _this.getForkChapterList()[_this.getForkChapterList().length - 1].resetAllEvents(function() {
          RunCommon.setChapterMax(_this.getForkChapterList().length);
          _this.setChapterIndex(_this.getForkChapterList().length - 1);
          RunCommon.setForkNum(RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum()));
          return _this.resetChapter(_this.getChapterIndex(), function() {
            LocalStorage.saveAllPageValues();
            if (callback != null) {
              return callback();
            }
          });
        });
      };
    })(this));
  };

  Page.prototype.didPage = function() {
    if (window.runDebug) {
      console.log('Page didPage');
    }
    return RunCommon.saveFootprint();
  };

  Page.prototype.initChapterEvent = function() {
    var chapter, event, i, j, len, ref, results;
    ref = this.getAllChapterList();
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

  Page.prototype.initItemDrawingInPage = function(callback) {
    var finishCount, j, len, obj, objs, results;
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Page initItemDrawingInPage');
    }
    objs = Common.itemInstancesInPage(PageValue.getPageNum(), true, true);
    if (objs.length === 0) {
      if (callback != null) {
        callback();
      }
      return;
    }
    finishCount = 0;
    results = [];
    for (j = 0, len = objs.length; j < len; j++) {
      obj = objs[j];
      results.push(obj.refreshIfItemNotExist(obj.visible, (function(_this) {
        return function(obj) {
          if (obj.firstFocus) {
            window.disabledEventHandler = true;
            Common.focusToTarget(obj.getJQueryElement(), function() {
              return window.disabledEventHandler = false;
            }, true);
          }
          finishCount += 1;
          if (finishCount >= objs.length) {
            if (callback != null) {
              return callback();
            }
          }
        };
      })(this)));
    }
    return results;
  };

  Page.prototype.resetAllChapters = function(callback) {
    var count, max;
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('Page resetAllChapters');
    }
    count = 0;
    max = this.getAllChapterList().length;
    if (max === 0) {
      if (callback != null) {
        return callback();
      }
    } else {
      return this.getAllChapterList().forEach(function(chapter) {
        return chapter.resetAllEvents((function(_this) {
          return function() {
            count += 1;
            if (count >= max) {
              if (callback != null) {
                return callback();
              }
            }
          };
        })(this));
      });
    }
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

  Page.prototype.finishAllChapters = function(nextPageIndex) {
    if (nextPageIndex == null) {
      nextPageIndex = null;
    }
    if (window.runDebug) {
      console.log('Page finishAllChapters');
      if (nextPageIndex != null) {
        console.log('nextPageIndex: ' + nextPageIndex);
      }
    }
    if (nextPageIndex != null) {
      window.eventAction.nextPageIndex = nextPageIndex;
    }
    this.finishedAllChapters = true;
    if (nextPageIndex || window.eventAction.hasNextPage()) {
      return this.floatPageScrollHandleCanvas();
    } else {
      window.eventAction.finishAllPages();
      return FloatView.show('Finished all', FloatView.Type.FINISH, 3.0);
    }
  };

  Page.prototype.shutdown = function() {
    return this.hideAllGuide();
  };

  return Page;

})();

//# sourceMappingURL=page.js.map
