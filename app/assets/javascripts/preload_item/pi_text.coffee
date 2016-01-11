class PreloadItemText extends CanvasItemBase
  @NAME_PREFIX = "text"
  @CLASS_DIST_TOKEN = 'PreloadItemText'
  @NO_TEXT = 'No Text'
  @WRITE_TEXT_BLUR_LENGTH = 3

  if gon?
    constant = gon.const
    class @BalloonType
      @FREE = constant.PreloadItemText.BalloonType.FREE
      @ARC = constant.PreloadItemText.BalloonType.ARC
      @RECT = constant.PreloadItemText.BalloonType.RECT
      @BROKEN_ARC = constant.PreloadItemText.BalloonType.BROKEN_ARC
      @BROKEN_RECT = constant.PreloadItemText.BalloonType.BROKEN_RECT
      @SHOUT = constant.PreloadItemText.BalloonType.SHOUT
      @THINK = constant.PreloadItemText.BalloonType.THINK
    class @WordAlign
      @LEFT = constant.PreloadItemText.WordAlign.LEFT
      @CENTER = constant.PreloadItemText.WordAlign.CENTER
      @RIGHT = constant.PreloadItemText.WordAlign.RIGHT

  @actionProperties =
  {
    modifiables: {
      textColor: {
        name: 'TextColor'
        default: {r:0, g:0, b:0}
        colorType: 'rgb'
        type: 'color'
        ja: {
          name: '文字色'
        }
      }
      isDrawHorizontal: {
        name: 'Horizontal'
        type: 'boolean'
      }
      showBalloon: {
        name: 'Show Balloon'
        default: false
        type: 'boolean'
        openChildrenValue: true
        ja: {
          name: '吹き出し表示'
        }
        children: {
          balloonColor: {
            name: 'BalloonColor'
            default: '#fff'
            type: 'color'
            colorType: 'hex'
            ja: {
              name: '吹き出しの色'
            }
          }
          balloonType: {
            name: 'BalloonType'
            type: 'select'
            options: [
              {name: 'Arc', value: @BalloonType.ARC}
              {name: 'Broken Arc', value: @BalloonType.BROKEN_ARC}
              {name: 'Rect', value: @BalloonType.RECT}
              {name: 'Broken Rect', value: @BalloonType.BROKEN_RECT}
              {name: 'Shout', value: @BalloonType.SHOUT}
              {name: 'Think', value: @BalloonType.THINK}
            ]
            openChildrenValue: [@BalloonType.RECT, @BalloonType.BROKEN_RECT]
            children: {
              balloonRadius: {
                name: 'BalloonRadius'
                default: 30
                type: 'integer'
                min: 1
                max: 100
                ja: {
                  name: '吹き出しの角丸'
                }
              }
            }
          }
        }
      }
      fontFamily: {
        name: "Select Font"
        type: 'select'
        ja: {
          name: 'フォント選択'
        }
        options: [
          'sans-serif'
          'arial'
          'arial black'
          'arial narrow'
          'arial unicode ms'
          'Century Gothic'
          'Franklin Gothic Medium'
          'Gulim'
          'Dotum'
          'Haettenschweiler'
          'Impact'
          'Ludica Sans Unicode'
          'Microsoft Sans Serif'
          'MS Sans Serif'
          'MV Boil'
          'New Gulim'
          'Tahoma'
          'Trebuchet'
          'Verdana'
          'serif'
          'Batang'
          'Book Antiqua'
          'Bookman Old Style'
          'Century'
          'Estrangelo Edessa'
          'Garamond'
          'Gautami'
          'Georgia'
          'Gungsuh'
          'Latha'
          'Mangal'
          'MS Serif'
          'PMingLiU'
          'Palatino Linotype'
          'Raavi'
          'Roman'
          'Shruti'
          'Sylfaen'
          'Times New Roman'
          'Tunga'
          'monospace'
          'BatangChe'
          'Courier'
          'Courier New'
          'DotumChe'
          'GulimChe'
          'GungsuhChe'
          'HG行書体'
          'Lucida Console'
          'MingLiU'
          'ＭＳ ゴシック'
          'ＭＳ 明朝'
          'OCRB'
          'SimHei'
          'SimSun'
          'Small Fonts'
          'Terminal'
          'fantasy'
          'alba'
          'alba matter'
          'alba super'
          'baby kruffy'
          'Chick'
          'Croobie'
          'Fat'
          'Freshbot'
          'Frosty'
          'Gloo Gun'
          'Jokewood'
          'Modern'
          'Monotype Corsiva'
          'Poornut'
          'Pussycat Snickers'
          'Weltron Urban'
          'cursive'
          'Comic Sans MS'
          'HGP行書体'
          'HG正楷書体-PRO'
          'Jenkins v2.0'
          'Script'
          ['ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro']
          ['ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN']
          ['ヒラギノ角ゴ Pro W6', 'HiraKakuPro-W6']
          ['ヒラギノ角ゴ ProN W6', 'HiraKakuProN-W6']
          ['ヒラギノ角ゴ Std W8', 'Hiragino Kaku Gothic Std']
          ['ヒラギノ角ゴ StdN W8', 'Hiragino Kaku Gothic StdN']
          ['ヒラギノ丸ゴ Pro W4', 'Hiragino Maru Gothic Pro']
          ['ヒラギノ丸ゴ ProN W4', 'Hiragino Maru Gothic ProN']
          ['ヒラギノ明朝 Pro W3', 'Hiragino Mincho Pro']
          ['ヒラギノ明朝 ProN W3', 'Hiragino Mincho ProN']
          ['ヒラギノ明朝 Pro W6', 'HiraMinPro-W6']
          ['ヒラギノ明朝 ProN W6', 'HiraMinProN-W6']
          'Osaka'
          ['Osaka－等幅', 'Osaka-Mono']
          'MS UI Gothic'
          ['ＭＳ Ｐゴシック','MS PGothic']
          ['ＭＳ ゴシック','MS Gothic']
          ['ＭＳ Ｐ明朝', 'MS PMincho']
          ['ＭＳ 明朝', 'MS Mincho']
          ['メイリオ', 'Meiryo']
          'Meiryo UI'
        ]
      }
      isFixedFontSize: {
        name: "Font Size Fixed"
        type: 'boolean'
        default: false
        openChildrenValue: true
        children: {
          fontSize: {
            type: 'integer'
            name: "Font Size"
            min: 1
            max: 100
          }
        }
      }
      wordAlign: {
        name: "Word Align"
        type: 'select'
        options: [
          {name: 'left', value: @WordAlign.LEFT}
          {name: 'center', value: @WordAlign.CENTER}
          {name: 'right', value: @WordAlign.RIGHT}
        ]
      }
    }
    methods : {
      changeText: {
        modifiables: {
          inputText: {
            name: "Text"
            type: 'string'
            ja: {
              name: "文字"
            }
          }
        }
        options: {
          id: 'changeText'
          name: 'changeText'
          desc: "changeText"
          ja: {
            name: 'テキスト'
            desc: 'テキスト変更'
          }
        }
      }
      writeText: {
        options: {
          id: 'writeText'
          name: 'writeText'
          desc: "writeText"
          ja: {
            name: 'テキスト'
            desc: 'テキスト描画'
          }
        }
      }
    }
  }

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->
    super(cood)
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @inputText = null
    @isDrawHorizontal = true
    @fontFamily = 'Times New Roman'
    @fontSize = null
    @isFixedFontSize = false
    @showBalloon = false
    @balloonValue = {}
    @balloonType = null
    @textPositions = null
    @wordAlign = @constructor.WordAlign.LEFT
    @_fontMeatureCache = {}

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    super(w, h)
    # FIXME: フォントサイズ(and枠)変更

  # アイテム描画
  # @param [Boolean] show 要素作成後に表示するか
  itemDraw: (show = true) ->
    super(show)
    # スタイル設定
    if @inputText?
      _setTextStyle.call(@)
    else
      _setNoTextStyle.call(@)
    # 文字配置 & フォント設定
    if @inputText?
      _setTextToCanvas.call(@ , @inputText)
    else
      _setTextToCanvas.call(@ , @constructor.NO_TEXT)

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  refresh: (show = true, callback = null) ->
    super(show, =>
      _settingTextDbclickEvent.call(@)
      if callback?
        callback()
    )

  setInstanceVar: (varName, value)->
    if varName == 'isDrawHorizontal' && @isDrawHorizontal != value
      # Canvas縦横変更
      canvas = document.getElementById(@canvasElementId())
      width = canvas.width
      height = canvas.height
      $(canvas).css({width: "#{height}px", height: "#{width}px"})
      $(canvas).attr({width: height, height: width})
      w = @itemSize.w
      h = @itemSize.h
      @itemSize.w = h
      @itemSize.h = w
    super(varName, value)

  # マウスアップ時の描画イベント
  mouseUpDrawing: (zindex, callback = null) ->
    @restoreAllDrawingSurface()
    # 編集状態で描画
    @endDraw(zindex, true, =>
      @setupItemEvents()
      @saveObj(true)
      # フォーカス設定
      @firstFocus = Common.firstFocusItemObj() == null
      # 編集モード
      Navbar.setModeEdit()
      WorktableCommon.changeMode(Constant.Mode.EDIT)
      # テキストModal表示
      _showInputModal.call(@)
      if callback?
        callback()
    )

  changeText: (opt) ->
    opa = opt.progress / opt.progressMax
    canvas = document.getElementById(@canvasElementId())
    context = canvas.getContext('2d')
    context.clearRect(0, 0, canvas.width, canvas.height)
    context.fillStyle = "rgb(#{@textColor.r},#{@textColor.g},#{@textColor.b})"
    context.globalAlpha = 1 - opa
    _setTextToCanvas.call(@ , @inputText__before)
    context.globalAlpha = opa
    _setTextToCanvas.call(@ , @inputText__after)

  writeText: (opt) ->
    canvas = document.getElementById(@canvasElementId())
    context = canvas.getContext('2d')
    context.clearRect(0, 0, canvas.width, canvas.height)
    if @inputText? && @inputText.length > 0
      _setTextStyle.call(@)
      _setTextToCanvas.call(@ , @inputText, (@inputText.length * opt.progress / opt.progressMax))

  _setTextStyle = ->
    canvas = document.getElementById(@canvasElementId())
    context = canvas.getContext('2d')
    context.fillStyle = @textColor

  _setNoTextStyle = ->
    canvas = document.getElementById(@canvasElementId())
    context = canvas.getContext('2d')
    context.fillStyle = 'rgba(33, 33, 33, 0.3)'

  _setTextToCanvas = (text, writingLength) ->
    if !text?
      return

    canvas = document.getElementById(@canvasElementId())
    context = canvas.getContext('2d')
    # FIXME: 枠がある場合は中のサイズを取るようにする
    if !@fontSize?
      _calcFontSizeAbout.call(@, text, canvas.width, canvas.height)
    context.font = "#{@fontSize}px #{@fontFamily}"
    if @showBalloon
      # 枠
      _drawBalloon.call(@, context, canvas.width, canvas.height)
    context.save()
    _drawText.call(@, context, text, canvas.width, canvas.height, writingLength)
    context.restore()

  _getCircumPos = ->
    {
     x: (d, r, cx) ->
       return Math.cos(Math.PI / 180 * d) * r + cx
     y: (d, r, cy) ->
       return Math.sin(Math.PI / 180 * d) * r + cy
    }

  _getRandomInt = (max, min) ->
    return Math.floor(Math.random() * (max - min)) + min

  _drawBalloon = (context, width, height) ->
    if !@showBalloon
      return

    _drawArc = ->
      # 円
      context.save()
      context.beginPath()
      context.translate(width * 0.5, height * 0.5)
      # 調整
      diff = 3.0
      if width > height
        context.scale(width / height, 1)
        context.arc(0, 0, height * 0.5 - diff, 0, Math.PI * 2)
      else
        context.scale(1, height / width)
        context.arc(0, 0, width * 0.5 - diff, 0, Math.PI * 2)

      context.fillStyle = 'rgba(255, 255, 255, 0.5)'
      context.strokeStyle = 'rgba(0, 0, 0, 0.5)'
      context.fill()
      context.stroke()
      context.restore()
    _drawRect = ->
      # 四角
      context.save()
      context.beginPath()
      # FIXME: 描画オプション追加
      context.fillStyle = 'rgba(0, 0, 255, 0.5)';
      context.fillRect(0, 0, width, height);
      context.restore()
    _drawBArc = ->
      # 円 破線
      context.save()
      context.beginPath()
      context.translate(width * 0.5, height * 0.5)
      per = Math.PI * 2 / 360
      if width > height
        context.scale(width / height, 1)
        sum = 0
        x = 0
        while sum < Math.PI * 2
          l = ((2 * Math.cos(x)) + 1) * per
          y = x + l
          context.arc(0, 0, height * 0.5, x, y)
          sum += l
          # 空白
          l = ((1 * Math.cos(x)) + 1) * per
          y = x + l
          sum += l
      else
        context.scale(1, height / width)
        sum = 0
        x = 0
        while sum < Math.PI * 2
          l = ((2 * Math.sin(x)) + 1) * per
          y = x + l
          context.arc(0, 0, height * 0.5, x, y)
          sum += l
          # 空白
          l = ((1 * Math.sin(x)) + 1) * per
          y = x + l
          sum += l
        context.arc(0, 0, width * 0.5, 0, Math.PI * 2)
      context.restore()

    _drawBRect = ->
      context.save()
      # 四角 破線
      dashLength = 5
      _draw = (sx, sy, ex, ey) ->
        deltaX = ex - sx
        deltaY = ey - sy
        numDashes = Math.floor(Math.sqrt(deltaX * deltaX + deltaY * deltaY) / dashLength)
        for i in [0..(numDashes - 1)]
          if i % 2 == 0
            context.moveTo(sx + (deltaX / numDashes) * i, sy + (deltaY / numDashes) * i)
          else
            context.lineTo(sx + (deltaX / numDashes) * i, sy + (deltaY / numDashes) * i)

      _draw.call(@, 0, 0, width, 0)
      _draw.call(@, width, 0, width, height)
      _draw.call(@, width, height, 0, height)
      _draw.call(@, 0, height, 0, 0)
      context.restore()

    _drawShout = =>
      # 叫び
      num = 18
      radiusX = 120
      radiusY = 80
      num = 18
      cx = 120
      cy = 100
      punkLineMax = 30
      punkLineMin = 20
      fillStyle = 'rgba(255,255,255,0.9)'
      strokeStyle = 'black'
      lineWidth = 3      
      deg = 0
      addDeg = 360 / num
      # 共通設定
      context.beginPath()
      context.lineJoin = 'round'
      context.lineCap = 'round'
      context.fillStyle = fillStyle
      context.strokeStyle = strokeStyle
      context.lineWidth = lineWidth
      for i in [0..(num-1)]
        deg += addDeg
        if !@balloonValue['balloonRandomInt']?
          @balloonValue['balloonRandomInt'] = _getRandomInt.call(@, punkLineMax, punkLineMin)
        random = @balloonValue['balloonRandomInt']
        # 始点・終点
        beginX = _getCircumPos.x(deg, radiusX, cx)
        beginY = _getCircumPos.y(deg, radiusY, cy)
        endX   = _getCircumPos.x(deg + addDeg, radiusX, cx)
        endY   = _getCircumPos.y(deg + addDeg, radiusY, cy)
        # 制御値
        cp1x = _getCircumPos.x(deg, radiusX - random, cx)
        cp1y = _getCircumPos.y(deg, radiusY - random, cy)
        cp2x = _getCircumPos.x(deg + addDeg, radiusX - random, cx)
        cp2y = _getCircumPos.y(deg + addDeg, radiusY - random, cy)

        # 開始点と最終点のズレを調整する
        if i == 0
          context.arcTo(beginX, beginY, endX, endY, punkLineMax)
        context.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, endX, endY)

      context.fill()
      context.stroke()

    _drawThink = =>
      # 考え中
      num = 18
      radiusX = 120
      radiusY = 80
      num = 18
      cx = 120
      cy = 100
      punkLineMax = 30
      punkLineMin = 20
      fillStyle = 'rgba(255,255,255,0.9)'
      strokeStyle = 'black'
      lineWidth = 3
      deg = 0
      addDeg = 360 / num
      # 共通設定
      context.beginPath()
      context.lineJoin = 'round'
      context.lineCap = 'round'
      context.fillStyle = fillStyle
      context.strokeStyle = strokeStyle
      context.lineWidth = lineWidth
      for i in [0..(num-1)]
        deg += addDeg
        if !@balloonValue['balloonRandomInt']?
          @balloonValue['balloonRandomInt'] = _getRandomInt.call(@, punkLineMax, punkLineMin)
        random = @balloonValue['balloonRandomInt']
        # 始点・終点
        beginX = _getCircumPos.x(deg, radiusX, cx)
        beginY = _getCircumPos.y(deg, radiusY, cy)
        endX   = _getCircumPos.x(deg + addDeg, radiusX, cx)
        endY   = _getCircumPos.y(deg + addDeg, radiusY, cy)
        # 制御値
        cp1x = _getCircumPos.x(deg, radiusX + random, cx)
        cp1y = _getCircumPos.y(deg, radiusY + random, cy)
        cp2x = _getCircumPos.x(deg + addDeg, radiusX + random, cx)
        cp2y = _getCircumPos.y(deg + addDeg, radiusY + random, cy)

        # 開始点と最終点のズレを調整する
        if i == 0
          context.arcTo(beginX, beginY, endX, endY, punkLineMax)
        context.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, endX, endY)

      context.fill()
      context.stroke()

    if @balloonType == @constructor.BalloonType.ARC
      _drawArc.call(@)
    else if @balloonType == @constructor.BalloonType.RECT
      _drawRect.call(@)
    else if @balloonType == @constructor.BalloonType.BROKEN_ARC
      _drawBArc.call(@)
    else if @balloonType == @constructor.BalloonType.BROKEN_RECT
      _drawBRect.call(@)
    else if @balloonType == @constructor.BalloonType.SHOUT
      _drawShout.call(@)
    else if @balloonType == @constructor.BalloonType.THINK
      _drawThink.call(@)

  _drawText = (context, text, width, height, writingLength = text.length) ->
    wordWidth = context.measureText('あ').width
    _calcSize = (columnText) ->
      hasJapanease = false
      for i in [0..(columnText.length - 1)]
        if columnText.charAt(i).charCodeAt(0) >= 256
          hasJapanease = true
          break
      if hasJapanease
        return context.measureText('あ').width
      else
        context.measureText('W').width

    _calcHorizontalColumnWidth = (columnText) ->
      sum = 0
      for char in columnText.split('')
        sum += context.measureText(char).width
      return sum
    _calcVerticalColumnHeight = (columnText) ->
      # 暫定で日本語の高さに合わせる
      return columnText.length * context.measureText('あ').width
    _calcHorizontalColumnHeightMax = (columnText) ->
      ret = 0
      for c in columnText.split('')
        measure = _calcWordMeasure.call(@, c, @fontSize, @fontFamily, wordWidth)
        r = measure.height
        if ret < r
          ret = r
      return ret
    _calcHorizontalColumnWidthMax = (columns) ->
      ret = 0
      for c in columns
        r = _calcHorizontalColumnWidth.call(@, c)
        if ret < r
          ret = r
      return ret
    _calcVerticalColumnHeightMax = (columns) ->
      ret = 0
      for c in columns
        r = _calcVerticalColumnHeight.call(@, c)
        if ret < r
          ret = r
      return ret

    _preTextStyle = (context, idx, writingLength) ->
      if writingLength == 0
        context.globalAlpha = 0
      else if idx <= writingLength
        context.globalAlpha = 1
      else
        ga = 1 - ((idx - writingLength) / @constructor.WRITE_TEXT_BLUR_LENGTH)
        if ga < 0
          ga = 0
        context.globalAlpha = ga

    _writeLength = (column, writingLength, wordSum) ->
      v = parseInt(writingLength - wordSum)
      if v > column.length
        v = column.length
      else if v < 0
        v = 0
      return v

    column = ['']
    line = 0
    text = text.replace("{br}", "\n", "gm")
    for i in [0..(text.length - 1)]
      char = text.charAt(i)
      if char == "\n" || (@isDrawHorizontal && context.measureText(column[line] + char).width > width) || (!@isDrawHorizontal && _calcVerticalColumnHeight.call(@, column[line] + char) > height)
        line += 1
        column[line] = ''
        if char == "\n"
          char = ''
      column[line] += char
    sizeSum = 0
    wordSum = 0
    if @isDrawHorizontal
      heightLine = (height - wordWidth * column.length) * 0.5
      widthMax = _calcHorizontalColumnWidthMax.call(@, column)
      for j in [0..(column.length - 1)]
        heightLine += _calcHorizontalColumnHeightMax.call(@, column[j])
        w = null
        if @wordAlign == @constructor.WordAlign.LEFT
          w = (width - widthMax) * 0.5
        else if @wordAlign == @constructor.WordAlign.CENTER
          w = (width - _calcHorizontalColumnWidth.call(@, column[j])) * 0.5
        else
          # RIGHT
          w = (width + widthMax) * 0.5 - _calcHorizontalColumnWidth.call(@, column[j])
        context.beginPath()
        wl = 0
        for c, idx in column[j].split('')
          _preTextStyle.call(@, context, idx + wordSum + 1, writingLength)
          context.fillText(c, w + wl, heightLine)
          wl += context.measureText(c).width
        wordSum += column[j].length
    else
      widthLine = (width + wordWidth * column.length) * 0.5
      heightMax = _calcVerticalColumnHeightMax.call(@, column)
      for j in [0..(column.length - 1)]
        widthLine -= wordWidth
        h = null
        if @wordAlign == @constructor.WordAlign.LEFT
          h = (height - heightMax) * 0.5
        else if @wordAlign == @constructor.WordAlign.CENTER
          h = (height - _calcVerticalColumnHeight.call(@, column[j])) * 0.5
        else
          # RIGHT
          h = (height + heightMax) * 0.5 - _calcVerticalColumnHeight.call(@, column[j])
        context.beginPath()
        hl = 0
        for c, idx in column[j].split('')
          measure = _calcWordMeasure.call(@, c, @fontSize, @fontFamily, wordWidth)
          _preTextStyle.call(@, context, idx + wordSum + 1, writingLength)
          if _isWordSmallJapanease.call(@, c)
            # 小文字は右上に寄せる
            context.fillText(c, widthLine + (wordWidth - measure.width) * 0.5, h + wordWidth + hl - (wordWidth - measure.height))
            hl += measure.height
          else if _isWordNeedRotate.call(@, c)
            # 90°回転
            context.save()
            context.beginPath()
            context.translate(widthLine + wordWidth * 0.5, h + hl + measure.height)
            # デバッグ用の円
            #context.arc(0, 0, 20, 0, Math.PI*2, false)
            #context.stroke()
            context.rotate(Math.PI / 2)
            # 「wordWidth * 0.75」は調整用の値
            context.fillText(c, -measure.width * 0.5, wordWidth * 0.75 * 0.5)
            context.restore()
            hl += measure.width
          else
            context.fillText(c, widthLine, h + wordWidth + hl)
            hl += measure.height
        wordSum += column[j].length

  _calcWordMeasure = (char, fontSize, fontFamily, wordSize) ->
    fontSizeKey = "#{fontSize}"
    if @_fontMeatureCache[fontSizeKey]? && @_fontMeatureCache[fontSizeKey][fontFamily]? && @_fontMeatureCache[fontSizeKey][fontFamily][char]?
      return @_fontMeatureCache[fontSizeKey][fontFamily][char]

    nCanvas = document.createElement('canvas')
    nCanvas.width = wordSize
    nCanvas.height = wordSize
    nContext = nCanvas.getContext('2d')
    nContext.font = "#{fontSize}px #{fontFamily}"
    nContext.textBaseline = 'top'
    nContext.fillStyle = nCanvas.strokeStyle = '#ff0000'
    nContext.fillText(char, 0, 0)
    writedImage = nContext.getImageData(0, 0, wordSize, wordSize)
    mi = _measureImage.call(@, writedImage)

    if window.debug
      console.log('char: ' + char + ' textWidth:' + mi.width + ' textHeight:' + mi.height)

    if !@_fontMeatureCache[fontSizeKey]?
      @_fontMeatureCache[fontSizeKey] = {}
    if !@_fontMeatureCache[fontSizeKey][fontFamily]?
      @_fontMeatureCache[fontSizeKey][fontFamily] = {}
    @_fontMeatureCache[fontSizeKey][fontFamily][char] = mi

    return mi

  _measureImage = (_writedImage) ->
    w = _writedImage.width
    x = 0
    y = 0
    minX = 0
    maxX = 1
    minY = 0
    maxY = 1
    for i in [0..(_writedImage.data.length - 1)] by 4
      if _writedImage.data[i + 0] > 128
        if x < minX
          minX = x
        if x > maxX
          maxX = x
        if y < minY
          minY = y
        if y > maxY
          maxY = y
      x += 1
      if x >= w
        x = 0
        y += 1
    return {
      width : maxX - minX + 1
      height: maxY - minY + 1
    }

  _isWordSmallJapanease = (char) ->
    list = '、。ぁぃぅぇぉっゃゅょゎァィゥェォっャュョヮヵヶ'.split('')
    list = list.concat([',', '\\.'])
    regex = new RegExp(list.join('|'))
    return char.match(regex)

  _isWordNeedRotate = (char) ->
    if char.charCodeAt(0) < 256
      # 英字は回転
      return true

    list = 'ー＝〜・'
    regex = new RegExp(list.split('').join('|'))
    return char.match(regex)

  # 描画枠から大体のフォントサイズを計算
  _calcFontSizeAbout = (text, width, height) ->
    # 文字数計算
    a = text.length
    # 文末の改行を削除
    text = text.replace(/\n+$/g,'')
    if !@isFixedFontSize
      # フォントサイズを計算
      newLineCount = text.split('\n').length - 1
      if @isDrawHorizontal
        w = height
        h = width
      else
        w = width
        h = height
      fontSize = (Math.sqrt(Math.pow(newLineCount, 2) + (w * 4 * (a + 1)) / h) - newLineCount) * h / ((a + 1) * 2)
      if debug
        console.log(fontSize)
      # FontSizeは暫定
      @fontSize = parseInt(fontSize / 1.5)
      if @fontSize < 1
        @fontSize = 1

  _showInputModal = ->
    Common.showModalView(Constant.ModalViewType.ITEM_TEXT_EDITING, false, (modalEmt, params, callback = null) =>
      _prepareEditModal.call(@ ,modalEmt)
      if callback?
        callback()
    )

  _settingTextDbclickEvent = ->
    # ダブルクリックでEditに変更
    @getJQueryElement().off('dblclick').on('dblclick', (e) =>
      e.preventDefault()
      # Modal表示
      _showInputModal.call(@)
    )

  _prepareEditModal = (modalEmt) ->
    if @inputText?
      $('.textarea:first', modalEmt).val(@inputText)
    else
      $('.textarea:first', modalEmt).val('')
    $('.create_button', modalEmt).off('click').on('click', (e) =>
      # Inputを反映して再表示
      emt = $(e.target).closest('.modal-content')
      @inputText = $('.textarea:first', emt).val()
      # データ保存
      @saveObj()
      # モードを描画モードに
      Navbar.setModeDraw(@classDistToken, =>
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        @refresh(true, =>
          Common.hideModalView()
        )
      )
    )
    $('.back_button', modalEmt).off('click').on('click', (e) =>
      Common.hideModalView()
    )

Common.setClassToMap(PreloadItemText.CLASS_DIST_TOKEN, PreloadItemText)

if window.itemInitFuncList? && !window.itemInitFuncList[PreloadItemText.CLASS_DIST_TOKEN]?
  if window.debug
    console.log('PreloadItemText loaded')
  window.itemInitFuncList[PreloadItemText.CLASS_DIST_TOKEN] = (option = {}) ->
    if window.isWorkTable && PreloadItemText.jsLoaded?
      PreloadItemArrow.jsLoaded(option)
    #JS読み込み完了後の処理
    if window.debug
      console.log('PreloadItemText init Finish')