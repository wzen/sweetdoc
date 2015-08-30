// Generated by CoffeeScript 1.9.2
var Navbar;

Navbar = (function() {
  function Navbar() {}

  Navbar.initWorktableNavbar = function() {
    var etcMenuEmt, fileMenuEmt, itemsSelectMenuEmt;
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
    $('.menu-newcreate', fileMenuEmt).on('click', function() {
      if (Object.keys(window.instanceMap).length > 0) {
        if (window.confirm('ページ内に存在するアイテムは全て削除されます。')) {
          return WorktableCommon.removeAllItemAndEventOnThisPage();
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
    return $('.menu-item', itemsSelectMenuEmt).on('click', function() {
      var itemId;
      itemId = parseInt($(this).attr('id').replace('menu-item-', ''));
      itemsSelectMenuEmt.removeClass('active');
      $(this).parent('li').addClass('active');
      window.selectItemMenu = itemId;
      changeMode(Constant.Mode.DRAW);
      return WorktableCommon.loadItemJs(itemId);
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
