# Canvas
WorkTableCanvasItemExtend =
  # デザイン変更コンフィグを作成
  makeDesignConfig: ->
    @designConfigRoot = $('#' + @getDesignConfigId())
    if !@designConfigRoot? || @designConfigRoot.length == 0
      @designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', @getDesignConfigId())
      @designConfigRoot.removeClass('design_temp')
      @designConfigRoot.find('.canvas-config').css('display', '')
      @designConfigRoot.find('.css-config').remove()
      $('#design-config').append(@designConfigRoot)

  # ドラッグ中イベント
  drag: ->
    element = $('#' + @id)
    @itemSize.x = element.position().left
    @itemSize.y = element.position().top
    if window.debug
      console.log("drag: itemSize: #{JSON.stringify(@itemSize)}")

  # ドラッグ完了時イベント
  dragComplete: ->
    @saveObj()

  # リサイズ中イベント
  resize: ->
    canvas = $('#' + @canvasElementId())
    element = $('#' + @id)
    @scale.w = element.width() / @itemSize.w
    @scale.h = element.height() / @itemSize.h
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.scale(@scale.w, @scale.h)
    @drawNewCanvas()
    if window.debug
      console.log("resize: itemSize: #{JSON.stringify(@itemSize)}")

  # リサイズ完了時イベント
  resizeComplete: ->
    @saveObj()
