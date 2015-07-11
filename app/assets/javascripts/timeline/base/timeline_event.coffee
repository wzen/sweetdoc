class TimelineEvent

  if gon?
  # 定数
    constant = gon.const

    class @PageValueKey
      # @property [String] te タイムラインイベントRoot
      @te : (teNum) ->
        constant.PageValueKey.TE_PREFIX + ':' + Constant.PageValueKey.TE_NUM_PREFIX + teNum
      # @property [String] ID アイテムID
      @ID = 'id'
      # @property [String] ITEM_ID アイテムタイプID
      @ITEM_ID = 'item_id'
      # @property [String] ACTION_EVENT_TYPE_ID アクションイベントID
      @ACTION_EVENT_TYPE_ID = 'action_event_type_id'
      # @property [String] VALUE タイムラインイベント値
      @VALUE = 'value'
      # @property [String] CHAPTER チャプター
      @CHAPTER = 'chapter'
      # @property [String] SCREEN スクリーン
      @SCREEN = 'screen'
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

  @inputTagName = (teNum, key) ->
    return "#{@PageValueKey.te(teNum)}:#{key}"

  @initCommonConfigValue = (timelineConfig) ->
    if timelineConfig.actionType == Constant.ActionEventTypeClassName.SCROLL
      scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
      if scrollPointDiv?
        startDiv = scrollPointDiv.find('.scroll_point_start:first')
        start = startDiv.val()
        s = null
        if start.length == 0
          s = TimelineEvent.getAllScrollLength()
          startDiv.val(s)
          if s == 0
            startDiv.prop("disabled", true)
        endDiv = scrollPointDiv.find('.scroll_point_end:first')
        end = endDiv.val()
        if end.length == 0
          endDiv.val(parseInt(s) + _scrollLength.call(@, timelineConfig))

  # fixme: 実装予定
  @checkConfigValue = (timelineConfig) ->

  @commonWriteValue = (timelineConfig) ->
    writeValue = {}
    writeValue[@PageValueKey.ID] = timelineConfig.id
    writeValue[@PageValueKey.ITEM_ID] = timelineConfig.itemId
    writeValue[@PageValueKey.ACTION_EVENT_TYPE_ID] = timelineConfig.actionEventTypeId
    # fixme
    writeValue[@PageValueKey.CHAPTER] = 1
    # fixme
    writeValue[@PageValueKey.CHAPTER] = 1
    writeValue[@PageValueKey.IS_COMMON_EVENT] = timelineConfig.isCommonEvent
    writeValue[@PageValueKey.METHODNAME] = timelineConfig.methodName
    writeValue[@PageValueKey.ACTIONTYPE] = timelineConfig.actionType

    if timelineConfig.actionType == Constant.ActionEventTypeClassName.SCROLL
      scrollPoint = ""
      scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
      if scrollPointDiv?
        start = scrollPointDiv.find('.scroll_point_start:first').val()
        end = scrollPointDiv.find('.scroll_point_end:first').val()
        scrollPoint = start + @PageValueKey.SCROLL_POINT_SEP + end
      writeValue[@PageValueKey.SCROLL_POINT] = scrollPoint

    else if timelineConfig.actionType == Constant.ActionEventTypeClassName.CLICK
      isClickParallel = false
      clickParallel = $('.click_parallel_div .click_parallel', timelineConfig.emt)
      if clickParallel?
        isClickParallel = clickParallel.is(":checked")
      writeValue[@PageValueKey.IS_CLICK_PARALLEL] = isClickParallel

    return writeValue

  @commonReadValue = (timelineConfig) ->
    writeValue = getTimelinePageValue(@PageValueKey.te(timelineConfig.teNum))
    if writeValue?
      if timelineConfig.actionType == Constant.ActionEventTypeClassName.SCROLL
        scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
        scrollPoint = writeValue[@PageValueKey.SCROLL_POINT]
        if scrollPointDiv? && scrollPoint?
          s = scrollPoint.split(@PageValueKey.SCROLL_POINT_SEP)
          start = s[0]
          end = s[1]
          scrollPointDiv.find('.scroll_point_start:first').val(start)
          scrollPointDiv.find('.scroll_point_end:first').val(end)

      else if timelineConfig.actionType == Constant.ActionEventTypeClassName.CLICK
        clickParallel = $('.click_parallel_div .click_parallel', timelineConfig.emt)
        isClickParallel = writeValue[@PageValueKey.IS_CLICK_PARALLEL]
        if clickParallel? && isClickParallel
          clickParallel.prop("checked", true)

  _scrollLength = (timelineConfig) ->
    scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
    writeValue = getTimelinePageValue(@PageValueKey.te(timelineConfig.teNum))
    if writeValue?
      scrollPoint = writeValue[@PageValueKey.SCROLL_POINT]
      if scrollPointDiv? && scrollPoint?
       s = scrollPoint.split(@PageValueKey.SCROLL_POINT_SEP)
       start = s[0]
       end = s[1]
       return parseInt(end) - parseInt(start)

    return null

  # スクロールの合計の長さを取得
  @getAllScrollLength = ->
    self = @
    maxTeNum = 0
    scrollPoint = null
    $('#timeline_page_values .timeline_event').children('div').each((e) ->
      teNum = parseInt($(@).attr('class'))
      if teNum > maxTeNum
        sp = $(@).find(".#{self.PageValueKey.SCROLL_POINT}:first").val()
        if sp? && sp != "null"
          maxTeNum = teNum
          scrollPoint = sp
    )
    if !scrollPoint?
      return 0

    s = scrollPoint.split(@PageValueKey.SCROLL_POINT_SEP)
    scrollEnd = parseInt(s[1])
    return scrollEnd











