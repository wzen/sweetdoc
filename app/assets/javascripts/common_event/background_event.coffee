# 背景イベント
class BackgroundEvent extends CommonEvent
  @EVENT_ID = '1'

  class @PrivateClass extends CommonEvent.PrivateClass

    initWithEvent: (timelineEvent) ->
      super(timelineEvent)
      methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
      if methodName == 'changeBackgroundColor'
        @scrollEvents = []

        bColor = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEBackgroundColorChange.BASE_COLOR]
        cColor = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEBackgroundColorChange.CHANGE_COLOR]
        scrollStart = parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])
        scrollEnd = parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END])

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

        @targetBackground = $('#main-wrapper')

    changeBackgroundColor: (scrollValue) ->
      @targetBackground.css('backgroundColor', @scrollEvents[scrollValue])

    # スクロールチャプター終了判定
    finishedScroll: (methodName, scrollValue) ->
      if methodName == 'changeBackgroundColor'
        return scrollValue >= @scrollLength() - 1
      return false

setClassToMap(true, BackgroundEvent.EVENT_ID, BackgroundEvent)
setInstanceFromMap(true, BackgroundEvent.EVENT_ID)