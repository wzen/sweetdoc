class Handwrite

  @item = null
  @drag = false
  @click = false
  @enableMoveEvent = true
  @queueLoc = null
  @zindex = null

  # 手書きイベント初期化
  @initHandwrite = ->
    @drag = false
    @click = false
    @item = null
    lastX = null; lastY = null
    @enableMoveEvent = true
    @queueLoc = null
    @zindex = Constant.Zindex.EVENTBOTTOM + window.scrollInside.children().length + 1
    MOVE_FREQUENCY = 7
    @zoom = 1

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
        x = (e.x || e.clientX) / @zoom
        y = (e.y || e.clientY) / @zoom
        return _windowToCanvas(drawingCanvas, x, y)

      # 座標の状態を保存
      # @param [Array] loc 座標
      _saveLastLoc = (loc) ->
        lastX = loc.x
        lastY = loc.y

      # マウスダウンイベント
      # @param [Array] e ウィンドウ座標
      drawingCanvas.onmousedown = (e) =>
        if e.which == 1 #左クリック
          @zoom = PageValue.getGeneralPageValue(PageValue.Key.zoom())
          loc = _calcCanvasLoc.call(@, e)
          _saveLastLoc(loc)
          @click = true
          if mode == Constant.Mode.DRAW
            e.preventDefault()
            @mouseDownDrawing(loc)

      # マウスドラッグイベント
      # @param [Array] e ウィンドウ座標
      drawingCanvas.onmousemove = (e) =>
        if e.which == 1 #左クリック
          loc = _calcCanvasLoc.call(@, e)
          if @click &&
              Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY
            if mode == Constant.Mode.DRAW
              e.preventDefault()
              @mouseMoveDrawing(loc)
            _saveLastLoc(loc)

      # マウスアップイベント
      # @param [Array] e ウィンドウ座標
      drawingCanvas.onmouseup = (e) =>
        if e.which == 1 #左クリック
          if @drag && mode == Constant.Mode.DRAW
            e.preventDefault()
            @mouseUpDrawing()
        @drag = false
        @click = false


  # マウスダウン時の描画イベント
  # @param [Array] loc Canvas座標
  @mouseDownDrawing = (loc) ->
    # プレビューを停止して再描画
    WorktableCommon.reDrawAllItemsFromInstancePageValueIfChanging()
    if selectItemMenu?
      # インスタンス作成
      @item = new (Common.getClassFromMap(false, selectItemMenu))(loc)
      window.instanceMap[@item.id] = @item
      @item.mouseDownDrawing()

  # マウスドラッグ時の描画イベント
  # @param [Array] loc Canvas座標
  @mouseMoveDrawing = (loc) ->
    if @item?
      if @enableMoveEvent
        @enableMoveEvent = false
        @drag = true
        @item.draw(loc)

        # 待ちキューがある場合はもう一度実行
        if @queueLoc != null
          q = @queueLoc
          @queueLoc = null
          @item.draw(q)

        @enableMoveEvent = true
      else
        # 待ちキューに保存
        @queueLoc = loc

  # マウスアップ時の描画イベント
  @mouseUpDrawing = ->
    if @item?
      @item.mouseUpDrawing(@zindex, =>
        @zindex += 1
      )
