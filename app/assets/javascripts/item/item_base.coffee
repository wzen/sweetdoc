# アイテム基底
# @abstract
class ItemBase extends ItemEventBase
  # @property [String] ID_PREFIX IDプレフィックス
  @ID_PREFIX = "i"
  # @abstract
  # @property [String] NAME_PREFIX 名前プレフィックス
  @NAME_PREFIX = ""
  # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
  @DESIGN_CONFIG_ROOT_ID = 'design_config_@id'
  # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
  @DESIGN_PAGEVALUE_ROOT = 'designs'

  constant = gon.const
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
    @id = @constructor.ID_PREFIX + '_' + @constructor.NAME_PREFIX + '_' + Common.generateId()
    # @property [ItemType] CLASS_DIST_TOKEN アイテム種別
    @classDistToken = @constructor.CLASS_DIST_TOKEN
    # @property [String] name 名前
    @name = null
    # @property [String] visible 表示状態
    @visible = false
    # @property [String] firstFocus 初期フォーカス
    @firstFocus = false
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
    # @property [Array] registCoord ドラッグ座標
    @registCoord = []

  # アイテムのJQuery要素を取得
  # @return [Object] JQuery要素
  getJQueryElement: ->
    return $('#' + @id)

  # アイテム用のテンプレートHTMLを読み込み
  # @abstract
  # @return [String] HTML
  createItemElement: (callback) ->
    callback()

  # アイテム削除
  removeItemElement: ->
    @getJQueryElement().remove()

  # ScrollInsideに要素追加
  addContentsToScrollInside: (contents, callback = null) ->
    if @getJQueryElement()? && @getJQueryElement().length > 0
      # 既に存在する場合は追加しない
      if callback?
        callback()
      return

    createdElement = Common.wrapCreateItemElement(@, $(contents))
    $(createdElement).appendTo(window.scrollInside)
    if callback?
      callback()

  # 画面を保存(全画面)
  saveDrawingSurface : ->
    @_drawingSurfaceImageData = drawingContext.getImageData(0, 0, drawingCanvas.width, drawingCanvas.height)

  # 保存した画面を全画面に再設定
  restoreAllDrawingSurface : ->
    window.drawingContext.putImageData(@_drawingSurfaceImageData, 0, 0)

  # 保存した画面を指定したサイズで再設定
  # @param [Array] size サイズ
  restoreRefreshingSurface : (size) ->
    # ボタンのLadderBand用にpaddingを付ける
    padding = 5
    window.drawingContext.putImageData(@_drawingSurfaceImageData, 0, 0, size.x - padding, size.y - padding, size.w + (padding * 2), size.h + (padding * 2))

  # アイテム表示
  showItem: ->
    @getJQueryElement().css({'opacity': 1, 'z-index': Common.plusPagingZindex(@zindex)})
  # アイテム非表示
  hideItem: ->
    @getJQueryElement().css({'opacity': 0, 'z-index': Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM)})

  # アイテム描画
  # @abstract
  # @param [Boolean] show 要素作成後に表示するか
  itemDraw: (show = true) ->
    if !show
      @hideItem()
    else
      @showItem()

  willChapter: ->
    # チャプター開始時に表示
    @showItem()
    super()

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  refresh: (show = true, callback = null) ->
    requestAnimationFrame( =>
      if window.runDebug
        console.log('ItemBase refresh id:' + @id)
  
      if @refreshing? && @refreshing
        # createItemElementが重い時のため
        # 描画中はスタックに登録
        @refreshStack = true
        if window.debug
          console.log('add stack')
        return

      @refreshing = true
      @removeItemElement()
      @createItemElement( =>
        @itemDraw(show)
        if @setupItemEvents?
          # アイテムのイベント設定
          @setupItemEvents()
        @refreshing = false
        if @refreshStack? && @refreshStack
          # スタックが存在する場合再度描画
          @refreshStack = false
          if window.debug
            console.log('stack redraw')
          @refresh(show, callback)
        else
          if callback?
            callback(@)
      )
    )

  # 画面表示がない場合描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  refreshIfItemNotExist: (show = true, callback = null) ->
    if window.runDebug
      console.log('ItemBase refreshIfItemNotExist id:' + @id)
    if @getJQueryElement().length == 0
      @refresh(show, callback)
    else
      if callback?
        callback(@)

  # CSSに反映
  applyDesignChange: (doStyleSave = true) ->
    @refresh()
    if doStyleSave
      @saveDesign()

  # アイテムの情報をアイテムリストと操作履歴に保存
  # @param [Boolean] newCreated 新規作成か
  saveObj: (newCreated = false) ->
    if newCreated
      # 名前を付与
      num = 0
      self = @
      for k, v of Common.allItemInstances()
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
    obj = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceBefore(@_event[EventPageValueBase.PageValueKey.DIST_ID], @id))
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
    if @actionProperties? &&
      @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT]?
        return @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.METHOD]
    else
      return null

  # アイテム作成時に設定されるデフォルトアクションタイプ
  @defaultActionType = ->
    return Common.getActionTypeByCodingActionType(@actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.ACTION_TYPE])

  # 独自コンフィグのデフォルト
  @defaultSpecificMethodValue = ->
    if @actionProperties? &&
      @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT]?
        ret = @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.SPECIFIC_METHOD_VALUES]
        if ret?
          return ret
        else
          return {}
    else
      return {}

  # 変数編集コンフィグのデフォルト
  @defaultModifiableVars = ->
    if @actionProperties? &&
      @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT]?
        mod = @actionPropertiesModifiableVars(@ActionPropertiesKey.DEFAULT_EVENT, true)
        if mod?
          return mod
        else
          return {}
    else
      return {}

  # スクロールのデフォルト有効方向
  @defaultScrollEnabledDirection = ->
    if @actionProperties? &&
      @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT]?
        return @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.SCROLL_ENABLED_DIRECTION]
    else
      return null

  # スクロールのデフォルト進行方向
  @defaultScrollForwardDirection = ->
    if @actionProperties? &&
      @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT]?
        return @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.SCROLL_FORWARD_DIRECTION]
    else
      return null

  # クリックのデフォルト時間
  @defaultClickDuration = ->
    if @actionProperties? &&
      @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT]?
        return @actionProperties[@ActionPropertiesKey.DEFAULT_EVENT][@ActionPropertiesKey.EVENT_DURATION]
    else
      return null

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
    itemDiff = @_event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF]
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

    scrollEnd = parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])
    scrollStart = parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
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
    itemDiff = @_event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF]
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

    eventDuration = @_event[EventPageValueBase.PageValueKey.EVENT_DURATION]
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

  @switchChildrenConfig = (e, varName, openValue, targetValue) ->
    for cKey, cValue of openValue
      if !cValue?
        # 判定値無し
        return
      if typeof targetValue == 'object'
        # オブジェクトの場合は判定しない
        return

      if typeof cValue == 'string' && (cValue == 'true' || cValue == 'false')
        cValue = cValue == 'true'
      if typeof targetValue == 'string' && (targetValue == 'true' || targetValue == 'false')
        targetValue = targetValue == 'true'

      root = e.closest(".#{Constant.DesignConfig.DESIGN_ROOT_CLASSNAME}")
      openClassName = ConfigMenu.Modifiable.CHILDREN_WRAPPER_CLASS.replace('@parentvarname', varName).replace('@childrenkey', cKey)
      if cValue == targetValue
        $(root).find(".#{openClassName}").show()
      else
        $(root).find(".#{openClassName}").hide()

  if window.isWorkTable
    @include(itemBaseWorktableExtend)

