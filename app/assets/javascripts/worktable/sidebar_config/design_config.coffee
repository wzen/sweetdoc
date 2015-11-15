class DesignConfig
  @addConfigIfNeed = (obj, successCallback = null, errorCallback = null)->
    $.ajax(
      {
        url: "/worktable/design_config"
        type: "POST"
        data: {
          designConfig: obj.constructor.actionProperties.designConfig
          isCanvas: obj instanceof CanvasItemBase
        }
        dataType: "json"
        success: (data)->
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            if errorCallback?
              errorCallback(data)
            console.log('/worktable/design_config server error')
        error: (data) ->
          if errorCallback?
            errorCallback(data)
          console.log('/worktable/design_config ajax error')
      }
    )