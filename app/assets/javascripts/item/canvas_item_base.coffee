# Canvasアイテム
# @abstract
# @extend ItemBase
class CanvasItemBase extends ItemBase
  # コンストラクタ
  constructor: ->
    super()
    @newDrawingSurfaceImageData = null
    @newDrawedSurfaceImageData = null
    # @property [Array] scale 表示倍率
    @scale = {w:1.0, h:1.0}
    if window.isWorkTable
      @constructor.include WorkTableCanvasItemExtend

  # CanvasのHTML要素IDを取得
  # @return [Int] Canvas要素ID
  canvasElementId: ->
    return @id + '_canvas'

  # 伸縮率を設定
  setScale: ->
    # 要素の伸縮
    element = $("##{@id}")
    canvas = $("##{@canvasElementId()}")
    element.width(@itemSize.w * @scale.w)
    element.height(@itemSize.h * @scale.h)
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    # キャンパスの伸縮
    context = canvas[0].getContext('2d');
    context.scale(@scale.w, @scale.h)

  # キャンパス初期化処理
  initCanvas: ->
    # 伸縮率を設定
    @setScale()

  # 新規キャンパスを作成
  makeNewCanvas: ->
    $(ElementCode.get().createItemElement(@)).appendTo(window.scrollInside)
    # キャンパスに対する初期化
    @initCanvas()
    # 画面を保存
    @saveNewDrawingSurface()

  # 新規キャンパスの画面を保存
  saveNewDrawingSurface : ->
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      @newDrawingSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height)

  # 描画済みの新規キャンパスの画面を保存
  saveNewDrawedSurface : ->
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      @newDrawedSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height)

  # 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawingSurface : ->
    if @newDrawingSurfaceImageData?
      canvas = document.getElementById(@canvasElementId());
      if canvas?
        context = canvas.getContext('2d');
        context.putImageData(@newDrawingSurfaceImageData, 0, 0)

  # 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawedSurface : ->
    if @newDrawedSurfaceImageData
      canvas = document.getElementById(@canvasElementId());
      if canvas?
        context = canvas.getContext('2d');
        context.putImageData(@newDrawedSurfaceImageData, 0, 0)

  # 描画を削除
  clearDraw: ->
    canvas = document.getElementById(@canvasElementId());
    if canvas?
      context = canvas.getContext('2d');
      context.clearRect(0, 0, canvas.width, canvas.height)
      # キャンパスに対する初期化
      @initCanvas()

  # イベント適用前のオブジェクト状態を取得
  stateEventBefore: (isForward) ->
    obj = @getMinimumObject()
    if !isForward
      # サイズ変更後のScaleを計算
      scale = obj.scale
      itemDiff = @event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF]
      obj.itemSize.x -= itemDiff.x
      obj.itemSize.y -= itemDiff.y
      w = scale.w * obj.itemSize.w
      h = scale.h * obj.itemSize.h
      sw = (w - itemDiff.w) / obj.itemSize.w
      sh = (h - itemDiff.h) / obj.itemSize.h
      obj.scale.w = sw
      obj.scale.h = sh

    return obj

  # イベント適用後のオブジェクト状態を取得
  stateEventAfter: (isForward) ->
    obj = @getMinimumObject()
    if isForward
      scale = obj.scale
      itemDiff = @event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF]
      obj.itemSize.x += itemDiff.x
      obj.itemSize.y += itemDiff.y
      w = scale.w * obj.itemSize.w
      h = scale.h * obj.itemSize.h
      sw = (w + itemDiff.w) / obj.itemSize.w
      sh = (h + itemDiff.h) / obj.itemSize.h
      obj.scale.w = sw
      obj.scale.h = sh

    return obj

  # イベント前の表示状態にする
  updateEventBefore: ->
    super()
    capturedEventBeforeObject = @getCapturedEventBeforeObject()
    if capturedEventBeforeObject
      # アイテムサイズ更新
      itemSize = Common.makeClone(capturedEventBeforeObject.itemSize)
      itemSize.w *= capturedEventBeforeObject.scale.w
      itemSize.h *= capturedEventBeforeObject.scale.h
      @updatePositionAndItemSize(itemSize, false)

  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    capturedEventAfterObject = @getCapturedEventAfterObject()
    if capturedEventAfterObject
      # アイテムサイズ更新
      itemSize = Common.makeClone(capturedEventAfterObject.itemSize)
      itemSize.w *= capturedEventAfterObject.scale.w
      itemSize.h *= capturedEventAfterObject.scale.h
      @updatePositionAndItemSize(itemSize, false)

  # アイテムサイズ更新
  updateItemSize: (w, h) ->
    element = $('#' + @id)
    element.css({width: w, height: h})
    canvas = $('#' + @canvasElementId())
    scaleW = element.width() / @itemSize.w
    scaleH = element.height() / @itemSize.h
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    drawingCanvas = document.getElementById(@canvasElementId())
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.scale(scaleW, scaleH)
    @scale.w = scaleW
    @scale.h = scaleH
    @drawNewCanvas()

  # アニメーション変更前のアイテムサイズ
  originalItemElementSize: ->
    capturedEventBeforeObject = @getCapturedEventBeforeObject()
    itemSize = capturedEventBeforeObject.itemSize
    originalScale = capturedEventBeforeObject.scale
    return {
      x: itemSize.x
      y: itemSize.y
      w: itemSize.w * originalScale.w
      h: itemSize.h * originalScale.h
    }

  # CSSボタンコントロール初期化
  setupOptionMenu: ->
    super()
    item = @
    cssRoot = @cssRoot
    cssCode = @cssCode

    if @constructor.actionProperties.designConfig == Constant.ItemDesignOptionType.DESIGN_TOOL

      btnGradientStep = $(".design-gradient-step", @designConfigRoot)
      btnBgColor = $(".design-bg-color1,.design-bg-color2,.design-bg-color3,.design-bg-color4,.design-bg-color5,.design-border-color,.design-font-color", @designConfigRoot)
      btnShadowColor = $(".design-shadow-color,.design-shadowinset-color,.design-text-shadow1-color,.design-text-shadow2-color", @designConfigRoot);

      # スライダー初期化
      SidebarUI.settingGradientSlider('design-slider-gradient', null, cssCode, @designConfigRoot)
      SidebarUI.settingGradientDegSlider('design-slider-gradient-deg', 0, 315, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-border-radius', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-border-width', 0, 10, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-font-size', 0, 30, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadow-left', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadow-opacity', 0.0, 1.0, cssCode, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design-slider-shadow-size', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadow-top', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadowinset-left', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadowinset-opacity', 0.0, 1.0, cssCode, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design-slider-shadowinset-size', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-shadowinset-top', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow1-left', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow1-opacity', 0.0, 1.0, cssCode, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design-slider-text-shadow1-size', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow1-top', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow2-left', -100, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow2-opacity', 0.0, 1.0, cssCode, @designConfigRoot, 0.1)
      SidebarUI.settingSlider('design-slider-text-shadow2-size', 0, 100, cssCode, @designConfigRoot)
      SidebarUI.settingSlider('design-slider-text-shadow2-top', -100, 100, cssCode, @designConfigRoot)

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
        item.applyCssStyle()
      ).each( ->
        SidebarUI.changeGradientShow(@, cssCode, @designConfigRoot)
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
        item.applyCssStyle()
      )


  applyDesignTool: (drawingContext) ->


