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

  EventAction.prototype.thisPageNum = function() {
    return this.pageIndex + 1;
  };

  EventAction.prototype.start = function() {
    RunCommon.setPageNum(this.thisPageNum());
    RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, window.eventAction.thisPageNum());
    RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM);
    return this.thisPage().willPage((function(_this) {
      return function() {
        return _this.thisPage().start();
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
      return this.finishAllPages();
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
      return this.changePaging(beforePageIndex, this.pageIndex, callback);
    } else {
      return this.thisPage().willPage((function(_this) {
        return function() {
          return _this.thisPage().start();
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
          Common.createdMainContainerIfNeeded(afterPageNum, beforePageNum > afterPageNum);
          pageFlip = new PageFlip(beforePageNum, afterPageNum);
          RunCommon.initMainContainer();
          PageValue.adjustInstanceAndEventOnPage();
          _after = function() {
            this.thisPage().start();
            if (this.thisPage().thisChapter() != null) {
              this.thisPage().thisChapter().disableEventHandle();
            }
            return pageFlip.startRender((function(_this) {
              return function() {
                var className, section;
                _this.nextPageIndex = null;
                className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
                section = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
                section.hide();
                Common.removeAllItem(beforePageNum);
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

  EventAction.prototype.rewindAllPages = function() {
    var i, j, page, ref;
    for (i = j = ref = this.pageList.length - 1; j >= 0; i = j += -1) {
      page = this.pageList[i];
      page.resetAllChapters();
    }
    this.pageIndex = 0;
    RunCommon.setPageNum(this.thisPageNum());
    this.finishedAllPages = false;
    return this.start();
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
