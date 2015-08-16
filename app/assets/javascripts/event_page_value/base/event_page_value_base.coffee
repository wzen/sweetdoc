class EventPageValueBase

  if gon?
  # 定数
    constant = gon.const

    class @PageValueKey
      # @property [String] te タイムラインイベントRoot
      @te : (teNum) ->
        constant.PageValueKey.TE_PREFIX + constant.PageValueKey.PAGE_VALUES_SEPERATOR + Constant.PageValueKey.TE_NUM_PREFIX + teNum
      # @property [String] ID アイテムID
      @ID = 'id'
      # @property [String] ITEM_ID アイテムタイプID
      @ITEM_ID = 'item_id'
      # @property [String] COMMON_EVENT_ID 共通イベントID
      @COMMON_EVENT_ID = 'common_event_id'
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
      # @property [String] ACTIONTYPE アクションタイプ名
      @ACTIONTYPE = 'actiontype'
      # @property [String] ANIAMTIONTYPE アニメーションタイプ名
      @ANIAMTIONTYPE = 'animationtype'
      # @property [String] IS_PARALLEL 同時実行
      @IS_PARALLEL = 'is_parallel'
      # @property [String] SCROLL_TIME スクロール実行開始位置
      @SCROLL_POINT_START = 'scroll_point_start'
      # @property [String] SCROLL_TIME スクロール実行終了位置
      @SCROLL_POINT_END = 'scroll_point_end'

  @initConfigValue = (timelineConfig) ->
    if timelineConfig.actionType == Constant.ActionEventHandleType.SCROLL
      handlerDiv = $(".handler_div .#{timelineConfig.methodClassName()}", timelineConfig.emt)
      if handlerDiv?
        startDiv = handlerDiv.find('.scroll_point_start:first')
        start = startDiv.val()
        s = null
        if start.length == 0
          s = EventPageValueBase.getAllScrollLength()
          startDiv.val(s)
          if s == 0
            startDiv.prop("disabled", true)
        endDiv = handlerDiv.find('.scroll_point_end:first')
        end = endDiv.val()
        if end.length == 0
          endDiv.val(parseInt(s) + _scrollLength.call(@, timelineConfig))

  # fixme: 実装予定
  @checkConfigValue = (timelineConfig) ->

  @writeToPageValue = (timelineConfig) ->
    writeValue = {}
    writeValue[@PageValueKey.ID] = timelineConfig.id
    writeValue[@PageValueKey.ITEM_ID] = timelineConfig.itemId
    writeValue[@PageValueKey.COMMON_EVENT_ID] = timelineConfig.commonEventId
    # fixme
    writeValue[@PageValueKey.CHAPTER] = 1
    # fixme
    writeValue[@PageValueKey.SCREEN] = 1
    writeValue[@PageValueKey.IS_COMMON_EVENT] = timelineConfig.isCommonEvent
    writeValue[@PageValueKey.METHODNAME] = timelineConfig.methodName
    writeValue[@PageValueKey.ACTIONTYPE] = timelineConfig.actionType
    writeValue[@PageValueKey.ANIAMTIONTYPE] = timelineConfig.animationType
    writeValue[@PageValueKey.IS_PARALLEL] = timelineConfig.isParallel

    if timelineConfig.actionType == Constant.ActionEventHandleType.SCROLL
      writeValue[@PageValueKey.SCROLL_POINT_START] = timelineConfig.scrollPointStart
      writeValue[@PageValueKey.SCROLL_POINT_END] = timelineConfig.scrollPointEnd

    return writeValue

  @readFromPageValue = (timelineConfig) ->
    writeValue = PageValue.getTimelinePageValue(@PageValueKey.te(timelineConfig.teNum))
    if writeValue?
      timelineConfig.id = writeValue[@PageValueKey.ID]
      timelineConfig.itemId = writeValue[@PageValueKey.ITEM_ID]
      timelineConfig.commonEventId = writeValue[@PageValueKey.COMMON_EVENT_ID]
      # fixme
      #writeValue[@PageValueKey.CHAPTER] = 1
      # fixme
      #writeValue[@PageValueKey.SCREEN] = 1
      timelineConfig.isCommonEvent = writeValue[@PageValueKey.IS_COMMON_EVENT]
      timelineConfig.methodName = writeValue[@PageValueKey.METHODNAME]
      timelineConfig.actionType = writeValue[@PageValueKey.ACTIONTYPE]
      timelineConfig.animationType = writeValue[@PageValueKey.ANIAMTIONTYPE]

      parallel = $(".parallel_div .parallel", timelineConfig.emt)
      isParallel = writeValue[@PageValueKey.IS_PARALLEL]
      if parallel? && isParallel
        parallel.prop("checked", true)

      if timelineConfig.actionType == Constant.ActionEventHandleType.SCROLL
        handlerDiv = $(".handler_div .#{timelineConfig.methodClassName()}", timelineConfig.emt)
        start = writeValue[@PageValueKey.SCROLL_POINT_START]
        end = writeValue[@PageValueKey.SCROLL_POINT_END]
        if handlerDiv? && start? && end?
          handlerDiv.find('.scroll_point_start:first').val(start)
          handlerDiv.find('.scroll_point_end:first').val(end)

      return true
    else
      return false

  _scrollLength = (timelineConfig) ->
    writeValue = PageValue.getTimelinePageValue(@PageValueKey.te(timelineConfig.teNum))
    if writeValue?
      start = writeValue[@PageValueKey.SCROLL_POINT_START]
      end = writeValue[@PageValueKey.SCROLL_POINT_END]
      if start? && $.isNumeric(start) && end? && $.isNumeric(end)
       return parseInt(end) - parseInt(start)

    return 0

  # スクロールの合計の長さを取得
  @getAllScrollLength = ->
    self = @
    maxTeNum = 0
    ret = null
    $("##{Constant.PageValueKey.TE_ROOT} .#{Constant.PageValueKey.TE_PREFIX}").children('div').each((e) ->
      teNum = parseInt($(@).attr('class'))
      if teNum > maxTeNum
        start = $(@).find(".#{self.PageValueKey.SCROLL_POINT_START}:first").val()
        end = $(@).find(".#{self.PageValueKey.SCROLL_POINT_END}:first").val()
        if start? && start != "null" && end? && end != "null"
          maxTeNum = teNum
          ret = end
    )
    if !ret?
      return 0

    return ret











