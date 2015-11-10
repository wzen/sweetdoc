// Generated by CoffeeScript 1.9.2
var RunCommon;

RunCommon = (function() {
  var constant;

  function RunCommon() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    RunCommon.RUN_CSS = constant.ElementAttribute.RUN_CSS;
    RunCommon.AttributeName = (function() {
      function AttributeName() {}

      AttributeName.CONTENTS_CREATOR_CLASSNAME = constant.Run.AttributeName.CONTENTS_CREATOR_CLASSNAME;

      AttributeName.CONTENTS_TITLE_CLASSNAME = constant.Run.AttributeName.CONTENTS_TITLE_CLASSNAME;

      AttributeName.CONTENTS_CAPTION_CLASSNAME = constant.Run.AttributeName.CONTENTS_CAPTION_CLASSNAME;

      AttributeName.CONTENTS_PAGE_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_PAGE_NUM_CLASSNAME;

      AttributeName.CONTENTS_PAGE_MAX_CLASSNAME = constant.Run.AttributeName.CONTENTS_PAGE_MAX_CLASSNAME;

      AttributeName.CONTENTS_CHAPTER_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_CHAPTER_NUM_CLASSNAME;

      AttributeName.CONTENTS_CHAPTER_MAX_CLASSNAME = constant.Run.AttributeName.CONTENTS_CHAPTER_MAX_CLASSNAME;

      AttributeName.CONTENTS_FORK_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_FORK_NUM_CLASSNAME;

      AttributeName.CONTENTS_TAGS_CLASSNAME = constant.Run.AttributeName.CONTENTS_TAGS_CLASSNAME;

      return AttributeName;

    })();
    RunCommon.Key = (function() {
      function Key() {}

      Key.TARGET_PAGES = constant.Run.Key.TARGET_PAGES;

      Key.LOADED_ITEM_IDS = constant.Run.Key.LOADED_ITEM_IDS;

      Key.PROJECT_ID = constant.Run.Key.PROJECT_ID;

      Key.ACCESS_TOKEN = constant.Run.Key.ACCESS_TOKEN;

      return Key;

    })();
  }

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
    Common.updateScrollContentsPosition(scrollInside.width() * 0.5, scrollInside.height() * 0.5);
    scrollHandleWrapper.scrollLeft(scrollHandle.width() * 0.5);
    return scrollHandleWrapper.scrollTop(scrollHandle.height() * 0.5);
  };

  RunCommon.updateMainViewSize = function() {
    var heightRate, i, infoHeight, padding, projectScreenSize, updateMainHeight, updateMainWidth, updateMainWrapperPercent, updatedProjectScreenSize, widthRate, zoom;
    updateMainWidth = $('#contents').width();
    infoHeight = 0;
    padding = 0;
    i = $('.contents_info:first');
    if (i != null) {
      infoHeight = i.height();
      padding = 9;
    }
    updateMainHeight = $('#contents').height() - $("#" + Navbar.NAVBAR_ROOT).height() - infoHeight - padding;
    projectScreenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
    updatedProjectScreenSize = $.extend(true, {}, projectScreenSize);
    if (updateMainWidth < projectScreenSize.width + 30) {
      updatedProjectScreenSize.width = updateMainWidth - 30;
    }
    if (updateMainHeight < projectScreenSize.height + 10) {
      updatedProjectScreenSize.height = updateMainHeight - 10;
    }
    widthRate = updatedProjectScreenSize.width / projectScreenSize.width;
    heightRate = updatedProjectScreenSize.height / projectScreenSize.height;
    if (widthRate < heightRate) {
      zoom = widthRate;
    } else {
      zoom = heightRate;
    }
    if (zoom === 0.0) {
      zoom = 0.01;
    }
    updatedProjectScreenSize.width = projectScreenSize.width * zoom;
    updatedProjectScreenSize.height = projectScreenSize.height * zoom;
    updateMainWrapperPercent = 100 / zoom;
    $('#main').height(updateMainHeight);
    $('#project_wrapper').css({
      width: updatedProjectScreenSize.width,
      height: updatedProjectScreenSize.height
    });
    return window.mainWrapper.css({
      transform: "scale(" + zoom + ", " + zoom + ")",
      width: updateMainWrapperPercent + "%",
      height: updateMainWrapperPercent + "%"
    });
  };

  RunCommon.resizeMainContainerEvent = function() {
    this.updateMainViewSize();
    Common.updateCanvasSize();
    return Common.updateScrollContentsFromPagevalue();
  };

  RunCommon.resizeEvent = function() {
    return RunCommon.resizeMainContainerEvent();
  };

  RunCommon.initEventAction = function() {
    var forkEventPageValueList, i, j, l, m, page, pageCount, pageList, ref, ref1;
    pageCount = PageValue.getPageCount();
    pageList = new Array(pageCount);
    for (i = l = 1, ref = pageCount; 1 <= ref ? l <= ref : l >= ref; i = 1 <= ref ? ++l : --l) {
      forkEventPageValueList = {};
      for (j = m = 0, ref1 = PageValue.getForkCount(); 0 <= ref1 ? m <= ref1 : m >= ref1; j = 0 <= ref1 ? ++m : --m) {
        forkEventPageValueList[j] = PageValue.getEventPageValueSortedListByNum(j, i);
      }
      page = null;
      if (forkEventPageValueList[PageValue.Key.EF_MASTER_FORKNUM].length > 0) {
        page = new Page({
          forks: forkEventPageValueList
        });
      }
      pageList[i - 1] = page;
    }
    RunCommon.setPageMax(pageCount);
    window.eventAction = new EventAction(pageList, PageValue.getPageNum() - 1);
    return window.eventAction.start();
  };

  RunCommon.initHandleScrollPoint = function() {
    window.scrollHandleWrapper.scrollLeft(window.scrollHandleWrapper.width() * 0.5);
    return window.scrollHandleWrapper.scrollTop(window.scrollHandleWrapper.height() * 0.5);
  };

  RunCommon.setupScrollEvent = function() {
    var lastLeft, lastTop, stopTimer;
    lastLeft = window.scrollHandleWrapper.scrollLeft();
    lastTop = window.scrollHandleWrapper.scrollTop();
    stopTimer = null;
    window.scrollHandleWrapper.off('scroll');
    return window.scrollHandleWrapper.on('scroll', function(e) {
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

  RunCommon.loadPagingPageValue = function(loadPageNum, callback, forceUpdate) {
    var className, data, i, l, lastPageNum, locationPaths, ref, ref1, section, targetPages;
    if (callback == null) {
      callback = null;
    }
    if (forceUpdate == null) {
      forceUpdate = false;
    }
    lastPageNum = loadPageNum + Constant.Paging.PRELOAD_PAGEVALUE_NUM;
    targetPages = [];
    for (i = l = ref = loadPageNum, ref1 = lastPageNum; ref <= ref1 ? l <= ref1 : l >= ref1; i = ref <= ref1 ? ++l : --l) {
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
    data = {};
    data[RunCommon.Key.TARGET_PAGES] = targetPages;
    data[RunCommon.Key.LOADED_ITEM_IDS] = JSON.stringify(PageValue.getLoadedItemIds());
    data[RunCommon.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
    locationPaths = window.location.pathname.split('/');
    data[RunCommon.Key.ACCESS_TOKEN] = locationPaths[locationPaths.length - 1].split('?')[0];
    return $.ajax({
      url: "/run/paging",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (data.resultSuccess) {
          return Common.setupJsByList(data.itemJsList, function() {
            var k, ref2, ref3, ref4, v;
            if (data.pagevalues != null) {
              if (data.pagevalues.general_pagevalue != null) {
                ref2 = data.pagevalues.general_pagevalue;
                for (k in ref2) {
                  v = ref2[k];
                  PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, JSON.parse(v));
                }
              }
              if (data.pagevalues.instance_pagevalue != null) {
                ref3 = data.pagevalues.instance_pagevalue;
                for (k in ref3) {
                  v = ref3[k];
                  PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, JSON.parse(v));
                }
              }
              if (data.pagevalues.event_pagevalue != null) {
                ref4 = data.pagevalues.event_pagevalue;
                for (k in ref4) {
                  v = ref4[k];
                  PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT + PageValue.Key.PAGE_VALUES_SEPERATOR + k, JSON.parse(v));
                }
              }
            }
            if (callback != null) {
              return callback();
            }
          });
        } else {
          return console.log('/run/paging server error');
        }
      },
      error: function(data) {
        return console.log('/run/paging ajax error');
      }
    });
  };

  RunCommon.getForkStack = function(pn) {
    if (window.forkNumStacks == null) {
      window.forkNumStacks = {};
    }
    return window.forkNumStacks[pn];
  };

  RunCommon.setForkStack = function(obj, pn) {
    if (window.forkNumStacks == null) {
      window.forkNumStacks = {};
    }
    return window.forkNumStacks[pn] = [obj];
  };

  RunCommon.initForkStack = function(forkNum, pn) {
    this.setForkStack({
      changedChapterIndex: 0,
      forkNum: forkNum
    }, pn);
    PageValue.setGeneralPageValue(PageValue.Key.FORK_STACK, window.forkNumStacks);
    return true;
  };

  RunCommon.addForkNumToStack = function(forkNum, cIndex, pn) {
    var lastForkNum, stack;
    lastForkNum = this.getLastForkNumFromStack(pn);
    if ((lastForkNum != null) && lastForkNum !== forkNum) {
      stack = this.getForkStack(pn);
      stack.push({
        changedChapterIndex: cIndex,
        forkNum: forkNum
      });
      PageValue.setGeneralPageValue(PageValue.Key.FORK_STACK, window.forkNumStacks);
      return true;
    } else {
      return false;
    }
  };

  RunCommon.getLastObjestFromStack = function(pn) {
    var stack;
    if (window.forkNumStacks == null) {
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK);
      if (window.forkNumStacks == null) {
        return null;
      }
    }
    stack = window.forkNumStacks[pn];
    if ((stack != null) && stack.length > 0) {
      return stack[stack.length - 1];
    } else {
      return null;
    }
  };

  RunCommon.getLastForkNumFromStack = function(pn) {
    var obj;
    obj = this.getLastObjestFromStack(pn);
    if (obj != null) {
      return obj.forkNum;
    } else {
      return null;
    }
  };

  RunCommon.getOneBeforeObjestFromStack = function(pn) {
    var stack;
    if (window.forkNumStacks == null) {
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK);
      if (window.forkNumStacks == null) {
        return null;
      }
    }
    stack = window.forkNumStacks[pn];
    if ((stack != null) && stack.length > 1) {
      return stack[stack.length - 2];
    } else {
      return null;
    }
  };

  RunCommon.popLastForkNumInStack = function(pn) {
    if (window.forkNumStacks == null) {
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK);
      if (window.forkNumStacks == null) {
        return false;
      }
    }
    window.forkNumStacks[pn].pop();
    return true;
  };

  RunCommon.showUploadGalleryConfirm = function() {
    var root, target;
    target = '_uploadgallery';
    window.open("about:blank", target);
    root = $('#nav');
    $("input[name='" + Constant.Gallery.Key.PROJECT_ID + "']", root).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID));
    $("input[name='" + Constant.Gallery.Key.PAGE_MAX + "']", root).val(PageValue.getPageCount());
    document.upload_gallery_form.target = target;
    return setTimeout(function() {
      return document.upload_gallery_form.submit();
    }, 200);
  };

  RunCommon.initMainContainer = function() {
    CommonVar.runCommonVar();
    this.initView();
    this.initHandleScrollPoint();
    Common.initResize(this.resizeEvent);
    this.setupScrollEvent();
    Navbar.initRunNavbar();
    Common.applyEnvironmentFromPagevalue();
    return RunCommon.updateMainViewSize();
  };

  RunCommon.setCreator = function(value) {
    var e;
    e = $("." + this.AttributeName.CONTENTS_CREATOR_CLASSNAME);
    if (e != null) {
      return e.html(value);
    } else {
      return e.html('');
    }
  };

  RunCommon.setTitle = function(title_name) {
    var base, e;
    base = title_name;
    if (!window.isWorkTable) {
      title_name += '(Preview)';
    }
    $("#" + Navbar.NAVBAR_ROOT).find('.nav_title').html(title_name);
    e = $("." + this.AttributeName.CONTENTS_TITLE_CLASSNAME);
    if ((title_name != null) && title_name.length > 0) {
      document.title = title_name;
    } else {
      document.title = window.appName;
    }
    e = $("." + this.AttributeName.CONTENTS_TITLE_CLASSNAME);
    if (e != null) {
      return e.html(base);
    } else {
      return e.html('');
    }
  };

  RunCommon.setPageNum = function(value) {
    var e;
    e = $("." + this.AttributeName.CONTENTS_PAGE_NUM_CLASSNAME);
    if (e != null) {
      return e.html(value);
    } else {
      return e.html('');
    }
  };

  RunCommon.setChapterNum = function(value) {
    var e;
    e = $("." + this.AttributeName.CONTENTS_CHAPTER_NUM_CLASSNAME);
    if (e != null) {
      return e.html(value);
    } else {
      return e.html('');
    }
  };

  RunCommon.setPageMax = function(page_max) {
    var e;
    e = $("." + this.AttributeName.CONTENTS_PAGE_MAX_CLASSNAME);
    if (e != null) {
      return e.html(page_max);
    } else {
      return e.html('');
    }
  };

  RunCommon.setChapterMax = function(chapter_max) {
    var e;
    e = $("." + this.AttributeName.CONTENTS_CHAPTER_MAX_CLASSNAME);
    if (e != null) {
      return e.html(chapter_max);
    } else {
      return e.html('');
    }
  };

  RunCommon.setForkNum = function(num) {
    var e;
    e = $("." + this.AttributeName.CONTENTS_FORK_NUM_CLASSNAME);
    if (e != null) {
      e.html(num);
      return e.closest('li').css('display', num > 0 ? 'block' : 'none');
    } else {
      e.html('');
      return e.closest('li').hide();
    }
  };

  RunCommon.start = function(useLocalStorate) {
    var is_reload;
    if (useLocalStorate == null) {
      useLocalStorate = false;
    }
    window.isWorkTable = false;
    window.eventAction = null;
    window.runPage = true;
    window.initDone = false;
    CommonVar.initVarWhenLoadedView();
    CommonVar.initCommonVar();
    PageValue.setPageNum(1);
    if (useLocalStorate) {
      is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD);
      if (is_reload != null) {
        LocalStorage.loadAllPageValues();
      } else {
        LocalStorage.saveAllPageValues();
      }
    }
    Common.createdMainContainerIfNeeded(PageValue.getPageNum());
    RunCommon.initMainContainer();
    return Common.loadJsFromInstancePageValue(function() {
      RunCommon.initEventAction();
      return window.initDone = true;
    });
  };

  return RunCommon;

})();

//# sourceMappingURL=run_common.js.map
