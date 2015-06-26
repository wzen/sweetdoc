# タイムラインイベントのUIを追加
# @param [String] contents 追加するHTMLの文字列
addTimelineEventContents = (te_actions, te_values) ->
  if te_actions? && te_actions.length > 0
    className = Constant.ElementAttribute.TE_ACTION_CLASS.replace('@itemid', te_actions[0].item_id)
    action_forms = $('#timeline-config .action_forms')
    if action_forms.find(".#{className}").length == 0
      li = ''
      te_actions.forEach( (a) ->
        actionType = null
        if a.action_event_type_id == Constant.ActionEventHandleType.SCROLL
          actionType = "scroll"
        else if a.action_event_type_id == Constant.ActionEventHandleType.CLICK
          actionType = "click"
        li += """
          <li class='push method #{actionType} #{a.method_name}'>
            #{a.options['name']}
            <input class='item_id' type='hidden' value='#{a.item_id}' >
            <input class='method_name' type='hidden' value='#{a.method_name}'>
          </li>
        """
      )

      $("<div class='#{className}'><ul>#{li}</ul></div>").appendTo(action_forms)

  if te_values?
    $(te_values).appendTo($('#timeline-config .value_forms'))

# タイムラインのイベント設定
setupTimelineEvents = ->
  self = @

  # イベント
  clickTimelineEvent = (e) ->
    ieSelf = @

    # アイテム選択メニューを更新
    updateSelectItemMenu = ->

      # 作成されたアイテムの一覧を取得
      teItemSelects = $('#timeline-config .te_item_select')
      teItemSelect = teItemSelects[0]
      selectOptions = ''
      items = $('#page_values .item')
      items.children().each( ->
        id = $(@).find('input.id').val()
        name = $(@).find('input.name').val()
        itemType = $(@).find('input.itemType').val()
        selectOptions += """
          <option value='#{id}&#{itemType}'>
            #{name}
          </option>
        """
      )

      # メニューを入れ替え
      teItemSelects.each( ->
        $(@).find('option').each( ->
          if $(@).val().length > 0 && $(@).val().indexOf('c_') != 0
            $(@).remove()
        )
        $(@).append($(selectOptions))
      )

    # アイテム選択イベント
    selectItem = (e) ->
      # 選択枠消去
      clearSelectedBorder()

      emt = $(e).closest('.event')
      values = $(e).val().split('&')
      v = values[0]
      i = values[1]
      d = null
      isSelectedCommonEvent = v.indexOf('c_') == 0
      if isSelectedCommonEvent
        # 共通のイベントを選択 → 変更値を表示
        d = "values_div"
      else
        # アイテムのイベントを選択 → アクション名一覧を表示
        d = "action_div"
        vEmt = $('#' + v)
        # 選択枠設定
        setSelectedBorder(vEmt, 'timeline')
        # フォーカス
        focusToTarget(vEmt)

      # 一度全て非表示にする
      $(".config.te_div", emt).css('display', 'none')
      $(".#{d} .forms", emt).children("div").css('display', 'none')

      # 表示
      displayClassName = ''
      if isSelectedCommonEvent
        displayClassName = v
      else
        displayClassName = Constant.ElementAttribute.TE_ACTION_CLASS.replace('@itemid', i)
      $(".#{displayClassName}", emt).css('display', '')
      $(".#{d}", emt).css('display', '')
      $("<input type='hidden' class='obj_id', value='#{v}'>").appendTo($('values', emt))

    # アクション名選択イベント
    selectAction = (e) ->
      emt = $(e).closest('.event')
      item_id = $(e).find('input.item_id').val()
      method_name = $(e).find('input.method_name').val()
      valueClassName = Constant.ElementAttribute.TE_VALUES_CLASS.replace('@itemid', item_id).replace('@methodname', method_name)
      $(".values_div .forms", emt).children("div").css('display', 'none')
      $(".#{valueClassName}", emt).css('display', '')
      $(".config.values_div", emt).css('display', '')
      $("<input type='hidden' class='item_id', value='#{item_id}'>").appendTo($('values', emt))
      $("<input type='hidden' class='method_name', value='#{method_name}'>").appendTo($('values', emt))

    # イベントの入力値を初期化する
    resetAction = (e) ->
      $(e).closest('.event')
      $('.values .args', emt).html('')

    # 入力値を適用する
    applyAction = (e) ->
      emt = $(e).closest('.event')
      h = {}
      $('.values input', emt).each( ->
        v = $(@).val()
        k = $(@).attr('class')
        h[k] = v
      )
      # タイムラインイベントの数を更新&タイムラインイベントの値を設定
      teCount = getPageValue(Constant.PageValueKey.TE_COUNT)
      if teCount?
        teCount += 1
      else
        teCount = 1
      # イベントのIDは暫定で連番とする
      setPageValue(Constant.PageValueKey.TE_VALUE.replace('@te_num', teCount), h)
      setPageValue(Constant.PageValueKey.TE_COUNT, teCount)

      # イベントの色を変更


      # 次のイベントを作成
      createTimelineEvent.call(ieSelf, e)
    # 次のイベントを表示


    # タイムラインイベントを作成
    createTimelineEvent = (e) ->
      # tempをクローンしてtimeline_eventsに追加
      pEmt = $('#timeline_events')
      newEmt = $('.timeline_event_temp', pEmt).children(':first').clone(true)
      teNum = getPageValue(Constant.PageValueKey.TE_COUNT) + 1
      newEmt.find('.te_num').val(teNum)
      pEmt.append(newEmt)

    if $(e).is('.ui-sortable-helper')
      # ドラッグの場合はクリック反応なし
      return

    # 選択枠切り替え
    clearSelectedBorder()
    setSelectedBorder(e, "timeline")
    # サイドメニューをタイムラインに切り替え
    switchSidebarConfig("timeline")

    # イベントメニューの存在チェック
    te_num = $(e).find('input.te_num').val()
    eId = Constant.ElementAttribute.TE_ITEM_ROOT_ID.replace('@te_num', te_num)
    emt = $('#' + eId)
    if emt.length == 0
      # イベントメニューの作成
      emt = $('#timeline-config .timeline_temp .event').clone(true).attr('id', eId)
      $('#timeline-config').append(emt)

    # アイテム選択メニュー更新
    updateSelectItemMenu.call(ieSelf)

    # JSイベントの追加
    do =>
      em = $('.te_item_select', emt)
      em.off('change')
      em.on('change', (e) ->
        selectItem.call(ieSelf, @)
      )
      em = $('.action_forms li', emt)
      em.off('click')
      em.on('click', (e) ->
        selectAction.call(ieSelf, @)
      )
      em = $('.push.button.reset', emt)
      em.off('click')
      em.on('click', (e) ->
        # UIの入力値を初期化
        resetAction.call(ieSelf, @)
      )
      em = $('.push.button.apply', emt)
      em.off('click')
      em.on('click', (e) ->
        # 入力値を適用する
        applyAction.call(ieSelf, @)
      )
      em = $('.push.button.cancel', emt)
      em.off('click')
      em.on('click', (e) ->
        # 入力を全てクリアしてサイドバーを閉じる
        emt = $(@).closest('.event')
        $('.values', emt).html('')
        closeSidebar( ->
          $(".config.te_div", emt).css('display', 'none')
        )
      )

    # イベントメニューの表示
    $('#timeline-config .event').css('display', 'none')
    emt.css('display', '')

    if !isOpenedConfigSidebar()
      # タイムラインのconfigをオープンする
      openConfigSidebar()


    # コンフィグ初期化
    if $(e).hasClass('blank')
      # ブランク
      # アイテムのリストを表示

    else
      # イベント設定済み


