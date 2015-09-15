class EventConfig

  if gon?
    # @property [String] TE_ITEM_ROOT_ID イベントRoot
    @ITEM_ROOT_ID = 'event_@te_num'
    # @property [String] EVENT_ITEM_SEPERATOR イベント(アイテム)値のセパレータ
    @EVENT_ITEM_SEPERATOR = "&"
    # @property [String] COMMON_ACTION_CLASS イベント共通アクションクラス名
    @COMMON_ACTION_CLASS = constant.EventConfig.COMMON_ACTION_CLASS
    # @property [String] ITEM_ACTION_CLASS イベントアイテムアクションクラス名
    @ITEM_ACTION_CLASS = constant.EventConfig.ITEM_ACTION_CLASS
    # @property [String] COMMON_VALUES_CLASS 共通イベントクラス名
    @COMMON_VALUES_CLASS = constant.EventConfig.COMMON_VALUES_CLASS
    # @property [String] ITEM_VALUES_CLASS アイテムイベントクラス名
    @ITEM_VALUES_CLASS = constant.EventConfig.ITEM_VALUES_CLASS
    # @property [String] EVENT_COMMON_PREFIX 共通イベントプレフィックス
    @EVENT_COMMON_PREFIX = constant.EventConfig.EVENT_COMMON_PREFIX

  # コンストラクタ
  # @param [Object] @emt コンフィグRoot
  # @param [Integer] @teNum イベント番号
  constructor: (@emt, @teNum) ->
    _setupFromPageValues.call(@)

  # インスタンス値から画面の状態を設定
  setupConfigValues: ->
    self = @

    # 選択イベントタイプ
    selectItemValue = ''
    if @isCommonEvent
      selectItemValue = "#{EventConfig.EVENT_COMMON_PREFIX}#{@commonEventId}"
    else
      selectItemValue = "#{@id}#{EventConfig.EVENT_ITEM_SEPERATOR}#{@itemId}"
    $('.te_item_select', @emt).val(selectItemValue)

    actionFormName = ''
    if @isCommonEvent
      actionFormName = EventConfig.EVENT_COMMON_PREFIX + @commonEventId
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
  # @param [Object] e 選択オブジェクト
  selectItem: (e = null) ->
    if e?
      value = $(e).val()

      # デフォルト選択時
      if value == ""
        # 非表示にする
        $(".config.te_div", @emt).css('display', 'none')
        return

      @isCommonEvent = value.indexOf(EventConfig.EVENT_COMMON_PREFIX) == 0
      if @isCommonEvent
        @commonEventId = parseInt(value.substring(EventConfig.EVENT_COMMON_PREFIX.length))
      else
        splitValues = value.split(EventConfig.EVENT_ITEM_SEPERATOR)
        @id = splitValues[0]
        @itemId = splitValues[1]

    # 選択枠消去
    WorktableCommon.clearSelectedBorder()

    if !@isCommonEvent
      vEmt = $('#' + @id)
      # 選択枠設定
      WorktableCommon.setSelectedBorder(vEmt, 'timeline')
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
  # @param [Object] e 選択オブジェクト
  clickMethod: (e = null) ->
    if e?
      parent = $(e).closest('.radio')
      @actionType = parseInt(parent.find('input.action_type:first').val())
      @methodName = parent.find('input.method_name:first').val()
      @animationType = parent.find('input.animation_type:first').val()

    handlerClassName = @methodClassName()
    valueClassName = @methodClassName()

    if @teNum > 1
      beforeActionType = PageValue.getEventPageValue(PageValue.Key.eventNumber(@teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE]
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
      tle = _getEventPageValueClass.call(@)
      if tle? && tle.initConfigValue?
        tle.initConfigValue(@)

    _setScrollDirectionEvent.call(@)
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

        topEmt = handlerDiv.find('.scroll_enabled_top:first')
        bottomEmt = handlerDiv.find('.scroll_enabled_bottom:first')
        leftEmt = handlerDiv.find('.scroll_enabled_left:first')
        rightEmt = handlerDiv.find('.scroll_enabled_right:first')
        @scrollEnabledDirection = {
          top: topEmt.find('.scroll_enabled:first').is(":checked")
          bottom: bottomEmt.find('.scroll_enabled:first').is(":checked")
          left: leftEmt.find('.scroll_enabled:first').is(":checked")
          right: rightEmt.find('.scroll_enabled:first').is(":checked")
        }
        @scrollForwardDirection = {
          top: topEmt.find('.scroll_forward:first').is(":checked")
          bottom: bottomEmt.find('.scroll_forward:first').is(":checked")
          left: leftEmt.find('.scroll_forward:first').is(":checked")
          right: rightEmt.find('.scroll_forward:first').is(":checked")
        }

    if @isCommonEvent
      # 共通イベントはここでインスタンス生成
      commonEventClass = Common.getClassFromMap(true, @commonEventId)
      commonEvent = new commonEventClass()
      instanceMap[commonEvent.id] = commonEvent
      commonEvent.setItemAllPropToPageValue()
      @id = commonEvent.id

    errorMes = @writeToPageValue()
    if errorMes? && errorMes.length > 0
      # エラー発生時
      @showError(errorMes)
      return

    # イベントの色を変更
    Timeline.changeTimelineColor(@teNum, @actionType)

    # キャッシュに保存
    LocalStorage.saveAllPageValues()

    # プレビュー開始
    item = instanceMap[@id]
    if item? && item.preview?
      item.preview(PageValue.getEventPageValue(PageValue.Key.eventNumber(@teNum)))

  # 画面値に書き込み
  writeToPageValue: ->
    errorMes = "Not implemented"
    writeValue = null
    tle = _getEventPageValueClass.call(@)
    if tle?
      errorMes = tle.writeToPageValue(@)
    return errorMes

  # 画面値から読み込み
  readFromPageValue: ->
    if EventPageValueBase.readFromPageValue(@)
      tle = _getEventPageValueClass.call(@)
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
  # @param [String] message メッセージ内容
  showError: (message)->
    eventConfigError = $('.event_config_error', @emt)
    eventConfigError.find('p').html(message)
    eventConfigError.css('display', '')

  # エラー非表示
  clearError: ->
    eventConfigError = $('.event_config_error', @emt)
    eventConfigError.find('p').html('')
    eventConfigError.css('display', 'none')

  # 対応するEventPageValueクラスを取得
  # @return [Class] EventPageValueクラス
  _getEventPageValueClass = ->
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

  _setScrollDirectionEvent = ->
    self = 0
    handler = $('.handler_div', @emt)
    $('.scroll_enabled', handler).off('click')
    $('.scroll_enabled').on('click', (e) ->
      if $(@).is(':checked')
        $(@).closest('.scroll_enabled_wrapper').find('.scroll_forward:first').parent('label').css('display', 'block')
      else
        emt = $(@).closest('.scroll_enabled_wrapper').find('.scroll_forward:first')
        emt.parent('label').css('display', 'none')
        emt.prop('checked', false)
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
      Timeline.refreshAllTimeline()
      # 次のイベントConfigを表示
    )
    em = $('.push.button.cancel', @emt)
    em.off('click')
    em.on('click', (e) ->
      self.clearError()

      # 入力を全てクリアしてサイドバーを閉じる
      e = $(@).closest('.event')
      $('.values', e).html('')
      Sidebar.closeSidebar( ->
        $(".config.te_div", e).css('display', 'none')
      )
    )

  _setupFromPageValues = ->
    if @readFromPageValue()
      @setupConfigValues()
      @selectItem()
      @clickMethod()

  # 追加されたコンフィグを全て消去
  @removeAllConfig: ->
    $('#event-config').children('.event').remove()

  # アクションイベント情報をコンフィグ内に追加
  # @param [Integer] item_id アイテムID
  # @param [Array] te_actions 追加するアクションデータ
  # @param [Array] te_values 追加するValueデータ
  @addEventConfigContents = (item_id, te_actions, te_values) ->
    if te_actions? && te_actions.length > 0
      className = EventConfig.ITEM_ACTION_CLASS.replace('@itemid', item_id)
      handler_forms = $('#event-config .handler_div .configBox')
      action_forms = $('#event-config .action_forms')
      if action_forms.find(".#{className}").length == 0

        actionParent = $("<div class='#{className}' style='display:none'></div>")
        te_actions.forEach( (a) ->
          # アクションメソッドConfig追加
          actionType = Common.getActionTypeClassNameByActionType(a.action_event_type_id)
          methodClone = $('#event-config .method_temp').children(':first').clone(true)
          span = methodClone.find('label:first').children('span:first')
          span.attr('class', actionType)
          span.html(a.options['name'])
          methodClone.find('input.action_type:first').val(a.action_event_type_id)
          methodClone.find('input.method_name:first').val(a.method_name)
          methodClone.find('input.animation_type:first').val(a.action_animation_type_id)
          valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@itemid', item_id).replace('@methodname', a.method_name)
          methodClone.find('input:radio').attr('name', className)
          methodClone.find('input.value_class_name:first').val(valueClassName)
          actionParent.append(methodClone)

          # イベントタイプConfig追加
          handlerClone = null
          if a.action_event_type_id == Constant.ActionEventHandleType.SCROLL
            handlerClone = $('#event-config .handler_scroll_temp').children().clone(true)
          else if a.action_event_type_id == Constant.ActionEventHandleType.CLICK
            handlerClone = $('#event-config .handler_click_temp').children().clone(true)
          handlerParent = $("<div class='#{valueClassName}' style='display:none'></div>")
          handlerParent.append(handlerClone)
          handlerParent.appendTo(handler_forms)
        )

        actionParent.appendTo(action_forms)

    if te_values?
      $(te_values).appendTo($('#event-config .value_forms'))