class PreloadItemText extends CanvasItemBase
  @NAME_PREFIX = "text"
  @CLASS_DIST_TOKEN = 'PreloadItemText'
  @NO_TEXT = 'No Text'

  if gon?
    constant = gon.const
    class @BalloonType
      @NONE = constant.PreloadItemText.BalloonType.NONE
      @FREE = constant.PreloadItemText.BalloonType.FREE
      @NORMAL = constant.PreloadItemText.BalloonType.NORMAL
      @RECT = constant.PreloadItemText.BalloonType.RECT
      @THINK = constant.PreloadItemText.BalloonType.THINK
      @SHOUT = constant.PreloadItemText.BalloonType.SHOUT
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
      fontFamily: {
        name: "Select Font"
        type: 'select'
        ja: {
          name: 'フォント選択'
        }
        'options[]': [
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
    @isDrawBalloon = false
    @balloonType = @constructor.BalloonType.NONE
    @textPositions = null
    @wordAlign = @constructor.WordAlign.LEFT

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
      _setTextToCanvas.call(@ , @inputText, parseInt(@inputText.length * opt.progress / opt.progressMax))

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
    context.save()
    _drawText.call(@, context, text, canvas.width, canvas.height, writingLength)
    context.restore()

  _drawText = (context, text, width, height, writingLength = text.length) ->
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

    _calcVerticalColumnWidth = (columnText) ->
      sum = 0
      for char in columnText.split('')
        sum += context.measureText(char).width
      return sum
    _calcVerticalColumnHeight = (columnText) ->
      # 暫定で日本語の高さに合わせる
      return columnText.length * context.measureText('あ').width
    _calcVerticalColumnWidthMax = (columns) ->
      ret = 0
      for c in columns
        r = _calcVerticalColumnWidth.call(@, c)
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
    _replaceWordToSpace = (text) ->
      spaceStr = ''
      for char in text.split('')
        if char.charCodeAt(0) >= 256
          # 全角スペース
          spaceStr += ' '
        else
          # 半角スペース
          spaceStr += ' '
      return spaceStr

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
    wordWidth =  context.measureText('あ').width
    wordSum = 0
    if @isDrawHorizontal
      heightLine = (height - wordWidth * column.length) * 0.5
      widthMax = _calcVerticalColumnWidthMax.call(@, column)
      for j in [0..(column.length - 1)]
        heightLine += wordWidth
        w = null
        if @wordAlign == @constructor.WordAlign.LEFT
          w = (width - widthMax) * 0.5
        else if @wordAlign == @constructor.WordAlign.CENTER
          w = (width - _calcVerticalColumnWidth.call(@, column[j])) * 0.5
        else
          # RIGHT
          w = (width + widthMax) * 0.5 - _calcVerticalColumnWidth.call(@, column[j])
        context.beginPath()
        wl = writingLength - wordSum
        if wl > column[j].length
          wl = column[j].length
        visibleStr = column[j].substring(0, wl)
        hiddenStr = _replaceWordToSpace.call(@, column[j].substr(wl))
        t = visibleStr + hiddenStr
        context.fillText(t, w, heightLine)
        wordSum += t.length
    else
      widthLine = (width + wordWidth * column.length) * 0.5 + wordWidth
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
        wl = writingLength - wordSum
        if wl > column[j].length
          wl = column[j].length
        visibleStr = column[j].substring(0, wl)
        hiddenStr = _replaceWordToSpace.call(@, column[j].substr(wl))
        t = visibleStr + hiddenStr
        hl = 0
        for c in t.split('')
          context.fillText(c, widthLine, h + wordWidth + hl)
          hl += wordWidth
        wordSum += t.length

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