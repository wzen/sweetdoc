$ ->
  dragging = false
  lastX = null; lastY = null
  item = null
  enableMoveEvent = true
  queueLoc = null
  zindex = 1
  MOVE_FREQUENCY = 7

  windowToCanvas = (canvas, x, y) ->
    bbox = canvas.getBoundingClientRect()
    return {x: x - bbox.left * (canvas.width  / bbox.width), y: y - bbox.top  * (canvas.height / bbox.height)}

  mouseDownOrTouchStartInDrawingCanvas = (loc) ->
    dragging = true;

    if selectItemMenu == Constant.ItemType.ARROW
      item = new ArrowItem(loc)
    else if selectItemMenu == Constant.ItemType.BUTTON
      item = new ButtonItem(loc)

    item.saveDrawingSurface()
    item.startDraw()

    lastX = loc.x;
    lastY = loc.y;

  mouseMoveOrTouchMoveInDrawingCanvas = (loc) ->
    if dragging && Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY) >= MOVE_FREQUENCY
      if enableMoveEvent
        enableMoveEvent = false

        item.draw(loc)

        # 待ちキューがある場合はもう一度実行
        if queueLoc != null
          q = queueLoc
          queueLoc = null
          item.draw(q)

        enableMoveEvent = true
        lastX = loc.x
        lastY = loc.y
      else
        # 待ちキューに保存
        queueLoc = loc

  mouseUpOrTouchEndInDrawingCanvas = (loc) ->
    item.restoreAllDrawingSurface()
    if dragging
      item.endDraw(loc, zindex)
      zindex += 1
    dragging = false

  handwrite = ->
    drawingCanvas.onmousedown = (e) ->
      if e.which == 1 #左クリック
        if mode == Constant.MODE.DRAW
          x = e.x || e.clientX
          y = e.y || e.clientY
          loc = windowToCanvas(drawingCanvas, x, y)
          e.preventDefault()
          mouseDownOrTouchStartInDrawingCanvas(loc)
        else if mode == Constant.MODE.OPTION
          # サイドバーを閉じる
          closeSidebar()
          changeMode(Constant.MODE.EDIT)

    drawingCanvas.onmousemove = (e) ->
      if e.which == 1 #左クリック
        if mode == Constant.MODE.DRAW
          x = e.x || e.clientX
          y = e.y || e.clientY
          loc = windowToCanvas(drawingCanvas, x, y)
          e.preventDefault()
          mouseMoveOrTouchMoveInDrawingCanvas(loc)

    drawingCanvas.onmouseup = (e) ->
      if e.which == 1 #左クリック
        if mode == Constant.MODE.DRAW
          x = e.x || e.clientX
          y = e.y || e.clientY
          loc = windowToCanvas(drawingCanvas, x, y)
          e.preventDefault()
          mouseUpOrTouchEndInDrawingCanvas(loc)

  handwrite()



