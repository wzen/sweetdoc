# タイムラインイベントを作成
createTimelineEvent = (teNum) ->
  # 存在チェック
  emts = $('#timeline_events .timeline_event .te_num')
  exist = false
  emts.each( (e) ->
    if parseInt($(@).val()) == teNum
      exist = true
  )
  if exist
    return

  # tempをクローンしてtimeline_eventsに追加
  pEmt = $('#timeline_events')
  newEmt = $('.timeline_event_temp', pEmt).children(':first').clone(true)
  $("<input class='te_num' type='hidden' value='#{teNum}' >").appendTo(newEmt)
  pEmt.append(newEmt)

# タイムラインのイベント設定
setupTimelineEventConfig = ->
  self = @
  te = null

  _setupTimelineEvent = ->
    tEmt = $('#timeline_events .timeline_event .te_num')
    tEmt.each((e) ->
      teNum = parseInt($(@).val())
      actionType = getTimelinePageValue(TimelineEvent.PageValueKey.te(teNum) + Constant.PageValueKey.PAGE_VALUES_SEPERATOR + TimelineEvent.PageValueKey.ACTIONTYPE)
      changeTimelineColor(teNum, actionType)
      if e == tEmt.length - 1 && actionType != null
        # blankのイベントが無い場合、作成
        createTimelineEvent(tEmt.length + 1)
    )
    # イベントのクリック
    $('#timeline_events .timeline_event').off('click')
    $('#timeline_events .timeline_event').on('click', (e) ->
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

    # イベントハンドラの設定
    setupTimelineEventHandler(te_num)

    # イベントメニューの表示
    $('#timeline-config .event').css('display', 'none')
    emt.css('display', '')

    # タイムラインのconfigをオープンする
    openConfigSidebar()

    _updateEventState.call(@, te_num)

  # イベントによる表示状態を更新
  _updateEventState = (te_num) ->
    te_num = parseInt(te_num)
    tes = getTimelinePageValueSortedListByNum()

    # 全てをイベント前に変更
    previewinitCount = 0
    for idx in [tes.length - 1 .. 0] by -1
      te = tes[idx]
      item = window.createdObject[te.id]
      item.setEvent(te)
      item.stopPreview( ->
        item.updateEventBefore()
        previewinitCount += 1
      )

    ivTimer = setInterval( ->
      if previewinitCount >= tes.length
        clearInterval(ivTimer)
        for te, idx in tes
          item = window.createdObject[te.id]
          if idx < te_num - 1
            item.setEvent(te)
            item.updateEventAfter()
          else if idx == te_num - 1
            item.setEvent(te)
            # プレビュー実行
            item.preview(te)
            break
    , 100)

  _setupTimelineEvent.call(self)

# アイテム選択メニューを更新
updateSelectItemMenu = ->
  # 作成されたアイテムの一覧を取得
  teItemSelects = $('#timeline-config .te_item_select')
  teItemSelect = teItemSelects[0]
  selectOptions = ''
  items = $("##{Constant.PageValueKey.PV_ROOT} .item")
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

# イベントハンドラー設定
setupTimelineEventHandler = (te_num) ->
  eId = TimelineConfig.ITEM_ROOT_ID.replace('@te_num', te_num)
  emt = $('#' + eId)
  # Configクラス作成 & イベントハンドラの設定
  te = new TimelineConfig(emt, te_num)
  do =>
    em = $('.te_item_select', emt)
    em.off('change')
    em.on('change', (e) ->
      te.clearError()
      te.selectItem(@)
    )

# タイムラインのCSSをまとめる
setupTimeLineCss = ->
  itemCssStyle = ""
  $('#css_code_info').find('.css-style').each( ->
    itemCssStyle += $(this).html()
  )

  if itemCssStyle.length > 0
    setTimelinePageValue(Constant.PageValueKey.TE_CSS, itemCssStyle)

# アクションタイプからアクションタイプクラス名を取得
getActionTypeClassNameByActionType = (actionType) ->
  if parseInt(actionType) == Constant.ActionEventHandleType.CLICK
    return Constant.ActionEventTypeClassName.CLICK
  else if parseInt(actionType) == Constant.ActionEventHandleType.SCROLL
    return Constant.ActionEventTypeClassName.SCROLL
  return null

# タイムラインイベントの色を変更
changeTimelineColor = (teNum, actionType = null) ->
  # イベントの色を変更
  teEmt = null
  $('#timeline_events').children('.timeline_event').each((e) ->
    if parseInt($(@).find('input.te_num:first').val()) == parseInt(teNum)
      teEmt = @
  )

  for k,v of Constant.ActionEventTypeClassName
    $(teEmt).removeClass(v)

  if actionType?
    $(teEmt).addClass(getActionTypeClassNameByActionType(actionType))
  else
    $(teEmt).addClass(Constant.ActionEventTypeClassName.BLANK)

