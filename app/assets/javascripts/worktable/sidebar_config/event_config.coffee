class EventConfig

  if gon?
    # 定数
    constant = gon.const
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
        $(".config.te_div", @emt).hide()
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
    $(".config.te_div", @emt).hide()
    $(".action_div .forms", @emt).children("div").hide()

    # 表示
    displayClassName = ''
    if @isCommonEvent
      displayClassName = @constructor.COMMON_ACTION_CLASS.replace('@commoneventid', @commonEventId)
    else
      displayClassName = @constructor.ITEM_ACTION_CLASS.replace('@itemid', @itemId)
      # アイテム共通情報表示
      $('.item_common_div', @emt).show()

    $(".#{displayClassName}", @emt).show()
    $(".action_div", @emt).show()

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

    _callback = ->
      handlerClassName = @methodClassName()
      valueClassName = @methodClassName()

      if @teNum > 1
        beforeActionType = PageValue.getEventPageValue(PageValue.Key.eventNumber(@teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE]
        if @actionType == beforeActionType
          # 前のイベントと同じアクションタイプの場合は同時実行を表示
          $(".config.parallel_div", @emt).show()

      # Handler表示
      $(".handler_div .configBox", @emt).children("div").hide()
      $(".handler_div .#{handlerClassName}", @emt).show()
      $(".config.handler_div", @emt).show()

      # 変更値表示
      $(".value_forms", @emt).children("div").hide()
      $(".value_forms .#{valueClassName}", @emt).show()
      $(".config.values_div", @emt).show()

      if e?
        # 初期化
        tle = _getEventPageValueClass.call(@)
        if tle? && tle.initConfigValue?
          tle.initConfigValue(@)

      if @actionType == Constant.ActionType.SCROLL
        _setScrollDirectionEvent.call(@)
      else if @actionType == Constant.ActionType.CLICK
        _setEventDuration.call(@)
        _setForkSelect.call(@)
      _setApplyClickEvent.call(@)

    if @id?
      # アイテム選択時
      item = window.instanceMap[@id]
      if item?
        # 変数変更コンフィグ読み込み
        @addEventVarModifyConfig(item.constructor, =>
          _callback.call(@)
        )
      else
        _callback.call(@)
    else if @commonEventId
      # 共通イベント選択時
      objClass = Common.getClassFromMap(true, @commonEventId)
      if objClass
        @addEventVarModifyConfig(objClass, =>
          _callback.call(@)
        )
      else
        _callback.call(@)

  # イベントの入力値を初期化する
  resetAction: ->
    _setupFromPageValues.call(@)

  # 入力値を適用する
  applyAction: ->
    # 入力値を保存

    if !@distId?
      @distId = Common.generateId()

    @itemSizeDiff = {
      x: parseInt($('.item_position_diff_x:first', @emt).val())
      y: parseInt($('.item_position_diff_y:first', @emt).val())
      w: parseInt($('.item_diff_width:first', @emt).val())
      h: parseInt($('.item_diff_height:first', @emt).val())
    }

    @isParallel = false
    parallel = $(".parallel_div .parallel", @emt)
    if parallel?
      @isParallel = parallel.is(":checked")

    if @actionType == Constant.ActionType.SCROLL
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

    else if @actionType == Constant.ActionType.CLICK
      handlerDiv = $(".handler_div .#{@methodClassName()}", @emt)
      if handlerDiv?
        @eventDuration = handlerDiv.find('.click_duration:first').val()

        @forkNum = 0
        checked = handlerDiv.find('.enable_fork:first').is(':checked')
        if checked? && checked
          prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '')
          @forkNum = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''))

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
    eventConfigError.show()

  # エラー非表示
  clearError: ->
    eventConfigError = $('.event_config_error', @emt)
    eventConfigError.find('p').html('')
    eventConfigError.hide()

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
    $('.scroll_enabled', handler).on('click', (e) ->
      if $(@).is(':checked')
        $(@).closest('.scroll_enabled_wrapper').find('.scroll_forward:first').parent('label').show()
      else
        emt = $(@).closest('.scroll_enabled_wrapper').find('.scroll_forward:first')
        emt.parent('label').hide()
        emt.prop('checked', false)
    )

  _setEventDuration = ->
    self = 0
    handler = $('.handler_div', @emt)
    eventDuration = handler.find('.click_duration:first')
    if @eventDuration?
      eventDuration.val(@eventDuration)
    else
      item = window.instanceMap[@id]
      if item?
        eventDuration.val(item.constructor.actionProperties.methods[@methodName][item.constructor.ActionPropertiesKey.EVENT_DURATION])

  _setForkSelect = ->
    self = 0
    handler = $('.handler_div', @emt)
    $('.enable_fork', handler).off('click')
    $('.enable_fork', handler).on('click', (e) ->
      $('.fork_select', handler).parent('div').css('display', if $(@).is(':checked') then 'block' else 'none')
     )

    # Forkコンフィグ作成
    forkCount = PageValue.getForkCount()
    if forkCount > 0
      forkNum = PageValue.getForkNum()
      # Fork選択作成
      selectOptions = ''
      for i in [1..forkCount]
        if i != forkNum # 現在のフォークは選択肢に含めない
          name = Constant.Paging.NAV_MENU_FORK_NAME.replace('@forknum', i)
          value = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', i)
          selectOptions += "<option value='#{value}'>#{name}</option>"

      if selectOptions.length > 0
        $('.fork_select', handler).children().remove()
        $('.fork_select', handler).append($(selectOptions))
        # Fork表示
        $('.fork_handler_wrapper', handler).show()
      else
        # 選択肢が無い場合、Fork非表示
        $('.fork_handler_wrapper', handler).hide()
    else
      # Fork非表示
      $('.fork_handler_wrapper', handler).hide()

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
    )
    em = $('.push.button.cancel', @emt)
    em.off('click')
    em.on('click', (e) ->
      self.clearError()

      # 入力を全てクリアしてサイドバーを閉じる
      e = $(@).closest('.event')
      $('.values', e).html('')
      Sidebar.closeSidebar( ->
        $(".config.te_div", e).hide()
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

  # アクションイベント情報をコンフィグに追加
  # @param [Integer] item_id アイテムID
  @addEventConfigContents = (item_id) ->
    itemClass = Common.getClassFromMap(false, item_id)

    if itemClass? && itemClass.actionProperties?
      className = EventConfig.ITEM_ACTION_CLASS.replace('@itemid', item_id)
      handler_forms = $('#event-config .handler_div .configBox')
      action_forms = $('#event-config .action_forms')
      if action_forms.find(".#{className}").length == 0
        actionParent = $("<div class='#{className}' style='display:none'></div>")
        props = itemClass.actionProperties
        if !props?
          console.log('Not declaration actionProperties')
          return
        methods = props[ItemBase.ActionPropertiesKey.METHODS]
        if !methods?
          console.log("Not Found #{ItemBase.ActionPropertiesKey.METHODS} key in actionProperties")
          return
        for methodName, prop of methods
          # アクションメソッドConfig追加
          actionType = Common.getActionTypeByCodingActionType(prop.actionType)
          actionTypeClassName = Common.getActionTypeClassNameByActionType(actionType)
          methodClone = $('#event-config .method_temp').children(':first').clone(true)
          span = methodClone.find('label:first').children('span:first')
          span.attr('class', actionTypeClassName)
          span.html(prop[ItemBase.ActionPropertiesKey.OPTIONS]['name'])
          methodClone.find('input.action_type:first').val(actionType)
          methodClone.find('input.method_name:first').val(methodName)
          valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@itemid', item_id).replace('@methodname', methodName)
          methodClone.find('input:radio').attr('name', className)
          methodClone.find('input.value_class_name:first').val(valueClassName)
          actionParent.append(methodClone)

          # イベントタイプConfig追加
          handlerClone = null
          if actionType == Constant.ActionType.SCROLL
            handlerClone = $('#event-config .handler_scroll_temp').children().clone(true)
          else if actionType == Constant.ActionType.CLICK
            handlerClone = $('#event-config .handler_click_temp').children().clone(true)
          handlerParent = $("<div class='#{valueClassName}' style='display:none'></div>")
          handlerParent.append(handlerClone)
          handlerParent.appendTo(handler_forms)

        actionParent.appendTo(action_forms)

  # 変数編集の入力フォームを追加
  addEventVarModifyConfig: (objClass, successCallback = null, errorCallback = null) ->
    # HTML存在チェック
    valueClassName = @methodClassName()
    emt = $(".value_forms .#{valueClassName}", @emt)
    if emt.length > 0
      # コンフィグの初期化
      @initEventVarModifyConfig(objClass)
      if successCallback?
        successCallback()
      return

    $.ajax(
      {
        url: "/worktable/event_var_modify_config"
        type: "POST"
        data: {
          modifiables: objClass.actionProperties.methods[@methodName].modifiables
        }
        dataType: "json"
        success: (data) =>
          if data.resultSuccess
            # コンフィグ追加
            $(".value_forms", @emt).append($("<div class='#{valueClassName}'>#{data.html}</div>"))
            # コンフィグの初期化
            @initEventVarModifyConfig(objClass)
            if successCallback?
              successCallback(data)
          else
            if errorCallback?
              errorCallback(data)
            console.log('/worktable/event_var_modify_config server error')
        error: (data) ->
          if errorCallback?
            errorCallback(data)
          console.log('/worktable/event_var_modify_config ajax error')
      }
    )

  # 変数編集コンフィグの初期化
  initEventVarModifyConfig: (objClass) ->
    mod = objClass.actionProperties.methods[@methodName].modifiables
    if mod?
      for varName, v of mod
        if @hasModifiableVar(varName)
          defaultValue = @modifiableVars[varName]
        else
          defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
        if v.type == Constant.ItemDesignOptionType.NUMBER
          @settingModifiableVarSlider(varName, defaultValue, v.min, v.max, v.stepValue)
        else if v.type == Constant.ItemDesignOptionType.STRING
          @settingModifiableString(varName, defaultValue)
        else if v.type == Constant.ItemDesignOptionType.COLOR
          @settingModifiableColor(varName, defaultValue)

  # 変数変更値が存在するか
  hasModifiableVar: (varName = null) ->
    ret = @modifiableVars? && @modifiableVars? != 'undefined'
    if varName?
      return ret && @modifiableVars[varName]?
    else
      return ret

  # 変数編集スライダーの作成
  # @param [Int] varName 変数名
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Int] stepValue 進捗数
  settingModifiableVarSlider: (varName, defaultValue, min = 0, max = 100, stepValue = 0) ->
    meterClassName = "#{varName}_meter"
    meterElement = $(".#{meterClassName}", @emt)
    valueElement = meterElement.prev('input:first')
    valueElement.val(defaultValue)
    valueElement.html(defaultValue)
    try
      meterElement.slider('destroy')
    catch #例外は握りつぶす
    meterElement.slider({
      min: min,
      max: max,
      step: stepValue,
      value: defaultValue
      slide: (event, ui) =>
        valueElement.val(ui.value)
        valueElement.html(ui.value)
        if !@hasModifiableVar(varName)
          @modifiableVars = {}
        @modifiableVars[varName] = ui.value
    })

  # 変数編集テキストボックスの作成
  # @param [String] varName 変数名
  settingModifiableString: (varName, defaultValue) ->
    $(".#{varName}_text", @emt).val(defaultValue)
    $(".#{varName}_text", @emt).off('change').on('change', =>
      if !@hasModifiableVar(varName)
        @modifiableVars = {}
      @modifiableVars[varName] = $(@).val()
    )

  # 変数編集カラーピッカーの作成
  # @param [Object] configRoot コンフィグルート
  # @param [String] varName 変数名
  settingModifiableColor: (varName, defaultValue) ->
    emt = $(".#{varName}_color", @emt)
    ColorPickerUtil.initColorPicker(
      $(emt),
      defaultValue,
      (a, b, d, e) =>
        if !@hasModifiableVar(varName)
          @modifiableVars = {}
        @modifiableVars[varName] = "#{b}"
    )