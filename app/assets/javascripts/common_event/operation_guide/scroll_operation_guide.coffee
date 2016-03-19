class ScrollOperationGuide
  class @Type
    @PAGING = 0
    @REWIND = 1
  class @Direction
    @FORWORD = 0
    @REVERSE = 1

  constructor: (@type, @direction = @constructor.Direction.FORWORD) ->
    if $('#main').hasClass('fullscreen')
      @iconWidth = 30
    else
      @iconWidth = 50
    if @type == @constructor.Type.PAGING
      @runScrollDist = 50
    else if @type == @constructor.Type.REWIND
      @runScrollDist = 80
    @perWidth = @iconWidth / @runScrollDist
    @finishedScrollDistSum = 0
    @stopTimer = null
    @intervalTimer = null
    @runningTargetId = null
    @wrapper = $('#pages .operation_guide_wrapper:first')
    if @type == @constructor.Type.PAGING
      @emt = $('#pages .paging_parent:first')
    else if @type == @constructor.Type.REWIND
      @emt = $('#pages .rewind_parent:first')

  # スクロールイベント
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  scrollEvent: (x, y, target = null) ->
    @scrollEventByDistSum(x + y, target)

  # スクロールイベント
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  scrollEventByDistSum: (distSum, target = null) ->
    if target? && @runningTargetId? && @runningTargetId != target.id
      return
    if target?
      @runningTargetId = target.id
    @wrapper.show()
    $('#pages .operation_guide').hide()
    @emt.show()
    if @intervalTimer != null
      clearInterval(@intervalTimer)
      @intervalTimer = null
    if @stopTimer != null
      clearTimeout(@stopTimer)
      @stopTimer = null
    @stopTimer = setTimeout( =>
      clearTimeout(@stopTimer)
      @stopTimer = null
      @intervalTimer = setInterval( =>
        # Width短くする
        @finishedScrollDistSum -= parseInt(@runScrollDist * 0.2)
        @update(@finishedScrollDistSum * @perWidth)
        if @finishedScrollDistSum <= 0
          @clear()
      , 10)
    , 200)
    @finishedScrollDistSum += distSum
    @update(@finishedScrollDistSum * @perWidth)
    #if window.debug
      #console.log('finishedScrollDistSum:' + @finishedScrollDistSum)
    if @finishedScrollDistSum > @runScrollDist
      if @intervalTimer != null
        clearInterval(@intervalTimer)
        @intervalTimer = null
      if @stopTimer != null
        clearTimeout(@stopTimer)
        @stopTimer = null
      if @type == @constructor.Type.PAGING
        # 次のページに移動
        window.eventAction.nextPageIfFinishedAllChapter( =>
          @wrapper.hide()
        )
      else if @type == @constructor.Type.REWIND
        # チャプター戻し
        window.eventAction.thisPage().rewindChapter( =>
          @clear()
        )

  update: (value) ->
    v = value + 'px'
    @emt.css('width', v)

  clear: (target = null) ->
    if target? && @runningTargetId? && @runningTargetId != target.id
      return
    @update(0)
    @wrapper.hide()
    @finishedScrollDistSum = 0
    @runningTargetId = null
    if @stopTimer != null
      clearTimeout(@stopTimer)
      @stopTimer = null
    if @intervalTimer != null
      clearInterval(@intervalTimer)
      @intervalTimer = null

