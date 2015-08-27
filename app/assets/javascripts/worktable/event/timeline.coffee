class Timeline

  # タイムラインを作成
  @createTimelineEvent = (teNum) ->
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
  @setupTimelineEventConfig = ->
    self = @
    te = null

    _setupTimelineEvent = ->
      ePageValues = PageValue.getEventPageValueSortedListByNum()
      timelineEvents = $('#timeline_events').children('.timeline_event')
      emt = null
      if ePageValues.length > 0
        # 色と数値を更新
        for pageValue, idx in ePageValues
          teNum = idx + 1
          emt = timelineEvents.eq(idx)
          if emt.length == 0
            # 新規作成
            self.createTimelineEvent(teNum)
            timelineEvents = $('#timeline_events').children('.timeline_event')
          $('.te_num', emt).val(teNum)
          actionType = pageValue[EventPageValueBase.PageValueKey.ACTIONTYPE]
          Timeline.changeTimelineColor(teNum, actionType)

        # 不要なタイムラインイベントを削除
        if ePageValues.length < timelineEvents.length - 1
          for i in [(ePageValues.length)..(timelineEvents.length - 1)]
            emt = timelineEvents.get(i)
            emt.remove()
      else
        @createTimelineEvent(1)

      # blankイベントを新規作成
      self.createTimelineEvent(ePageValues.length + 1)

      # 再取得
      timelineEvents = $('#timeline_events').children('.timeline_event')

      # イベントのクリック
      timelineEvents.off('click')
      timelineEvents.on('click', (e) ->
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
      # イベントの右クリック
      menu = [{title: "Edit", cmd: "edit", uiIcon: "ui-icon-scissors"}]
      timelineEvents.each((e) ->
        t = $(@)
        t.contextmenu(
          {
            preventContextMenuForPopup: true
            preventSelect: true
            menu: menu
            select: (event, ui) ->
              target = event.target
              switch ui.cmd
                when "edit"
                  _initEventConfig.call(self, target)
                else
                  return
          }
        )
      )

    # イベント
    _clickTimelineEvent = (e) ->

      if $(e).is('.ui-sortable-helper')
        # ドラッグの場合はクリック反応なし
        return

      # 選択枠切り替え
      clearSelectedBorder()
      setSelectedBorder(e, "timeline")

      if Sidebar.isOpenedConfigSidebar() || $(e).hasClass(Constant.ActionEventTypeClassName.BLANK)
        # サイドバー表示時 or Blankの場合はコンフィグを設定&表示
        _initEventConfig.call(@, e)

      # プレビュー
      te_num = $(e).find('input.te_num').val()
      _doPreview.call(@, te_num)

    # プレビュー実行
    _doPreview = (te_num) ->
      Common.clearAllEventChange( ->
        tes = PageValue.getEventPageValueSortedListByNum()
        te_num = parseInt(te_num)
        for te, idx in tes
          item = window.instanceMap[te.id]
          if item?
            if idx < te_num - 1
              item.setEvent(te)
              item.updateEventAfter()
            else if idx == te_num - 1
              item.setEvent(te)
              # プレビュー実行
              item.preview(te)
              break
      )

    # イベントコンフィグの設定&表示
    _initEventConfig = (e) ->
      # サイドメニューをタイムラインに切り替え
      Sidebar.switchSidebarConfig("timeline")

      te_num = $(e).find('input.te_num').val()
      eId = EventConfig.ITEM_ROOT_ID.replace('@te_num', te_num)
      emt = $('#' + eId)
      if emt.length == 0
        # イベントメニューの作成
        emt = $('#event-config .event_temp .event').clone(true).attr('id', eId)
        $('#event-config').append(emt)

      # アイテム選択メニュー更新
      self.updateSelectItemMenu()

      # イベントハンドラの設定
      self.setupTimelineEventHandler(te_num)

      # イベントメニューの表示
      $('#event-config .event').css('display', 'none')
      emt.css('display', '')

      # サイドバー表示
      Sidebar.openConfigSidebar()

    _setupTimelineEvent.call(self)

  # アイテム選択メニューを更新
  @updateSelectItemMenu = ->
    # 作成されたアイテムの一覧を取得
    teItemSelects = $('#event-config .te_item_select')
    teItemSelect = teItemSelects[0]
    selectOptions = ''
    items = $("##{PageValue.Key.IS_ROOT} .#{PageValue.Key.INSTANCE_PREFIX}")
    items.children().each( ->
      id = $(@).find('input.id').val()
      name = $(@).find('input.name').val()
      itemId = $(@).find('input.itemId').val()
      selectOptions += """
          <option value='#{id}#{Constant.EVENT_ITEM_SEPERATOR}#{itemId}'>
            #{name}
          </option>
        """
    )

    # メニューを入れ替え
    teItemSelects.each( ->
      $(@).find('option').each( ->
        if $(@).val().length > 0 && $(@).val().indexOf(Constant.EVENT_COMMON_PREFIX) != 0
          $(@).remove()
      )
      $(@).append($(selectOptions))
    )

  # イベントハンドラー設定
  @setupTimelineEventHandler = (te_num) ->
    eId = EventConfig.ITEM_ROOT_ID.replace('@te_num', te_num)
    emt = $('#' + eId)
    # Configクラス作成 & イベントハンドラの設定
    te = new EventConfig(emt, te_num)
    do =>
      em = $('.te_item_select', emt)
      em.off('change')
      em.on('change', (e) ->
        te.clearError()
        te.selectItem(@)
      )

  # タイムラインのCSSをまとめる
  @setupEventCss = ->
    itemCssStyle = ""
    $('#css_code_info').find('.css-style').each( ->
      itemCssStyle += $(this).html()
    )

    if itemCssStyle.length > 0
      PageValue.setEventPageValue(PageValue.Key.E_CSS, itemCssStyle)

  # タイムラインイベントの色を変更
  @changeTimelineColor = (teNum, actionType = null) ->
    # イベントの色を変更
    teEmt = null
    $('#timeline_events').children('.timeline_event').each((e) ->
      if parseInt($(@).find('input.te_num:first').val()) == parseInt(teNum)
        teEmt = @
    )

    for k,v of Constant.ActionEventTypeClassName
      $(teEmt).removeClass(v)

    if actionType?
      $(teEmt).addClass(Common.getActionTypeClassNameByActionType(actionType))
    else
      $(teEmt).addClass(Constant.ActionEventTypeClassName.BLANK)

  # EventPageValueを参照してタイムラインを更新
  @refreshAllTimeline: ->
    pEmt = $('#timeline_events')
    pEmt.children().each((e) ->
      emt = $(@)
      if emt.hasClass('timeline_event_temp') == false
        emt.remove()
    )
    @setupTimelineEventConfig()
