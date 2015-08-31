# 背景イベント
class BackgroundEvent extends CommonEvent
  @EVENT_ID = '1'

  initWithEvent: (event) ->
    super(event)
    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
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

      @targetBackground = window.mainWrapper

  # イベント前の表示状態にする
  updateEventBefore: ->
    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
    if methodName == 'changeBackgroundColor'
      bColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.BASE_COLOR]
      @targetBackground.css('backgroundColor', bColor)

  # イベント後の表示状態にする
  updateEventAfter: ->
    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
    if methodName == 'changeBackgroundColor'
      cColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.CHANGE_COLOR]
      @targetBackground.css('backgroundColor', cColor)

  changeBackgroundColor: (scrollValue) ->
    @targetBackground.css('backgroundColor', @scrollEvents[scrollValue])

  # スクロールチャプター終了判定
  finishedScroll: (methodName, scrollValue) ->
    if methodName == 'changeBackgroundColor'
      return scrollValue >= @scrollLength() - 1
    return false

Common.setClassToMap(true, BackgroundEvent.EVENT_ID, BackgroundEvent)