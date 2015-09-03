class PageFlip

  @DIRECTION = {}
  @DIRECTION.FORWARD = 1
  @DIRECTION.BACK = 2

  constructor: (beforePageNum, afterPageNum) ->
    # Dimensions of one page in the book
    @PAGE_WIDTH = $('#pages').width()
    @PAGE_HEIGHT = $('#pages').height()

    # The canvas size equals to the book dimensions + this padding
    @CANVAS_PADDING = 20

    @zIndex = Common.plusPagingZindex(0, @flipPageNum)

    # アニメーション用Div作成
    zIndexMax = Common.plusPagingZindex(0, 0)
    $("##{Constant.Paging.ROOT_ID}").append("<div id='pageflip-root' style='position:absolute;top:0;left:0;width:100%;height:100%;z-index:#{zIndexMax}'><canvas id='pageflip-canvas' style='z-index:#{zIndexMax}'></canvas></div>")

    @canvas = document.getElementById("pageflip-canvas")
    @context = @canvas.getContext("2d")

    # Resize the canvas to match the book size
    @canvas.width = @PAGE_WIDTH + (@CANVAS_PADDING * 2)
    @canvas.height = @PAGE_HEIGHT + (@CANVAS_PADDING * 2)

    # Offset the canvas so that it's padding is evenly spread around the book
    @canvas.style.top = -@CANVAS_PADDING + "px"
    @canvas.style.left = -@CANVAS_PADDING + "px"

    @direction = if beforePageNum < afterPageNum then PageFlip.DIRECTION.FORWARD else PageFlip.DIRECTION.BACK
    if window.debug
      console.log('[PageFlip constructor] direction:' + @direction)

    @flipPageNum = if beforePageNum < afterPageNum then beforePageNum else afterPageNum
    if window.debug
      console.log('[PageFlip constructor] flipPageNum:' + @flipPageNum)

    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', afterPageNum)
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    section.css('display', '')
    if @direction == PageFlip.DIRECTION.FORWARD
      section.css('width', '')
    else if @direction == PageFlip.DIRECTION.BACK
      section.css('width', '0')

  # 描画開始
  startRender: (callback = null)->
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', @flipPageNum)
    pages = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    if @direction == PageFlip.DIRECTION.FORWARD
      @flip = {
        progress: 1,
        target: -0.25,
        page: pages,
      }

      point = @PAGE_WIDTH
      timer = setInterval(=>
        point -= 50
        if point < -@CANVAS_PADDING
          point = -@CANVAS_PADDING
          @flip.progress = 0
          @render(point)
          clearInterval(timer)
          $('#pageflip-root').remove()
          if callback?
            callback()
        @render(point)
      , 50)
    else if @direction == PageFlip.DIRECTION.BACK
      @flip = {
        progress: -0.25,
        target: 1,
        page: pages,
      }
      point = -@CANVAS_PADDING
      timer = setInterval(=>
        point += 50
        if point > @PAGE_WIDTH
          point = @PAGE_WIDTH
          @flip.progress = 1
          @render(point)
          clearInterval(timer)
          $('#pageflip-root').remove()
          if callback?
            callback()
        @render(point)
      , 50)

  # 描画
  render: (point)->
    if point < -@CANVAS_PADDING || point > @PAGE_WIDTH
      return

    # Reset all pixels in the canvas
    @context.clearRect(0, 0, @canvas.width, @canvas.height)

    # Ease progress towards the target value
    @flip.progress += (@flip.target - @flip.progress)* 0.2
#    if window.debug
#      console.log('[render] progress: ' + @flip.progress)

    @drawFlip(@flip)

  drawFlip: (flip)->
    # Strength of the fold is strongest in the middle of the book
    strength = 1 - Math.abs(flip.progress)

    foldWidth = 0

    # X position of the folded paper
    foldX = @PAGE_WIDTH * flip.progress + foldWidth
