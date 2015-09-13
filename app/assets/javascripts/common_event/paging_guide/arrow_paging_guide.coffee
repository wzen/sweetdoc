class ArrowPagingGuide
  @PAGE_CHANGE_SCROLL_DIST = 50
  @CANVAS_WIDTH = 100
  @CANVAS_HEIGHT = 70

  constructor: ->
    @finishedScrollDistSum = 0
    @stopTimer = null
    @intervalTimer = null

  # キャンパス表示
  _showCanvas = ->
    emt = $('#arrow_paging_guide')
    if !emt? || emt.length == 0
      # キャンパスが無い場合、作成
      top = window.mainWrapper.height() - ArrowPagingGuide.CANVAS_HEIGHT
      left = window.mainWrapper.width() - ArrowPagingGuide.CANVAS_WIDTH
      temp = """
                <div id='arrow_paging_guide' style='position: absolute;top:#{top}px;left:#{left}px;z-index:#{Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT - 1)};display:none;'><canvas id='arrow_paging_guide_canvas' class='canvas' width='#{ArrowPagingGuide.CANVAS_WIDTH}' height='#{ArrowPagingGuide.CANVAS_HEIGHT}' style='width:100%;height:100%'></canvas></div>
              """
      window.mainWrapper.append(temp)
      @canvas = document.getElementById('arrow_paging_guide_canvas')
      @context = @canvas.getContext('2d')

    $('#arrow_paging_guide').css('display', 'block')

  _moveBackground = ->
    x = ArrowPagingGuide.CANVAS_WIDTH * @finishedScrollDistSum / ArrowPagingGuide.PAGE_CHANGE_SCROLL_DIST

    @context.globalCompositeOperation = "source-over";
    @context.beginPath()
    @context.moveTo(0, 20)
    @context.lineTo(60, 20)
    @context.lineTo(60, 0)
    @context.lineTo(100, 35)
    @context.lineTo(60, 70)
    @context.lineTo(60, 50)
    @context.lineTo(0, 50)
    @context.lineTo(0, 20)
    @context.fill()

    @context.globalCompositeOperation = "source-in";
    @context.beginPath()
    @context.fillStyle = 'blue'
    @context.moveTo(0, 0)
    @context.lineTo(x, 0)
    @context.lineTo(x, ArrowPagingGuide.CANVAS_HEIGHT)
    @context.lineTo(0, ArrowPagingGuide.CANVAS_HEIGHT)
    @context.lineTo(0, 0)
    @context.fill()

  # スクロールイベント
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  scrollEvent: (x, y) ->
    _showCanvas.call(@)

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
        @finishedScrollDistSum -= 3
        _moveBackground.call(@)
        if @finishedScrollDistSum <= 0
          @finishedScrollDistSum = 0
          clearInterval(@intervalTimer)
          @intervalTimer = null
          $('#arrow_paging_guide').css('display', 'none')
      , 10)
    , 200)
    @finishedScrollDistSum += x + y
    _moveBackground.call(@)
    #console.log('finishedScrollDistSum:' + @finishedScrollDistSum)
    if @finishedScrollDistSum > @constructor.PAGE_CHANGE_SCROLL_DIST
      # 次のページに移動
      window.eventAction.nextPageIfFinishedAllChapter( ->
        # 矢印削除
        #$('#arrow_paging_guide').remove()
      )
