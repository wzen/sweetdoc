# アイテム基底
class ItemBase
  # @abstract
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = ""
  # @abstract
  # @property [ItemType] ITEMTYPE アイテム種別
  @ITEMTYPE = ""

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->

    # @property [Int] id ID
    @id = generateId()
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

  # IDを取得
  # @return [Int] ID
  getId: ->
    return @id

  # HTML要素IDを取得
  # @return [Int] HTML要素ID
  getElementId: ->
    return @constructor.IDENTITY + '_' + @id

  getJQueryElement: ->
    return $('#' + @getElementId())

  # サイズ取得
  # @return [Array] サイズ
  getSize: ->
    return @itemSize

  # サイズ設定
  # @param [Array] size サイズ
  setSize: (size) ->
    @itemSize = size

  # z-indexを取得
  # @return [Int] z-index
  getZIndex: ->
    return @zindex

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
    drawingContext.putImageData(@drawingSurfaceImageData, 0, 0, size.x - Constant.SURFACE_IMAGE_MARGIN, size.y - Constant.SURFACE_IMAGE_MARGIN, size.w + Constant.SURFACE_IMAGE_MARGIN * 2, size.h + Constant.SURFACE_IMAGE_MARGIN * 2)

  # 描画開始時の処理
  startDraw: ->

  # 描画中の処理
  # @abstract
  draw: (cood) ->

  # 描画終了時の処理
  # @param [Array] cood 座標
  # @param [Int] zindex z-index
  # @return [Boolean] 処理結果
  endDraw: (zindex) ->
    @zindex = zindex
    return true

  # インスタンス変数で再描画
  # データから読み込んで描画する処理に使用
  # @abstract
  reDraw: ->

  # アイテムの情報をアイテムリストと操作履歴に保存
  # @param [ItemActionType] action アクション種別
  saveObj: (action) ->
    # 操作履歴に保存
    history = {
      obj: @
      action : action
      itemSize: @itemSize
    }
    @pushOhi(operationHistoryIndex - 1)
    pushOperationHistory(history)
    if action == Constant.ItemActionType.MAKE
      # アイテムリストに保存
      itemObjectList.push(@)
    console.log('save obj:' + JSON.stringify(@itemSize))

  # ストレージとDB保存用の最小限のデータを取得
  # @abstract
  generateMinimumObject: ->

  # 最小限のデータからアイテムを描画
  # @abstract
  loadByMinimumObject: (obj) ->

  # 閲覧モード用の描画
  # @abstract
  drawForLookaround: (obj) ->

  # アイテムにイベントを設定する
  setupEvents: ->

    # クリックイベント設定
    do =>
      @getJQueryElement().mousedown( (e)->
        if e.which == 1 #左クリック
          e.stopPropagation()
          $(@).find('.editSelected').remove()
          $(@).append('<div class="editSelected" />')
      )

    # JQueryUIのドラッグイベントとリサイズ設定
    do =>
      @getJQueryElement().draggable({
        containment: mainWrapper
        stop: (event, ui) =>
          rect = {x:ui.position.left, y: ui.position.top, w: @getSize().w, h: @getSize().h}
          @setSize(rect)
          @saveObj(Constant.ItemActionType.MOVE)
      })
      @getJQueryElement().resizable({
        containment: mainWrapper
        stop: (event, ui) =>
          rect = {x: @getSize().x, y: @getSize().y, w: ui.size.width, h: ui.size.height}
          @setSize(rect)
          @saveObj(Constant.ItemActionType.MOVE)
      })

  # イベントによって設定したスタイルをクリアする　
  clearAllEventStyle : ->
