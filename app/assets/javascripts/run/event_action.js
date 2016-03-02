// Generated by CoffeeScript 1.9.2
var EventAction;

EventAction = (function() {
  function EventAction(pageList, pageIndex) {
    this.pageList = pageList;
    this.pageIndex = pageIndex;
    this.finishedAllPages = false;
    this.nextPageIndex = null;
  }

  EventAction.prototype.thisPage = function() {
    return this.pageList[this.pageIndex];
  };

  EventAction.prototype.beforePage = function() {
    if (this.pageIndex > 0) {
      return this.pageList[this.pageIndex - 1];
    } else {
      return null;
    }
  };

  EventAction.prototype.thisPageNum = function() {
    return this.pageIndex + 1;
  };

  EventAction.prototype.start = function(callback) {
    if (callback == null) {
      callback = null;
    }
    RunCommon.setPageNum(this.thisPageNum());
    RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, window.eventAction.thisPageNum());
    RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM);
    return this.thisPage().willPage((function(_this) {
      return function() {
        _this.thisPage().start();
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  EventAction.prototype.shutdown = function() {
    if (this.thisPage() != null) {
      return this.thisPage().shutdown();
    }
  };

  EventAction.prototype.nextPageIfFinishedAllChapter = function(callback) {
    if (callback == null) {
      callback = null;
    }
    if (this.thisPage().finishedAllChapters) {
      return this.nextPage(callback);
    }
  };

  EventAction.prototype.nextPage = function(callback) {
    var beforePageIndex;
    if (callback == null) {
      callback = null;
    }
    this.thisPage().didPage();
    beforePageIndex = this.pageIndex;
    if (this.pageList.length <= this.pageIndex + 1) {
      this.finishAllPages();
      if (callback != null) {
        return callback();
      }
    } else {
      if (this.nextPageIndex != null) {
        this.pageIndex = this.nextPageIndex;
      } else {
        this.pageIndex += 1;
      }
      RunCommon.setPageNum(this.thisPageNum());
      PageValue.setPageNum(this.thisPageNum());
      return this.changePaging(beforePageIndex, this.pageIndex, callback);
    }
  };

  EventAction.prototype.rewindPage = function(callback) {
    var beforePageIndex;
    if (callback == null) {
      callback = null;
    }
    beforePageIndex = this.pageIndex;
    if (this.pageIndex > 0) {
      this.pageIndex -= 1;
      RunCommon.setPageNum(this.thisPageNum());
      PageValue.setPageNum(this.thisPageNum());
      this.changePaging(beforePageIndex, this.pageIndex, callback);
      return this.thisPage().thisChapter().doMoveChapter = true;
    } else {
      return this.thisPage().willPage((function(_this) {
        return function() {
          _this.thisPage().start();
          if (callback != null) {
            return callback();
          }
        };
      })(this));
    }
  };

  EventAction.prototype.changePaging = function(beforePageIndex, afterPageIndex, callback) {
    var afterPageNum, beforePageNum, doLoadFootprint;
    if (callback == null) {
      callback = null;
    }
    Common.hideModalView(true);
    Common.showModalFlashMessage('Page changing');
    beforePageNum = beforePageIndex + 1;
    afterPageNum = afterPageIndex + 1;
    if (window.debug) {
      console.log('[changePaging] beforePageNum:' + beforePageNum);
      console.log('[changePaging] afterPageNum:' + afterPageNum);
    }
    doLoadFootprint = beforePageNum > afterPageNum;
    return RunCommon.loadPagingPageValue(afterPageNum, doLoadFootprint, (function(_this) {
      return function() {
        return Common.loadJsFromInstancePageValue(function() {
          var _after, forkEventPageValueList, i, j, pageFlip, ref;
          Common.createdMainContainerIfNeeded(afterPageNum, beforePageNum > afterPageNum);
          pageFlip = new PageFlip(beforePageNum, afterPageNum);
          RunCommon.initMainContainer();
          if (_this.thisPage() === null) {
            forkEventPageValueList = {};
            for (i = j = 0, ref = PageValue.getForkCount(); 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
              forkEventPageValueList[i] = PageValue.getEventPageValueSortedListByNum(i, afterPageNum);
            }
            _this.pageList[afterPageIndex] = new Page({
              forks: forkEventPageValueList
            });
            if (window.debug) {
              console.log('[nextPage] created page instance');
            }
          }
          PageValue.adjustInstanceAndEventOnPage();
          _after = function() {
            this.thisPage().start();
            if (this.thisPage().thisChapter() != null) {
              this.thisPage().thisChapter().disableEventHandle();
            }
            if (beforePageNum < afterPageNum) {
              Common.initScrollContentsPosition();
            }
            return pageFlip.startRender((function(_this) {
              return function() {
                var className, section;
                _this.nextPageIndex = null;
                className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
                section = $("#" + constant.Paging.ROOT_ID).find("." + className + ":first");
                section.hide();
                Common.removeAllItem(beforePageNum, false);
                $("#" + (RunCommon.RUN_CSS.replace('@pagenum', beforePageNum))).remove();
                if (_this.thisPage().thisChapter() != null) {
                  _this.thisPage().thisChapter().enableEventHandle();
                }
                Common.hideModalView();
                if (callback != null) {
                  return callback();
                }
              };
            })(this));
          };
          if (beforePageNum > afterPageNum) {
            return _this.thisPage().willPageFromRewind(function() {
              return _after.call(_this);
            });
          } else {
            RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, afterPageNum);
            RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM);
            return _this.thisPage().willPage(function() {
              return _after.call(_this);
            });
          }
        });
      };
    })(this));
  };

  EventAction.prototype.rewindAllPages = function(callback) {
    var count, i, j, page, ref, results;
    if (callback == null) {
      callback = null;
    }
    count = 0;
    results = [];
    for (i = j = ref = this.pageList.length - 1; j >= 0; i = j += -1) {
      page = this.pageList[i];
      results.push(page.resetAllChapters((function(_this) {
        return function() {
          count += 1;
          if (count >= _this.pageList.length) {
            _this.pageIndex = 0;
            RunCommon.setPageNum(_this.thisPageNum());
            _this.finishedAllPages = false;
            return _this.start(callback);
          }
        };
      })(this)));
    }
    return results;
  };

  EventAction.prototype.hasNextPage = function() {
    return this.pageIndex < this.pageList.length - 1;
  };

  EventAction.prototype.finishAllPages = function() {
    this.finishedAllPages = true;
    if (window.debug) {
      return console.log('Finish All Pages!!!');
    }
  };

  return EventAction;

})();

//# sourceMappingURL=event_action.js.map
