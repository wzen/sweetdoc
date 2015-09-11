class OperationHistory

  # @property OPERATION_STORE_MAX 操作履歴保存最大数
  @OPERATION_STORE_MAX = 30

  class @Key
    @INSTANCE = 'iv'
    @EVENT = 'ev'

  # 操作履歴を追加
  # @param [Boolean] isInit 初期化処理か
  @add = (isInit = false) ->
    if window.operationHistoryIndexes[PageValue.getPageNum()]? && !isInit
      window.operationHistoryIndexes[PageValue.getPageNum()] = (window.operationHistoryIndexes[PageValue.getPageNum()] + 1) % @OPERATION_STORE_MAX
    else
      window.operationHistoryIndexes[PageValue.getPageNum()] = 0
    window.operationHistoryTailIndex = window.operationHistoryIndexes[PageValue.getPageNum()]
    obj = {}
    obj[@Key.INSTANCE] = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix())
    obj[@Key.EVENT] = PageValue.getEventPageValue(PageValue.Key.eventPagePrefix())
    if !window.operationHistories[PageValue.getPageNum()]?
      window.operationHistories[PageValue.getPageNum()] = []
    window.operationHistories[PageValue.getPageNum()][window.operationHistoryIndexes[PageValue.getPageNum()]] = obj

  # 操作履歴を取り出し
  # @return [Boolean] 処理したか
  _pop = ->
    if !window.operationHistoryIndexes[PageValue.getPageNum()]?
      return false

    hIndex = window.operationHistoryIndexes[PageValue.getPageNum()]
    if hIndex <= 0
      hIndex = @OPERATION_STORE_MAX - 1
    else
      hIndex -= 1

    if window.operationHistories[PageValue.getPageNum()]? && window.operationHistories[PageValue.getPageNum()][hIndex]?
      obj = window.operationHistories[PageValue.getPageNum()][hIndex]
      # 全描画を消去
      WorktableCommon.removeAllItemAndEventOnThisPage()

      instancePageValue = obj[@Key.INSTANCE]
      eventPageValue = obj[@Key.EVENT]
      if instancePageValue?
        PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue)
      if eventPageValue?
        PageValue.setEventPageValueByPageRootHash(eventPageValue)
      window.operationHistoryIndexes[PageValue.getPageNum()] = hIndex

      # キャッシュ保存 & 描画
      PageValue.adjustInstanceAndEventOnPage()
      LocalStorage.saveAllPageValues()
      WorktableCommon.drawAllItemFromInstancePageValue()
      return true
    else
      return false

  # 操作履歴を取り出してIndexを進める(redo処理)
  # @return [Boolean] 処理したか
  _popRedo = ->
    if !window.operationHistoryIndexes[PageValue.getPageNum()]?
      return false

    hIndex = (window.operationHistoryIndexes[PageValue.getPageNum()] + 1) % @OPERATION_STORE_MAX
    if window.operationHistories[PageValue.getPageNum()]? && window.operationHistories[PageValue.getPageNum()][hIndex]?
      obj = window.operationHistories[PageValue.getPageNum()][hIndex]
      # 全描画を消去
      WorktableCommon.removeAllItemAndEventOnThisPage()

      instancePageValue = obj[@Key.INSTANCE]
      eventPageValue = obj[@Key.EVENT]
      if instancePageValue?
        PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue)
      if eventPageValue?
        PageValue.setEventPageValueByPageRootHash(eventPageValue)
      window.operationHistoryIndexes[PageValue.getPageNum()] = hIndex

      # キャッシュ保存 & 描画
      PageValue.adjustInstanceAndEventOnPage()
      LocalStorage.saveAllPageValues()
      WorktableCommon.drawAllItemFromInstancePageValue()
      return true
    else
      return false

  # undo処理
  @undo = ->
    nextTailIndex = (window.operationHistoryTailIndex + 1) % @OPERATION_STORE_MAX

    if !window.operationHistoryIndexes[PageValue.getPageNum()]? || nextTailIndex == window.operationHistoryIndexes[PageValue.getPageNum()] || !_pop.call(@)
      Message.flushWarn("Can't Undo")

  # redo処理
  @redo = ->
    if !window.operationHistoryIndexes[PageValue.getPageNum()]? || window.operationHistoryTailIndex == window.operationHistoryIndexes[PageValue.getPageNum()] || !_popRedo.call(@)
      Message.flushWarn("Can't Redo")