#    if window.debug
#      console.log('[drawFlip] foldX:' + foldX + ' progress:' + flip.progress)

    # How far the page should outdent vertically due to perspective
    verticalOutdent = 20 * strength

    # The maximum width of the left and right side shadows
    paperShadowWidth = (@PAGE_WIDTH * 0.5)* Math.max(Math.min(1 - flip.progress, 0.5), 0)
    rightShadowWidth = (@PAGE_WIDTH * 0.5)* Math.max(Math.min(strength, 0.5), 0)
    leftShadowWidth = (@PAGE_WIDTH * 0.5)* Math.max(Math.min(strength, 0.5), 0)

    # Change page element width to match the x position of the fold
    flip.page.css({'width': Math.max(foldX, 0)+ "px", 'z-index': @zIndex})

    @context.save()

    # Draw a sharp shadow on the left side of the page
    @context.strokeStyle = 'rgba(0,0,0,'+(0.05 * strength)+')'
    @context.lineWidth = 30 * strength
    @context.beginPath()
    @context.moveTo(foldX - foldWidth, -verticalOutdent * 0.5)
    @context.lineTo(foldX - foldWidth, @PAGE_HEIGHT + (verticalOutdent * 0.5))
    @context.stroke()


    # Right side drop shadow
    rightShadowGradient = @context.createLinearGradient(foldX, 0, foldX + rightShadowWidth, 0)
    rightShadowGradient.addColorStop(0, 'rgba(0,0,0,'+(strength*0.2)+')')
    rightShadowGradient.addColorStop(0.8, 'rgba(0,0,0,0.0)')

    @context.fillStyle = rightShadowGradient
    @context.beginPath()
    @context.moveTo(foldX, 0)
    @context.lineTo(foldX + rightShadowWidth, 0)
    @context.lineTo(foldX + rightShadowWidth, @PAGE_HEIGHT)
    @context.lineTo(foldX, @PAGE_HEIGHT)
    @context.fill()


    # Left side drop shadow
    leftShadowGradient = @context.createLinearGradient(foldX - foldWidth - leftShadowWidth, 0, foldX - foldWidth, 0)
    leftShadowGradient.addColorStop(0, 'rgba(0,0,0,0.0)')
    leftShadowGradient.addColorStop(1, 'rgba(0,0,0,'+(strength*0.15)+')')

    @context.fillStyle = leftShadowGradient
    @context.beginPath()
    @context.moveTo(foldX - foldWidth - leftShadowWidth, 0)
    @context.lineTo(foldX - foldWidth, 0)
    @context.lineTo(foldX - foldWidth, @PAGE_HEIGHT)
    @context.lineTo(foldX - foldWidth - leftShadowWidth, @PAGE_HEIGHT)
    @context.fill()


    # Gradient applied to the folded paper (highlights & shadows)
    foldGradient = @context.createLinearGradient(foldX - paperShadowWidth, 0, foldX, 0)
    foldGradient.addColorStop(0.35, '#fafafa')
    foldGradient.addColorStop(0.73, '#eeeeee')
    foldGradient.addColorStop(0.9, '#fafafa')
    foldGradient.addColorStop(1.0, '#e2e2e2')

    @context.fillStyle = foldGradient
    @context.strokeStyle = 'rgba(0,0,0,0.06)'
    @context.lineWidth = 0.5

    # Draw the folded piece of paper
    @context.beginPath()
    @context.moveTo(foldX, 0)
    @context.lineTo(foldX, @PAGE_HEIGHT)
    @context.quadraticCurveTo(foldX, @PAGE_HEIGHT + (verticalOutdent * 2), foldX - foldWidth, @PAGE_HEIGHT + verticalOutdent)
    @context.lineTo(foldX - foldWidth, -verticalOutdent)
    @context.quadraticCurveTo(foldX, -verticalOutdent * 2, foldX, 0)

    @context.fill()
    @context.stroke()

    @context.restore()

