# 矢印アイテム
# @extend CanvasItemBase
class ArrowItem extends CanvasItemBase
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "Arrow"
  # @property [String] ITEM_ID アイテム種別
  @ITEM_ID = Constant.ItemId.ARROW
  # @property [Int] ARROW_WIDTH 矢印幅
  ARROW_WIDTH = 37
  # @property [Int] HEADER_WIDTH 矢印の頭の幅
  HEADER_WIDTH = 100
  # @property [Int] HEADER_HEIGHT 矢印の頭の長さ
  HEADER_HEIGHT = 50

  # コンストラクタ
  # @param [Array] cood 座標
  constructor : (cood = null)->
    super(cood)
    # @property [Array] direction 矢印の進行方向
    @direction = {x: 0, y: 0}
    # @property [Array] coodHeadPart 矢印の頭部の座標
    @coodHeadPart = []
    # @property [Array] coodLeftBodyPart 矢印の体左部分の座標
    @coodLeftBodyPart = []
    # @property [Array] coodRightBodyPart 矢印の体右部分の座標
    @coodRightBodyPart = []
    # @property [Int] arrow_width 矢印幅
    @arrow_width = ARROW_WIDTH
    # @property [Int] arrow_half_width 矢印の半分幅
    @arrow_half_width = @arrow_width / 2.0
    # @property [Int] header_width 矢印の頭の幅
    @header_width = HEADER_WIDTH
    # @property [Int] header_height 矢印の頭の長さ
    @header_height = HEADER_HEIGHT
    # @property [Int] padding_size CanvasのPadding
    @padding_size = @header_width
    # @property [Array] drawCoodRegist 矢印のドラッグ座標(描画時のみ使用)
    # @private
    @drawCoodRegist = []

  # パスの描画
  # @param [Array] moveCood 画面ドラッグ座標
  drawPath : (moveCood) ->
    _calDrection.call(@, @drawCoodRegist[@drawCoodRegist.length - 1], moveCood)
    @drawCoodRegist.push(moveCood)

    # 尾の部分の座標を計算
    _calTailDrawPath.call(@)
    # 体の部分の座標を計算
    _calBodyPath.call(@, moveCood)
    # 頭の部分の座標を計算
    _calTrianglePath.call(@, @coodLeftBodyPart[@coodLeftBodyPart.length - 1], @coodRightBodyPart[@coodRightBodyPart.length - 1])
    #console.log("@traceTriangelHeadIndex:" + @traceTriangelHeadIndex)

  # 線の描画
  drawLine : ->
    drawingContext.beginPath();
    # 尾と体の座標をCanvasに描画
    _drawCoodToBaseCanvas.call(@)
    drawingContext.globalAlpha = 0.3
    drawingContext.stroke()

  # 再描画処理(新規キャンパスに描画)
  # @param [boolean] show 要素作成後に描画を表示するか
  reDraw: (show = true) ->
    # 新規キャンパス存在チェック
    canvas = document.getElementById(@canvasElementId())
    if !canvas?
      # 新規Canvasを作成
      @makeNewCanvas()
    else
      # 描画をクリア
      @clearDraw()
    # 座標をクリア
    @resetDrawPath()

    if show
      # 座標を再計算
      for r in @coodRegist
        @drawPath(r)
      # 描画
      @drawNewCanvas()

  # パスの情報をリセット
  resetDrawPath: ->
    @coodHeadPart = []
    @coodLeftBodyPart = []
    @coodRightBodyPart = []
    @drawCoodRegist = []

  # アイテムの最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  getMinimumObject: ->
    obj = super()
    newobj = {
      itemId: Constant.ItemId.ARROW
      arrow_width: Common.makeClone(@arrow_width)
      header_width: Common.makeClone(@header_width)
      header_height: Common.makeClone(@header_height)
      scale: Common.makeClone(@scale)
    }
    $.extend(obj, newobj)
    return obj

  # 最小限のデータを設定
  # @param [Array] obj アイテムオブジェクトの最小限データ
  setMiniumObject: (obj) ->
    super(obj)
    @arrow_width = Common.makeClone(obj.arrow_width)
    @arrow_half_width = Common.makeClone(@arrow_width / 2.0)
    @header_width = Common.makeClone(obj.header_width)
    @header_height = Common.makeClone(obj.header_height)
    @padding_size = Common.makeClone(@header_width)
    @scale = Common.makeClone(obj.scale)

  # イベント前の表示状態にする
  updateEventBefore: ->
    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
    if methodName == 'scrollDraw'
      @reDraw(false)

  # イベント後の表示状態にする
  updateEventAfter: ->
    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
    if methodName == 'scrollDraw'
      @reDraw(false)
      (@constructor.prototype[methodName]).call(@, @event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])

  # スクロールイベント ※アクションイベント
  scrollDraw : (scrollValue) ->
    #console.log("scrollY: #{@scrollValue}")
    r = scrollValue / @scrollLength()

    @resetDrawPath()
    @restoreAllNewDrawingSurface()
    for r in @coodRegist.slice(0, parseInt((@coodRegist.length - 1) * r))
      @drawPath(r)
    # 尾と体の座標をCanvasに描画
    @drawNewCanvas()

  # クリックイベント ※アクションイベント
  changeColorClick : (e) =>

  # 座標間の距離を計算する
  # @private
  _coodLength = (locA, locB) ->
    # 整数にする
    return parseInt(Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2)))

  # 進行方向を設定
  # @private
  _calDrection = (beforeLoc, cood) ->
    if !beforeLoc? || !cood?
      return

    x = null
    if beforeLoc.x < cood.x
      x = 1
    else if beforeLoc.x == cood.x
      x = 0
    else
      x = -1

    y = null
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
  _calTrianglePath = (leftCood, rightCood) ->
    if !leftCood? || !rightCood?
      return null

    r =
      x: leftCood.x - rightCood.x
      y: leftCood.y - rightCood.y
    sita = Math.atan2(r.y, r.x)
    leftTop =
      x: Math.cos(sita) * (@header_width + @arrow_width) / 2.0 + rightCood.x
      y: Math.sin(sita) * (@header_width + @arrow_width) / 2.0 + rightCood.y

    sitaRight = sita + Math.PI

    rightTop =
      x: Math.cos(sitaRight) * (@header_width - @arrow_width) / 2.0 + rightCood.x
      y: Math.sin(sitaRight) * (@header_width - @arrow_width) / 2.0 + rightCood.y

    sitaTop = sita + Math.PI / 2.0

    mid =
      x: (leftCood.x + rightCood.x) / 2.0
      y: (leftCood.y + rightCood.y) / 2.0
    top =
      x: Math.cos(sitaTop) * @header_height + mid.x
      y: Math.sin(sitaTop) * @header_height + mid.y

    @coodHeadPart = [rightTop, top, leftTop]

  # 矢印の尾を作成
  # @private
  _calTailDrawPath = ->
    ### 検証 ###
    _validate = ->
      return @drawCoodRegist.length == 2

    if !_validate.call(@)
      return

    locTail = @drawCoodRegist[0]
    locSub = @drawCoodRegist[1]

    # 座標を保存
    rad = Math.atan2(locSub.y - locTail.y, locSub.x - locTail.x)
    @coodRightBodyPart.push({x: -(Math.sin(rad) * @arrow_half_width) + locTail.x, y: Math.cos(rad) * @arrow_half_width + locTail.y})
    @coodLeftBodyPart.push({x: Math.sin(rad) * @arrow_half_width + locTail.x, y: -(Math.cos(rad) * @arrow_half_width) + locTail.y})

  # 矢印の本体を作成
  # @private
  _calBodyPath = ->
    ### 検証 ###
    _validate = ->
      return @drawCoodRegist.length >= 3

    ### 3点から引く座標を求める ###
    _calCenterBodyCood = (left, center, right) ->

      leftLength = _coodLength.call(@, left, center)
      rightLength = _coodLength.call(@, right, center)

      l = {x: left.x - center.x, y: left.y - center.y}
      r = {x: right.x - center.x, y: right.y - center.y}
      cos = (l.x * r.x + l.y * r.y) / (leftLength * rightLength)
      cos = -1.0 if cos < -1
      cos = 1.0 if cos > 1
      vectorRad = Math.acos(cos)
      rad = Math.atan2(r.y, r.x) + (vectorRad / 2.0)

      #      _coodLog.call(@, left, 'left:')
      #      _coodLog.call(@, center, 'center:')
      #      _coodLog.call(@, right, 'right:')
      #      _coodLog.call(@, l, 'l')
      #      _coodLog.call(@, r, 'r')
      #      console.log('leftLength:' + leftLength + ' rightLength:' + rightLength)
      #      console.log('vectorRad:' + vectorRad)
      #      console.log('rad:' + rad)
      #      console.log('locLeft:x ' + Math.cos(rad + Math.PI))
      #      console.log('locLeft:y ' + Math.sin(rad + Math.PI))
      #      console.log('locRight:x ' + Math.cos(rad))
      #      console.log('locRight:x ' + Math.sin(rad))

      leftX = parseInt(Math.cos(rad + Math.PI) * @arrow_half_width + center.x)
      leftY = parseInt(Math.sin(rad + Math.PI) * @arrow_half_width + center.y)
      rightX = parseInt(Math.cos(rad) * @arrow_half_width + center.x)
      rightY = parseInt(Math.sin(rad) * @arrow_half_width + center.y)

      ret =
        coodLeftPart:
          x: leftX
          y: leftY
        coodRightPart:
          x: rightX
          y: rightY
      return ret

    ### 進行方向から最適化 ###
    _suitCoodBasedDirection = (cood)->

      _suitCood = (cood, beforeCood) ->
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
      leftCood = _suitCood.call(@, cood.coodLeftPart, beforeLeftCood)
      rightCood = _suitCood.call(@, cood.coodRightPart, beforeRightCood)

      ret =
        coodLeftPart: leftCood
        coodRightPart: rightCood
      return ret

    if !_validate.call(@)
      return

    locLeftBody = @coodLeftBodyPart[@coodLeftBodyPart.length - 1]
    locRightBody = @coodRightBodyPart[@coodRightBodyPart.length - 1]
    centerBodyCood = _calCenterBodyCood.call(@, @drawCoodRegist[@drawCoodRegist.length - 3], @drawCoodRegist[@drawCoodRegist.length - 2], @drawCoodRegist[@drawCoodRegist.length - 1])
    centerBodyCood = _suitCoodBasedDirection.call(@, centerBodyCood)
    #    console.log('Left')
    #    _coodLog.call(@, locLeftBody, 'moveTo')
    #    _coodLog.call(@, centerBodyCood.coodLeftPart, 'lineTo')
    #    console.log('Right')
    #    _coodLog.call(@, locRightBody, 'moveTo')
    #    _coodLog.call(@, centerBodyCood.coodRightPart, 'lineTo')

    @coodLeftBodyPart.push(centerBodyCood.coodLeftPart)
    @coodRightBodyPart.push(centerBodyCood.coodRightPart)

  # 座標をCanvasに描画
  # @private
  # @param [Object] dc CanvasContext(isBaseCanvasがfalseの場合使用)
  _drawCoodToCanvas = (dc = null) ->
    drawingContext = null
    if dc?
      drawingContext = dc
    else
      drawingContext = window.drawingContext
    if @coodLeftBodyPart.length <= 0 || @coodRightBodyPart.length <= 0
      # 尾が描かれてない場合
      return

    drawingContext.moveTo(@coodLeftBodyPart[@coodLeftBodyPart.length - 1].x, @coodLeftBodyPart[@coodLeftBodyPart.length - 1].y)
    if @coodLeftBodyPart.length >= 2
      for i in [@coodLeftBodyPart.length - 2 .. 0]
        drawingContext.lineTo(@coodLeftBodyPart[i].x, @coodLeftBodyPart[i].y)
    for i in [0 .. @coodRightBodyPart.length - 1]
      drawingContext.lineTo(@coodRightBodyPart[i].x, @coodRightBodyPart[i].y)
    for i in [0 .. @coodHeadPart.length - 1]
      drawingContext.lineTo(@coodHeadPart[i].x, @coodHeadPart[i].y)
    drawingContext.closePath()

  # 座標を基底Canvasに描画
  # @param [Object] dc Canvasコンテキスト
  _drawCoodToBaseCanvas = ->
    _drawCoodToCanvas.call(@)

  # 座標を新しいCanvasに描画
  # @param [Object] dc Canvasコンテキスト
  _drawCoodToNewCanvas = ->
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    _drawCoodToCanvas.call(@, drawingContext)

  # 新しいCanvasに矢印を描画
  drawNewCanvas : ->
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.beginPath();
    # 尾と体の座標をCanvasに描画
    _drawCoodToNewCanvas.call(@)
    drawingContext.fillStyle = "#00008B"
    drawingContext.fill()

  # 座標のログを表示
  # @private
  _coodLog = (cood, name) ->
    console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y)

