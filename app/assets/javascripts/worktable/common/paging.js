// Generated by CoffeeScript 1.9.2
var Paging;

Paging = (function() {
  function Paging() {}

  Paging.initPaging = function() {
    return this.createPageSelectMenu();
  };

  Paging.createPageSelectMenu = function() {
    var active, deletePageMenu, divider, forkCount, forkNum, i, j, k, l, name, navForkClass, navForkName, navPageClass, navPageName, newForkMenu, newPageMenu, nowMenuName, pageCount, pageMenu, ref, ref1, root, selectRoot, subActive, subMenu;
    pageCount = PageValue.getPageCount();
    root = $("#" + Constant.Paging.NAV_ROOT_ID);
    selectRoot = $("." + Constant.Paging.NAV_SELECT_ROOT_CLASS, root);
    divider = "<li class='divider'></li>";
    newPageMenu = "<li><a class='" + Constant.Paging.NAV_MENU_ADDPAGE_CLASS + " menu-item'>" + (I18n.t('header_menu.page.add_page')) + "</a></li>";
    newForkMenu = "<li><a class='" + Constant.Paging.NAV_MENU_ADDFORK_CLASS + " menu-item'>" + (I18n.t('header_menu.page.add_fork')) + "</a></li>";
    deletePageMenu = "<li><a class='" + Constant.Paging.NAV_MENU_DELETEPAGE_CLASS + " menu-item'>" + (I18n.t('header_menu.page.delete_page')) + "</a></li>";
    pageMenu = '';
    for (i = k = 1, ref = pageCount; 1 <= ref ? k <= ref : k >= ref; i = 1 <= ref ? ++k : --k) {
      navPageClass = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', i);
      navPageName = (I18n.t('header_menu.page.page')) + " " + i;
      forkCount = PageValue.getForkCount(i);
      forkNum = PageValue.getForkNum(i);
      active = forkNum === PageValue.Key.EF_MASTER_FORKNUM ? 'class="active"' : '';
      subMenu = "<li " + active + "><a class='" + navPageClass + " menu-item '>" + (I18n.t('header_menu.page.master')) + "</a></li>";
      if (forkCount > 0) {
        for (j = l = 1, ref1 = forkCount; 1 <= ref1 ? l <= ref1 : l >= ref1; j = 1 <= ref1 ? ++l : --l) {
          navForkClass = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', j);
          navForkName = (I18n.t('header_menu.page.fork')) + " " + j;
          subActive = j === forkNum ? 'class="active"' : '';
          subMenu += "<li " + subActive + "><a class='" + navPageClass + " " + navForkClass + " menu-item '>" + navForkName + "</a></li>";
        }
      }
      subMenu += divider + newForkMenu;
      if (i > 1) {
        subMenu += divider + deletePageMenu;
      }
      pageMenu += "<li class=\"dropdown-submenu\">\n    <a>" + navPageName + "</a>\n    <ul class=\"dropdown-menu\">\n        " + subMenu + "\n    </ul>\n</li>";
    }
    pageMenu += divider + newPageMenu;
    selectRoot.children().remove();
    $(pageMenu).appendTo(selectRoot);
    nowMenuName = (I18n.t('header_menu.page.page')) + " " + (PageValue.getPageNum());
    if (PageValue.getForkNum() > 0) {
      name = (I18n.t('header_menu.page.fork')) + " " + (PageValue.getForkNum());
      nowMenuName += " - (" + name + ")";
    }
    $("." + Constant.Paging.NAV_SELECTED_CLASS, root).html(nowMenuName);
    selectRoot.find(".menu-item").off('click').on('click', (function(_this) {
      return function(e) {
        var classList, forkPrefix, pageNum, pagePrefix;
        Common.hideModalView(true);
        Common.showModalFlashMessage('Changing...');
        pagePrefix = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', '');
        forkPrefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '');
        pageNum = null;
        forkNum = PageValue.Key.EF_MASTER_FORKNUM;
        classList = e.target.classList;
        classList.forEach(function(c) {
          if (c.indexOf(pagePrefix) >= 0) {
            return pageNum = parseInt(c.replace(pagePrefix, ''));
          } else if (c.indexOf(forkPrefix) >= 0) {
            return forkNum = parseInt(c.replace(forkPrefix, ''));
          }
        });
        if (pageNum != null) {
          return _this.selectPage(pageNum, forkNum);
        } else {
          return Common.hideModalView();
        }
      };
    })(this));
    selectRoot.find("." + Constant.Paging.NAV_MENU_ADDPAGE_CLASS, root).off('click').on('click', (function(_this) {
      return function() {
        return _this.createNewPage();
      };
    })(this));
    selectRoot.find("." + Constant.Paging.NAV_MENU_ADDFORK_CLASS, root).off('click').on('click', (function(_this) {
      return function() {
        return _this.createNewFork();
      };
    })(this));
    return selectRoot.find("." + Constant.Paging.NAV_MENU_DELETEPAGE_CLASS, root).off('click').on('click', (function(_this) {
      return function() {
        if (window.confirm(I18n.t('message.dialog.delete_page'))) {
          return _this.removePage();
        }
      };
    })(this));
  };

  Paging.switchSectionDisplay = function(pageNum) {
    var className, section;
    $("#" + Constant.Paging.ROOT_ID).find(".section").hide();
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    section = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
    return section.show();
  };

  Paging.createNewPage = function() {
    Common.hideModalView(true);
    Common.showModalFlashMessage('Creating...');
    return WorktableCommon.stopAllEventPreview((function(_this) {
      return function() {
        var beforePageNum, created;
        beforePageNum = PageValue.getPageNum();
        if (window.debug) {
          console.log('[createNewPage] beforePageNum:' + beforePageNum);
        }
        Sidebar.closeSidebar();
        LocalStorage.clearWorktableWithoutSetting();
        EventConfig.removeAllConfig();
        created = Common.createdMainContainerIfNeeded(PageValue.getPageCount() + 1);
        PageValue.setPageNum(PageValue.getPageCount() + 1);
        WorktableCommon.initMainContainer();
        PageValue.adjustInstanceAndEventOnPage();
        return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
          var className, newSection, oldSection;
          WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded();
          WorktableCommon.changeMode(window.mode);
          Timeline.refreshAllTimeline();
          className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
          newSection = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
          newSection.show();
          className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
          oldSection = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
          oldSection.hide();
          Common.removeAllItem(beforePageNum);
          PageValue.setEventPageValue(PageValue.Key.eventCount(), 0);
          PageValue.updatePageCount();
          WorktableCommon.setWorktableViewScale(WorktableCommon.getWorktableViewScale(beforePageNum), true);
          WorktableCommon.initScrollContentsPosition();
          if (created) {
            OperationHistory.add(true);
          }
          LocalStorage.saveAllPageValues();
          _this.createPageSelectMenu();
          return Common.hideModalView();
        });
      };
    })(this));
  };

  Paging.selectPage = function(selectedPageNum, selectedForkNum, callback) {
    if (selectedForkNum == null) {
      selectedForkNum = PageValue.Key.EF_MASTER_FORKNUM;
    }
    if (callback == null) {
      callback = null;
    }
    if (selectedPageNum === PageValue.getPageNum()) {
      if (selectedForkNum === PageValue.getForkNum()) {
        Common.hideModalView();
        if (callback != null) {
          callback();
        }
        return;
      } else {
        this.selectFork(selectedForkNum, (function(_this) {
          return function() {
            Timeline.refreshAllTimeline();
            LocalStorage.saveAllPageValues();
            _this.createPageSelectMenu();
            Common.hideModalView();
            if (callback != null) {
              return callback();
            }
          };
        })(this));
        return;
      }
    }
    return WorktableCommon.stopAllEventPreview((function(_this) {
      return function() {
        var beforePageNum, created, pageCount;
        if (window.debug) {
          console.log('[selectPage] selectedNum:' + selectedPageNum);
        }
        if (selectedPageNum <= 0) {
          return;
        }
        pageCount = PageValue.getPageCount();
        if (selectedPageNum < 0 || selectedPageNum > pageCount) {
          return;
        }
        beforePageNum = PageValue.getPageNum();
        if (window.debug) {
          console.log('[selectPage] beforePageNum:' + beforePageNum);
        }
        Sidebar.closeSidebar();
        LocalStorage.clearWorktableWithoutSetting();
        EventConfig.removeAllConfig();
        created = Common.createdMainContainerIfNeeded(selectedPageNum, false);
        PageValue.setPageNum(selectedPageNum);
        WorktableCommon.initMainContainer();
        PageValue.adjustInstanceAndEventOnPage();
        return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
          return Paging.selectFork(selectedForkNum, function() {
            var className, newSection, oldSection;
            WorktableCommon.changeMode(window.mode, selectedPageNum);
            Timeline.refreshAllTimeline();
            className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', selectedPageNum);
            newSection = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
            newSection.show();
            className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
            oldSection = $("#" + Constant.Paging.ROOT_ID).find("." + className + ":first");
            oldSection.hide();
            if (window.debug) {
              console.log('[selectPage] deleted pageNum:' + beforePageNum);
            }
            Common.removeAllItem(beforePageNum);
            if (created) {
              OperationHistory.add(true);
            }
            LocalStorage.saveAllPageValues();
            _this.createPageSelectMenu();
            Common.hideModalView();
            if (callback != null) {
              return callback();
            }
          });
        });
      };
    })(this));
  };

  Paging.createNewFork = function() {
    return WorktableCommon.stopAllEventPreview((function(_this) {
      return function() {
        PageValue.setForkNum(PageValue.getForkCount() + 1);
        PageValue.setEventPageValue(PageValue.Key.eventCount(), 0);
        PageValue.updateForkCount();
        OperationHistory.add(true);
        LocalStorage.saveAllPageValues();
        _this.createPageSelectMenu();
        return Timeline.refreshAllTimeline();
      };
    })(this));
  };

  Paging.selectFork = function(selectedForkNum, callback) {
    if (callback == null) {
      callback = null;
    }
    if ((selectedForkNum == null) || selectedForkNum === PageValue.getForkNum()) {
      if (callback != null) {
        callback();
      }
      return;
    }
    return WorktableCommon.stopAllEventPreview(function() {
      PageValue.setForkNum(selectedForkNum);
      if (selectedForkNum === PageValue.Key.EF_MASTER_FORKNUM) {
        if (callback != null) {
          return callback();
        }
      } else {
        return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
          if (callback != null) {
            return callback();
          }
        });
      }
    });
  };

  Paging.removePage = function(pageNum, callback) {
    var _removePage;
    if (callback == null) {
      callback = null;
    }
    if (pageNum <= 1) {
      if (callback != null) {
        callback();
      }
      return;
    }
    _removePage = function(pageNum) {
      return WorktableCommon.removePage(pageNum, (function(_this) {
        return function() {
          LocalStorage.saveAllPageValues();
          _this.createPageSelectMenu();
          if (callback != null) {
            return callback();
          }
        };
      })(this));
    };
    if (pageNum === PageValue.getPageNum()) {
      return this.selectPage(pageNum - 1, PageValue.Key.EF_MASTER_FORKNUM, (function(_this) {
        return function() {
          return _removePage.call(_this);
        };
      })(this));
    } else {
      return _removePage.call(this);
    }
  };

  return Paging;

})();

//# sourceMappingURL=paging.js.map
