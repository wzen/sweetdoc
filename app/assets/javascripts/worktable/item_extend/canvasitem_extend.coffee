# Canvas
WorkTableCanvasItemExtend =
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

  # 描画終了
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true) ->
    @zindex = zindex

    # TODO: 汎用的に修正
    # 座標を新規キャンパス用に修正
    do =>
      @coodRegist.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodLeftBodyPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodRightBodyPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodHeadPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )

    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()
    @drawAndMakeConfigsAndWritePageValue(show)
    # Canvas状態を保存
    @saveNewDrawedSurface()
    return true