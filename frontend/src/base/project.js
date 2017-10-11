/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
var Project = (function() {
  let _project_select_options = undefined;
  Project = class Project {
    static initClass() {

      _project_select_options = function(user_pagevalue_list) {
        let d, p;
        let list = '';
        const n = $.now();
        let l = $.grep(user_pagevalue_list, u => u['p_is_sample'] === 0);
        if(l.length > 0) {
          list += `<optgroup label='${I18n.t('modal.not_sample_project')}'>`;
          for(p of Array.from(l)) {
            d = new Date(p['up_updated_at']);
            list += `<option value='${p['up_id']}'>${p['p_title']} - ${Common.displayDiffAlmostTime(n, d.getTime())}</option>`;
          }
          list += "</optgroup>";
        }
        l = $.grep(user_pagevalue_list, u => u['p_is_sample'] === 1);
        if(l.length > 0) {
          list += `<optgroup label='${I18n.t('modal.sample_project')}'>`;
          for(p of Array.from(l)) {
            d = new Date(p['up_updated_at']);
            list += `<option value='${p['up_id']}'>${p['p_title']}</option>`;
          }
          list += "</optgroup>";
        }
        return list;
      };
    }

    // プロジェクト更新
    static updateProjectInfo(info) {
      const {projectName} = info;
      // プロジェクト情報初期化
      Project.initProjectValue(projectName);
      // プロジェクト名設定
      Common.setTitle(projectName);
      // 環境更新
      return Common.applyEnvironmentFromPagevalue();
    }

    // プロジェクト作成時モーダルビュー初期化
    static initProjectModal(modalEmt, params, callback = null) {

      const _modalSize = function(type) {
        let width;
        if(type === 'new') {
          width = 424;
        } else {
          width = 424;
        }
        return {width};
      };

      // ラジオボタンイベント
      $('.project_create_wrapper input[type=radio]', modalEmt).off('click').on('click', function() {
        $('.display_project_new_wrapper', modalEmt).css('display', $(this).val() === 'new' ? 'block' : 'none');
        $('.display_project_select_wrapper', modalEmt).css('display', $(this).val() === 'select' ? 'block' : 'none');
        const size = _modalSize($(this).val());
        modalEmt.animate(null, {width: `${size.width}px`, height: `${size.height}px`}, {duration: 300, queue: false});
        Common.modalCentering(true, size);
        $('.button_wrapper span', modalEmt).hide();
        $(`.button_wrapper .${$(this).val()}`, modalEmt).show();
        return Project.hideError(modalEmt);
      });
      // 作成済みプロジェクト一覧取得
      Project.load_data_order_last_updated(data => {
        let size;
        const {user_pagevalue_list} = data;
        const projectSelect = $('.project_select', modalEmt);
        if(user_pagevalue_list.length > 0) {
          const list = _project_select_options.call(this, user_pagevalue_list);
          projectSelect.children().remove();
          $(list).appendTo(projectSelect);
          $('.project_create_wrapper input[type=radio][value=select]', modalEmt).prop('checked', true);
          $('.display_project_new_wrapper', modalEmt).hide();
          $('.display_project_select_wrapper', modalEmt).show();
          $(".button_wrapper .select", modalEmt).show();
          $('.button_wrapper span', modalEmt).hide();
          $(".button_wrapper .select", modalEmt).show();
          size = _modalSize('select');
          modalEmt.css({width: size.width, height: size.height});
          $('.project_create_wrapper', modalEmt).show();
          Common.modalCentering();
          if(callback !== null) {
            return callback();
          }
        } else {
          projectSelect.children().remove();
          $('.project_create_wrapper input[type=radio][value=new]', modalEmt).prop('checked', true);
          $('.display_project_new_wrapper', modalEmt).show();
          $('.display_project_select_wrapper', modalEmt).hide();
          $(".button_wrapper .new", modalEmt).show();
          $('.button_wrapper span', modalEmt).hide();
          $(".button_wrapper .new", modalEmt).show();
          size = _modalSize('new');
          modalEmt.css({width: size.width, height: size.height});
          $('.project_create_wrapper', modalEmt).hide();
          Common.modalCentering();
          if(callback !== null) {
            return callback();
          }
        }
      });

      // Createボタンイベント
      $('.create_button', modalEmt).off('click').on('click', function() {
        Common.hideModalView(true);
        Common.showModalFlashMessage('Creating...');

        // プロジェクト新規作成
        const projectName = $('.project_name').val();
        if((projectName == null) || (projectName.length === 0)) {
          // エラー
          Project.showError(modalEmt, I18n.t('message.project.error.project_name'));
          return;
        }

        // Mainコンテナ作成
        Common.createdMainContainerIfNeeded(PageValue.getPageNum());
        // コンテナ初期化
        WorktableCommon.initMainContainer();
        // リサイズイベント
        Common.initResize(WorktableCommon.resizeEvent);
        // プロジェクト更新
        Project.updateProjectInfo({
          projectName
        });

        // プロジェクト作成リクエスト
        return Project.create(projectName, function(data) {
          // 初期化終了
          window.initDone = true;
          // モーダルを削除
          Common.hideModalView();
          // 通知
          return FloatView.show('Project created', FloatView.Type.APPLY, 3.0);
        });
      });
      // Openボタンイベント
      $('.open_button', modalEmt).off('click').on('click', function() {
        // プロジェクト選択
        const user_pagevalue_id = $('.project_select', modalEmt).val();
        return Project.load(user_pagevalue_id, function(data) {
          if(!Common.isinitedScrollContentsPosition()) {
            // スクロール位置が更新されていない場合は更新させる ※保険としてチェック
            WorktableCommon.initScrollContentsPosition();
          }
          // 初期化終了
          return window.initDone = true;
        });
      });

      // MainPageに遷移
      $('.back_button', modalEmt).off('click').on('click', () => window.location.href = '/');

      // Error非表示
      return Project.hideError(modalEmt);
    }

    // プロジェクト一覧を更新順に取得
    static load_data_order_last_updated(successCallback = null, errorCallback = null) {
      return $.ajax(
        {
          url: "/page_value_state/load_created_projects",
          type: "GET",
          dataType: "json",
          success(data) {
            if(data.resultSuccess) {
              if(successCallback !== null) {
                return successCallback(data);
              }
            } else {
              if(errorCallback !== null) {
                errorCallback();
              }
              console.log('/page_value_state/load_created_projects server error');
              return Common.ajaxError(data);
            }
          },
          error(data) {
            if(errorCallback !== null) {
              errorCallback();
            }
            console.log('/page_value_state/load_created_projects ajax error');
            return Common.ajaxError(data);
          }
        }
      );
    }

    // プロジェクト新規作成リクエスト
    static create(title, callback = null) {
      const data = {};
      data[constant.Project.Key.TITLE] = title;
      return $.ajax(
        {
          url: "/project/create",
          type: "POST",
          data,
          dataType: "json",
          success(data) {
            if(data.resultSuccess) {
              // PageValue設定
              PageValue.setGeneralPageValue(PageValue.Key.PROJECT_ID, data.project_id);
              PageValue.setGeneralPageValue(PageValue.Key.IS_SAMPLE_PROJECT, false);
              // 共通イベントのインスタンス作成
              WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded();
              // 更新日時設定
              Navbar.setLastUpdateTime(data.updated_at);
              // ナビバーをプロジェクト作成後状態に
              Navbar.switchWorktableNavbarWhenProjectCreated(true);
              if(callback !== null) {
                return callback(data);
              }
            } else {
              Common.hideModalView(true);
              console.log('project/create server error');
              return Common.ajaxError(data);
            }
          },
          error(data) {
            Common.hideModalView(true);
            console.log('project/create ajax error');
            return Common.ajaxError(data);
          }
        }
      );
    }

    // プロジェクト読み込み
    static load(user_pagevalue_id, callback = null) {
      Common.hideModalView(true);
      Common.showModalFlashMessage('Loading...');
      return ServerStorage.load(user_pagevalue_id, data => {
        // Mainコンテナ作成
        Common.createdMainContainerIfNeeded(PageValue.getPageNum());
        // コンテナ初期化
        WorktableCommon.initMainContainer();
        // リサイズイベント
        Common.initResize(WorktableCommon.resizeEvent);
        WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
          PageValue.updatePageCount();
          PageValue.updateForkCount();
          Paging.initPaging();
          Common.applyEnvironmentFromPagevalue();
          WorktableSetting.initConfig();
          // 共通イベントのインスタンス作成
          WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded();
          // 最新更新日時設定
          Navbar.setLastUpdateTime(data.updated_at);
          // ページ変更処理
          const sectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
          $('#pages .section:first').attr('class', `${sectionClass} section`);
          $('#pages .section:first').css({
            'backgroundColor': constant.DEFAULT_BACKGROUNDCOLOR,
            'z-index': Common.plusPagingZindex(0, PageValue.getPageNum())
          });
          $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT));
          window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM + 1));
          // ナビバーをプロジェクト作成後状態に
          Navbar.switchWorktableNavbarWhenProjectCreated(true);
          // モーダルを削除
          Common.hideModalView();
          // 通知
          FloatView.show('Project loaded', FloatView.Type.APPLY, 3.0);
          if(callback !== null) {
            return callback(data);
          }
        });
        return Timeline.refreshAllTimeline();
      });
    }

    static initProjectValue(name) {
      // PageValue設定
      PageValue.setGeneralPageValue(PageValue.Key.PROJECT_NAME, name);
      // プロジェクトのサイズは動作プレビューで指定させるため空
      return PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {});
    }

    // プロジェクト管理モーダルビュー初期化
    static initAdminProjectModal(modalEmt, params, callback = null) {
      const _loadAdminMenu = callback =>
        $.ajax(
          {
            url: "/project/admin_menu",
            type: "GET",
            dataType: "json",
            success(data) {
              if(data.resultSuccess) {
                return callback(data.admin_html);
              } else {
                console.log('/project/admin_menu server error');
                return Common.ajaxError(data);
              }
            },
            error(data) {
              console.log('/project/admin_menu ajax error');
              return Common.ajaxError(data);
            }
          }
        )
      ;

      const _loadEditInput = function(target, callback) {
        const data = {};
        data[constant.Project.Key.USER_PAGEVALUE_ID] = $(target).closest('.am_row').find(`.${constant.Project.Key.USER_PAGEVALUE_ID}:first`).val();
        return $.ajax(
          {
            url: "/project/get_project_by_user_pagevalue_id",
            type: "POST",
            dataType: "json",
            data,
            success(data) {
              if(data.resultSuccess) {
                return callback(data.project);
              } else {
                console.log('/project/get_project_by_user_pagevalue_id server error');
                return Common.ajaxError(data);
              }
            },
            error(data) {
              console.log('/project/get_project_by_user_pagevalue_id ajax error');
              return Common.ajaxError(data);
            }
          }
        );
      };

      const _update = function(target, callback) {
        const data = {};
        data[constant.Project.Key.PROJECT_ID] = $(target).closest('.am_input_wrapper').find(`.${constant.Project.Key.PROJECT_ID}:first`).val();
        const inputWrapper = modalEmt.find('.am_input_wrapper:first');
        data.value = {
          p_title: inputWrapper.find('.project_name:first').val()
        };
        return $.ajax(
          {
            url: "/project/update",
            type: "POST",
            dataType: "json",
            data,
            success(data) {
              if(data.resultSuccess) {
                return callback(data.updated_project_info, data.admin_html);
              } else {
                console.log('/project/remove server error');
                return Common.ajaxError(data);
              }
            },
            error(data) {
              console.log('/project/remove ajax error');
              return Common.ajaxError(data);
            }
          }
        );
      };

      const _delete = function(target, callback) {
        const data = {};
        data[constant.Project.Key.PROJECT_ID] = $(target).closest('.am_row').find(`.${constant.Project.Key.PROJECT_ID}:first`).val();
        return $.ajax(
          {
            url: "/project/remove",
            type: "POST",
            dataType: "json",
            data,
            success(data) {
              if(data.resultSuccess) {
                return callback(data.admin_html);
              } else {
                console.log('/project/remove server error');
                return Common.ajaxError(data);
              }
            },
            error(data) {
              console.log('/project/remove ajax error');
              return Common.ajaxError(data);
            }
          }
        );
      };

      const _initEditInput = function() {
        const inputWrapper = modalEmt.find('.am_input_wrapper:first');
        inputWrapper.hide();
        inputWrapper.find('input[type=text]').val('');
        return inputWrapper.find('input[type=number]').val('');
      };

      const _settingEditInputEvent = function() {
        modalEmt.find('.button_wrapper .update_button').off('click').on('click', e => {
          return _update.call(this, $(e.target), (updated_project_info, admin_html) => {
            // 更新完了 -> リスト再表示
            modalEmt.find('.am_list:first').empty().html(admin_html);
            // アクティブ & プロジェクト状態更新
            _updateActive.call(this);
            Project.updateProjectInfo({
              projectName: updated_project_info.title
            });
            // 非表示
            return Common.hideModalView();
          });
        });
        return modalEmt.find('.am_input_wrapper .button_wrapper .cancel_button').off('click').on('click', e => {
          // 左にスライド
          return modalEmt.find('.am_scroll_wrapper:first').animate({scrollLeft: 0}, 200);
        });
      };

      var _updateActive = () =>
        modalEmt.find('.am_row').each(function() {
          const openedProjectId = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
          if(parseInt($(this).find(`.${constant.Project.Key.PROJECT_ID}:first`).val()) === parseInt(openedProjectId)) {
            return $(this).find(".am_title:first").addClass('opened');
          } else {
            return $(this).find(".am_title:first").removeClass('opened');
          }
        })
      ;

      // 作成済みプロジェクト一覧取得
      return _loadAdminMenu.call(this, admin_html => {
        modalEmt.find('.am_list:first').html(admin_html);
        var _setEvent = function() {
          // アクティブ設定
          _updateActive.call(this);
          // イベント設定
          modalEmt.find('.am_row .edit_button').off('click').on('click', e => {
            // 右にスライド
            const scrollWrapper = modalEmt.find('.am_scroll_wrapper:first');
            const scrollContents = scrollWrapper.children('div:first');
            const scrollContentsSize = {
              width: $('.am_list_wrapper:first').width(),
              height: $('.am_list_wrapper:first').height()
            };
            scrollWrapper.animate({scrollLeft: scrollContentsSize.width}, 200);
            // プロジェクト情報初期化
            _initEditInput.call(this);
            // プロジェクト情報読み込み
            return _loadEditInput($(e.target), project => {
              const inputWrapper = modalEmt.find('.am_input_wrapper:first');
              inputWrapper.find('.project_name:first').val(project.title);
              inputWrapper.find(`.${constant.Project.Key.PROJECT_ID}:first`).val(project.id);
              _settingEditInputEvent.call(this);
              return inputWrapper.show();
            });
          });
          modalEmt.find('.am_row .remove_button').off('click').on('click', e => {
            // 削除確認
            if(window.confirm(I18n.t('message.dialog.delete_project'))) {
              const deletedProjectId = $(e.target).closest('.am_row').find(`.${constant.Project.Key.PROJECT_ID}:first`).val();
              // 削除
              return _delete.call(this, $(e.target), admin_html => {
                // アクティブ設定
                _updateActive.call(this);
                if(parseInt(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)) === parseInt(deletedProjectId)) {
                  // 自身のプロジェクトを削除 -> プロジェクト選択
                  Common.hideModalView(true);
                  WorktableCommon.resetWorktable();
                  // 初期モーダル表示
                  return Common.showModalView(constant.ModalViewType.INIT_PROJECT, true, Project.initProjectModal);
                } else {
                  // 削除完了 -> リスト再表示
                  modalEmt.find('.am_list:first').empty().html(admin_html);
                  return _setEvent.call(this);
                }
              });
            }
          });
          return modalEmt.find('.am_list_wrapper .cancel_button').off('click').on('click', e => {
            return Common.hideModalView();
          });
        };
        _setEvent.call(this);
        Common.modalCentering();
        if(callback !== null) {
          return callback();
        }
      });
    }

    // Mainビューの高さ計算
    // TODO: デザインが変わったら修正
    static calcOriginalViewHeight() {
      const borderWidth = 5;
      const timelineTopPadding = 5;
      return $('#screen_wrapper').height() - $('#timeline').height() - timelineTopPadding - (borderWidth * 2);
    }

    // サンプルプロジェクトか
    static isSampleProject() {
      const p = PageValue.getGeneralPageValue(PageValue.Key.IS_SAMPLE_PROJECT);
      if(p !== null) {
        if(typeof p === 'string') {
          return p === 'true';
        } else {
          return p;
        }
      }
      return false;
    }

    static showError(modalEmt, message) {
      modalEmt.find('.error_wrapper .error:first').html(message);
      return modalEmt.find('.error_wrapper').show();
    }

    static hideError(modalEmt) {
      modalEmt.find('.error_wrapper').hide();
      return modalEmt.find('.error_wrapper .error:first').html('');
    }
  };
  Project.initClass();
  return Project;
})();
