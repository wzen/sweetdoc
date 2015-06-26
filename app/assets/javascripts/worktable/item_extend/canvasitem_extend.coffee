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

  # ドラッグ時のイベント
  drag: ->
    element = $('#' + @id)
    @itemSize.x = element.position().left
    @itemSize.y = element.position().top
    console.log("drag: itemSize: #{JSON.stringify(@itemSize)}")

  # リサイズ時のイベント
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
    console.log("resize: itemSize: #{JSON.stringify(@itemSize)}")

  # 履歴データを取得
  # @param [ItemActionType] action アクション種別
  getHistoryObj: (action) ->
    obj = {
      obj: @
      action : action
      itemSize: makeClone(@itemSize)
      scale: makeClone(@scale)
    }
    console.log("getHistory: scale:#{@scale.w},#{@scale.h}")
    return obj

  # 履歴データを設定
  # @param [Array] historyObj 履歴オブジェクト
  setHistoryObj: (historyObj) ->
    @itemSize = makeClone(historyObj.itemSize)
    @scale = makeClone(historyObj.scale)
    console.log("setHistoryObj: itemSize: #{JSON.stringify(@itemSize)}")