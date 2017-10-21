import Common from '../base/common';
import PageValue from '../base/page_value';
import FloatView from '../base/float_view';
import ServerStorage from '../worktable/common/server_storage';

let constant = gon.const;
export default class Navbar {
  static initClass() {
    // 定数
    // @property [String] NAVBAR_ROOT ナビヘッダーRoot
    this.NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT;
    // @property [String] ITEM_MENU_PREFIX アイテムメニュープレフィックス
    this.ITEM_MENU_PREFIX = 'menu-item-';
    // @property [String] FILE_LOAD_CLASS ファイル読み込み クラス名
    this.FILE_LOAD_CLASS = constant.ElementAttribute.FILE_LOAD_CLASS;
    // @property [String] LAST_UPDATE_TIME_CLASS 最新更新日 クラス名
    this.LAST_UPDATE_TIME_CLASS = constant.ElementAttribute.LAST_UPDATE_TIME_CLASS;
  }

  // Worktableナビバー初期化
  static initWorktableNavbar() {
    Promise.all([
      import('../worktable/common/worktable_common'),
      import('../sidebar_config/sidebar_ui'),
      import('../base/project')
    ]).then(([loaded, loaded2, loaded3]) => {
      const WorktableCommon = loaded.default;
      const Sidebar = loaded2.default;
      const Project = loaded3.default;
      const fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
      $('.menu-changeproject', fileMenuEmt).off('click').on('click', function() {
        const _cbk = () =>
          // データを保存
          ServerStorage.save(() => {
            WorktableCommon.resetWorktable();
            // ナビバーをプロジェクト作成前状態に
            Navbar.switchWorktableNavbarWhenProjectCreated(false);
            // 初期モーダル表示
            return Common.showModalView(constant.ModalViewType.INIT_PROJECT, true, Project.initProjectModal);
          })
        ;

        if((Object.keys(window.instanceMap).length > 0) || (PageValue.getPageCount() >= 2)) {
          let lastSaveTimeStr = '';
          const lastSaveTime = Common.displayLastUpdateDiffAlmostTime();
          if(lastSaveTime !== null) {
            lastSaveTimeStr = `\n${I18n.t('message.dialog.last_savetime')}${lastSaveTime}`;
          }
          if(window.confirm(I18n.t('message.dialog.change_project') + lastSaveTimeStr)) {
            return _cbk.call(this);
          }
        } else {
          return _cbk.call(this);
        }
      });
      $('.menu-adminproject', fileMenuEmt).off('click').on('click', () =>
        // モーダル表示
        Common.showModalView(constant.ModalViewType.ADMIN_PROJECTS, false, Project.initAdminProjectModal)
      );
      const menuSave = $('.menu-save', fileMenuEmt);
      menuSave.off('click').on('click', () => ServerStorage.save());
      menuSave.off('mouseenter').on('mouseenter', function(e) {
        const lastSaveTime = Common.displayLastUpdateDiffAlmostTime();
        if(lastSaveTime !== null) {
          const li = this.closest('li');
          $(li).append($(`<div class='pop' style='display:none'><p>Last Save ${lastSaveTime}</p></div>`));
          $('.pop', li).css({top: $(li).height() + 30, left: $(li).width()});
          return $('.pop', li).show();
        }
      });
      menuSave.off('mouseleave').on('mouseleave', function(e) {
        const ul = this.closest('ul');
        return $('.pop', ul).remove();
      });
      $('.menu-load', fileMenuEmt).off('mouseenter').on('mouseenter', () => Navbar.get_load_list());
      const etcMenuEmt = $('#header_etc_select_menu .dropdown-menu > li');
      $('.menu-about', etcMenuEmt).off('click').on('click', () => Common.showModalView(constant.ModalViewType.ABOUT));
      $('.menu-backtomainpage', etcMenuEmt).off('click').on('click', () => window.location.href = '/');
      const itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
      $('.menu-item', itemsSelectMenuEmt).off('click').on('click', function(e) {
        if($(this).hasClass('href')) {
          const d = $(this).attr('disabled');
          if(d !== null) {
            return false;
          }
          return;
        }
        Sidebar.closeSidebar();
        const selected = $(this).html();
        $('#header_items_selected_menu_span').html(selected);
        // 選択枠削除
        WorktableCommon.clearSelectedBorder();
        const emtId = $(this).attr('id');
        if(emtId.indexOf(Navbar.ITEM_MENU_PREFIX) >= 0) {
          const classDistToken = emtId.replace(Navbar.ITEM_MENU_PREFIX, '');
          Navbar.setModeDraw(classDistToken, () => {
            WorktableCommon.changeMode(constant.Mode.DRAW);
          });
        }
      });
      $('#menu-action-edit').off('click').on('click', function() {
        Sidebar.closeSidebar();
        Navbar.setModeEdit();
        WorktableCommon.changeMode(constant.Mode.EDIT);
      });
      $('#menu_sidebar_toggle').off('click').on('click', function() {
        if(Sidebar.isOpenedConfigSidebar()) {
          return Sidebar.closeSidebar();
        } else {
          Sidebar.switchSidebarConfig(Sidebar.Type.STATE);
          const navTab = $('#tab-config .nav-tabs');
          // コンフィグ初期化
          let activeConfig = navTab.find('li.active');
          if(activeConfig.hasClass('beginning_event_state')) {
            import('../sidebar_config/state_config').then(l => {l.default.initConfig();})
          } else if(activeConfig.hasClass('worktable_setting')) {
            import('../worktable/common/worktable_setting').then(l => {l.default.initConfig();})
          } else if(activeConfig.hasClass('item_state')) {
            import('../sidebar_config/item_state_config').then(l => {l.default.initConfig();})
          }
          // タブ選択時イベントの設定
          navTab.find('li > a').off('click.init').on('click.init', e => {
            // 選択枠を削除
            WorktableCommon.clearSelectedBorder();
            // イベントポインタ削除
            WorktableCommon.clearEventPointer();
            activeConfig = $(e.target).closest('li');
            if(activeConfig.hasClass('beginning_event_state')) {
              import('../sidebar_config/state_config').then(l => {l.default.initConfig();})
            } else if(activeConfig.hasClass('worktable_setting')) {
              import('../worktable/common/worktable_setting').then(l => {l.default.initConfig();})
            } else if(activeConfig.hasClass('item_state')) {
              import('../sidebar_config/item_state_config').then(l => {l.default.initConfig();})
            }
          });
          Sidebar.openStateConfig();
        }
      });
    });
  }

