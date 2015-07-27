# イベントリスナー Extend
EventListener =
  # アクションの初期化(閲覧モードのみ使用される)
  setEvent: (timelineEvent) ->
    @timelineEvent = timelineEvent
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
  finishedScroll: (methodName, scrollValue) ->
    return scrollValue >= @scrollLength() - 1

  # スクロール基底メソッド
  scrollRootFunc: (x, y) ->
    if !@timelineEvent[TimelineEvent.PageValueKey.METHODNAME]?
      # メソッドが無い場合
      return

    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
    if @finishedScroll(methodName, @scrollValue)
      # 終了済みの場合
      return

    console.log("y:#{y}")
    if y >= 0
      @scrollValue += parseInt((y + 9) / 10)
    else
      @scrollValue += parseInt((y - 9) / 10)
    @scrollValue = if @scrollValue < 0 then 0 else @scrollValue
    scrollLength = @scrollLength()
    @scrollValue = if @scrollValue >= scrollLength then scrollLength - 1 else @scrollValue

    # スクロール指定範囲外なら反応させない
    if @scrollValue < parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START]) || @scrollValue > parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END])
      return

    (@constructor.prototype[methodName]).call(@, @scrollValue)

    if @finishedScroll(methodName, @scrollValue)
      console.log('scroll nextChapter')
      if window.timeLine?
        chapter = window.timeLine.getChapter()
        if chapter.finishedScrollAllActor()
          # 全てのアイテムのスクロールが終了している場合は次のチャプターへ
          @nextChapter()

  scrollLength: ->
    return parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])

CommonEventListener =
  # 初期化
  initWithEvent: (timelineEvent) ->

ItemEventListener =
  # 初期化
  initWithEvent: (timelineEvent) ->
    @setMiniumObject(timelineEvent[TLEItemChange.minObj])

    # アイテムを描画
    # TODO: 設定で初期表示させるか切り替えさせる
#    if @reDraw?
#      @reDraw(false)

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->