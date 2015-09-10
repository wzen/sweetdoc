// Generated by CoffeeScript 1.9.2
var RunCommon;

RunCommon = (function() {
  function RunCommon() {}

  RunCommon.RUN_CSS = constant.ElementAttribute.RUN_CSS;

  RunCommon.initView = function() {
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width());
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height());
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
    scrollInside.width(window.scrollViewSize);
    scrollInside.height(window.scrollViewSize);
    scrollInsideCover.width(window.scrollViewSize);
    scrollInsideCover.height(window.scrollViewSize);
    scrollHandle.width(window.scrollViewSize);
    scrollHandle.height(window.scrollViewSize);
    scrollContents.scrollLeft(scrollInside.width() * 0.5);
    scrollContents.scrollTop(scrollInside.height() * 0.5);
    scrollHandleWrapper.scrollLeft(scrollHandle.width() * 0.5);
    return scrollHandleWrapper.scrollTop(scrollHandle.height() * 0.5);
  };

  RunCommon.updateMainViewSize = function() {
    var padding;
    padding = 5 * 2;
    $('#main').height($('#contents').height() - $("#" + Navbar.NAVBAR_ROOT).height() - padding);
    return window.scrollContentsSize = {
      width: window.scrollContents.width(),
      height: window.scrollContents.height()
    };
  };

  RunCommon.resizeMainContainerEvent = function() {
    this.updateMainViewSize();
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width());
    return $(window.drawingCanvas).attr('height', window.canvasWrapper.height());
  };

  RunCommon.initResize = function() {
    return $(window).resize(function() {
      return RunCommon.resizeMainContainerEvent();
    });
  };

  RunCommon.initEventAction = function() {
    var eventPageValueList, i, j, page, pageCount, pageList, ref;
    pageCount = PageValue.getPageCount();
    pageList = new Array(pageCount);
    for (i = j = 1, ref = pageCount; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
      eventPageValueList = PageValue.getEventPageValueSortedListByNum(i);
      page = null;
      if ((eventPageValueList != null) && eventPageValueList.length > 0) {
        page = new Page(eventPageValueList);
      }
      pageList[i - 1] = page;
    }
    Navbar.setPageMax(pageCount);
    window.eventAction = new EventAction(pageList, PageValue.getPageNum() - 1);
    return window.eventAction.start();
  };

  RunCommon.initHandleScrollPoint = function() {
    scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * 0.5);
    return scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * 0.5);
  };

  RunCommon.setupScrollEvent = function() {
    var lastLeft, lastTop, stopTimer;
    lastLeft = scrollHandleWrapper.scrollLeft();
    lastTop = scrollHandleWrapper.scrollTop();
    stopTimer = null;
    return scrollHandleWrapper.scroll(function(e) {
      var distX, distY, x, y;
      e.preventDefault();
      if (!RunCommon.enabledScroll()) {
        return;
      }
      x = $(this).scrollLeft();
      y = $(this).scrollTop();
      if (stopTimer !== null) {
        clearTimeout(stopTimer);
      }
      stopTimer = setTimeout((function(_this) {
        return function() {
          RunCommon.initHandleScrollPoint();
          lastLeft = $(_this).scrollLeft();
          lastTop = $(_this).scrollTop();
          clearTimeout(stopTimer);
          return stopTimer = null;
        };
      })(this), 100);
      distX = x - lastLeft;
      distY = y - lastTop;
      lastLeft = x;
      lastTop = y;
      return window.eventAction.thisPage().handleScrollEvent(distX, distY);
    });
  };

  RunCommon.enabledScroll = function() {
    var ret;
    ret = false;
    if ((window.eventAction != null) && (window.eventAction.thisPage() != null) && (window.eventAction.thisPage().finishedAllChapters || ((window.eventAction.thisPage().thisChapter() != null) && window.eventAction.thisPage().isScrollChapter()))) {
      ret = true;
    }
    return ret;
  };

  RunCommon.createCssElement = function(pageNum) {
    var cssEmt, cssId;
    cssId = this.RUN_CSS.replace('@pagenum', pageNum);
    cssEmt = $("#" + cssId);
    if ((cssEmt == null) || cssEmt.length === 0) {
      $("<div id='" + cssId + "'></div>").appendTo(window.cssCode);
      cssEmt = $("#" + cssId);
    }
    return cssEmt.html(PageValue.itemCssOnPage(pageNum));
  };

  RunCommon.loadPagingPageValue = function(firstPageNum, lastPageNum, callback, forceUpdate) {
    var className, i, j, ref, ref1, section, targetPages;
    if (callback == null) {
      callback = null;
    }
    if (forceUpdate == null) {
      forceUpdate = false;
    }
    targetPages = [];
    for (i = j = ref = firstPageNum, ref1 = lastPageNum; ref <= ref1 ? j <= ref1 : j >= ref1; i = ref <= ref1 ? ++j : --j) {
      if (forceUpdate) {
        targetPages.push(i);
      } else {
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', i);
        section = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
        if ((section == null) || section.length === 0) {
          targetPages.push(i);
        }
      }
    }
    if (targetPages.length === 0) {
      if (callback != null) {
        callback();
      }
      return;
    }
    return $.ajax({
      url: "/run/paging",
      type: "POST",
      dataType: "json",
      data: {
        targetPages: targetPages
      },
      success: function(data) {
        var k, ref2, ref3, v;
        if (data.instance_pagevalue_hash !== null) {
          ref2 = data.instance_pagevalue_hash;
          for (k in ref2) {
            v = ref2[k];
            PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v);
          }
        }
        if (data.event_pagevalue_hash !== null) {
          ref3 = data.event_pagevalue_hash;
          for (k in ref3) {
            v = ref3[k];
            PageValue.setEventPageValue(PageValue.Key.E_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v);
          }
        }
        if (callback != null) {
          return callback();
        }
      },
      error: function(data) {}
    });
  };

  RunCommon.initMainContainer = function() {
    CommonVar.runCommonVar();
    this.initView();
    this.initHandleScrollPoint();
    this.initResize();
    this.setupScrollEvent();
    return Navbar.initRunNavbar();
  };

  return RunCommon;

})();

//# sourceMappingURL=run_common.js.map
