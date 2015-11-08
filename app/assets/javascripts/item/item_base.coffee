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

    if window.isWorkTable
      @constructor.include WorkTableCommonExtend

  # コンフィグメニューの要素IDを取得
  # @return [String] HTML要素ID
  getDesignConfigId: ->
    return @constructor.DESIGN_CONFIG_ROOT_ID.replace('@id', @id)

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
    }
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

  # イベントに書き込む情報
  eventConfigValue: ->
    return null

  # アイテム位置&サイズを更新
  updateItemSize: (x, y, w, h) ->
    @getJQueryElement().css({top: y, left: x, width: w, height: h})
    @itemSize.x = parseInt(x)
    @itemSize.y = parseInt(y)
    @itemSize.w = parseInt(w)
    @itemSize.h = parseInt(h)
    @saveObj()

# CSSアイテム
# @abstract
# @extend ItemBase
class CssItemBase extends ItemBase

  # @property [String] CSSTEMPID CSSテンプレートID
  @CSSTEMPID = ''

  if gon?
    constant = gon.const

    @DESIGN_ROOT_CLASSNAME = constant.DesignConfig.ROOT_CLASSNAME

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null) ->
    super(cood)
    @cssRoot = null
    @cssCache = null
    @cssCode = null
    @cssStyle = null
    if cood != null
      @moveLoc = {x:cood.x, y:cood.y}
    @css = null
    @cssStypeReflectTimer = null
    if window.isWorkTable
      @constructor.include WorkTableCssItemExtend


  # JSファイル読み込み時処理
  @jsLoaded: (option) ->
    # ワークテーブルの初期化処理
    css_temp = option.css_temp
    if css_temp?
      # CSSテンプレートを設置
      tempEmt = "<div id='#{@CSSTEMPID}'>#{css_temp}</div>"
      window.cssCodeInfoTemp.append(tempEmt)

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  reDraw: (show = true)->
    super(show)
    @clearDraw()
    $(ElementCode.get().createItemElement(@)).appendTo(window.scrollInside)
    if !show
      @getJQueryElement().css('opacity', 0)

    if @setupDragAndResizeEvents?
      # ドラッグ & リサイズイベント設定
      @setupDragAndResizeEvents()

  # 描画削除
  clearDraw: ->
    @getJQueryElement().remove()

  # ストレージとDB保存用の最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  getMinimumObject: ->
    obj = super()
    newobj = {
      itemId: @constructor.ITEM_ID
      mousedownCood: Common.makeClone(@mousedownCood)
      css: @cssRoot[0].outerHTML
    }
    $.extend(obj, newobj)
    return obj

  # 最小限のデータを設定
  # @param [Array] obj アイテムオブジェクトの最小限データ
  setMiniumObject: (obj) ->
    super(obj)
    @mousedownCood = Common.makeClone(obj.mousedownCood)
    @css = Common.makeClone(obj.css)

  # CSS内のオブジェクトIDを自身のものに変更
  changeCssId: (oldObjId) ->
    reg = new RegExp(oldObjId, 'g')
    @css = @css.replace(reg, @id)

  # CSSのルートのIDを取得
  # @return [String] CSSルートID
  getCssRootElementId: ->
    return "css-" + @id

  # CSSアニメーションルートID取得
  # @return [String] CSSアニメーションID
  getCssAnimElementId: ->
    return "css-anim-style"

  # オプションメニューを作成
  # @abstract
  setupOptionMenu: ->

  #CSSを設定
  makeCss: (fromTemp = false) ->
    newEmt = null

    # 存在する場合消去して上書き
    $("#{@getCssRootElementId()}").remove()

    if !fromTemp && @css?
      # 設定済みのCSSプロパティから作成
      newEmt = $(@css)
    else
      # CSSテンプレートから作成
      newEmt = $('#' + @constructor.CSSTEMPID).clone(true).attr('id', @getCssRootElementId())
      newEmt.find('.design-item-id').html(@id)
    window.cssCodeInfo.append(newEmt)
    @cssRoot = $('#' + @getCssRootElementId())
    @cssCache = $(".css-cache", @cssRoot)
    @cssCode = $(".css-code", @cssRoot)
    @cssStyle = $(".css-style", @cssRoot)

    @reflectCssStyle(false)

  # CSS内容
  # @abstract
  cssAnimationElement: ->
    return null

  # アニメーションCSS追加処理
  appendAnimationCssIfNeeded : ->
    ce = @cssAnimationElement()
    if ce?
      methodName = @getEventMethodName()
      # CSSが存在する場合は削除して入れ替え
      @removeCss()
      funcName = "#{methodName}_#{@id}"
      window.cssCode.append("<div class='#{funcName}'><style type='text/css'> #{ce} </style></div>")

  # CSSのスタイルを反映
  reflectCssStyle: (doStyleSave = true) ->
    @cssStyle.text(@cssCode.text())
    @css = @cssRoot[0].outerHTML

    if doStyleSave
      # 頻繁に呼ばれるためタイマーでPageValueに書き込む
      if @cssStypeReflectTimer?
        clearTimeout(@cssStypeReflectTimer)
        @cssStypeReflectTimer = null
      @cssStypeReflectTimer = setTimeout( =>
        # 0.5秒後に反映
        # ページに状態を保存
        @setItemAllPropToPageValue()
        # キャッシュに保存
        LocalStorage.saveAllPageValues()
        @cssStypeReflectTimer = setTimeout( ->
          # 1秒後に操作履歴に保存
          OperationHistory.add()
        , 1000)
      , 500)

  # CSS削除処理
  removeCss: ->
    methodName = @getEventMethodName()
    funcName = "#{methodName}_#{@id}"
    window.cssCode.find(".#{funcName}").remove()

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
    if window.isWorkTable
      @constructor.include WorkTableCanvasItemExtend

  # CanvasのHTML要素IDを取得
  # @return [Int] Canvas要素ID
  canvasElementId: ->
    return @id + '_canvas'

  # 伸縮率を設定
  setScale: ->
    # 要素の伸縮
    element = $("##{@id}")
    canvas = $("##{@canvasElementId()}")
    element.width(@itemSize.w * @scale.w)
    element.height(@itemSize.h * @scale.h)
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    # キャンパスの伸縮
    context = canvas[0].getContext('2d');
    context.scale(@scale.w, @scale.h)
    if window.debug
      console.log("setScale: itemSize: #{JSON.stringify(@itemSize)}")

  # キャンパス初期化処理
  initCanvas: ->
    # 伸縮率を設定
    @setScale()

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
