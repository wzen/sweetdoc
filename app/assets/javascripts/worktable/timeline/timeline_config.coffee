class TimelineConfig

  if gon?
    # @property [String] TE_ITEM_ROOT_ID タイムラインイベントRoot
    @ITEM_ROOT_ID = 'timeline_event_@te_num'
    # @property [String] TE_ACTION_CLASS タイムラインイベント アクション一覧
    @ACTION_CLASS = 'timeline_event_action_@itemid'
    # @property [String] TE_VALUES_DIV タイムラインイベント アクションUI
    @VALUES_CLASS = constant.ElementAttribute.TE_VALUES_CLASS

  # コンストラクタ
  constructor: (@emt, @teNum) ->
    #@emt = $(e).closest('.event')
    if @readFromPageValue()
      @setupConfigValues()
      @selectItem()
      @clickMethod()

  # インスタンス値から画面の状態を設定
  setupConfigValues: ->
    self = @

    # 選択イベントタイプ
    selectItemValue = ''
    if @isCommonEvent
      selectItemValue = "#{Constant.TIMELINE_COMMON_PREFIX}#{@commonEventId}"
    else
      selectItemValue = "#{@id}#{Constant.TIMELINE_ITEM_SEPERATOR}#{@itemId}"
    $('.te_item_select', @emt).val(selectItemValue)

    actionFormName = ''
    if @isCommonEvent
      actionFormName = Constant.TIMELINE_COMMON_PREFIX + @commonEventId
    else
      actionFormName = TimelineConfig.ACTION_CLASS.replace('@itemid', @itemId)

    $(".#{actionFormName} .radio", @emt).each((e) ->
      actionType = $(@).find('input.action_type').val()
      methodName = $(@).find('input.method_name').val()
      if parseInt(actionType) == self.actionType && methodName == self.methodName
        $(@).find('input:radio').prop('checked', true)
        return false
    )

  # イベントタイプ選択
  selectItem: (e = null) ->
    if e?
      value = $(e).val()

      # デフォルト選択時
      if value == ""
        # 非表示にする
        $(".config.te_div", @emt).css('display', 'none')
        return

      @isCommonEvent = value.indexOf(Constant.TIMELINE_COMMON_PREFIX) == 0
      if @isCommonEvent
        @commonEventId = parseInt(value.substring(Constant.TIMELINE_COMMON_PREFIX.length))
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
      displayClassName = value
    else
      displayClassName = @constructor.ACTION_CLASS.replace('@itemid', @itemId)
    $(".#{displayClassName}", @emt).css('display', '')
    $(".action_div", @emt).css('display', '')

    _setMethodActionEvent.call(@)

    checkedRadioButton = $(".action_forms input:radio[name='#{displayClassName}']:checked", @emt)
    if checkedRadioButton.val()
      @clickMethod(checkedRadioButton)

  # メソッド選択
  clickMethod: (e = null) ->
    if e?
      parent = $(e).closest('.radio')
      @actionType = parseInt(parent.find('input.action_type:first').val())
      @methodName = parent.find('input.method_name:first').val()

    valueClassName = null
    if @isCommonEvent
      valueClassName = "#{Constant.TIMELINE_COMMON_ACTION_PREFIX}#{@commonEventId}_#{@methodName}"
    else
      valueClassName = @constructor.VALUES_CLASS.replace('@itemid', @itemId).replace('@methodname', @methodName)

    handlerClassName = valueClassName

    $(".handler_div .configBox", @emt).children("div").css('display', 'none')
    $(".handler_div .#{handlerClassName}", @emt).css('display', '')
    $(".config.handler_div", @emt).css('display', '')

    $(".value_forms", @emt).children("div").css('display', 'none')
    $(".value_forms .#{valueClassName}", @emt).css('display', '')
    $(".config.values_div", @emt).css('display', '')

    if e?
      # 初期化
      tle = _timelineEvent.call(@)
      if tle? && tle.initConfigValue?
        tle.initConfigValue(@)

    _setApplyClickEvent.call(@)

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
    changeTimelineColor(@teNum, @actionType)

  # 画面値に書き込み
  writeToPageValue: ->
    errorMes = "Not implemented"
    writeValue = null
    tle = _timelineEvent.call(@)
    if tle?
      errorMes = tle.writeToPageValue(@)
    return errorMes

  # 画面値から読み込み
  readFromPageValue: ->
    if TimelineEvent.readFromPageValue(@)
      tle = _timelineEvent.call(@)
      if tle?
        return tle.readFromPageValue(@)
    return false

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

  _timelineEvent = ->
    if @isCommonEvent == null
      return null

    if @isCommonEvent
      if @commonEventId == Constant.CommonActionEventChangeType.BACKGROUND
        return TLEBackgroundColorChange
      else if @commonEventId == Constant.CommonActionEventChangeType.SCREEN
        return TLEScreenPositionChange
    else
      return TLEItemChange

  _setMethodActionEvent = ->
    self = @
    em = $('.action_forms input:radio', @emt)
    em.off('change')
    em.on('change', (e) ->
      self.clickMethod(@)
    )

  _setApplyClickEvent = ->
    self = @
    em = $('.push.button.reset', @emt)
    em.off('click')
    em.on('click', (e) ->
      # UIの入力値を初期化
      self.resetAction()
    )
    em = $('.push.button.apply', @emt)
    em.off('click')
    em.on('click', (e) ->
      # 入力値を適用する
      self.applyAction()
      # イベントを更新
      setupTimelineEventConfig()
      # 次のイベントConfigを表示
    )
    em = $('.push.button.cancel', @emt)
    em.off('click')
    em.on('click', (e) ->
      # 入力を全てクリアしてサイドバーを閉じる
      e = $(@).closest('.event')
      $('.values', e).html('')
      closeSidebar( ->
        $(".config.te_div", e).css('display', 'none')
      )
    )
