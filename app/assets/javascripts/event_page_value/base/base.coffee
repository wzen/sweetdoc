class EventPageValueBase

  if gon?
  # 定数
    constant = gon.const

    class @PageValueKey
      # @property [String] te イベントRoot
      @te : (teNum) ->
        constant.PageValueKey.E_PREFIX + constant.PageValueKey.PAGE_VALUES_SEPERATOR + PageValue.Key.E_NUM_PREFIX + teNum
      # @property [String] ID アイテムID
      @ID = constant.EventPageValueKey.ID
      # @property [String] ITEM_ID アイテムタイプID
      @ITEM_ID = constant.EventPageValueKey.ITEM_ID
      # @property [String] COMMON_EVENT_ID 共通イベントID
      @COMMON_EVENT_ID = constant.EventPageValueKey.COMMON_EVENT_ID
      # @property [String] VALUE イベント値
      @VALUE = constant.EventPageValueKey.VALUE
      # @property [String] CHAPTER チャプター
      @CHAPTER = constant.EventPageValueKey.CHAPTER
      # @property [String] SCREEN スクリーン
      @SCREEN = constant.EventPageValueKey.SCREEN
      # @property [String] IS_COMMON_EVENT 共通イベント判定
      @IS_COMMON_EVENT = constant.EventPageValueKey.IS_COMMON_EVENT
      # @property [String] ORDER ソート番号
      @ORDER = constant.EventPageValueKey.ORDER
      # @property [String] METHODNAME イベント名
      @METHODNAME = constant.EventPageValueKey.METHODNAME
      # @property [String] ACTIONTYPE アクションタイプ名
      @ACTIONTYPE = constant.EventPageValueKey.ACTIONTYPE
      # @property [String] ANIAMTIONTYPE アニメーションタイプ名
      @ANIAMTIONTYPE = constant.EventPageValueKey.ANIAMTIONTYPE
      # @property [String] IS_PARALLEL 同時実行
      @IS_PARALLEL = constant.EventPageValueKey.IS_PARALLEL
      # @property [String] SCROLL_TIME スクロール実行開始位置
      @SCROLL_POINT_START = constant.EventPageValueKey.SCROLL_POINT_START
      # @property [String] SCROLL_TIME スクロール実行終了位置
      @SCROLL_POINT_END = constant.EventPageValueKey.SCROLL_POINT_END

  @initConfigValue = (eventConfig) ->
    if eventConfig.actionType == Constant.ActionEventHandleType.SCROLL
      handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
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
          endDiv.val(parseInt(s) + _scrollLength.call(@, eventConfig))

  # fixme: 実装予定
  @checkConfigValue = (eventConfig) ->

  @writeToPageValue = (eventConfig) ->
    writeValue = {}
    writeValue[@PageValueKey.ID] = eventConfig.id
    writeValue[@PageValueKey.ITEM_ID] = eventConfig.itemId
    writeValue[@PageValueKey.COMMON_EVENT_ID] = eventConfig.commonEventId
    # fixme
    writeValue[@PageValueKey.CHAPTER] = 1
    # fixme
    writeValue[@PageValueKey.SCREEN] = 1
    writeValue[@PageValueKey.IS_COMMON_EVENT] = eventConfig.isCommonEvent
    writeValue[@PageValueKey.METHODNAME] = eventConfig.methodName
    writeValue[@PageValueKey.ACTIONTYPE] = eventConfig.actionType
    writeValue[@PageValueKey.ANIAMTIONTYPE] = eventConfig.animationType
    writeValue[@PageValueKey.IS_PARALLEL] = eventConfig.isParallel

    if eventConfig.actionType == Constant.ActionEventHandleType.SCROLL
      writeValue[@PageValueKey.SCROLL_POINT_START] = eventConfig.scrollPointStart
      writeValue[@PageValueKey.SCROLL_POINT_END] = eventConfig.scrollPointEnd

    return writeValue

  @readFromPageValue = (eventConfig) ->
    writeValue = PageValue.getEventPageValue(@PageValueKey.te(eventConfig.teNum))
    if writeValue?
      eventConfig.id = writeValue[@PageValueKey.ID]
      eventConfig.itemId = writeValue[@PageValueKey.ITEM_ID]
      eventConfig.commonEventId = writeValue[@PageValueKey.COMMON_EVENT_ID]
      # fixme
      #writeValue[@PageValueKey.CHAPTER] = 1
      # fixme
      #writeValue[@PageValueKey.SCREEN] = 1
      eventConfig.isCommonEvent = writeValue[@PageValueKey.IS_COMMON_EVENT]
      eventConfig.methodName = writeValue[@PageValueKey.METHODNAME]
      eventConfig.actionType = writeValue[@PageValueKey.ACTIONTYPE]
      eventConfig.animationType = writeValue[@PageValueKey.ANIAMTIONTYPE]

      parallel = $(".parallel_div .parallel", eventConfig.emt)
      isParallel = writeValue[@PageValueKey.IS_PARALLEL]
      if parallel? && isParallel
        parallel.prop("checked", true)

      if eventConfig.actionType == Constant.ActionEventHandleType.SCROLL
        handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
        start = writeValue[@PageValueKey.SCROLL_POINT_START]
        end = writeValue[@PageValueKey.SCROLL_POINT_END]
        if handlerDiv? && start? && end?
          handlerDiv.find('.scroll_point_start:first').val(start)
          handlerDiv.find('.scroll_point_end:first').val(end)

      return true
    else
      return false

  _scrollLength = (eventConfig) ->
    writeValue = PageValue.getEventPageValue(@PageValueKey.te(eventConfig.teNum))
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
    $("##{PageValue.Key.E_ROOT} .#{PageValue.Key.E_PREFIX}").children('div').each((e) ->
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











