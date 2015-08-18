// Generated by CoffeeScript 1.9.2
var initEventAction, initHandleScrollPoint, initResize, initView, setupScrollEvent;

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
  ls = new LocalStorage(LocalStorage.Key.RUN_EVENT_PAGEVALUES);
  if (is_reload != null) {
    return ls.loadEventPageValue();
  } else {
    return ls.saveEventPageValue();
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
  var chapterList, eventList, eventObjList, eventPageValueList;
  eventPageValueList = PageValue.getEventPageValueSortedListByNum();
  chapterList = [];
  eventObjList = [];
  eventList = [];
  $.each(eventPageValueList, function(idx, obj) {
    var beforeEvent, chapter, event, parallel;
    event = Common.getInstanceFromMap(obj);
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
          eventList: eventList
        });
      } else {
        chapter = new ScrollChapter({
          eventObjList: eventObjList,
          eventList: eventList
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
  window.eventAction = new EventAction(chapterList);
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
    if (eventAction.finished || !eventAction.isScrollChapter()) {
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
    return eventAction.handleScrollEvent(distX, distY);
  });
  return scrollFinished = function() {};
};

$(function() {
  runCommonVar();
  initView();
  initHandleScrollPoint();
  initEventAction();
  setupScrollEvent();
  return $('#sup_css').html(PageValue.getEventPageValue(Constant.PageValueKey.E_CSS));
});

//# sourceMappingURL=run.js.map
