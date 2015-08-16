# JSファイルをサーバから読み込む
# @param [Int] itemId アイテム種別
# @param [Function] callback コールバック関数
loadItemJs = (itemIds, callback = null) ->
  if jQuery.type(itemIds) != "array"
    itemIds = [itemIds]

  callbackCount = 0
  needReadItemIds = []
  for itemId in itemIds
    itemInitFuncName = getInitFuncName(itemId)
    if window.itemInitFuncList[itemInitFuncName]?
      # 読み込み済みなアイテムIDの場合
      window.itemInitFuncList[itemInitFuncName]()
      callbackCount += 1
      if callbackCount >= itemIds.length
        if callback?
          # 既に全て読み込まれている場合はコールバック実行して終了
          callback()
        return
    else
      # Ajaxでjs読み込みが必要なアイテムID
      needReadItemIds.push(itemId)

  # js読み込み
  $.ajax(
    {
      url: "/item_js/index"
      type: "POST"
      dataType: "json"
      data: {
        itemIds: needReadItemIds
      }
      success: (data)->
        callbackCount = 0
        for d in data
          if d.css_info?
            option = {isWorkTable: true, css_temp: d.css_info}

          availJs(getInitFuncName(d.item_id), d.js_src, option, ->
            callbackCount += 1
            if callback? && callbackCount >= data.length
              callback()
          )
          addItemInfo(d.item_id, d.te_actions)
          addEventConfigContents(d.item_id, d.te_actions, d.te_values)

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
        # デフォルトメソッド & デフォルトアクションタイプ
        PageValue.setPageValue(Constant.PageValueKey.ITEM_DEFAULT_METHODNAME.replace('@item_id', item_id), a.method_name)
        PageValue.setPageValue(Constant.PageValueKey.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', item_id), a.action_event_type_id)
        PageValue.setPageValue(Constant.PageValueKey.ITEM_DEFAULT_ANIMATIONTYPE.replace('@item_id', item_id), a.action_animation_type_id)
    )

# タイムラインイベントのConfigを追加
# @param [String] contents 追加するHTMLの文字列
addEventConfigContents = (item_id, te_actions, te_values) ->
  if te_actions? && te_actions.length > 0
    className = EventConfig.ITEM_ACTION_CLASS.replace('@itemid', item_id)
    handler_forms = $('#event-config .handler_div .configBox')
    action_forms = $('#event-config .action_forms')
    if action_forms.find(".#{className}").length == 0

      actionParent = $("<div class='#{className}' style='display:none'></div>")
      te_actions.forEach( (a) ->
        # アクションメソッドConfig追加
        actionType = getActionTypeClassNameByActionType(a.action_event_type_id)
        methodClone = $('#event-config .method_temp').children(':first').clone(true)
        span = methodClone.find('label:first').children('span:first')
        span.attr('class', actionType)
        span.html(a.options['name'])
        methodClone.find('input.action_type:first').val(a.action_event_type_id)
        methodClone.find('input.method_name:first').val(a.method_name)
        methodClone.find('input.animation_type:first').val(a.action_animation_type_id)
        valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@itemid', item_id).replace('@methodname', a.method_name)
        methodClone.find('input:radio').attr('name', className)
        methodClone.find('input.value_class_name:first').val(valueClassName)
        actionParent.append(methodClone)

        # イベントタイプConfig追加
        handlerClone = null
        if a.action_event_type_id == Constant.ActionEventHandleType.SCROLL
          handlerClone = $('#event-config .handler_scroll_temp').children().clone(true)
        else if a.action_event_type_id == Constant.ActionEventHandleType.CLICK
          handlerClone = $('#event-config .handler_click_temp').children().clone(true)
        handlerParent = $("<div class='#{valueClassName}' style='display:none'></div>")
        handlerParent.append(handlerClone)
        handlerParent.appendTo(handler_forms)
      )

      actionParent.appendTo(action_forms)

  if te_values?
    $(te_values).appendTo($('#event-config .value_forms'))