# イベントのクリック
  $('.timeline_event').off('click')
  $('.timeline_event').on('click', (e) ->
    clickTimelineEvent.call(self, @)
  )

  # イベントのD&D
  $('#timeline_events').sortable({
    revert: true
    axis: 'x'
    containment: $('#timeline_events_container')
    items: '.sortable'
    stop: (event, ui) ->
      # イベントのソート番号を更新
  })

# タイムラインのオブジェクトをまとめる
setupTimeLineObjects = ->
  # 処理は暫定(itemObjectListから取っているが、本当はタイムラインの情報を取る)

  # Storageに値を格納
  # とりあえず矢印だけ
  objList = []
  itemObjectList.forEach((item) ->
    obj = {
      chapter: 1
      screen: 1
      miniObj: item.getMinimumObject()
      itemSize: item.itemSize
      sEvent: "scrollDraw"
      cEvent: "defaultClick"
    }
    objList.push(obj)
  )
  return objList

# タイムラインのCSSをまとめる
setupTimeLineCss = ->
  itemCssStyle = ""
  $('#css_code_info').find('.css-style').each( ->
    itemCssStyle += $(this).html()
  )
  # 暫定処理
  itemObjectList.forEach((item) ->
    if ButtonItem? && item instanceof ButtonItem
      # cssアニメーション
      itemCssStyle += ButtonItem.dentButton(item)
  )

  return itemCssStyle