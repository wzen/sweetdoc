# アイテム基底
class ItemBase extends Extend
  @include EventListener

  # @abstract
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = ""
  # @abstract
  # @property [ItemType] ITEMTYPE アイテム種別
  @ITEMTYPE = ""

  # 要素IDからアイテムIDを取得
  @getIdByElementId : (elementId) ->
    return elementId.replace(@IDENTITY + '_', '')

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->
    super()
    # @property [Int] id ID
    @id = generateId()
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
    @zindex = 0
    # @property [Array] ohiRegist 操作履歴Index保存配列
    @ohiRegist = []
    # @property [Int] ohiRegistIndex 操作履歴Index保存配列のインデックス
    @ohiRegistIndex = 0
    # @property [Object] jqueryElement アイテムのjQueryオブジェクト
    @jqueryElement = null

  # HTML要素IDを取得
  # @return [Int] HTML要素ID
  getElementId: ->
    return @constructor.IDENTITY + '_' + @id

  # コンフィグメニューの要素IDを取得
  # @return [Int] HTML要素ID
  getDesignConfigId: ->
    return @id + '_designconfig'

  getJQueryElement: ->
    return $('#' + @getElementId())

  # 操作履歴Indexをプッシュ
  # @param [ItemBase] obj オブジェクト
  pushOhi: (obj) ->
    @ohiRegist[@ohiRegistIndex] = obj
    @ohiRegistIndex += 1

  # 操作履歴Index保存配列のインデックスをインクリメント
  incrementOhiRegistIndex: ->
    @ohiRegistIndex += 1

  # 操作履歴Indexを取り出す
  # @return [Int] 操作履歴Index
  popOhi: ->
    @ohiRegistIndex -= 1
    return @ohiRegist[@ohiRegistIndex]

  # 最後の操作履歴Indexを取得
  # @return [Int] 操作履歴Index
  lastestOhi: ->
    return @ohiRegist[@ohiRegist.length - 1]

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

  # 描画開始時の処理
  startDraw: ->

  # ドラッグでの描画処理
  # @abstract
  draw: (cood) ->

  # 描画終了時の処理
  # @param [Array] cood 座標
  # @param [Int] zindex z-index
  # @return [Boolean] 処理結果
  endDraw: (zindex) ->
    @zindex = zindex
    return true

  # インスタンス変数で描画
  # データから読み込んで描画する処理に使用
  # @abstract
  reDraw: ->

  # アイテムの情報をアイテムリストと操作履歴に保存
  # @param [ItemActionType] action アクション種別
  saveObj: (action) ->
    # 操作履歴に保存
    history = @getHistoryObj(action)
    @pushOhi(operationHistoryIndex - 1)
    pushOperationHistory(history)
    if action == Constant.ItemActionType.MAKE
      # 名前を付与
      num = 1
      self = @
      itemObjectList.forEach((obj) ->
        if self.constructor.IDENTITY == obj.constructor.IDENTITY
          num += 1
      )
      @name = @constructor.IDENTITY + " #{num}"
      # アイテムリストに保存
      itemObjectList.push(@)
    console.log('save obj:' + JSON.stringify(@itemSize))

  # アイテムの情報をページ値に保存
  # @property [Boolean] isCache キャッシュとして保存するか
  setAllItemPropToPageValue: (isCache = false)->
    prefix_key = if isCache then Constant.PageValueKey.ITEM_VALUE_CACHE else Constant.PageValueKey.ITEM_VALUE
    prefix_key = prefix_key.replace('@id', @id)
    obj = @generateMinimumObject()
    setPageValue(prefix_key, obj)

  # アイテムをページ値から再描画
  # @property [Boolean] isCache キャッシュとして保存するか
  # @return [Boolean] 処理結果
  reDrawByObjPageValue: (isCache = false) ->
    prefix_key = if isCache then Constant.PageValueKey.ITEM_VALUE_CACHE else Constant.PageValueKey.ITEM_VALUE
    prefix_key = prefix_key.replace('@id', @id)
    obj = getPageValue(prefix_key)
    if obj?
      @reDrawByMinimumObject(obj)
      return true
    return false

  # アイテムの情報をページ値から取得
  # @property [String] prop 変数名
  # @property [Boolean] isCache キャッシュとして保存するか
  getItemPropFromPageValue : (prop, isCache = false) ->
    prefix_key = if isCache then Constant.PageValueKey.ITEM_VALUE_CACHE else Constant.PageValueKey.ITEM_VALUE
    prefix_key = prefix_key.replace('@id', @id)
    return getPageValue(prefix_key + ":#{prop}")

  # アイテムの情報をページ値から取得
  # @property [String] prop 変数名
  # @property [Object] value 値
  # @property [Boolean] isCache キャッシュとして保存するか
  setItemPropToPageValue : (prop, value, isCache = false) ->
    prefix_key = if isCache then Constant.PageValueKey.ITEM_VALUE_CACHE else Constant.PageValueKey.ITEM_VALUE
    prefix_key = prefix_key.replace('@id', @id)
    setPageValue(prefix_key + ":#{prop}", value)

  # 履歴データを取得
  # @abstract
  # @param [ItemActionType] action アクション種別
  getHistoryObj: (action) ->
    return null

  # 履歴データを設定
  # @abstract
  setHistoryObj: (historyObj) ->

  # 保存用の最小限のデータを取得
  # @abstract
  generateMinimumObject: ->

  # 最小限のデータからアイテムを描画
  # @abstract
  reDrawByMinimumObject: (obj) ->

  # 閲覧モード用の描画
  # @abstract
  drawForLookaround: (obj) ->

  # イベントによって設定したスタイルをクリアする　
  clearAllEventStyle : ->

