# 背景イベント
class BackgroundEvent extends CommonEvent
  @EVENT_ID = '1'

  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    super(event)
    methodName = @getEventMethodName()
    if methodName == 'changeBackgroundColor'
      beforeColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.BASE_COLOR]
      afterColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.CHANGE_COLOR]
      scrollStart = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
      scrollEnd = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])
      @scrollEvents = Common.colorChangeCacheData(beforeColor, afterColor, scrollEnd - scrollStart)

      className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
      section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
      @targetBackground = section

  # イベント前の表示状態にする
  updateEventBefore: ->
    methodName = @getEventMethodName()
    if methodName == 'changeBackgroundColor'
      bColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.BASE_COLOR]
      @targetBackground.css('backgroundColor', bColor)

  # イベント後の表示状態にする
  updateEventAfter: ->
    methodName = @getEventMethodName()
    if methodName == 'changeBackgroundColor'
      cColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.CHANGE_COLOR]
      @targetBackground.css('backgroundColor', cColor)

  # スクロールイベント
  # @param [Integer] scrollValue スクロール値
  changeBackgroundColor: (scrollValue) ->
    @targetBackground.css('backgroundColor', @scrollEvents[scrollValue])

Common.setClassToMap(true, BackgroundEvent.EVENT_ID, BackgroundEvent)
