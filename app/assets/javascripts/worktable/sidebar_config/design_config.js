// Generated by CoffeeScript 1.9.2
var DesignConfig;

DesignConfig = (function() {
  function DesignConfig() {}

  DesignConfig.getDesignConfig = function(obj, successCallback, errorCallback) {
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    return $.ajax({
      url: "/worktable/design_config",
      type: "POST",
      data: {
        designConfig: obj.constructor.actionProperties.designConfig,
        isCanvas: obj instanceof CanvasItemBase,
        modifiables: obj.constructor.actionProperties.modifiables
      },
      dataType: "json",
      success: function(data) {
        if (data.resultSuccess) {
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          if (errorCallback != null) {
            errorCallback(data);
          }
          return console.log('/worktable/design_config server error');
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          errorCallback(data);
        }
        return console.log('/worktable/design_config ajax error');
      }
    });
  };

  return DesignConfig;

})();

//# sourceMappingURL=design_config.js.map
