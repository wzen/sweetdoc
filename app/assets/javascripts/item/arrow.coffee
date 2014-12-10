#JS読み込み完了
window.loadedItemTypeList.push(Constant.ItemType.ARROW)

# 矢印アイテム
# @extend CanvasItemBase
class ArrowItem extends CanvasItemBase
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "arrow"
  # @property [String] ITEMTYPE アイテム種別
  @ITEMTYPE = Constant.ItemType.ARROW

  # @property [Int] ARROW_WIDTH 矢印幅
  ARROW_WIDTH = 37
  # @property [Int] ARROW_HALF_WIDTH 矢印幅(半分)
  ARROW_HALF_WIDTH = ARROW_WIDTH / 2.0

  # @property [Int] HEADER_WIDTH 矢印の頭の幅
  HEADER_WIDTH = 100
  # @property [Int] HEADER_HEIGHT 矢印の頭の長さ
  HEADER_HEIGHT = 50
  # @property [Int] PADDING_SIZE 矢印サイズのPadding
  PADDING_SIZE = HEADER_WIDTH

  # コンストラクタ
  # @param [Array] cood 座標
  constructor : (cood = null)->
    super(cood)
    # @property [Array] direction 矢印の進行方向
    @direction = {x: 0, y: 0}
    # @property [Array] coodRegist 矢印のドラッグ座標
    @coodRegist = []
    # @property [Array] coodHeadPart 矢印の頭部の座標
    @coodHeadPart = []
    # @property [Array] coodLeftBodyPart 矢印の体左部分の座標
    @coodLeftBodyPart = []
    # @property [Array] coodRightBodyPart 矢印の体右部分の座標
    @coodRightBodyPart = []

    # @property [Array] drawCoodRegist 矢印のドラッグ座標(描画時のみ使用)
    # @private
    @drawCoodRegist = []

  # CanvasのHTML要素IDを取得
  # @return [Int] Canvas要素ID
  canvasElementId: ->
    return @getElementId() + '_canvas'

  # パスの描画
  # @param [Array] moveCood 画面ドラッグ座標
  drawPath : (moveCood) ->
    calDrection.call(@, @drawCoodRegist[@drawCoodRegist.length - 1], moveCood)
    @drawCoodRegist.push(moveCood)

    # 描画範囲の更新
    updateArrowRect.call(@, moveCood)

    # 尾の部分の座標を計算
    calTailDrawPath.call(@)
    # 体の部分の座標を計算
    calBodyPath.call(@, moveCood)
    # 頭の部分の座標を計算
    calTrianglePath.call(@, @coodLeftBodyPart[@coodLeftBodyPart.length - 1], @coodRightBodyPart[@coodRightBodyPart.length - 1])
    #console.log("@traceTriangelHeadIndex:" + @traceTriangelHeadIndex)

  # 線の描画
  drawLine : ->
    drawingContext.beginPath();
    # 尾と体の座標をCanvasに描画
    drawCoodToCanvas.call(@, true)
    drawingContext.globalAlpha = 0.3
    drawingContext.stroke()

  # 描画(パス+線)
  # @param [Array] moveCood 画面ドラッグ座標
  draw : (moveCood) ->
    @coodRegist.push(moveCood)
    # パスの描画
    @drawPath(moveCood)
    # 描画した矢印をクリア
    clearArrow.call(@)
    # 線の描画
    @drawLine()

  # 描画終了時に呼ばれるメソッド
  # @param [Array] cood 座標
  # @param [Int] zindex z-index
  endDraw: (zindex) ->
    if !super(zindex)
      return false
    @makeElement()
    return true

  # 再描画処理
  reDraw: ->
    @saveDrawingSurface()
    @resetDrawPath()
    for r in @coodRegist
      @drawPath(r)
    @drawLine()
    @restoreDrawingSurface(@itemSize)
    @endDraw(@zindex)

  # パスの情報をリセット
  resetDrawPath: ->
    @coodHeadPart = []
    @coodLeftBodyPart = []
    @coodRightBodyPart = []
    @drawCoodRegist = []

  # CanvasのHTML要素を作成
  # @param [Array] cood 座標
  # @return [Boolean] 処理結果
  makeElement: ->
    # Canvasを作成
    $(ElementCode.get().createItemElement(@)).appendTo('#main-wrapper')
    $('#' + @canvasElementId()).attr('width',  $('#' + @getElementId()).width())
    $('#' + @canvasElementId()).attr('height', $('#' + @getElementId()).height())

    # 新しいCanvasに描画
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.beginPath();
    drawCoodToCanvas.call(@, false, drawingContext)
    drawingContext.fillStyle = "#00008B"
    drawingContext.fill()

  # ストレージとDB保存用の最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  generateMinimumObject: ->
    obj = {
      itemType: Constant.ItemType.ARROW
      zindex: @zindex
      coodRegist: @coodRegist
    }
    return obj

  # 最小限のデータからアイテムを描画
  # @param [Array] obj アイテムオブジェクトの最小限データ
  loadByMinimumObject: (obj) ->
    @setMiniumObject(obj)
    @reDraw()
    @saveObj(Constant.ItemActionType.MAKE)

  # 最小限のデータを設定
  setMiniumObject: (obj) ->
    @zindex = obj.zindex
    @coodRegist = obj.coodRegist

  # スクロールイベント
  actorScrollEvent : (x, y) ->
    if !@scrollValue?
      console.log('scroll init')
      @saveDrawingSurface()
      @scrollValue = 0
    else
      console.log("y:#{y}")
      if y >= 0
        @scrollValue += parseInt((y + 9) / 10)
      else
        @scrollValue += parseInt((y - 9) / 10)
    @scrollValue = if @scrollValue < 0 then 0 else @scrollValue
    @scrollValue = if @scrollValue >= @coodRegist.length then @coodRegist.length - 1 else @scrollValue
    console.log("scrollY: #{@scrollValue}")
    @resetDrawPath()
    @restoreDrawingSurface(@actorSize)
    for r in @coodRegist.slice(0, @scrollValue)
      @drawPath(r)
    drawingContext.beginPath();
    # 尾と体の座標をCanvasに描画
    drawCoodToCanvas.call(@, true)
    drawingContext.fillStyle = "#00008B"
    # 描画した矢印をクリア
    #console.log("actorSize: #{@actorSize.x} #{@actorSize.y} #{@actorSize.w} #{@actorSize.h}")
    drawingContext.fill()

    if @scrollValue >= @coodRegist.length - 1
      @nextChapter()

  # 座標間の距離を計算する
  # @private
  coodLength = (locA, locB) ->
    # 整数にする
    return parseInt(Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2)))

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
  calTrianglePath = (leftCood, rightCood) ->
    if !leftCood? || !rightCood?
      return null

    r =
      x: leftCood.x - rightCood.x
      y: leftCood.y - rightCood.y
    sita = Math.atan2(r.y, r.x)
    leftTop =
      x: Math.cos(sita) * (HEADER_WIDTH + ARROW_WIDTH) / 2.0 + rightCood.x
      y: Math.sin(sita) * (HEADER_WIDTH + ARROW_WIDTH) / 2.0 + rightCood.y

    sitaRight = sita + Math.PI

    rightTop =
      x: Math.cos(sitaRight) * (HEADER_WIDTH - ARROW_WIDTH) / 2.0 + rightCood.x
      y: Math.sin(sitaRight) * (HEADER_WIDTH - ARROW_WIDTH) / 2.0 + rightCood.y

    sitaTop = sita + Math.PI / 2.0

    mid =
      x: (leftCood.x + rightCood.x) / 2.0
      y: (leftCood.y + rightCood.y) / 2.0
    top =
      x: Math.cos(sitaTop) * HEADER_HEIGHT + mid.x
      y: Math.sin(sitaTop) * HEADER_HEIGHT + mid.y

    @coodHeadPart = [rightTop, top, leftTop]

  # 矢印の尾を作成
  # @private
  calTailDrawPath = ->
    ### 検証 ###
    validate = ->
      return @drawCoodRegist.length == 2

    if !validate.call(@)
      return

    locTail = @drawCoodRegist[0]
    locSub = @drawCoodRegist[1]

    # 座標を保存
    rad = Math.atan2(locSub.y - locTail.y, locSub.x - locTail.x)
    @coodRightBodyPart.push({x: -(Math.sin(rad) * ARROW_HALF_WIDTH) + locTail.x, y: Math.cos(rad) * ARROW_HALF_WIDTH + locTail.y})
    @coodLeftBodyPart.push({x: Math.sin(rad) * ARROW_HALF_WIDTH + locTail.x, y: -(Math.cos(rad) * ARROW_HALF_WIDTH) + locTail.y})

  # 矢印の本体を作成
  # @private
  calBodyPath = ->
    ### 検証 ###
    validate = ->
      return @drawCoodRegist.length >= 3

    ### 3点から引く座標を求める ###
    calCenterBodyCood = (left, center, right) ->

      leftLength = coodLength.call(@, left, center)
      rightLength = coodLength.call(@, right, center)

      l = {x: left.x - center.x, y: left.y - center.y}
      r = {x: right.x - center.x, y: right.y - center.y}
      cos = (l.x * r.x + l.y * r.y) / (leftLength * rightLength)
      cos = -1.0 if cos < -1
      cos = 1.0 if cos > 1
      vectorRad = Math.acos(cos)
      rad = Math.atan2(r.y, r.x) + (vectorRad / 2.0)

      #      coodLog.call(@, left, 'left:')
      #      coodLog.call(@, center, 'center:')
      #      coodLog.call(@, right, 'right:')
      #      coodLog.call(@, l, 'l')
      #      coodLog.call(@, r, 'r')
      #      console.log('leftLength:' + leftLength + ' rightLength:' + rightLength)
      #      console.log('vectorRad:' + vectorRad)
      #      console.log('rad:' + rad)
      #      console.log('locLeft:x ' + Math.cos(rad + Math.PI))
      #      console.log('locLeft:y ' + Math.sin(rad + Math.PI))
      #      console.log('locRight:x ' + Math.cos(rad))
      #      console.log('locRight:x ' + Math.sin(rad))

      leftX = parseInt(Math.cos(rad + Math.PI) * ARROW_HALF_WIDTH + center.x)
      leftY = parseInt(Math.sin(rad + Math.PI) * ARROW_HALF_WIDTH + center.y)
      rightX = parseInt(Math.cos(rad) * ARROW_HALF_WIDTH + center.x)
      rightY = parseInt(Math.sin(rad) * ARROW_HALF_WIDTH + center.y)

      ret =
        coodLeftPart:
          x: leftX
          y: leftY
        coodRightPart:
          x: rightX
          y: rightY
      return ret

    ### 進行方向から最適化 ###
    suitCoodBasedDirection = (cood)->

      suitCood = (cood, beforeCood) ->
        if @direction.x < 0 &&
          beforeCood.x < cood.x
            cood.x = beforeCood.x
        else if @direction.x > 0 &&
          beforeCood.x > cood.x
            cood.x = beforeCood.x
        if @direction.y < 0 &&
          beforeCood.y < cood.y
            cood.y = beforeCood.y
        else if @direction.y > 0 &&
          beforeCood.y > cood.y
            cood.y = beforeCood.y
        return cood

      beforeLeftCood = @coodLeftBodyPart[@coodLeftBodyPart.length - 1]
      beforeRightCood = @coodRightBodyPart[@coodRightBodyPart.length - 1]
      leftCood = suitCood.call(@, cood.coodLeftPart, beforeLeftCood)
      rightCood = suitCood.call(@, cood.coodRightPart, beforeRightCood)

      ret =
        coodLeftPart: leftCood
        coodRightPart: rightCood
      return ret

    if !validate.call(@)
      return

    locLeftBody = @coodLeftBodyPart[@coodLeftBodyPart.length - 1]
    locRightBody = @coodRightBodyPart[@coodRightBodyPart.length - 1]
    centerBodyCood = calCenterBodyCood.call(@, @drawCoodRegist[@drawCoodRegist.length - 3], @drawCoodRegist[@drawCoodRegist.length - 2], @drawCoodRegist[@drawCoodRegist.length - 1])
    centerBodyCood = suitCoodBasedDirection.call(@, centerBodyCood)
    #    console.log('Left')
    #    coodLog.call(@, locLeftBody, 'moveTo')
    #    coodLog.call(@, centerBodyCood.coodLeftPart, 'lineTo')
    #    console.log('Right')
    #    coodLog.call(@, locRightBody, 'moveTo')
    #    coodLog.call(@, centerBodyCood.coodRightPart, 'lineTo')

    @coodLeftBodyPart.push(centerBodyCood.coodLeftPart)
    @coodRightBodyPart.push(centerBodyCood.coodRightPart)

  # 座標をCanvasに描画
  # @private
  # @param [Boolean] isBaseCanvas 基底キャンバスへの描画か
  drawCoodToCanvas = (isBaseCanvas, dc = null) ->
    if isBaseCanvas
      drawingContext = window.drawingContext
      marginX = 0
      marginY = 0
    else if dc != null
      drawingContext = dc
      marginX = @itemSize.x
      marginY = @itemSize.y
    if @coodLeftBodyPart.length <= 0 || @coodRightBodyPart.length <= 0
      # 尾が描かれてない場合
      return

    drawingContext.moveTo(@coodLeftBodyPart[@coodLeftBodyPart.length - 1].x - marginX, @coodLeftBodyPart[@coodLeftBodyPart.length - 1].y - marginY)
    if @coodLeftBodyPart.length >= 2
      for i in [@coodLeftBodyPart.length - 2 .. 0]
        drawingContext.lineTo(@coodLeftBodyPart[i].x - marginX, @coodLeftBodyPart[i].y - marginY)
    for i in [0 .. @coodRightBodyPart.length - 1]
      drawingContext.lineTo(@coodRightBodyPart[i].x - marginX, @coodRightBodyPart[i].y - marginY)
    for i in [0 .. @coodHeadPart.length - 1]
      drawingContext.lineTo(@coodHeadPart[i].x - marginX, @coodHeadPart[i].y - marginY)
    drawingContext.closePath()

  # 描画した矢印をクリア
  # @private
  clearArrow = ->
    # 保存したキャンパスを張り付け
    @restoreDrawingSurface(@itemSize)

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


class WorkTableArrowItem extends ArrowItem

# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList.arrowInit?
  window.itemInitFuncList.arrowInit = (option = {}) ->