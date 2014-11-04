$ ->
  dragging = false
  clicking = false
  lastX = null; lastY = null
  item = null
  enableMoveEvent = true
  queueLoc = null
  zindex = 1
  MOVE_FREQUENCY = 7

  # ウィンドウ座標からCanvas座標に変換する
  # @param [Object] canvas Canvas
  # @param [Int] x x座標
  # @param [Int] y y座標
  windowToCanvas = (canvas, x, y) ->
    bbox = canvas.getBoundingClientRect()
    return {x: x - bbox.left * (canvas.width  / bbox.width), y: y - bbox.top  * (canvas.height / bbox.height)}

  # マウスダウン時の描画イベント
  # @param [Array] loc Canvas座標
  mouseDownDrawing = (loc) ->
    if selectItemMenu == Constant.ItemType.ARROW
      item = new ArrowItem(loc)
    else if selectItemMenu == Constant.ItemType.BUTTON
      item = new ButtonItem(loc)
    item.saveDrawingSurface()
    item.startDraw()

  # マウスドラッグ時の描画イベント
  # @param [Array] loc Canvas座標
  mouseMoveDrawing = (loc) ->
    if enableMoveEvent
      enableMoveEvent = false
      dragging = true
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
  # @param [Array] loc Canvas座標
  mouseUpDrawing = (loc) ->
    item.restoreAllDrawingSurface()
    item.endDraw(loc, zindex)
    zindex += 1

  # 手書きイベントを設定
  handwrite = ->

    # 画面のウィンドウ座標からCanvas座標に変換
    # @param [Array] e ウィンドウ座標
    # @return [Array] Canvas座標
    calcCanvasLoc = (e)->
      x = e.x || e.clientX
      y = e.y || e.clientY
      return windowToCanvas(drawingCanvas, x, y)

    # 座標の状態を保存
    # @param [Array] loc 座標
    saveLastLoc = (loc) ->
      lastX = loc.x
      lastY = loc.y

    # マウスダウンイベント
    # @param [Array] e ウィンドウ座標
    drawingCanvas.onmousedown = (e) ->
      if e.which == 1 #左クリック
        loc = calcCanvasLoc(e)
        saveLastLoc(loc)
        clicking = true
        if mode == Constant.MODE.DRAW
          e.preventDefault()
          mouseDownDrawing(loc)
        else if mode == Constant.MODE.OPTION
          # サイドバーを閉じる
          closeSidebar()
          changeMode(Constant.MODE.EDIT)

    # マウスドラッグイベント
    # @param [Array] e ウィンドウ座標
    drawingCanvas.onmousemove = (e) ->
      if e.which == 1 #左クリック
        loc = calcCanvasLoc(e)
        if clicking &&
          Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY
            if mode == Constant.MODE.DRAW
              e.preventDefault()
              mouseMoveDrawing(loc)
            saveLastLoc(loc)

    # マウスアップイベント
    # @param [Array] e ウィンドウ座標
    drawingCanvas.onmouseup = (e) ->
      if e.which == 1 #左クリック
        if dragging && mode == Constant.MODE.DRAW
          loc = calcCanvasLoc(e)
          e.preventDefault()
          mouseUpDrawing(loc)
      dragging = false
      clicking = false

  handwrite()



