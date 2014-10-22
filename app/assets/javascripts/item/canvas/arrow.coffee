class Arrow extends CanvasBase
  TRIANGLE_LENGTH = 30
  TRIANGLE_TOP_LENGTH = TRIANGLE_LENGTH + 5
  ARROW_WIDTH = 10
  ARROW_HALF_WIDTH = ARROW_WIDTH / 2.0
  constructor : (loc)->
    super(loc)
    @locTraces = []
    @lengthTraces = []
    @traceTriangelHeadIndex = 0
    @allLengthSum = 0
    @triangleLengthSum = 0
    @traceDrawedIndex = 0
    @leftLocs = []
    @rightLocs = []

  getId: ->
    return 'arrow_' + super()
  getCanvasId: ->
    return @getId() + '_canvas'

  ### 描画 ###
  draw : (loc) ->
    drawingContext.beginPath();
    drawingContext.moveTo(loc.x, loc.y)
    @locTraces.push(loc)

    updateArrowRect.call(@, loc)

    # 描画した矢印をクリア
    backToBeforeDraw.call(@)

    # 頭の部分の座標を計算&描画
    drawTriangle.call(@, loc, window.drawingContext)
    if @traceDrawedIndex == 0
      # 尾の部分の座標を計算
      drawTailPath.call(@)
    # 体の部分の座標を計算
    drawBodyPath.call(@, loc)

    #console.log("@traceTriangelHeadIndex:" + @traceTriangelHeadIndex)

    # 尾と体の座標をCanvasに描画
    pathToCanvas.call(@, window.drawingContext)

    # 線の描画
    drawingContext.stroke()

  endDraw: (loc, zindex) ->
    if !super(loc, zindex)
      return false
    emt = $('<div id="' + @getId() + '" class="draggable resizable" style="position: absolute;top:' + @rect.y + 'px;left: ' + @rect.x + 'px;width:' + @rect.w + 'px;height:' + @rect.h + 'px;z-index:' + zindex + '"><canvas id="' + @getCanvasId() + '" class="arrow canvas" ></canvas></div>').appendTo('#main-wrapper')
    #Canvasサイズ
    $('#' + @getCanvasId()).attr('width', $('#' + emt.attr('id')).width())
    $('#' + @getCanvasId()).attr('height', $('#' + emt.attr('id')).height())
    initContextMenu(emt.attr('id'), '.arrow', Constant.ItemType.ARROW)
    setDraggableAndResizable(emt)
    drawingCanvas = document.getElementById(@getCanvasId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.beginPath();

    # 新しいCanvasに合わせるためにrect分座標を引く
    for l in @locTraces
      l.x -= @rect.x
      l.y -= @rect.y
    for l in @leftLocs
      l.x -= @rect.x
      l.y -= @rect.y
    for l in @rightLocs
      l.x -= @rect.x
      l.y -= @rect.y

    #drawingContext.moveTo(loc.x - @rect.x, loc.y - @rect.y)

    drawTriangle.call(@, {x:loc.x - @rect.x, y:loc.y - @rect.y}, drawingContext)
    pathToCanvas.call(@, drawingContext)

    drawingContext.stroke()
    return true

  save: ->
    # WebStorageの保存(Abstract)
  drawByStorage: (id, obj) ->
    # storageの情報から描画(Abstract)

  ### 座標間の距離を計算する ###
  locLength = (locA, locB) ->
    Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2))

  ### 矢印の頭を作成 ###
  drawTriangle = (loc, drawingContext) ->
    locBefore = @locTraces[@locTraces.length - 2]
    locTop = null

    if locBefore == undefined || locBefore == null
      return

    ### 計算 ###
    cal = ->
      length = locLength.call(@, loc, locBefore)
      @lengthTraces.push(length)
      @triangleLengthSum += length
      @allLengthSum += length
      while parseInt(@triangleLengthSum) > TRIANGLE_TOP_LENGTH
        @triangleLengthSum -= @lengthTraces.shift()
        # ヘッダーインデックスを+1
        @traceTriangelHeadIndex += 1
      locTop = @locTraces[@traceTriangelHeadIndex]

    ### 検証 ###
    validate = ->
      # 長さが短い
      if parseInt(@allLengthSum) < TRIANGLE_LENGTH
        return false
