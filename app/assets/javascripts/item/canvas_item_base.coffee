# Canvasアイテム
# @abstract
# @extend ItemBase
class CanvasItemBase extends ItemBase
  # コンストラクタ
  constructor: ->
    super()
    @_newDrawingSurfaceImageData = null
    @_newDrawedSurfaceImageData = null
    # @property [Array] scale 表示倍率
    @scale = {w:1.0, h:1.0}

  # CanvasのHTML要素IDを取得
  # @return [Int] Canvas要素ID
  canvasElementId: ->
    return @id + '_canvas'

  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (callback) ->
    # 新規キャンパス存在チェック
    canvas = document.getElementById(@canvasElementId())
    if canvas?
      # 存在している場合は追加しない
      callback()
      return

    contents = """
      <canvas id="#{@canvasElementId()}" class="canvas context_base" ></canvas>
    """
    @addContentsToScrollInside(contents, callback)

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

  # キャンパス初期化処理
  initCanvas: ->
    # 伸縮率を設定
    @setScale()

  # アイテム描画
  # @param [Boolean] show 要素作成後に表示するか
  itemDraw: (show = true) ->
    # キャンパスに対する初期化
    @initCanvas()

  # 新規キャンパスの画面を保存
  saveNewDrawingSurface : ->
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      @_newDrawingSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height)

  # 描画済みの新規キャンパスの画面を保存
  saveNewDrawedSurface : ->
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      @_newDrawedSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height)

  # 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawingSurface : ->
    if @_newDrawingSurfaceImageData?
      canvas = document.getElementById(@canvasElementId());
      if canvas?
        context = canvas.getContext('2d');
        context.putImageData(@_newDrawingSurfaceImageData, 0, 0)

  # 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawedSurface : ->
    if @_newDrawedSurfaceImageData
      canvas = document.getElementById(@canvasElementId());
      if canvas?
        context = canvas.getContext('2d');
        context.putImageData(@_newDrawedSurfaceImageData, 0, 0)

  # 描画を削除
  clearDraw: ->
    # 画面を保存
    @saveNewDrawingSurface()
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      context.clearRect(0, 0, canvas.width, canvas.height)
      # キャンパスに対する初期化
      @initCanvas()

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    element = $('#' + @id)
    element.css({width: w, height: h})
    canvas = $('#' + @canvasElementId())
    scaleW = element.width() / @itemSize.w
    scaleH = element.height() / @itemSize.h
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.scale(scaleW, scaleH)
    @scale.w = scaleW
    @scale.h = scaleH
    @drawNewCanvas()

  # アニメーション変更前のアイテムサイズ
  originalItemElementSize: ->
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(@event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    $.extend(true, obj, diff)
    itemSize = obj.itemSize
    originalScale = obj.scale
    return {
      x: itemSize.x
      y: itemSize.y
      w: itemSize.w * originalScale.w
      h: itemSize.h * originalScale.h
    }

  # CanvasにDesignToolの内容を反映
  applyDesignTool: ->
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')

    do =>
      # 背景色
      halfSlopLength = Math.sqrt(Math.pow(drawingCanvas.width / 2.0, 2) + Math.pow(drawingCanvas.height / 2.0, 2))
      deg = @designs.values.design_slider_gradient_deg_value
      #console.log("deg: #{deg}")
      pi = deg / 180.0 * Math.PI
      tanX = drawingCanvas.width * (if Math.sin(pi) >= 0 then Math.ceil(Math.sin(pi)) else Math.floor(Math.sin(pi)))
      tanY = drawingCanvas.height * (if Math.cos(pi) >= 0 then Math.ceil(Math.cos(pi)) else Math.floor(Math.cos(pi)))
      l1 = halfSlopLength * Math.cos(Math.abs((Math.atan2(tanX, tanY) * 180.0 / Math.PI) - deg) / 180.0 * Math.PI)
      #console.log("l1: #{l1}")
      centorCood = {x: drawingCanvas.width / 2.0, y : drawingCanvas.height / 2.0}
      startX = centorCood.x + parseInt((l1 * Math.sin(pi)))
      startY = centorCood.y - parseInt((l1 * Math.cos(pi)))
      endX = centorCood.x + parseInt((l1 * Math.sin(pi + Math.PI)))
      endY = centorCood.y - parseInt((l1 * Math.cos(pi + Math.PI)))
      #console.log("startX: #{startX}, startY: #{startY}, endX: #{endX}, endY: #{endY}")
      gradient = drawingContext.createLinearGradient(startX, startY, endX, endY)
      gradient.addColorStop(0,"##{@designs.values.design_bg_color1_value}")
      if @designs.flags.design_bg_color2_flag
        gradient.addColorStop(@designs.values.design_bg_color2_position_value / 100,"##{@designs.values.design_bg_color2_value}")
      if @designs.flags.design_bg_color3_flag
        gradient.addColorStop(@designs.values.design_bg_color3_position_value / 100,"##{@designs.values.design_bg_color3_value}")
      if @designs.flags.design_bg_color4_flag
        gradient.addColorStop(@designs.values.design_bg_color4_position_value / 100,"##{@designs.values.design_bg_color4_value}")
      gradient.addColorStop(1,"##{@designs.values.design_bg_color5_value}")
      drawingContext.fillStyle = gradient

    do =>
      # 影
      drawingContext.shadowColor = "rgba(#{@designs.values.design_shadow_color_value},#{@designs.values.design_slider_shadow_opacity_value})"
      drawingContext.shadowOffsetX = @designs.values.design_slider_shadow_left_value
      drawingContext.shadowOffsetY = @designs.values.design_slider_shadow_top_value
      drawingContext.shadowBlur = @designs.values.design_slider_shadow_size_value

    do =>
      # 線
      drawingContext.strokeStyle = "##{@designs.values.design_border_color_value}"
      drawingContext.lineWidth = @designs.values.design_slider_border_width_value
      drawingContext.miterLimit = @designs.values.design_slider_border_radius_value

    drawingContext.stroke()
    drawingContext.fill()

  if window.isWorkTable
    @include(canvasItemBaseWorktableExtend)