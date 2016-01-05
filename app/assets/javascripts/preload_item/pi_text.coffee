class PreloadItemText extends ItemBase
  @NAME_PREFIX = "text"
  @CLASS_DIST_TOKEN = 'PreloadItemText'
  @INPUT_CLASSNAME = 'pi_input_text'
  @CONTENTS_CLASSNAME = 'pi_contents_text'

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
    @fontFamily = 'Times New Roman'
    @fontSize = null
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @_editing = false
    @inputText = 'Input text'

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    super(w, h)
    # FIXME: フォントサイズ変更


  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (callback) ->
    element = "<div class='css_item_base context_base put_center'>#{@cssItemHtml()}</div>"

  # HTML要素
  cssItemHtml: ->
    if @_editing
      element = """
        <input type='text' class='text_wrapper #{@constructor.INPUT_CLASSNAME}' value='#{@inputText}' style="width:100%;height:100%;">
      """
    else
      element = """
        <canvas
        <div class='item_wrapper'><div class='#{@constructor.CONTENTS_CLASSNAME} change_before'><span class='text_wrapper'>#{@inputText}</span></div><div class='#{@constructor.CONTENTS_CLASSNAME} change_after' style='opacity: 0'><span class='text_wrapper'></span></div></div>
      """
    @addContentsToScrollInside(element, callback)


  # アイテム編集
  launchEdit: ->


  # マウスアップ時の描画イベント
  mouseUpDrawing: (zindex, callback = null) ->
    @restoreAllDrawingSurface()
    @fontSize = _fontSize.call(@)
    # 編集状態で描画
    @_editing = true
    @endDraw(zindex, true, =>
      @setupItemEvents()
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
      # line-height設定
      @getJQueryElement().find('.text_wrapper').css('line-height', @getJQueryElement().find('.text_wrapper').parent().height() + 'px')

      if callback?
        callback()
    )

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  refresh: (show = true, callback = null) ->
    super(show, ->
      if callback?
        callback()
      # TODO: 吹き出しの端を描画
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
      @refresh(true, =>
        # テキストイベント設定
        _settingInputEvent.call(@)
        # line-height設定
        @getJQueryElement().find('.text_wrapper').css('line-height', @getJQueryElement().find('.text_wrapper').parent().height() + 'px')
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
      Navbar.setModeDraw(@classDistToken, =>
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        @refresh(true, =>
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