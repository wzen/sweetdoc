# アイテム基底
# @abstract
class ItemBase extends ItemEventBase
  # @abstract
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = ""
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
    @id = "i" + @constructor.IDENTITY + Common.generateId()
    # @property [ItemType] ITEM_ACCESS_TOKEN アイテム種別
    @itemToken = @constructor.ITEM_ACCESS_TOKEN
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
    # @property [Array] coodRegist ドラッグ座標
    @coodRegist = []
    if window.isWorkTable
      @constructor.include WorkTableCommonInclude

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
        if self.constructor.IDENTITY == v.constructor.IDENTITY
          num += 1
      @name = @constructor.IDENTITY + " #{num}"

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

    eventDuration = @constructor.actionProperties.methods[@getEventMethodName()][EventPageValueBase.PageValueKey.EVENT_DURATION]
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
