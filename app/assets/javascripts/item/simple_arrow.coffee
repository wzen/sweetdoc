# 矢印アイテム
# @extend ItemBase
class SimpleArrowItem extends ItemBase
  @NAME_PREFIX = "simplearrow"
  if window.loadedClassDistToken?
    @CLASS_DIST_TOKEN = window.loadedClassDistToken

  # @property [Int] ARROW_WIDTH 矢印幅
  ARROW_WIDTH = 30
  # @property [Int] ARROW_HALF_WIDTH 矢印幅(半分)
  ARROW_HALF_WIDTH = ARROW_WIDTH / 2.0

  # @property [Int] HEADER_WIDTH 矢印の頭の幅
  HEADER_WIDTH = 50
  # @property [Int] HEADER_HEIGHT 矢印の頭の長さ
  HEADER_HEIGHT = 50
  # @property [Int] PADDING_SIZE 矢印サイズのPadding
  PADDING_SIZE = HEADER_WIDTH + 5

  # コンストラクタ
  # @param [Array] cood 座標
  constructor : (cood = null)->
    super(cood)
    # @property [Array] direction 矢印の進行方向
    @direction = {x: 0, y: 0}
    # @property [Array] registCoord ドラッグした座標
    @registCoord = []
    # @property [Array] _headPartCoord 矢印の頭部の座標
    @_headPartCoord = []

  # CanvasのHTML要素IDを取得
  # @return [Int] Canvas要素ID
  canvasElementId: ->
    return @id + '_canvas'

  # 描画
  # @param [Array] moveCood 画面ドラッグ座標
  draw : (moveCood) ->
    calDrection.call(@, @registCoord[@registCoord.length - 1], moveCood)

    if @registCoord.length >= 2
      b = @registCoord[@registCoord.length - 2]
      mid =
        x: (b.x + moveCood.x) / 2.0
        y: (b.y + moveCood.y) / 2.0
      @registCoord[@registCoord - 1] = mid

    @registCoord.push(moveCood)

    updateArrowRect.call(@, moveCood)

    # 描画した矢印をクリア
    clearArrow.call(@)

    # 頭の部分の座標を計算
    calTrianglePath.call(@)
    #console.log("@traceTriangelHeadIndex:" + @traceTriangelHeadIndex)

    # 座標をCanvasに描画
    drawCoodToCanvas.call(@, window.drawingContext)

  # 描画終了時に呼ばれるメソッド
  # @param [Array] cood 座標
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true, callback = null) ->
    if !super(zindex)
      if callback?
        callback()
      return false

    # 新しいCanvasに合わせるためにrect分座標を引く
    for l in @registCoord
      l.x -= @itemSize.x
      l.y -= @itemSize.y
    for l in @_headPartCoord
      l.x -= @itemSize.x
      l.y -= @itemSize.y

    @drawAndMakeConfigs(show)
    if callback?
      callback()
    return true

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  refresh: (show = true) ->
    @drawAndMakeConfigs(show)

  # CanvasのHTML要素を作成
  # @param [Array] cood 座標
  # @param [boolean] show 要素作成後に描画を表示するか
  # @return [Boolean] 処理結果
  drawAndMakeConfigs: (show = true) ->

    # Canvasを作成
    #$(ElementCode.get().createItemElement(@)).appendTo(window.scrollInside)
    $('#' + @canvasElementId()).attr('width', $('#' + @id).width())
    $('#' + @canvasElementId()).attr('height', $('#' + @id).height())
    @setupItemEvents()

    if show
      # 新しいCanvasに描画
      drawingCanvas = document.getElementById(@canvasElementId())
      drawingContext = drawingCanvas.getContext('2d')
      drawCoodToCanvas.call(@, drawingContext)

  # ストレージとDB保存用の最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  getMinimumObject: ->
    obj = {
      classDistToken: @constructor.CLASS_DIST_TOKEN
      a: @itemSize
      b: @zindex
      c: @registCoord
      d : @_headPartCoord
    }
    return obj

  # 座標間の距離を計算する
  # @private
  coodLength = (locA, locB) ->
    # 整数にする
    return parseInt(Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2)))
    #Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2))

  # 進行方向を設定
  # @private
  calDrection = (beforeLoc, cood) ->
    if !beforeLoc? || !cood?
      return

    if beforeLoc.x < cood.x
      x = 1
    else if beforeLoc.x == cood.x
      x = 0
    else
      x = -1

    if beforeLoc.y < cood.y
      y = 1
    else if beforeLoc.y == cood.y
      y = 0
    else
      y = -1

    #console.log('direction x:' + x + ' y:' + y)
    @direction = {x: x, y: y}

  # 矢印の頭を作成
  # @private
  calTrianglePath = ->
    if @registCoord.length < 4
      return null

    lastBodyCood = @registCoord[@registCoord.length - 1]
    r =
      x: @registCoord[@registCoord.length - 4].x - lastBodyCood.x
      y: @registCoord[@registCoord.length - 4].y - lastBodyCood.y
    sita = Math.atan2(r.y, r.x)
    sitaLeft = sita - Math.PI / 2.0
    leftTop =
      x: Math.cos(sitaLeft) * HEADER_WIDTH + lastBodyCood.x
      y: Math.sin(sitaLeft) * HEADER_WIDTH + lastBodyCood.y
    sitaRight = sita + Math.PI / 2.0
    rightTop =
      x: Math.cos(sitaRight) * HEADER_WIDTH + lastBodyCood.x
      y: Math.sin(sitaRight) * HEADER_WIDTH + lastBodyCood.y

    sitaMid = sita + Math.PI
    top =
      x: Math.cos(sitaMid) * HEADER_HEIGHT + lastBodyCood.x
      y: Math.sin(sitaMid) * HEADER_HEIGHT + lastBodyCood.y

    @_headPartCoord = [rightTop, top, leftTop]

  # 座標をCanvasに描画
  # @private
  drawCoodToCanvas = (drawingContext) ->
    if @registCoord.length < 2
      # 描かれてない場合
      return
    drawingContext.beginPath()
    drawingContext.lineWidth = ARROW_WIDTH
    drawingContext.strokeStyle = 'red'
    drawingContext.lineCap = 'round'
    drawingContext.lineJoin = 'round'
    drawingContext.moveTo(@registCoord[0].x, @registCoord[0].y)
    for i in [1 .. @registCoord.length - 1]
      drawingContext.lineTo(@registCoord[i].x, @registCoord[i].y)
    drawingContext.stroke()

    if @_headPartCoord.length < 2
      return
    drawingContext.beginPath()
    drawingContext.fillStyle = 'red'
    drawingContext.lineWidth = 1.0
    drawingContext.moveTo(@_headPartCoord[0].x, @_headPartCoord[0].y)
    for i in [1 .. @_headPartCoord.length - 1]
      drawingContext.lineTo(@_headPartCoord[i].x, @_headPartCoord[i].y)
    drawingContext.closePath()
    drawingContext.fill()
    drawingContext.stroke()

  # 描画した矢印をクリア
  # @private
  clearArrow = ->
    # 保存したキャンパスを張り付け
    @restoreRefreshingSurface(@itemSize)

  # 矢印のサイズ更新
  # @private
  updateArrowRect = (cood) ->
    if @itemSize == null
      @itemSize = {x: cood.x, y: cood.y, w: 0, h: 0}
    else
      minX = cood.x - PADDING_SIZE
      minX = if minX < 0 then 0 else minX
      minY = cood.y - PADDING_SIZE
      minY = if minY < 0 then 0 else minY
      maxX = cood.x + PADDING_SIZE
      maxX = if maxX > drawingCanvas.width then drawingCanvas.width else maxX
      maxY = cood.y + PADDING_SIZE
      maxY = if maxY > drawingCanvas.height then drawingCanvas.height else maxY

      if @itemSize.x > minX
        @itemSize.w += @itemSize.x - minX
        @itemSize.x = minX
      if @itemSize.x + @itemSize.w < maxX
        @itemSize.w += maxX - (@itemSize.x + @itemSize.w)
      if @itemSize.y > minY
        @itemSize.h += @itemSize.y - minY
        @itemSize.y = minY
      if @itemSize.y + @itemSize.h < maxY
        @itemSize.h += maxY - (@itemSize.y + @itemSize.h)

  # 座標のログを表示
  # @private
  coodLog = (cood, name) ->
    console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y)
