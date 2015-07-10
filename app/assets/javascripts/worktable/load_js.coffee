# JSファイルをサーバから読み込む
# @param [Int] itemId アイテム種別
# @param [Function] callback コールバック関数
loadItemJs = (itemId, callback = null) ->
  itemInitFuncName = getInitFuncName(itemId)
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
        itemId: itemId
      }
      success: (data)->
        if data.css_info?
          option = {isWorkTable: true, css_temp: data.css_info}

        availJs(itemInitFuncName, data.js_src, option, callback)
        addItemInfo(data.item_id, data.te_actions)
        addTimelineEventContents(data.item_id, data.te_actions, data.te_values)

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

# アイテム情報を追加
addItemInfo = (item_id, te_actions) ->
  if te_actions? && te_actions.length > 0
    te_actions.forEach( (a) ->
      if a.is_default? && a.is_default
        setPageValue(Constant.PageValueKey.ITEM_DEFAULT_METHODNAME.replace('@item_id', item_id), a.method_name)
        setPageValue(Constant.PageValueKey.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', item_id), a.action_event_type_id)
    )

# タイムラインイベントのConfigを追加
# @param [String] contents 追加するHTMLの文字列
addTimelineEventContents = (item_id, te_actions, te_values) ->
  if te_actions? && te_actions.length > 0
    className = TimelineConfig.ACTION_CLASS.replace('@itemid', item_id)
    action_forms = $('#timeline-config .action_forms')
    if action_forms.find(".#{className}").length == 0
      li = ''
      te_actions.forEach( (a) ->
        actionType = null
        if a.action_event_type_id == Constant.ActionEventHandleType.SCROLL
          actionType = Constant.ActionEventTypeClassName.SCROLL
        else if a.action_event_type_id == Constant.ActionEventHandleType.CLICK
          actionType = Constant.ActionEventTypeClassName.CLICK
        li += """
          <li class='push method #{actionType}'>
            #{a.options['name']}
          </li>
        """
      )

      $("<div class='#{className}'><ul>#{li}</ul></div>").appendTo(action_forms)

  if te_values?
    $(te_values).appendTo($('#timeline-config .value_forms'))