# 背景イベント
class BackgroundEvent extends CommonEvent
  @EVENT_ID = '1'

  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    super(event)
    methodName = @getEventMethodName()
    if methodName == 'changeBackgroundColor'
      @scrollEvents = []

      bColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.BASE_COLOR]
      cColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.CHANGE_COLOR]
      scrollStart = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
      scrollEnd = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])

      # 'rgb(r, g, b)'のフォーマットを分解
      bColors = bColor.replace('rgb', '').replace('(', '').replace(')', '').split(',')
      for val, index in bColors
        bColors[index] = parseInt(val)
      cColors = cColor.replace('rgb', '').replace('(', '').replace(')', '').split(',')
      for val, index in cColors
        cColors[index] = parseInt(val)

      scrollLength = scrollEnd - scrollStart
      rPer = (cColors[0] - bColors[0]) / scrollLength
      gPer = (cColors[1] - bColors[1]) / scrollLength
      bPer = (cColors[2] - bColors[2]) / scrollLength
      rp = rPer
      gp = gPer
      bp = bPer
      for i in [0..scrollLength]
        r = parseInt(bColors[0] + rp)
        g = parseInt(bColors[1] + gp)
        b = parseInt(bColors[2] + bp)
        rgb = "rgb(#{r},#{g},#{b})"
        @scrollEvents[i] = rgb
        rp += rPer
        gp += gPer
        bp += bPer

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
