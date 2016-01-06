class PreloadItemText extends CanvasItemBase
  @NAME_PREFIX = "text"
  @CLASS_DIST_TOKEN = 'PreloadItemText'
  @INPUT_CLASSNAME = 'pi_input_text'
  @CONTENTS_CLASSNAME = 'pi_contents_text'

  if gon?
    constant = gon.const
    class @BalloonType
      @NONE = constant.PreloadItemText.BalloonType.NONE
      @FREE = constant.PreloadItemText.BalloonType.FREE
      @NORMAL = constant.PreloadItemText.BalloonType.NORMAL
      @RECT = constant.PreloadItemText.BalloonType.RECT
      @THINK = constant.PreloadItemText.BalloonType.THINK
      @SHOUT = constant.PreloadItemText.BalloonType.SHOUT

  @actionProperties =
  {
    modifiables: {
      textColor: {
        name: 'TextColor'
        default: '#000'
        colorType: 'hex'
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
          name: 'Text'
          desc: "Text"
          ja: {
            name: 'テキスト'
            desc: 'テキスト変更'
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
    #@_editing = false
    @inputText = 'Input text'
    @isDrawHorizontal = true
    @fontFamily = 'Times New Roman'
    @fontSize = null
    @isFixedFontSize = false
    @isDrawBalloon = false
    @balloonType = @constructor.BalloonType.NONE
    @textPositions = null

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    super(w, h)
    # FIXME: フォントサイズ(and枠)変更

  # アイテム描画
  # @param [Boolean] show 要素作成後に表示するか
  itemDraw: (show = true) ->
    super(show)
    # 描画
    _draw.call(@)

  # マウスアップ時の描画イベント
  mouseUpDrawing: (zindex, callback = null) ->
    @restoreAllDrawingSurface()
    #@fontSize = _fontSize.call(@)
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

  # CSSスタイル
  # TODO: CSSファイルで管理できるように修正
  cssStyle: ->
    css = """
      ##{@id} .text_wrapper {
        font-family: '#{@fontFamily}';
        font-size: #{@fontSize}px;
        display: table-cell;
        vertical-align: middle;
        color: #{@textColor}
      }
      ##{@id} .#{@constructor.CONTENTS_CLASSNAME} {
        text-align: center;
        display: table;
        width: 100%;
        height: 100%;
      }
    """
    if @showBalloon
      css += """
        ##{@id} .item_wrapper {
          border-radius: #{@balloonRadius}px;
          background-color: #{@balloonColor};
        }
      """

    return css

  changeText: (opt) ->
    changeBefore = @getJQueryElement().find('.change_before:first')
    changeAfter = @getJQueryElement().find('.change_after:first')
    if changeAfter.find('span:first').text().length == 0
      changeBefore.find('span:first').html(@inputText__before)
      changeBefore.css('opacity', 1)
      changeAfter.find('span:first').html(@inputText__after)
      changeAfter.css('opacity', 0)
    else
      opa = 1 * opt.progress / opt.progressMax
      changeBefore.css('opacity', 1 - opa)
      changeAfter.css('opacity', opa)

  _draw = ->
    # スタイル設定
    _setTextStyle.call(@)
    # 文字配置 & フォント設定
    _setTextToCanvas.call(@ ,$(drawingCanvas).attr('width'), $(drawingCanvas).attr('height'))

  _setTextStyle = ->
    canvas = document.getElementById(@canvasElementId())
    context = drawingCanvas.getContext('2d')


  _setTextToCanvas = ->
    canvas = document.getElementById(@canvasElementId())
    context = drawingCanvas.getContext('2d')
    canvasWidth = $(canvas).attr('width')
    canvasHeight = $(canvas).attr('height')
    # FIXME: 枠がある場合は中のサイズを取るようにする
    _calcTextPositionAndFont.call(@, canvasWidth, canvasHeight)
    context.font = "#{@fontSize}px #{@fontFamily}"
    for p in @textPositions
      context.save()
      context.beginPath()
      if !@isDrawHorizontal && p.char.charCodeAt(0) < 256
        # 縦書き & 英語の場合、90°回転
        context.translate(canvas.width / 2, canvas.height / 2);
        context.rotate(Math.PI / 90);
      context.fillText(p.char, p.x, p.y)
      context.restore()

  _calcTextPositionAndFont = (width, height) ->
    # 文字数計算
    a = @inputText.length
    # 文末の改行を削除
    @inputText = @inputText.replace(/\n+$/g,'')
    if !@isFixedFontSize
      # フォントサイズを計算
      newLineCount = @inputText.split('\n').length - 1
      if @isDrawHorizontal
        w = height
        h = width
      else  
        w = width
        h = height
      fontSize = (Math.sqrt(Math.pow(newLineCount, 2) + (w * 4 * (a + 1)) / h) - newLineCount) * (a + 1) / h * 2
      if debug
        console.log(fontSize)
      @fontSize = parseInt(fontSize)
    # 描画位置を計算
    @textPositions = []
    posIndex = 0
    if @isDrawHorizontal
      # 横書き
      x = 0
      y = 0
      for c in @inputText.split('')
        if c != '\n'
          x = 0
          y += @fontSize
        else
          @textPositions[posIndex] = {
            char: c
            x: x
            y: y
          }
          posIndex += 1
          x += @fontSize
          if x >= width
            x = 0
            y += @fontSize
    else
      # 縦書き
      x = width - @fontSize
      y = 0
      for c in @inputText.split('')
        if c != '\n'
          y = 0
          x -= @fontSize
        else
          @textPositions[posIndex] = {
            char: c
            x: x
            y: y
          }
          posIndex += 1
          y += @fontSize
          if y >= height
            y = 0
            x -= @fontSize

  _showInputModal = ->
    Common.showModalView(Constant.ModalViewType.ITEM_TEXT_EDITING, false, (modalEmt, params, callback = null) =>
      _prepareEditModal.call(@ ,modalEmt)
      if callback?
        callback()
    )

  _settingTextDbclickEvent = ->
    # ダブルクリックでEditに変更
    emt = @getJQueryElement().find(".#{@constructor.CONTENTS_CLASSNAME}:first")
    emt.off('dblclick').on('dblclick', (e) =>
      @refresh(true, =>
        # Modal表示
        _showInputModal.call(@)
      )
    )

  _prepareEditModal = (modalEmt) ->
    $('.create_button', modalEmt).off('click').on('click', (e) =>
      # Inputを反映して再表示
      emt = $(e.target).closest('.modal-content')
      @inputText = $('.textarea:first', emt).val()
      # モードを描画モードに
      Navbar.setModeDraw(@classDistToken, =>
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        @refresh(true, =>
          # イベント設定
          _settingTextDbclickEvent.call(@)
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