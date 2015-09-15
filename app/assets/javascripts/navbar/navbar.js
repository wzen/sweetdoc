// Generated by CoffeeScript 1.9.2
var Navbar;

Navbar = (function() {
  function Navbar() {}

  Navbar.NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT;

  Navbar.ITEM_MENU_PREFIX = 'menu-item-';

  Navbar.initWorktableNavbar = function() {
    var etcMenuEmt, fileMenuEmt, itemsSelectMenuEmt;
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
    $('.menu-newcreate', fileMenuEmt).off('click');
    $('.menu-newcreate', fileMenuEmt).on('click', function() {
      if (Object.keys(window.instanceMap).length > 0 || PageValue.getPageCount() >= 2) {
        if (window.confirm(I18n.t('message.dialog.new_project'))) {
          return WorktableCommon.recreateMainContainer();
        }
      }
    });
    $('.menu-load', fileMenuEmt).off('mouseenter');
    $('.menu-load', fileMenuEmt).on('mouseenter', function() {
      return ServerStorage.get_load_list();
    });
    $('.menu-save', fileMenuEmt).off('click');
    $('.menu-save', fileMenuEmt).on('click', function() {
      return ServerStorage.save();
    });
    $('.menu-setting', fileMenuEmt).off('click');
    $('.menu-setting', fileMenuEmt).on('click', function() {
      Sidebar.switchSidebarConfig('setting');
      Setting.initConfig();
      return Sidebar.openConfigSidebar();
    });
    etcMenuEmt = $('#header_etc_select_menu .dropdown-menu > li');
    $('.menu-about', etcMenuEmt).off('click');
    $('.menu-about', etcMenuEmt).on('click', function() {
      return Common.showModalView(Constant.ModalViewType.ABOUT);
    });
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
    $('.menu-item', itemsSelectMenuEmt).click(function() {
      var emtId, itemId;
      WorktableCommon.reDrawAllInstanceItemIfChanging();
      emtId = $(this).attr('id');
      if (emtId.indexOf(Navbar.ITEM_MENU_PREFIX) >= 0) {
        itemId = parseInt(emtId.replace(Navbar.ITEM_MENU_PREFIX, ''));
        itemsSelectMenuEmt.removeClass('active');
        $(this).parent('li').addClass('active');
        window.selectItemMenu = itemId;
        WorktableCommon.changeMode(Constant.Mode.DRAW);
        return Common.loadItemJs(itemId);
      }
    });
    $('#header_items_select_menu .menu-item').click(function() {
      var selected;
      selected = $(this).html();
      return $('#header_items_selected_menu_span').html(selected);
    });
    return $('#menu-action-edit').click(function() {
      return WorktableCommon.changeMode(Constant.Mode.EDIT);
    });
  };

  Navbar.initRunNavbar = function() {
    var navEmt;
    navEmt = $('#nav');
    $('.menu-control-rewind-page', navEmt).off('click');
    $('.menu-control-rewind-page', navEmt).on('click', function() {
      if (window.eventAction != null) {
        return window.eventAction.thisPage().rewindAllChapters();
      }
    });
    $('.menu-control-rewind-chapter', navEmt).off('click');
    return $('.menu-control-rewind-chapter', navEmt).on('click', function() {
      if (window.eventAction != null) {
        return window.eventAction.thisPage().rewindChapter();
      }
    });
  };

  Navbar.setPageNum = function(value) {
    var e, navEmt;
    navEmt = $('#nav');
    e = $('.nav_page_num', navEmt);
    if (e != null) {
      return e.html(value);
    } else {
      return e.html('');
    }
  };

  Navbar.setChapterNum = function(value) {
    var e, navEmt;
    navEmt = $('#nav');
    e = $('.nav_chapter_num', navEmt);
    if (e != null) {
      return e.html(value);
    } else {
      return e.html('');
    }
  };

  Navbar.setPageMax = function(page_max) {
    var e, navEmt;
    navEmt = $('#nav');
    e = $('.nav_page_max', navEmt);
    if (e != null) {
      return e.html(page_max);
    } else {
      return e.html('');
    }
  };

  Navbar.setChapterMax = function(chapter_max) {
    var e, navEmt;
    navEmt = $('#nav');
    e = $('.nav_chapter_max', navEmt);
    if (e != null) {
      return e.html(chapter_max);
    } else {
      return e.html('');
    }
  };

  return Navbar;

})();

//# sourceMappingURL=navbar.js.map
