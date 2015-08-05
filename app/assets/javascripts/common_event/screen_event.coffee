# 画面表示イベント
class ScreenEvent extends CommonEvent
  @EVENT_ID = '2'

  constructor: ->
    @id = @constructor.EVENT_ID

  getJQueryElement: ->
    return window.mainWrapper

  # 画面移動イベント
  changeScreenPosition: (e) =>
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.CLICK
      finished_count = 0
      scrollTop = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.X]
      scrollLeft = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Y]
      scrollContents.animate({scrollTop: (scrollContents.scrollTop() + scrollTop), scrollLeft: (scrollContents.scrollLeft() + scrollLeft) }, 'normal', 'linear', ->
        finished_count += 1
        if finished_count >= 2
          @isFinishedEvent = true
          if window.timeLine?
            window.timeLine.nextChapterIfFinishedAllEvent()
      )

#      @getJQueryElement().addClass('changeScreenPosition_' + @id)
#      @getJQueryElement().on('webkitAnimationEnd animationend', (e) =>
#        @getJQueryElement().removeClass('changeScreenPosition_' + @id)
#
#        finished_count += 1
#        if finished_count >= 2
#          @isFinishedEvent = true
#          if window.timeLine?
#            window.timeLine.nextChapterIfFinishedAllEvent()
#      )

  # CSS
  cssElement : (methodName) ->
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]

    if methodName == 'changeScreenPosition'
      if actionType == Constant.ActionEventHandleType.CLICK

        funcName = "#{methodName}_#{@id}"

        scale = null
        mainTramsform = $('#main-wrapper').css('transform')
        if mainTramsform?
          s = parseInt(mainTramsform.replace('scale', '').replace('(', '').replace(')', ''))
          if s? && !Number.isNaN(s)
            scale = s

        if scale?
          zoom = scale + @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Z]
        else
          zoom = 1

        # CSSに設定
        css = """
        .#{funcName}
        {
        -moz-transition: all 0.5s ease 0;
        -webkit-transition: all 0.5s ease 0;
        -webkit-transform : scale(#{zoom});
        transform : scale(#{zoom});
        }
        """

        return css

    return null

  zoom: (zoom, x, y) ->
    $(".content").css({
      "-moz-transition": "all 0s ease 0",
      "-webkit-transition": "all 0s ease 0",
      "-webkit-transform-origin": x+"px "+y+"px",
      "transform-origin": x+"px "+y+"px",
    })
    setTimeout( ->
      $(".content").css({
        "-moz-transition": "all 0.5s ease 0",
        "-webkit-transition": "all 0.5s ease 0",
        "-webkit-transform" : "scale("+zoom+")",
        "transform" : "scale("+zoom+")"
      })
    ,1)


setClassToMap(true, ScreenEvent.EVENT_ID, ScreenEvent)