  static switchWorktableNavbarWhenProjectCreated(flg) {
    let root;
    if(flg) {
      import('../base/project').then(loaded => {
        const Project = loaded.default;
        root = $('#header_items_file_menu');
        // プロジェクト作成後のナビバーに表示変更
        $(".menu-save-li", root).show();
        if(Project.isSampleProject()) {
          $(".menu-save-li", root).addClass('disabled');
          $(".menu-save", root).attr('disabled', 'disabled');
          $(".last_update_time_li", root).hide();
        } else {
          $(".menu-save-li", root).removeClass('disabled');
          $(".menu-save", root).removeAttr('disabled');
          $(".last_update_time_li", root).show();
        }
        $('#header_items_select_menu').show();
        $('#header_items_motion_check').show();
        $('#menu_sidebar_toggle').show();
        $(`#${constant.Paging.NAV_ROOT_ID}`).show();
        $('#menu_sidebar_toggle_li').show();
        $(`#${this.NAVBAR_ROOT} .${this.LAST_UPDATE_TIME_CLASS}`).closest('li').show();
      });
    } else {
      // プロジェクト作成前のナビバーに表示変更
      $(".menu-save-li", root).hide();
      $('#header_items_select_menu').hide();
      $('#header_items_motion_check').hide();
      $('#menu_sidebar_toggle').hide();
      $(`#${constant.Paging.NAV_ROOT_ID}`).hide();
      $('#menu_sidebar_toggle_li').hide();
      $(`#${this.NAVBAR_ROOT} .${this.LAST_UPDATE_TIME_CLASS}`).closest('li').hide();
    }
  }

