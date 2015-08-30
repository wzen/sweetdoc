// Generated by CoffeeScript 1.9.2
var initEventAction, initHandleScrollPoint, initResize, initView, setupScrollEvent;

window.runPage = true;

initView = function() {
  var is_reload;
  $('#contents').css('height', $('#contents').height() - $("#" + Constant.ElementAttribute.NAVBAR_ROOT).height());
  $('#canvas_container').attr('width', $('#canvas_wrapper').width());
  $('#canvas_container').attr('height', $('#canvas_wrapper').height());
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
  scrollHandleWrapper.scrollTop(scrollHandle.height() * 0.5);
  is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD);
  if (is_reload != null) {
    return LocalStorage.loadValueForRun();
  } else {
    return LocalStorage.saveValueForRun();
  }
};

initResize = function(wrap, scrollWrapper) {
  var resizeTimer;
  resizeTimer = false;
  return $(window).resize(function() {
    if (resizeTimer !== false) {
      clearTimeout(resizeTimer);
    }
    return resizeTimer = setTimeout(function() {
      var h;
      h = $(window).height();
      mainWrapper.height(h);
      return scrollWrapper.height(h);
    }, 200);
  });
};

initEventAction = function() {
  var chapterList, eventList, eventObjList, eventPageValueList, i, j, page, pageCount, pageList, ref;
  pageCount = PageValue.getPageCount();
  pageList = [];
  for (i = j = 1, ref = pageCount; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
    eventPageValueList = PageValue.getEventPageValueSortedListByNum(i);
    chapterList = [];
    if (eventPageValueList != null) {
      eventObjList = [];
      eventList = [];
      $.each(eventPageValueList, function(idx, obj) {
        var beforeEvent, chapter, classMapId, event, id, isCommonEvent, parallel;
        isCommonEvent = obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT];
        id = obj[EventPageValueBase.PageValueKey.ID];
        classMapId = isCommonEvent ? obj[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] : obj[EventPageValueBase.PageValueKey.ITEM_ID];
        event = Common.getInstanceFromMap(isCommonEvent, id, classMapId);
        event.initWithEvent(obj);
        eventObjList.push(event);
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
              eventObjList: eventObjList,
              eventList: eventList,
              num: idx
            });
          } else {
            chapter = new ScrollChapter({
              eventObjList: eventObjList,
              eventList: eventList,
              num: idx
            });
          }
          chapterList.push(chapter);
          eventObjList = [];
          eventList = [];
          if (!window.firstItemFocused && !obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
            chapter.focusToActorIfNeed(true);
            window.firstItemFocused = true;
          }
        }
        return true;
      });
    }
    page = new Page(chapterList);
    pageList.push(page);
  }
  Navbar.setPageMax(pageCount);
  window.eventAction = new EventAction(pageList, window.pageNum - 1);
  return window.eventAction.start();
};

initHandleScrollPoint = function() {
  scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * 0.5);
  return scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * 0.5);
};

setupScrollEvent = function() {
  var lastLeft, lastTop, scrollFinished, stopTimer;
  lastLeft = scrollHandleWrapper.scrollLeft();
  lastTop = scrollHandleWrapper.scrollTop();
  stopTimer = null;
  scrollHandleWrapper.scroll(function() {
    var distX, distY, x, y;
    if (eventAction.thisPage().finishedAllChapters || !eventAction.thisPage().isScrollChapter()) {
      return;
    }
    x = $(this).scrollLeft();
    y = $(this).scrollTop();
    if (stopTimer !== null) {
      clearTimeout(stopTimer);
    }
    stopTimer = setTimeout((function(_this) {
      return function() {
        initHandleScrollPoint();
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
    console.log('distX:' + distX + ' distY:' + distY);
    return eventAction.thisPage().handleScrollEvent(distX, distY);
  });
  return scrollFinished = function() {};
};

$(function() {
  runCommonVar();
  initView();
  initHandleScrollPoint();
  initEventAction();
  setupScrollEvent();
  Navbar.initRunNavbar();
  return $('#sup_css').html(PageValue.getEventPageValue(PageValue.Key.eventCss()));
});

//# sourceMappingURL=run.js.map
