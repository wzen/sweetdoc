class Arrow extends CanvasBase
  @IDENTITY = "arrow"
  TRIANGLE_LENGTH = 30
  TRIANGLE_TOP_LENGTH = TRIANGLE_LENGTH + 5
  ARROW_WIDTH = 30
  ARROW_HALF_WIDTH = ARROW_WIDTH / 2.0
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

  canvasElementId: ->
    return @elementId() + '_canvas'

  ### 描画 ###
  draw : (clickCood) ->
    calDrection(@coodRegist[@coodRegist.length - 1], clickCood)

    drawingContext.beginPath();
    drawingContext.moveTo(clickCood.x, clickCood.y)
    @coodRegist.push(clickCood)

    updateArrowRect.call(@, clickCood)

    # 描画した矢印をクリア
    clearArrow.call(@)

    # 頭の部分の座標を計算&描画
    calTrianglePath.call(@, clickCood, window.drawingContext)
    # 尾の部分の座標を計算
    calTailDrawPath.call(@)
    # 体の部分の座標を計算
    calBodyPath.call(@, clickCood)

    #console.log("@traceTriangelHeadIndex:" + @traceTriangelHeadIndex)

    # 尾と体の座標をCanvasに描画
    drawCoodToCanvas.call(@, window.drawingContext)

    # 線の描画
    drawingContext.stroke()

  endDraw: (clickCood, zindex) ->
    if !super(clickCood, zindex)
      return false
    @make(clickCood)
    return true

  make: (cood) ->
    emt = $('<div id="' + @elementId() + '" class="draggable resizable" style="position: absolute;top:' + @rect.y + 'px;left: ' + @rect.x + 'px;width:' + @rect.w + 'px;height:' + @rect.h + 'px;z-index:' + @zindex + '"><canvas id="' + @canvasElementId() + '" class="arrow canvas" ></canvas></div>').appendTo('#main-wrapper')
    #Canvasサイズ
    $('#' + @canvasElementId()).attr('width', $('#' + emt.attr('id')).width())
    $('#' + @canvasElementId()).attr('height', $('#' + emt.attr('id')).height())
    initContextMenu(emt.attr('id'), '.arrow', Constant.ItemType.ARROW)
    setDraggableAndResizable(@)
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.beginPath();

    # 新しいCanvasに合わせるためにrect分座標を引く
    for l in @coodRegist
      l.x -= @rect.x
      l.y -= @rect.y
    for l in @coodLeftBodyPart
      l.x -= @rect.x
      l.y -= @rect.y
    for l in @coodRightBodyPart
      l.x -= @rect.x
      l.y -= @rect.y

    #drawingContext.moveTo(cood.x - @rect.x, cood.y - @rect.y)

    calTrianglePath.call(@, {x:cood.x - @rect.x, y:cood.y - @rect.y}, drawingContext)
    drawCoodToCanvas.call(@, drawingContext)

    drawingContext.stroke()
    return true

  reDraw: ->
    @crTriangleBottomLineIndex -= 1
    @make(@coodRegist[@coodRegist.length - 1])

  jsonSaveToStorage: ->
    obj = {
      itemType: Constant.ItemType.ARROW
      a: @rect
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

  loadByStorage: (obj) ->
#    @id = elementId.slice(@constructor.IDENTITY.length + 1)
    @rect = obj.a
    @zindex = obj.b
    @coodRegist = obj.c
    @coodDistanceRegist = obj.d
    @crTriangleBottomLineIndex = obj.e
    @arrowTotalLength = obj.f
    @triangleTotalLength = obj.g
    @coodLeftBodyPart = obj.h
    @coodRightBodyPart = obj.i
    @reDraw()
    @save(Constant.ItemAction.MAKE)

  ### 座標間の距離を計算する ###
  coodLength = (locA, locB) ->
    # 整数にする
    return parseInt(Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2)))
    #Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2))

  ### 進行方向を設定 ###
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

  ### 矢印の頭を作成 ###
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


  ### 矢印の尾を作成 ###
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

  ### 矢印の本体を作成 ###
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

  ### 座標をCanvasに描画 ###
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

  ### 描画した矢印をクリア ###
  clearArrow = ->
    # 保存したキャンパスを張り付け
    @restoreDrawingSurface(@rect)

  ### 矢印の範囲更新 ###
  updateArrowRect = (cood) ->
    if @rect == null
      @rect = {x: cood.x, y: cood.y, w: 0, h: 0}
    else
      minX = cood.x - TRIANGLE_TOP_LENGTH
      minX = if minX < 0 then 0 else minX
      minY = cood.y - TRIANGLE_TOP_LENGTH
      minY = if minY < 0 then 0 else minY
      maxX = cood.x + TRIANGLE_TOP_LENGTH
      maxX = if maxX > drawingCanvas.width then drawingCanvas.width else maxX
      maxY = cood.y + TRIANGLE_TOP_LENGTH
      maxY = if maxY > drawingCanvas.height then drawingCanvas.height else maxY

      if @rect.x > minX
        @rect.w += @rect.x - minX
        @rect.x = minX
      if @rect.x + @rect.w < maxX
        @rect.w += maxX - (@rect.x + @rect.w)
      if @rect.y > minY
        @rect.h += @rect.y - minY
        @rect.y = minY
      if @rect.y + @rect.h < maxY
        @rect.h += maxY - (@rect.y + @rect.h)

  coodLog = (cood, name) ->
    console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y)