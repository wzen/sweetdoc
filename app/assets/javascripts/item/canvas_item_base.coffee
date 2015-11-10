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
      @updatePositionAndItemSize(itemSize, false, true)

  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    capturedEventAfterObject = @getCapturedEventAfterObject()
    if capturedEventAfterObject
      # アイテムサイズ更新
      itemSize = Common.makeClone(capturedEventAfterObject.itemSize)
      itemSize.w *= capturedEventAfterObject.scale.w
      itemSize.h *= capturedEventAfterObject.scale.h
      @updatePositionAndItemSize(itemSize, false, true)

  # アイテムサイズ更新
  updateItemSize: (w, h, updateInstanceInfo = true) ->
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
