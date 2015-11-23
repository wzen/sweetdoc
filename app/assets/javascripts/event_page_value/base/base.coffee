# PageValue基底
class EventPageValueBase

  if gon?
  # 定数
    constant = gon.const

    class @PageValueKey
      # @property [String] DIST_ID 一意のイベント識別ID
      @DIST_ID = constant.EventPageValueKey.DIST_ID
      # @property [String] ID オブジェクトID
      @ID = constant.EventPageValueKey.ID
      # @property [String] ITEM_ID アイテムID
      @ITEM_ID = constant.EventPageValueKey.ITEM_ID
      # @property [String] ITEM_SIZE_DIFF アイテムサイズ
      @ITEM_SIZE_DIFF = constant.EventPageValueKey.ITEM_SIZE_DIFF
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
      # @property [String] CHANGE_FORKNUM フォーク番号
      @CHANGE_FORKNUM = constant.EventPageValueKey.CHANGE_FORKNUM
      # @property [String] MODIFIABLE_VARS 変更するインスタンス変数
      @MODIFIABLE_VARS = constant.EventPageValueKey.MODIFIABLE_VARS
      # @property [String] IS_DRAW_BY_ANIMATION アニメーションとしてメソッドを実行するか
      @IS_DRAW_BY_ANIMATION = constant.EventPageValueKey.IS_DRAW_BY_ANIMATION
      # @property [String] CLICK_DURATION クリック実行時間
      @CLICK_DURATION = constant.EventPageValueKey.CLICK_DURATION

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

    if eventConfig.actionType == Constant.ActionType.SCROLL
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
    else if eventConfig.actionType == Constant.ActionType.CLICK
      handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
      if handlerDiv?
        clickDuration = handlerDiv.find('.click_duration:first')
        item = window.instanceMap[eventConfig.id]
        if item?
          clickDuration.val(item.constructor.methods[eventConfig.methodClassName()][item.constructor.ActionPropertiesKey.CLICK_DURATION])

  # PageValueに書き込みデータを取得
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [Object] 書き込むデータ
  @writeToPageValue = (eventConfig) ->
    writeValue = {}
    writeValue[@PageValueKey.DIST_ID] = eventConfig.distId
    writeValue[@PageValueKey.ID] = eventConfig.id
    writeValue[@PageValueKey.ITEM_ID] = eventConfig.itemId
    writeValue[@PageValueKey.ITEM_SIZE_DIFF] = eventConfig.itemSizeDiff
    writeValue[@PageValueKey.COMMON_EVENT_ID] = eventConfig.commonEventId
    writeValue[@PageValueKey.IS_COMMON_EVENT] = eventConfig.isCommonEvent
    writeValue[@PageValueKey.METHODNAME] = eventConfig.methodName
    writeValue[@PageValueKey.ACTIONTYPE] = eventConfig.actionType
    writeValue[@PageValueKey.IS_SYNC] = eventConfig.isParallel
    writeValue[@PageValueKey.MODIFIABLE_VARS] = eventConfig.modifiableVars

    if eventConfig.actionType == Constant.ActionType.SCROLL
      writeValue[@PageValueKey.SCROLL_POINT_START] = eventConfig.scrollPointStart
      writeValue[@PageValueKey.SCROLL_POINT_END] = eventConfig.scrollPointEnd
      writeValue[@PageValueKey.SCROLL_ENABLED_DIRECTIONS] = eventConfig.scrollEnabledDirection
      writeValue[@PageValueKey.SCROLL_FORWARD_DIRECTIONS] = eventConfig.scrollForwardDirection
    else if eventConfig.actionType == Constant.ActionType.CLICK
      writeValue[@PageValueKey.CLICK_DURATION] = eventConfig.clickDuration
      writeValue[@PageValueKey.CHANGE_FORKNUM] = eventConfig.forkNum

    return writeValue

  # PageValueからConfigにデータを読み込み
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [Boolean] 読み込み成功したか
  @readFromPageValue = (eventConfig) ->
    writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum))
    if writeValue?
      eventConfig.distId = writeValue[@PageValueKey.DIST_ID]
      eventConfig.id = writeValue[@PageValueKey.ID]
      eventConfig.itemId = writeValue[@PageValueKey.ITEM_ID]
      eventConfig.itemSizeDiff = writeValue[@PageValueKey.ITEM_SIZE_DIFF]
      eventConfig.commonEventId = writeValue[@PageValueKey.COMMON_EVENT_ID]
      eventConfig.isCommonEvent = writeValue[@PageValueKey.IS_COMMON_EVENT]
      eventConfig.methodName = writeValue[@PageValueKey.METHODNAME]
      eventConfig.actionType = writeValue[@PageValueKey.ACTIONTYPE]
      eventConfig.modifiableVars = writeValue[@PageValueKey.MODIFIABLE_VARS]

      if !eventConfig.isCommonEvent
        if eventConfig.itemSizeDiff && eventConfig.itemSizeDiff.x
          $('.item_position_diff_x', eventConfig.emt).val(eventConfig.itemSizeDiff.x)
        if eventConfig.itemSizeDiff && eventConfig.itemSizeDiff.y
          $('.item_position_diff_y', eventConfig.emt).val(eventConfig.itemSizeDiff.y)
        if eventConfig.itemSizeDiff && eventConfig.itemSizeDiff.w
          $('.item_diff_width', eventConfig.emt).val(eventConfig.itemSizeDiff.w)
        if eventConfig.itemSizeDiff && eventConfig.itemSizeDiff.h
          $('.item_diff_height', eventConfig.emt).val(eventConfig.itemSizeDiff.h)

      parallel = $(".parallel_div .parallel", eventConfig.emt)
      isParallel = writeValue[@PageValueKey.IS_SYNC]
      if parallel? && isParallel
        parallel.prop("checked", true)

      if eventConfig.actionType == Constant.ActionType.SCROLL
        handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
        if handlerDiv?
          eventConfig.scrollPointStart = writeValue[@PageValueKey.SCROLL_POINT_START]
          eventConfig.scrollPointEnd = writeValue[@PageValueKey.SCROLL_POINT_END]
          if eventConfig.scrollPointStart? && eventConfig.scrollPointEnd?
            handlerDiv.find('.scroll_point_start:first').val(eventConfig.scrollPointStart)
            handlerDiv.find('.scroll_point_end:first').val(eventConfig.scrollPointEnd)

          eventConfig.scrollEnabledDirection = writeValue[@PageValueKey.SCROLL_ENABLED_DIRECTIONS]
          eventConfig.scrollForwardDirection = writeValue[@PageValueKey.SCROLL_FORWARD_DIRECTIONS]
          topEmt = handlerDiv.find('.scroll_enabled_top:first')
          if topEmt?
            topEmt.children('.scroll_enabled:first').prop("checked", eventConfig.scrollEnabledDirection.top)
            if eventConfig.scrollEnabledDirection.top
              topEmt.children('.scroll_forward:first').prop("checked", eventConfig.scrollForwardDirection.top)
            else
              topEmt.children('.scroll_forward:first').prop("checked", false)
              topEmt.children('.scroll_forward:first').parent('label').hide()
          bottomEmt = handlerDiv.find('scroll_enabled_bottom:first')
          if bottomEmt?
            bottomEmt.children('.scroll_enabled:first').prop("checked", eventConfig.scrollEnabledDirection.bottom)
            if eventConfig.scrollEnabledDirection.bottom
              bottomEmt.children('.scroll_forward:first').prop("checked", eventConfig.scrollForwardDirection.bottom)
            else
              bottomEmt.children('.scroll_forward:first').prop("checked", false)
              bottomEmt.children('.scroll_forward:first').parent('label').hide()
          leftEmt = handlerDiv.find('scroll_enabled_left:first')
          if leftEmt?
            leftEmt.children('.scroll_enabled:first').prop("checked", eventConfig.scrollEnabledDirection.left)
            if eventConfig.scrollEnabledDirection.left
              leftEmt.children('.scroll_forward:first').prop("checked", eventConfig.scrollForwardDirection.left)
            else
              leftEmt.children('.scroll_forward:first').prop("checked", false)
              leftEmt.children('.scroll_forward:first').parent('label').hide()
          rightEmt = handlerDiv.find('scroll_enabled_right:first')
          if rightEmt?
            rightEmt.children('.scroll_enabled:first').prop("checked", eventConfig.scrollEnabledDirection.right)
            if eventConfig.scrollEnabledDirection.right
              rightEmt.children('.scroll_forward:first').prop("checked", eventConfig.scrollForwardDirection.right)
            else
              rightEmt.children('.scroll_forward:first').prop("checked", false)
              rightEmt.children('.scroll_forward:first').parent('label').hide()

      else if eventConfig.actionType == Constant.ActionType.CLICK
        handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
        if handlerDiv?
          clickDuration = handlerDiv.find('.click_duration:first')
          eventConfig.clickDuration = writeValue[@PageValueKey.CLICK_DURATION]
          if eventConfig.clickDuration?
            clickDuration.val(eventConfig.clickDuration)
          else
            item = window.instanceMap[eventConfig.id]
            if item?
              clickDuration.val(item.constructor.methods[eventConfig.methodClassName()][item.constructor.ActionPropertiesKey.CLICK_DURATION])

          eventConfig.forkNum = writeValue[@PageValueKey.CHANGE_FORKNUM]
          enabled = eventConfig.forkNum? && eventConfig.forkNum > 0
          $('.enable_fork:first', handlerDiv).prop('checked', enabled)
          fn = if enabled then eventConfig.forkNum else 1
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