#      # 角度チェック
#      locA = {x: loc.x - locBefore.x, y: loc.y - locBefore.y}
#      locB = {x: locBefore.x - locTop.x, y: locBefore.y - locTop.y}
#      console.log("locA.x:" + locA.x + " locA.y:" + locA.y)
#      console.log("locB.x:" + locB.x + " locB.y:" + locB.y)
#      sita = Math.acos((locA.x * locB.x + locA.y * locB.y) / (locLength.call(@, locTop, locBefore) * @lengthTraces[@lengthTraces.length - 1]))
#      sita *= 180.0 / Math.PI
#      console.log("sita:" + sita)
#      if sita <= 30
#        return true
#
#      return false
      return true

    ### パスの描画 ###
    drawTrianglePath =  ->
      locBottom = loc
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
  drawTailPath = ->
    ### 検証 ###
    validate = ->
      return @traceDrawedIndex == 0 && @locTraces.length >= 2

    if !validate.call(@)
      return

    locTail = @locTraces[0]
    locSub = @locTraces[1]

    # 座標を保存
    rad = Math.atan2(locSub.y - locTail.y, locSub.x - locTail.x)
    @rightLocs.push({x: -(Math.sin(rad) * ARROW_HALF_WIDTH) + locTail.x, y: Math.cos(rad) * ARROW_HALF_WIDTH + locTail.y})
    @leftLocs.push({x: Math.sin(rad) * ARROW_HALF_WIDTH + locTail.x, y: -(Math.cos(rad) * ARROW_HALF_WIDTH) + locTail.y})
    @traceDrawedIndex = 1

  ### 矢印の本体を作成 ###
  drawBodyPath = ->
    ### 検証 ###
    validate = ->
      return @traceTriangelHeadIndex >= 3

    ### 3点から引く座標を求める ###
    crossLoc = (left, center, right) ->
      leftLength = locLength.call(@, left, center)
      rightLength = locLength.call(@, right, center)
      #console.log('leftLength:' + leftLength + ' rightLength:' + rightLength)
      l = {x: left.x - center.x, y: left.y - center.y}
      r = {x: right.x - center.x, y: right.y - center.y}
      vectorRad = Math.acos((l.x * r.x + l.y * r.y) / (leftLength * rightLength))
      #locLog.call(@, left, 'left')
      #locLog.call(@, center, 'center')
      #locLog.call(@, right, 'right')
      rad = Math.atan2(r.y, r.x) + (vectorRad / 2.0)
      #console.log('rad:' + rad)
      ret =
        locLeft:
          x: Math.cos(rad + Math.PI) * ARROW_HALF_WIDTH + center.x
          y: Math.sin(rad + Math.PI) * ARROW_HALF_WIDTH + center.y
        locRight:
          x: Math.cos(rad) * ARROW_HALF_WIDTH + center.x
          y: Math.sin(rad) * ARROW_HALF_WIDTH + center.y
      return ret

    if !validate.call(@)
      return

    #尾の座標を求める
    locRightBody = @rightLocs[@rightLocs.length - 1]
    locLeftBody = @leftLocs[@leftLocs.length - 1]
    lineToLocs = crossLoc.call(@, @locTraces[@traceTriangelHeadIndex - 3], @locTraces[@traceTriangelHeadIndex - 2], @locTraces[@traceTriangelHeadIndex - 1])
    #console.log('Left')
    #locLog.call(@, locLeftBody, 'moveTo')
    #locLog.call(@, lineToLocs.locLeft, 'lineTo')
    #console.log('Right')
    #locLog.call(@, locRightBody, 'moveTo')
    #locLog.call(@, lineToLocs.locRight, 'lineTo')

    @leftLocs.push(lineToLocs.locLeft)
    @rightLocs.push(lineToLocs.locRight)
    @traceDrawedIndex += 1

  ### 座標をCanvasに描画 ###
  pathToCanvas = (drawingContext) ->
    if @leftLocs.length <= 0 || @rightLocs.length <= 0
      # 尾が描かれてない場合
      return

    drawingContext.moveTo(@leftLocs[@leftLocs.length - 1].x, @leftLocs[@leftLocs.length - 1].y)
    if @leftLocs.length >= 2
      for i in [@leftLocs.length-2 .. 0]
        drawingContext.lineTo(@leftLocs[i].x, @leftLocs[i].y)
    for i in [0 .. @rightLocs.length-1]
      drawingContext.lineTo(@rightLocs[i].x, @rightLocs[i].y)

  ### 描画した矢印をクリア ###
  backToBeforeDraw = ->
    # 保存したキャンパスを張り付け
    @restoreDrawingSurface(@rect)

  ### 矢印の範囲更新 ###
  updateArrowRect = (loc) ->
    if @rect == null
      @rect = {x: loc.x, y: loc.y, w: 0, h: 0}
    else
      minX = loc.x - TRIANGLE_TOP_LENGTH
      minX = if minX < 0 then 0 else minX
      minY = loc.y - TRIANGLE_TOP_LENGTH
      minY = if minY < 0 then 0 else minY
      maxX = loc.x + TRIANGLE_TOP_LENGTH
      maxX = if maxX > drawingCanvas.width then drawingCanvas.width else maxX
      maxY = loc.y + TRIANGLE_TOP_LENGTH
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

  locLog = (loc, name) ->
    console.log(name + 'X:' + loc.x + ' ' + name + 'Y:' + loc.y)