// Generated by CoffeeScript 1.9.2
var ItemPreviewCommon;

ItemPreviewCommon = (function() {
  var constant;

  function ItemPreviewCommon() {}

  constant = gon["const"];

  ItemPreviewCommon.MAIN_TEMP_WORKTABLE_CLASS = constant.ElementAttribute.MAIN_TEMP_WORKTABLE_CLASS;

  ItemPreviewCommon.MAIN_TEMP_RUN_CLASS = constant.ElementAttribute.MAIN_TEMP_RUN_CLASS;

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
      root.children('.section').remove();
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
    window.scrollContents.off('scroll').on('scroll', function(e) {
      var left, top;
      e.preventDefault();
      top = window.scrollContents.scrollTop();
      left = window.scrollContents.scrollLeft();
      if (jQuery(":hover")[jQuery(':hover').length - 1] === window.scrollInside.get(0)) {
        FloatView.show(FloatView.scrollMessage(top, left), FloatView.Type.DISPLAY_POSITION);
        return Common.saveDisplayPosition(top, left, false, function() {
          return FloatView.hide();
        });
      }
    });
    ItemPreviewHandwrite.initHandwrite();
    this.applyEnvironmentFromPagevalue();
    WorktableCommon.updateMainViewSize();
    if (callback != null) {
      return callback();
    }
  };

  ItemPreviewCommon.applyEnvironmentFromPagevalue = function() {
    return Common.initScrollContentsPosition();
  };

  ItemPreviewCommon.initMainContainerAsRun = function(callback) {
    if (callback == null) {
      callback = null;
    }
    CommonVar.runCommonVar();
    RunCommon.initView();
    RunCommon.initHandleScrollPoint();
    RunCommon.setupScrollEvent();
    Common.applyEnvironmentFromPagevalue();
    $('#project_wrapper').removeAttr('style');
    if (callback != null) {
      return callback();
    }
  };

  ItemPreviewCommon.initAfterLoadItem = function() {
    var itemClassName;
    if (window.isCodingDebug) {
      window.selectItemMenu = window[Constant.ITEM_CODING_TEMP_CLASS_NAME].CLASS_DIST_TOKEN;
    } else {
      itemClassName = $("." + Constant.ITEM_GALLERY_ITEM_CLASSNAME + ":first").val();
      window.selectItemMenu = window[itemClassName].CLASS_DIST_TOKEN;
    }
    WorktableCommon.changeMode(Constant.Mode.DRAW);
    this.initEvent();
    return Navbar.initItemPreviewNavbar();
  };

  ItemPreviewCommon.initEvent = function() {
    $('#run_btn_wrapper .run_btn').off('click').on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        return _this.switchRun();
      };
    })(this));
    return $('#stop_btn_wrapper .stop_btn').off('click').on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        return _this.switchWorktable();
      };
    })(this));
  };

  ItemPreviewCommon.switchWorktable = function(callback) {
    if (callback == null) {
      callback = null;
    }
    if (!window.isWorkTable) {
      window.isWorkTable = true;
      window.initDone = false;
      RunCommon.shutdown();
      this.createdMainContainerIfNeeded();
      return this.initMainContainerAsWorktable((function(_this) {
        return function() {
          return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
            window.initDone = true;
            $('#sidebar').find('.cover_touch_overlay').remove();
            WorktableCommon.changeMode(Constant.Mode.EDIT);
            $('#run_btn_wrapper').show();
            $('#stop_btn_wrapper').hide();
            if (callback != null) {
              return callback();
            }
          });
        };
      })(this));
    }
  };

  ItemPreviewCommon.switchRun = function(callback) {
    var height, width;
    if (callback == null) {
      callback = null;
    }
    if (window.isWorkTable) {
      window.isWorkTable = false;
      window.initDone = false;
      width = $('#screen_wrapper').width();
      height = $('#screen_wrapper').height();
      Project.initProjectValue('ItemPreviewRun', width, height);
      this.createdMainContainerIfNeeded();
      return this.initMainContainerAsRun((function(_this) {
        return function() {
          window.eventAction = null;
          window.runPage = true;
          _this.coverOverlayOnConfig();
          RunCommon.initEventAction();
          window.initDone = true;
          $('#run_btn_wrapper').hide();
          $('#stop_btn_wrapper').show();
          if (callback != null) {
            return callback();
          }
        };
      })(this));
    }
  };

  ItemPreviewCommon.coverOverlayOnConfig = function() {
    var nav, style, tabContent, top;
    tabContent = $('#myTabContent');
    nav = $('#tab-config ul.nav');
    top = -(nav.height());
    style = "top:" + top + "px;left:0;width:" + (tabContent.width()) + "px;height:" + (tabContent.height() + nav.height()) + "px;";
    tabContent.append("<div class='cover_touch_overlay' style='" + style + "'></div>");
    return $('.cover_touch_overlay').off('click').on('click', function(e) {
      e.preventDefault();
    });
  };

  ItemPreviewCommon.showUploadItemConfirm = function() {
    var target;
    target = '_uploaditem';
    window.open("about:blank", target);
    document.upload_item_form.target = target;
    return document.upload_item_form.submit();
  };

  ItemPreviewCommon.showAddItemConfirm = function() {};

  return ItemPreviewCommon;

})();

//# sourceMappingURL=item_preview_common.js.map
