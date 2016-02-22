class ArrowPagingGuide
  @PAGE_CHANGE_SCROLL_DIST = 50
  constructor: ->
    @finishedScrollDistSum = 0
    @stopTimer = null
    @intervalTimer = null
    @wrapper = $('#pages .paging_wrapper:first')
    @emt = $('#pages .paging_parent:first')

  # スクロールイベント
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  scrollEvent: (x, y) ->
    @wrapper.show()

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
        @finishedScrollDistSum -= 3
        @emt.css('width', @finishedScrollDistSum + 'px')
        if @finishedScrollDistSum <= 0
          @finishedScrollDistSum = 0
          clearInterval(@intervalTimer)
          @intervalTimer = null
          @wrapper.hide()
      , 10)
    , 200)
    @finishedScrollDistSum += x + y
    @emt.css('width', @finishedScrollDistSum + 'px')
    #if window.debug
      #console.log('finishedScrollDistSum:' + @finishedScrollDistSum)
    if @finishedScrollDistSum > @constructor.PAGE_CHANGE_SCROLL_DIST
      if @intervalTimer != null
        clearInterval(@intervalTimer)
        @intervalTimer = null
      if @stopTimer != null
        clearTimeout(@stopTimer)
        @stopTimer = null
      # 次のページに移動
      window.eventAction.nextPageIfFinishedAllChapter( =>
        @wrapper.hide()
      )
