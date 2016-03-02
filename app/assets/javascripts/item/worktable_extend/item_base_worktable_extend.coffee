itemBaseWorktableExtend =
  # デザインコンフィグメニューの要素IDを取得
  # @return [String] HTML要素ID
  getDesignConfigId: ->
    return @constructor.DESIGN_CONFIG_ROOT_ID.replace('@id', @id)

  # マウスダウン時の描画イベント
  # @param [Array] loc Canvas座標
  mouseDownDrawing: (callback = null) ->
    @saveDrawingSurface()
    WorktableCommon.changeMode(constant.Mode.DRAW)
    @startDraw()
    if callback?
      callback()

  # マウスアップ時の描画イベント
  mouseUpDrawing: (zindex, callback = null) ->
    @restoreAllDrawingSurface()
    @endDraw(zindex, true, =>
      @setupItemEvents()
      WorktableCommon.changeMode(constant.Mode.DRAW)
      @saveObj(true)
      # フォーカス設定
      @firstFocus = Common.firstFocusItemObj() == null
      if callback?
        callback()
    )

  # ドラッグ描画開始
  startDraw: ->
    return

  # ドラッグ描画(枠)
  # @param [Array] cood 座標
  draw: (cood) ->
    if @itemSize != null
      @restoreRefreshingSurface(@itemSize)

    @itemSize = {x: null, y: null, w: null, h: null}
    @itemSize.w = Math.abs(cood.x - @_moveLoc.x);
    @itemSize.h = Math.abs(cood.y - @_moveLoc.y);
    if cood.x > @_moveLoc.x
      @itemSize.x = @_moveLoc.x
    else
      @itemSize.x = cood.x
    if cood.y > @_moveLoc.y
      @itemSize.y = @_moveLoc.y
    else
      @itemSize.y = cood.y
    drawingContext.strokeRect(@itemSize.x, @itemSize.y, @itemSize.w, @itemSize.h)

  # 描画終了
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true, callback = null) ->
    @zindex = zindex
    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()
    @createItemElement((createdElement) =>
      @itemDraw(show)
      if @setupItemEvents?
        # アイテムのイベント設定
        @setupItemEvents()
      if callback?
        callback()
    )

  # モード変更時処理
  # @abstract
  changeMode: (changeMode) ->

  # 描画&コンフィグ作成
  # @param [Boolean] show 要素作成後に描画を表示するか
  drawAndMakeConfigsAndWritePageValue: (show = true, callback = null) ->
    if window.runDebug
      console.log('ItemBase drawAndMakeConfigsAndWritePageValue')

    @drawAndMakeConfigs(show, =>
      if @constructor.defaultMethodName()?
        # デフォルトイベントがある場合はイベント作成
        # Blankのタイムラインを取得
        blank = $('#timeline_events > .timeline_event.blank:first')
        teNum = blank.find('.te_num').val()
        distId = blank.find('.dist_id').val()
        EPVItem.writeDefaultToPageValue(@, teNum, distId)
        # タイムライン更新
        #Timeline.refreshAllTimeline()
        Timeline.updateEvent(teNum)
      if callback?
        callback()
    )

  # 描画&コンフィグ作成
  # @param [boolean] show 要素作成後に描画を表示するか
  # @return [Boolean] 処理結果
  drawAndMakeConfigs: (show = true, callback = null) ->
    if window.runDebug
      console.log('ItemBase drawAndMakeConfigs')
    # アイテム描画
    @refresh(show)
    if callback?
      callback()

  # オプションメニューを開く
  showOptionMenu: ->
    # 全てのサイドバーを非表示
    sc = $('.sidebar-config')
    sc.hide()
    $(".#{constant.DesignConfig.ROOT_CLASSNAME}", sc).hide()
    $('#design-config').show()
    $('#' + @getDesignConfigId()).show()

  # コンテキストメニュー設定
  setupContextMenu: ->
    menu = []
    contextSelector = ".context_base"
    menu.push({
      title: I18n.t('context_menu.edit'), cmd: "edit", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # アイテム編集
        WorktableCommon.editItem(event.target.id)
    })
    menu.push({
      title: I18n.t('context_menu.copy'), cmd: "copy", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # コピー
        WorktableCommon.copyItem()
        WorktableCommon.setMainContainerContext()
    })
    menu.push({
      title: I18n.t('context_menu.cut'), cmd: "cut", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 切り取り
        WorktableCommon.cutItem()
        WorktableCommon.setMainContainerContext()
    })
    menu.push({
      title: I18n.t('context_menu.float'), cmd: "float", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 最前面移動
        objId = $(event.target).attr('id')
        WorktableCommon.floatItem(objId)
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        # 履歴保存
        OperationHistory.add()
    })
    menu.push({
      title: I18n.t('context_menu.rear'), cmd: "rear", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # 最背面移動
        objId = $(event.target).attr('id')
        WorktableCommon.rearItem(objId)
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        # 履歴保存
        OperationHistory.add()
    })
    menu.push({
      title: I18n.t('context_menu.delete'), cmd: "delete", uiIcon: "ui-icon-scissors", func: (event, ui) ->
        # アイテム削除
        if window.confirm(I18n.t('message.dialog.delete_item'))
          WorktableCommon.removeSingleItem(event.target)
    })
    WorktableCommon.setupContextMenu(@getJQueryElement(), contextSelector, menu)

  # アイテムに対してドラッグ&リサイズイベントを設定する
  setupDragAndResizeEvent: ->
    @getJQueryElement().draggable({
      containment: scrollInside
      drag: (event, ui) =>
        if @drag?
          @drag(ui.position)
      stop: (event, ui) =>
        if @dragComplete?
          @dragComplete()
    })
    @getJQueryElement().resizable({
      containment: scrollInside
      resize: (event, ui) =>
        if @resize?
          @resize(ui.size, ui.originalSize)
      stop: (event, ui) =>
        if @resizeComplete?
          @resizeComplete()
    })

  # クリックイベント設定
  setupClickEvent: ->
    @getJQueryElement().mousedown((e) ->
      if e.which == 1 #左クリック
        e.stopPropagation()
        WorktableCommon.clearSelectedBorder()
        WorktableCommon.setSelectedBorder(@, "edit")
    )

  # アイテムにイベントを設定する
  setupItemEvents: ->
    @setupContextMenu()
    @setupClickEvent()
    @setupDragAndResizeEvent()

  # ドラッグ中イベント
  drag: (position) ->
    scale = WorktableCommon.getWorktableViewScale()
    position.left /= scale
    position.top /= scale
    @updateItemPosition(position.left, position.top)
    if window.debug
      console.log("drag: position:")
      console.log(position)
      console.log("drag: itemSize: #{JSON.stringify(@itemSize)}")

  # リサイズ時のイベント
  resize: (size, originalSize) ->
    scale = WorktableCommon.getWorktableViewScale()
    diff = {
      width: (size.width - originalSize.width) / scale
      height: (size.height - originalSize.height) / scale
    }
    size.width = originalSize.width + diff.width
    size.height = originalSize.height + diff.height
    @updateItemSize(size.width, size.height)
    if window.debug
      console.log("resize: size:")
      console.log(size)
      console.log("resize: itemSize: #{JSON.stringify(@itemSize)}")

  # ドラッグ完了時イベント
  dragComplete: ->
    @saveObj()

  # リサイズ完了時イベント
  resizeComplete: ->
    @saveObj()


  # CSSボタンコントロール初期化
  setupOptionMenu: (callback = null) ->
    ConfigMenu.getDesignConfig(@, (designConfigRoot) =>
      # アイテム名の変更
      name = $('.item-name', designConfigRoot)
      name.val(@name)
      name.off('change').on('change', (e) =>
        @name = $(e.target).val()
        @setItemPropToPageValue('name', @name)
      )

      _existFocusSetItem = ->
        objs = Common.itemInstancesInPage()
        focusExist = false
        for obj in objs
          if obj.firstFocus? && obj.firstFocus
            focusExist = true
        return focusExist

      focusEmt = $('.focus_at_launch', designConfigRoot)
      # アイテム初期フォーカス
      if @firstFocus
        focusEmt.prop('checked', true)
      else
        focusEmt.removeAttr('checked')
      # ページ内に初期フォーカス設定されているアイテムが存在する場合はdisabled
      if !@firstFocus && _existFocusSetItem.call(@)
        focusEmt.removeAttr('checked')
        focusEmt.attr('disabled', true)
      else
        focusEmt.removeAttr('disabled')
      focusEmt.off('change').on('change', (e) =>
        @firstFocus = $(e.target).prop('checked')
        @saveObj()
      )

      visibleEmt = $('.visible_at_launch', designConfigRoot)
      # アイテム初期表示
      if @visible
        visibleEmt.prop('checked', true)
      else
        visibleEmt.removeAttr('checked')
        focusEmt.removeAttr('checked')
        focusEmt.attr('disabled', true)
      visibleEmt.off('change').on('change', (e) =>
        @visible = $(e.target).prop('checked')
        if @visible && !_existFocusSetItem.call(@)
          focusEmt.removeAttr('disabled')
        else
          focusEmt.removeAttr('checked')
          focusEmt.attr('disabled', true)
        focusEmt.trigger('change')
        @saveObj()
      )

      # アイテム位置の変更
      p = Common.calcItemCenterPositionInWorktable(@itemSize)
      $('.item_position_x:first', designConfigRoot).val(p.left)
      $('.item_position_y:first', designConfigRoot).val(p.top)
      $('.item_width:first', designConfigRoot).val(@itemSize.w)
      $('.item_height:first', designConfigRoot).val(@itemSize.h)
      $('.item_position_x:first, .item_position_y:first, .item_width:first, .item_height:first', designConfigRoot).off('change').on('change', =>
        centerPosition = {x: $('.item_position_x:first', designConfigRoot).val(), y: $('.item_position_y:first', designConfigRoot).val()}
        w = parseInt($('.item_width:first', designConfigRoot).val())
        h = parseInt($('.item_height:first', designConfigRoot).val())
        p = Common.calcItemScrollContentsPosition(centerPosition, w, h)
        itemSize = {
          x: parseInt(p.left)
          y: parseInt(p.top)
          w: w
          h: h
        }
        @updatePositionAndItemSize(itemSize, true, true)
      )

      # デザインコンフィグ
      if @constructor.actionProperties.designConfig? && @constructor.actionProperties.designConfig
        @setupDesignToolOptionMenu()

      # 変数編集コンフィグ
      @settingModifiableChangeEvent()

      if callback?
        callback()
    )

  # デザインスライダーの作成
  # @param [Int] id メーターのElementID
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Int] stepValue 進捗数
  settingDesignSlider: (className, min, max, stepValue = 1) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    meterElement = $(".#{className}", designConfigRoot)
    valueElement = meterElement.prev('input:first')
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
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
        classNames = $(event.target).attr('class').split(' ')
        n = $.grep(classNames, (s) -> s.indexOf('design_') >= 0)[0]
        @designs.values["#{n}_value"] = ui.value
        @applyDesignStyleChange(n, ui.value)
    })

  # HTML要素からグラデーションスライダーの作成
  # @param [Object] element HTML要素
  # @param [Array] values 値の配列
  settingGradientSliderByElement: (element, values) ->
    try
      element.slider('destroy')
    catch #例外は握りつぶす
    element.slider({
      # 0%と100%は含まない
      min: 1
      max: 99
      values: values
      slide: (event, ui) =>
        index = $(ui.handle).index()
        classNames = $(event.target).attr('class').split(' ')
        n = $.grep(classNames, (s) -> s.indexOf('design_') >= 0)[0]
        @designs.values["design_bg_color#{index + 2}_position_value"] = ("0" + ui.value).slice(-2)
        @applyGradientStyleChange(index, n, ui.value)
    })

    handleElement = element.children('.ui-slider-handle')
    if values == null
      handleElement.hide()
    else
      handleElement.show()

  # グラデーションスライダーの作成
  # @param [Int] id HTML要素のID
  # @param [Array] values 値の配列
  settingGradientSlider: (className, values) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    meterElement = $(".#{className}", designConfigRoot)
    @settingGradientSliderByElement(meterElement, values)

  # グラデーション方向スライダーの作成
  # @param [Int] id メーターのElementID
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  settingGradientDegSlider: (className, min, max, each45Degrees = true) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    meterElement = $('.' + className, designConfigRoot)
    valueElement = $('.' + className + '_value', designConfigRoot)
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
    valueElement.val(defaultValue)
    valueElement.html(defaultValue)
    step = 1
    if each45Degrees
      step = 45

    try
      meterElement.slider('destroy')
    catch #例外は握りつぶす
    meterElement.slider({
      min: min,
      max: max,
      step: step,
      value: defaultValue
      slide: (event, ui) =>
        valueElement.val(ui.value)
        valueElement.html(ui.value)
        classNames = $(event.target).attr('class').split(' ')
        n = $.grep(classNames, (s) -> s.indexOf('design_') >= 0)[0]
        @designs.values["#{n}_value"] = ui.value
        @applyGradientDegChange(n, ui.value)
    })

  # グラデーションの表示変更(スライダーのハンドル&カラーピッカー)
  # @param [Object] element HTML要素
  changeGradientShow: (targetElement) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    value = parseInt(targetElement.value)
    if value >= 2 && value <= 5
      meterElement = $(targetElement).siblings('.ui-slider:first')
      values = null
      if value == 3
        values = [50]
      else if value == 4
        values = [30, 70]
      else if value == 5
        values = [25, 50, 75]

      @settingGradientSliderByElement(meterElement, values)
      @switchGradientColorSelectorVisible(value, designConfigRoot)

  # グラデーションのカラーピッカー表示切り替え
  # @param [Int] gradientStepValue 現在のグラデーション数
  switchGradientColorSelectorVisible: (gradientStepValue) ->
    designConfigRoot = $('#' + @getDesignConfigId())
    for i in [2 .. 4]
      element = $('.design_bg_color' + i, designConfigRoot)
      if i > gradientStepValue - 1
        element.hide()
      else
        element.show()

  # デザイン更新処理
  saveDesign: ->
    if @saveDesignReflectTimer?
      clearTimeout(@saveDesignReflectTimer)
      @saveDesignReflectTimer = null
    @saveDesignReflectTimer = setTimeout(=>
      # 0.5秒後に反映
      # ページに状態を保存
      @setItemAllPropToPageValue()
      # キャッシュに保存
      LocalStorage.saveAllPageValues()
      @saveDesignReflectTimer = setTimeout(->
        # 1秒後に操作履歴に保存
        OperationHistory.add()
      , 1000)
    , 500)

  # 変数編集イベント設定
  settingModifiableChangeEvent: ->
    designConfigRoot = $('#' + @getDesignConfigId())
    if @constructor.actionPropertiesModifiableVars()?
      for varName, value of @constructor.actionPropertiesModifiableVars()
        if value.type == constant.ItemDesignOptionType.NUMBER
          @settingModifiableVarSlider(designConfigRoot, varName, value[@constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE], value.min, value.max, value.stepValue)
        else if value.type == constant.ItemDesignOptionType.STRING
          @settingModifiableString(designConfigRoot, varName, value[@constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE])
        else if value.type == constant.ItemDesignOptionType.BOOLEAN
          @settingModifiableCheckbox(designConfigRoot, varName, value[@constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE])
        else if value.type == constant.ItemDesignOptionType.COLOR
          @settingModifiableColor(designConfigRoot, varName, value[@constructor.ActionPropertiesKey.COLOR_TYPE], value[@constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE])
        else if value.type == constant.ItemDesignOptionType.SELECT_FILE
          @settingModifiableSelectFile(designConfigRoot, varName)
        else if value.type == constant.ItemDesignOptionType.SELECT_IMAGE_FILE
          @settingModifiableSelectImageFile(designConfigRoot, varName)
        else if value.type == constant.ItemDesignOptionType.SELECT
          @settingModifiableSelect(designConfigRoot, varName, value[@constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE], value['options[]'])

  # 変数編集スライダーの作成
  # @param [Object] configRoot コンフィグルート
  # @param [String] varName 変数名
  # @param [Int] min 最小値
  # @param [Int] max 最大値
  # @param [Int] stepValue 進捗数
  settingModifiableVarSlider: (configRoot, varName, openChildrenValue, min = 0, max = 100, stepValue = 1) ->
    meterElement = $(".#{varName}_meter", configRoot)
    valueElement = meterElement.prev('input:first')
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
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
        value = ui.value
        valueElement.val(value)
        valueElement.html(value)
        @changeInstanceVarByConfig(varName, value)
        @constructor.switchChildrenConfig(event.target, varName, openChildrenValue, value)
        @applyDesignChange()
    }).trigger('slide')

  # 変数編集テキストボックスの作成
  # @param [Object] configRoot コンフィグルート
  # @param [String] varName 変数名
  settingModifiableString: (configRoot, varName, openChildrenValue) ->
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
    $(".#{varName}_text", configRoot).val(defaultValue)
    $(".#{varName}_text", configRoot).off('change').on('change', (e) =>
      value = $(e.target).val()
      @changeInstanceVarByConfig(varName, value)
      @constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value)
      @applyDesignChange()
    ).trigger('change')

  # 変数編集テキストボックスの作成
  # @param [Object] configRoot コンフィグルート
  # @param [String] varName 変数名
  settingModifiableCheckbox: (configRoot, varName, openChildrenValue) ->
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
    if defaultValue
      $(".#{varName}_checkbox", configRoot).attr('checked', true)
    else
      $(".#{varName}_checkbox", configRoot).removeAttr('checked')

    $(".#{varName}_checkbox", configRoot).off('change').on('change', (e) =>
      value = $(e.target).is(':checked')
      @changeInstanceVarByConfig(varName, value)
      @constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value)
      @applyDesignChange()
    ).trigger('change')

  # 変数編集カラーピッカーの作成
  # @param [Object] configRoot コンフィグルート
  # @param [String] varName 変数名
  settingModifiableColor: (configRoot, varName, colorType, openChildrenValue) ->
    emt = $(".#{varName}_color", configRoot)
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
    ColorPickerUtil.initColorPicker(
      $(emt),
      defaultValue,
      (a, b, d, e) =>
        value = "##{b}"
        if colorType? && colorType == 'rgb'
          value = Common.colorFormatChangeHexToRgb(value)
        @changeInstanceVarByConfig(varName, value)
        @constructor.switchChildrenConfig(emt, varName, openChildrenValue, value)
        @applyDesignChange()
    )
    @constructor.switchChildrenConfig(emt, varName, openChildrenValue, defaultValue)

  # 変数編集ファイルアップロードの作成 FIXME
  # @param [Object] configRoot コンフィグルート
  # @param [String] varName 変数名
  settingModifiableSelectFile: (configRoot, varName) ->
    form = $("form.item_image_form_#{varName}", configRoot)
    @initModifiableSelectFile(form)
    form.off().on('ajax:complete', (e, data, status, error) =>
      d = JSON.parse(data.responseText)
      @changeInstanceVarByConfig(varName, d.image_url)
      @saveObj()
      @applyDesignChange()
    )

  # 変数編集画像ファイルアップロードの作成
  # @param [Object] configRoot コンフィグルート
  # @param [String] varName 変数名
  settingModifiableSelectImageFile: (configRoot, varName) ->
    form = $("form.item_image_form_#{varName}", configRoot)
    @initModifiableSelectImageFile(form)
    form.off().on('ajax:complete', (e, data, status, error) =>
      d = JSON.parse(data.responseText)
      @changeInstanceVarByConfig(varName, d.image_url)
      @initModifiableSelectImageFile(e.target)
      $(e.target).find(".#{@constructor.ImageKey.SELECT_FILE}:first").trigger('change')
      $(e.target).find(".#{@constructor.ImageKey.URL}:first").trigger('change')
      @saveObj()
      @applyDesignChange()
    )

  # 変数編集選択メニューの作成
  settingModifiableSelect: (configRoot, varName, openChildrenValue, selectOptions) ->
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

    selectEmt = $(".#{varName}_select", configRoot)
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
    if defaultValue?
      selectEmt.val(_joinArray.call(@, defaultValue))
    selectEmt.off('change').on('change', (e) =>
      value = _splitArray.call(@, $(e.target).val())
      if value.match(/^-?[0-9]+\.[0-9]+$/)
        # 小数
        value = parseFloat(value)
      else if value.match(/^-?[0-9]+$/)
        # 整数
        value = parseInt(value)
      @changeInstanceVarByConfig(varName, value)
      @constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value)
      @applyDesignChange()
    ).trigger('change')

  # 変数編集ファイルアップロードのイベント初期化
  initModifiableSelectFile: (emt) ->
    $(emt).find(".#{@constructor.ImageKey.PROJECT_ID}").val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID))
    $(emt).find(".#{@constructor.ImageKey.ITEM_OBJ_ID}").val(@id)
    $(emt).find(".#{@constructor.ImageKey.SELECT_FILE}:first").off().on('change', (e) =>
      target = e.target
      if target.value && target.value.length > 0
        # 選択時
        # Deleteボタン表示
        del = $(emt).find(".#{@constructor.ImageKey.SELECT_FILE_DELETE}:first")
        del.off('click').on('click', ->
          $(target).val('')
          $(target).trigger('change')
        )
        del.show()
      else
        # 未選択
        # Deleteボタン表示
        $(emt).find(".#{@constructor.ImageKey.SELECT_FILE_DELETE}:first").hide()
    )

  # 変数編集画像ファイルアップロードのイベント初期化
  initModifiableSelectImageFile: (emt) ->
    $(emt).find(".#{@constructor.ImageKey.PROJECT_ID}").val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID))
    $(emt).find(".#{@constructor.ImageKey.ITEM_OBJ_ID}").val(@id)
    $(emt).find(".#{@constructor.ImageKey.SELECT_FILE}:first").off('change').on('change', (e) =>
      target = e.target
      if target.value && target.value.length > 0
        # 選択時
        # URL入力を無効 & Deleteボタン表示
        el = $(emt).find(".#{@constructor.ImageKey.URL}:first")
        el.attr('disabled', true)
        el.css('backgroundColor', 'gray')
        del = $(emt).find(".#{@constructor.ImageKey.SELECT_FILE_DELETE}:first")
        del.off('click').on('click', ->
          $(target).val('')
          $(target).trigger('change')
        )
        del.parent('div').show()
      else
        # 未選択
        # URL入力を有効 & Deleteボタン非表示
        el = $(emt).find(".#{@constructor.ImageKey.URL}:first")
        el.removeAttr('disabled')
        el.css('backgroundColor', 'white')
        $(emt).find(".#{@constructor.ImageKey.SELECT_FILE_DELETE}:first").parent('div').hide()
    )
    $(emt).find(".#{@constructor.ImageKey.URL}:first").off('change').on('change', (e) =>
      target = e.target
      if $(target).val().length > 0
        # 入力時
        # ファイル選択を無効
        $(emt).find(".#{@constructor.ImageKey.SELECT_FILE}:first").attr('disabled', true)
      else
        # 未入力時
        # ファイル選択を有効
        $(emt).find(".#{@constructor.ImageKey.SELECT_FILE}:first").removeAttr('disabled')
    )