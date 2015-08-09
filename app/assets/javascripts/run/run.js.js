// Generated by CoffeeScript 1.9.2
var initHandleScrollPoint, initResize, initTimeline, initView, loadPageValueFromStorage, savePageValueToStorage, setupScrollEvent;

window.runPage = true;

initView = function() {
  var is_reload;
  $('#contents').css('height', $('#contents').height() - $('#nav').height());
  $('#canvas_container').attr('width', $('#canvas_wrapper').width());
  $('#canvas_container').attr('height', $('#canvas_wrapper').height());
  scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
  scrollInside.width(scrollContents.width() * (scrollViewMag + 1));
  scrollInside.height(scrollContents.height() * (scrollViewMag + 1));
  scrollInsideCover.width(scrollContents.width() * (scrollViewMag + 1));
  scrollInsideCover.height(scrollContents.height() * (scrollViewMag + 1));
  scrollHandle.width(scrollHandleWrapper.width() * (scrollViewMag + 1));
  scrollHandle.height(scrollHandleWrapper.height() * (scrollViewMag + 1));
  scrollContents.scrollLeft(scrollContents.width() * (scrollViewMag * 0.5));
  scrollContents.scrollTop(scrollContents.height() * (scrollViewMag * 0.5));
  scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * (scrollViewMag * 0.5));
  scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * (scrollViewMag * 0.5));
  is_reload = getPageValue(Constant.PageValueKey.IS_RUNWINDOW_RELOAD);
  if (is_reload != null) {
    return loadPageValueFromStorage();
  } else {
    return savePageValueToStorage();
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
  var chapterList, eventList, index, k, tList, timelineList, timelinePageValues, v;
  timelinePageValues = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX);
  timelineList = new Array(getTimelinePageValue(Constant.PageValueKey.TE_COUNT));
  for (k in timelinePageValues) {
    v = timelinePageValues[k];
    if (k.indexOf(Constant.PageValueKey.TE_NUM_PREFIX) === 0) {
      index = parseInt(k.substring(Constant.PageValueKey.TE_NUM_PREFIX.length)) - 1;
      timelineList[index] = v;
    }
  }
  chapterList = [];
  eventList = [];
  tList = [];
  $.each(timelineList, function(idx, obj) {
    var beforeTimeline, chapter, event, parallel;
    event = getInstanceFromMap(obj);
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
  scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * (scrollViewMag * 0.5));
  return scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * (scrollViewMag * 0.5));
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

savePageValueToStorage = function() {
  var h;
  h = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX);
  return lstorage.setItem(Constant.StorageKey.TIMELINE_PAGEVALUES, JSON.stringify(h));
};

loadPageValueFromStorage = function() {
  var h;
  h = JSON.parse(lstorage.getItem(Constant.StorageKey.TIMELINE_PAGEVALUES));
  return setTimelinePageValue(Constant.PageValueKey.TE_PREFIX, h);
};

$(function() {
  runCommonVar();
  initView();
  initHandleScrollPoint();
  initTimeline();
  setupScrollEvent();
  $('#sup_css').html(lstorage.getItem('itemCssStyle'));
  return $('#sup_css').html(getTimelinePageValue(Constant.PageValueKey.TE_CSS));
});

//# sourceMappingURL=run.js.js.map
