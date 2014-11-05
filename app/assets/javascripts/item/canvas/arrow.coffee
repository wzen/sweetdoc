# 矢印アイテム
# @extend ItemBase
class ArrowItem extends ItemBase

  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "arrow"
  # @property [String] ITEMTYPE アイテム種別
  @ITEMTYPE = Constant.ItemType.ARROW

  TRIANGLE_LENGTH = 30
  TRIANGLE_TOP_LENGTH = TRIANGLE_LENGTH + 5

  # @property [Int] ARROW_WIDTH 矢印幅
  ARROW_WIDTH = 30
  # @property [Int] ARROW_HALF_WIDTH 矢印幅(半分)
  ARROW_HALF_WIDTH = ARROW_WIDTH / 2.0

  # コンストラクタ
  # @param [Array] cood 座標
  constructor : (cood = null)->
    super(cood)
    @direction = {x: 0, y: 0}  #現在の進行方向を表す
    @coodRegist = []
    @coodDistanceRegist = []
    @crTriangleBottomLineIndex = 0
    @arrowTotalLength = 0
    @triangleTotalLength = 0
    @coodLeftBodyPart = []
    @coodRightBodyPart = []

  # CanvasのHTML要素IDを取得
  # @return [Int] Canvas要素ID
  canvasElementId: ->
    return @getElementId() + '_canvas'

  # 描画
  # @param [Array] moveCood 画面ドラッグ座標
  draw : (moveCood) ->
    calDrection(@coodRegist[@coodRegist.length - 1], moveCood)

    drawingContext.beginPath();
    drawingContext.moveTo(moveCood.x, moveCood.y)
    @coodRegist.push(moveCood)

    updateArrowRect.call(@, moveCood)

    # 描画した矢印をクリア
    clearArrow.call(@)

    # 頭の部分の座標を計算&描画
    calTrianglePath.call(@, moveCood, window.drawingContext)
    # 尾の部分の座標を計算
    calTailDrawPath.call(@)
    # 体の部分の座標を計算
    calBodyPath.call(@, moveCood)

    #console.log("@traceTriangelHeadIndex:" + @traceTriangelHeadIndex)

    # 尾と体の座標をCanvasに描画
    drawCoodToCanvas.call(@, window.drawingContext)

    # 線の描画
    drawingContext.stroke()

  # 描画終了時に呼ばれるメソッド
  # @param [Array] cood 座標
  # @param [Int] zindex z-index
  endDraw: (cood, zindex) ->
    if !super(cood, zindex)
      return false
    @makeElement(cood)
    return true

  # 再描画処理
  reDraw: ->
    # 矢印はまだ..

  # CanvasのHTML要素を作成
  # @param [Array] cood 座標
  # @return [Boolean] 処理結果
  makeElement: (cood) ->

    # Canvasを作成
    $(ElementCode.get().createItemElement(@)).appendTo('#main-wrapper')
    $('#' + @canvasElementId()).attr('width', $('#' + @getElementId).width())
    $('#' + @canvasElementId()).attr('height', $('#' + @getElementId).height())
    @setupEvents()

    # 新しいCanvasに描画
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.beginPath();

    # 新しいCanvasに合わせるためにrect分座標を引く
    for l in @coodRegist
      l.x -= @itemSize.x
      l.y -= @itemSize.y
    for l in @coodLeftBodyPart
      l.x -= @itemSize.x
      l.y -= @itemSize.y
    for l in @coodRightBodyPart
      l.x -= @itemSize.x
      l.y -= @itemSize.y

    calTrianglePath.call(@, {x:cood.x - @itemSize.x, y:cood.y - @itemSize.y}, drawingContext)
    drawCoodToCanvas.call(@, drawingContext)
    drawingContext.stroke()
    return true

  # ストレージとDB保存用の最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  generateMinimumObject: ->
    obj = {
      itemType: Constant.ItemType.ARROW
      a: @itemSize
      b: @zindex
      c: @coodRegist
      d : @coodDistanceRegist
      e : @crTriangleBottomLineIndex - 1
      f : @arrowTotalLength
      g : @triangleTotalLength
      h : @coodLeftBodyPart
      i : @coodRightBodyPart
    }
    return obj

  # 最小限のデータからアイテムを描画
  # @param [Array] obj アイテムオブジェクトの最小限データ
  loadByMinimumObject: (obj) ->
