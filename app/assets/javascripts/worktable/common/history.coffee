class OperationHistory

  class @Key
    @INSTANCE = 'iv'
    @EVENT = 'ev'

  # 操作履歴を追加
  # @param [Boolean] isInit 初期化処理か
  @add = (isInit = false) ->
    if window.operationHistoryIndex? && !isInit
      window.operationHistoryIndex = (window.operationHistoryIndex + 1) % window.operationHistoryLimit
    else
      window.operationHistoryIndex = 0
    window.operationHistoryTailIndex = window.operationHistoryIndex
    obj = {}
    obj[@Key.INSTANCE] = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
    obj[@Key.EVENT] = PageValue.getEventPageValue(PageValue.Key.E_PREFIX)
    window.operationHistory[window.operationHistoryIndex] = obj

  # 操作履歴を取り出し
  # @return [Boolean] 処理したか
  _pop = ->
    hIndex = window.operationHistoryIndex
    if hIndex <= 0
      hIndex = window.operationHistoryLimit - 1
    else
      hIndex -= 1
    obj = window.operationHistory[hIndex]
    if obj?
      # 全描画を消去
      WorktableCommon.removeAllItemAndEvent()

      instancePageValue = obj[@Key.INSTANCE]
      eventPageValue = obj[@Key.EVENT]
      if instancePageValue?
        PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, instancePageValue)
      if eventPageValue?
        PageValue.setEventPageValueByRootHash(eventPageValue)
      window.operationHistoryIndex = hIndex

      # キャッシュ保存 & 描画
      PageValue.adjustInstanceAndEvent()
      LocalStorage.saveEventPageValue()
      WorktableCommon.drawAllItemFromEventPageValue()
      return true
    else
      return false

  # 操作履歴を取り出してIndexを進める(redo処理)
  # @return [Boolean] 処理したか
  _popRedo = ->
    hIndex = (window.operationHistoryIndex + 1) % window.operationHistoryLimit
    obj = window.operationHistory[hIndex]
    if obj?
      # 全描画を消去
      WorktableCommon.removeAllItemAndEvent()

      instancePageValue = obj[@Key.INSTANCE]
      eventPageValue = obj[@Key.EVENT]
      if instancePageValue?
        PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, instancePageValue)
      if eventPageValue?
        PageValue.setEventPageValueByRootHash(eventPageValue)
      window.operationHistoryIndex = hIndex

      # キャッシュ保存 & 描画
      PageValue.adjustInstanceAndEvent()
      LocalStorage.saveEventPageValue()
      WorktableCommon.drawAllItemFromEventPageValue()
      return true
    else
      return false

  # undo処理
  @undo = ->
    nextTailIndex = (window.operationHistoryTailIndex + 1) % window.operationHistoryLimit
    if nextTailIndex == window.operationHistoryIndex || !_pop.call(@)
      Message.flushWarn("Can't Undo")
      return

  # redo処理
  @redo = ->
    if window.operationHistoryTailIndex == window.operationHistoryIndex || !_popRedo.call(@)
      Message.flushWarn("Can't Redo")
      return
