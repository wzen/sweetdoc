# CSS
WorkTableCssItemExtend =
  # リサイズ時のイベント
  resize: ->
    element = $('#' + @id)
    @itemSize.w = element.width()
    @itemSize.h = element.height()

  # ドラッグ描画
  # @param [Array] cood 座標
  draw: (cood) ->
    if @itemSize != null
      @restoreDrawingSurface(@itemSize)

    @itemSize = {x:null,y:null,w:null,h:null}
    @itemSize.w = Math.abs(cood.x - @moveLoc.x);
    @itemSize.h = Math.abs(cood.y - @moveLoc.y);
    if cood.x > @moveLoc.x
      @itemSize.x = @moveLoc.x
    else
      @itemSize.x = cood.x
    if cood.y > @moveLoc.y
      @itemSize.y = @moveLoc.y
    else
      @itemSize.y = cood.y
    drawingContext.strokeRect(@itemSize.x, @itemSize.y, @itemSize.w, @itemSize.h)

  # 描画終了
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true) ->
    @zindex = zindex
    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()
    @makeCss(true)
    @drawAndMakeConfigsAndWritePageValue(show)
    return true