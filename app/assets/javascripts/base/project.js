// Generated by CoffeeScript 1.9.2
var Project;

Project = (function() {
  function Project() {}

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
