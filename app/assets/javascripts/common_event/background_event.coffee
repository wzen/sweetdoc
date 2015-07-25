# 背景イベント
class BackgroundEvent extends CommonEvent
  @EVENT_ID = '1'

  willChapter: (methodName) ->

    if methodName == 'changeBackgroundColor'
      @scrollEvents = []
      bColor = @timelineEvent[TLEBackgroundColorChange.BASE_COLOR]
      cColor = @timelineEvent[TLEBackgroundColorChange.CHANGE_COLOR]
      scrollStart = parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])
      scrollEnd = parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END])

      # 'rgb(r, g, b)'のフォーマットを分解
      bColors = bColor.replace('rgb', '').replace('(', '').replace(')', '').split(',')
      cColors = cColor.replace('rgb', '').replace('(', '').replace(')', '').split(',')

      color_max = 256 * 3
      colorPerHeight = (color_max) / scrollViewHeight
      c = 0
      for i in [0..(scrollEnd - scrollStart)]
        styles = []
        c += colorPerHeight
        cf = Math.floor(c)
        r = parseInt(cf / 3)
        g = parseInt((cf + 1) / 3)
        b = parseInt((cf + 2) / 3)
        rgb = "rgb(" + r + "," + g + "," + b + ")"
        style = {name : "background-color", param : rgb}
        styles.push(style)
        @scrollEvents[i] = styles

  changeBackgroundColor: (scrollValue) ->

setClassToMap(true, BackgroundEvent.EVENT_ID, BackgroundEvent)