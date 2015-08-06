# サーバにアイテムの情報を保存
saveToServer = ->
  jsonList = []
  for k, v of createdObject
    j = {
      id: makeClone(v.id)
      obj: v.getMinimumObject()
    }
    jsonList.push(j)

  $.ajax(
    {
      url: "/item_state/save_itemstate"
      type: "POST"
      data: {
        user_id: 0
        state: JSON.stringify(jsonList)
      }
      dataType: "json"
      success: (data)->
        console.log(data.message)
      error: (data) ->
        console.log(data.message)
    }
  )

# サーバからアイテムの情報を取得して描画
loadFromServer = ->
  $.ajax(
    {
      url: "/item_state/load_itemstate"
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
            item = null
            if obj.itemId == Constant.ItemId.BUTTON
              item = new WorkTableButtonItem()
            else if obj.itemId == Constant.ItemId.ARROW
              item = new WorkTableArrowItem()
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

          availJs(itemInitFuncName, d.js_src, option, ->
            loadedCount += 1
            if loadedCount >= data.length
              # 全て読み込んだ後
              callback.call(self)
          )
          addTimelineEventContents(d.te_actions, d.te_values)
        )

      error: (data) ->
        console.log(data.message)
    }
  )
