# メニューをサーバから読み込み
class ConfigMenu
  if gon?
    constant = gon.const

    @ROOT_ID = constant.ConfigMenu.ROOT_ID
    class @Action
      @PRELOAD_IMAGE_PATH_SELECT = constant.ConfigMenu.Action.PRELOAD_IMAGE_PATH_SELECT

  # デザインコンフィグ
  @getDesignConfig = (obj, successCallback = null, errorCallback = null) ->
    designConfigRoot = $('#' + obj.getDesignConfigId())
    if !designConfigRoot? || designConfigRoot.length == 0
      itemType = null
      if obj instanceof CanvasItemBase
        itemType = 'canvas'
      else if obj instanceof CssItemBase
        itemType = 'css'
      else
        itemType = 'other'

      $.ajax(
        {
          url: "/config_menu/design_config"
          type: "POST"
          data: {
            designConfig: obj.constructor.actionProperties.designConfig
            itemType: itemType
            modifiables: obj.constructor.actionProperties.modifiables
          }
          dataType: "json"
          success: (data) ->
            if data.resultSuccess
              designConfigRoot = $('#' + obj.getDesignConfigId())
              if !designConfigRoot? || designConfigRoot.length == 0
                html = $(data.html).attr('id', obj.getDesignConfigId())
                $('#design-config').append(html)
                designConfigRoot = $('#' + obj.getDesignConfigId())
              if successCallback?
                successCallback(designConfigRoot)
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

    else
      if successCallback?
        successCallback(designConfigRoot)

  # メソッド変数コンフィグ読み込み
  @loadEventMethodValueConfig = (eventConfigObj, itemObjClass, successCallback = null, errorCallback = null) ->
    if !itemObjClass.actionProperties.methods[eventConfigObj[EventPageValueBase.PageValueKey.METHODNAME]]? ||
      !itemObjClass.actionProperties.methods[eventConfigObj[EventPageValueBase.PageValueKey.METHODNAME]].modifiables?
        # メソッド or 変数編集無し
        if successCallback?
          successCallback()
        return

    # HTML存在チェック
    valueClassName = eventConfigObj.methodClassName()
    emt = $(".value_forms .#{valueClassName}", eventConfigObj.emt)
    if emt.length > 0
      # 変数編集コンフィグの初期化
      eventConfigObj.initEventVarModifyConfig(itemObjClass)
      if successCallback?
        successCallback()
      return

    $.ajax(
      {
        url: "/config_menu/method_values_config"
        type: "POST"
        data: {
          classDistToken: itemObjClass.CLASS_DIST_TOKEN
          modifiables: itemObjClass.actionProperties.methods[eventConfigObj[EventPageValueBase.PageValueKey.METHODNAME]].modifiables
        }
        dataType: "json"
        success: (data) ->
          if data.resultSuccess
            # コンフィグ追加
            $(".value_forms", eventConfigObj.emt).append($("<div class='#{valueClassName}'><div class='#{eventConfigObj.constructor.METHOD_VALUE_MODIFY_ROOT}'>#{data.modify_html}</div><div class='#{eventConfigObj.constructor.METHOD_VALUE_SPECIFIC_ROOT}'>#{data.specific_html}</div></div>"))
            # コンフィグの初期化
            eventConfigObj.initEventVarModifyConfig(itemObjClass)
            eventConfigObj.initEventSpecificConfig(itemObjClass)
            if successCallback?
              successCallback(data)
          else
            if errorCallback?
              errorCallback(data)
            console.log('/config_menu/method_values_config server error')
        error: (data) ->
          if errorCallback?
            errorCallback(data)
          console.log('/config_menu/method_values_config ajax error')
      }
    )

  # コンフィグを読み込み(汎用的に使用)
  @loadConfig = (serverActionName, sendData, successCallback = null, errorCallback = null) ->
    # 存在チェック
    emt = $("##{@ROOT_ID} .#{serverActionName}")
    if emt? && emt.length > 0
      if successCallback?
        successCallback(emt.children(':first'))
      return

    $.ajax(
      {
        url: "/config_menu/#{serverActionName}"
        type: "POST"
        data: sendData
        dataType: "json"
        success: (data) =>
          if data.resultSuccess
            # コンフィグ追加
            $("##{@ROOT_ID}").append("<div class='#{serverActionName}'>#{data.html}</div>")
            emt = $("##{@ROOT_ID} .#{serverActionName}")
            if successCallback?
              successCallback(emt.children(':first'))
          else
            if errorCallback?
              errorCallback(data)
            console.log("/config_menu/#{serverActionName} server error")
        error: (data) ->
          if errorCallback?
            errorCallback(data)
          console.log("/config_menu/#{serverActionName} ajax error")
      }
    )
