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
            # 無い場合は新規作成
            self.createTimelineEvent(teNum)
            timelineEvents = $('#timeline_events').children('.timeline_event')
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
        # 操作履歴削除
        PageValue.removeAllFootprint()
        tes = PageValue.getEventPageValueSortedListByNum()
        te_num = parseInt(te_num)
        for te, idx in tes
          item = window.instanceMap[te.id]
          if item?
            item.initEvent(te)
            # インスタンスの状態を保存
            PageValue.saveInstanceObjectToFootprint(item.id, true, item._event[EventPageValueBase.PageValueKey.DIST_ID])
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

    _setupTimelineEvent.call(self)

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
      # PageValueのタイムライン番号を入れ替え
      PageValue.sortEventPageValue(beforeNum, afterNum)
    # タイムライン再作成
    @refreshAllTimeline()



