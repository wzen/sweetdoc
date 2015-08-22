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

  # サーバにアイテムの情報を保存
  @save = ->
    data = {}
    data[@constructor.Key.USER_ID] = 0
    # FIXME: 差分保存 & バッチでフル保存するようにする
    data[@constructor.Key.INSTANCE_PAGE_VALUE] = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
    data[@constructor.Key.EVENT_PAGE_VALUE] = PageValue.getEventPageValue(PageValue.Key.E_PREFIX)
    data[@constructor.Key.SETTING_PAGE_VALUE] = PageValue.getSettingPageValue(Setting.PageValueKey.PREFIX)

    $.ajax(
      {
        url: "/page_value_state/save_state"
        type: "POST"
        data: data
        dataType: "json"
        success: (data)->
          # updateフラグ除去
          #PageValue.clearAllUpdateFlg()
          console.log(data.message)
        error: (data) ->
          console.log(data.message)
      }
    )

  # サーバからアイテムの情報を取得して描画
  @load = ->
    $.ajax(
      {
        url: "/page_value_state/load_state"
        type: "POST"
        data: {
          user_id: 0
          loaded_itemids : JSON.stringify(loadedItemTypeList)
        }
        dataType: "json"
        success: (data)->
          self = @
          # 全て読み込んだ後のコールバック
          callback = ->
            clearWorkTable()
            itemList = JSON.parse(data.item_list)
            for j in itemList
              obj = j.obj
              item = new (Common.getClassFromMap(false, obj.itemId))()
              window.instanceMap[item.id] = item
              item.reDrawByMinimumObject(obj)
              setupEvents(item)

          if data.length == 0
            callback.call(self)
            return

          loadedCount = 0
          data.forEach((d) ->
            itemInitFuncName = getInitFuncName(d.item_id)
            if window.itemInitFuncList[itemInitFuncName]?
              # 既に読み込まれている場合はコールバックのみ実行
              window.itemInitFuncList[itemInitFuncName]()
              loadedCount += 1
              if loadedCount >= data.length
                # 全て読み込んだ後
                callback.call(self)
              return

            if d.css_info?
              option = {isWorkTable: true, css_temp: d.css_info}

            WorktableCommon.availJs(itemInitFuncName, d.js_src, option, ->
              loadedCount += 1
              if loadedCount >= data.length
                # 全て読み込んだ後
                callback.call(self)
            )
            EventConfig.addEventConfigContents(d.te_actions, d.te_values)
          )

        error: (data) ->
          console.log(data.message)
      }
    )

