// Generated by CoffeeScript 1.10.0
var EventAction;

EventAction = (function() {
  function EventAction(pageList, pageIndex) {
    this.pageList = pageList;
    this.pageIndex = pageIndex;
    this.finishedAllPages = false;
  }

  EventAction.prototype.thisPage = function() {
    return this.pageList[this.pageIndex];
  };

  EventAction.prototype.thisPageNum = function() {
    return this.pageIndex + 1;
  };

  EventAction.prototype.start = function() {
    Navbar.setPageNum(this.thisPageNum());
    RunCommon.createCssElement(this.thisPageNum());
    RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, window.eventAction.thisPageNum());
    Navbar.setForkNum(PageValue.Key.EF_MASTER_FORKNUM);
    this.thisPage().willPage();
    return this.thisPage().start();
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
      this.pageIndex += 1;
      Navbar.setPageNum(this.thisPageNum());
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
      Navbar.setPageNum(this.thisPageNum());
      PageValue.setPageNum(this.thisPageNum());
      return this.changePaging(beforePageIndex, this.pageIndex, callback);
    } else {
      this.thisPage().willPage();
      return this.thisPage().start();
    }
  };

  EventAction.prototype.changePaging = function(beforePageIndex, afterPageIndex, callback) {
    var afterPageNum, beforePageNum;
    if (callback == null) {
      callback = null;
    }
    beforePageNum = beforePageIndex + 1;
    afterPageNum = afterPageIndex + 1;
    if (window.debug) {
      console.log('[changePaging] beforePageNum:' + beforePageNum);
      console.log('[changePaging] afterPageNum:' + afterPageNum);
    }
    return RunCommon.loadPagingPageValue(afterPageNum, (function(_this) {
      return function() {
        return Common.loadJsFromInstancePageValue(function() {
          var forkEventPageValueList, i, j, pageFlip, ref;
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
          RunCommon.createCssElement(afterPageNum);
          if (beforePageNum > afterPageNum) {
            _this.thisPage().willPageFromRewind();
          } else {
            RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, afterPageNum);
            Navbar.setForkNum(PageValue.Key.EF_MASTER_FORKNUM);
            _this.thisPage().willPage();
          }
          _this.thisPage().start();
          return pageFlip.startRender(function() {
            var className, section;
            className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
            section = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
            section.hide();
            Common.removeAllItem(beforePageNum);
            $("#" + (RunCommon.RUN_CSS.replace('@pagenum', beforePageNum))).remove();
            if (callback != null) {
              return callback();
            }
          });
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
    Navbar.setPageNum(this.thisPageNum());
    this.finishedAllPages = false;
    return this.start();
  };

  EventAction.prototype.hasNextPage = function() {
    return this.pageIndex < this.pageList.length - 1;
  };

  EventAction.prototype.finishAllPages = function() {
    this.finishedAllPages = true;
    return console.log('Finish All Pages!!!');
  };

  return EventAction;

})();

//# sourceMappingURL=event_action.js.map
