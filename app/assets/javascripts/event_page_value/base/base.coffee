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
      # @property [String] EVENT_DURATION クリック実行時間
      @EVENT_DURATION = constant.EventPageValueKey.EVENT_DURATION

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

    if eventConfig[@PageValueKey.ACTIONTYPE] == Constant.ActionType.SCROLL
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
    else if eventConfig[@PageValueKey.ACTIONTYPE] == Constant.ActionType.CLICK
      handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
      if handlerDiv?
        eventDuration = handlerDiv.find('.click_duration:first')
        item = window.instanceMap[eventConfig[@PageValueKey.ID]]
        if item?
          eventDuration.val(item.constructor.actionProperties.methods[eventConfig[@PageValueKey.METHODNAME]][item.constructor.ActionPropertiesKey.EVENT_DURATION])

  # PageValueに書き込みデータを取得
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [Object] 書き込むデータ
  @writeToPageValue = (eventConfig) ->
    errorMes = ''
    writeValue = {}
    for k, v of @PageValueKey
      if eventConfig[v]?
        writeValue[v] = eventConfig[v]

    if errorMes.length == 0
      PageValue.setEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum), writeValue)
      if parseInt(PageValue.getEventPageValue(PageValue.Key.eventCount())) < eventConfig.teNum
        PageValue.setEventPageValue(PageValue.Key.eventCount(), eventConfig.teNum)

      # Storageに保存
      LocalStorage.saveAllPageValues()

    return errorMes

  # PageValueからConfigにデータを読み込み
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [Boolean] 読み込み成功したか
  @readFromPageValue = (eventConfig) ->
    writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum))
    if writeValue?
      for k, v of @PageValueKey
        if writeValue[v]?
          eventConfig[v] = writeValue[v]

      if !eventConfig[@PageValueKey.IS_COMMON_EVENT]
        if eventConfig[@PageValueKey.ITEM_SIZE_DIFF] && eventConfig[@PageValueKey.ITEM_SIZE_DIFF].x
          $('.item_position_diff_x', eventConfig.emt).val(eventConfig[@PageValueKey.ITEM_SIZE_DIFF].x)
        if eventConfig[@PageValueKey.ITEM_SIZE_DIFF] && eventConfig[@PageValueKey.ITEM_SIZE_DIFF].y
          $('.item_position_diff_y', eventConfig.emt).val(eventConfig[@PageValueKey.ITEM_SIZE_DIFF].y)
        if eventConfig[@PageValueKey.ITEM_SIZE_DIFF] && eventConfig[@PageValueKey.ITEM_SIZE_DIFF].w
          $('.item_diff_width', eventConfig.emt).val(eventConfig[@PageValueKey.ITEM_SIZE_DIFF].w)
        if eventConfig[@PageValueKey.ITEM_SIZE_DIFF] && eventConfig[@PageValueKey.ITEM_SIZE_DIFF].h
          $('.item_diff_height', eventConfig.emt).val(eventConfig[@PageValueKey.ITEM_SIZE_DIFF].h)

      parallel = $(".parallel_div .parallel", eventConfig.emt)
      if parallel? && eventConfig[@PageValueKey.IS_SYNC]
        parallel.prop("checked", true)

      if eventConfig[@PageValueKey.ACTIONTYPE] == Constant.ActionType.SCROLL
        handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
        if handlerDiv?
          if eventConfig[@PageValueKey.SCROLL_POINT_START]? && eventConfig[@PageValueKey.SCROLL_POINT_END]?
            handlerDiv.find('.scroll_point_start:first').val(eventConfig[@PageValueKey.SCROLL_POINT_START])
            handlerDiv.find('.scroll_point_end:first').val(eventConfig[@PageValueKey.SCROLL_POINT_END])

          topEmt = handlerDiv.find('.scroll_enabled_top:first')
          if topEmt?
            topEmt.children('.scroll_enabled:first').prop("checked", eventConfig[@PageValueKey.SCROLL_ENABLED_DIRECTIONS].top)
            if eventConfig[@PageValueKey.SCROLL_ENABLED_DIRECTIONS].top
              topEmt.children('.scroll_forward:first').prop("checked", eventConfig[@PageValueKey.SCROLL_FORWARD_DIRECTIONS].top)
            else
              topEmt.children('.scroll_forward:first').prop("checked", false)
              topEmt.children('.scroll_forward:first').parent('label').hide()
          bottomEmt = handlerDiv.find('scroll_enabled_bottom:first')
          if bottomEmt?
            bottomEmt.children('.scroll_enabled:first').prop("checked", eventConfig[@PageValueKey.SCROLL_ENABLED_DIRECTIONS].bottom)
            if eventConfig[@PageValueKey.SCROLL_ENABLED_DIRECTIONS].bottom
              bottomEmt.children('.scroll_forward:first').prop("checked", eventConfig[@PageValueKey.SCROLL_FORWARD_DIRECTIONS].bottom)
            else
              bottomEmt.children('.scroll_forward:first').prop("checked", false)
              bottomEmt.children('.scroll_forward:first').parent('label').hide()
          leftEmt = handlerDiv.find('scroll_enabled_left:first')
          if leftEmt?
            leftEmt.children('.scroll_enabled:first').prop("checked", eventConfig[@PageValueKey.SCROLL_ENABLED_DIRECTIONS].left)
            if eventConfig[@PageValueKey.SCROLL_ENABLED_DIRECTIONS].left
              leftEmt.children('.scroll_forward:first').prop("checked", eventConfig[@PageValueKey.SCROLL_FORWARD_DIRECTIONS].left)
            else
              leftEmt.children('.scroll_forward:first').prop("checked", false)
              leftEmt.children('.scroll_forward:first').parent('label').hide()
          rightEmt = handlerDiv.find('scroll_enabled_right:first')
          if rightEmt?
            rightEmt.children('.scroll_enabled:first').prop("checked", eventConfig[@PageValueKey.SCROLL_ENABLED_DIRECTIONS].right)
            if eventConfig[@PageValueKey.SCROLL_ENABLED_DIRECTIONS].right
              rightEmt.children('.scroll_forward:first').prop("checked", eventConfig[@PageValueKey.SCROLL_FORWARD_DIRECTIONS].right)
            else
              rightEmt.children('.scroll_forward:first').prop("checked", false)
              rightEmt.children('.scroll_forward:first').parent('label').hide()

      else if eventConfig[@PageValueKey.ACTIONTYPE] == Constant.ActionType.CLICK
        handlerDiv = $(".handler_div .#{eventConfig.methodClassName()}", eventConfig.emt)
        if handlerDiv?
          eventDuration = handlerDiv.find('.click_duration:first')
          if eventConfig[@PageValueKey.EVENT_DURATION]?
            eventDuration.val(eventConfig[@PageValueKey.EVENT_DURATION])
          else
            item = window.instanceMap[eventConfig[@PageValueKey.ID]]
            if item?
              eventDuration.val(item.constructor.actionProperties.methods[eventConfig[@PageValueKey.METHODNAME]][item.constructor.ActionPropertiesKey.EVENT_DURATION])

          enabled = eventConfig[@PageValueKey.CHANGE_FORKNUM]? && eventConfig[@PageValueKey.CHANGE_FORKNUM] > 0
          $('.enable_fork:first', handlerDiv).prop('checked', enabled)
          fn = if enabled then eventConfig[@PageValueKey.CHANGE_FORKNUM] else 1
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
