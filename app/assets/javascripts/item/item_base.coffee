# アイテム基底
# @abstract
class ItemBase extends ItemEventBase
  # @abstract
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = ""
  # @abstract
  # @property [ItemType] ITEM_ID アイテム種別
  @ITEM_ID = ""
  # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
  @DESIGN_CONFIG_ROOT_ID = 'design_config_@id'
  # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
  @DESIGN_PAGEVALUE_ROOT = 'designs'

  if gon?
    constant = gon.const

    class @ActionPropertiesKey
      @METHODS = constant.ItemActionPropertiesKey.METHODS
      @DEFAULT_METHOD = constant.ItemActionPropertiesKey.DEFAULT_METHOD
      @ACTION_TYPE = constant.ItemActionPropertiesKey.ACTION_TYPE
      @SCROLL_ENABLED_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_ENABLED_DIRECTION
      @SCROLL_FORWARD_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_FORWARD_DIRECTION
      @OPTIONS = constant.ItemActionPropertiesKey.OPTIONS

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->
    super()
    # @property [Int] id ID
    @id = "i" + @constructor.IDENTITY + Common.generateId()
    # @property [String] name 名前
    @name = null
    # @property [Object] drawingSurfaceImageData 画面を保存する変数
    @drawingSurfaceImageData = null
    if cood != null
      # @property [Array] mousedownCood 初期座標
      @mousedownCood = {x:cood.x, y:cood.y}
    # @property [Array] itemSize サイズ
    @itemSize = null
    # @property [Int] zIndex z-index
    @zindex = Constant.Zindex.EVENTBOTTOM + 1
    # @property [Array] ohiRegist 操作履歴Index保存配列
    @ohiRegist = []
    # @property [Int] ohiRegistIndex 操作履歴Index保存配列のインデックス
    @ohiRegistIndex = 0
    # @property [Object] jqueryElement アイテムのjQueryオブジェクト
    @jqueryElement = null
    # @property [Array] coodRegist ドラッグ座標
    @coodRegist = []

    # modifiables変数の初期化
    if @constructor.actionProperties.modifiables?
      for varName, value of @constructor.actionProperties.modifiables
        this[varName] = value.default

    if window.isWorkTable
      @constructor.include WorkTableCommonInclude

  # アイテムのJQuery要素を取得
  # @return [Object] JQuery要素
  getJQueryElement: ->
    return $('#' + @id)

  # 画面を保存(全画面)
  saveDrawingSurface : ->
    @drawingSurfaceImageData = drawingContext.getImageData(0, 0, drawingCanvas.width, drawingCanvas.height)

  # 保存した画面を全画面に再設定
  restoreAllDrawingSurface : ->
    drawingContext.putImageData(@drawingSurfaceImageData, 0, 0)

  # 保存した画面を指定したサイズで再設定
  # @param [Array] size サイズ
  restoreDrawingSurface : (size) ->
    # ボタンのLadderBand用にpaddingを付ける
    padding = 5
    drawingContext.putImageData(@drawingSurfaceImageData, 0, 0, size.x - padding, size.y - padding, size.w + (padding * 2), size.h + (padding * 2))

  # インスタンス変数で描画
  # データから読み込んで描画する処理に使用
  # @abstract
  # @param [Boolean] show 要素作成後に表示するか
  reDraw: (show = true) ->

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
    Timeline.updateSelectItemMenu()

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

  # 保存用の最小限のデータを取得
  # @return [Object] 取得データ
  getMinimumObject: ->
    obj = {
      id: Common.makeClone(@id)
      itemId: Common.makeClone(@constructor.ITEM_ID)
      name: Common.makeClone(@name)
      itemSize: Common.makeClone(@itemSize)
      zindex: Common.makeClone(@zindex)
      coodRegist: JSON.stringify(Common.makeClone(@coodRegist))
      designs: Common.makeClone(@designs)
    }
    mod = {}
    # modifiables変数の追加
    if @constructor.actionProperties.modifiables?
      for varName, value of @constructor.actionProperties.modifiables
        mod[varName] = Common.makeClone(this[varName])
    $.extend(obj, mod)

    return obj

  # 最小限のデータを設定
  # @param [Object] obj 設定データ
  setMiniumObject: (obj) ->
    # ID変更のため一度instanceMapから削除
    delete window.instanceMap[@id]
    @id = Common.makeClone(obj.id)
    @name = Common.makeClone(obj.name)
    @itemSize = Common.makeClone(obj.itemSize)
    @zindex = Common.makeClone(obj.zindex)
    @coodRegist = Common.makeClone(JSON.parse(obj.coodRegist))
    @designs = Common.makeClone(obj.designs)

    # modifiables変数の追加
    if @constructor.actionProperties.modifiables?
      for varName, value of @constructor.actionProperties.modifiables
        this[varName] = Common.makeClone(obj[varName])
    window.instanceMap[@id] = @

  # イベントによって設定したスタイルをクリアする
  clearAllEventStyle: ->
    return

  # アイテム作成時に設定されるデフォルトメソッド名
  @defaultMethodName = ->
    return @actionProperties[@ActionPropertiesKey.DEFAULT_METHOD]

  # アイテム作成時に設定されるデフォルトアクションタイプ
  @defaultActionType = ->
    return Common.getActionTypeByCodingActionType(@actionProperties[@ActionPropertiesKey.METHODS][@defaultMethodName()][@ActionPropertiesKey.ACTION_TYPE])

  @defaultEventConfigValue = ->
    return null

  # スクロールのデフォルト有効方向
  @defaultScrollEnabledDirection = ->
    return @actionProperties[@ActionPropertiesKey.METHODS][@defaultMethodName()][@ActionPropertiesKey.SCROLL_ENABLED_DIRECTION]

  # スクロールのデフォルト進行方向
  @defaultScrollForwardDirection = ->
    return @actionProperties[@ActionPropertiesKey.METHODS][@defaultMethodName()][@ActionPropertiesKey.SCROLL_FORWARD_DIRECTION]

  # デフォルトデザインをPageValue & 変数に適用
  applyDefaultDesign: ->
    # デザイン用のPageValue作成
    if @constructor.actionProperties.designConfigDefaultValues?
      PageValue.setInstancePageValue(PageValue.Key.instanceDesignRoot(@id), @constructor.actionProperties.designConfigDefaultValues)
    @designs = PageValue.getInstancePageValue(PageValue.Key.instanceDesignRoot(@id))

  # イベントに書き込む情報
  eventConfigValue: ->
    return null

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
  updateInstanceParamByScroll: (scrollValue, immediate = false)->
    super()
    @updateItemSizeByScroll(scrollValue, immediate)

  # クリックによるアイテム状態更新
  updateInstanceParamByClick: (immediate = false) ->
    super()
    @updateItemSizeByClick()

  # スクロールイベントでアイテム位置&サイズ更新
  updateItemSizeByScroll: (scrollValue, immediate = false) ->
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
  updateItemSizeByClick: (immediate = false) ->
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

    clickAnimationDuration = @constructor.actionProperties.methods[@getEventMethodName()].clickAnimationDuration
    duration = 0.01
    perX = itemDiff.x * (duration / clickAnimationDuration)
    perY = itemDiff.y * (duration / clickAnimationDuration)
    perW = itemDiff.w * (duration / clickAnimationDuration)
    perH = itemDiff.h * (duration / clickAnimationDuration)
    loopMax = Math.ceil(clickAnimationDuration/ duration)
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
