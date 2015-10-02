class Project
  @load_data: (successCallback = null, errorCallback = null) ->
    $.ajax(
      {
        url: "/project/list"
        type: "GET"
        dataType: "json"
        success: (data)->
          if successCallback?
            successCallback(data)
        error: (data)->
          if errorCallback?
            errorCallback()
      }
    )

  # プロジェクト新規作成リクエスト
  @create = (title, screenWidth, screenHeight, callback = null) ->
    data = {}
    data[Constant.Project.Key.TITLE] = title
    data[Constant.Project.Key.SCREEN_WIDTH] = screenWidth
    data[Constant.Project.Key.SCREEN_HEIGHT] = screenHeight
    $.ajax(
      {
        url: "/project/create"
        type: "POST"
        data: data
        dataType: "json"
        success: (data) ->
          # PageValue設定
          PageValue.setGeneralPageValue(PageValue.Key.PROJECT_ID, data.project_id)
          if callback?
            callback()
        error: (data) ->
      }
    )

