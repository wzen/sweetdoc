# PageValue基底
class EventPageValueBase
  # 定数
  constant = gon.const

  @NO_METHOD = constant.EventPageValue.NO_METHOD
  @NO_JUMPPAGE = constant.EventPageValue.NO_JUMPPAGE

  class @PageValueKey
    # @property [String] DIST_ID 一意のイベント識別ID
    @DIST_ID = constant.EventPageValueKey.DIST_ID
    # @property [String] ID オブジェクトID
    @ID = constant.EventPageValueKey.ID
    # @property [String] CLASS_DIST_TOKEN クラス識別TOKEN
    @CLASS_DIST_TOKEN = constant.EventPageValueKey.CLASS_DIST_TOKEN
    # @property [String] ITEM_SIZE_DIFF アイテムサイズ
    @ITEM_SIZE_DIFF = constant.EventPageValueKey.ITEM_SIZE_DIFF
    # @property [String] DO_FOCUS フォーカス
    @DO_FOCUS = constant.EventPageValueKey.DO_FOCUS
    # @property [String] DO_FOCUS チャプター開始時に表示
    SHOW_WILL_CHAPTER = constant.EventPageValueKey.SHOW_WILL_CHAPTER
    # @property [String] DO_FOCUS チャプター開始時の表示実行時間
    SHOW_WILL_CHAPTER_DURATION = constant.EventPageValueKey.SHOW_WILL_CHAPTER_DURATION
    # @property [String] DO_FOCUS チャプター終了時に非表示
    HIDE_DID_CHAPTER = constant.EventPageValueKey.HIDE_DID_CHAPTER
    # @property [String] DO_FOCUS チャプター終了時に非表示実行時間
    HIDE_DID_CHAPTER_DURATION = constant.EventPageValueKey.HIDE_DID_CHAPTER_DURATION
    # @property [String] SPECIFIC_METHOD_VALUES メソッド固有値
    @SPECIFIC_METHOD_VALUES = constant.EventPageValueKey.SPECIFIC_METHOD_VALUES
    # @property [String] IS_COMMON_EVENT 共通イベント判定
    @IS_COMMON_EVENT = constant.EventPageValueKey.IS_COMMON_EVENT
    # @property [String] ORDER ソート番号
    @ORDER = constant.EventPageValueKey.ORDER
    # @property [String] METHODNAME イベント名
    @METHODNAME = constant.EventPageValueKey.METHODNAME
    # @property [String] ACTIONTYPE アクションタイプ名
    @ACTIONTYPE = constant.EventPageValueKey.ACTIONTYPE
    # @property [String] FINISH_PAGE ページ終了フラグ
    @FINISH_PAGE = constant.EventPageValueKey.FINISH_PAGE
    # @property [String] JUMPPAGE_NUM ページ遷移先番号
    @JUMPPAGE_NUM = constant.EventPageValueKey.JUMPPAGE_NUM
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

    handlerDiv = $(".handler_div", eventConfig.emt)
    if eventConfig[@PageValueKey.ACTIONTYPE] == constant.ActionType.SCROLL
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
    else if eventConfig[@PageValueKey.ACTIONTYPE] == constant.ActionType.CLICK
      eventDuration = handlerDiv.find('.click_duration:first')
      item = window.instanceMap[eventConfig[@PageValueKey.ID]]
      if item?
        duration = item.constructor.actionProperties.methods[eventConfig[@PageValueKey.METHODNAME]][item.constructor.ActionPropertiesKey.EVENT_DURATION]
        if !duration?
          duration = 0
        eventDuration.val(duration)

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

      # コンフィグ作成
      eventConfig.constructor.addEventConfigContents(eventConfig[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN])

      # 選択イベントタイプ
      selectItemValue = "#{eventConfig[@PageValueKey.ID]}#{EventConfig.EVENT_ITEM_SEPERATOR}#{eventConfig[@PageValueKey.CLASS_DIST_TOKEN]}"
      eventConfig.constructor.setSelectItemValue($('.dropdown:first', eventConfig.emt), selectItemValue)

      # 選択メソッドタイプ
      actionFormName = EventConfig.ITEM_ACTION_CLASS.replace('@classdisttoken', eventConfig[@PageValueKey.CLASS_DIST_TOKEN])
      $(".#{actionFormName} .radio", eventConfig.emt).each((e) ->
        methodName = $(@).find('input.method_name').val()
        if methodName == eventConfig[EventPageValueBase.PageValueKey.METHODNAME]
          $(@).find('input[type=radio]').prop('checked', true)
      )

      # 共通情報
      # ページ終了フラグ & ページ遷移
      if eventConfig[@PageValueKey.FINISH_PAGE]? && eventConfig[@PageValueKey.FINISH_PAGE]
        $('.finish_page', eventConfig.emt).attr('checked', true)
      else
        $('.finish_page', eventConfig.emt).removeAttr('checked')
      if eventConfig[@PageValueKey.JUMPPAGE_NUM]?
        $('.finish_page_select', eventConfig.emt).val(eventConfig[@PageValueKey.JUMPPAGE_NUM])
      else
        $('.finish_page_select', eventConfig.emt).val(EventPageValueBase.NO_JUMPPAGE)

      if !eventConfig[@PageValueKey.IS_COMMON_EVENT]
        # 画面位置&サイズ
        if eventConfig[@PageValueKey.ITEM_SIZE_DIFF] && eventConfig[@PageValueKey.ITEM_SIZE_DIFF].x
          $('.item_position_diff_x', eventConfig.emt).val(eventConfig[@PageValueKey.ITEM_SIZE_DIFF].x)
        if eventConfig[@PageValueKey.ITEM_SIZE_DIFF] && eventConfig[@PageValueKey.ITEM_SIZE_DIFF].y
          $('.item_position_diff_y', eventConfig.emt).val(eventConfig[@PageValueKey.ITEM_SIZE_DIFF].y)
        if eventConfig[@PageValueKey.ITEM_SIZE_DIFF] && eventConfig[@PageValueKey.ITEM_SIZE_DIFF].w
          $('.item_diff_width', eventConfig.emt).val(eventConfig[@PageValueKey.ITEM_SIZE_DIFF].w)
        if eventConfig[@PageValueKey.ITEM_SIZE_DIFF] && eventConfig[@PageValueKey.ITEM_SIZE_DIFF].h
          $('.item_diff_height', eventConfig.emt).val(eventConfig[@PageValueKey.ITEM_SIZE_DIFF].h)
        if eventConfig[@PageValueKey.DO_FOCUS]
          $('.do_focus', eventConfig.emt).prop('checked', true)
        else
          $('.do_focus', eventConfig.emt).removeAttr('checked')

        # 画面表示
        showWillEnabled = !eventConfig[@PageValueKey.SHOW_WILL_CHAPTER]? || eventConfig[@PageValueKey.SHOW_WILL_CHAPTER]
        $('.show_will_chapter', eventConfig.emt).prop('checked', showWillEnabled)
        showWillDuration = eventConfig[@PageValueKey.SHOW_WILL_CHAPTER_DURATION]
        if !showWillDuration?
          showWillDuration = 0
        $('.show_will_chapter_duration', eventConfig.emt).val(showWillDuration)
        hideDidEnabled = eventConfig[@PageValueKey.HIDE_DID_CHAPTER]? && eventConfig[@PageValueKey.HIDE_DID_CHAPTER]
        $('.hide_did_chapter', eventConfig.emt).prop('checked', hideDidEnabled)
        hideDidDuration = eventConfig[@PageValueKey.HIDE_DID_CHAPTER_DURATION]
        if hideDidDuration?
          $('.hide_did_chapter_duration', eventConfig.emt).val(hideDidDuration)

      # Sync
      parallel = $(".parallel_div .parallel", eventConfig.emt)
      if parallel? && eventConfig[@PageValueKey.IS_SYNC]
        parallel.prop("checked", true)

      # 操作
      handlerDiv = $(".handler_div", eventConfig.emt)
      if eventConfig[@PageValueKey.ACTIONTYPE] == constant.ActionType.SCROLL
        handlerDiv.find('input[type=radio][value=scroll]').prop('checked', true)
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

      else if eventConfig[@PageValueKey.ACTIONTYPE] == constant.ActionType.CLICK
        handlerDiv.find('input[type=radio][value=click]').prop('checked', true)
        eventDuration = handlerDiv.find('.click_duration:first')
        if eventConfig[@PageValueKey.EVENT_DURATION]?
          eventDuration.val(eventConfig[@PageValueKey.EVENT_DURATION])
        else
          item = window.instanceMap[eventConfig[@PageValueKey.ID]]
          if item?
            #duration = item.constructor.actionProperties.methods[eventConfig[@PageValueKey.METHODNAME]][item.constructor.ActionPropertiesKey.EVENT_DURATION]
            duration = eventConfig[@PageValueKey.EVENT_DURATION]
            if !duration?
              duration = 0
            eventDuration.val(duration)
        enabled = eventConfig[@PageValueKey.CHANGE_FORKNUM]? && eventConfig[@PageValueKey.CHANGE_FORKNUM] > 0
        $('.enable_fork:first', handlerDiv).prop('checked', enabled)

      specificValues = eventConfig[@PageValueKey.SPECIFIC_METHOD_VALUES]
      specificRoot = $(eventConfig.emt).find(".#{eventConfig.methodClassName()} .#{eventConfig.constructor.METHOD_VALUE_SPECIFIC_ROOT}")
      if specificValues?
        for className, value of specificValues
          specificRoot.find(".#{className}:first").val(value)

      return true
    else
      return false

  # スクロールの合計の長さを取得
  # @return [Integer] 取得値
  @getAllScrollLength = ->
    maxTeNum = 0
    ret = null
    $("##{PageValue.Key.E_ROOT} .#{PageValue.Key.E_SUB_ROOT} .#{PageValue.Key.pageRoot()}").children('div').each((i, e) =>
      teNum = parseInt($(e).attr('class'))
      if teNum > maxTeNum
        start = $(e).find(".#{@PageValueKey.SCROLL_POINT_START}:first").val()
        end = $(e).find(".#{@PageValueKey.SCROLL_POINT_END}:first").val()
        if start? && start != "null" && end? && end != "null"
          maxTeNum = teNum
          ret = end
    )
    if !ret?
      return 0

    return parseInt(ret)
