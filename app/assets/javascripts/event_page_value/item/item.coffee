# EventPageValue アイテム
class EPVItem extends EventPageValueBase
  @itemSize = 'item_size'

  # アイテムのデフォルトイベントをPageValueに書き込み
  # @param [Object] item アイテムオブジェクト
  # @return [String] エラーメッセージ
  @writeDefaultToPageValue = (item, teNum, distId) ->
    if window.isItemPreview
      # アイテムプレビュー時は暫定の値を入れる
      teNum = 1
      distId = Common.generateId()

    errorMes = ""
    writeValue = {}
    writeValue[@PageValueKey.DIST_ID] = distId
    writeValue[@PageValueKey.ID] = item.id
    writeValue[@PageValueKey.CLASS_DIST_TOKEN] = item.constructor.CLASS_DIST_TOKEN
    writeValue[@PageValueKey.ITEM_SIZE_DIFF] = {x: 0, y: 0, w: 0, h: 0}
    writeValue[@PageValueKey.DO_FOCUS] = true
    writeValue[@PageValueKey.IS_COMMON_EVENT] = false
    writeValue[@PageValueKey.FINISH_PAGE] = false
    writeValue[@PageValueKey.METHODNAME] = item.constructor.defaultMethodName()
    actionType = item.constructor.defaultActionType()
    writeValue[@PageValueKey.ACTIONTYPE] = actionType
    start = @getAllScrollLength()
    # FIXME: スクロールの長さは要調整
    adjust = 4.0
    end = start + item.registCoord.length * adjust
    if start > end
      start = null
      end = null
    writeValue[@PageValueKey.SCROLL_POINT_START] = start
    writeValue[@PageValueKey.SCROLL_POINT_END] = end
    writeValue[@PageValueKey.IS_SYNC] = false
    writeValue[@PageValueKey.SCROLL_ENABLED_DIRECTIONS] = item.constructor.defaultScrollEnabledDirection()
    writeValue[@PageValueKey.SCROLL_FORWARD_DIRECTIONS] = item.constructor.defaultScrollForwardDirection()
    writeValue[@PageValueKey.EVENT_DURATION] = item.constructor.defaultClickDuration()
    writeValue[@PageValueKey.SPECIFIC_METHOD_VALUES] = item.constructor.defaultSpecificMethodValue()
    writeValue[@PageValueKey.MODIFIABLE_VARS] = item.constructor.defaultModifiableVars()

    if errorMes.length == 0
      # イベントとイベント数をPageValueに書き込み
      PageValue.setEventPageValue(PageValue.Key.eventNumber(teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.eventCount(), teNum)

      # Storageに保存
      window.lStorage.saveAllPageValues()

    return errorMes
