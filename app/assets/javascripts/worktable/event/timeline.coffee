class Timeline

  # タイムラインを作成
  # @param [Integer] teNum 作成するイベント番号
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

    # 設定開始
    _setupTimelineEvent = ->
      ePageValues = PageValue.getEventPageValueSortedListByNum()
      timelineEvents = $('#timeline_events').children('.timeline_event')
      emt = null
      if ePageValues.length > 0
        # 色、数値、Sync線を更新
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

          # 同期線
          if pageValue[EventPageValueBase.PageValueKey.IS_SYNC]
            # 線表示
            timelineEvents.eq(idx).before("<div class='sync_line #{Common.getActionTypeClassNameByActionType(actionType)}'></div>")
          else
            # 線消去
            timelineEvents.eq(idx).prev('.sync_line').remove()

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
        start: (event, ui) ->
          # 同期線消去
          $('#timeline_events .sync_line').remove()
        update: (event, ui) ->
          # イベントのソート番号を更新
          target = $(ui.item)
          beforeNum = parseInt(target.find('.te_num:first').val())
          afterNum = null
          tes = $('#timeline_events').children('.timeline_event')
          tes.each((idx) ->
            if parseInt($(@).find('.te_num:first').val()) == beforeNum
              afterNum = idx + 1
          )
          if afterNum?
            Timeline.changeSortTimeline(beforeNum, afterNum)
      })
      # イベントの右クリック
      menu = [{title: I18n.t('context_menu.edit'), cmd: "edit", uiIcon: "ui-icon-scissors"}]
      menu.push({
        title: I18n.t('context_menu.delete')
        cmd: "delete"
        uiIcon: "ui-icon-scissors"
      })
      timelineEvents.filter((idx) ->
        return !$(@).hasClass('temp') && !$(@).hasClass('blank')
      ).contextmenu(
        {
          preventContextMenuForPopup: true
          preventSelect: true
          menu: menu
          select: (event, ui) ->
            target = event.target
            switch ui.cmd
              when "edit"
                _initEventConfig.call(self, target)
              when "delete"
                _deleteTimeline.call(self, target)
              else
                return
        }
      )

    # クリックイベント内容
    # @param [Object] e イベントオブジェクト
    _clickTimelineEvent = (e) ->

      if $(e).is('.ui-sortable-helper')
        # ドラッグの場合はクリック反応なし
        return

      # 選択枠切り替え
      WorktableCommon.clearSelectedBorder()
      WorktableCommon.setSelectedBorder(e, "timeline")

      if Sidebar.isOpenedConfigSidebar() || $(e).hasClass(Constant.TimelineActionTypeClassName.BLANK)
        # サイドバー表示時 or Blankの場合はコンフィグを設定&表示
        _initEventConfig.call(@, e)

      # プレビュー
      te_num = $(e).find('input.te_num').val()
      _doPreview.call(@, te_num)

    # プレビュー実行
    # @param [Integer] te_num 実行するイベント番号
    _doPreview = (te_num) ->
      Common.clearAllEventAction( ->
        tes = PageValue.getEventPageValueSortedListByNum()
        te_num = parseInt(te_num)
        for te, idx in tes
          item = window.instanceMap[te.id]
          if item?
            item.initEvent(te)
            # インスタンスの状態を保存
            PageValue.saveInstanceObjectToFootprint(item.id, true, item.event[EventPageValueBase.PageValueKey.DIST_ID])
            if idx < te_num - 1
               item.updateEventAfter()
            else if idx == te_num - 1
              # プレビュー実行
              item.preview(te)
              break
      )

    # タイムライン削除
    _deleteTimeline = (target) ->
      eNum = parseInt($(target).find('.te_num:first').val())
      # EventPageValueを削除
      PageValue.removeEventPageValue(eNum)
      # タイムライン表示更新
      Timeline.refreshAllTimeline()

    # コンフィグメニュー初期化&表示
    # @param [Object] e 対象オブジェクト
    _initEventConfig = (e) ->
      # サイドメニューをタイムラインに切り替え
      Sidebar.switchSidebarConfig(Sidebar.Type.TIMELINE)

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
      $('#event-config .event').hide()
      emt.show()

      # サイドバー表示
      Sidebar.openConfigSidebar()

    _setupTimelineEvent.call(self)

  # アイテム選択メニューを更新
  @updateSelectItemMenu = ->
    # 作成されたアイテムの一覧を取得
    teItemSelects = $('#event-config .te_item_select')
    teItemSelect = teItemSelects[0]
    selectOptions = ''
    items = $("##{PageValue.Key.IS_ROOT} .#{PageValue.Key.INSTANCE_PREFIX} .#{PageValue.Key.pageRoot()}")
    items.children().each( ->
      id = $(@).find('input.id').val()
      name = $(@).find('input.name').val()
      itemId = $(@).find('input.itemId').val()
      if itemId?
        selectOptions += """
            <option value='#{id}#{EventConfig.EVENT_ITEM_SEPERATOR}#{itemId}'>
              #{name}
            </option>
          """
    )
    itemOptgroupClassName = 'item_optgroup_class_name'
    selectOptions = "<optgroup class='#{itemOptgroupClassName}' label='#{I18n.t("config.select_opt_group.item")}'>" + selectOptions + '</optgroup>'
    # メニューを入れ替え
    teItemSelects.each( ->
      $(@).find(".#{itemOptgroupClassName}").remove()
      $(@).append($(selectOptions))
    )

  # イベントハンドラー設定
  # @param [Integer] te_num イベント番号
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

  # タイムラインイベントの色を変更
  # @param [Integer] teNum イベント番号
  # @param [Integer] actionType アクションタイプ
  @changeTimelineColor = (teNum, actionType = null) ->
    # イベントの色を変更
    teEmt = null
    $('#timeline_events').children('.timeline_event').each((e) ->
      if parseInt($(@).find('input.te_num:first').val()) == parseInt(teNum)
        teEmt = @
    )

    for k,v of Constant.TimelineActionTypeClassName
      $(teEmt).removeClass(v)

    if actionType?
      $(teEmt).addClass(Common.getActionTypeClassNameByActionType(actionType))
    else
      $(teEmt).addClass(Constant.TimelineActionTypeClassName.BLANK)

  # EventPageValueを参照してタイムラインを更新
  @refreshAllTimeline: ->
    Indicator.showIndicator(Indicator.Type.TIMELINE)

    # 非同期で実行
    setTimeout( =>
      pEmt = $('#timeline_events')
      pEmt.children().each((e) ->
        emt = $(@)
        if emt.hasClass('timeline_event_temp') == false
          emt.remove()
      )
      @setupTimelineEventConfig()
      Indicator.hideIndicator(Indicator.Type.TIMELINE)
    , 0)

  # タイムラインソートイベント
  @changeSortTimeline: (beforeNum, afterNum) ->
    if beforeNum != afterNum
      PageValue.sortEventPageValue(beforeNum, afterNum)
    @refreshAllTimeline()



