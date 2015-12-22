class EventConfig

  if gon?
    # 定数
    constant = gon.const
    # @property [String] TE_ITEM_ROOT_ID イベントRoot
    @ITEM_ROOT_ID = 'event_@distId'
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

    @METHOD_VALUE_MODIFY_ROOT = 'modify'
    @METHOD_VALUE_SPECIFIC_ROOT = 'specific'

  # コンストラクタ
  # @param [Object] @emt コンフィグRoot
  # @param [Integer] @teNum イベント番号
  constructor: (@emt, @teNum, @distId) ->
    _setupFromPageValues.call(@)

  # イベントコンフィグ表示前初期化
  @initEventConfig: (distId, teNum = 1) ->
    # アイテム選択メニュー更新
    @updateSelectItemMenu()
    # イベントハンドラの設定
    @setupTimelineEventHandler(distId, teNum)

  clearAllChange: ->
    # 全アイテム再描画
    WorktableCommon.reDrawAllItemsFromInstancePageValueIfChanging()
    # プレビューボタンに切り替え
    @emt.find('.button_preview_wrapper').show()
    @emt.find('.button_stop_preview_wrapper').hide()

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

      @[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] = value.indexOf(EventConfig.EVENT_COMMON_PREFIX) == 0
      if @[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
        @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] = parseInt(value.substring(EventConfig.EVENT_COMMON_PREFIX.length))
      else
        splitValues = value.split(EventConfig.EVENT_ITEM_SEPERATOR)
        @[EventPageValueBase.PageValueKey.ID] = splitValues[0]
        @[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN] = splitValues[1]

    if window.isWorkTable
      # 選択枠消去
      WorktableCommon.clearSelectedBorder()

    if !@[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      vEmt = $('#' + @[EventPageValueBase.PageValueKey.ID])
      if window.isWorkTable
        # 選択枠設定
        WorktableCommon.setSelectedBorder(vEmt, 'timeline')
        # フォーカス
        Common.focusToTarget(vEmt)

    # 一度全て非表示にする
    $(".config.te_div", @emt).hide()

    if !@[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      # アイテム共通情報表示
      $('.item_common_div', @emt).show()

    # Handler表示
    $(".config.handler_div", @emt).show()
    # Action表示
    $(".action_div", @emt).show()
    actionClassName = @actionClassName()
    $(".action_div .#{actionClassName}", @emt).show()

    # イベント設定
    _setHandlerRadioEvent.call(@)
    _setScrollDirectionEvent.call(@)
    _setForkSelect.call(@)
    _setMethodActionEvent.call(@)

  # メソッド選択
  # @param [Object] e 選択オブジェクト
  clickMethod: (e = null) ->
    _callback = ->
      if @[EventPageValueBase.PageValueKey.METHODNAME]?
        # 変更値表示
        valueClassName = @methodClassName()
        $(".value_forms", @emt).children("div").hide()
        $(".value_forms .#{valueClassName}", @emt).show()
        $(".config.values_div", @emt).show()

      _setApplyClickEvent.call(@)

    if !@[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]
      # アイテム選択時
      item = window.instanceMap[@[EventPageValueBase.PageValueKey.ID]]
      if item? && @[EventPageValueBase.PageValueKey.METHODNAME]?
        # 変数変更コンフィグ読み込み
        ConfigMenu.loadEventMethodValueConfig(@, item.constructor, =>
          _callback.call(@)
        )
      else
        _callback.call(@)
    else
      # 共通イベント選択時
      objClass = Common.getClassFromMap(true, @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID])
      if objClass
        ConfigMenu.loadEventMethodValueConfig(@, objClass, =>
          _callback.call(@)
        )
      else
        _callback.call(@)

  # 入力値を適用する
  applyAction: ->
    if !@[EventPageValueBase.PageValueKey.ACTIONTYPE]?
      if window.debug
        console.log('validation error')
      return false

    # 入力値を保存
    if !@[EventPageValueBase.PageValueKey.DIST_ID]?
      @[EventPageValueBase.PageValueKey.DIST_ID] = Common.generateId()

    @[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF] = {
      x: parseInt($('.item_position_diff_x:first', @emt).val())
      y: parseInt($('.item_position_diff_y:first', @emt).val())
      w: parseInt($('.item_diff_width:first', @emt).val())
      h: parseInt($('.item_diff_height:first', @emt).val())
    }

    @[EventPageValueBase.PageValueKey.DO_FOCUS] = $('.do_focus', @emt).prop('checked')
    @[EventPageValueBase.PageValueKey.IS_SYNC] = false
    parallel = $(".parallel_div .parallel", @emt)
    if parallel?
      @[EventPageValueBase.PageValueKey.IS_SYNC] = parallel.is(":checked")

    handlerDiv = $(".handler_div", @emt)
    if @[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionType.SCROLL
      @[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = ''
      @[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = ""
      @[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = handlerDiv.find('.scroll_point_start:first').val()
      @[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = handlerDiv.find('.scroll_point_end:first').val()

      topEmt = handlerDiv.find('.scroll_enabled_top:first')
      bottomEmt = handlerDiv.find('.scroll_enabled_bottom:first')
      leftEmt = handlerDiv.find('.scroll_enabled_left:first')
      rightEmt = handlerDiv.find('.scroll_enabled_right:first')
      @[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS] = {
        top: topEmt.find('.scroll_enabled:first').is(":checked")
        bottom: bottomEmt.find('.scroll_enabled:first').is(":checked")
        left: leftEmt.find('.scroll_enabled:first').is(":checked")
        right: rightEmt.find('.scroll_enabled:first').is(":checked")
      }
      @[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS] = {
        top: topEmt.find('.scroll_forward:first').is(":checked")
        bottom: bottomEmt.find('.scroll_forward:first').is(":checked")
        left: leftEmt.find('.scroll_forward:first').is(":checked")
        right: rightEmt.find('.scroll_forward:first').is(":checked")
      }

    else if @[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionType.CLICK
      @[EventPageValueBase.PageValueKey.EVENT_DURATION] = handlerDiv.find('.click_duration:first').val()
      @[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = 0
      checked = handlerDiv.find('.enable_fork:first').is(':checked')
      if checked? && checked
        prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '')
        @[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''))

    if @[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      # 共通イベントはここでインスタンス生成
      commonEventClass = Common.getClassFromMap(true, @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID])
      commonEvent = new commonEventClass()
      if !instanceMap[commonEvent.id]?
        # ※インスタンスが存在しない場合のみsetInstanceする
        instanceMap[commonEvent.id] = commonEvent
        commonEvent.setItemAllPropToPageValue()
      @[EventPageValueBase.PageValueKey.ID] = commonEvent.id

    errorMes = @writeToPageValue()
    if errorMes? && errorMes.length > 0
      # エラー発生時
      @showError(errorMes)
      return false

    # イベントの色を変更
    Timeline.changeTimelineColor(@teNum, @[EventPageValueBase.PageValueKey.ACTIONTYPE])
    # キャッシュに保存
    LocalStorage.saveAllPageValues()
    return true

  # プレビュー開始
  preview: (keepDispMag) ->
    WorktableCommon.updatePrevEventsToAfter(@teNum, =>
      WorktableCommon.runPreview(@teNum, keepDispMag)
    )

  # プレビュー停止
  stopPreview: (callback = null) ->
    WorktableCommon.stopAllEventPreview(callback)

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
    tle = _getEventPageValueClass.call(@)
    if tle?
      return tle.readFromPageValue(@)
    else
      return false

  # アクションメソッドクラス名を取得
  actionClassName: ->
    name = ''
    if @[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      name = @constructor.COMMON_ACTION_CLASS.replace('@commoneventid', @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID])
    else
      name = @constructor.ITEM_ACTION_CLASS.replace('@itemtoken', @[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN])
    return name

  # アクションメソッド & メソッド毎の値のクラス名を取得
  methodClassName: ->
    if @[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      return @constructor.COMMON_VALUES_CLASS.replace('@commoneventid', @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]).replace('@methodname', @[EventPageValueBase.PageValueKey.METHODNAME])
    else
      return @constructor.ITEM_VALUES_CLASS.replace('@itemtoken', @[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]).replace('@methodname', @[EventPageValueBase.PageValueKey.METHODNAME])

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
    if @[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == null
      return null

    if @[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      if @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] == Constant.CommonActionEventChangeType.SCREEN
        return EPVScreenPosition
      else
        return EventPageValueBase
    else
      return EPVItem

  _setMethodActionEvent = ->
    actionClassName = @actionClassName()
    em = $(".action_forms .#{actionClassName} input[type=radio]", @emt)
    em.off('click').on('click', (e) =>
      @clearError()
      parent = $(e.target).closest('.radio')
      @[EventPageValueBase.PageValueKey.METHODNAME] = parent.find('input.method_name:first').val()
      @clickMethod(e.target)
      if @[EventPageValueBase.PageValueKey.ACTIONTYPE]?
        # Buttonフォーム表示
        $('.button_div', @emt).show()
    )
    $(".action_forms .#{actionClassName} input[type=radio]:checked", @emt).trigger('click')

  _setHandlerRadioEvent = ->
    $('.handler_div input[type=radio]', @emt).off('click').on('click', (e) =>
      if $(".action_forms .#{@actionClassName()} input[type=radio]:checked", @emt).length > 0
        # Buttonフォーム表示
        $('.button_div', @emt).show()

      $('.handler_form', @emt).hide()
      if $(e.target).val() == 'scroll'
        @[EventPageValueBase.PageValueKey.ACTIONTYPE] = Constant.ActionType.SCROLL
        $('.scroll_form', @emt).show()
      else if $(e.target).val() == 'click'
        @[EventPageValueBase.PageValueKey.ACTIONTYPE] = Constant.ActionType.CLICK
        $('.click_form', @emt).show()

      if @teNum > 1
        beforeActionType = PageValue.getEventPageValue(PageValue.Key.eventNumber(@teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE]
        if @[EventPageValueBase.PageValueKey.ACTIONTYPE] == beforeActionType
          # 前のイベントと同じアクションタイプの場合は同時実行を表示
          $(".config.parallel_div", @emt).show()
        else
          $(".config.parallel_div", @emt).hide()
    )
    $('.handler_div input[type=radio]:checked', @emt).trigger('click')

  _setScrollDirectionEvent = ->
    self = 0
    handler = $('.handler_div', @emt)
    $('.scroll_enabled', handler).off('click').on('click', (e) ->
      if $(@).is(':checked')
        $(@).closest('.scroll_enabled_wrapper').find('.scroll_forward:first').parent('label').show()
      else
        emt = $(@).closest('.scroll_enabled_wrapper').find('.scroll_forward:first')
        emt.parent('label').hide()
        emt.prop('checked', false)
    )

  _setForkSelect = ->
    self = 0
    handler = $('.handler_div', @emt)
    $('.enable_fork', handler).off('click').on('click', (e) ->
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
    $('.push.button.preview', @emt).off('click').on('click', (e) =>
      @clearError()
      # UIの入力値を初期化
      keepDispMag = $(e.target).closest('div').find('.keep_disp_mag').is(':checked')
      @preview(keepDispMag)
      $(e.target).closest('.button_div').find('.button_preview_wrapper').hide()
      $(e.target).closest('.button_div').find('.button_stop_preview_wrapper').show()
    )
    $('.push.button.apply', @emt).off('click').on('click', (e) =>
      @clearError()
      # 入力値を適用する
      if @applyAction()
        # 通知
        FloatView.show('Applied', FloatView.Type.INFO)
        # イベントを更新
        Timeline.refreshAllTimeline()
    )
    $('.push.button.stop_preview', @emt).off('click').on('click', (e) =>
      @clearError()
      Common.updateAllEventsToBefore( =>
        $(e.target).closest('.button_div').find('.button_preview_wrapper').show()
        $(e.target).closest('.button_div').find('.button_stop_preview_wrapper').hide()
      )
    )

  _setupFromPageValues = ->
    if @readFromPageValue()
      @selectItem()

  # 追加されたコンフィグを全て消去
  @removeAllConfig: ->
    $('#event-config').children('.event').remove()

  # アクションイベント情報をコンフィグに追加
  # @param [Integer] item_access_token アイテムID
  @addEventConfigContents = (item_access_token) ->
    itemClass = Common.getClassFromMap(false, item_access_token)

    if itemClass? && itemClass.actionProperties?
      className = EventConfig.ITEM_ACTION_CLASS.replace('@itemtoken', item_access_token)
      #handler_forms = $('#event-config .handler_div .configBox')
      action_forms = $('#event-config .action_forms')
      if action_forms.find(".#{className}").length == 0
        actionParent = $("<div class='#{className}' style='display:none'></div>")
        props = itemClass.actionProperties
        if !props?
          if window.debug
            console.log('Not declaration actionProperties')
          return

        # アクションメソッドConfig追加
        methodClone = $('#event-config .method_none_temp').children(':first').clone(true)
        methodClone.find('input[type=radio]').attr('name', className)
        actionParent.append(methodClone)
        methods = props[ItemBase.ActionPropertiesKey.METHODS]
        if methods?
          for methodName, prop of methods
            methodClone = $('#event-config .method_temp').children(':first').clone(true)
            span = methodClone.find('label:first').children('span:first')
            span.html(prop[ItemBase.ActionPropertiesKey.OPTIONS]['name'])
            methodClone.find('input.method_name:first').val(methodName)
            valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@itemtoken', item_access_token).replace('@methodname', methodName)
            methodClone.find('input[type=radio]').attr('name', className)
            methodClone.find('input.value_class_name:first').val(valueClassName)
            actionParent.append(methodClone)

        actionParent.appendTo(action_forms)

  # 変数編集コンフィグの初期化
  initEventVarModifyConfig: (objClass) ->
    if !objClass.actionProperties.methods[@[EventPageValueBase.PageValueKey.METHODNAME]]? ||
      !objClass.actionProperties.methods[@[EventPageValueBase.PageValueKey.METHODNAME]].modifiables?
        # メソッド or 変数編集無し
        return

    mod = objClass.actionProperties.methods[@[EventPageValueBase.PageValueKey.METHODNAME]].modifiables
    if mod?
      for varName, v of mod
        defaultValue = null
        if @hasModifiableVar(varName)
          defaultValue = @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
        else
          objClass = null
          if @[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]?
            objClass = Common.getClassFromMap(false, @[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN])
          else if @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]?
            objClass = Common.getClassFromMap(true, @[EventPageValueBase.PageValueKey.COMMON_EVENT_ID])
          defaultValue = objClass.actionProperties.modifiables[varName].default
        if v.type == Constant.ItemDesignOptionType.NUMBER
          @settingModifiableVarSlider(varName, defaultValue, v.min, v.max, v.stepValue)
        else if v.type == Constant.ItemDesignOptionType.STRING
          @settingModifiableString(varName, defaultValue)
        else if v.type == Constant.ItemDesignOptionType.COLOR
          @settingModifiableColor(varName, defaultValue)
        else if v.type == Constant.ItemDesignOptionType.SELECT
          @settingModifiableSelect(varName, defaultValue, v['options[]'])

  # 独自変数コンフィグの初期化
  initEventSpecificConfig: (objClass) ->
    if !objClass.actionProperties.methods[@[EventPageValueBase.PageValueKey.METHODNAME]]? ||
      !objClass.actionProperties.methods[@[EventPageValueBase.PageValueKey.METHODNAME]].specific?
        # メソッド or 変数編集無し
        return

    sp = objClass.actionProperties.methods[@[EventPageValueBase.PageValueKey.METHODNAME]].specific
    # 変数と同じクラス名のInputに設定(現状textのみ)
    for varName, v of sp
      e = @emt.find(".#{@methodClassName()} .#{EventConfig.METHOD_VALUE_SPECIFIC_ROOT} .#{varName}")
      if e.length > 0
        e.val(v)

    # FIXME: イベント必要であれば実装

  # 変数変更値が存在するか
  hasModifiableVar: (varName = null) ->
    ret = @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? != 'undefined'
    if varName?
      return ret && @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
    else
      return ret

  # 変数編集スライダーの作成
  # @param [Int] varName 変数名
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Int] stepValue 進捗数
  settingModifiableVarSlider: (varName, defaultValue, min = 0, max = 100, stepValue = 1) ->
    meterClassName = "#{varName}_meter"
    meterElement = $(".#{@methodClassName()} .#{EventConfig.METHOD_VALUE_MODIFY_ROOT} .#{meterClassName}", @emt)
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
          @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {}
        @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = ui.value
    })

  # 変数編集テキストボックスの作成
  # @param [String] varName 変数名
  settingModifiableString: (varName, defaultValue) ->
    $(".#{@methodClassName()} .#{EventConfig.METHOD_VALUE_MODIFY_ROOT} .#{varName}_text", @emt).val(defaultValue)
    $(".#{@methodClassName()} .#{EventConfig.METHOD_VALUE_MODIFY_ROOT} .#{varName}_text", @emt).off('change').on('change', =>
      if !@hasModifiableVar(varName)
        @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {}
      @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = $(@).val()
    )

  # 変数編集カラーピッカーの作成
  # @param [Object] configRoot コンフィグルート
  # @param [String] varName 変数名
  settingModifiableColor: (varName, defaultValue) ->
    emt = $(".#{@methodClassName()} .#{EventConfig.METHOD_VALUE_MODIFY_ROOT} .#{varName}_color", @emt)
    ColorPickerUtil.initColorPicker(
      $(emt),
      defaultValue,
      (a, b, d, e) =>
        if !@hasModifiableVar(varName)
          @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {}
        @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = "##{b}"
    )

  # 変数編集選択メニューの作成
  settingModifiableSelect: (varName, defaultValue, selectOptions) ->

    _joinArray = (value) ->
      if $.isArray(value)
        return value.join(',')
      else
        return value

    _splitArray = (value) ->
      if $.isArray(value)
        return value.split(',')
      else
        return value

    selectEmt = $(".#{@methodClassName()} .#{EventConfig.METHOD_VALUE_MODIFY_ROOT} .#{varName}_select", @emt)
    if selectEmt.children('option').length == 0
      # 選択項目の作成
      for option in selectOptions
        v = _joinArray.call(@, option)
        selectEmt.append("<option value='#{v}'>#{v}</option>")

    selectEmt.val(_joinArray.call(@, defaultValue))
    selectEmt.off('change').on('change', (e) =>
      if !@hasModifiableVar(varName)
        @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {}
      @[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = _splitArray.call(@, $(e.target).val())
    )

  # アイテム選択メニューを更新
  @updateSelectItemMenu = ->
    # 作成されたアイテムの一覧を取得
    teItemSelects = $('#event-config .te_item_select')
    teItemSelect = teItemSelects[0]
    selectOptions = ''
    items = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix())
    for k, item of items
      id = item.value.id
      name = item.value.name
      itemToken = item.value.itemToken
      if itemToken?
        selectOptions += """
            <option value='#{id}#{EventConfig.EVENT_ITEM_SEPERATOR}#{itemToken}'>
              #{name}
            </option>
          """

    itemOptgroupClassName = 'item_optgroup_class_name'
    selectOptions = "<optgroup class='#{itemOptgroupClassName}' label='#{I18n.t("config.select_opt_group.item")}'>" + selectOptions + '</optgroup>'
    # メニューを入れ替え
    teItemSelects.each( ->
      $(@).find(".#{itemOptgroupClassName}").remove()
      $(@).append($(selectOptions))
    )

  # イベントハンドラー設定
  # @param [Integer] distId イベント番号
  @setupTimelineEventHandler = (distId, teNum) ->
    eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId)
    emt = $('#' + eId)
    # Configクラス作成 & イベントハンドラの設定
    config = new @(emt, teNum, distId)
    # 変更を元に戻す
    config.clearAllChange()
    # UpdateEventAfterイベント初期化
    $('.update_event_after', emt).removeAttr('checked')
    $('.update_event_after', emt).off('change').on('change', (e) =>
      if $(e.target).is(':checked')
        # イベント後に変更
        $(e.target).attr('disabled', true)
        WorktableCommon.updatePrevEventsToAfter(teNum, =>
          $(e.target).removeAttr('disabled')
        )
      else
        # 全アイテム再描画
        $(e.target).attr('disabled', true)
        WorktableCommon.reDrawAllItemsFromInstancePageValueIfChanging(PageValue.getPageNum(), =>
          $(e.target).removeAttr('disabled')
        )
    )
    # 選択メニューイベント
    $('.te_item_select', emt).off('change').on('change', (e) ->
      config.clearError()
      config.selectItem(@)
    )
    window.drawingCanvas.one('click.setupTimelineEventHandler', (e) =>
      # メイン画面クリックで全アイテム再描画
      @reDrawAllItemsFromInstancePageValueIfChanging()
    )
