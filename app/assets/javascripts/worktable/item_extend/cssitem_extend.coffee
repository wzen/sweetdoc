# CSS
WorkTableCssItemExtend =

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
    @applyDefaultDesign()
    @makeCss(true)
    @drawAndMakeConfigsAndWritePageValue(show)
    return true

  # デザイン変更を反映
  applyDesignStyleChange: (designKeyName, value, doStyleSave = true) ->
    cssCodeElement = $('.' + designKeyName + '_value', @cssCode)
    cssCodeElement.html(value)
    @applyDesignChange(doStyleSave)

  # グラデーションデザイン変更を反映
  applyGradientStyleChange: (index, designKeyName, value, doStyleSave = true) ->
    position = $('.design_bg_color' + (index + 2) + '_position', @cssCode)
    position.html(("0" + value).slice(-2))
    @applyDesignStyleChange(designKeyName, value, doStyleSave)

  # グラデーション方向変更を反映
  applyGradientDegChange: (designKeyName, value, doStyleSave = true) ->
    webkitDeg = {0 : 'left top, left bottom', 45 : 'right top, left bottom', 90 : 'right top, left top', 135 : 'right bottom, left top', 180 : 'left bottom, left top', 225 : 'left bottom, right top', 270 : 'left top, right top', 315: 'left top, right bottom'}
    webkitValueElement = $('.' + className + '_value_webkit', @cssCode)
    webkitValueElement.html(webkitDeg[ui.value])
    @applyDesignStyleChange(designKeyName, value, doStyleSave)

  applyGradientStepChange: (target, doStyleSave = true) ->
    @changeGradientShow(target)
    stepValue = parseInt($(target).val())
    for i in [2 .. 4]
      className = 'design_bg_color' + i
      flag = $("." + className + "_flag", @cssRoot)
      cache = $("." + className + "_cache", @cssRoot)
      if i > stepValue - 1
        mh = flag.html()
        if mh.length > 0
          cache.html(mh)
        $(flag).empty()
      else
        flag.html(cache.html())
    @applyDesignChange(doStyleSave)

  applyColorChangeByPicker: (designKeyName, value, doStyleSave = true) ->
    codeEmt = $(".#{designKeyName}_value", @cssCode)
    codeEmt.text(value)
    @applyDesignChange(doStyleSave)

