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
      @scrollEvent = @constructor.prototype[methodName]

    # クリックイベント
    if actionType == Constant.ActionEventHandleType.CLICK
      clickEventFunc = @constructor.prototype[methodName]
      @getJQueryElement().on('click', (e) =>
        clickEventFunc.call(@, e)
      )

  # リセット(アクション前に戻す)
  # @abstract
  reset: ->

  # JQueryエレメントを取得
  # @abstract
  getJQueryElement: ->

  # チャプターを進める
  nextChapter: ->
    if window.timeLine?
      window.timeLine.nextChapter()

  # チャプター開始前イベント
  # @abstract
  willChapter: (methodName) ->

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

    # 描画
    if @reDraw?
      @reDraw(false)

    # アクションメソッドの設定
    @setEvents()

    # 共通イベントパラメータ
    @delay = null

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->