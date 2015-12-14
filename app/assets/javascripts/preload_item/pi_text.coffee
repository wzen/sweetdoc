class PreloadItemText extends CssItemBase
  @NAME_PREFIX = "text"
  @ITEM_ACCESS_TOKEN = 'PreloadItemText'
  @INPUT_CLASSNAME = 'pi_input_text'
  @CONTENTS_CLASSNAME = 'pi_contents_text'

  @actionProperties =
  {
    modifiables: {
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
  }

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->
    super(cood)
    @fontFamily = 'Times New Roman'
    @fontSize = null
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @_editing = false
    @inputText = 'Input text'

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    super(w, h)
    # フォントサイズ変更

  # HTML要素
  cssItemHtml: ->
    if @_editing
      return """
        <input type='text' class='#{@constructor.INPUT_CLASSNAME}' value='#{@inputText}' style="width:100%;height:100%;">
      """
    else
      return """
        <div class='#{@constructor.CONTENTS_CLASSNAME}'>#{@inputText}</div>
      """

  # マウスアップ時の描画イベント
  mouseUpDrawing: (zindex, callback = null) ->
    @restoreAllDrawingSurface()
    @fontSize = _fontSize.call(@)
    # 編集状態で描画
    @_editing = true
    @endDraw(zindex, true, =>
      @setupDragAndResizeEvents()
      @saveObj(true)
      # フォーカス設定
      @firstFocus = Common.firstFocusItemObj() == null
      # 編集モード
      Navbar.setModeEdit()
      WorktableCommon.changeMode(Constant.Mode.EDIT)
      # テキストイベント設定
      _settingInputEvent.call(@)
      # テキストを選択状態に
      @getJQueryElement().find(".#{@constructor.INPUT_CLASSNAME}:first").focus()
      @getJQueryElement().find(".#{@constructor.INPUT_CLASSNAME}:first").select()

      if callback?
        callback()
    )

  # CSSスタイル
  # TODO: CSSファイルで管理できるように修正
  cssStyle: ->
    return """
      ##{@id} .#{@constructor.INPUT_CLASSNAME}, ##{@id} .#{@constructor.CONTENTS_CLASSNAME} {
        font-family: '#{@fontFamily}';
        font-size: #{@fontSize}px;
        display: table-cell;
        vertical-align: middle;
      }
      ##{@id} .css_item_base {
        display: table;
        width: 100%;
        height: 100%;
      }
    """

  _fontSize = ->
    if @itemSize.w > @itemSize.h
      # 高さに合わせる
      return parseInt(@itemSize.h / 3)
    else
      # 幅に合わせる
      return parseInt(@itemSize.w / 3)

  _settingTextDbclickEvent = ->
    # ダブルクリックでEditに変更
    emt = @getJQueryElement().find(".#{@constructor.CONTENTS_CLASSNAME}:first")
    emt.off('dblclick').on('dblclick', (e) =>
      @_editing = true
      @reDraw(true, =>
        # テキストイベント設定
        _settingInputEvent.call(@)
        # テキストを選択状態に
        @getJQueryElement().find(".#{@constructor.INPUT_CLASSNAME}:first").focus()
        @getJQueryElement().find(".#{@constructor.INPUT_CLASSNAME}:first").select()

      )
    )

  _settingInputEvent = ->
    # テキストイベント設定
    _event = (target) ->
      @inputText = $(target).val()
      # 編集終了
      @_editing = false
      @saveObj()
      # モードを描画モードに
      Navbar.setModeDraw(@itemToken, =>
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        @reDraw(true, =>
          # イベント設定
          _settingTextDbclickEvent.call(@)
        )
      )

    input = @getJQueryElement().find(".#{@constructor.INPUT_CLASSNAME}:first")
    input.off('focusout').on('focusout', (e) =>
      _event.call(@, e.target)
    )
    input.off('keypress').on('keypress', (e) =>
      if e.keyCode == 13
        _event.call(@, e.target)
    )

Common.setClassToMap(false, PreloadItemText.ITEM_ACCESS_TOKEN, PreloadItemText)

if window.itemInitFuncList? && !window.itemInitFuncList[PreloadItemText.ITEM_ACCESS_TOKEN]?
  if EventConfig?
    EventConfig.addEventConfigContents(PreloadItemText.ITEM_ACCESS_TOKEN)
  console.log('PreloadItemText loaded')
  window.itemInitFuncList[PreloadItemText.ITEM_ACCESS_TOKEN] = (option = {}) ->
    if window.isWorkTable && PreloadItemText.jsLoaded?
      PreloadItemArrow.jsLoaded(option)
    #JS読み込み完了後の処理
    if window.debug
      console.log('PreloadItemText init Finish')