#    @id = elementId.slice(@constructor.IDENTITY.length + 1)
    @itemSize = obj.a
    @zindex = obj.b
    @coodRegist = obj.c
    @coodDistanceRegist = obj.d
    @crTriangleBottomLineIndex = obj.e
    @arrowTotalLength = obj.f
    @triangleTotalLength = obj.g
    @coodLeftBodyPart = obj.h
    @coodRightBodyPart = obj.i
    @crTriangleBottomLineIndex -= 1
    @makeElement(@coodRegist[@coodRegist.length - 1])
    @save(Constant.ItemActionType.MAKE)

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

    console.log('direction x:' + x + ' y:' + y)
    @direction = {x: x, y: y}

  # 矢印の頭を作成
  # @private
  calTrianglePath = (cood, drawingContext) ->
    locBefore = @coodRegist[@coodRegist.length - 2]
    locTop = null

    if locBefore == undefined || locBefore == null
      return

    ### 計算 ###
    cal = ->
      length = coodLength.call(@, cood, locBefore)
      @coodDistanceRegist.push(length)
      @triangleTotalLength += length
      @arrowTotalLength += length
      while parseInt(@triangleTotalLength) > TRIANGLE_TOP_LENGTH
        @triangleTotalLength -= @coodDistanceRegist.shift()
        # ヘッダーインデックスを+1
        @crTriangleBottomLineIndex += 1
      locTop = @coodRegist[@crTriangleBottomLineIndex]

    ### 検証 ###
    validate = ->
      # 長さが短い
      if parseInt(@arrowTotalLength) < TRIANGLE_LENGTH
        return false
