# CSSアイテム
# @abstract
# @extend ItemBase
class CssItemBase extends ItemBase

  if window.loadedItemToken?
    # @property [String] ITEM_ACCESS_TOKEN アイテム種別
    @ITEM_ACCESS_TOKEN = window.loadedItemToken

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null) ->
    super(cood)
    @_cssRoot = null
    @_cssCache = null
    @_cssCode = null
    @_cssStyle = null
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @_cssStypeReflectTimer = null
    if window.isWorkTable
      @constructor.include WorkTableCssItemExtend

  # initEvent前の処理
  initEventPrepare: ->
    # デザインCSS & アニメーションCSS作成
    @makeCss()
    @appendAnimationCssIfNeeded()

 # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (callback) ->
    contents = """
          <div type="button" class="css_item_base context_base"><div></div></div>
        """
    callback(Common.wrapCreateItemElement(@, $(contents)))

  # JSファイル読み込み時処理
  @jsLoaded: (option) ->
    # ワークテーブルの初期化処理

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  reDraw: (show = true, callback = null) ->
    super(show, =>
      @clearDraw()
      @createItemElement((createdElement) =>
        $(createdElement).appendTo(window.scrollInside)
        if !show
          @getJQueryElement().css('opacity', 0)

        if @setupDragAndResizeEvents?
          # ドラッグ & リサイズイベント設定
          @setupDragAndResizeEvents()

        if callback?
          callback()
      )
    )

  # 描画削除
  clearDraw: ->
    @getJQueryElement().remove()

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    @getJQueryElement().css({width: w, height: h})
    @itemSize.w = parseInt(w)
    @itemSize.h = parseInt(h)

  # アニメーション変更前のアイテムサイズ
  originalItemElementSize: ->
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(@event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    $.extend(true, obj, diff)
    return obj.itemSize

  # CSSのルートのIDを取得
  # @return [String] CSSルートID
  getCssRootElementId: ->
    return "css_" + @id

  # CSSアニメーションルートID取得
  # @return [String] CSSアニメーションID
  getCssAnimElementId: ->
    return "css_anim_style"

  #CSSを設定
  makeCss: (fromTemp = false) ->
    _applyCss = (designs) ->
      if !designs?
        return
      temp = $('.cssdesign_temp:first').clone(true).attr('class', '')
      temp.attr('id', @getCssRootElementId())
      if designs.values?
        for k,v of designs.values
          #console.log("k: #{k}  v: #{v}")
          temp.find(".#{k}").html("#{v}")
      if designs.flags?
        for k,v of designs.flags
          if !v
            temp.find(".#{k}").empty()
      temp.find('.design_item_obj_id').html(@id)
      temp.appendTo(window.cssCode)

    # 上書きするため一旦削除
    $("#{@getCssRootElementId()}").remove()
    if !fromTemp && @designs?
      # 保存しているデザインで初期化
      _applyCss.call(@, @designs)
    else
      # デフォルトのデザインで初期化
      _applyCss.call(@, @constructor.actionProperties.designConfigDefaultValues)

    @_cssRoot = $('#' + @getCssRootElementId())
    @_cssCache = $(".css_cache", @_cssRoot)
    @_cssCode = $(".css_code", @_cssRoot)
    @_cssStyle = $(".css_style", @_cssRoot)
    @applyDesignChange(false)

  # デザイン反映
  applyDesignChange: (doStyleSave) ->
    @reDraw()
    @_cssStyle.text(@_cssCode.text())
    if doStyleSave
      @saveDesign()

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
