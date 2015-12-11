class ItemPreviewEventConfig extends EventConfig
  # 入力値を適用する
  applyAction: ->
    # 入力値を保存
    if !@[EventPageValueBase.PageValueKey.DIST_ID]?
      @[EventPageValueBase.PageValueKey.DIST_ID] = Common.generateId()

    @[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF] = {
      x: parseInt($('.item_position_diff_x:first', @emt).val())
      y: parseInt($('.item_position_diff_y:first', @emt).val())
      w: parseInt($('.item_diff_width:first', @emt).val())
      h: parseInt($('.item_diff_height:first', @emt).val())
    }

    @[EventPageValueBase.PageValueKey.DO_FOCUS] = $('.do_focus', @emt).prop('checked')

    @[EventPageValueBase.PageValueKey.IS_SYNC] = false
    parallel = $(".parallel_div .parallel", @emt)
    if parallel?
      @[EventPageValueBase.PageValueKey.IS_SYNC] = parallel.is(":checked")

    if @[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionType.SCROLL
      @[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = ''
      @[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = ""
      handlerDiv = $(".handler_div .#{@methodClassName()}", @emt)
      if handlerDiv?
        @[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = handlerDiv.find('.scroll_point_start:first').val()
        @[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = handlerDiv.find('.scroll_point_end:first').val()

        topEmt = handlerDiv.find('.scroll_enabled_top:first')
        bottomEmt = handlerDiv.find('.scroll_enabled_bottom:first')
        leftEmt = handlerDiv.find('.scroll_enabled_left:first')
        rightEmt = handlerDiv.find('.scroll_enabled_right:first')
        @[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS] = {
          top: topEmt.find('.scroll_enabled:first').is(":checked")
          bottom: bottomEmt.find('.scroll_enabled:first').is(":checked")
          left: leftEmt.find('.scroll_enabled:first').is(":checked")
          right: rightEmt.find('.scroll_enabled:first').is(":checked")
        }
        @[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS] = {
          top: topEmt.find('.scroll_forward:first').is(":checked")
          bottom: bottomEmt.find('.scroll_forward:first').is(":checked")
          left: leftEmt.find('.scroll_forward:first').is(":checked")
          right: rightEmt.find('.scroll_forward:first').is(":checked")
        }

    else if @[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionType.CLICK
      handlerDiv = $(".handler_div .#{@methodClassName()}", @emt)
      if handlerDiv?
        @[EventPageValueBase.PageValueKey.EVENT_DURATION] = handlerDiv.find('.click_duration:first').val()

        @[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = 0
        checked = handlerDiv.find('.enable_fork:first').is(':checked')
        if checked? && checked
          prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '')
          @[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''))

    if @[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      # 共通イベントはここでインスタンス生成
      commonEventClass = Common.getClassFromMap(true, @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID])
      commonEvent = new commonEventClass()
      if !instanceMap[commonEvent.id]?
        # ※インスタンスが存在しない場合のみsetInstanceする
        instanceMap[commonEvent.id] = commonEvent
        commonEvent.setItemAllPropToPageValue()
      @[EventPageValueBase.PageValueKey.ID] = commonEvent.id

    errorMes = @writeToPageValue()
    if errorMes? && errorMes.length > 0
      # エラー発生時
      @showError(errorMes)
      return

    # キャッシュに保存
    LocalStorage.saveAllPageValues()
    # Run開始
    ItemPreviewCommon.switchRun()

window.EventConfig = ItemPreviewEventConfig