# タイムラインイベントのConfigを追加
# @param [String] contents 追加するHTMLの文字列
addTimelineEventContents = (te_actions, te_values) ->
  if te_actions? && te_actions.length > 0
    className = TimelineConfig.ACTION_CLASS.replace('@itemid', te_actions[0].item_id)
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
            <input class='item_id' type='hidden' value='#{a.item_id}' >
            <input class='action_type' type='hidden' value='#{actionType}'>
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
  te = null

  ### private method ここから ###

  # タイムラインイベントを作成
  _createTimelineEvent = (e) ->
    # tempをクローンしてtimeline_eventsに追加
    pEmt = $('#timeline_events')
    newEmt = $('.timeline_event_temp', pEmt).children(':first').clone(true)
    teNum = getPageValue(Constant.PageValueKey.TE_COUNT) + 1
    newEmt.find('.te_num').val(teNum)
    pEmt.append(newEmt)

  # イベント
  _clickTimelineEvent = (e) ->

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
    eId = TimelineConfig.ITEM_ROOT_ID.replace('@te_num', te_num)
    emt = $('#' + eId)
    if emt.length == 0
      # イベントメニューの作成
      emt = $('#timeline-config .timeline_temp .event').clone(true).attr('id', eId)
      $('#timeline-config').append(emt)

    # アイテム選択メニュー更新
    updateSelectItemMenu()

    # Configクラス作成 & イベントハンドラの設定
    te = new TimelineConfig(emt, e)
    do =>
      em = $('.te_item_select', emt)
      em.off('change')
      em.on('change', (e) ->
        te.selectItem(@)
      )
      em = $('.action_forms li', emt)
      em.off('click')
      em.on('click', (e) ->
        te.clickMethod(@)
      )
      em = $('.push.button.reset', emt)
      em.off('click')
      em.on('click', (e) ->
        # UIの入力値を初期化
        te.resetAction()
      )
      em = $('.push.button.apply', emt)
      em.off('click')
      em.on('click', (e) ->
        # 入力値を適用する
        te.applyAction()
        # 次のイベントを作成
        _createTimelineEvent.call(self, e)
        # 次のイベントConfigを表示
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

  ### private method ここまで ###

  # イベントのクリック
  $('.timeline_event').off('click')
  $('.timeline_event').on('click', (e) ->
    _clickTimelineEvent.call(self, @)
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
    itemId = $(@).find('input.itemId').val()
    selectOptions += """
        <option value='#{id}#{Constant.TIMELINE_ITEM_SEPERATOR}#{itemId}'>
          #{name}
        </option>
      """
  )

  # メニューを入れ替え
  teItemSelects.each( ->
    $(@).find('option').each( ->
      if $(@).val().length > 0 && $(@).val().indexOf(Constant.TIMELINE_COMMON_PREFIX) != 0
        $(@).remove()
    )
    $(@).append($(selectOptions))
  )

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