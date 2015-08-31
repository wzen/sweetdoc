# アイテム基底
# @abstract
class ItemBase extends ItemEventBase
  # @abstract
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = ""
  # @abstract
  # @property [ItemType] ITEM_ID アイテム種別
  @ITEM_ID = ""

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
    @zindex = Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1)
    # @property [Array] ohiRegist 操作履歴Index保存配列
    @ohiRegist = []
    # @property [Int] ohiRegistIndex 操作履歴Index保存配列のインデックス
    @ohiRegistIndex = 0
    # @property [Object] jqueryElement アイテムのjQueryオブジェクト
    @jqueryElement = null
    # @property [Array] coodRegist ドラッグ座標
    @coodRegist = []

  # コンフィグメニューの要素IDを取得
  # @return [Int] HTML要素ID
  getDesignConfigId: ->
    return Constant.ElementAttribute.DESIGN_CONFIG_ROOT_ID.replace('@id', @id)

  getJQueryElement: ->
    return $('#' + @id)

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
  reDraw: (show = true) ->

  # アイテムの情報をアイテムリストと操作履歴に保存
  # @param [Boolean] newCreated 新規作成か
  saveObj: (newCreated = false) ->
    if newCreated
      # 名前を付与
      num = 1
      self = @
      for k, v of Common.getCreatedItemObject()
        if self.constructor.IDENTITY == v.constructor.IDENTITY
          num += 1
      @name = @constructor.IDENTITY + " #{num}"

    # ページに状態を保存
    @setItemAllPropToPageValue()
    # キャッシュに保存
    LocalStorage.saveEventPageValue()
    # 操作履歴に保存
    OperationHistory.add()
    console.log('save obj:' + JSON.stringify(@itemSize))

    # イベントの選択項目更新
    # fixme: 実行場所について再考
    Timeline.updateSelectItemMenu()

  # アイテムの情報をページ値から取得
  # @property [String] prop 変数名
  # @property [Boolean] isCache キャッシュとして保存するか
  getItemPropFromPageValue : (prop, isCache = false) ->
    prefix_key = if isCache then PageValue.Key.instanceValueCache() else PageValue.Key.instanceValue()
    prefix_key = prefix_key.replace('@id', @id)
    return PageValue.getInstancePageValue(prefix_key + ":#{prop}")

  # アイテムの情報をページ値に設定
  # @property [String] prop 変数名
  # @property [Object] value 値
  # @property [Boolean] isCache キャッシュとして保存するか
  setItemPropToPageValue : (prop, value, isCache = false) ->
    prefix_key = if isCache then PageValue.Key.instanceValueCache() else PageValue.Key.instanceValue()
    prefix_key = prefix_key.replace('@id', @id)
    PageValue.setInstancePageValue(prefix_key + ":#{prop}", value)
    LocalStorage.saveInstancePageValue()

  # 履歴データを取得
  # @abstract
  # @param [ItemActionType] action アクション種別
  getHistoryObj: (action) ->
    return null

  # 履歴データを設定
  # @abstract
  setHistoryObj: (historyObj) ->

  # 保存用の最小限のデータを取得
  getMinimumObject: ->
    obj = {
      id: Common.makeClone(@id)
      itemId: Common.makeClone(@constructor.ITEM_ID)
      name: Common.makeClone(@name)
      itemSize: Common.makeClone(@itemSize)
      zindex: Common.makeClone(@zindex)
      coodRegist: JSON.stringify(Common.makeClone(@coodRegist))
    }
    return obj

  # 最小限のデータを設定
  setMiniumObject: (obj) ->
    delete window.instanceMap[@id]

    @id = Common.makeClone(obj.id)
    @name = Common.makeClone(obj.name)
    @itemSize = Common.makeClone(obj.itemSize)
    @zindex = Common.makeClone(obj.zindex)
    @coodRegist = Common.makeClone(JSON.parse(obj.coodRegist))

    window.instanceMap[@id] = @

  # 閲覧モード用の描画
  # @abstract
  drawForLookaround: (obj) ->

  # イベントによって設定したスタイルをクリアする
  clearAllEventStyle: ->
    return

  # アイテム作成時に設定されるデフォルトメソッド名
  @defaultMethodName = ->
    return PageValue.getInstancePageValue(PageValue.Key.ITEM_DEFAULT_METHODNAME.replace('@item_id', @ITEM_ID))

  # アイテム作成時に設定されるデフォルトアクションタイプ
  @defaultActionType = ->
    return PageValue.getInstancePageValue(PageValue.Key.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', @ITEM_ID))

  # アイテム作成時に設定されるデフォルトアクションタイプ
  @defaultAnimationType = ->
    return PageValue.getInstancePageValue(PageValue.Key.ITEM_DEFAULT_ANIMATIONTYPE.replace('@item_id', @ITEM_ID))

  @defaultEventConfigValue = ->
    return null

  eventConfigValue: ->
    return null

  # イベントに書き込む情報
  objWriteEvent: ->
    obj = {}
    # TODO: アイテムの共通情報をここに記述
    return obj

# CSSアイテム
# @abstract
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

  #CSSを設定
  makeCss: ->
    newEmt = null
    if @css?
      newEmt = $(@css)
    else
      # CSSテンプレートからオブジェクト個別のCSSを作成
      newEmt = $('#' + @constructor.CSSTEMPID).clone(true).attr('id', @getCssRootElementId())
      newEmt.find('.btn-item-id').html(@id)
    $('#css_code_info').append(newEmt)
    @cssRoot = $('#' + @getCssRootElementId())
    @cssCache = $(".css-cache", @cssRoot)
    @cssCode = $(".css-code", @cssRoot)
    @cssStyle = $(".css-style", @cssRoot)
    @cssStyle.text(@cssCode.text())

# Canvasアイテム
# @abstract
# @extend ItemBase
class CanvasItemBase extends ItemBase
  # コンストラクタ
  constructor: ->
    super()
    @newDrawingSurfaceImageData = null
    @newDrawedSurfaceImageData = null
    # @property [Array] scale 表示倍率
    @scale = {w:1.0, h:1.0}

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
    return @id + '_canvas'

  # 伸縮率を設定
  setScale: (drawingContext) ->
    # 要素の伸縮
    element = $("##{@id}")
    canvas = $("##{@canvasElementId()}")
    element.width(@itemSize.w * @scale.w)
    element.height(@itemSize.h * @scale.h)
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    # キャンパスの伸縮
    drawingContext.scale(@scale.w, @scale.h)
    console.log("setScale: itemSize: #{JSON.stringify(@itemSize)}")

  # キャンパス初期化処理
  initCanvas: ->
    canvas = document.getElementById(@canvasElementId());
    context = canvas.getContext('2d');
    # 伸縮率を設定
    @setScale(context)

  # 新規キャンパスを作成
  makeNewCanvas: ->
    $(ElementCode.get().createItemElement(@)).appendTo(window.scrollInside)
    # キャンパスに対する初期化
    @initCanvas()
    # 画面を保存
    @saveNewDrawingSurface()

  # 新規キャンパスの画面を保存
  saveNewDrawingSurface : ->
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      @newDrawingSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height)

  # 描画済みの新規キャンパスの画面を保存
  saveNewDrawedSurface : ->
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      @newDrawedSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height)

  # 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawingSurface : ->
    if @newDrawingSurfaceImageData?
      canvas = document.getElementById(@canvasElementId());
      if canvas?
        context = canvas.getContext('2d');
        context.putImageData(@newDrawingSurfaceImageData, 0, 0)

  # 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawedSurface : ->
    if @newDrawedSurfaceImageData
      canvas = document.getElementById(@canvasElementId());
      if canvas?
        context = canvas.getContext('2d');
        context.putImageData(@newDrawedSurfaceImageData, 0, 0)

  # 描画を削除
  clearDraw: ->
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      context.clearRect(0, 0, canvas.width, canvas.height)
      # キャンパスに対する初期化
      @initCanvas()
