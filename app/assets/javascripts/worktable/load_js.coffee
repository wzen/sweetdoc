# JSファイルをサーバから読み込む
# @param [Int] itemType アイテム種別
# @param [Function] callback コールバック関数
loadItemJs = (itemType, callback = null) ->
  itemInitFuncName = getInitFuncName(itemType)
  if window.itemInitFuncList[itemInitFuncName]?
    # 既に読み込まれている場合はコールバックのみ実行
    window.itemInitFuncList[itemInitFuncName]()
    if callback?
      callback()
    return

  # js読み込み
  $.ajax(
    {
      url: "/item_js/index"
      type: "POST"
      dataType: "json"
      data: {
        itemId: itemType
      }
      success: (data)->
        if data.css_info?
          option = {isWorkTable: true, css_temp: data.css_info}

        availJs(itemInitFuncName, data.js_src, option, callback)
        addTimelineEventContents(data.te_actions, data.te_values)

      error: (data) ->
    }
  )

# JSファイルを設定
# @param [String] initName アイテム初期化関数名
# @param [String] jsSrc jsファイル名
# @param [Function] callback 設定後のコールバック
availJs = (initName, jsSrc, option = {}, callback = null) ->
  s = document.createElement('script');
  s.type = 'text/javascript';
  # TODO: 認証コードの比較
  s.src = jsSrc;
  firstScript = document.getElementsByTagName('script')[0];
  firstScript.parentNode.insertBefore(s, firstScript);
  t = setInterval( ->
    if window.itemInitFuncList[initName]?
      clearInterval(t)
      window.itemInitFuncList[initName](option)
      if callback?
        callback()
  , '500')

