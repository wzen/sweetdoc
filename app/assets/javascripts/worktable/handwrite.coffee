class Handwrite

  # 手書きイベント初期化
  @initHandwrite = ->
    drag = false
    click = false
    lastX = null; lastY = null
    item = null
    enableMoveEvent = true
    queueLoc = null
    zindex = Constant.Zindex.EVENTBOTTOM + window.scrollInside.children().length + 1
    MOVE_FREQUENCY = 7
    @zoom = 1

    # ウィンドウ座標からCanvas座標に変換する
    # @param [Object] canvas Canvas
    # @param [Int] x x座標
    # @param [Int] y y座標
    _windowToCanvas = (canvas, x, y) ->
      bbox = canvas.getBoundingClientRect()
      return {x: x - bbox.left * (canvas.width  / bbox.width), y: y - bbox.top  * (canvas.height / bbox.height)}

    # マウスダウン時の描画イベント
    # @param [Array] loc Canvas座標
    _mouseDownDrawing = (loc) ->
      # プレビューを停止して再描画
      WorktableCommon.reDrawAllInstanceItemIfChanging()
      if selectItemMenu?
        item = new (Common.getClassFromMap(false, selectItemMenu))(loc)
        window.instanceMap[item.id] = item
        item.saveDrawingSurface()
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        item.startDraw()

    # マウスドラッグ時の描画イベント
    # @param [Array] loc Canvas座標
    _mouseMoveDrawing = (loc) ->
      if item?
        if enableMoveEvent
          enableMoveEvent = false
          drag = true
          item.draw(loc)

          # 待ちキューがある場合はもう一度実行
          if queueLoc != null
            q = queueLoc
            queueLoc = null
            item.draw(q)

          enableMoveEvent = true
        else
          # 待ちキューに保存
          queueLoc = loc

    # マウスアップ時の描画イベント
    _mouseUpDrawing = ->
      if item?
        item.restoreAllDrawingSurface()
        item.endDraw(zindex)
        item.setupDragAndResizeEvents()
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        item.saveObj(true)
        zindex += 1

    # 手書きイベントを設定
    do =>

      # 画面のウィンドウ座標からCanvas座標に変換
      # @param [Array] e ウィンドウ座標
      # @return [Array] Canvas座標
      _calcCanvasLoc = (e) ->
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
      drawingCanvas.onmousedown = (e) ->
        if e.which == 1 #左クリック
          @zoom = PageValue.getGeneralPageValue(PageValue.Key.zoom())
          loc = _calcCanvasLoc.call(@, e)
          _saveLastLoc(loc)
          click = true
          if mode == Constant.Mode.DRAW
            e.preventDefault()
            _mouseDownDrawing(loc)
          else if mode == Constant.Mode.OPTION
            # サイドバーを閉じる
            Sidebar.closeSidebar()
            # モードを変更以前に戻す
            WorktableCommon.putbackMode()

      # マウスドラッグイベント
      # @param [Array] e ウィンドウ座標
      drawingCanvas.onmousemove = (e) ->
        if e.which == 1 #左クリック
          loc = _calcCanvasLoc.call(@, e)
          if click &&
              Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY
            if mode == Constant.Mode.DRAW
              e.preventDefault()
              _mouseMoveDrawing(loc)
            _saveLastLoc(loc)

      # マウスアップイベント
      # @param [Array] e ウィンドウ座標
      drawingCanvas.onmouseup = (e) ->
        if e.which == 1 #左クリック
          if drag && mode == Constant.Mode.DRAW
            e.preventDefault()
            _mouseUpDrawing()
        drag = false
        click = false
