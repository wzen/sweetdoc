# CSSアイテム
# @abstract
# @extend ItemBase
class CssItemBase extends ItemBase

  if window.loadedItemId?
    # @property [String] ITEM_ID アイテム種別
    @ITEM_ID = window.loadedItemId

  if gon?
    constant = gon.const

    @DESIGN_ROOT_CLASSNAME = constant.DesignConfig.ROOT_CLASSNAME

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

  # イベント適用前のオブジェクト状態を取得
  stateEventBefore: (isForward) ->
    obj = @getMinimumObject()
    if !isForward
      # サイズ変更後
      itemSize = obj.itemSize
      itemDiff = @event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF]
      obj.itemSize = {
        x: itemSize.x - itemDiff.x
        y: itemSize.y - itemDiff.y
        w: itemSize.w - itemDiff.w
        h: itemSize.h - itemDiff.h
      }

    console.log("stateEventBefore")
    console.log(obj)
    return obj

  # イベント適用後のオブジェクト状態を取得
  stateEventAfter: (isForward) ->
    obj = @getMinimumObject()
    if isForward
      # サイズ変更後
      obj = @getMinimumObject()
      itemSize = obj.itemSize
      itemDiff = @event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF]
      obj.itemSize = {
        x: itemSize.x + itemDiff.x
        y: itemSize.y + itemDiff.y
        w: itemSize.w + itemDiff.w
        h: itemSize.h + itemDiff.h
      }

    console.log("stateEventAfter")
    console.log(obj)
    return obj

  # イベント前の表示状態にする
  updateEventBefore: ->
    super()
    capturedEventBeforeObject = @getCapturedEventBeforeObject()
    if capturedEventBeforeObject
      # アイテムサイズ更新
      @updatePositionAndItemSize(Common.makeClone(capturedEventBeforeObject.itemSize), false)

  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    capturedEventAfterObject = @getCapturedEventAfterObject()
    if capturedEventAfterObject
      # アイテムサイズ更新
      @updatePositionAndItemSize(Common.makeClone(capturedEventAfterObject.itemSize), false)

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    @getJQueryElement().css({width: w, height: h})
    @itemSize.w = parseInt(w)
    @itemSize.h = parseInt(h)

  # アニメーション変更前のアイテムサイズ
  originalItemElementSize: ->
    capturedEventBeforeObject = @getCapturedEventBeforeObject()
    return capturedEventBeforeObject.itemSize

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
    # 上書きするため一旦削除
    $("#{@getCssRootElementId()}").remove()

    temp = $('.cssdesign_temp:first').clone(true).attr('class', '')
    temp.attr('id', @getCssRootElementId())

    if !fromTemp && @design?
      # 保存しているデザインで初期化
      for k,v of @design
        #console.log("k: #{k}  v: #{v}")
        temp.find(".#{k}").html("#{v}")
    else
      if @constructor.actionProperties.designConfigDefaultValues?
        # デフォルトのデザインで初期化
        for k,v of @constructor.actionProperties.designConfigDefaultValues
          #console.log("k: #{k}  v: #{v}")
          temp.find(".#{k}").html("#{v}")
    temp.find('.design_item_id').html(@id)
    temp.appendTo(window.cssCode)

    @cssRoot = $('#' + @getCssRootElementId())
    @cssCache = $(".css_cache", @cssRoot)
    @cssCode = $(".css_code", @cssRoot)
    @cssStyle = $(".css_style", @cssRoot)

    @applyDesignChange(false)

  # CSSに反映
  applyDesignChange: (doStyleSave) ->
    @cssStyle.text(@cssCode.text())
    if doStyleSave
      # 頻繁に呼ばれるためタイマーでPageValueに書き込む
      if @cssStypeReflectTimer?
        clearTimeout(@cssStypeReflectTimer)
        @cssStypeReflectTimer = null
      @cssStypeReflectTimer = setTimeout( =>
        # 0.5秒後に反映
        # ページに状態を保存
        @setItemAllPropToPageValue()
        # キャッシュに保存
        LocalStorage.saveAllPageValues()
        @cssStypeReflectTimer = setTimeout( ->
          # 1秒後に操作履歴に保存
          OperationHistory.add()
        , 1000)
      , 500)

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
