// Generated by CoffeeScript 1.9.2
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

  EventAction.prototype.start = function() {
    var pageNum;
    pageNum = this.pageIndex + 1;
    Navbar.setPageNum(pageNum);
    RunCommon.createCssElement(pageNum);
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
    var beforePageIndex, pageNum;
    if (callback == null) {
      callback = null;
    }
    this.thisPage().didPage();
    beforePageIndex = this.pageIndex;
    if (this.pageList.length <= this.pageIndex + 1) {
      return this.finishAllPages();
    } else {
      this.pageIndex += 1;
      pageNum = this.pageIndex + 1;
      Navbar.setPageNum(pageNum);
      PageValue.setPageNum(pageNum);
      return this.changePaging(beforePageIndex, this.pageIndex, callback);
    }
  };

  EventAction.prototype.rewindPage = function(callback) {
    var beforePageIndex, pageNum;
    if (callback == null) {
      callback = null;
    }
    beforePageIndex = this.pageIndex;
    if (this.pageIndex > 0) {
      this.pageIndex -= 1;
      pageNum = this.pageIndex + 1;
      Navbar.setPageNum(pageNum);
      PageValue.setPageNum(pageNum);
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
          var eventPageValueList, pageFlip;
          if (_this.thisPage() === null) {
            eventPageValueList = PageValue.getEventPageValueSortedListByNum(afterPageNum);
            _this.pageList[afterPageIndex] = new Page(eventPageValueList);
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
            _this.thisPage().willPage();
          }
          _this.thisPage().start();
          return pageFlip.startRender(function() {
            var className, section;
            className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
            section = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
            section.css('display', 'none');
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
    Navbar.setPageNum(this.pageIndex + 1);
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
