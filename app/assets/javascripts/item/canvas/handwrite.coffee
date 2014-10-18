$ ->
  dragging = false
  lastX = null; lastY = null
  item = null
  enableMoveEvent = true
  queueLoc = null
  window.contanerStates = new ContainerState()
  zindex = 1

  windowToCanvas = (canvas, x, y) ->
    bbox = canvas.getBoundingClientRect()
    return {x: x - bbox.left * (canvas.width  / bbox.width), y: y - bbox.top  * (canvas.height / bbox.height)}

  mouseDownOrTouchStartInDrawingCanvas = (loc) ->
    dragging = true;

    if selectItemMenu == Constant.ItemType.ARROW
      item = new Arrow(loc)
    else if selectItemMenu == Constant.ItemType.BUTTON
      item = new Button(loc)

    item.saveDrawingSurface()
    item.startDraw()

    lastX = loc.x;
    lastY = loc.y;

  mouseMoveOrTouchMoveInDrawingCanvas = (loc) ->
    # 前と同じ座標の時は無視
    if dragging && (loc.x != lastX || loc.y != lastY)
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
      item.endDraw(loc, contanerStates, zindex)
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



