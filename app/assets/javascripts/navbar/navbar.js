// Generated by CoffeeScript 1.9.2
var Navbar;

Navbar = (function() {
  var constant;

  function Navbar() {}

  constant = gon["const"];

  Navbar.NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT;

  Navbar.ITEM_MENU_PREFIX = 'menu-item-';

  Navbar.FILE_LOAD_CLASS = constant.ElementAttribute.FILE_LOAD_CLASS;

  Navbar.LAST_UPDATE_TIME_CLASS = constant.ElementAttribute.LAST_UPDATE_TIME_CLASS;

  Navbar.initWorktableNavbar = function() {
    var etcMenuEmt, fileMenuEmt, itemsSelectMenuEmt, menuSave;
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
    $('.menu-changeproject', fileMenuEmt).off('click').on('click', function() {
      var _cbk, lastSaveTime, lastSaveTimeStr;
      _cbk = function() {
        return ServerStorage.save((function(_this) {
          return function() {
            WorktableCommon.resetWorktable();
            Navbar.switchWorktableNavbarWhenProjectCreated(false);
            return Common.showModalView(Constant.ModalViewType.INIT_PROJECT, true, Project.initProjectModal);
          };
        })(this));
      };
      if (Object.keys(window.instanceMap).length > 0 || PageValue.getPageCount() >= 2) {
        lastSaveTimeStr = '';
        lastSaveTime = Common.displayLastUpdateDiffAlmostTime();
        if (lastSaveTime != null) {
          lastSaveTimeStr = '\n' + I18n.t('message.dialog.last_savetime') + lastSaveTime;
        }
        if (window.confirm(I18n.t('message.dialog.change_project') + lastSaveTimeStr)) {
          return _cbk.call(this);
        }
      } else {
        return _cbk.call(this);
      }
    });
    $('.menu-adminproject', fileMenuEmt).off('click').on('click', function() {
      return Common.showModalView(Constant.ModalViewType.ADMIN_PROJECTS, true, Project.initAdminProjectModal);
    });
    menuSave = $('.menu-save', fileMenuEmt);
    menuSave.off('click').on('click', function() {
      return ServerStorage.save();
    });
    menuSave.off('mouseenter').on('mouseenter', function(e) {
      var lastSaveTime, li;
      lastSaveTime = Common.displayLastUpdateDiffAlmostTime();
      if (lastSaveTime != null) {
        li = this.closest('li');
        $(li).append($("<div class='pop' style='display:none'><p>Last Save " + lastSaveTime + "</p></div>"));
        $('.pop', li).css({
          top: $(li).height() + 30,
          left: $(li).width()
        });
        return $('.pop', li).show();
      }
    });
    menuSave.off('mouseleave').on('mouseleave', function(e) {
      var ul;
      ul = this.closest('ul');
      return $('.pop', ul).remove();
    });
    $('.menu-load', fileMenuEmt).off('mouseenter').on('mouseenter', function() {
      return Navbar.get_load_list();
    });
    etcMenuEmt = $('#header_etc_select_menu .dropdown-menu > li');
    $('.menu-about', etcMenuEmt).off('click').on('click', function() {
      return Common.showModalView(Constant.ModalViewType.ABOUT);
    });
    $('.menu-backtomainpage', etcMenuEmt).off('click').on('click', function() {
      return window.location.href = '/';
    });
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
    $('.menu-item', itemsSelectMenuEmt).off('click').on('click', function() {
      var classDistToken, emtId, selected;
      selected = $(this).html();
      $('#header_items_selected_menu_span').html(selected);
      WorktableCommon.refreshAllItemsFromInstancePageValueIfChanging();
      WorktableCommon.clearSelectedBorder();
      emtId = $(this).attr('id');
      if (emtId.indexOf(Navbar.ITEM_MENU_PREFIX) >= 0) {
        classDistToken = emtId.replace(Navbar.ITEM_MENU_PREFIX, '');
        return Navbar.setModeDraw(classDistToken, (function(_this) {
          return function() {
            return WorktableCommon.changeMode(Constant.Mode.DRAW);
          };
        })(this));
      }
    });
    $('#menu-action-edit').off('click').on('click', function() {
      Navbar.setModeEdit();
      return WorktableCommon.changeMode(Constant.Mode.EDIT);
    });
    return $('#menu_sidebar_toggle').off('click').on('click', function() {
      if (Sidebar.isOpenedConfigSidebar()) {
        return Sidebar.closeSidebar();
      } else {
        Sidebar.switchSidebarConfig(Sidebar.Type.STATE);
        StateConfig.initConfig();
        WorktableSetting.initConfig();
        ItemStateConfig.initConfig();
        return Sidebar.openStateConfig();
      }
    });
  };

  Navbar.switchWorktableNavbarWhenProjectCreated = function(flg) {
    var root;
    if (flg) {
      root = $('#header_items_file_menu');
      $(".menu-save-li", root).show();
      $('#header_items_select_menu').show();
      $('#header_items_motion_check').show();
      $('#menu_sidebar_toggle').show();
      $("#" + Constant.Paging.NAV_ROOT_ID).show();
      $('#menu_sidebar_toggle_li').show();
      return $("#" + this.NAVBAR_ROOT + " ." + this.LAST_UPDATE_TIME_CLASS).closest('li').show();
    } else {
      $(".menu-save-li", root).hide();
      $('#header_items_select_menu').hide();
      $('#header_items_motion_check').hide();
      $('#menu_sidebar_toggle').hide();
      $("#" + Constant.Paging.NAV_ROOT_ID).hide();
      $('#menu_sidebar_toggle_li').hide();
      return $("#" + this.NAVBAR_ROOT + " ." + this.LAST_UPDATE_TIME_CLASS).closest('li').hide();
    }
  };

  Navbar.initRunNavbar = function() {
    var navEmt;
    navEmt = $('#nav');
    $('.menu-showguide', navEmt).off('click').on('click', function() {
      return RunSetting.toggleShowGuide();
    });
    $('.menu-control-rewind-page', navEmt).off('click').on('click', function() {
      if (window.eventAction != null) {
        return window.eventAction.thisPage().rewindAllChapters();
      }
    });
    $('.menu-control-rewind-chapter', navEmt).off('click').on('click', function() {
      if (window.eventAction != null) {
        return window.eventAction.thisPage().rewindChapter();
      }
    });
    return $('.menu-upload-gallery', navEmt).off('click').on('click', function() {
      return RunCommon.showUploadGalleryConfirm();
    });
  };

  Navbar.initCodingNavbar = function() {
    var fileMenuEmt, menuSave;
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
    menuSave = $('.menu-save', fileMenuEmt);
    menuSave.off('click').on('click', function() {
      return CodingCommon.saveActiveCode();
    });
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
    menuSave = $('.menu-all-save', fileMenuEmt);
    return menuSave.off('click').on('click', function() {
      return CodingCommon.saveAllCode();
    });
  };

  Navbar.initItemPreviewNavbar = function() {
    var navEmt;
    navEmt = $('#nav');
    $('.menu-upload-item', navEmt).off('click').on('click', function() {
      return ItemPreviewCommon.showUploadItemConfirm();
    });
    return $('.menu-add-item', navEmt).off('click').on('click', function() {
      return ItemPreviewCommon.showAddItemConfirm();
    });
  };

  Navbar.setModeDraw = function(classDistToken, callback) {
    var emtId, itemsSelectMenuEmt, menuItem;
    if (callback == null) {
      callback = null;
    }
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
    itemsSelectMenuEmt.removeClass('active');
    emtId = "menu-item-" + classDistToken;
    menuItem = $("#" + emtId);
    menuItem.parent('li').addClass('active');
    $('#header_items_selected_menu_span').html(menuItem.html());
    window.selectItemMenu = classDistToken;
    return Common.loadItemJs(classDistToken, callback);
  };

  Navbar.setModeEdit = function() {
    var itemsSelectMenuEmt, selected;
    selected = $('#menu-action-edit').html();
    $('#header_items_selected_menu_span').html(selected);
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
    itemsSelectMenuEmt.removeClass('active');
    return $('#menu-action-edit').parent('li').addClass('active');
  };

  Navbar.setTitle = function(title_name) {
    if (!window.isWorkTable) {
      title_name += '(Preview)';
    }
    $("#" + Navbar.NAVBAR_ROOT).find('.nav_title').html(title_name);
    if ((title_name != null) && title_name.length > 0) {
      return document.title = title_name;
    } else {
      return document.title = window.appName;
    }
  };

  Navbar.get_load_list = function() {
    var diffTime, loadEmt, loadedLocalTime, s, updateFlg;
    loadEmt = $("#" + Navbar.NAVBAR_ROOT).find("." + ServerStorage.ElementAttribute.FILE_LOAD_CLASS);
    updateFlg = loadEmt.find("." + ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG).length > 0;
    if (updateFlg) {
      loadedLocalTime = loadEmt.find("." + ServerStorage.ElementAttribute.LOADED_LOCALTIME);
      if (loadedLocalTime != null) {
        diffTime = Common.calculateDiffTime($.now(), parseInt(loadedLocalTime.val()));
        s = diffTime.seconds;
        if (window.debug) {
          console.log('loadedLocalTime diff ' + s);
        }
        if (parseInt(s) <= ServerStorage.ElementAttribute.LOAD_LIST_INTERVAL_SECONDS) {
          return;
        }
      }
    }
    loadEmt.children().remove();
    $("<li><a class='menu-item'>Loading...</a></li>").appendTo(loadEmt);
    return ServerStorage.get_load_data(function(data) {
      var d, e, i, len, list, n, p, user_pagevalue_list;
      user_pagevalue_list = data.user_pagevalue_list;
      if (user_pagevalue_list.length > 0) {
        list = '';
        n = $.now();
        for (i = 0, len = user_pagevalue_list.length; i < len; i++) {
          p = user_pagevalue_list[i];
          d = new Date(p['updated_at']);
          e = "<li><a class='menu-item'>" + (Common.displayDiffAlmostTime(n, d.getTime())) + " (" + (Common.formatDate(d)) + ")</a><input type='hidden' class='user_pagevalue_id' value=" + p['id'] + "></li>";
          list += e;
        }
        loadEmt.children().remove();
        $(list).appendTo(loadEmt);
        loadEmt.find('li').off('click');
        loadEmt.find('li').on('click', function(e) {
          var user_pagevalue_id;
          user_pagevalue_id = $(this).find('.user_pagevalue_id:first').val();
          return Project.load(user_pagevalue_id);
        });
        loadEmt.find("." + ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG).remove();
        loadEmt.find("." + ServerStorage.ElementAttribute.LOADED_LOCALTIME).remove();
        $("<input type='hidden' class=" + ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG + " value='1'>").appendTo(loadEmt);
        return $("<input type='hidden' class=" + ServerStorage.ElementAttribute.LOADED_LOCALTIME + " value=" + ($.now()) + ">").appendTo(loadEmt);
      } else {
        loadEmt.children().remove();
        return $("<li><a class='menu-item'>No Data</a></li>").appendTo(loadEmt);
      }
    }, function() {
      if (window.debug) {
        console.log(data.responseText);
      }
      loadEmt.children().remove();
      return $("<li><a class='menu-item'>Server Access Error</a></li>").appendTo(loadEmt);
    });
  };

  Navbar.setLastUpdateTime = function(update_at) {
    return $("#" + this.NAVBAR_ROOT + " ." + this.LAST_UPDATE_TIME_CLASS).html((I18n.t('header_menu.etc.last_update_date')) + " : " + (Common.displayLastUpdateTime(update_at)));
  };

  Navbar.disabledOperation = function(flg) {
    if (flg) {
      if ($("#" + this.NAVBAR_ROOT + " .cover_touch_overlay").length === 0) {
        $("#" + this.NAVBAR_ROOT).append("<div class='cover_touch_overlay'></div>");
        return $('.cover_touch_overlay').off('click').on('click', function(e) {
          e.preventDefault();
        });
      }
    } else {
      return $("#" + this.NAVBAR_ROOT + " .cover_touch_overlay").remove();
    }
  };

  return Navbar;

})();

//# sourceMappingURL=navbar.js.map
