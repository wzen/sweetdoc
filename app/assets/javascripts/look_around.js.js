// Generated by CoffeeScript 1.8.0
var initCommonVar, initResize, initScroll, initScrollPoint;

initCommonVar = function() {
  window.wrap = $('#main-wrapper');
  window.contents = $("#scroll_wrapper");
  window.scrollContents = $("#scroll_contents");
  window.inside = $("#scroll_inside");
  window.distX = 0;
  window.distY = 0;
  window.scrollViewMag = 20;
  window.resizeTimer = false;
  return window.timeLine = null;
};

initResize = function(wrap, contents) {
  var resizeTimer;
  resizeTimer = false;
  return $(window).resize(function() {
    if (resizeTimer !== false) {
      clearTimeout(resizeTimer);
    }
    return resizeTimer = setTimeout(function() {
      var h;
      h = $(window).height();
      wrap.height(h);
      return contents.height(h);
    }, 200);
  });
};

initScrollPoint = function() {
  scrollContents.scrollLeft(scrollContents.width() * (scrollViewMag * 0.5));
  return scrollContents.scrollTop(scrollContents.height() * (scrollViewMag * 0.5));
};

initScroll = function() {
  var lastLeft, lastTop, scrollFinished, stopTimer;
  lastLeft = null;
  lastTop = null;
  stopTimer = null;
  scrollContents.on("mousedown", function(e) {
    e.preventDefault();
    return console.log('onmousedown');
  });
  scrollContents.scroll(function() {
    var distX, distY, x, y;
    x = $(this).scrollLeft();
    y = $(this).scrollTop();
    if (lastLeft === null || lastTop === null) {
      initScrollPoint();
      lastLeft = x;
      lastTop = y;
    }
    if (stopTimer !== null) {
      clearTimeout(stopTimer);
    }
    stopTimer = setTimeout(function() {
      lastLeft = null;
      lastTop = null;
      clearTimeout(stopTimer);
      return stopTimer = null;
    }, 50);
    if (lastLeft === null || lastTop === null) {
      return;
    }
    distX = x - lastLeft;
    distY = y - lastTop;
    lastLeft = x;
    return lastTop = y;
  });
  return scrollFinished = function() {};
};

$(function() {
  var actorList, chapter, chapterList, objList;
  initCommonVar();
  inside.width(scrollContents.width() * (scrollViewMag + 1));
  inside.height(scrollContents.height() * (scrollViewMag + 1));
  initScrollPoint();
  $('#canvas_container').attr('width', $('#canvas_wrapper').width());
  $('#canvas_container').attr('height', $('#canvas_wrapper').height());
  window.lstorage = localStorage;
  objList = JSON.parse(lstorage.getItem('timelineObjList'));
  actorList = [];
  objList.forEach(function(obj) {
    var item, miniObj;
    item = null;
    miniObj = obj.miniObj;
    if (miniObj.itemType === Constant.ItemType.BUTTON) {
      item = new ButtonItem();
    } else if (miniObj.itemType === Constant.ItemType.ARROW) {
      item = new ArrowItem();
    }
    item.initActor(miniObj, obj.actorSize, obj.sEvent, obj.cEvent);
    return actorList.push(item);
  });
  chapterList = [];
  chapter = new Chapter(actorList);
  chapterList.push(chapter);
  window.timeLine = new TimeLine(chapterList);
  return initScroll();
});

//# sourceMappingURL=look_around.js.js.map
