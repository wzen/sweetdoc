class Handwrite

  #@item = null
  @drag = false
  @click = false
  @enableMoveEvent = true
  @queueLoc = null
  @zindex = null

  # 手書きイベント初期化
  @initHandwrite = ->
    @drag = false
    @click = false
    window.handwritingItem = null
    lastX = null; lastY = null
    @enableMoveEvent = true
    @queueLoc = null
    MOVE_FREQUENCY = 7

    # ウィンドウ座標からCanvas座標に変換する
    # @param [Object] canvas Canvas
    # @param [Int] x x座標
    # @param [Int] y y座標
    _windowToCanvas = (canvas, x, y) ->
      bbox = canvas.getBoundingClientRect()
      return {x: x - bbox.left * (canvas.width  / bbox.width), y: y - bbox.top  * (canvas.height / bbox.height)}

    # 手書きイベントを設定
    do =>
      # 画面のウィンドウ座標からCanvas座標に変換
      # @param [Array] e ウィンドウ座標
      # @return [Array] Canvas座標
      _calcCanvasLoc = (e) =>
        worktableScale = WorktableCommon.getWorktableViewScale()
        x = (e.x || e.clientX) / worktableScale
        y = (e.y || e.clientY) / worktableScale
        return _windowToCanvas(drawingCanvas, x, y)

      # 座標の状態を保存
      # @param [Array] loc 座標
      _saveLastLoc = (loc) ->
        lastX = loc.x
        lastY = loc.y

      # マウスダウンイベント
      # @param [Array] e ウィンドウ座標
      drawingCanvas.onmousedown = (e) =>
        e.preventDefault()
        e.stopPropagation()
        if @drag && @click
          # 描画に失敗した場合は一旦削除
          drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height)
          @drag = false
          @click = false
        if e.which == 1 #左クリック
          @zindex = constant.Zindex.EVENTBOTTOM + window.scrollInside.children().length + 1
          loc = _calcCanvasLoc.call(@, e)
          _saveLastLoc(loc)
          @click = true
          if @isDrawMode(@)
            e.preventDefault()
            @mouseDownDrawing(loc)

      # マウスドラッグイベント
      # @param [Array] e ウィンドウ座標
      drawingCanvas.onmousemove = (e) =>
        e.preventDefault()
        e.stopPropagation()
        if e.which == 1 #左クリック
          loc = _calcCanvasLoc.call(@, e)
          if @click &&
              Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY
            if @isDrawMode(@)
              e.preventDefault()
              @mouseMoveDrawing(loc)
            _saveLastLoc(loc)

      # マウスアップイベント
      # @param [Array] e ウィンドウ座標
      drawingCanvas.onmouseup = (e) =>
        e.preventDefault()
        e.stopPropagation()
        if e.which == 1 #左クリック
          if @drag && @isDrawMode(@)
            e.preventDefault()
            @mouseUpDrawing()
        @drag = false
        @click = false

  # マウスダウン時の描画イベント
  # @param [Array] loc Canvas座標
  @mouseDownDrawing = (loc) ->
    if window.mode == constant.Mode.DRAW
      # 通常描画
      if selectItemMenu?
        # インスタンス作成
        window.handwritingItem = new (Common.getClassFromMap(selectItemMenu))(loc)
        window.instanceMap[window.handwritingItem.id] = window.handwritingItem
        window.handwritingItem.mouseDownDrawing()

  # マウスドラッグ時の描画イベント
  # @param [Array] loc Canvas座標
  @mouseMoveDrawing = (loc) ->
    if window.handwritingItem?
      if @enableMoveEvent
        @enableMoveEvent = false
        @drag = true
        window.handwritingItem.draw(loc)

        # 待ちキューがある場合はもう一度実行
        if @queueLoc != null
          q = @queueLoc
          @queueLoc = null
          window.handwritingItem.draw(q)

        @enableMoveEvent = true
      else
        # 待ちキューに保存
        @queueLoc = loc

  # マウスアップ時の描画イベント
  @mouseUpDrawing = ->
    if window.handwritingItem?
      window.handwritingItem.mouseUpDrawing(@zindex, =>
        @zindex += 1
        window.handwritingItem = null
      )

  @isDrawMode = ->
    return window.mode == constant.Mode.DRAW
