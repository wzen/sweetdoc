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
    newEmt.find('.te_num').val(teNum)
    newEmt.find('.dist_id').val(Common.generateId())
    #$("<input class='te_num' type='hidden' value='#{teNum}' >").appendTo(newEmt)
    pEmt.append(newEmt)

  # タイムラインのイベント設定
  @setupTimelineEventConfig = (onlyTail) ->
    te = null

    # 設定開始
    _setupTimelineEvent = ->
      ePageValues = PageValue.getEventPageValueSortedListByNum()
      timelineEvents = $('#timeline_events').children('.timeline_event')
      emt = null
      if ePageValues.length > 0
        if onlyTail
          idx = ePageValues.length - 1
          _createEvent.call(@, timelineEvents, ePageValues[idx], idx)
          timelineEvents = $('#timeline_events').children('.timeline_event')
        else
          # 色、数値、Sync線を更新
          for pageValue, idx in ePageValues
            _createEvent.call(@, timelineEvents, pageValue, idx)
          timelineEvents = $('#timeline_events').children('.timeline_event')
          # 不要なタイムラインイベントを削除
          if ePageValues.length < timelineEvents.length - 1
            for i in [(ePageValues.length)..(timelineEvents.length - 1)]
              emt = timelineEvents.get(i)
              emt.remove()
      else
        @createTimelineEvent(1)

      # blankイベントを新規作成
      @createTimelineEvent(ePageValues.length + 1)

      # 再取得
      timelineEvents = $('#timeline_events').children('.timeline_event')

      # イベントのクリック
      timelineEvents.off('click').on('click', (e) =>
        _clickTimelineEvent.call(@, $(e.target))
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
      menu = [{title: I18n.t('context_menu.preview'), cmd: "preview", uiIcon: "ui-icon-scissors"}]
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
          select: (event, ui) =>
            target = event.target
            switch ui.cmd
              when "preview"
                te_num = $(target).find('input.te_num').val()
                WorktableCommon.runPreview(te_num)
              when "delete"
                if window.confirm(I18n.t('message.dialog.delete_event'))
                  _deleteTimeline.call(@, target)
              else
                return
        }
      )

    # イベント作成
    _createEvent = (timelineEvents, pageValue, idx) ->
      teNum = idx + 1
      emt = timelineEvents.eq(idx)
      if emt.length == 0
        # 無い場合は新規作成
        @createTimelineEvent(teNum)
      $('.te_num', emt).val(teNum)
      $('.dist_id', emt).val(pageValue[EventPageValueBase.PageValueKey.DIST_ID])
      actionType = pageValue[EventPageValueBase.PageValueKey.ACTIONTYPE]
      Timeline.changeTimelineColor(teNum, actionType)

      # 同期線
      if pageValue[EventPageValueBase.PageValueKey.IS_SYNC]
        # 線表示
        timelineEvents.eq(idx).before("<div class='sync_line #{Common.getActionTypeClassNameByActionType(actionType)}'></div>")
      else
        # 線消去
        timelineEvents.eq(idx).prev('.sync_line').remove()

    # クリックイベント内容
    # @param [Object] e イベントオブジェクト
    _clickTimelineEvent = (e) ->
      if $(e).is('.ui-sortable-helper')
        # ドラッグの場合はクリック反応なし
        return
      # コンフィグを開く
      _initEventConfig.call(@, e)
      # 選択枠
      WorktableCommon.setSelectedBorder($(e), 'timeline')

    # タイムライン削除
    _deleteTimeline = (target) ->
      eNum = parseInt($(target).find('.te_num:first').val())
      # EventPageValueを削除
      PageValue.removeEventPageValue(eNum)
      # キャッシュ更新
      LocalStorage.saveAllPageValues()
      # タイムライン表示更新
      Timeline.refreshAllTimeline()

    # コンフィグメニュー初期化&表示
    # @param [Object] e 対象オブジェクト
    _initEventConfig = (e) ->
      # サイドメニューをタイムラインに切り替え
      Sidebar.switchSidebarConfig(Sidebar.Type.EVENT)
      teNum = $(e).find('input.te_num').val()
      distId = $(e).find('input.dist_id').val()
      Sidebar.initEventConfig(distId, teNum)
      # イベントメニューの表示
      $('#event-config .event').hide()
      eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId)
      $("##{eId}").show()
      # サイドバー表示
      Sidebar.openConfigSidebar()

    _setupTimelineEvent.call(@)

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
      # 全消去
      pEmt = $('#timeline_events')
      pEmt.children().each((e) ->
        emt = $(@)
        if emt.hasClass('timeline_event_temp') == false
          emt.remove()
      )
      @setupTimelineEventConfig(false)
      Indicator.hideIndicator(Indicator.Type.TIMELINE)
    , 0)

  # イベントを追加
  @addEvent: ->
    @setupTimelineEventConfig(true)

  # タイムラインソートイベント
  @changeSortTimeline: (beforeNum, afterNum) ->
    if beforeNum != afterNum
      # PageValueのタイムライン番号を入れ替え
      PageValue.sortEventPageValue(beforeNum, afterNum)
    # タイムライン再作成
    @refreshAllTimeline()

  # 操作不可にする
  @disabledOperation = (flg) ->
    if flg
      if $('#timeline_container .cover_touch_overlay').length == 0
        $('#timeline_container').append("<div class='cover_touch_overlay'></div>")
        $('.cover_touch_overlay').off('click').on('click', (e) ->
          e.preventDefault()
          return
        )
    else
      $('#timeline_container .cover_touch_overlay').remove()
