// Generated by CoffeeScript 1.9.2
var Project;

Project = (function() {
  function Project() {}

  Project.updateProjectInfo = function(info) {
    var height, projectName, width;
    projectName = info.projectName;
    width = info.screenWidth;
    height = info.screenHeight;
    Project.initProjectValue(projectName, width, height);
    return Common.setTitle(projectName);
  };

  Project.initProjectModal = function(modalEmt, params, callback) {
    var _modalSize;
    if (callback == null) {
      callback = null;
    }
    _modalSize = function(type) {
      var height, width;
      if (type === 'new') {
        width = 424;
        height = 179;
      } else {
        width = 424;
        height = 118;
      }
      return {
        width: width,
        height: height
      };
    };
    $('.project_create_wrapper input[type=radio]', modalEmt).off('click');
    $('.project_create_wrapper input[type=radio]', modalEmt).on('click', function() {
      var size;
      $('.display_project_new_wrapper', modalEmt).css('display', $(this).val() === 'new' ? 'block' : 'none');
      $('.display_project_select_wrapper', modalEmt).css('display', $(this).val() === 'select' ? 'block' : 'none');
      size = _modalSize($(this).val());
      modalEmt.animate({
        width: size.width + "px",
        height: size.height + "px"
      }, {
        duration: 300,
        queue: false
      });
      Common.modalCentering(true, size);
      $('.button_wrapper span', modalEmt).hide();
      return $(".button_wrapper ." + ($(this).val()), modalEmt).show();
    });
    $('.display_size_wrapper input[type=radio]', modalEmt).off('click');
    $('.display_size_wrapper input[type=radio]', modalEmt).on('click', function() {
      var height;
      $('.display_size_input_wrapper', modalEmt).css('display', $(this).val() === 'input' ? 'block' : 'none');
      if ($(this).val() === 'input') {
        height = 199;
      } else {
        height = 179;
      }
      return modalEmt.animate({
        height: size.height + "px"
      }, {
        duration: 300
      });
    });
    $('.default_window_size', modalEmt).html((window.mainWrapper.width()) + " X " + (window.mainWrapper.height()));
    Project.load_data_order_last_updated(function(data) {
      var d, e, i, len, list, n, p, projectSelect, size, user_pagevalue_list;
      user_pagevalue_list = data.user_pagevalue_list;
      projectSelect = $('.project_select', modalEmt);
      if (user_pagevalue_list.length > 0) {
        list = '';
        n = $.now();
        for (i = 0, len = user_pagevalue_list.length; i < len; i++) {
          p = user_pagevalue_list[i];
          d = new Date(p['up_updated_at']);
          e = "<option value='" + p['up_id'] + "'>" + p['p_title'] + " - " + (Common.displayDiffAlmostTime(n, d.getTime())) + "</option>";
          list += e;
        }
        projectSelect.children().remove();
        $(list).appendTo(projectSelect);
        $('.project_create_wrapper input[type=radio][value=select]', modalEmt).prop('checked', true);
        $('.display_project_new_wrapper', modalEmt).hide();
        $('.display_project_select_wrapper', modalEmt).show();
        $(".button_wrapper .select", modalEmt).show();
        $('.button_wrapper span', modalEmt).hide();
        $(".button_wrapper .select", modalEmt).show();
        size = _modalSize('select');
        modalEmt.css({
          width: size.width,
          height: size.height
        });
        $('.project_create_wrapper', modalEmt).show();
        Common.modalCentering();
        if (callback != null) {
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
        modalEmt.css({
          width: size.width,
          height: size.height
        });
        $('.project_create_wrapper', modalEmt).hide();
        Common.modalCentering();
        if (callback != null) {
          return callback();
        }
      }
    });
    $('.create_button', modalEmt).off('click');
    $('.create_button', modalEmt).on('click', function() {
      var height, projectName, width;
      projectName = $('.project_name').val();
      width = $('#screen_wrapper').width();
      height = $('#screen_wrapper').height();
      if ((projectName == null) || projectName.length === 0) {
        return;
      }
      if ($('.display_size_wrapper input[value=input]').is(':checked')) {
        width = $('.display_size_input_width', modalEmt).val();
        height = $('.display_size_input_height', modalEmt).val();
        if ((width == null) || width.length === 0 || (height == null) || height.length === 0) {
          return;
        }
      }
      Project.updateProjectInfo({
        projectName: projectName,
        screenWidth: width,
        screenHeight: height
      });
      Common.applyEnvironmentFromPagevalue();
      return Project.create(projectName, width, height, function(data) {
        Navbar.setLastUpdateTime(data.updated_at);
        window.initDone = true;
        return Common.hideModalView();
      });
    });
    $('.open_button', modalEmt).off('click');
    $('.open_button', modalEmt).on('click', function() {
      var user_pagevalue_id;
      user_pagevalue_id = $('.project_select', modalEmt).val();
      return ServerStorage.load(user_pagevalue_id, function(data) {
        var sectionClass;
        Navbar.setLastUpdateTime(data.updated_at);
        Common.applyEnvironmentFromPagevalue();
        sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
        $('#pages .section:first').attr('class', sectionClass + " section");
        $('#pages .section:first').css({
          'backgroundColor': Constant.DEFAULT_BACKGROUNDCOLOR,
          'z-index': Common.plusPagingZindex(0, PageValue.getPageNum())
        });
        $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT));
        window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1));
        window.initDone = true;
        return Common.hideModalView();
      });
    });
    $('.back_button', modalEmt).off('click');
    return $('.back_button', modalEmt).on('click', function() {
      return window.location.href = '/';
    });
  };

  Project.load_data_order_last_updated = function(successCallback, errorCallback) {
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    return $.ajax({
      url: "/page_value_state/user_pagevalues_and_projects_sorted_updated",
      type: "GET",
      dataType: "json",
      success: function(data) {
        if (data.resultSuccess) {
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          if (errorCallback != null) {
            errorCallback();
          }
          return console.log('/page_value_state/user_pagevalues_and_projects_sorted_updated server error');
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          errorCallback();
        }
        return console.log('/page_value_state/user_pagevalues_and_projects_sorted_updated ajax error');
      }
    });
  };

  Project.create = function(title, screenWidth, screenHeight, callback) {
    var data;
    if (callback == null) {
      callback = null;
    }
    data = {};
    data[Constant.Project.Key.TITLE] = title;
    data[Constant.Project.Key.SCREEN_SIZE] = {
      width: screenWidth,
      height: screenHeight
    };
    return $.ajax({
      url: "/project/create",
      type: "POST",
      data: data,
      dataType: "json",
      success: function(data) {
        if (data.resultSuccess) {
          PageValue.setGeneralPageValue(PageValue.Key.PROJECT_ID, data.project_id);
          if (callback != null) {
            return callback(data);
          }
        } else {
          return console.log('project/create server error');
        }
      },
      error: function(data) {
        return console.log('project/create ajax error');
      }
    });
  };

  Project.initProjectValue = function(name, width, height) {
    PageValue.setGeneralPageValue(PageValue.Key.PROJECT_NAME, name);
    return PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {
      width: parseInt(width),
      height: parseInt(height)
    });
  };

  Project.initAdminProjectModal = function(modalEmt, params, callback) {
    var _delete, _initEditInput, _loadAdminMenu, _loadEditInput, _settingEditInputEvent, _update, _updateActive;
    if (callback == null) {
      callback = null;
    }
    _loadAdminMenu = function(callback) {
      return $.ajax({
        url: "/project/admin_menu",
        type: "GET",
        dataType: "json",
        success: function(data) {
          if (data.resultSuccess) {
            return callback(data.admin_html);
          } else {
            return console.log('/project/admin_menu server error');
          }
        },
        error: function(data) {
          return console.log('/project/admin_menu ajax error');
        }
      });
    };
    _loadEditInput = function(target, callback) {
      var data;
      data = {};
      data[Constant.Project.Key.USER_PAGEVALUE_ID] = $(target).closest('.am_row').find("." + Constant.Project.Key.USER_PAGEVALUE_ID + ":first").val();
      return $.ajax({
        url: "/project/get_project_by_user_pagevalue_id",
        type: "POST",
        dataType: "json",
        data: data,
        success: function(data) {
          if (data.resultSuccess) {
            return callback(data.project);
          } else {
            return console.log('/project/get_project_by_user_pagevalue_id server error');
          }
        },
        error: function(data) {
          return console.log('/project/get_project_by_user_pagevalue_id ajax error');
        }
      });
    };
    _update = function(target, callback) {
      var data, inputWrapper;
      data = {};
      data[Constant.Project.Key.PROJECT_ID] = $(target).closest('.am_row').find("." + Constant.Project.Key.PROJECT_ID + ":first").val();
      inputWrapper = modalEmt.find('.am_input_wrapper:first');
      data.value = {
        p_title: inputWrapper.find('.project_name:first').val(),
        p_screen_width: inputWrapper.find('.display_size_input_width:first').val(),
        p_screen_height: inputWrapper.find('.display_size_input_height:first').val()
      };
      return $.ajax({
        url: "/project/update",
        type: "POST",
        dataType: "json",
        data: data,
        success: function(data) {
          if (data.resultSuccess) {
            return callback(data.updated_project_info, data.admin_html);
          } else {
            return console.log('/project/remove server error');
          }
        },
        error: function(data) {
          return console.log('/project/remove ajax error');
        }
      });
    };
    _delete = function(target, callback) {
      var data;
      data = {};
      data[Constant.Project.Key.PROJECT_ID] = $(target).closest('.am_row').find("." + Constant.Project.Key.PROJECT_ID + ":first").val();
      return $.ajax({
        url: "/project/remove",
        type: "POST",
        dataType: "json",
        data: data,
        success: function(data) {
          if (data.resultSuccess) {
            return callback(data.admin_html);
          } else {
            return console.log('/project/remove server error');
          }
        },
        error: function(data) {
          return console.log('/project/remove ajax error');
        }
      });
    };
    _initEditInput = function() {
      var inputWrapper;
      inputWrapper = modalEmt.find('.am_input_wrapper:first');
      inputWrapper.hide();
      inputWrapper.find('input[type=text]').val('');
      return inputWrapper.find('input[type=number]').val('');
    };
    _settingEditInputEvent = function() {
      modalEmt.find('.button_wrapper update_button').off('click').on('click', (function(_this) {
        return function(e) {
          return _update(_this, $(e.target), function(updated_project_info, admin_html) {
            modalEmt.find('.am_list:first').empty().html(admin_html);
            _updateActive.call(_this);
            _this.updateProjectInfo({
              projectName: updated_project_info.title,
              screenWidth: updated_project_info.screen_width,
              screenHeight: updated_project_info.screen_height
            });
            return modalEmt.find('.am_scroll_wrapper:first').animate({
              scrollLeft: 0
            }, 200);
          });
        };
      })(this));
      return modalEmt.find('.button_wrapper cancel_button').off('click').on('click', (function(_this) {
        return function(e) {
          return modalEmt.find('.am_scroll_wrapper:first').animate({
            scrollLeft: 0
          }, 200);
        };
      })(this));
    };
    _updateActive = function() {
      return modalEmt.find('.am_row').each((function(_this) {
        return function() {
          var openedProjectId;
          openedProjectId = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID);
          if ($(_this).find("." + Constant.Project.Key.PROJECT_ID + ":first").val() === openedProjectId) {
            return $(_this).find(".am_title:frist").addClass('opened');
          } else {
            return $(_this).find(".am_title:frist").removeClass('opened');
          }
        };
      })(this));
    };
    return _loadAdminMenu.call(this, (function(_this) {
      return function(admin_html) {
        modalEmt.find('.am_list:first').html(admin_html);
        modalEmt.find('.am_row .edit_button').off('click').on('click', function(e) {
          var scrollContents, scrollWrapper;
          scrollWrapper = modalEmt.find('.am_scroll_wrapper:first');
          scrollContents = scrollWrapper.children('div:first');
          scrollWrapper.animate({
            scrollLeft: scrollContents.width()
          }, 200);
          _initEditInput.call(_this);
          return _loadEditInput($(e.target), function(project) {
            var inputWrapper;
            inputWrapper = modalEmt.find('.am_input_wrapper:first');
            inputWrapper.find('.project_name:first').val(project.title);
            inputWrapper.find('.display_size_input_width:first').val(project.screen_width);
            inputWrapper.find('.display_size_input_height:first').val(project.screen_height);
            return inputWrapper.show();
          });
        });
        modalEmt.find('.am_row .remove_button').off('click').on('click', function(e) {
          if (window.confirm(I18n.t('message.dialog.delete_project'))) {
            return _delete(_this, $(e.target), function(admin_html) {
              return modalEmt.find('.am_list:first').empty().html(admin_html);
            });
          }
        });
        Common.modalCentering();
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  };

  return Project;

})();

//# sourceMappingURL=project.js.map
