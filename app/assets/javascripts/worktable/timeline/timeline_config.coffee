class TimelineConfig

  if gon?
    # @property [String] TE_ITEM_ROOT_ID タイムラインイベントRoot
    @ITEM_ROOT_ID = 'timeline_event_@te_num'
    # @property [String] TE_ACTION_CLASS タイムラインイベント アクション一覧
    @ACTION_CLASS = 'timeline_event_action_@itemid'
    # @property [String] TE_VALUES_DIV タイムラインイベント アクションUI
    @VALUES_CLASS = constant.ElementAttribute.TE_VALUES_CLASS

  # コンストラクタ
  constructor: (e, @teEmt, teNum = null) ->
    @emt = $(e).closest('.event')
    if teNum?
      @teNum = teNum
      @readFromPageValue()
    else
      @teNum = getPageValue(Constant.PageValueKey.TE_COUNT)
      if !@teNum?
        @teNum = 1

  # イベントタイプ選択
  selectItem: (e) ->
    value = $(e).val()

    # デフォルト選択時
    if value == ""
      # 非表示にする
      $(".config.te_div", @emt).css('display', 'none')
      return

    @isCommonEvent = value.indexOf(Constant.TIMELINE_COMMON_PREFIX) == 0
    if @isCommonEvent
      @actionEventTypeId = parseInt(value.substring(Constant.TIMELINE_COMMON_PREFIX.length))
    else
      splitValues = value.split(Constant.TIMELINE_ITEM_SEPERATOR)
      @id = splitValues[0]
      @itemId = splitValues[1]

    # 選択枠消去
    clearSelectedBorder()

    if !@isCommonEvent
      vEmt = $('#' + @id)
      # 選択枠設定
      setSelectedBorder(vEmt, 'timeline')
      # フォーカス
      focusToTarget(vEmt)

    # 一度全て非表示にする
    $(".config.te_div", @emt).css('display', 'none')
    $(".action_div .forms", @emt).children("div").css('display', 'none')

    # 表示
    displayClassName = ''
    if @isCommonEvent
      displayClassName = Constant.TIMELINE_COMMON_ACTION_CLASSNAME
    else
      displayClassName = @constructor.ACTION_CLASS.replace('@itemid', @itemId)
    $(".#{displayClassName}", @emt).css('display', '')
    $(".action_div", @emt).css('display', '')

  # メソッド選択
  clickMethod: (e) ->
    valueClassName = null
    @actionType = $(e).find('input.action_type').val()
    if @isCommonEvent
      valueClassName = Constant.TIMELINE_COMMON_PREFIX + @actionEventTypeId
    else
      @methodName = $(e).find('input.method_name').val()
      valueClassName = @constructor.VALUES_CLASS.replace('@itemid', @itemId).replace('@methodname', @methodName)

    extraClassName = null
    if @actionType == "scroll"
      extraClassName = "scroll_point_div"
    else
      extraClassName = "click_parallel_div"

    $(".scroll_point_div", @emt).css('display', 'none')
    $(".click_parallel_div", @emt).css('display', 'none')
    $(".values_div .forms", @emt).children("div").css('display', 'none')
    $(".#{extraClassName}", @emt).css('display', '')
    $(".#{valueClassName}", @emt).css('display', '')
    $(".config.values_div", @emt).css('display', '')

    # 初期化
    @initConfigUI(@actionEventTypeId)

  # コンフィグUI初期化
  initConfigUI: (type) ->
    typeArray = []
    if typeOfValue(type) != "array"
      typeArray.push(type)
    else
      typeArray = type

    $(typeArray).each((e) ->
      if e == Constant.CommonActionEventChangeType.BACKGROUND
        bgColor = $('#main-wrapper.stage_container').css('backgroundColor')
        $(".baseColor", $("values_div", @emt)).css('backgroundColor', bgColor)
        $(".colorPicker", @emt).each( ->
          self = $(@)
          if !self.hasClass('temp') && !self.hasClass('baseColor')
            initColorPicker(self, "fff", null)
        )
      else if e == Constant.CommonActionEventChangeType.MOVE
        # FIXME:
        console.log('move')
    )

  # イベントの入力値を初期化する
  resetAction: ->
    $('.values .args', @emt).html('')

  # 入力値を適用する
  applyAction: ->
    # 入力値を保存
    errorMes = @writeToPageValue()
    if errorMes? && errorMes.length > 0
      # エラー発生時
      @showError(errorMes)
      return

    # イベントの色を変更
    $(@teEmt).removeClass("blank")
    if @isCommonEvent
      $(@teEmt).addClass("common")
    else
      $(@teEmt).addClass(@actionType)

  # 画面値に書き込み
  writeToPageValue: ->
    errorMes = "Not implemented"
    writeValue = null
    if @isCommonEvent
      if @actionEventTypeId == Constant.CommonActionEventChangeType.BACKGROUND
        errorMes = TimelineCommonEventBackground.writeToPageValue(@)
      else if @actionEventTypeId == Constant.CommonActionEventChangeType.MOVE
        errorMes = TimelineCommonEventMove.writeToPageValue(@)

    return errorMes


  # 画面値から読み込み
  readFromPageValue: ->
    if @isCommonEvent
      if @actionEventTypeId == Constant.CommonActionEventChangeType.BACKGROUND
        TimelineCommonEventBackground.readFromPageValue()
      else if @actionEventTypeId == Constant.CommonActionEventChangeType.MOVE
        TimelineCommonEventMove.readFromPageValue()

  # エラー表示
  showError: (message)->
    timelineConfigError = $('.timeline_config_error', @emt)
    timelineConfigError.find('p').html(message)
    timelineConfigError.css('display', '')

  # エラー非表示
  clearError: ->
    timelineConfigError = $('.timeline_config_error', @emt)
    timelineConfigError.find('p').html('')
    timelineConfigError.css('display', 'none')
