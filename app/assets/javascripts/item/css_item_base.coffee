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
    @css = null
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
    if !@cssRoot?
      @cssRoot = $('#' + @getCssRootElementId())
    if @cssRoot? && @cssRoot.length > 0
      newobj['css'] = @cssRoot[0].outerHTML
    $.extend(obj, newobj)
    return obj

  # 最小限のデータを設定
  # @param [Array] obj アイテムオブジェクトの最小限データ
  setMiniumObject: (obj) ->
    super(obj)
    @mousedownCood = Common.makeClone(obj.mousedownCood)
    @css = Common.makeClone(obj.css)

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

  # CSS内のオブジェクトIDを自身のものに変更
  changeCssId: (oldObjId) ->
    reg = new RegExp(oldObjId, 'g')
    @css = @css.replace(reg, @id)

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

    # 存在する場合消去して上書き
    $("#{@getCssRootElementId()}").remove()

    if !fromTemp && @css?
      temp = $(@css)
      temp.appendTo(window.cssCodeInfoTemp)
    else
      # CSSを作成
      temp = $('.cssdesign_temp:first').clone(true).attr('class', '')
      temp.attr('id', @getCssRootElementId())
      if @constructor.actionProperties.designConfigDefaultValues?
        # 初期化
        for k,v of @constructor.actionProperties.designConfigDefaultValues
          console.log("k: #{k}  v: #{v}")
          temp.find(".#{k}").html("#{v}")
      temp.find('.design_item_id').html(@id)
      temp.appendTo(window.cssCodeInfoTemp)

    @cssRoot = $('#' + @getCssRootElementId())
    @cssCache = $(".css_cache", @cssRoot)
    @cssCode = $(".css_code", @cssRoot)
    @cssStyle = $(".css_style", @cssRoot)

    @applyCssStyle(false)

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
      @removeCss()
      funcName = "#{methodName}_#{@id}"
      window.cssCode.append("<div class='#{funcName}'><style type='text/css'> #{ce} </style></div>")

  # CSSのスタイルを反映
  applyCssStyle: (doStyleSave = true) ->
    @cssStyle.text(@cssCode.text())
    if @cssRoot?
      @css = @cssRoot[0].outerHTML

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

  # CSS削除処理
  removeCss: ->
    methodName = @getEventMethodName()
    funcName = "#{methodName}_#{@id}"
    window.cssCode.find(".#{funcName}").remove()

  # CSSボタンコントロール初期化
  setupOptionMenu: ->
    super()
    item = @
    cssRoot = @cssRoot
    cssCode = @cssCode

    if @constructor.actionProperties.designConfig == Constant.ItemDesignOptionType.DESIGN_TOOL

      btnGradientStep = $(".design_gradient_step", @designConfigRoot)
      btnBgColor = $(".design_bg_color1,.design_bg_color2,.design_bg_color3,.design_bg_color4,.design_bg_color5,.design_border_color,.design_font_color", @designConfigRoot)
      btnShadowColor = $(".design_shadow_color,.design_shadowinset_color,.design_text_shadow1_color,.design_text_shadow2_color", @designConfigRoot);

      # スライダー初期化
      SidebarUI.settingGradientSlider('design_slider_gradient', null, cssCode, @designConfigRoot)
      SidebarUI.settingGradientDegSlider('design_slider_gradient_deg', 0, 315, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_border_radius', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_border_width', 0, 10, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_font_size', 0, 30, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_shadow_left', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_shadow_opacity', 0.0, 1.0, cssCode, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design_slider_shadow_size', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_shadow_top', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_shadowinset_left', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_shadowinset_opacity', 0.0, 1.0, cssCode, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design_slider_shadowinset_size', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_shadowinset_top', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_text_shadow1_left', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_text_shadow1_opacity', 0.0, 1.0, cssCode, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design_slider_text_shadow1_size', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_text_shadow1_top', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_text_shadow2_left', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_text_shadow2_opacity', 0.0, 1.0, cssCode, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design_slider_text_shadow2_size', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design_slider_text_shadow2_top', -100, 100, cssCode, @designConfigRoot)

      # オプションメニューを作成
      # カラーピッカーイベント
      btnBgColor.each( ->
        self = $(@)
        className = self[0].classList[0]
        btnCodeEmt = cssCode.find("." + className).first()
        colorValue = btnCodeEmt.text()
        ColorPickerUtil.initColorPicker(
          self,
          colorValue,
          (a, b, d) ->
            btnCodeEmt = cssCode.find("." + className)
            btnCodeEmt.text(b)
            item.applyCssStyle()
        )
      )
      btnShadowColor.each( ->
        self = $(@)
        className = self[0].classList[0]
        btnCodeEmt = cssCode.find("." + className).first()
        colorValue = btnCodeEmt.text()
        ColorPickerUtil.initColorPicker(
          self,
          colorValue,
          (a, b, d) ->
            btnCodeEmt = cssCode.find("." + className)
            btnCodeEmt.text(d.r + "," + d.g + "," + d.b)
            item.applyCssStyle()
        )
      )

      # グラデーションStepイベント
      btnGradientStep.off('keyup mouseup')
      btnGradientStep.on('keyup mouseup', (e) ->
        SidebarUI.changeGradientShow(e.currentTarget, cssCode, @designConfigRoot)
        stepValue = parseInt($(e.currentTarget).val())
        for i in [2 .. 4]
          className = 'design_bg_color' + i
          mozFlag = $("." + className + "_moz_flag", cssRoot)
          mozCache = $("." + className + "_moz_cache", cssRoot)
          webkitFlag = $("." + className + "_webkit_flag", cssRoot)
          webkitCache = $("." + className + "_webkit_cache", cssRoot)
          if i > stepValue - 1
            mh = mozFlag.html()
            if mh.length > 0
              mozCache.html(mh)
            wh = webkitFlag.html()
            if wh.length > 0
              webkitCache.html(wh)
            $(mozFlag).empty()
            $(webkitFlag).empty()
          else
            mozFlag.html(mozCache.html());
            webkitFlag.html(webkitCache.html())
        item.applyCssStyle()
      ).each( ->
        SidebarUI.changeGradientShow(@, cssCode, @designConfigRoot)
        stepValue = parseInt($(@).val())
        for i in [2 .. 4]
          className = 'design_bg_color' + i
          mozFlag = $("." + className + "_moz_flag", cssRoot)
          mozCache = $("." + className + "_moz_cache", cssRoot)
          webkitFlag = $("." + className + "_webkit_flag", cssRoot)
          webkitCache = $("." + className + "_webkit_cache", cssRoot)
          if i > stepValue - 1
            mh = mozFlag.html()
            if mh.length > 0
              mozCache.html(mh)
            wh = webkitFlag.html()
            if wh.length > 0
              webkitCache.html(wh)
            $(mozFlag).empty()
            $(webkitFlag).empty()
        item.applyCssStyle()
      )

