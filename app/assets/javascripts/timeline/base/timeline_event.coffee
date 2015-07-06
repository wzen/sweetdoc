class TimelineEvent

  class @PageValueKey
    # @property [String] te タイムラインイベントRoot
    @te : (teNum) -> 'timeline_event:' + @teNum
    # @property [String] ID アイテムID
    @ID = 'id'
    # @property [String] ITEM_ID アイテムタイプID
    @ITEM_ID = 'item_id'
    # @property [String] ACTION_EVENT_TYPE_ID アクションイベントID
    @ACTION_EVENT_TYPE_ID = 'action_event_type_id'
    # @property [String] VALUE タイムラインイベント値
    @VALUE = 'value'
    # @property [String] IS_COMMON_EVENT タイムライン共通イベント判定
    @IS_COMMON_EVENT = 'is_common_event'
    # @property [String] TE_VALUE タイムライン変更前の値
    #@TE_ORIGINAL_VALUE = @TE + ':originalvalue'
    # @property [String] ORDER ソート番号
    @ORDER = 'order'
    # @property [String] METHODNAME イベント名
    @METHODNAME = 'methodname'
    # @property [String] METHODNAME イベント名
    @ACTIONTYPE = 'actiontype'
    # @property [String] IS_PARALLEL 同時実行
    @IS_CLICK_PARALLEL = 'is_click_parallel'
    # @property [String] SCROLL_TIME スクロール実行時間
    @SCROLL_POINT = 'scroll_point'
    # @property [String] TE_SCROLL_TIME_SEP スクロール実行時間セパレータ
    @SCROLL_POINT_SEP = '-'

  # fixme: 実装予定
  checkConfigValue: (timelineConfig) ->


  commonWriteValue: (timelineConfig) ->
    writeValue = {}
    writeValue[@constructor.PageValueKey.ID] = timelineConfig.id
    writeValue[@constructor.PageValueKey.ITEM_ID] = timelineConfig.itemId
    writeValue[@constructor.PageValueKey.ACTION_EVENT_TYPE_ID] = timelineConfig.actionEventTypeId
    writeValue[@constructor.PageValueKey.IS_COMMON_EVENT] = timelineConfig.isCommonEvent
    writeValue[@constructor.PageValueKey.METHODNAME] = timelineConfig.methodName
    writeValue[@constructor.PageValueKey.ACTIONTYPE] = timelineConfig.actionType

    scrollPoint = ""
    scrollPointDiv = $('.scroll_point_div', timelineConfig.emt)
    if scrollPointDiv?
      start = scrollPointDiv.find('.scroll_point_start:first').val()
      end = scrollPointDiv.find('.scroll_point_end:first').val()
      scrollPoint = start + @constructor.PageValueKey.SCROLL_POINT_SEP + end
    writeValue[@constructor.PageValueKey.SCROLL_POINT] = scrollPoint

    isClickParallel = false
    clickParallel = $('.click_parallel_div .click_parallel', timelineConfig.emt)
    if clickParallel?
      isClickParallel = clickParallel.is(":checked")
    writeValue[@constructor.PageValueKey.IS_CLICK_PARALLEL] = isClickParallel

    return writeValue



