# EventPageValue アイテム
class EPVItem extends EventPageValueBase
  @itemSize = 'item_size'

  # アイテムのデフォルトイベントをPageValueに書き込み
  # @param [Object] item アイテムオブジェクト
  # @return [String] エラーメッセージ
  @writeDefaultToPageValue = (item, teNum, distId) ->
    errorMes = ""
    writeValue = {}
    writeValue[@PageValueKey.DIST_ID] = distId
    writeValue[@PageValueKey.ID] = item.id
    writeValue[@PageValueKey.ITEM_ACCESS_TOKEN] = item.constructor.ITEM_ACCESS_TOKEN
    writeValue[@PageValueKey.ITEM_SIZE_DIFF] = item.itemSizeDiff
    writeValue[@PageValueKey.COMMON_EVENT_ID] = null
    writeValue[@PageValueKey.IS_COMMON_EVENT] = false
    writeValue[@PageValueKey.METHODNAME] = item.constructor.defaultMethodName()
    actionType = item.constructor.defaultActionType()
    writeValue[@PageValueKey.ACTIONTYPE] = actionType
    start = @getAllScrollLength()
    end = start + item.coodRegist.length
    if start > end
      start = null
      end = null
    writeValue[@PageValueKey.SCROLL_POINT_START] = start
    writeValue[@PageValueKey.SCROLL_POINT_END] = end
    writeValue[@PageValueKey.IS_SYNC] = false
    writeValue[@PageValueKey.SCROLL_ENABLED_DIRECTIONS] = item.constructor.defaultScrollEnabledDirection()
    writeValue[@PageValueKey.SCROLL_FORWARD_DIRECTIONS] = item.constructor.defaultScrollForwardDirection()
    writeValue[@PageValueKey.EVENT_DURATION] = item.constructor.defaultClickDuration()
    writeValue[@PageValueKey.VALUE] = item.constructor.defaultEventConfigValue()
    writeValue[@PageValueKey.MODIFIABLE_VARS] = {}

    if errorMes.length == 0
      # イベントとイベント数をPageValueに書き込み
      PageValue.setEventPageValue(PageValue.Key.eventNumber(teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.eventCount(), teNum)

      # Storageに保存
      LocalStorage.saveAllPageValues()

    return errorMes
