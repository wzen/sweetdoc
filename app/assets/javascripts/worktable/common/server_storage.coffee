class ServerStorage

  if gon?
    # 定数
    constant = gon.const
    # ページ内値保存キー
    class @Key
      @USER_ID = constant.ServerStorage.Key.USER_ID
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
  @save = ->
    data = {}
    # FIXME: 差分保存 & バッチでフル保存するようにする
    instancePagevalues = []
    instance = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
    for k, v of instance
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''))
      instancePagevalues.push({
        pageNum: pageNum,
        pagevalue: JSON.stringify(v)

      })
    data[@Key.INSTANCE_PAGE_VALUE] = if instancePagevalues.length > 0 then instancePagevalues else null

    eventPagevalues = []
    event = PageValue.getEventPageValue(PageValue.Key.E_PREFIX)
    for k, v of event
      pageNum = parseInt(k.replace(PageValue.Key.P_PREFIX, ''))
      eventPagevalues.push({
        pageNum: pageNum,
        pagevalue: JSON.stringify(v)

      })
    data[@Key.EVENT_PAGE_VALUE] = if eventPagevalues.length > 0 then eventPagevalues else null

    data[@Key.SETTING_PAGE_VALUE] = JSON.stringify(PageValue.getSettingPageValue(Setting.PageValueKey.PREFIX))

    if data[@Key.INSTANCE_PAGE_VALUE]? || data[@Key.EVENT_PAGE_VALUE]? || data[@Key.SETTING_PAGE_VALUE]?
      $.ajax(
        {
          url: "/page_value_state/save_state"
          type: "POST"
          data: data
          dataType: "json"
          success: (data)->
            # updateフラグ除去
            #PageValue.clearAllUpdateFlg()
            # 「Load」マウスオーバーで取得させるためupdateフラグを消去
            $("##{Constant.ElementAttribute.NAVBAR_ROOT}").find(".#{ServerStorage.ElementAttribute.FILE_LOAD_CLASS} .#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}").remove()
            console.log(data.message)
          error: (data) ->
            console.log(data.message)
        }
      )

  # サーバからアイテムの情報を取得して描画
  @load = (user_pagevalue_id) ->
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
          callback = ->
            clearWorkTable()

            # Pagevalue設置
            if data.instance_pagevalue_data?
              d = JSON.parse(data.instance_pagevalue_data)
              PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, d)
            if data.event_pagevalue_data?
              d = JSON.parse(data.event_pagevalue_data)
              PageValue.setEventPageValueByRootHash(d)
            if data.setting_pagevalue_data?
              d = JSON.parse(data.setting_pagevalue_data)
              PageValue.setSettingPageValue(Setting.PageValueKey.PREFIX, d)

            PageValue.adjustInstanceAndEventOnThisPage()
            PageValue.updatePageCount()
            LocalStorage.saveEventPageValue()
            WorktableCommon.drawAllItemFromEventPageValue()
            Setting.initConfig()

          if item_js_list.length == 0
            callback.call(self)
            return

          loadedCount = 0
          item_js_list.forEach((d) ->
            itemInitFuncName = getInitFuncName(d.item_id)
            if window.itemInitFuncList[itemInitFuncName]?
              # 既に読み込まれている場合はコールバックのみ実行
              window.itemInitFuncList[itemInitFuncName]()
              loadedCount += 1
              if loadedCount >= item_js_list.length
                # 全て読み込んだ後
                callback.call(self)
              return

            if d.css_info?
              option = {isWorkTable: true, css_temp: d.css_info}

            WorktableCommon.availJs(itemInitFuncName, d.js_src, option, ->
              loadedCount += 1
              if loadedCount >= item_js_list.length
                # 全て読み込んだ後
                callback.call(self)
            )
            PageValue.addItemInfo(d.item_id, d.te_actions)
            EventConfig.addEventConfigContents(d.item_id, d.te_actions, d.te_values)
          )

        error: (data) ->
          console.log(data.message)
      }
    )

  @get_load_list: ->
    loadEmt = $("##{Constant.ElementAttribute.NAVBAR_ROOT}").find(".#{@ElementAttribute.FILE_LOAD_CLASS}")
    updateFlg = loadEmt.find(".#{@ElementAttribute.LOAD_LIST_UPDATED_FLG}").length > 0
    if updateFlg
      loadedLocalTime = loadEmt.find(".#{@ElementAttribute.LOADED_LOCALTIME}")
      if loadedLocalTime?
        diffTime = Common.diffTime($.now(), parseInt(loadedLocalTime.val()))
        s = diffTime.seconds
        console.log('loadedLocalTime diff ' + s)
        if parseInt(s) <= @LOAD_LIST_INTERVAL_SECONDS
          # 読み込んでX秒以内ならロードしない
          return

    loadEmt.children().remove()
    $("<li><a class='menu-item'>Loading...</a></li>").appendTo(loadEmt)

    $.ajax(
      {
        url: "/page_value_state/user_pagevalue_list"
        type: "POST"
        dataType: "json"
        success: (data)->
          user_pagevalue_list = data
          if user_pagevalue_list.length > 0
            list = ''
            n = $.now()
            for p in user_pagevalue_list
              d = new Date(p.updated_at)
              e = "<li><a class='menu-item'>#{Common.diffAlmostTime(n, d.getTime())} (#{Common.formatDate(d)})</a><input type='hidden' class='user_pagevalue_id' value=#{p.user_pagevalue_id}></li>"
              list += e
            loadEmt.children().remove()
            $(list).appendTo(loadEmt)
            # クリックイベント設定
            loadEmt.find('li').click((e) ->
              user_pagevalue_id = $(@).find('.user_pagevalue_id:first').val()
              ServerStorage.load(user_pagevalue_id)
            )

            # ロード済みに変更 & 現在時間を記録
            loadEmt.find(".#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}").remove()
            loadEmt.find(".#{ServerStorage.ElementAttribute.LOADED_LOCALTIME}").remove()
            $("<input type='hidden' class=#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG} value='1'>").appendTo(loadEmt)
            $("<input type='hidden' class=#{ServerStorage.ElementAttribute.LOADED_LOCALTIME} value=#{$.now()}>").appendTo(loadEmt)

          else
            loadEmt.children().remove()
            $("<li><a class='menu-item'>No Data</a></li>").appendTo(loadEmt)
        error: (data)->
          console.log(data.responseText)
          loadEmt.children().remove()
          $("<li><a class='menu-item'>Server Access Error</a></li>").appendTo(loadEmt)
      }
    )