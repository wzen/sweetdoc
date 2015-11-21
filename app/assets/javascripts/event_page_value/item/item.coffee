# EventPageValue アイテム
class EPVItem extends EventPageValueBase
  @itemSize = 'item_size'

  # コンフィグ初期設定
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @param [Object] item アイテムオブジェクト
  @initConfigValue = (eventConfig, item) ->
    super(eventConfig)

  # アイテムのデフォルトイベントをPageValueに書き込み
  # @param [Object] item アイテムオブジェクト
  # @return [String] エラーメッセージ
  @writeDefaultToPageValue = (item) ->
    errorMes = ""
    writeValue = {}
    writeValue[@PageValueKey.DIST_ID] = Common.generateId()
    writeValue[@PageValueKey.ID] = item.id
    writeValue[@PageValueKey.ITEM_ID] = item.constructor.ITEM_ID
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
    writeValue[@PageValueKey.VALUE] = item.constructor.defaultEventConfigValue()
    writeValue[@PageValueKey.MODIFIABLE_VARS] = {}

    if errorMes.length == 0
      teNum = PageValue.getEventPageValue(PageValue.Key.eventCount())
      if teNum?
        teNum = parseInt(teNum) + 1
      else
        teNum = 1

      # イベントとイベント数をPageValueに書き込み
      PageValue.setEventPageValue(PageValue.Key.eventNumber(teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.eventCount(), teNum)

      # Storageに保存
      LocalStorage.saveAllPageValues()

    return errorMes

  # PageValueに書き込み
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [String] エラーメッセージ
  @writeToPageValue = (eventConfig) ->
    errorMes = ""
    writeValue = super(eventConfig)

    if errorMes.length == 0
      item = instanceMap[eventConfig.id]
      value = item.eventConfigValue()
      writeValue[@PageValueKey.VALUE] = value
      PageValue.setEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum), writeValue)
      if parseInt(PageValue.getEventPageValue(PageValue.Key.eventCount())) < eventConfig.teNum
        PageValue.setEventPageValue(PageValue.Key.eventCount(), eventConfig.teNum)

      # Storageに保存
      LocalStorage.saveAllPageValues()

    return errorMes

  # PageValueからConfigにデータを読み込み
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @param [Object] item アイテムオブジェクト
  # @return [Boolean] 読み込み成功したか
  @readFromPageValue = (eventConfig, item) ->
    ret = super(eventConfig)
    return ret
