# CSSアイテム
# @abstract
# @extend ItemBase
class CssItemBase extends ItemBase

  if window.loadedClassDistToken?
    # @property [String] CLASS_DIST_TOKEN アイテム種別
    @CLASS_DIST_TOKEN = window.loadedClassDistToken

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null) ->
    super(cood)
    @_cssRoot = null
    @_cssDesignToolCache = null
    @_cssDesignToolCode = null
    @_cssDesignToolStyle = null
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @_cssStypeReflectTimer = null

  # initEvent前の処理
  initEventPrepare: ->
    # デザインCSS & アニメーションCSS作成
    #@makeCss()
    @appendAnimationCssIfNeeded()

  # HTML要素
  # @abstract
  cssItemHtml: ->

  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (callback) ->
    element = "<div class='css_item_base context_base put_center'>#{@cssItemHtml()}</div>"
    @addContentsToScrollInside(element, callback)

  # JSファイル読み込み時処理
  @jsLoaded: (option) ->
    # ワークテーブルの初期化処理

  # アイテム描画
  # @param [Boolean] show 要素作成後に表示するか
  itemDraw: (show = true) ->
    if !show
      @getJQueryElement().css('opacity', 0)
    else
      @getJQueryElement().css('opacity', 1)

  # CSSのルートのIDを取得
  # @return [String] CSSルートID
  getCssRootElementId: ->
    return "css_" + @id

  # CSSアニメーションルートID取得
  # @return [String] CSSアニメーションID
  getCssAnimElementId: ->
    return "css_anim_style"

  #CSSを設定
  makeCss: (forceUpdate = false) ->
    _applyCss = (designs) ->
      # CSS用のDiv作成
      if designs?
        temp = $('.cssdesign_tool_temp:first').clone(true).attr('class', '')
        temp.attr('id', @getCssRootElementId())
        if designs.values?
          for k,v of designs.values
            #if window.debug
              #console.log("k: #{k}  v: #{v}")
            temp.find(".#{k}").html("#{v}")
        if designs.flags?
          for k,v of designs.flags
            if !v
              temp.find(".#{k}").empty()
      else
        temp = $('.cssdesign_temp:first').clone(true).attr('class', '')
        temp.attr('id', @getCssRootElementId())

      temp.find('.design_item_obj_id').html(@id)
      temp.appendTo(window.cssCode)

    rootEmt = $("#{@getCssRootElementId()}")
    if rootEmt? && rootEmt.length > 0
      if forceUpdate
        # 上書きするため一旦削除
        $("#{@getCssRootElementId()}").remove()
      else
        return

    if @designs?
      # 保存しているデザインで初期化
      _applyCss.call(@, @designs)
    else
      # デフォルトのデザインで初期化
      _applyCss.call(@, @constructor.actionProperties.designConfigDefaultValues)

    @_cssRoot = $('#' + @getCssRootElementId())
    @_cssDesignToolCache = $(".css_design_tool_cache", @_cssRoot)
    @_cssDesignToolCode = $(".css_design_tool_code", @_cssRoot)
    @_cssDesignToolStyle = $(".css_design_tool_style", @_cssRoot)
    @applyDesignChange(false)

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  reDraw: (show = true, callback = null) ->
    super(show, =>
      # CSS作成
      @makeCss()
      if callback?
        callback()
    )

  # デザイン反映
  applyDesignChange: (doStyleSave) ->
    #@reDraw()
    @_cssDesignToolStyle.text(@_cssDesignToolCode.text())
    if (addStyle = @cssStyle())?
      @_cssRoot.append($("<style type='text/css'>#{addStyle}</style>"))

    if doStyleSave
      @saveDesign()

  # CSSスタイル
  # @abstract
  cssStyle: ->

  # アニメーションKeyframe
  # @abstract
  cssAnimationKeyframe: ->
    return null

  # アニメーションCSS追加処理
  appendAnimationCssIfNeeded : ->
    keyframe = @cssAnimationKeyframe()
    if keyframe?
      methodName = @getEventMethodName()
      # CSSが存在する場合は削除して入れ替え
      @removeAnimationCss()
      funcName = "#{methodName}_#{@id}"
      keyFrameName = "#{@id}_frame"
      webkitKeyframe = "@-webkit-keyframes #{keyframe}"
      mozKeyframe = "@-moz-keyframes #{keyframe}"
      duration = @eventDuration()

      # CSSに設定
      css = """
      .#{funcName}
      {
      -webkit-animation-name: #{keyFrameName};
      -moz-animation-name: #{keyFrameName};
      -webkit-animation-duration: #{duration}s;
      -moz-animation-duration: #{duration}s;
      }
      """

      window.cssCode.append("<div class='#{funcName}'><style type='text/css'> #{webkitKeyframe} #{mozKeyframe} #{css} </style></div>")

  # アニメーションCSS削除処理
  removeAnimationCss: ->
    methodName = @getEventMethodName()
    funcName = "#{methodName}_#{@id}"
    window.cssCode.find(".#{funcName}").remove()


  if window.isWorkTable
    @include(cssItemBaseWorktableExtend)

