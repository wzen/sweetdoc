class ScrollGuide extends GuideBase

  @timer = null
  @IDLE_TIMER = 1500 # 1.5秒

  if gon?
    # 定数
    constant = gon.const
    @TOP_ROOT_ID = constant.RunGuide.TOP_ROOT_ID
    @BOTTOM_ROOT_ID = constant.RunGuide.BOTTOM_ROOT_ID
    @LEFT_ROOT_ID = constant.RunGuide.LEFT_ROOT_ID
    @RIGHT_ROOT_ID = constant.RunGuide.RIGHT_ROOT_ID

  @setTimer: (directions) ->
    if @timer?
      clearTimeout(@timer)
    @timer = setTimeout( =>
      @showGuide(directions)
    , @IDLE_TIMER)

  # ガイド表示
  @showGuide: (directions) ->
    if $.isArray(directions)
      directions = [directions]

    @hideGuide()
    directions.forEach((d) =>
      id = null
      if d == Constant.ScrollDirection.TOP
        id = @TOP_ROOT_ID
      else if d == Constant.ScrollDirection.BOTTOM
        id = @BOTTOM_ROOT_ID
      else if d == Constant.ScrollDirection.LEFT
        id = @LEFT_ROOT_ID
      else if d == Constant.ScrollDirection.RIGHT
        id = @RIGHT_ROOT_ID
      $("##{id}").css('display', '')
    )

  # ガイド非表示
  @hideGuide: ->
    if @timer?
      clearTimeout(@timer)

    $("##{@TOP_ROOT_ID}").css('display', 'none')
    $("##{@BOTTOM_ROOT_ID}").css('display', 'none')
    $("##{@LEFT_ROOT_ID}").css('display', 'none')
    $("##{@RIGHT_ROOT_ID}").css('display', 'none')