window.loadedClassList.ArrowItem = ArrowItem
Common.setClassToMap(false, ArrowItem.ITEM_ID, ArrowItem)

if window.worktablePage?
  # ワークテーブル用矢印クラス
  class WorkTableArrowItem extends ArrowItem
    @include WorkTableCommonExtend
    @include WorkTableCanvasItemExtend

    # 描画(パス+線)
    # @param [Array] moveCood 画面ドラッグ座標
    draw : (moveCood) ->
      @coodRegist.push(moveCood)
      # 描画範囲の更新
      _updateArrowRect.call(@, moveCood)
      # パスの描画
      @drawPath(moveCood)
      # 描画した矢印をクリア
      @restoreDrawingSurface(@itemSize)
      # 線の描画
      @drawLine()

    # 描画終了時に呼ばれるメソッド
    # @param [Int] zindex z-index
    # @param [boolean] show 要素作成後に描画を表示するか
    endDraw: (zindex, show = true) ->
      if !super(zindex)
        return false
      @drawAndMakeConfigsAndWritePageValue(show)
      # Canvas状態を保存
      @saveNewDrawedSurface()
      return true

    # 矢印のサイズ更新
    # @private
    _updateArrowRect = (cood) ->
      if @itemSize == null
        @itemSize = {x: cood.x, y: cood.y, w: 0, h: 0}
      else
        minX = cood.x - @padding_size
        minX = if minX < 0 then 0 else minX
        minY = cood.y - @padding_size
        minY = if minY < 0 then 0 else minY
        maxX = cood.x + @padding_size
        maxX = if maxX > drawingCanvas.width then drawingCanvas.width else maxX
        maxY = cood.y + @padding_size
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

  window.loadedClassList.WorkTableArrowItem = WorkTableArrowItem
  Common.setClassToMap(false, WorkTableArrowItem.ITEM_ID, WorkTableArrowItem)

if window.itemInitFuncList? && !window.itemInitFuncList.arrowInit?
  window.itemInitFuncList.arrowInit = (option = {}) ->
    #JS読み込み完了後の処理
    console.log('arrow loaded')

