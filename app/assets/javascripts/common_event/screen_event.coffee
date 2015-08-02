# 画面表示イベント
class ScreenEvent extends CommonEvent
  @EVENT_ID = '2'

  # 画面移動イベント
  changeScreenPosition: ->
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.CLICK
      $('#main-wrapper')


  # CSS
  cssElement : (methodName) ->
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]

    if methodName == 'changeScreenPosition'
      if actionType == Constant.ActionEventHandleType.CLICK

        funcName = "#{methodName}_#{@id}"
        zoom = @timelineEvent[TimelineEvent.PageValueKey.VALUE][TLEScreenPositionChange.Z]

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