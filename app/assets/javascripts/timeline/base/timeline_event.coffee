class TimelineEvent

  class @PageValueKey
    # @property [String] te タイムラインイベントRoot
    @te : (teNum) -> 'timeline_event:' + @teNum
    # @property [String] ID アイテムID
    @ID = 'id'
    # @property [String] ITEM_ID アイテムタイプID
    @ITEM_ID = 'item_id'
    # @property [String] ACTION_EVENT_TYPE_ID アクションイベントID
    @ACTION_EVENT_TYPE_ID = 'action_event_type_id'
    # @property [String] VALUE タイムラインイベント値
    @VALUE = 'value'
    # @property [String] IS_COMMON_EVENT タイムライン共通イベント判定
    @IS_COMMON_EVENT = 'is_common_event'
    # @property [String] TE_VALUE タイムライン変更前の値
    #@TE_ORIGINAL_VALUE = @TE + ':originalvalue'
    # @property [String] ORDER ソート番号
    @ORDER = 'order'
    # @property [String] METHODNAME イベント名
    @METHODNAME = 'methodname'
    # @property [String] METHODNAME イベント名
    @ACTIONTYPE = 'actiontype'
    # @property [String] IS_PARALLEL 同時実行
    @IS_CLICK_PARALLEL = 'is_click_parallel'
    # @property [String] SCROLL_TIME スクロール実行時間
    @SCROLL_POINT = 'scroll_point'
    # @property [String] TE_SCROLL_TIME_SEP スクロール実行時間セパレータ
    @SCROLL_POINT_SEP = '-'

  @initConfigValue = (timelineConfig) ->
    if timelineConfig.actionType == Constant.ActionEventTypeClassName.SCROLL
      scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
      if scrollPointDiv?
        startDiv = scrollPointDiv.find('.scroll_point_start:first')
        start = startDiv.val()
        s = null
        if start.length == 0
          s = getPageValue(Constant.PageValueKey.TE_ALL_LENGTH)
          if s?
            startDiv.val(s)
          else
            s = 0
            startDiv.val("0")
            startDiv.prop("disabled", true)
        endDiv = scrollPointDiv.find('.scroll_point_end:first')
        end = endDiv.val()
        if end.length == 0
          endDiv.val(parseInt(s) + _scrollLength(timelineConfig))

  # fixme: 実装予定
  @checkConfigValue = (timelineConfig) ->

  @commonWriteValue = (timelineConfig) ->
    writeValue = {}
    writeValue[TimelineEvent.PageValueKey.ID] = timelineConfig.id
    writeValue[TimelineEvent.PageValueKey.ITEM_ID] = timelineConfig.itemId
    writeValue[TimelineEvent.PageValueKey.ACTION_EVENT_TYPE_ID] = timelineConfig.actionEventTypeId
    writeValue[TimelineEvent.PageValueKey.IS_COMMON_EVENT] = timelineConfig.isCommonEvent
    writeValue[TimelineEvent.PageValueKey.METHODNAME] = timelineConfig.methodName
    writeValue[TimelineEvent.PageValueKey.ACTIONTYPE] = timelineConfig.actionType

    if timelineConfig.actionType == Constant.ActionEventTypeClassName.SCROLL
      scrollPoint = ""
      scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
      if scrollPointDiv?
        start = scrollPointDiv.find('.scroll_point_start:first').val()
        end = scrollPointDiv.find('.scroll_point_end:first').val()
        scrollPoint = start + TimelineEvent.PageValueKey.SCROLL_POINT_SEP + end
      writeValue[TimelineEvent.PageValueKey.SCROLL_POINT] = scrollPoint

    else if timelineConfig.actionType == Constant.ActionEventTypeClassName.CLICK
      isClickParallel = false
      clickParallel = $('.click_parallel_div .click_parallel', timelineConfig.emt)
      if clickParallel?
        isClickParallel = clickParallel.is(":checked")
      writeValue[TimelineEvent.PageValueKey.IS_CLICK_PARALLEL] = isClickParallel

    return writeValue

  @commonReadValue = (timelineConfig) ->
    writeValue = getPageValue(TimelineEvent.PageValueKey.te(timelineConfig.teNum))
    if writeValue?
      if timelineConfig.actionType == Constant.ActionEventTypeClassName.SCROLL
        scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
        scrollPoint = writeValue[TimelineEvent.PageValueKey.SCROLL_POINT]
        if scrollPointDiv? && scrollPoint?
          s = scrollPoint.split(TimelineEvent.PageValueKey.SCROLL_POINT_SEP)
          start = s[0]
          end = s[1]
          scrollPointDiv.find('.scroll_point_start:first').val(start)
          scrollPointDiv.find('.scroll_point_end:first').val(end)

      else if timelineConfig.actionType == Constant.ActionEventTypeClassName.CLICK
        clickParallel = $('.click_parallel_div .click_parallel', timelineConfig.emt)
        isClickParallel = writeValue[TimelineEvent.PageValueKey.IS_CLICK_PARALLEL]
        if clickParallel? && isClickParallel
          clickParallel.prop("checked", true)

  _scrollLength = (timelineConfig) ->
    scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
    writeValue = getPageValue(TimelineEvent.PageValueKey.te(timelineConfig.teNum))
    if writeValue?
      scrollPoint = writeValue[TimelineEvent.PageValueKey.SCROLL_POINT]
      if scrollPointDiv? && scrollPoint?
       s = scrollPoint.split(TimelineEvent.PageValueKey.SCROLL_POINT_SEP)
       start = s[0]
       end = s[1]
       return parseInt(end) - parseInt(start)

    return null






