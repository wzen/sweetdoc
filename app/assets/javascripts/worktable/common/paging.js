// Generated by CoffeeScript 1.9.2
var Paging;

Paging = (function() {
  function Paging() {}

  Paging.initPaging = function() {
    return this.createPageSelectMenu();
  };

  Paging.createPageSelectMenu = function() {
    var active, divider, i, j, menu, navMenuClass, navMenuName, newPageMenu, nowMenuName, pageCount, pageMenu, ref, root, selectRoot, self;
    self = this;
    pageCount = PageValue.getPageCount();
    root = $("#" + Constant.Paging.NAV_ROOT_ID);
    selectRoot = $("." + Constant.Paging.NAV_SELECT_ROOT_CLASS, root);
    menu = "<li><a class='" + Constant.Paging.NAV_MENU_CLASS + " menu-item'>" + Constant.Paging.NAV_MENU_NAME + "</a></li>";
    divider = "<li class='divider'></li>";
    newPageMenu = "<li><a class='" + Constant.Paging.NAV_MENU_ADDPAGE_CLASS + " menu-item'>Add next page</a></li>";
    pageMenu = '';
    for (i = j = 1, ref = pageCount; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
      navMenuClass = Constant.Paging.NAV_MENU_CLASS.replace('@pagenum', i);
      navMenuName = Constant.Paging.NAV_MENU_NAME.replace('@pagenum', i);
      active = i === PageValue.getPageNum() ? 'class="active"' : '';
      pageMenu += "<li " + active + "><a class='" + navMenuClass + " menu-item '>" + navMenuName + "</a></li>";
    }
    pageMenu += divider;
    pageMenu += newPageMenu;
    selectRoot.children().remove();
    $(pageMenu).appendTo(selectRoot);
    nowMenuName = Constant.Paging.NAV_MENU_NAME.replace('@pagenum', PageValue.getPageNum());
    $("." + Constant.Paging.NAV_SELECTED_CLASS, root).html(nowMenuName);
    selectRoot.find(".menu-item").off('click');
    selectRoot.find(".menu-item").on('click', function() {
      var classList, prefix;
      prefix = Constant.Paging.NAV_MENU_CLASS.replace('@pagenum', '');
      classList = this.classList;
      return classList.forEach(function(c) {
        var pageNum;
        if (c.indexOf(prefix) >= 0) {
          pageNum = parseInt(c.replace(prefix, ''));
          self.selectPage(pageNum);
          return false;
        }
      });
    });
    selectRoot.find("." + Constant.Paging.NAV_MENU_ADDPAGE_CLASS, root).off('click');
    return selectRoot.find("." + Constant.Paging.NAV_MENU_ADDPAGE_CLASS, root).on('click', function() {
      return self.createNewPage();
    });
  };

  Paging.switchSectionDisplay = function(pageNum) {
    var className, section;
    $("#" + Constant.Paging.ROOT_ID).find(".section").css('display', 'none');
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    section = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
    return section.css('display', '');
  };

  Paging.createNewPage = function() {
    var beforePageNum, pageFlip, self;
    self = this;
    beforePageNum = PageValue.getPageNum();
    if (window.debug) {
      console.log('[createNewPage] beforePageNum:' + beforePageNum);
    }
    Sidebar.closeSidebar();
    LocalStorage.clearWorktableWithoutSetting();
    EventConfig.removeAllConfig();
    Common.createdMainContainerIfNeeded(beforePageNum + 1);
    pageFlip = new PageFlip(beforePageNum, beforePageNum + 1);
    PageValue.setPageNum(PageValue.getPageCount() + 1);
    WorktableCommon.initMainContainer();
    PageValue.adjustInstanceAndEventOnThisPage();
    return WorktableCommon.drawAllItemFromInstancePageValue((function(_this) {
      return function() {
        return pageFlip.startRender(function() {
          var className, section;
          className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
          section = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
          section.css('display', 'none');
          Common.removeAllItem(beforePageNum);
          Timeline.refreshAllTimeline();
          PageValue.setEventPageValue(PageValue.Key.eventCount(), 0);
          PageValue.updatePageCount();
          LocalStorage.saveAllPageValues();
          return self.createPageSelectMenu();
        });
      };
    })(this));
  };

  Paging.selectPage = function(selectedNum) {
    var beforePageNum, pageCount, pageFlip, self;
    if (window.debug) {
      console.log('[selectPage] selectedNum:' + selectedNum);
    }
    self = this;
    if (selectedNum <= 0) {
      return;
    }
    pageCount = PageValue.getPageCount();
    if (selectedNum < 0 || selectedNum > pageCount) {
      return;
    }
    beforePageNum = PageValue.getPageNum();
    if (window.debug) {
      console.log('[selectPage] beforePageNum:' + beforePageNum);
    }
    Sidebar.closeSidebar();
    LocalStorage.clearWorktableWithoutSetting();
    EventConfig.removeAllConfig();
    Common.createdMainContainerIfNeeded(selectedNum, beforePageNum > selectedNum);
    pageFlip = new PageFlip(beforePageNum, selectedNum);
    PageValue.setPageNum(selectedNum);
    WorktableCommon.initMainContainer();
    PageValue.adjustInstanceAndEventOnThisPage();
    return WorktableCommon.drawAllItemFromInstancePageValue((function(_this) {
      return function() {
        return pageFlip.startRender(function() {
          var className, section;
          className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
          section = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
          section.css('display', 'none');
          if (window.debug) {
            console.log('[selectPage] deleted pageNum:' + beforePageNum);
          }
          Common.removeAllItem(beforePageNum);
          Timeline.refreshAllTimeline();
          LocalStorage.saveAllPageValues();
          return self.createPageSelectMenu();
        });
      };
    })(this));
  };

  return Paging;

})();

//# sourceMappingURL=paging.js.map
