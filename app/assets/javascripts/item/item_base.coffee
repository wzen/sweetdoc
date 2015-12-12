# アイテム基底
# @abstract
class ItemBase extends ItemEventBase
  # @abstract
  # @property [String] NAME_PREFIX 名前プレフィックス
  @NAME_PREFIX = ""
  # @abstract
  # @property [ItemType] ITEM_ACCESS_TOKEN アイテム種別
  @ITEM_ACCESS_TOKEN = ""
  # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
  @DESIGN_CONFIG_ROOT_ID = 'design_config_@id'
  # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
  @DESIGN_PAGEVALUE_ROOT = 'designs'

  if gon?
    constant = gon.const

    class @ActionPropertiesKey
      @METHODS = constant.ItemActionPropertiesKey.METHODS
      @DEFAULT_EVENT = constant.ItemActionPropertiesKey.DEFAULT_EVENT
      @METHOD = constant.ItemActionPropertiesKey.METHOD
      @DEFAULT_METHOD = constant.ItemActionPropertiesKey.DEFAULT_METHOD
      @ACTION_TYPE = constant.ItemActionPropertiesKey.ACTION_TYPE
      @SCROLL_ENABLED_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_ENABLED_DIRECTION
      @SCROLL_FORWARD_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_FORWARD_DIRECTION
      @OPTIONS = constant.ItemActionPropertiesKey.OPTIONS
      @EVENT_DURATION = constant.ItemActionPropertiesKey.EVENT_DURATION

    class @ImageKey
      @PROJECT_ID = constant.PreloadItemImage.Key.PROJECT_ID
      @ITEM_OBJ_ID = constant.PreloadItemImage.Key.ITEM_OBJ_ID
      @EVENT_DIST_ID = constant.PreloadItemImage.Key.EVENT_DIST_ID
      @SELECT_FILE = constant.PreloadItemImage.Key.SELECT_FILE
      @URL = constant.PreloadItemImage.Key.URL
      @SELECT_FILE_DELETE = constant.PreloadItemImage.Key.SELECT_FILE_DELETE


  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->
    super()
    # @property [Int] id ID
    @id = "i" + @constructor.NAME_PREFIX + Common.generateId()
    # @property [ItemType] ITEM_ACCESS_TOKEN アイテム種別
    @itemToken = @constructor.ITEM_ACCESS_TOKEN
    # @property [String] name 名前
    @name = null
    # @property [String] visible 表示状態
    @visible = false
    # @property [String] firstFocus 初期フォーカス
    @firstFocus = Common.firstFocusItemObj() == null
    # @property [Object] _drawingSurfaceImageData 画面を保存する変数
    @_drawingSurfaceImageData = null
    if cood != null
      # @property [Array] _mousedownCood 初期座標
      @_mousedownCood = {x:cood.x, y:cood.y}
    # @property [Array] itemSize サイズ
    @itemSize = null
    # @property [Int] zIndex z-index
    @zindex = Constant.Zindex.EVENTBOTTOM + 1
    # @property [Array] _ohiRegist 操作履歴Index保存配列
    @_ohiRegist = []
    # @property [Int] _ohiRegistIndex 操作履歴Index保存配列のインデックス
    @_ohiRegistIndex = 0
    # @property [Array] coodRegist ドラッグ座標
    @coodRegist = []

  # アイテムのJQuery要素を取得
  # @return [Object] JQuery要素
  getJQueryElement: ->
    return $('#' + @id)

  # アイテム用のテンプレートHTMLを読み込み
  # @abstract
  # @return [String] HTML
  createItemElement: (callback) ->

  # 画面を保存(全画面)
  saveDrawingSurface : ->
    @_drawingSurfaceImageData = drawingContext.getImageData(0, 0, drawingCanvas.width, drawingCanvas.height)

  # 保存した画面を全画面に再設定
  restoreAllDrawingSurface : ->
    window.drawingContext.putImageData(@_drawingSurfaceImageData, 0, 0)

  # 保存した画面を指定したサイズで再設定
  # @param [Array] size サイズ
  restoreDrawingSurface : (size) ->
    # ボタンのLadderBand用にpaddingを付ける
    padding = 5
    window.drawingContext.putImageData(@_drawingSurfaceImageData, 0, 0, size.x - padding, size.y - padding, size.w + (padding * 2), size.h + (padding * 2))

  # インスタンス変数で描画
  # データから読み込んで描画する処理に使用
  # @param [Boolean] show 要素作成後に表示するか
  # @param [Function] callback コールバック
  reDraw: (show = true, callback = null) ->
    if callback?
      callback()

  # 描画削除
  clearDraw: ->
    @getJQueryElement().remove()

  # CSSに反映
  applyDesignChange: (doStyleSave = true) ->
    @reDraw()
    if doStyleSave
      @saveDesign()

  # インスタンス変数で描画
  # データから読み込んで描画する処理に使用
  # @param [Boolean] show 要素作成後に表示するか
  reDrawWithEventBefore: (show = true) ->
    # インスタンス値初期化
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    if obj
      @setMiniumObject(obj)
    @reDraw(show)

  # アイテムの情報をアイテムリストと操作履歴に保存
  # @param [Boolean] newCreated 新規作成か
  saveObj: (newCreated = false) ->
    if newCreated
      # 名前を付与
      num = 0
      self = @
      for k, v of Common.getCreatedItemInstances()
        if self.constructor.NAME_PREFIX == v.constructor.NAME_PREFIX
          num += 1
      @name = @constructor.NAME_PREFIX + " #{num}"

    # ページに状態を保存
    @setItemAllPropToPageValue()
    # キャッシュに保存
    LocalStorage.saveAllPageValues()
    # 操作履歴に保存
    OperationHistory.add()
    if window.debug
      console.log('save obj')

    # イベントの選択項目更新
    # fixme: 実行場所について再考
    EventConfig.updateSelectItemMenu()

  # アイテムの情報をページ値から取得
  # @property [String] prop 変数名
  # @property [Boolean] isCache キャッシュとして保存するか
  getItemPropFromPageValue : (prop, isCache = false) ->
    prefix_key = if isCache then PageValue.Key.instanceValueCache(@id) else PageValue.Key.instanceValue(@id)
    return PageValue.getInstancePageValue(prefix_key + ":#{prop}")

  # アイテムの情報をページ値に設定
  # @property [String] prop 変数名
  # @property [Object] value 値
  # @property [Boolean] isCache キャッシュとして保存するか
  setItemPropToPageValue : (prop, value, isCache = false) ->
    prefix_key = if isCache then PageValue.Key.instanceValueCache(@id) else PageValue.Key.instanceValue(@id)
    PageValue.setInstancePageValue(prefix_key + ":#{prop}", value)
    LocalStorage.saveInstancePageValue()

  # アニメーション変更前のアイテムサイズ
  originalItemElementSize: ->
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(@event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    $.extend(true, obj, diff)
    return obj.itemSize

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    @getJQueryElement().css({width: w, height: h})
    @itemSize.w = parseInt(w)
    @itemSize.h = parseInt(h)

  # イベントによって設定したスタイルをクリアする
  clearAllEventStyle: ->
    return

  # アイテム作成時に設定されるデフォルトメソッド名
  @defaultMethodName = ->
    return @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.METHOD]

  # アイテム作成時に設定されるデフォルトアクションタイプ
  @defaultActionType = ->
    return Common.getActionTypeByCodingActionType(@actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.ACTION_TYPE])

  @defaultEventConfigValue = ->
    return null

  # スクロールのデフォルト有効方向
  @defaultScrollEnabledDirection = ->
    return @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.SCROLL_ENABLED_DIRECTION]

  # スクロールのデフォルト進行方向
  @defaultScrollForwardDirection = ->
    return @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.SCROLL_FORWARD_DIRECTION]

  # クリックのデフォルト時間
  @defaultClickDuration = ->
    return @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.EVENT_DURATION]

  # デフォルトデザインをPageValue & 変数に適用
  applyDefaultDesign: ->
    # デザイン用のPageValue作成
    if @constructor.actionProperties.designConfigDefaultValues?
      PageValue.setInstancePageValue(PageValue.Key.instanceDesignRoot(@id), @constructor.actionProperties.designConfigDefaultValues)
    @designs = PageValue.getInstancePageValue(PageValue.Key.instanceDesignRoot(@id))

  # アイテム位置&サイズを更新
  updatePositionAndItemSize: (itemSize, withSaveObj = true) ->
    @updateItemPosition(itemSize.x, itemSize.y)
    @updateItemSize(itemSize.w, itemSize.h)
    if withSaveObj
      @saveObj()

  updateItemPosition: (x, y) ->
    @getJQueryElement().css({top: y, left: x})
    @itemSize.x = parseInt(x)
    @itemSize.y = parseInt(y)

  # スクロールによるアイテム状態更新
  updateInstanceParamByStep: (stepValue, immediate = false)->
    super(stepValue, immediate)
    @updateItemSizeByStep(stepValue, immediate)

  # クリックによるアイテム状態更新
  updateInstanceParamByAnimation: (immediate = false) ->
    super(immediate)
    @updateItemSizeByAnimation()

  # スクロールイベントでアイテム位置&サイズ更新
  updateItemSizeByStep: (scrollValue, immediate = false) ->
    itemDiff = @event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF]
    if !itemDiff? || itemDiff == 'undefined'
      # 変更なしの場合
      return
    if itemDiff.x == 0 && itemDiff.y == 0 && itemDiff.w == 0 && itemDiff.h == 0
      # 変更なしの場合
      return

    originalItemElementSize = @originalItemElementSize()
    if immediate
      itemSize = {
        x: originalItemElementSize.x + itemDiff.x
        y: originalItemElementSize.y + itemDiff.y
        w: originalItemElementSize.w + itemDiff.w
        h: originalItemElementSize.h + itemDiff.h
      }
      @updatePositionAndItemSize(itemSize, false)
      return

    scrollEnd = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])
    scrollStart = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
    progressPercentage = scrollValue / (scrollEnd - scrollStart)
    itemSize = {
      x: originalItemElementSize.x + (itemDiff.x * progressPercentage)
      y: originalItemElementSize.y + (itemDiff.y * progressPercentage)
      w: originalItemElementSize.w + (itemDiff.w * progressPercentage)
      h: originalItemElementSize.h + (itemDiff.h * progressPercentage)
    }
    @updatePositionAndItemSize(itemSize, false)

  # クリックイベントでアイテム位置&サイズ更新
  updateItemSizeByAnimation: (immediate = false) ->
    itemDiff = @event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF]
    if !itemDiff? || itemDiff == 'undefined'
      # 変更なしの場合
      return
    if itemDiff.x == 0 && itemDiff.y == 0 && itemDiff.w == 0 && itemDiff.h == 0
      # 変更なしの場合
      return

    originalItemElementSize = @originalItemElementSize()
    if immediate
      itemSize = {
        x: originalItemElementSize.x + itemDiff.x
        y: originalItemElementSize.y + itemDiff.y
        w: originalItemElementSize.w + itemDiff.w
        h: originalItemElementSize.h + itemDiff.h
      }
      @updatePositionAndItemSize(itemSize, false)
      return

    eventDuration = @event[EventPageValueBase.PageValueKey.EVENT_DURATION]
    duration = 0.01
    perX = itemDiff.x * (duration / eventDuration)
    perY = itemDiff.y * (duration / eventDuration)
    perW = itemDiff.w * (duration / eventDuration)
    perH = itemDiff.h * (duration / eventDuration)
    loopMax = Math.ceil(eventDuration/ duration)
    count = 1
    timer = setInterval( =>
      itemSize = {
        x: originalItemElementSize.x + (perX * count)
        y: originalItemElementSize.y + (perY * count)
        w: originalItemElementSize.w + (perW * count)
        h: originalItemElementSize.h + (perH * count)
      }
      @updatePositionAndItemSize(itemSize, false)
      if count >= loopMax
        clearInterval(timer)
        itemSize = {
          x: originalItemElementSize.x + itemDiff.x
          y: originalItemElementSize.y + itemDiff.y
          w: originalItemElementSize.w + itemDiff.w
          h: originalItemElementSize.h + itemDiff.h
        }
        @updatePositionAndItemSize(itemSize, false)
      count += 1
    , duration * 1000)

  if window.isWorkTable
    @include({
      # デザインコンフィグメニューの要素IDを取得
      # @return [String] HTML要素ID
      getDesignConfigId: ->
        return @constructor.DESIGN_CONFIG_ROOT_ID.replace('@id', @id)

      # ドラッグ描画開始
      startDraw: ->
        return

      # 描画終了
      # @param [Int] zindex z-index
      # @param [boolean] show 要素作成後に描画を表示するか
      endDraw: (zindex, show = true, callback = null) ->
        @zindex = zindex
        # スクロールビュー分のxとyを追加
        @itemSize.x += scrollContents.scrollLeft()
        @itemSize.y += scrollContents.scrollTop()
        @createItemElement(true, (createdElement) =>
          $(createdElement).appendTo(window.scrollInside)
          if !show
            @getJQueryElement().css('opacity', 0)
          if @setupDragAndResizeEvents?
            # ドラッグ & リサイズイベント設定
            @setupDragAndResizeEvents()
          if callback?
            callback()
        )

      # ドラッグ描画(枠)
      # @param [Array] cood 座標
      draw: (cood) ->
        if @itemSize != null
          @restoreDrawingSurface(@itemSize)

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

      # 描画&コンフィグ作成
      # @param [Boolean] show 要素作成後に描画を表示するか
      drawAndMakeConfigsAndWritePageValue: (show = true, callback = null) ->
        @drawAndMakeConfigs(show, =>
          if @constructor.defaultMethodName()?
            # デフォルトイベントがある場合はイベント作成
            # Blankのタイムラインを取得
            blank = $('#timeline_events > .timeline_event.blank:first')
            teNum = blank.find('.te_num').val()
            distId = blank.find('.dist_id').val()
            EPVItem.writeDefaultToPageValue(@, teNum, distId)
            # タイムライン更新
            Timeline.refreshAllTimeline()
          if callback?
            callback()
        )

      # 描画&コンフィグ作成
      # @param [boolean] show 要素作成後に描画を表示するか
      # @return [Boolean] 処理結果
      drawAndMakeConfigs: (show = true, callback = null) ->
        # ボタン設置
        @reDraw(show)
        # コンフィグ作成
        ConfigMenu.getDesignConfig(@, ->
          if callback?
            callback()
        )

      # オプションメニューを開く
      showOptionMenu: ->
        # 全てのサイドバーを非表示
        sc = $('.sidebar-config')
        sc.hide()
        $(".#{Constant.DesignConfig.DESIGN_ROOT_CLASSNAME}", sc).hide()
        $('#design-config').show()
        $('#' + @getDesignConfigId()).show()

      # アイテムに対してドラッグ&リサイズイベントを設定する
      setupDragAndResizeEvents: ->
        self = @
        # コンテキストメニュー設定
        do ->
          menu = []
          contextSelector = ".context_base"
          menu.push({
            title: "Edit", cmd: "edit", uiIcon: "ui-icon-scissors", func: (event, ui) ->
              # アイテム編集
              Sidebar.openItemEditConfig(event.target)
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
                WorktableCommon.removeItem(event.target)
          })
          WorktableCommon.setupContextMenu(self.getJQueryElement(), contextSelector, menu)

        # クリックイベント設定
        do ->
          self.getJQueryElement().mousedown((e)->
            if e.which == 1 #左クリック
              e.stopPropagation()
              WorktableCommon.clearSelectedBorder()
              WorktableCommon.setSelectedBorder(@, "edit")
          )

        # JQueryUIのドラッグイベントとリサイズ設定
        do ->
          self.getJQueryElement().draggable({
            containment: scrollInside
            drag: (event, ui) ->
              if self.drag?
                self.drag()
            stop: (event, ui) ->
              if self.dragComplete?
                self.dragComplete()
          })
          self.getJQueryElement().resizable({
            containment: scrollInside
            resize: (event, ui) ->
              if self.resize?
                self.resize()
            stop: (event, ui) ->
              if self.resizeComplete?
                self.resizeComplete()
          })

      # ドラッグ中イベント
      drag: ->
        element = $('#' + @id)
        @updateItemPosition(element.position().left, element.position().top)
        if window.debug
          console.log("drag: itemSize: #{JSON.stringify(@itemSize)}")

      # リサイズ時のイベント
      resize: ->
        element = $('#' + @id)
        @updateItemSize(element.width(), element.height())

      # ドラッグ完了時イベント
      dragComplete: ->
        @saveObj()

      # リサイズ完了時イベント
      resizeComplete: ->
        @saveObj()


      # CSSボタンコントロール初期化
      setupOptionMenu: ->
        ConfigMenu.getDesignConfig(@, (designConfigRoot) =>
          # アイテム名の変更
          name = $('.item-name', designConfigRoot)
          name.val(@name)
          name.off('change').on('change', =>
            @name = $(@).val()
            @setItemPropToPageValue('name', @name)
          )

          _existFocusSetItem = ->
            focusExist = false
            instances = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix())
            for k, instance of instances
              obj = window.instanceMap[instance.value.id]
              if obj? && obj.firstFocus? && obj.firstFocus
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
          x = @getJQueryElement().position().left
          y = @getJQueryElement().position().top
          w = @getJQueryElement().width()
          h = @getJQueryElement().height()
          $('.item_position_x:first', designConfigRoot).val(x)
          $('.item_position_y:first', designConfigRoot).val(y)
          $('.item_width:first', designConfigRoot).val(w)
          $('.item_height:first', designConfigRoot).val(h)
          $('.item_position_x:first, .item_position_y:first, .item_width:first, .item_height:first', designConfigRoot).off('change').on('change', =>
            itemSize = {
              x: parseInt($('.item_position_x:first', designConfigRoot).val())
              y: parseInt($('.item_position_y:first', designConfigRoot).val())
              w: parseInt($('.item_width:first', designConfigRoot).val())
              h: parseInt($('.item_height:first', designConfigRoot).val())
            }
            @updatePositionAndItemSize(itemSize)
          )

          # デザインコンフィグ
          if @constructor.actionProperties.designConfig? && @constructor.actionProperties.designConfig
            @setupDesignToolOptionMenu()

          # 変数編集コンフィグ
          @settingModifiableChangeEvent()
        )

      # デザインスライダーの作成
      # @param [Int] id メーターのElementID
      # @param [Int] min 最小値
      # @param [Int] max 最大値
      # @param [Int] stepValue 進捗数
      settingDesignSlider: (className, min, max, stepValue = 0) ->
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
        if @constructor.actionProperties.modifiables?
          for varName, value of @constructor.actionProperties.modifiables
            if value.type == Constant.ItemDesignOptionType.NUMBER
              @settingModifiableVarSlider(designConfigRoot, varName, value.min, value.max)
            else if value.type == Constant.ItemDesignOptionType.STRING
              @settingModifiableString(designConfigRoot, varName)
            else if value.type == Constant.ItemDesignOptionType.COLOR
              @settingModifiableColor(designConfigRoot, varName)
            else if value.type == Constant.ItemDesignOptionType.SELECT_FILE
              @settingModifiableSelectFile(designConfigRoot, varName)
            else if v.type == Constant.ItemDesignOptionType.SELECT
              @settingModifiableSelect(designConfigRoot, varName, value.options)

      # 変数編集スライダーの作成
      # @param [Object] configRoot コンフィグルート
      # @param [String] varName 変数名
      # @param [Int] min 最小値
      # @param [Int] max 最大値
      # @param [Int] stepValue 進捗数
      settingModifiableVarSlider: (configRoot, varName, min = 0, max = 100, stepValue = 0) ->
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
            valueElement.val(ui.value)
            valueElement.html(ui.value)
            @[varName] = ui.value
            @applyDesignChange()
        })

      # 変数編集テキストボックスの作成
      # @param [Object] configRoot コンフィグルート
      # @param [String] varName 変数名
      settingModifiableString: (configRoot, varName) ->
        defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
        $(".#{varName}_text", configRoot).val(defaultValue)
        $(".#{varName}_text", configRoot).off('change').on('change', =>
          @[varName] = $(@).val()
          @applyDesignChange()
        )

      # 変数編集カラーピッカーの作成
      # @param [Object] configRoot コンフィグルート
      # @param [String] varName 変数名
      settingModifiableColor: (configRoot, varName) ->
        emt = $(".#{varName}_color", configRoot)
        defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
        ColorPickerUtil.initColorPicker(
          $(emt),
          defaultValue,
          (a, b, d, e) =>
            @[varName] = "##{b}"
            @applyDesignChange()
        )

      # 変数編集ファイルアップロードの作成
      # @param [Object] configRoot コンフィグルート
      # @param [String] varName 変数名
      settingModifiableSelectFile: (configRoot, varName) ->
        form = $("form.item_image_form_#{varName}", configRoot)
        @initModifiableSelectFile(form)
        form.off().on('ajax:complete', (e, data, status, error) =>
          d = JSON.parse(data.responseText)
          @[varName] = d.image_url
          @saveObj()
          @applyDesignChange()
        )

      # 変数編集選択メニューの作成
      settingModifiableSelect: (configRoot, varName, selectOptions) ->
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
        if selectEmt.children('option').length == 0
          # 選択項目の作成
          for option in selectOptions
            v = _joinArray.call(@, option)
            selectEmt.append("<option value='#{v}'>#{v}</option>")

        defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))[varName]
        if defaultValue?
          selectEmt.val(_joinArray.call(@, defaultValue))
        selectEmt.off('change').on('change', =>
          @[varName] = _splitArray.call(@, $(@).val())
          @applyDesignChange()
        )

      # 変数編集ファイルアップロードのイベント初期化
      initModifiableSelectFile: (emt) ->
        $(emt).find(".#{@constructor.ImageKey.PROJECT_ID}").val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID))
        $(emt).find(".#{@constructor.ImageKey.ITEM_OBJ_ID}").val(@id)
        $(emt).find(".#{@constructor.ImageKey.SELECT_FILE}:first").off().on('change', (e) =>
          target = e.target
          if target.value && target.value.length > 0
            # 選択時
            # URL入力を無効
            el = $(emt).find(".#{@constructor.ImageKey.URL}:first")
            el.attr('disabled', true)
            el.css('backgroundColor', 'gray')
            del = $(emt).find(".#{@constructor.ImageKey.SELECT_FILE_DELETE}:first")
            del.off('click').on('click', ->
              $(target).val('')
              $(target).trigger('change')
            )
            del.show()
          else
            # 未選択
            # URL入力を有効
            el = $(emt).find(".#{@constructor.ImageKey.URL}:first")
            el.removeAttr('disabled')
            el.css('backgroundColor', 'white')
            $(emt).find(".#{@constructor.ImageKey.SELECT_FILE_DELETE}:first").hide()
        )
        $(emt).find(".#{@constructor.ImageKey.URL}:first").off().on('change', (e) =>
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
      })


