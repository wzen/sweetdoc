class EventConfig

  if gon?
    # @property [String] TE_ITEM_ROOT_ID タイムラインイベントRoot
    @ITEM_ROOT_ID = 'event_@te_num'
    # @property [String] COMMON_ACTION_CLASS タイムライン共通アクションクラス名
    @COMMON_ACTION_CLASS = constant.ElementAttribute.COMMON_ACTION_CLASS
    # @property [String] ITEM_ACTION_CLASS タイムラインアイテムアクションクラス名
    @ITEM_ACTION_CLASS = constant.ElementAttribute.ITEM_ACTION_CLASS
    # @property [String] COMMON_VALUES_CLASS 共通タイムラインイベントクラス名
    @COMMON_VALUES_CLASS = constant.ElementAttribute.COMMON_VALUES_CLASS
    # @property [String] ITEM_VALUES_CLASS アイテムタイムラインイベントクラス名
    @ITEM_VALUES_CLASS = constant.ElementAttribute.ITEM_VALUES_CLASS

  # コンストラクタ
  constructor: (@emt, @teNum) ->
    _setupFromPageValues.call(@)

  # インスタンス値から画面の状態を設定
  setupConfigValues: ->
    self = @

    # 選択イベントタイプ
    selectItemValue = ''
    if @isCommonEvent
      selectItemValue = "#{Constant.EVENT_COMMON_PREFIX}#{@commonEventId}"
    else
      selectItemValue = "#{@id}#{Constant.EVENT_ITEM_SEPERATOR}#{@itemId}"
    $('.te_item_select', @emt).val(selectItemValue)

    actionFormName = ''
    if @isCommonEvent
      actionFormName = Constant.EVENT_COMMON_PREFIX + @commonEventId
    else
      actionFormName = EventConfig.ITEM_ACTION_CLASS.replace('@itemid', @itemId)

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

      @isCommonEvent = value.indexOf(Constant.EVENT_COMMON_PREFIX) == 0
      if @isCommonEvent
        @commonEventId = parseInt(value.substring(Constant.EVENT_COMMON_PREFIX.length))
      else
        splitValues = value.split(Constant.EVENT_ITEM_SEPERATOR)
        @id = splitValues[0]
        @itemId = splitValues[1]

    # 選択枠消去
    clearSelectedBorder()

    if !@isCommonEvent
      vEmt = $('#' + @id)
      # 選択枠設定
      setSelectedBorder(vEmt, 'timeline')
      # フォーカス
      Common.focusToTarget(vEmt)

    # 一度全て非表示にする
    $(".config.te_div", @emt).css('display', 'none')
    $(".action_div .forms", @emt).children("div").css('display', 'none')

    # 表示
    displayClassName = ''
    if @isCommonEvent
      displayClassName = @constructor.COMMON_ACTION_CLASS.replace('@commoneventid', @commonEventId)
    else
      displayClassName = @constructor.ITEM_ACTION_CLASS.replace('@itemid', @itemId)
    $(".#{displayClassName}", @emt).css('display', '')
    $(".action_div", @emt).css('display', '')

    _setMethodActionEvent.call(@)

    if e?
      # ラジオボタンをクリックした場合
      checkedRadioButton = $(".action_forms input:radio[name='#{displayClassName}']:checked", @emt)
      if checkedRadioButton.val()
        @clickMethod(checkedRadioButton)

  # メソッド選択
  clickMethod: (e = null) ->
    if e?
      parent = $(e).closest('.radio')
      @actionType = parseInt(parent.find('input.action_type:first').val())
      @methodName = parent.find('input.method_name:first').val()
      @animationType = parent.find('input.animation_type:first').val()

    handlerClassName = @methodClassName()
    valueClassName = @methodClassName()

    if @teNum > 1
      beforeActionType = PageValue.getEventPageValue(EventPageValueBase.PageValueKey.te(@teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE]
      if @actionType == beforeActionType
        # 前のイベントと同じアクションタイプの場合は同時実行を表示
        $(".config.parallel_div", @emt).css('display', '')

    $(".handler_div .configBox", @emt).children("div").css('display', 'none')
    $(".handler_div .#{handlerClassName}", @emt).css('display', '')
    $(".config.handler_div", @emt).css('display', '')

    $(".value_forms", @emt).children("div").css('display', 'none')
    $(".value_forms .#{valueClassName}", @emt).css('display', '')
    $(".config.values_div", @emt).css('display', '')

    if e?
      # 初期化
      tle = _getEventClass.call(@)
      if tle? && tle.initConfigValue?
        tle.initConfigValue(@)

    _setApplyClickEvent.call(@)

  # イベントの入力値を初期化する
  resetAction: ->
    _setupFromPageValues.call(@)

  # 入力値を適用する
  applyAction: ->
    # 入力値を保存

    @isParallel = false
    parallel = $(".parallel_div .parallel", @emt)
    if parallel?
      @isParallel = parallel.is(":checked")

    if @actionType == Constant.ActionEventHandleType.SCROLL
      @scrollPointStart = ''
      @scrollPointEnd = ""
      handlerDiv = $(".handler_div .#{@methodClassName()}", @emt)
      if handlerDiv?
        @scrollPointStart = handlerDiv.find('.scroll_point_start:first').val()
        @scrollPointEnd = handlerDiv.find('.scroll_point_end:first').val()

    if @isCommonEvent
      # 共通イベントはここでインスタンス生成
      commonEvent = Common.getClassFromMap(true, @commonEventId)
      @id = (new commonEvent()).id

    errorMes = @writeToPageValue()
    if errorMes? && errorMes.length > 0
      # エラー発生時
      @showError(errorMes)
      return

    # イベントの色を変更
    changeTimelineColor(@teNum, @actionType)

    # プレビュー開始
    item = createdObject[@id]
    if item? && item.preview?
      item.preview(PageValue.getEventPageValue(EventPageValueBase.PageValueKey.te(@teNum)))

  # 画面値に書き込み
  writeToPageValue: ->
    errorMes = "Not implemented"
    writeValue = null
    tle = _getEventClass.call(@)
    if tle?
      errorMes = tle.writeToPageValue(@)
    return errorMes

  # 画面値から読み込み
  readFromPageValue: ->
    if EventPageValueBase.readFromPageValue(@)
      tle = _getEventClass.call(@)
      if tle?
        return tle.readFromPageValue(@)
    return false

  # アクションメソッド & メソッド毎の値のクラス名を取得
  methodClassName: ->
    if @isCommonEvent
      return @constructor.COMMON_VALUES_CLASS.replace('@commoneventid', @commonEventId).replace('@methodname', @methodName)
    else
      return @constructor.ITEM_VALUES_CLASS.replace('@itemid', @itemId).replace('@methodname', @methodName)

  # エラー表示
  showError: (message)->
    eventConfigError = $('.timeline_config_error', @emt)
    eventConfigError.find('p').html(message)
    eventConfigError.css('display', '')

  # エラー非表示
  clearError: ->
    eventConfigError = $('.timeline_config_error', @emt)
    eventConfigError.find('p').html('')
    eventConfigError.css('display', 'none')

  _getEventClass = ->
    if @isCommonEvent == null
      return null

    if @isCommonEvent
      if @commonEventId == Constant.CommonActionEventChangeType.BACKGROUND
        return EPVBackgroundColor
      else if @commonEventId == Constant.CommonActionEventChangeType.SCREEN
        return EPVScreenPosition
    else
      return EPVItem

  _setMethodActionEvent = ->
    self = @
    em = $('.action_forms input:radio', @emt)
    em.off('change')
    em.on('change', (e) ->
      self.clearError()

      self.clickMethod(@)
    )

  _setApplyClickEvent = ->
    self = @
    em = $('.push.button.reset', @emt)
    em.off('click')
    em.on('click', (e) ->
      self.clearError()

      # UIの入力値を初期化
      self.resetAction()
    )
    em = $('.push.button.apply', @emt)
    em.off('click')
    em.on('click', (e) ->
      self.clearError()

      # 入力値を適用する
      self.applyAction()
      # イベントを更新
      setupTimelineEventConfig()
      # 次のイベントConfigを表示
    )
    em = $('.push.button.cancel', @emt)
    em.off('click')
    em.on('click', (e) ->
      self.clearError()

      # 入力を全てクリアしてサイドバーを閉じる
      e = $(@).closest('.event')
      $('.values', e).html('')
      closeSidebar( ->
        $(".config.te_div", e).css('display', 'none')
      )
    )

  _setupFromPageValues = ->
    if @readFromPageValue()
      @setupConfigValues()
      @selectItem()
      @clickMethod()
