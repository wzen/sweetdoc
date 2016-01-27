// Generated by CoffeeScript 1.9.2
var RunCommon;

RunCommon = (function() {
  var constant;

  function RunCommon() {}

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

    Key.LOADED_CLASS_DIST_TOKENS = constant.Run.Key.LOADED_CLASS_DIST_TOKENS;

    Key.PROJECT_ID = constant.Run.Key.PROJECT_ID;

    Key.ACCESS_TOKEN = constant.Run.Key.ACCESS_TOKEN;

    Key.RUNNING_USER_PAGEVALUE_ID = constant.Run.Key.RUNNING_USER_PAGEVALUE_ID;

    Key.FOOTPRINT_PAGE_VALUE = constant.Run.Key.FOOTPRINT_PAGE_VALUE;

    Key.LOAD_FOOTPRINT = constant.Run.Key.LOAD_FOOTPRINT;

    return Key;

  })();

  RunCommon.initView = function() {
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width());
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height());
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
    scrollInsideWrapper.width(window.scrollViewSize);
    scrollInsideWrapper.height(window.scrollViewSize);
    scrollInsideCover.width(window.scrollViewSize);
    scrollInsideCover.height(window.scrollViewSize);
    scrollHandle.width(window.scrollViewSize);
    scrollHandle.height(window.scrollViewSize);
    scrollHandleWrapper.scrollLeft(scrollHandle.width() * 0.5);
    scrollHandleWrapper.scrollTop(scrollHandle.height() * 0.5);
    return Common.initScrollContentsPosition();
  };

  RunCommon.updateMainViewSize = function() {
    var heightRate, i, infoHeight, padding, projectScreenSize, scaleFromViewRate, updateMainHeight, updateMainWidth, updatedProjectScreenSize, widthRate;
    updateMainWidth = $('#contents').width();
    infoHeight = 0;
    padding = 0;
    i = $('.contents_info:first');
    if (i != null) {
      infoHeight = i.height();
      padding = 9;
    }
    updateMainHeight = $('#contents').height() - infoHeight - padding;
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
      scaleFromViewRate = widthRate;
    } else {
      scaleFromViewRate = heightRate;
    }
    if (scaleFromViewRate === 0.0) {
      scaleFromViewRate = 0.01;
    }
    Common.scaleFromViewRate = scaleFromViewRate;
    updatedProjectScreenSize.width = projectScreenSize.width * scaleFromViewRate;
    updatedProjectScreenSize.height = projectScreenSize.height * scaleFromViewRate;
    $('#main').height(updateMainHeight);
    $('#project_wrapper').css({
      width: updatedProjectScreenSize.width,
      height: updatedProjectScreenSize.height
    });
    return Common.applyViewScale(true);
  };

  RunCommon.resizeMainContainerEvent = function() {
    this.updateMainViewSize();
    Common.updateCanvasSize();
    return Common.updateScrollContentsFromScreenEventVar();
  };

  RunCommon.resizeEvent = function() {
    return RunCommon.resizeMainContainerEvent();
  };

  RunCommon.showCreatorInfo = function() {
    var info, share;
    info = $('#contents').find('.contents_info:first');
    info.fadeIn('500');
    setTimeout(function() {
      return info.fadeOut('500');
    }, 3000);
    $('#contents .contents_info_show_button:first').off('click').on('click', (function(_this) {
      return function(e) {
        if (!info.is(':visible')) {
          return info.fadeIn('200');
        }
      };
    })(this));
    info.off('click').on('click', (function(_this) {
      return function(e) {
        if (info.is(':visible')) {
          return info.fadeOut('200');
        }
      };
    })(this));
    share = $('#contents').find('.share_info:first');
    $('#contents .contents_share_show_button:first').off('click').on('click', (function(_this) {
      return function(e) {
        if (!share.is(':visible')) {
          return share.fadeIn('200');
        }
      };
    })(this));
    share.off('click').on('click', (function(_this) {
      return function(e) {
        if (share.is(':visible')) {
          return share.fadeOut('200');
        }
      };
    })(this));
    return $('#contents').find('textarea.embed').off('click.close').on('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      return $(this).select();
    });
  };

  RunCommon.initEventAction = function() {
    var forkEventPageValueList, i, j, k, l, page, pageCount, pageList, pageNum, ref, ref1;
    pageCount = PageValue.getPageCount();
    pageNum = PageValue.getPageNum();
    pageList = new Array(pageCount);
    for (i = k = 1, ref = pageCount; 1 <= ref ? k <= ref : k >= ref; i = 1 <= ref ? ++k : --k) {
      if (i === parseInt(pageNum)) {
        forkEventPageValueList = {};
        for (j = l = 0, ref1 = PageValue.getForkCount(); 0 <= ref1 ? l <= ref1 : l >= ref1; j = 0 <= ref1 ? ++l : --l) {
          forkEventPageValueList[j] = PageValue.getEventPageValueSortedListByNum(j, i);
        }
        page = new Page({
          forks: forkEventPageValueList
        });
        pageList[i - 1] = page;
      } else {
        pageList[i - 1] = null;
      }
    }
    RunCommon.setPageMax(pageCount);
    window.eventAction = new EventAction(pageList, PageValue.getPageNum() - 1);
    return window.eventAction.start();
  };

  RunCommon.initHandleScrollPoint = function() {
    window.scrollHandleWrapper.scrollLeft(window.scrollHandle.width() * 0.5);
    return window.scrollHandleWrapper.scrollTop(window.scrollHandle.height() * 0.5);
  };

  RunCommon.setupScrollEvent = function() {
    var lastLeft, lastTop, stopTimer;
    lastLeft = window.scrollHandleWrapper.scrollLeft();
    lastTop = window.scrollHandleWrapper.scrollTop();
    stopTimer = null;
    return window.scrollHandleWrapper.off('scroll').on('scroll', function(e) {
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

  RunCommon.loadPagingPageValue = function(loadPageNum, doLoadFootprint, callback, forceUpdate) {
    var className, data, i, k, lastPageNum, locationPaths, ref, ref1, section, targetPages;
    if (doLoadFootprint == null) {
      doLoadFootprint = false;
    }
    if (callback == null) {
      callback = null;
    }
    if (forceUpdate == null) {
      forceUpdate = false;
    }
    lastPageNum = loadPageNum + Constant.Paging.PRELOAD_PAGEVALUE_NUM;
    targetPages = [];
    for (i = k = ref = loadPageNum, ref1 = lastPageNum; ref <= ref1 ? k <= ref1 : k >= ref1; i = ref <= ref1 ? ++k : --k) {
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
    data[RunCommon.Key.LOADED_CLASS_DIST_TOKENS] = JSON.stringify(PageValue.getLoadedclassDistTokens());
    locationPaths = window.location.pathname.split('/');
    data[RunCommon.Key.ACCESS_TOKEN] = locationPaths[locationPaths.length - 1].split('?')[0];
    data[RunCommon.Key.RUNNING_USER_PAGEVALUE_ID] = PageValue.getGeneralPageValue(PageValue.Key.RUNNING_USER_PAGEVALUE_ID);
    if (window.isMotionCheck && doLoadFootprint) {
      data[RunCommon.Key.LOAD_FOOTPRINT] = false;
      LocalStorage.loadPagingFootprintPageValue(loadPageNum);
    } else {
      data[RunCommon.Key.LOAD_FOOTPRINT] = doLoadFootprint;
    }
    return $.ajax({
      url: "/run/paging",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (data.resultSuccess) {
          return Common.setupJsByList(data.itemJsList, function() {
            if (data.pagevalues != null) {
              if (data.pagevalues.general_pagevalue != null) {
                PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, data.pagevalues.general_pagevalue, true);
              }
              if (data.pagevalues.instance_pagevalue != null) {
                PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, data.pagevalues.instance_pagevalue, true);
              }
              if (data.pagevalues.event_pagevalue != null) {
                PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, data.pagevalues.event_pagevalue, true);
              }
              if (data.pagevalues.footprint != null) {
                PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, data.pagevalues.footprint, true);
              }
            }
            if (callback != null) {
              return callback();
            }
          });
        } else {
          console.log('/run/paging server error');
          return Common.ajaxError(data);
        }
      },
      error: function(data) {
        console.log('/run/paging ajax error');
        return Common.ajaxError(data);
      }
    });
  };

  RunCommon.getForkStack = function(pn) {
    return PageValue.getFootprintPageValue(PageValue.Key.forkStack(pn));
  };

  RunCommon.setForkStack = function(obj, pn) {
    return PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), [obj]);
  };

  RunCommon.initForkStack = function(forkNum, pn) {
    this.setForkStack({
      changedChapterIndex: 0,
      forkNum: forkNum
    }, pn);
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
      PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), stack);
      return true;
    } else {
      return false;
    }
  };

  RunCommon.getLastObjestFromStack = function(pn) {
    var stack;
    stack = this.getForkStack(pn);
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
    stack = this.getForkStack(pn);
    if ((stack != null) && stack.length > 1) {
      return stack[stack.length - 2];
    } else {
      return null;
    }
  };

  RunCommon.popLastForkNumInStack = function(pn) {
    var stack;
    stack = this.getForkStack(pn);
    stack[pn].pop();
    PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), stack);
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
    return document.upload_gallery_form.submit();
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
    if (title_name != null) {
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

  RunCommon.saveFootprint = function(callback) {
    var data, locationPaths;
    if (callback == null) {
      callback = null;
    }
    if ((window.isMotionCheck != null) && window.isMotionCheck) {
      LocalStorage.saveFootprintPageValue();
      if (callback != null) {
        return callback();
      }
    } else {
      data = {};
      locationPaths = window.location.pathname.split('/');
      data[RunCommon.Key.ACCESS_TOKEN] = locationPaths[locationPaths.length - 1].split('?')[0];
      data[RunCommon.Key.FOOTPRINT_PAGE_VALUE] = JSON.stringify(PageValue.getFootprintPageValue(PageValue.Key.F_PREFIX));
      return $.ajax({
        url: "/run/save_gallery_footprint",
        type: "POST",
        data: data,
        dataType: "json",
        success: function(data) {
          if (data.resultSuccess) {
            if (callback != null) {
              return callback();
            }
          } else {
            console.log('/run/save_gallery_footprint server error');
            return Common.ajaxError(data);
          }
        },
        error: function(data) {
          console.log('/run/save_gallery_footprint ajax error');
          return Common.ajaxError(data);
        }
      });
    }
  };

  RunCommon.loadCommonFootprint = function(callback) {
    var data, locationPaths;
    if (callback == null) {
      callback = null;
    }
    if ((window.isMotionCheck != null) && window.isMotionCheck) {
      LocalStorage.loadCommonFootprintPageValue();
      if (callback != null) {
        return callback();
      }
    } else {
      data = {};
      locationPaths = window.location.pathname.split('/');
      data[RunCommon.Key.ACCESS_TOKEN] = locationPaths[locationPaths.length - 1].split('?')[0];
      return $.ajax({
        url: "/run/load_common_gallery_footprint",
        type: "POST",
        data: data,
        dataType: "json",
        success: function(data) {
          if (data.resultSuccess) {
            PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, data.pagevalue_data);
            if (callback != null) {
              return callback();
            }
          } else {
            console.log('/run/load_common_gallery_footprint server error');
            return Common.ajaxError(data);
          }
        },
        error: function(data) {
          console.log('/run/load_common_gallery_footprint ajax error');
          return Common.ajaxError(data);
        }
      });
    }
  };

  RunCommon.start = function(useLocalStorate) {
    var is_reload;
    if (useLocalStorate == null) {
      useLocalStorate = false;
    }
    window.eventAction = null;
    window.runPage = true;
    window.initDone = false;
    CommonVar.initVarWhenLoadedView();
    CommonVar.initCommonVar();
    if (useLocalStorate) {
      is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD);
      if (is_reload != null) {
        LocalStorage.loadAllPageValues();
      } else {
        PageValue.setPageNum(1);
        PageValue.removeAllFootprint();
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

  RunCommon.shutdown = function() {
    if (window.eventAction != null) {
      return window.eventAction.shutdown();
    }
  };

  return RunCommon;

})();

//# sourceMappingURL=run_common.js.map
