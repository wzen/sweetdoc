class OperationHistory

  # @property OPERATION_STORE_MAX 操作履歴保存最大数
  @OPERATION_STORE_MAX = 30

  class @Key
    @INSTANCE = 'iv'
    @EVENT = 'ev'

  @operationHistoryIndex = ->
    pageNum = PageValue.getPageNum()
    forkNum = PageValue.getForkNum()
    return pageNum + '-' + forkNum

  # 操作履歴を追加
  # @param [Boolean] isInit 初期化処理か
  @add = (isInit = false) ->
    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は処理しない
      return

    if window.operationHistoryIndexes[@operationHistoryIndex()]? && !isInit
      window.operationHistoryIndexes[@operationHistoryIndex()] = (window.operationHistoryIndexes[@operationHistoryIndex()] + 1) % @OPERATION_STORE_MAX
    else
      window.operationHistoryIndexes[@operationHistoryIndex()] = 0
    window.operationHistoryTailIndexes[@operationHistoryIndex()] = window.operationHistoryIndexes[@operationHistoryIndex()]
    obj = {}
    obj[@Key.INSTANCE] = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix())
    obj[@Key.EVENT] = PageValue.getEventPageValue(PageValue.Key.eventPageMainRoot())
    if !window.operationHistories[@operationHistoryIndex()]?
      window.operationHistories[@operationHistoryIndex()] = []
    window.operationHistories[@operationHistoryIndex()][window.operationHistoryIndexes[@operationHistoryIndex()]] = obj

  # 操作履歴を取り出し
  # @return [Boolean] 処理したか
  _pop = ->
    if !window.operationHistoryIndexes[@operationHistoryIndex()]?
      return false

    hIndex = window.operationHistoryIndexes[@operationHistoryIndex()]
    if hIndex <= 0
      hIndex = @OPERATION_STORE_MAX - 1
    else
      hIndex -= 1

    if window.operationHistories[@operationHistoryIndex()]? && window.operationHistories[@operationHistoryIndex()][hIndex]?
      obj = window.operationHistories[@operationHistoryIndex()][hIndex]
      # 全描画を消去
      WorktableCommon.removeAllItemAndEventOnThisPage()

      instancePageValue = obj[@Key.INSTANCE]
      eventPageValue = obj[@Key.EVENT]
      if instancePageValue?
        PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue)
      if eventPageValue?
        PageValue.setEventPageValueByPageRootHash(eventPageValue)
      window.operationHistoryIndexes[@operationHistoryIndex()] = hIndex

      # キャッシュ保存 & 描画 & タイムライン更新
      PageValue.adjustInstanceAndEventOnPage()
      LocalStorage.saveAllPageValues()
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue()
      Timeline.refreshAllTimeline()
      return true
    else
      return false

  # 操作履歴を取り出してIndexを進める(redo処理)
  # @return [Boolean] 処理したか
  _popRedo = ->
    if !window.operationHistoryIndexes[@operationHistoryIndex()]?
      return false

    hIndex = (window.operationHistoryIndexes[@operationHistoryIndex()] + 1) % @OPERATION_STORE_MAX
    if window.operationHistories[@operationHistoryIndex()]? && window.operationHistories[@operationHistoryIndex()][hIndex]?
      obj = window.operationHistories[@operationHistoryIndex()][hIndex]
      # 全描画を消去
      WorktableCommon.removeAllItemAndEventOnThisPage()

      instancePageValue = obj[@Key.INSTANCE]
      eventPageValue = obj[@Key.EVENT]
      if instancePageValue?
        PageValue.setInstancePageValue(PageValue.Key.instancePagePrefix(), instancePageValue)
      if eventPageValue?
        PageValue.setEventPageValueByPageRootHash(eventPageValue)
      window.operationHistoryIndexes[@operationHistoryIndex()] = hIndex

      # キャッシュ保存 & 描画 & タイムライン更新
      PageValue.adjustInstanceAndEventOnPage()
      LocalStorage.saveAllPageValues()
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue()
      Timeline.refreshAllTimeline()
      return true
    else
      return false

  # undo処理
  @undo = ->
    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は処理しない
      return

    nextTailIndex = (window.operationHistoryTailIndexes[@operationHistoryIndex()] + 1) % @OPERATION_STORE_MAX
    if !window.operationHistoryIndexes[@operationHistoryIndex()]? || nextTailIndex == window.operationHistoryIndexes[@operationHistoryIndex()] || !_pop.call(@)
      Message.flushWarn("Can't Undo")

  # redo処理
  @redo = ->
    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は処理しない
      return

    if !window.operationHistoryIndexes[@operationHistoryIndex()]? || window.operationHistoryTailIndexes[@operationHistoryIndex()] == window.operationHistoryIndexes[@operationHistoryIndex()] || !_popRedo.call(@)
      Message.flushWarn("Can't Redo")

