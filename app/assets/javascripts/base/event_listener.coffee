# イベントリスナー Extend
EventListener =
  # アクションの初期化(閲覧モードのみ使用される)
  initListener: (timelineEvent) ->
    @timelineEvent = timelineEvent

  # アクションメソッドの設定
  setEvents: ->
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
    return

  # JQueryエレメントを取得
  # @abstract
  getJQueryElement: ->
    return null

  # チャプターを進める
  nextChapter: ->
    if window.timeLine?
      window.timeLine.nextChapter()

  # チャプター開始前イベント
  willChapter: ->
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.SCROLL
      @scrollValue = 0

    return

  # チャプター終了時イベント
  # @abstract
  didChapter: (methodName) ->
    return

  # スクロール終了判定イベント
  # @abstract
  finishedScroll: (scrollValue) ->
    return false

  # スクロール基底メソッド
  scrollRootFunc: (x, y) ->
    if !@timelineEvent[TimelineEvent.PageValueKey.METHODNAME]?
      return

    console.log("y:#{y}")
    if y >= 0
      @scrollValue += parseInt((y + 9) / 10)
    else
      @scrollValue += parseInt((y - 9) / 10)
    @scrollValue = if @scrollValue < 0 then 0 else @scrollValue
    scrollLength = @scrollLength()
    @scrollValue = if @scrollValue >= scrollLength then scrollLength - 1 else @scrollValue
    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
    (@constructor.prototype[methodName]).call(@, @scrollValue)

    if @finishedScroll(@scrollValue)
      console.log('scroll nextChapter')
      @nextChapter()

  scrollLength: ->
    return parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])

CommonEventListener =
  # アクションの初期化(閲覧モードのみ使用される)
  initListener: (timelineEvent) ->
    @timelineEvent = timelineEvent

    # アクションメソッドの設定
    @setEvents()

ItemEventListener =
  # アクションの初期化(閲覧モードのみ使用される)
  initListener: (itemChange) ->
    @timelineEvent = itemChange
    @setMiniumObject(itemChange[TLEItemChange.minObj])

    # アクションメソッドの設定
    @setEvents()

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->