# CSSアイテム
# @extend ItemBase
class CssItemBase extends ItemBase
  # CSSのルートのIDを取得
  getCssRootElementId: ->
    return "css-" + @id

  # CSSアニメーションを設置する要素名
  getCssAnimElementId: ->
    return "css-anim-style"

  # オプションメニューを作成
  # @abstract
  setupOptionMenu: ->

  # 描画終了時に呼ばれるメソッド
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true) ->
    if !super(zindex)
      return false

    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()

    return true

  # デザイン変更コンフィグを作成
  makeDesignConfig: ->
    @designConfigRoot = $('#' + @getDesignConfigId())
    if !@designConfigRoot? || @designConfigRoot.length == 0
      @designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', @getDesignConfigId())
      @designConfigRoot.removeClass('design_temp')
      cssConfig = @designConfigRoot.find('.css-config')
      @designConfigRoot.find('.css-config').css('display', '')
      @designConfigRoot.find('.canvas-config').remove()
      $('#design-config').append(@designConfigRoot)

# Canvasアイテム
# @extend ItemBase
class CanvasItemBase extends ItemBase
  # コンストラクタ
  constructor: ->
    super()
    @newDrawingCanvas = null
    @newDrawingContext = null
    @newDrawingSurfaceImageData = null

  # 描画終了時に呼ばれるメソッド
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true) ->
    if !super(zindex)
      return false

    # 座標を新規キャンパス用に修正
    do =>
      @coodRegist.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodLeftBodyPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodRightBodyPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodHeadPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )

    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()

    return true

  # CanvasのHTML要素IDを取得
  # @return [Int] Canvas要素ID
  canvasElementId: ->
    return @getElementId() + '_canvas'

  # 伸縮率を設定
  setScale: (drawingContext) ->
    # 要素の伸縮
    element = $('#' + @getElementId())
    canvas = $('#' + @canvasElementId())
    element.width(@itemSize.w * @scale.w)
    element.height(@itemSize.h * @scale.h)
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    # キャンパスの伸縮
    drawingContext.scale(@scale.w, @scale.h)

    console.log("setScale: itemSize: #{JSON.stringify(@itemSize)}")

  # キャンパス初期化処理
  initCanvas: ->
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    # 伸縮率を設定
    @setScale(drawingContext)

  # 新規キャンパスを作成
  makeNewCanvas: ->
    $(ElementCode.get().createItemElement(@)).appendTo('#scroll_inside')
    # キャンパスに対する初期化
    @initCanvas()

  # 新規キャンパスの画面を保存
  saveNewDrawingSurface : ->
    @newDrawingCanvas = document.getElementById(@canvasElementId());
    @newDrawingContext = @newDrawingCanvas.getContext('2d');
    @newDrawingSurfaceImageData = @newDrawingContext.getImageData(0, 0, @newDrawingCanvas.width, @newDrawingCanvas.height)

  # 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawingSurface : ->
    if @newDrawingSurfaceImageData?
      @newDrawingContext.putImageData(@newDrawingSurfaceImageData, 0, 0)

  # 描画を削除
  clearDraw: ->
    drawingCanvas = document.getElementById(@canvasElementId());
    if drawingCanvas?
      drawingContext = @newDrawingCanvas.getContext('2d');
      drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height)
      # キャンパスに対する初期化
      @initCanvas()

  # デザイン変更コンフィグを作成
  makeDesignConfig: ->
    @designConfigRoot = $('#' + @getDesignConfigId())
    if !@designConfigRoot? || @designConfigRoot.length == 0
      @designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', @getDesignConfigId())
      @designConfigRoot.removeClass('design_temp')
      @designConfigRoot.find('.canvas-config').css('display', '')
      @designConfigRoot.find('.css-config').remove()
      $('#design-config').append(@designConfigRoot)


WorkTableExtend =
  # オプションメニューを開く
  showOptionMenu: ->
    sc = $('.sidebar-config')
    sc.css('display', 'none')
    $('.dc', sc).css('display', 'none')
    $('#design-config').css('display', '')
    $('#' + @getDesignConfigId()).css('display', '')

