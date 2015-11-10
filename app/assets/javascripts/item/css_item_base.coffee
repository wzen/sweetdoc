# CSSアイテム
# @abstract
# @extend ItemBase
class CssItemBase extends ItemBase

  # @property [String] CSSTEMPID CSSテンプレートID
  @CSSTEMPID = ''

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
    css_temp = option.css_temp
    if css_temp?
      # CSSテンプレートを設置
      tempEmt = "<div id='#{@CSSTEMPID}'>#{css_temp}</div>"
      window.cssCodeInfoTemp.append(tempEmt)

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
      css: @cssRoot[0].outerHTML
    }
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
      @updatePositionAndItemSize(Common.makeClone(capturedEventBeforeObject.itemSize), false, true)

  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    capturedEventAfterObject = @getCapturedEventAfterObject()
    if capturedEventAfterObject
      # アイテムサイズ更新
      @updatePositionAndItemSize(Common.makeClone(capturedEventAfterObject.itemSize), false, true)

  # アイテムサイズ更新
  updateItemSize: (w, h, updateInstanceInfo = true) ->
    @getJQueryElement().css({width: w, height: h})
    if updateInstanceInfo
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
    return "css-" + @id

  # CSSアニメーションルートID取得
  # @return [String] CSSアニメーションID
  getCssAnimElementId: ->
    return "css-anim-style"

  #CSSを設定
  makeCss: (fromTemp = false) ->
    newEmt = null

    # 存在する場合消去して上書き
    $("#{@getCssRootElementId()}").remove()

    if !fromTemp && @css?
      # 設定済みのCSSプロパティから作成
      newEmt = $(@css)
    else
      # CSSテンプレートから作成
      newEmt = $('#' + @constructor.CSSTEMPID).clone(true).attr('id', @getCssRootElementId())
      newEmt.find('.design-item-id').html(@id)
    window.cssCodeInfo.append(newEmt)
    @cssRoot = $('#' + @getCssRootElementId())
    @cssCache = $(".css-cache", @cssRoot)
    @cssCode = $(".css-code", @cssRoot)
    @cssStyle = $(".css-style", @cssRoot)

    @reflectCssStyle(false)

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
  reflectCssStyle: (doStyleSave = true) ->
    @cssStyle.text(@cssCode.text())
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
    cssCache = @cssCache
    cssCode = @cssCode
    cssStyle = @cssStyle

    if @constructor.actionProperties.designConfig == Constant.ItemDesignOptionType.DESIGN_TOOL

      btnGradientStep = $(".design-gradient-step", @designConfigRoot)
      btnBgColor = $(".design-bg-color1,.design-bg-color2,.design-bg-color3,.design-bg-color4,.design-bg-color5,.design-border-color,.design-font-color", @designConfigRoot)
      btnShadowColor = $(".design-shadow-color,.design-shadowinset-color,.design-text-shadow1-color,.design-text-shadow2-color", @designConfigRoot);

      # スライダー初期化
      SidebarUI.settingGradientSlider('design-slider-gradient', null, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingGradientDegSlider('design-slider-gradient-deg', 0, 315, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-border-radius', 0, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-border-width', 0, 10, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-font-size', 0, 30, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadow-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadow-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design-slider-shadow-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadow-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadowinset-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadowinset-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design-slider-shadowinset-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadowinset-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow1-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow1-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design-slider-text-shadow1-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow1-top', -100, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow2-left', -100, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow2-opacity', 0.0, 1.0, cssCode, cssStyle, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design-slider-text-shadow2-size', 0, 100, cssCode, cssStyle, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow2-top', -100, 100, cssCode, cssStyle, @designConfigRoot)

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
            item.reflectCssStyle()
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
            item.reflectCssStyle()
        )
      )

      # グラデーションStepイベント
      btnGradientStep.off('keyup mouseup')
      btnGradientStep.on('keyup mouseup', (e) ->
        SidebarUI.changeGradientShow(e.currentTarget, cssCode, cssStyle, @designConfigRoot)
        stepValue = parseInt($(e.currentTarget).val())
        for i in [2 .. 4]
          className = 'design-bg-color' + i
          mozFlag = $("." + className + "-moz-flag", cssRoot)
          mozCache = $("." + className + "-moz-cache", cssRoot)
          webkitFlag = $("." + className + "-webkit-flag", cssRoot)
          webkitCache = $("." + className + "-webkit-cache", cssRoot)
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
        item.reflectCssStyle()
      ).each( ->
        SidebarUI.changeGradientShow(@, cssCode, cssStyle, @designConfigRoot)
        stepValue = parseInt($(@).val())
        for i in [2 .. 4]
          className = 'design-bg-color' + i
          mozFlag = $("." + className + "-moz-flag", cssRoot)
          mozCache = $("." + className + "-moz-cache", cssRoot)
          webkitFlag = $("." + className + "-webkit-flag", cssRoot)
          webkitCache = $("." + className + "-webkit-cache", cssRoot)
          if i > stepValue - 1
            mh = mozFlag.html()
            if mh.length > 0
              mozCache.html(mh)
            wh = webkitFlag.html()
            if wh.length > 0
              webkitCache.html(wh)
            $(mozFlag).empty()
            $(webkitFlag).empty()
        item.reflectCssStyle()
      )

