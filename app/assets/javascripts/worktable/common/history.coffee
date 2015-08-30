class OperationHistory

  class @Key
    @INSTANCE = 'iv'
    @EVENT = 'ev'

  # 操作履歴を追加
  # @param [Boolean] isInit 初期化処理か
  @add = (isInit = false) ->
    if window.operationHistoryIndexes[window.pageNum]? && !isInit
      window.operationHistoryIndexes[window.pageNum] = (window.operationHistoryIndexes[window.pageNum] + 1) % window.operationHistoryLimit
    else
      window.operationHistoryIndexes[window.pageNum] = 0
    window.operationHistoryTailIndex = window.operationHistoryIndexes[window.pageNum]
    obj = {}
    obj[@Key.INSTANCE] = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix())
    obj[@Key.EVENT] = PageValue.getEventPageValue(PageValue.Key.eventPagePrefix())
    if !window.operationHistories[window.pageNum]?
      window.operationHistories[window.pageNum] = []
    window.operationHistories[window.pageNum][window.operationHistoryIndexes[window.pageNum]] = obj

  # 操作履歴を取り出し
  # @return [Boolean] 処理したか
  _pop = ->
    if !window.operationHistoryIndexes[window.pageNum]?
      return false

    hIndex = window.operationHistoryIndexes[window.pageNum]
    if hIndex <= 0
      hIndex = window.operationHistoryLimit - 1
    else
      hIndex -= 1

    if window.operationHistories[window.pageNum]? && window.operationHistories[window.pageNum][hIndex]?
      obj = window.operationHistories[window.pageNum][hIndex]
      # 全描画を消去
      WorktableCommon.removeAllItemAndEventOnThisPage()

      instancePageValue = obj[@Key.INSTANCE]
      eventPageValue = obj[@Key.EVENT]
      if instancePageValue?
        PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue)
      if eventPageValue?
        PageValue.setEventPageValueByPageRootHash(eventPageValue)
      window.operationHistoryIndexes[window.pageNum] = hIndex

      # キャッシュ保存 & 描画
      PageValue.adjustInstanceAndEventOnThisPage()
      LocalStorage.saveEventPageValue()
      WorktableCommon.drawAllItemFromEventPageValue()
      return true
    else
      return false

  # 操作履歴を取り出してIndexを進める(redo処理)
  # @return [Boolean] 処理したか
  _popRedo = ->
    if !window.operationHistoryIndexes[window.pageNum]?
      return false

    hIndex = (window.operationHistoryIndexes[window.pageNum] + 1) % window.operationHistoryLimit
    if window.operationHistories[window.pageNum]? && window.operationHistories[window.pageNum][hIndex]?
      obj = window.operationHistories[window.pageNum][hIndex]
      # 全描画を消去
      WorktableCommon.removeAllItemAndEventOnThisPage()

      instancePageValue = obj[@Key.INSTANCE]
      eventPageValue = obj[@Key.EVENT]
      if instancePageValue?
        PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue)
      if eventPageValue?
        PageValue.setEventPageValueByPageRootHash(eventPageValue)
      window.operationHistoryIndexes[window.pageNum] = hIndex

      # キャッシュ保存 & 描画
      PageValue.adjustInstanceAndEventOnThisPage()
      LocalStorage.saveEventPageValue()
      WorktableCommon.drawAllItemFromEventPageValue()
      return true
    else
      return false

  # undo処理
  @undo = ->
    nextTailIndex = (window.operationHistoryTailIndex + 1) % window.operationHistoryLimit

    if !window.operationHistoryIndexes[window.pageNum]? || nextTailIndex == window.operationHistoryIndexes[window.pageNum] || !_pop.call(@)
      Message.flushWarn("Can't Undo")
      return

  # redo処理
  @redo = ->
    if !window.operationHistoryIndexes[window.pageNum]? || window.operationHistoryTailIndex == window.operationHistoryIndexes[window.pageNum] || !_popRedo.call(@)
      Message.flushWarn("Can't Redo")
      return