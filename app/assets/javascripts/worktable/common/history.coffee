# 操作履歴をプッシュ
# @param [ItemBase] obj アイテムオブジェクト
pushOperationHistory = (obj) ->
  operationHistory[operationHistoryIndex] = obj
  operationHistoryIndex += 1

# 操作履歴を取り出し
# @return [ItemBase] アイテムオブジェクト
popOperationHistory = ->
  operationHistoryIndex -= 1
  return operationHistory[operationHistoryIndex]

# 操作履歴を取り出してIndexを進める(redo処理)
# @return [ItemBase] アイテムオブジェクト
popOperationHistoryRedo = ->
  obj = operationHistory[operationHistoryIndex]
  operationHistoryIndex += 1
  return obj

# undo処理
undo = ->
  if operationHistoryIndex <= 0
    flushWarn("Can't Undo")
    return

  history = popOperationHistory()
  obj = history.obj
  pastOperationIndex = obj.popOhi()
  action = history.action
  if action == Constant.ItemActionType.MAKE
    # オブジェクトを消去
    obj.getJQueryElement().remove()
  else if action == Constant.ItemActionType.MOVE
    obj.getJQueryElement().remove()
    past = operationHistory[pastOperationIndex]
    obj = past.obj
    obj.setHistoryObj(past)
    obj.reDraw()
    console.log("undo: itemSize: #{JSON.stringify(obj.itemSize)}")
    setupEvents(obj)
    console.log("undo2: itemSize: #{JSON.stringify(obj.itemSize)}")

# redo処理
redo = ->
  if operationHistory.length <= operationHistoryIndex
    flushWarn("Can't Redo")
    return

  history = popOperationHistoryRedo()
  obj = history.obj
  obj.incrementOhiRegistIndex()
  action = history.action
  if action == Constant.ItemActionType.MAKE
    obj.setHistoryObj(history)
    obj.reDraw()
    setupEvents(obj)
  else if action == Constant.ItemActionType.MOVE
    obj.getJQueryElement().remove()
    obj.setHistoryObj(history)
    obj.reDraw()
    setupEvents(obj)