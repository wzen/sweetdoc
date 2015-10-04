// Generated by CoffeeScript 1.9.2
var Project;

Project = (function() {
  function Project() {}

  Project.initProjectModal = function(modalEmt) {
    $('.project_create_wrapper input[type=radio]', modalEmt).off('click');
    $('.project_create_wrapper input[type=radio]', modalEmt).on('click', function() {
      $('.display_project_new_wrapper', modalEmt).css('display', $(this).val() === 'new' ? 'block' : 'none');
      return $('.display_project_select_wrapper', modalEmt).css('display', $(this).val() === 'select' ? 'block' : 'none');
    });
    $('.display_size_wrapper input[type=radio]', modalEmt).off('click');
    $('.display_size_wrapper input[type=radio]', modalEmt).on('click', function() {
      return $('.display_size_input_wrapper', modalEmt).css('display', $(this).val() === 'input' ? 'block' : 'none');
    });
    Project.load_data(function(data) {
      var d, e, i, len, list, n, p, projectSelect, user_pagevalue_list;
      user_pagevalue_list = data.list;
      projectSelect = $('.project_select', modalEmt);
      if (user_pagevalue_list.length > 0) {
        list = '';
        n = $.now();
        for (i = 0, len = user_pagevalue_list.length; i < len; i++) {
          p = user_pagevalue_list[i];
          d = new Date(p[Constant.Project.Key.USER_PAGEVALUE_UPDATED_AT]);
          e = "<option value='" + p[Constant.Project.Key.USER_PAGEVALUE_ID] + "'>" + p[Constant.Project.Key.TITLE] + " - " + (Common.displayDiffAlmostTime(n, d.getTime())) + "</option>";
          list += e;
        }
        projectSelect.children().remove();
        $(list).appendTo(projectSelect);
        return $('.project_create_wrapper', modalEmt).show();
      } else {
        projectSelect.children().remove();
        return $('.project_create_wrapper', modalEmt).hide();
      }
    });
    $('.create_button', modalEmt).off('click');
    return $('.create_button', modalEmt).on('click', function() {
      var height, projectName, user_pagevalue_id, width;
      if ($('input[name=project_create][value=new]').is(':checked')) {
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
        PageValue.setGeneralPageValue(PageValue.Key.PROJECT_NAME, projectName);
        PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {
          width: parseInt(width),
          height: parseInt(height)
        });
        Navbar.setTitle(projectName);
        return Project.create(projectName, width, height, function() {
          Common.initScreenSize();
          Common.hideModalView();
          return Common.updateScrollContentsFromPagevalue();
        });
      } else {
        user_pagevalue_id = $('.project_select', modalEmt).val();
        return ServerStorage.load(user_pagevalue_id, function() {
          Common.initScreenSize();
          Common.hideModalView();
          return Common.updateScrollContentsFromPagevalue();
        });
      }
    });
  };

  Project.load_data = function(successCallback, errorCallback) {
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    return $.ajax({
      url: "/project/list",
      type: "GET",
      dataType: "json",
      success: function(data) {
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          return errorCallback();
        }
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
        PageValue.setGeneralPageValue(PageValue.Key.PROJECT_ID, data.project_id);
        if (callback != null) {
          return callback();
        }
      },
      error: function(data) {}
    });
  };

  return Project;

})();

//# sourceMappingURL=project.js.map