  // Runナビバー初期化
  static initRunNavbar() {
    Promise.all([
      import('../run/common/run_common'),
      import('../run/common/run_setting')
    ]).then(([loaded, loaded2]) => {
      const RunCommon = loaded.default;
      const RunSetting = loaded2.default;
      const navEmt = $('#nav');
      $('.menu-screenSize', navEmt).off('click').on('click', () =>
        Common.showModalView(constant.ModalViewType.CHANGE_SCREEN_SIZE, false, (modalEmt, params, callback = null) => {
          // 設定
          let size;
          const radio = $('.display_size_wrapper input[type=radio]', modalEmt);
          radio.val(Common.isFixedScreenSize() ? ['input'] : ['default']);
          if(Common.isFixedScreenSize()) {
            size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
            $('.display_size_input_width', modalEmt).val(size.width);
            $('.display_size_input_height', modalEmt).val(size.height);
          }
          radio.off('change').on('change', () => $('.display_size_input_wrapper', modalEmt).css('display', radio.filter(':checked').val() === 'input' ? 'block' : 'none')).trigger('change');
          $('.update_button', modalEmt).off('click').on('click', () => {
            const beforeSize = Common.getScreenSize();
            // PageValueに設定
            if(radio.filter(':checked').val() === 'input') {
              const width = $('.display_size_input_width:first', modalEmt).val();
              const height = $('.display_size_input_height:first', modalEmt).val();
              if((width !== null) && (height !== null) && (width > 0) && (height > 0)) {
                size = {
                  width,
                  height
                };
                PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, size);
              } else {
                FloatView.show('Please input size', FloatView.Type.ERROR, 3.0);
              }
            } else {
              PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {});
            }
            // 変更反映
            Common.initScreenSize();
            // スクリーン位置調整
            RunCommon.adjustScrollPositionWhenScreenSizeChanging(beforeSize, Common.getScreenSize());
            return Common.hideModalView();
          });
          $('.cancel_button', modalEmt).off('click').on('click', () => {
            return Common.hideModalView();
          });
          if(callback !== null) {
            return callback();
          }
        })
      );
      $('.menu-showguide', navEmt).off('click').on('click', () => RunSetting.toggleShowGuide());
      $('.menu-control-rewind-page', navEmt).off('click').on('click', function() {
        if(window.eventAction !== null) {
          return window.eventAction.thisPage().rewindAllChapters();
        }
      });
      $('.menu-control-rewind-chapter', navEmt).off('click').on('click', function() {
        if(window.eventAction !== null) {
          return window.eventAction.thisPage().rewindChapter();
        }
      });
      return $('.menu-upload-gallery', navEmt).off('click').on('click', e => {
        e.preventDefault();
        e.stopPropagation();
        if(!$(e.target).closest('.menu-upload-gallery').hasClass('disabled')) {
          return RunCommon.showUploadGalleryConfirm();
        }
      });
    });
  }

  // Codingナビバー初期化
  static initCodingNavbar() {
    import('../coding/coding_common').then(loaded => {
      const CodingCommon = loaded.default;
      let fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
      let menuSave = $('.menu-save', fileMenuEmt);
      menuSave.off('click').on('click', () => CodingCommon.saveActiveCode());
      fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
      menuSave = $('.menu-all-save', fileMenuEmt);
      menuSave.off('click').on('click', () => CodingCommon.saveAllCode());
    });
  }

  // アイテムプレビューナビバー初期化
  static initItemPreviewNavbar() {
    import('../item_preview/item_preview_common').then(loaded => {
      const ItemPreviewCommon = loaded.default;
      const navEmt = $('#nav');
      $('.menu-upload-item', navEmt).off('click').on('click', () => ItemPreviewCommon.showUploadItemConfirm());
      $('.menu-add-item', navEmt).off('click').on('click', () => ItemPreviewCommon.showAddItemConfirm());
    });
  }

  // Drawモードに設定
  static setModeDraw(classDistToken, callback = null) {
    const itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
    itemsSelectMenuEmt.removeClass('active');
    const emtId = `menu-item-${classDistToken}`;
    const menuItem = $(`#${emtId}`);
    menuItem.parent('li').addClass('active');
    $('#header_items_selected_menu_span').html(menuItem.html());
    window.selectItemMenu = classDistToken;
    return Common.loadItemJs(classDistToken, callback);
  }

  // Editモードに設定
  static setModeEdit() {
    const selected = $('#menu-action-edit').html();
    $('#header_items_selected_menu_span').html(selected);
    const itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
    itemsSelectMenuEmt.removeClass('active');
    return $('#menu-action-edit').parent('li').addClass('active');
  }

  // ヘッダーにタイトルを設定
  static setTitle(title_name) {
    if(!window.isWorkTable) {
      title_name += '(Preview)';
    }
    $(`#${Navbar.NAVBAR_ROOT}`).find('.nav_title').html(title_name);
    if((title_name !== null) && (title_name.length > 0)) {
      return document.title = title_name;
    } else {
      return document.title = window.appName;
    }
  }

  // 保存されているデータ一覧を取得してNavbarに一覧で表示
  static get_load_list() {
    const loadEmt = $(`#${Navbar.NAVBAR_ROOT}`).find(`.${ServerStorage.ElementAttribute.FILE_LOAD_CLASS}`);
    const updateFlg = loadEmt.find(`.${ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}`).length > 0;
    if(updateFlg) {
      const loadedLocalTime = loadEmt.find(`.${ServerStorage.ElementAttribute.LOADED_LOCALTIME}`);
      if(loadedLocalTime !== null) {
        const diffTime = Common.calculateDiffTime($.now(), parseInt(loadedLocalTime.val()));
        const s = diffTime.seconds;
        if(window.debug) {
          console.log(`loadedLocalTime diff ${s}`);
        }
        if(parseInt(s) <= ServerStorage.ElementAttribute.LOAD_LIST_INTERVAL_SECONDS) {
          // 読み込んでX秒以内ならロードしない
          return;
        }
      }
    }

    loadEmt.children().remove();
    $("<li><a class='menu-item'>Loading...</a></li>").appendTo(loadEmt);

    ServerStorage.get_load_data(function(data) {
        const {user_pagevalue_list} = data;
        if(user_pagevalue_list.length > 0) {
          let list = '';
          const n = $.now();
          for(let p of Array.from(user_pagevalue_list)) {
            const d = new Date(p['updated_at']);
            const e = `<li><a class='menu-item'>${Common.displayDiffAlmostTime(n, d.getTime())} (${Common.formatDate(d)})</a><input type='hidden' class='user_pagevalue_id' value=${p['id']}></li>`;
            list += e;
          }
          loadEmt.children().remove();
          $(list).appendTo(loadEmt);
          // クリックイベント設定
          loadEmt.find('li').off('click');
          loadEmt.find('li').on('click', function(e) {
            const user_pagevalue_id = $(this).find('.user_pagevalue_id:first').val();
            import('../base/project').then(loaded => {loaded.default.load(user_pagevalue_id);})
          });

          // ロード済みに変更 & 現在時間を記録
          loadEmt.find(`.${ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}`).remove();
          loadEmt.find(`.${ServerStorage.ElementAttribute.LOADED_LOCALTIME}`).remove();
          $(`<input type='hidden' class=${ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG} value='1'>`).appendTo(loadEmt);
          return $(`<input type='hidden' class=${ServerStorage.ElementAttribute.LOADED_LOCALTIME} value=${$.now()}>`).appendTo(loadEmt);

        } else {
          loadEmt.children().remove();
          return $("<li><a class='menu-item'>No Data</a></li>").appendTo(loadEmt);
        }
      }
      ,
      function() {
        if(window.debug) {
          console.log(data.responseText);
        }
        loadEmt.children().remove();
        return $("<li><a class='menu-item'>Server Access Error</a></li>").appendTo(loadEmt);
      });
  }

  static setLastUpdateTime(update_at) {
    return $(`#${this.NAVBAR_ROOT} .${this.LAST_UPDATE_TIME_CLASS}`).html(`${I18n.t('header_menu.etc.last_update_date')} : ${Common.displayLastUpdateTime(update_at)}`);
  }

  // 操作不可にする
  static disabledOperation(flg) {
    if(flg) {
      if($(`#${this.NAVBAR_ROOT} .cover_touch_overlay`).length === 0) {
        $(`#${this.NAVBAR_ROOT}`).append("<div class='cover_touch_overlay'></div>");
        return $('.cover_touch_overlay').off('click').on('click', function(e) {
          e.preventDefault();
        });
      }
    } else {
      return $(`#${this.NAVBAR_ROOT} .cover_touch_overlay`).remove();
    }
  }

  // アイテム選択をデフォルトに戻す
  static setDefaultItemSelect() {
    window.mode = constant.Mode.NOT_SELECT;
    return $('#header_items_selected_menu_span').html(I18n.t('header_menu.action.select_action'));
  }
};
Navbar.initClass();
