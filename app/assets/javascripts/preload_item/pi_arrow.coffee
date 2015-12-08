# 矢印アイテム
# @extend CanvasItemBase
class PreloadItemArrow extends CanvasItemBase
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "Arrow"
  @ITEM_ACCESS_TOKEN = 'PreloadItemArrow'

  # @property [Int] HEADER_WIDTH 矢印の頭の幅
  HEADER_WIDTH = 100
  # @property [Int] HEADER_HEIGHT 矢印の頭の長さ
  HEADER_HEIGHT = 50

  @actionProperties =
    {
      defaultMethod: 'scrollDraw'
      designConfig: true
      designConfigDefaultValues: {
        values: {
          design_slider_font_size_value: 14
          design_font_color_value: 'ffffff'
          design_slider_padding_top_value: 10
          design_slider_padding_left_value: 20
          design_slider_gradient_deg_value: 0
          design_bg_color1_value: 'ffbdf5'
          design_bg_color2_value: 'ff82ec'
          design_bg_color2_position_value: 25
          design_bg_color3_value: 'fc46e1'
          design_bg_color3_position_value: 50
          design_bg_color4_value: 'fc46e1'
          design_bg_color4_position_value: 75
          design_bg_color5_value: 'fc46e1'
          design_border_color_value: 'ffffff'
          design_slider_border_radius_value: 30
          design_slider_border_width_value: 3
          design_slider_shadow_left_value: 3
          design_slider_shadow_top_value: 3
          design_slider_shadow_size_value: 11
          design_shadow_color_value: '000,000,000'
          design_slider_shadow_opacity_value: 0.5
        }
        flags: {
          design_bg_color2_flag: false
          design_bg_color3_flag: false
          design_bg_color4_flag: false
        }
      }
      modifiables: {
        arrowWidth: {
          name: "Arrow's width"
          default: 37
          type: 'number'
          min: 1
          max: 99
          ja: {
            name: "矢印の幅"
          }
        }
      }
      methods : {
        scrollDraw: {
          actionType: 'scroll'
          scrollEnabledDirection: {
            top: true
            bottom: true
            left: false
            right: false
          }
          scrollForwardDirection: {
            top: false
            bottom: true
            left: false
            right: false
          }
          modifiables: {
            arrowWidth: {
              name: "Arrow's width"
              type: 'number'
              min: 1
              max: 99
              varAutoChange: true
              ja :{
                name: "矢印の幅"
              }
            }
          }
          options: {
            id: 'drawScroll'
            name: 'Drawing by scroll'
            desc: "Draw by scroll action"
            ja: {
              name: 'スクロールで描画'
              desc: 'スクロールで矢印を描画'
            }
          }
        }
        changeColorClick: {
          actionType: 'click'
          options: {
            id: 'changeColorClick_Design'
            name: 'Changing color by click'
          }
        }
      }
    }

  # コンストラクタ
  # @param [Array] cood 座標
  constructor : (cood = null)->
    super(cood)
    # @property [Array] direction 矢印の進行方向
    @_direction = {x: 0, y: 0}
    # @property [Array] _coodHeadPart 矢印の頭部の座標
    @_coodHeadPart = []
    # @property [Array] _coodLeftBodyPart 矢印の体左部分の座標
    @_coodLeftBodyPart = []
    # @property [Array] _coodRightBodyPart 矢印の体右部分の座標
    @_coodRightBodyPart = []
    # @property [Int] header_width 矢印の頭の幅
    @header_width = HEADER_WIDTH
    # @property [Int] header_height 矢印の頭の長さ
    @header_height = HEADER_HEIGHT
    # @property [Int] padding_size CanvasのPadding
    @padding_size = @header_width
    # @property [Array] drawCoodRegist 矢印のドラッグ座標(描画時のみ使用)
    # @private
    @_drawCoodRegist = []

  # パスの描画
  # @param [Array] moveCood 画面ドラッグ座標
  drawPath : (moveCood) ->
    _calDrection.call(@, @_drawCoodRegist[@_drawCoodRegist.length - 1], moveCood)
    @_drawCoodRegist.push(moveCood)

    # 尾の部分の座標を計算
    _calTailDrawPath.call(@)
    # 体の部分の座標を計算
    _calBodyPath.call(@, moveCood)
    # 頭の部分の座標を計算
    _calTrianglePath.call(@, @_coodLeftBodyPart[@_coodLeftBodyPart.length - 1], @_coodRightBodyPart[@_coodRightBodyPart.length - 1])
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
    super(show)
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

    if @setupDragAndResizeEvents?
      # ドラッグ & リサイズイベント設定
      @setupDragAndResizeEvents()

  # パスの情報をリセット
  resetDrawPath: ->
    @_coodHeadPart = []
    @_coodLeftBodyPart = []
    @_coodRightBodyPart = []
    @_drawCoodRegist = []

  # イベント前の表示状態にする
  updateEventBefore: ->
    super()
    methodName = @getEventMethodName()
    if methodName == 'scrollDraw'
      @reDraw(false)

  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    methodName = @getEventMethodName()
    if methodName == 'scrollDraw'
      @reDraw()

  # スクロールイベント ※アクションイベント
  # @param [Integer] scrollValue スクロール値
  scrollDraw : (opt) ->
    #console.log("scrollY: #{@scrollValue}")
    r = opt.step / @stepMax()

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
    @_direction = {x: x, y: y}

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
      x: Math.cos(sita) * (@header_width + @arrowWidth) / 2.0 + rightCood.x
      y: Math.sin(sita) * (@header_width + @arrowWidth) / 2.0 + rightCood.y

    sitaRight = sita + Math.PI

    rightTop =
      x: Math.cos(sitaRight) * (@header_width - @arrowWidth) / 2.0 + rightCood.x
      y: Math.sin(sitaRight) * (@header_width - @arrowWidth) / 2.0 + rightCood.y

    sitaTop = sita + Math.PI / 2.0

    mid =
      x: (leftCood.x + rightCood.x) / 2.0
      y: (leftCood.y + rightCood.y) / 2.0
    top =
      x: Math.cos(sitaTop) * @header_height + mid.x
      y: Math.sin(sitaTop) * @header_height + mid.y

    @_coodHeadPart = [rightTop, top, leftTop]

  # 矢印の尾を作成
  # @private
  _calTailDrawPath = ->
    ### 検証 ###
    _validate = ->
      return @_drawCoodRegist.length == 2

    if !_validate.call(@)
      return

    locTail = @_drawCoodRegist[0]
    locSub = @_drawCoodRegist[1]

    # 座標を保存
    rad = Math.atan2(locSub.y - locTail.y, locSub.x - locTail.x)
    arrowHalfWidth = @arrowWidth / 2.0
    @_coodRightBodyPart.push({x: -(Math.sin(rad) * arrowHalfWidth) + locTail.x, y: Math.cos(rad) * arrowHalfWidth + locTail.y})
    @_coodLeftBodyPart.push({x: Math.sin(rad) * arrowHalfWidth + locTail.x, y: -(Math.cos(rad) * arrowHalfWidth) + locTail.y})

  # 矢印の本体を作成
  # @private
  _calBodyPath = ->
    ### 検証 ###
    _validate = ->
      return @_drawCoodRegist.length >= 3

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

      arrowHalfWidth = @arrowWidth / 2.0
      leftX = parseInt(Math.cos(rad + Math.PI) * arrowHalfWidth + center.x)
      leftY = parseInt(Math.sin(rad + Math.PI) * arrowHalfWidth + center.y)
      rightX = parseInt(Math.cos(rad) * arrowHalfWidth + center.x)
      rightY = parseInt(Math.sin(rad) * arrowHalfWidth + center.y)

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
        if @_direction.x < 0 &&
          beforeCood.x < cood.x
            cood.x = beforeCood.x
        else if @_direction.x > 0 &&
          beforeCood.x > cood.x
            cood.x = beforeCood.x
        if @_direction.y < 0 &&
          beforeCood.y < cood.y
            cood.y = beforeCood.y
        else if @_direction.y > 0 &&
          beforeCood.y > cood.y
            cood.y = beforeCood.y
        return cood

      beforeLeftCood = @_coodLeftBodyPart[@_coodLeftBodyPart.length - 1]
      beforeRightCood = @_coodRightBodyPart[@_coodRightBodyPart.length - 1]
      leftCood = _suitCood.call(@, cood.coodLeftPart, beforeLeftCood)
      rightCood = _suitCood.call(@, cood.coodRightPart, beforeRightCood)

      ret =
        coodLeftPart: leftCood
        coodRightPart: rightCood
      return ret

    if !_validate.call(@)
      return

    locLeftBody = @_coodLeftBodyPart[@_coodLeftBodyPart.length - 1]
    locRightBody = @_coodRightBodyPart[@_coodRightBodyPart.length - 1]
    centerBodyCood = _calCenterBodyCood.call(@, @_drawCoodRegist[@_drawCoodRegist.length - 3], @_drawCoodRegist[@_drawCoodRegist.length - 2], @_drawCoodRegist[@_drawCoodRegist.length - 1])
    centerBodyCood = _suitCoodBasedDirection.call(@, centerBodyCood)
    #    console.log('Left')
    #    _coodLog.call(@, locLeftBody, 'moveTo')
    #    _coodLog.call(@, centerBodyCood.coodLeftPart, 'lineTo')
    #    console.log('Right')
    #    _coodLog.call(@, locRightBody, 'moveTo')
    #    _coodLog.call(@, centerBodyCood.coodRightPart, 'lineTo')

    @_coodLeftBodyPart.push(centerBodyCood.coodLeftPart)
    @_coodRightBodyPart.push(centerBodyCood.coodRightPart)

  # 座標をCanvasに描画
  # @private
  # @param [Object] dc CanvasContext(isBaseCanvasがfalseの場合使用)
  _drawCoodToCanvas = (dc = null) ->
    drawingContext = null
    if dc?
      drawingContext = dc
    else
      drawingContext = window.drawingContext
    if @_coodLeftBodyPart.length <= 0 || @_coodRightBodyPart.length <= 0
      # 尾が描かれてない場合
      return

    drawingContext.moveTo(@_coodLeftBodyPart[@_coodLeftBodyPart.length - 1].x, @_coodLeftBodyPart[@_coodLeftBodyPart.length - 1].y)
    if @_coodLeftBodyPart.length >= 2
      for i in [@_coodLeftBodyPart.length - 2 .. 0]
        drawingContext.lineTo(@_coodLeftBodyPart[i].x, @_coodLeftBodyPart[i].y)
    for i in [0 .. @_coodRightBodyPart.length - 1]
      drawingContext.lineTo(@_coodRightBodyPart[i].x, @_coodRightBodyPart[i].y)
    for i in [0 .. @_coodHeadPart.length - 1]
      drawingContext.lineTo(@_coodHeadPart[i].x, @_coodHeadPart[i].y)
    drawingContext.closePath()

  # 座標を基底Canvasに描画
  _drawCoodToBaseCanvas = ->
    _drawCoodToCanvas.call(@)

  # 座標を新しいCanvasに描画
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
    @applyDesignTool()

  # 座標のログを表示
  # @private
  _coodLog = (cood, name) ->
    if window.debug
      console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y)

  # 描画(パス+線)
  # @param [Array] moveCood 画面ドラッグ座標
  draw: (moveCood) ->
    @coodRegist.push(moveCood)
    # 描画範囲の更新
    _updateArrowRect.call(@, moveCood)
    # パスの描画
    @drawPath(moveCood)
    # 描画した矢印をクリア
    @restoreDrawingSurface(@itemSize)
    # 線の描画
    @drawLine()

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

Common.setClassToMap(false, PreloadItemArrow.ITEM_ACCESS_TOKEN, PreloadItemArrow)

if window.itemInitFuncList? && !window.itemInitFuncList[PreloadItemArrow.ITEM_ACCESS_TOKEN]?
  EventConfig.addEventConfigContents(PreloadItemArrow.ITEM_ACCESS_TOKEN)
  console.log('arrow loaded')
  window.itemInitFuncList[PreloadItemArrow.ITEM_ACCESS_TOKEN] = (option = {}) ->
    if window.isWorkTable && PreloadItemArrow.jsLoaded?
      PreloadItemArrow.jsLoaded(option)
    #JS読み込み完了後の処理
    if window.debug
      console.log('arrow init Finish')
