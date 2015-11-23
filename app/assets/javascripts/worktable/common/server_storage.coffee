class ServerStorage

  if gon?
    # 定数
    constant = gon.const
    # ページ内値保存キー
    class @Key
      @PROJECT_ID = constant.ServerStorage.Key.PROJECT_ID
      @PAGE_COUNT = constant.ServerStorage.Key.PAGE_COUNT
      @GENERAL_COMMON_PAGE_VALUE = constant.ServerStorage.Key.GENERAL_COMMON_PAGE_VALUE
      @GENERAL_PAGE_VALUE = constant.ServerStorage.Key.GENERAL_PAGE_VALUE
      @INSTANCE_PAGE_VALUE = constant.ServerStorage.Key.INSTANCE_PAGE_VALUE
      @EVENT_PAGE_VALUE = constant.ServerStorage.Key.EVENT_PAGE_VALUE
      @SETTING_PAGE_VALUE = constant.ServerStorage.Key.SETTING_PAGE_VALUE

    class @ElementAttribute
      @FILE_LOAD_CLASS = constant.ElementAttribute.FILE_LOAD_CLASS
      @LOAD_LIST_UPDATED_FLG = 'load_list_updated'
      @LOADED_LOCALTIME = 'loaded_localtime'
      @LOAD_LIST_INTERVAL_SECONDS = 60

    # 60秒が過ぎたらLoadリスト一覧を取得可にする
    @LOAD_LIST_INTERVAL_SECONDS = 60

  # サーバにアイテムの情報を保存
  @save = (callback = null) ->
    window.workingAutoSave = true

    data = {}
    data[@Key.PAGE_COUNT] = parseInt(PageValue.getPageCount())
    data[@Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)

    generalPagevalues = {}
    generalCommonPagevalues = {}
    general = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX)
    data[@Key.GENERAL_PAGE_VALUE] = general

    instancePagevalues = {}
    instance = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
    for k, v of instance
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''))
      instancePagevalues[pageNum] = JSON.stringify(v)
    data[@Key.INSTANCE_PAGE_VALUE] = if Object.keys(instancePagevalues).length > 0 then instancePagevalues else null

    eventPagevalues = {}
    event = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
    for k, v of event
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''))
      eventPagevalues[pageNum] = JSON.stringify(v)
    data[@Key.EVENT_PAGE_VALUE] = if Object.keys(eventPagevalues).length > 0 then eventPagevalues else null
    data[@Key.SETTING_PAGE_VALUE] = PageValue.getSettingPageValue(PageValue.Key.ST_PREFIX)

    if data[@Key.INSTANCE_PAGE_VALUE]? || data[@Key.EVENT_PAGE_VALUE]? || data[@Key.SETTING_PAGE_VALUE]?
      $.ajax(
        {
          url: "/page_value_state/save_state"
          type: "POST"
          data: data
          dataType: "json"
          success: (data)->
            if data.resultSuccess
              # 「Load」マウスオーバーで取得させるためupdateフラグを消去
              $("##{Navbar.NAVBAR_ROOT}").find(".#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}").remove()
              # 最終保存時刻更新
              Navbar.setLastUpdateTime(data.last_save_time)
              PageValue.setGeneralPageValue(PageValue.Key.LAST_SAVE_TIME, data.last_save_time)
              if window.debug
                console.log(data.message)
              if callback?
                callback(data)
              window.workingAutoSave = false
            else
              console.log('/page_value_state/save_state server error')
              if window.debug
                console.log(data.message)
          error: (data) ->
            console.log('/page_value_state/save_state ajax error')
            if window.debug
              console.log(data.message)
        }
      )

  # サーバからアイテムの情報を取得して描画
  # @param [Integer] user_pagevalue_id 取得するUserPageValueのID
  @load = (user_pagevalue_id, callback = null) ->
    $.ajax(
      {
        url: "/page_value_state/load_state"
        type: "POST"
        data: {
          user_pagevalue_id: user_pagevalue_id
          loaded_itemids : JSON.stringify(PageValue.getLoadedItemIds())
        }
        dataType: "json"
        success: (data)->
          if data.resultSuccess
            # JSを適用
            Common.setupJsByList(data.itemJsList, ->
              WorktableCommon.removeAllItemOnWorkTable()

              # Pagevalue設置
              if data.general_pagevalue_data?
                PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, data.general_pagevalue_data)
                Common.setTitle(data.general_pagevalue_data.title)
              if data.instance_pagevalue_data?
                PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, data.instance_pagevalue_data)
              if data.event_pagevalue_data?
                PageValue.setEventPageValueByRootHash(data.event_pagevalue_data)
              if data.setting_pagevalue_data?
                PageValue.setSettingPageValue(PageValue.Key.ST_PREFIX, data.setting_pagevalue_data)

              PageValue.adjustInstanceAndEventOnPage()
              LocalStorage.saveAllPageValues()
              WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( ->
                Timeline.refreshAllTimeline()
                PageValue.updatePageCount()
                PageValue.updateForkCount()
                Paging.initPaging()
                Common.applyEnvironmentFromPagevalue()
                WorktableSetting.initConfig()
                if callback?
                  callback(data)
              )
            )

          else
            console.log('/page_value_state/load_state server error')
            if window.debug
              console.log(data.message)

        error: (data) ->
          console.log('/page_value_state/load_state ajax error')
          if window.debug
            console.log(data.message)
      }
    )

  @get_load_data: (successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)
    $.ajax(
      {
        url: "/page_value_state/user_pagevalue_list_sorted_update"
        type: "GET"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            console.log('/page_value_state/user_pagevalue_list_sorted_update server error')
            if errorCallback?
              errorCallback()
        error: (data)->
          console.log('/page_value_state/user_pagevalue_list_sorted_update ajax error')
          if errorCallback?
            errorCallback()
      }
    )

  @startSaveIdleTimer = ->
    if (window.workingAutoSave? && window.workingAutoSave) || !window.initDone
      # AutoSave実行中 or 画面初期化時は実行しない
      return

    if window.saveIdleTimer?
      clearTimeout(window.saveIdleTimer)
    if WorktableSetting.IdleSaveTimer.isEnabled()
      time = parseFloat(WorktableSetting.IdleSaveTimer.idleTime()) * 1000
      window.saveIdleTimer = setTimeout( ->
        ServerStorage.save()
      , time)