#      # 角度チェック
#      locA = {x: cood.x - locBefore.x, y: cood.y - locBefore.y}
#      locB = {x: locBefore.x - locTop.x, y: locBefore.y - locTop.y}
#      console.log("locA.x:" + locA.x + " locA.y:" + locA.y)
#      console.log("locB.x:" + locB.x + " locB.y:" + locB.y)
#      sita = Math.acos((locA.x * locB.x + locA.y * locB.y) / (coodLength.call(@, locTop, locBefore) * @lengthTraces[@lengthTraces.length - 1]))
#      sita *= 180.0 / Math.PI
#      console.log("sita:" + sita)
#      if sita <= 30
#        return true
#
#      return false
      return true

    ### パスの描画 ###
    drawTrianglePath =  ->
      locBottom = cood
      drawingContext.save()
      drawingContext.translate(locBottom.x, locBottom.y)
      rad = Math.atan2(locBottom.y - locTop.y, locBottom.x - locTop.x)
      drawingContext.rotate(rad)
      drawingContext.moveTo(0, 0)
      drawingContext.lineTo(-TRIANGLE_LENGTH, TRIANGLE_LENGTH)
      drawingContext.lineTo(-TRIANGLE_LENGTH, -TRIANGLE_LENGTH)
      drawingContext.lineTo(0, 0)
      drawingContext.restore()

    # 計算
    cal.call(@)

    # 検証
    if !validate.call(@)
      # 警告
      #flushWarn("Cannot draw Arrow." + " @triangleLengthSum:" + @triangleLengthSum)
      return

    #矢印の三角を描く
    drawTrianglePath.call(@)


  # 矢印の尾を作成
  # @private
  calTailDrawPath = ->
    ### 検証 ###
    validate = ->
      return @coodRegist.length == 2

    if !validate.call(@)
      return

    locTail = @coodRegist[0]
    locSub = @coodRegist[1]

    # 座標を保存
    rad = Math.atan2(locSub.y - locTail.y, locSub.x - locTail.x)
    @coodRightBodyPart.push({x: -(Math.sin(rad) * ARROW_HALF_WIDTH) + locTail.x, y: Math.cos(rad) * ARROW_HALF_WIDTH + locTail.y})
    @coodLeftBodyPart.push({x: Math.sin(rad) * ARROW_HALF_WIDTH + locTail.x, y: -(Math.cos(rad) * ARROW_HALF_WIDTH) + locTail.y})

  # 矢印の本体を作成
  # @private
  calBodyPath = ->
    ### 検証 ###
    validate = ->
      return @crTriangleBottomLineIndex >= 3

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

      coodLog.call(@, left, 'left:')
      coodLog.call(@, center, 'center:')
      coodLog.call(@, right, 'right:')
      coodLog.call(@, l, 'l')
      coodLog.call(@, r, 'r')
      console.log('leftLength:' + leftLength + ' rightLength:' + rightLength)
      console.log('vectorRad:' + vectorRad)
      console.log('rad:' + rad)
      console.log('locLeft:x ' + Math.cos(rad + Math.PI))
      console.log('locLeft:y ' + Math.sin(rad + Math.PI))
      console.log('locRight:x ' + Math.cos(rad))
      console.log('locRight:x ' + Math.sin(rad))

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
    centerBodyCood = calCenterBodyCood.call(@, @coodRegist[@crTriangleBottomLineIndex - 3], @coodRegist[@crTriangleBottomLineIndex - 2], @coodRegist[@crTriangleBottomLineIndex - 1])
    centerBodyCood = suitCoodBasedDirection.call(@, centerBodyCood)
    console.log('Left')
    coodLog.call(@, locLeftBody, 'moveTo')
    coodLog.call(@, centerBodyCood.coodLeftPart, 'lineTo')
    console.log('Right')
    coodLog.call(@, locRightBody, 'moveTo')
    coodLog.call(@, centerBodyCood.coodRightPart, 'lineTo')

    @coodLeftBodyPart.push(centerBodyCood.coodLeftPart)
    @coodRightBodyPart.push(centerBodyCood.coodRightPart)

  # 座標をCanvasに描画
  # @private
  drawCoodToCanvas = (drawingContext) ->
    if @coodLeftBodyPart.length <= 0 || @coodRightBodyPart.length <= 0
      # 尾が描かれてない場合
      return

    drawingContext.moveTo(@coodLeftBodyPart[@coodLeftBodyPart.length - 1].x, @coodLeftBodyPart[@coodLeftBodyPart.length - 1].y)
    if @coodLeftBodyPart.length >= 2
      for i in [@coodLeftBodyPart.length-2 .. 0]
        drawingContext.lineTo(@coodLeftBodyPart[i].x, @coodLeftBodyPart[i].y)
    for i in [0 .. @coodRightBodyPart.length-1]
      drawingContext.lineTo(@coodRightBodyPart[i].x, @coodRightBodyPart[i].y)

  # 描画した矢印をクリア
  # @private
  clearArrow = ->
    # 保存したキャンパスを張り付け
    @restoreDrawingSurface(@itemSize)

  # 矢印の範囲更新
  # @private
  updateArrowRect = (cood) ->
    if @itemSize == null
      @itemSize = {x: cood.x, y: cood.y, w: 0, h: 0}
    else
      minX = cood.x - TRIANGLE_TOP_LENGTH
      minX = if minX < 0 then 0 else minX
      minY = cood.y - TRIANGLE_TOP_LENGTH
      minY = if minY < 0 then 0 else minY
      maxX = cood.x + TRIANGLE_TOP_LENGTH
      maxX = if maxX > drawingCanvas.width then drawingCanvas.width else maxX
      maxY = cood.y + TRIANGLE_TOP_LENGTH
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