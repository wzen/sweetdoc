class PageFlip
  @start = (callback = null) ->
    width = $('#pages').width()
    height = $('#pages').height()
    $(@).wrap("<div class='flip_gallery'>")
    sections = $(@).find(".section")
    canvas = $(document.createElement("canvas")).attr({width:width,height:height}).css({margin:0,width:width+"px",height:height+"px"})
    $(this).css({position:"absolute",left:"-9000px",top:"-9000px"}).after(canvas)
    @run($(this).next(), width, height, sections, callback)

  @run = (canvas, width, height, sections, callback) ->
    obj = @
    el = canvas.prev()
    index = 0
    init = false
    background = 'transparent'
    cornersTop = true
    gradientColors = ['#4F2727','#FF8F8F','#F00']
    curlSize = 0.1
    scale = 'noresize'
    patterns = []
    canvas2 = canvas.clone()
    ctx2 = canvas2[0].getContext("2d")
    ctx = canvas[0].getContext("2d")
    loaded = 0
    sections = sections.each((i) ->
      if patterns[i]
        return
      section = @
      section.onload = ->
        r = 1
        if scale != "noresize"
          rx = width / this.width
          ry = height / this.height
          if scale == "fit"
            r = if (rx < 1 || ry < 1) then Math.min(rx, ry) else 1
          if scale == "fill"
            r = Math.min(rx, ry)
        $(section).data("flip.scale",r)
        patterns[i] = ctx.createPattern(section, "no-repeat")
        loaded += 1
        if loaded == sections.length && !init
          init = true
          _draw()
      if section.complete
        window.setTimeout(->
          section.onload()
        ,10)
    )

    mX = width
    mY = height
    basemX = mX * (1 - curlSize)
    basemY = mY * curlSize
    sideLeft = false
    onCorner = false
    curlDuration = 400
    curling = false
    animationTimer = null
    startDate = null
    flipDuration = 700
    flipping = false
    baseFlipX = null
    baseFlipY = null
    lastmX = null
    lastmY = null
    inCanvas = false
    mousedown = false
    dragging = false

  #  $(window).scroll(function(){
  #  })

    canvas.click( ->
      if(onCorner && !flipping)
        flipping = true
        c.triggerHandler("mousemove")
        window.clearInterval(animationTimer)
        startDate = new Date().getTime()
        baseFlipX = mX
        baseFlipY = mY
        animationTimer = window.setInterval(_flip,10)
        index += if sideLeft then -1 else 1
        if index < 0
          index = sections.length-1
        if index == sections.length
          index = 0
        el.trigger("flip.jflip",[index,sections.length])
      return false
    )

    _flip = ->
      date = new Date()
      delta = date.getTime() - startDate
      if delta >= flipDuration
        window.clearInterval(animationTimer)
        if(sideLeft)
          sections.unshift(sections.pop())
          patterns.unshift(patterns.pop())
        else
          sections.push(sections.shift())
          patterns.push(patterns.shift())

        mX = width
        mY = height
        _draw()
        flipping = false
        if inCanvas
          startDate = new Date().getTime()
          animationTimer = window.setInterval(_cornerCurlIn, 10)
          c.triggerHandler("mousemove")
        return
      mX = baseFlipX - 2 * width * delta / flipDuration
      mY = baseFlipY + 2 * height * delta / flipDuration
      _draw()

    _cornerMove = ->
      date = new Date()
      delta = date.getTime() - startDate
      mX = basemX + Math.sin(Math.PI * 2 * delta / 1000)
      mY = basemY + Math.cos(Math.PI * 2 * delta / 1000)
      drawing = true
      window.setTimeout(_draw, 0)

    _cornerCurlIn = ->
      date = new Date()
      delta = date.getTime() - startDate
      if delta >= curlDuration
        window.clearInterval(animationTimer)
        startDate = new Date().getTime()
        animationTimer = window.setInterval(_cornerMove, 10)
      mX = width - (width - basemX) * delta / curlDuration
      mY = basemY * delta / curlDuration
      _draw()

#    _cornerCurlOut = ->
#      date = new Date()
#      delta = date.getTime()-startDate
#      if(delta>=curlDuration)
#        window.clearInterval(animationTimer)
#      mX = basemX+(width-basemX)*delta/curlDuration
#      mY = basemY-basemY*delta/curlDuration
#      _draw()

    _curlShape = (m, q) ->
      intyW = m * width + q
      intx0 = -q / m
      ctx.beginPath()
      ctx.moveTo(width, Math.min(intyW, height))
      ctx.lineTo(width, 0)
      ctx.lineTo(Math.max(intx0, 0), 0)
      if intx0 < 0
        ctx.lineTo(0, Math.min(q, height))
        if q < height
          ctx.lineTo((height - q) / m, height)
        ctx.lineTo(width, height)
      else
        if intyW < height
          ctx.lineTo(width, intyW)
        else
          ctx.lineTo((height - q) / m, height)
          ctx.lineTo(width, height)
    _draw = ->
      if !init
        return

      ctx.fillStyle = background
      ctx.fillRect(0, 0, width, height)
      img = sections[0]
      r = $(img).data("flip.scale")
      ctx.drawImage(img, (width - img.width * r) / 2, (height - img.height * r) / 2, img.width * r, img.height * r)

      if mY && mX != width
        m = 2
        q = (mY - m * (mX + width)) / 2
        m2 = mY / (width - mX)
        q2 = mX * m2
        if m == m2
          return

        sx=1
        sy=1
        tx=0
        ty=0
        ctx.save()
        if sideLeft
          tx = width
          sx = -1
        if !cornersTop
          ty = height
          sy = -1
        ctx.translate(tx, ty)
        ctx.scale(sx, sy)
        intx = (q2 - q) / (m - m2)
        inty = m * intx + q
        int2x = (2 * inty + intx + 2 * m * mX - 2 * mY) / (2 * m+1)
        int2y = -int2x / m + inty + intx / m
        d = Math.sqrt(Math.pow(intx - int2x, 2) + Math.pow(inty - int2y, 2))
        stopHighlight = Math.min(d * 0.5, 30)

        c = ctx
        gradient = c.createLinearGradient(intx, inty, int2x, int2y)
        gradient.addColorStop(0, gradientColors[0])
        gradient.addColorStop(stopHighlight / d, gradientColors[1])
        gradient.addColorStop(1, gradientColors[2])
        c.fillStyle = gradient
        c.beginPath()
        c.moveTo(-q / m, 0)
        c.quadraticCurveTo((-q / m + mX) / 2 + 0.02 * mX, mY / 2, mX, mY)
        c.quadraticCurveTo((width + mX) / 2, (m * width + q + mY) / 2 - 0.02 * (height - mY), width, m * width + q)
        c.fill()

        gradient = null
        ctx.fillStyle = background
        _curlShape(m, q)
        ctx.fill()
        _curlShape(m, q)
        #ctx.restore()

        img = if sideLeft then sections[sections.length-1] else sections[1]
        r = $(img).data("flip.scale")
        ctx.save()
        ctx.clip()
  #      ctx.scale(1/sx,1/sy)
  #      ctx.translate(-tx,-ty)

        ctx.drawImage(img, (width - img.width * r) / 2, (height - img.height * r) / 2, img.width * r, img.height * r)

        ctx.restore()
  #      if($.browser.safari || $.browser.opera)
  #        ctx.restore()


