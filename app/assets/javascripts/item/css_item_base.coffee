# CSSアイテム
# @abstract
# @extend ItemBase
class CssItemBase extends ItemBase

  if window.loadedItemId?
    # @property [String] ITEM_ID アイテム種別
    @ITEM_ID = window.loadedItemId

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null) ->
    super(cood)
    @cssRoot = null
    @cssCache = null
    @cssCode = null
    @cssStyle = null
    if cood != null
      @moveLoc = {x:cood.x, y:cood.y}
    @cssStypeReflectTimer = null
    if window.isWorkTable
      @constructor.include WorkTableCssItemExtend


  # JSファイル読み込み時処理
  @jsLoaded: (option) ->
    # ワークテーブルの初期化処理

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  reDraw: (show = true)->
    super(show)
    @clearDraw()
    $(ElementCode.get().createItemElement(@)).appendTo(window.scrollInside)
    if !show
      @getJQueryElement().css('opacity', 0)

    if @setupDragAndResizeEvents?
      # ドラッグ & リサイズイベント設定
      @setupDragAndResizeEvents()

  # 描画削除
  clearDraw: ->
    @getJQueryElement().remove()

  # ストレージとDB保存用の最小限のデータを取得
  # @return [Array] アイテムオブジェクトの最小限データ
  getMinimumObject: ->
    obj = super()
    newobj = {
      itemId: @constructor.ITEM_ID
      mousedownCood: Common.makeClone(@mousedownCood)
    }
    $.extend(obj, newobj)
    return obj

  # 最小限のデータを設定
  # @param [Array] obj アイテムオブジェクトの最小限データ
  setMiniumObject: (obj) ->
    super(obj)
    @mousedownCood = Common.makeClone(obj.mousedownCood)

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
      temp.find('.design_item_id').html(@id)
      temp.appendTo(window.cssCode)

    # 上書きするため一旦削除
    $("#{@getCssRootElementId()}").remove()
    if !fromTemp && @designs?
      # 保存しているデザインで初期化
      _applyCss.call(@, @designs)
    else
      # デフォルトのデザインで初期化
      _applyCss.call(@, @constructor.actionProperties.designConfigDefaultValues)

    @cssRoot = $('#' + @getCssRootElementId())
    @cssCache = $(".css_cache", @cssRoot)
    @cssCode = $(".css_code", @cssRoot)
    @cssStyle = $(".css_style", @cssRoot)
    @applyDesignChange(false)

  # デザイン反映
  applyDesignChange: (doStyleSave) ->
    @reDraw()
    @cssStyle.text(@cssCode.text())
    if doStyleSave
      @saveDesign()

  # CSS内容
  # @abstract
  cssAnimationElement: ->
    return null

  # アニメーションCSS追加処理
  appendAnimationCssIfNeeded : ->
    ce = @cssAnimationElement()
    if ce?
      methodName = @getEventMethodName()
      # CSSが存在する場合は削除して入れ替え
      @removeAnimationCss()
      funcName = "#{methodName}_#{@id}"
      window.cssCode.append("<div class='#{funcName}'><style type='text/css'> #{ce} </style></div>")

  # アニメーションCSS削除処理
  removeAnimationCss: ->
    methodName = @getEventMethodName()
    funcName = "#{methodName}_#{@id}"
    window.cssCode.find(".#{funcName}").remove()
