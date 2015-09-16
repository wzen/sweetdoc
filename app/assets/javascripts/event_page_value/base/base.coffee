# PageValue基底
class EventPageValueBase

  if gon?
  # 定数
    constant = gon.const

    class @PageValueKey
      # @property [String] ID アイテムID
      @ID = constant.EventPageValueKey.ID
      # @property [String] ITEM_ID アイテムタイプID
      @ITEM_ID = constant.EventPageValueKey.ITEM_ID
      # @property [String] COMMON_EVENT_ID 共通イベントID
      @COMMON_EVENT_ID = constant.EventPageValueKey.COMMON_EVENT_ID
      # @property [String] VALUE イベント値
      @VALUE = constant.EventPageValueKey.VALUE
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
      # @property [String] IS_SYNC 同時実行
      @IS_SYNC = constant.EventPageValueKey.IS_SYNC
      # @property [String] SCROLL_TIME スクロール実行開始位置
      @SCROLL_POINT_START = constant.EventPageValueKey.SCROLL_POINT_START
      # @property [String] SCROLL_TIME スクロール実行終了位置
      @SCROLL_POINT_END = constant.EventPageValueKey.SCROLL_POINT_END
      # @property [String] SCROLL_ENABLED_DIRECTIONS スクロール可能方向
      @SCROLL_ENABLED_DIRECTIONS = constant.EventPageValueKey.SCROLL_ENABLED_DIRECTIONS
      # @property [String] SCROLL_FORWARD_DIRECTIONS スクロール進行方向
      @SCROLL_FORWARD_DIRECTIONS = constant.EventPageValueKey.SCROLL_FORWARD_DIRECTIONS
      # @property [String] FORKNUM フォーク番号
      @FORKNUM = constant.EventPageValueKey.FORKNUM

  # コンフィグ初期設定
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  @initConfigValue = (eventConfig) ->
    _scrollLength = (eventConfig) ->
      writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum))
      if writeValue?
        start = writeValue[@PageValueKey.SCROLL_POINT_START]
        end = writeValue[@PageValueKey.SCROLL_POINT_END]
        if start? && $.isNumeric(start) && end? && $.isNumeric(end)
          return parseInt(end) - parseInt(start)

      return 0

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

  # PageValueに書き込みデータを取得
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [Object] 書き込むデータ
  @writeToPageValue = (eventConfig) ->
    writeValue = {}
    writeValue[@PageValueKey.ID] = eventConfig.id
    writeValue[@PageValueKey.ITEM_ID] = eventConfig.itemId
    writeValue[@PageValueKey.COMMON_EVENT_ID] = eventConfig.commonEventId
    writeValue[@PageValueKey.IS_COMMON_EVENT] = eventConfig.isCommonEvent
    writeValue[@PageValueKey.METHODNAME] = eventConfig.methodName
    writeValue[@PageValueKey.ACTIONTYPE] = eventConfig.actionType
    writeValue[@PageValueKey.ANIAMTIONTYPE] = eventConfig.animationType
    writeValue[@PageValueKey.IS_SYNC] = eventConfig.isParallel

    if eventConfig.actionType == Constant.ActionEventHandleType.SCROLL
      writeValue[@PageValueKey.SCROLL_POINT_START] = eventConfig.scrollPointStart
      writeValue[@PageValueKey.SCROLL_POINT_END] = eventConfig.scrollPointEnd
      writeValue[@PageValueKey.SCROLL_ENABLED_DIRECTIONS] = eventConfig.scrollEnabledDirection
      writeValue[@PageValueKey.SCROLL_FORWARD_DIRECTIONS] = eventConfig.scrollForwardDirection
    else if eventConfig.actionType == Constant.ActionEventHandleType.CLICK
      writeValue[@PageValueKey.FORKNUM] = eventConfig.forkNum

    return writeValue

  # PageValueからConfigにデータを読み込み
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [Boolean] 読み込み成功したか
  @readFromPageValue = (eventConfig) ->
    writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum))
    if writeValue?
      eventConfig.id = writeValue[@PageValueKey.ID]
      eventConfig.itemId = writeValue[@PageValueKey.ITEM_ID]
      eventConfig.commonEventId = writeValue[@PageValueKey.COMMON_EVENT_ID]
      eventConfig.isCommonEvent = writeValue[@PageValueKey.IS_COMMON_EVENT]
      eventConfig.methodName = writeValue[@PageValueKey.METHODNAME]
      eventConfig.actionType = writeValue[@PageValueKey.ACTIONTYPE]
      eventConfig.animationType = writeValue[@PageValueKey.ANIAMTIONTYPE]

      parallel = $(".parallel_div .parallel", eventConfig.emt)
      isParallel = writeValue[@PageValueKey.IS_SYNC]
      if parallel? && isParallel
        parallel.prop("checked", true)

      if eventConfig.actionType == Constant.ActionEventHandleType.SCROLL
        handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
        if handlerDiv?
          start = writeValue[@PageValueKey.SCROLL_POINT_START]
          end = writeValue[@PageValueKey.SCROLL_POINT_END]
          if start? && end?
            handlerDiv.find('.scroll_point_start:first').val(start)
            handlerDiv.find('.scroll_point_end:first').val(end)

          enabledDirection = writeValue[@PageValueKey.SCROLL_ENABLED_DIRECTIONS]
          forwardDirection = writeValue[@PageValueKey.SCROLL_FORWARD_DIRECTIONS]
          topEmt = handlerDiv.find('.scroll_enabled_top:first')
          if topEmt?
            topEmt.children('.scroll_enabled:first').prop("checked", enabledDirection.top)
            if enabledDirection.top
              topEmt.children('.scroll_forward:first').prop("checked", forwardDirection.top)
            else
              topEmt.children('.scroll_forward:first').prop("checked", false)
              topEmt.children('.scroll_forward:first').parent('label').css('display', 'none')
          bottomEmt = handlerDiv.find('scroll_enabled_bottom:first')
          if bottomEmt?
            bottomEmt.children('.scroll_enabled:first').prop("checked", enabledDirection.bottom)
            if enabledDirection.bottom
              bottomEmt.children('.scroll_forward:first').prop("checked", forwardDirection.bottom)
            else
              bottomEmt.children('.scroll_forward:first').prop("checked", false)
              bottomEmt.children('.scroll_forward:first').parent('label').css('display', 'none')
          leftEmt = handlerDiv.find('scroll_enabled_left:first')
          if leftEmt?
            leftEmt.children('.scroll_enabled:first').prop("checked", enabledDirection.left)
            if enabledDirection.left
              leftEmt.children('.scroll_forward:first').prop("checked", forwardDirection.left)
            else
              leftEmt.children('.scroll_forward:first').prop("checked", false)
              leftEmt.children('.scroll_forward:first').parent('label').css('display', 'none')
          rightEmt = handlerDiv.find('scroll_enabled_right:first')
          if rightEmt?
            rightEmt.children('.scroll_enabled:first').prop("checked", enabledDirection.right)
            if enabledDirection.right
              rightEmt.children('.scroll_forward:first').prop("checked", forwardDirection.right)
            else
              rightEmt.children('.scroll_forward:first').prop("checked", false)
              rightEmt.children('.scroll_forward:first').parent('label').css('display', 'none')

      else if eventConfig.actionType == Constant.ActionEventHandleType.CLICK
        handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
        if handlerDiv?
          forkNum = writeValue[@PageValueKey.FORKNUM]
          enabled = forkNum? && forkNum > 0
          $('.enable_fork:first', handlerDiv).prop('checked', enabled)
          fn = if enabled then forkNum else 1
          $('.fork_select:first', handlerDiv).val(Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', fn))
          $('.fork_select:first', handlerDiv).parent('div').css('display', if enabled then 'block' else 'none')

      return true
    else
      return false

  # スクロールの合計の長さを取得
  # @return [Integer] 取得値
  @getAllScrollLength = ->
    self = @
    maxTeNum = 0
    ret = null
    $("##{PageValue.Key.E_ROOT} .#{PageValue.Key.E_SUB_ROOT} .#{PageValue.Key.pageRoot()}").children('div').each((e) ->
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

    return parseInt(ret)







