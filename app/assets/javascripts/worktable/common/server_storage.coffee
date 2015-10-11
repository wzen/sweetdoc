class ServerStorage

  if gon?
    # 定数
    constant = gon.const
    # ページ内値保存キー
    class @Key
      @PROJECT_ID = constant.ServerStorage.Key.PROJECT_ID
      @PAGE_COUNT = constant.ServerStorage.Key.PAGE_COUNT
      @GENERAL_PAGE_VALUE = constant.ServerStorage.Key.GENERAL_PAGE_VALUE
      @INSTANCE_PAGE_VALUE = constant.ServerStorage.Key.INSTANCE_PAGE_VALUE
      @EVENT_PAGE_VALUE = constant.ServerStorage.Key.EVENT_PAGE_VALUE
      @SETTING_PAGE_VALUE = constant.ServerStorage.Key.SETTING_PAGE_VALUE

    class @ElementAttribute
      @FILE_LOAD_CLASS = constant.ElementAttribute.FILE_LOAD_CLASS
      @LOAD_LIST_UPDATED_FLG = 'load_list_updated'
      @LOADED_LOCALTIME = 'loaded_localtime'

    # 60秒が過ぎたらLoadリスト一覧を取得可にする
    @LOAD_LIST_INTERVAL_SECONDS = 60

  # サーバにアイテムの情報を保存
  @save = (callback = null) ->
    data = {}
    data[@Key.PAGE_COUNT] = parseInt(PageValue.getPageCount())
    data[@Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)

    generalPagevalues = {}
    general = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX)
    for k, v of general
      if k.indexOf(PageValue.Key.P_PREFIX) >= 0
        pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''))
        generalPagevalues[pageNum] = JSON.stringify(v)
    data[@Key.GENERAL_PAGE_VALUE] = if Object.keys(generalPagevalues).length > 0 then generalPagevalues else null

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
    data[@Key.SETTING_PAGE_VALUE] = JSON.stringify(PageValue.getSettingPageValue(WorktableSetting.PageValueKey.PREFIX))
    if data[@Key.INSTANCE_PAGE_VALUE]? || data[@Key.EVENT_PAGE_VALUE]? || data[@Key.SETTING_PAGE_VALUE]?
      $.ajax(
        {
          url: "/page_value_state/save_state"
          type: "POST"
          data: data
          dataType: "json"
          success: (data)->
            # 「Load」マウスオーバーで取得させるためupdateフラグを消去
            $("##{Navbar.NAVBAR_ROOT}").find(".#{ServerStorage.ElementAttribute.FILE_LOAD_CLASS} .#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}").remove()
            # 最終保存時刻更新
            PageValue.setGeneralPageValue(PageValue.Key.LAST_SAVE_TIME, data.last_save_time)
            if window.debug
              console.log(data.message)
            if callback?
              callback()
          error: (data) ->
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
          self = @
          item_js_list = data.item_js_list
          # 全て読み込んだ後のコールバック
          _callback = ->
            WorktableCommon.removeAllItemOnWorkTable()

            # Pagevalue設置
            if data.general_pagevalue_data?
              d = {}
              for k, v of data.general_pagevalue_data
                d[k] = JSON.parse(v)
              PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, d)
            if data.project_pagevalue_data?
              for k, v of data.project_pagevalue_data
                PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)
              Navbar.setTitle(data.project_pagevalue_data.title)
            if data.instance_pagevalue_data?
              d = {}
              for k, v of data.instance_pagevalue_data
                d[k] = JSON.parse(v)
              PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, d)
            if data.event_pagevalue_data?
              d = {}
              for k, v of data.event_pagevalue_data
                d[k] = JSON.parse(v)
              PageValue.setEventPageValueByRootHash(d)
            if data.setting_pagevalue_data?
              d = JSON.parse(data.setting_pagevalue_data)
              PageValue.setSettingPageValue(WorktableSetting.PageValueKey.PREFIX, d)

            PageValue.adjustInstanceAndEventOnPage()
            LocalStorage.saveAllPageValues()
            WorktableCommon.drawAllItemFromInstancePageValue( ->
              Timeline.refreshAllTimeline()
              PageValue.updatePageCount()
              PageValue.updateForkCount()
              Paging.initPaging()
              Common.applyEnvironmentFromPagevalue()
              WorktableSetting.initConfig()
              if callback?
                callback()
            )

          if item_js_list.length == 0
            _callback.call(self)
            return

          loadedCount = 0
          item_js_list.forEach((d) ->
            itemId = d.item_id
            if window.itemInitFuncList[itemId]?
              # 既に読み込まれている場合はコールバックのみ実行
              window.itemInitFuncList[itemId]()
              loadedCount += 1
              if loadedCount >= item_js_list.length
                # 全て読み込んだ後
                _callback.call(self)
              return

            if d.css_temp?
              option = {css_temp: d.css_temp}

            Common.availJs(itemId, d.js_src, option, ->
              loadedCount += 1
              if loadedCount >= item_js_list.length
                # 全て読み込んだ後
                _callback.call(self)
            )
            PageValue.addItemInfo(d.item_id)
            EventConfig.addEventConfigContents(d.item_id)
          )

        error: (data) ->
          if window.debug
            console.log(data.message)
      }
    )

  @startSaveIdleTimer = ->
    if window.workingAutoSave? && window.workingAutoSave
      return

    if window.saveIdleTimer?
      clearTimeout(window.saveIdleTimer)
    if WorktableSetting.IdleSaveTimer.isEnabled()
      time = parseFloat(WorktableSetting.IdleSaveTimer.idleTime()) * 1000
      window.saveIdleTimer = setTimeout( ->
        window.workingAutoSave = true
        ServerStorage.save( ->
          window.workingAutoSave = false
        )
      , time)
