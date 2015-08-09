# イベントリスナー Extend
class EventBase extends Extend
  # 初期化
  initWithEvent: (timelineEvent) ->
    @setEvent(timelineEvent)

  # アクションの初期化(閲覧モードのみ使用される)
  setEvent: (timelineEvent) ->
    @timelineEvent = timelineEvent
    @isFinishedEvent = false
    @doPreviewLoop = false
    # アクションメソッドの設定
    @setMethod()

  # アクションメソッドの設定
  setMethod: ->
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
    if !@constructor.prototype[methodName]?
      # メソッドが見つからない場合
      return

    # スクロールイベント
    if actionType == Constant.ActionEventHandleType.SCROLL
      @scrollEvent = @scrollRootFunc

    # クリックイベント
    else if actionType == Constant.ActionEventHandleType.CLICK
      @clickEvent = @constructor.prototype[methodName]

  # リセット(アクション前に戻す)
  # @abstract
  reset: ->
    @isFinishedEvent = false
    return

  # プレビュー
  preview: (timelineEvent) ->
    drawDelay = 30 # 0.03秒毎スクロール描画
    loopDelay = 1000 # 1秒毎イベント実行
    loopMaxCount = 5 # ループ5回
    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]

    @initWithEvent(timelineEvent)
    @willChapter(methodName)
    @stopPreview(timelineEvent)
    @appendCssIfNeeded(methodName)

    method = @constructor.prototype[methodName]
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    # イベントループ
    @doPreviewLoop = true
    loopCount = 0
    if actionType == Constant.ActionEventHandleType.SCROLL

      p = 0
      _draw = =>
        setTimeout( =>
          if @doPreviewLoop
            method.call(@, p)
            p += 1
            if p >= @scrollLength()
              p = 0
              _loop.call(@)
            else
              _draw.call(@)
        , drawDelay)

      _loop = =>
        loopCount += 1
        if loopCount >= loopMaxCount
          @stopPreview(timelineEvent)

        setTimeout( =>
          if @doPreviewLoop
            _draw.call(@)
        , loopDelay)

      _draw.call(@)

    else if actionType == Constant.ActionEventHandleType.CLICK
      _loop = =>
        loopCount += 1
        if loopCount >= loopMaxCount
          @stopPreview(timelineEvent)

        setTimeout( =>
          if @doPreviewLoop
            method.call(@, null, _loop)
        , loopDelay)
      method.call(@, null, _loop)

  stopPreview: (timelineEvent) ->
    @doPreviewLoop = false
    if @ instanceof CanvasItemBase
      @restoreAllNewDrawedSurface()

  # JQueryエレメントを取得
  # @abstract
  getJQueryElement: ->
    return null

  # チャプターを進める
  nextChapter: ->
    if window.timeLine?
      window.timeLine.nextChapter()

  # チャプター開始前イベント
  willChapter: (methodName) ->
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.SCROLL
      @scrollValue = 0

    return

  # チャプター終了時イベント
  # @abstract
  didChapter: (methodName) ->
    return

  # スクロール基底メソッド
  scrollRootFunc: (x, y, complete = null) ->
    if !@timelineEvent[TimelineEvent.PageValueKey.METHODNAME]?
      # メソッドが無い場合
      return

    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
    if @isFinishedEvent
      # 終了済みの場合
      return

    console.log("y:#{y}")
    if y >= 0
      @scrollValue += parseInt((y + 9) / 10)
    else
      @scrollValue += parseInt((y - 9) / 10)

    sPoint = parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])
    ePoint = parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END])
    # スクロール指定範囲外なら反応させない
    if @scrollValue < sPoint || @scrollValue > ePoint
      return
    @scrollValue = if @scrollValue < sPoint then sPoint else @scrollValue
    @scrollValue = if @scrollValue > ePoint then ePoint else @scrollValue

    (@constructor.prototype[methodName]).call(@, @scrollValue - sPoint)

    if @scrollValue == ePoint
      @isFinishedEvent = true
      if complete?
        complete()

  # スクロールの長さを取得
  scrollLength: ->
    return parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])

  # CSS
  # @abstract
  cssElement: (methodName) ->
    return null

  # CSS追加処理
  appendCssIfNeeded : (methodName) ->
    ce = @cssElement(methodName)
    if ce?
      # CSSが存在する場合は削除して入れ替え
      @removeCss(methodName)
      funcName = "#{methodName}_#{@id}"
      window.cssCode.append("<div class='#{funcName}'><style type='text/css'> #{ce} </style></div>")

  # CSS削除処理
  removeCss: (methodName) ->
    funcName = "#{methodName}_#{@id}"
    window.cssCode.find(".#{funcName}").remove()

  # イベント後の表示状態にする
  updateEventAfter: ->

    if @ instanceof CanvasItemBase
      # 描画後の状態を表示
      @restoreAllNewDrawedSurface()

    else if @ instanceof CssItemBase
      # CSSアニメーション後にする
      @getJQueryElement().css({'-webkit-animation-duration':'0', '-moz-animation-duration', '0'})

    else if @ instanceof CommonEventBase
      actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
      # 共通イベントはアクションで判定
      if actionType == Constant.ActionEventHandleType.SCROLL
        # 最後までスクロールした状態
        methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
        (@constructor.prototype[methodName]).call(@, @timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END])
      else if actionType == Constant.ActionEventHandleType.CLICK
        # TODO:
        return

  # イベント前の表示状態にする
  updateEventBefore: ->
    if @ instanceof CanvasItemBase
      # 描画前の状態を表示
      @restoreAllNewDrawingSurface()

    else if @ instanceof CssItemBase
      # CSSアニメーション前
      @getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration')

    else if @ instanceof CommonEventBase
      actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
      # 共通イベントはアクションで判定
      if actionType == Constant.ActionEventHandleType.SCROLL
        # スクロール前
        methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
        (@constructor.prototype[methodName]).call(@, @timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])
      else if actionType == Constant.ActionEventHandleType.CLICK
        # TODO:
        return

  # ページング時
  clearPaging: (methodName) ->
    @removeCss(methodName)

class CommonEventBase extends EventBase
  # 初期化
  initWithEvent: (timelineEvent) ->
    super(timelineEvent)

class ItemEventBase extends EventBase
  # 初期化
  initWithEvent: (timelineEvent) ->
    super(timelineEvent)
    # 値設定
    @setMiniumObject(timelineEvent[TLEItemChange.minObj])
    # 描画してアイテムを作成
    # 表示非表示はwillChapterで切り替え
    @reDraw(false)

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->