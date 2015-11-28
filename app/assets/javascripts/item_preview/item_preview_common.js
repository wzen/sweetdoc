// Generated by CoffeeScript 1.9.2
var ItemPreviewCommon;

ItemPreviewCommon = (function() {
  var constant;

  function ItemPreviewCommon() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    ItemPreviewCommon.MAIN_TEMP_WORKTABLE_CLASS = constant.ElementAttribute.MAIN_TEMP_WORKTABLE_CLASS;
    ItemPreviewCommon.MAIN_TEMP_RUN_CLASS = constant.ElementAttribute.MAIN_TEMP_RUN_CLASS;
  }

  ItemPreviewCommon.createdMainContainerIfNeeded = function() {
    var container, markClass, pageSection, root, sectionClass, temp;
    root = $("#" + Constant.Paging.ROOT_ID);
    markClass = '';
    if (isWorkTable) {
      markClass = 'ws';
    } else {
      markClass = 'run';
    }
    container = $("." + markClass, root);
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', 1);
    pageSection = $("." + sectionClass, root);
    if ((container == null) || container.length === 0) {
      root.empty();
      if (isWorkTable) {
        temp = $("." + ItemPreviewCommon.MAIN_TEMP_WORKTABLE_CLASS + ":first").children(':first').clone(true);
      } else {
        temp = $("." + ItemPreviewCommon.MAIN_TEMP_RUN_CLASS + ":first").children(':first').clone(true);
      }
      temp = $(temp).wrap("<div class='" + sectionClass + " " + markClass + " section'></div>").parent();
      root.append(temp);
      return true;
    } else {
      return false;
    }
  };

  ItemPreviewCommon.initMainContainerAsWorktable = function(callback) {
    if (callback == null) {
      callback = null;
    }
    CommonVar.worktableCommonVar();
    Common.updateCanvasSize();
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT));
    window.scrollInsideWrapper.width(window.scrollViewSize);
    window.scrollInsideWrapper.height(window.scrollViewSize);
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1));
    window.scrollContents.off('scroll');
    window.scrollContents.on('scroll', function(e) {
      var left, top;
      e.preventDefault();
      top = window.scrollContents.scrollTop();
      left = window.scrollContents.scrollLeft();
      FloatView.show(FloatView.scrollMessage(top, left), FloatView.Type.DISPLAY_POSITION);
      if (window.scrollContentsScrollTimer != null) {
        clearTimeout(window.scrollContentsScrollTimer);
      }
      return window.scrollContentsScrollTimer = setTimeout(function() {
        PageValue.setDisplayPosition(top, left);
        FloatView.hide();
        return window.scrollContentsScrollTimer = null;
      }, 500);
    });
    ItemPreviewHandwrite.initHandwrite();
    Common.applyEnvironmentFromPagevalue();
    WorktableCommon.updateMainViewSize();
    if (callback != null) {
      return callback();
    }
  };

  ItemPreviewCommon.initMainContainerAsRun = function(callback) {
    if (callback == null) {
      callback = null;
    }
    CommonVar.runCommonVar();
    RunCommon.initView();
    RunCommon.initHandleScrollPoint();
    Common.initResize(this.resizeEvent);
    RunCommon.setupScrollEvent();
    Common.applyEnvironmentFromPagevalue();
    RunCommon.updateMainViewSize();
    if (callback != null) {
      return callback();
    }
  };

  ItemPreviewCommon.initAfterLoadItem = function() {
    window.selectItemMenu = ItemPreviewTemp.ITEM_ID;
    WorktableCommon.changeMode(Constant.Mode.DRAW);
    return this.initEvent();
  };

  ItemPreviewCommon.initEvent = function() {
    $('#run_btn_wrapper .run_btn').off('click').on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        if (window.isWorkTable) {
          window.isWorkTable = false;
          return _this.switchRun(function() {
            $('#run_btn_wrapper').hide();
            return $('#stop_btn_wrapper').show();
          });
        }
      };
    })(this));
    return $('#stop_btn_wrapper .stop_btn').off('click').on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        if (!window.isWorkTable) {
          window.isWorkTable = true;
          return _this.switchWorktable(function() {
            $('#run_btn_wrapper').show();
            return $('#stop_btn_wrapper').hide();
          });
        }
      };
    })(this));
  };

  ItemPreviewCommon.switchWorktable = function(callback) {
    if (callback == null) {
      callback = null;
    }
    window.initDone = false;
    this.createdMainContainerIfNeeded();
    return this.initMainContainerAsWorktable(function() {
      return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
        window.initDone = true;
        if (callback != null) {
          return callback();
        }
      });
    });
  };

  ItemPreviewCommon.switchRun = function(callback) {
    var height, width;
    if (callback == null) {
      callback = null;
    }
    window.initDone = false;
    width = $('#screen_wrapper').width();
    height = $('#screen_wrapper').height();
    Project.initProjectValue('ItemPreviewRun', width, height);
    this.createdMainContainerIfNeeded();
    return this.initMainContainerAsRun(function() {
      window.eventAction = null;
      window.runPage = true;
      Common.createdMainContainerIfNeeded(PageValue.getPageNum());
      RunCommon.initMainContainer();
      RunCommon.initEventAction();
      window.initDone = true;
      if (callback != null) {
        return callback();
      }
    });
  };

  return ItemPreviewCommon;

})();

//# sourceMappingURL=item_preview_common.js.map
