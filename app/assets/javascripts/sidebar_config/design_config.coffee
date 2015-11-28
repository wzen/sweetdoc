class DesignConfig
  @getDesignConfig = (obj, successCallback = null, errorCallback = null)->
    $.ajax(
      {
        url: "/config_menu/design_config"
        type: "POST"
        data: {
          designConfig: obj.constructor.actionProperties.designConfig
          isCanvas: obj instanceof CanvasItemBase
          modifiables: obj.constructor.actionProperties.modifiables
        }
        dataType: "json"
        success: (data)->
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            if errorCallback?
              errorCallback(data)
            console.log('/config_menu/design_config server error')
        error: (data) ->
          if errorCallback?
            errorCallback(data)
          console.log('/config_menu/design_config ajax error')
      }
    )