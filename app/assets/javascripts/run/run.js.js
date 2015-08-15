// Generated by CoffeeScript 1.9.2
var initHandleScrollPoint, initResize, initTimeline, initView, setupScrollEvent;

window.runPage = true;

initView = function() {
  var is_reload, ls;
  $('#contents').css('height', $('#contents').height() - $('#nav').height());
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
  is_reload = PageValue.getPageValue(Constant.PageValueKey.IS_RUNWINDOW_RELOAD);
  ls = new LocalStorage(LocalStorage.Key.RUN_TIMELINE_PAGEVALUES);
  if (is_reload != null) {
    return ls.loadTimelinePageValueFromStorage();
  } else {
    return ls.saveTimelinePageValueToStorage();
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

initTimeline = function() {
  var chapterList, eventList, tList, timelineList;
  timelineList = PageValue.getTimelinePageValueSortedListByNum();
  chapterList = [];
  eventList = [];
  tList = [];
  $.each(timelineList, function(idx, obj) {
    var beforeTimeline, chapter, event, parallel;
    event = Common.getInstanceFromMap(obj);
    event.initWithEvent(obj);
    eventList.push(event);
    tList.push(obj);
    parallel = false;
    if (idx < timelineList.length - 1) {
      beforeTimeline = timelineList[idx + 1];
      if (beforeTimeline[TimelineEvent.PageValueKey.IS_PARALLEL]) {
        parallel = true;
      }
    }
    if (!parallel) {
      chapter = null;
      if (obj[TimelineEvent.PageValueKey.ACTIONTYPE] === Constant.ActionEventHandleType.CLICK) {
        chapter = new ClickChapter({
          eventList: eventList,
          timelineEventList: tList
        });
      } else {
        chapter = new ScrollChapter({
          eventList: eventList,
          timelineEventList: tList
        });
      }
      chapterList.push(chapter);
      eventList = [];
      tList = [];
      if (!window.firstItemFocused && !obj[TimelineEvent.PageValueKey.IS_COMMON_EVENT]) {
        chapter.focusToActorIfNeed(true);
        window.firstItemFocused = true;
      }
    }
    return true;
  });
  window.timeLine = new TimeLine(chapterList);
  return window.timeLine.start();
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
    if (timeLine.finished || !timeLine.isScrollChapter()) {
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
    return timeLine.handleScrollEvent(distX, distY);
  });
  return scrollFinished = function() {};
};

$(function() {
  runCommonVar();
  initView();
  initHandleScrollPoint();
  initTimeline();
  setupScrollEvent();
  return $('#sup_css').html(PageValue.getTimelinePageValue(Constant.PageValueKey.TE_CSS));
});

//# sourceMappingURL=run.js.js.map
