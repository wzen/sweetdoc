# イベントリスナー Extend
EventListener =
  # アクションの初期化
  # @abstract
  initListener: (timelineEvent) ->

  setEvents: (sEventFuncName, cEventFuncName) ->
    # スクロールイベント
    if sEventFuncName? && @constructor.prototype[sEventFuncName]?
      @scrollEvent = @constructor.prototype[sEventFuncName]

    # クリックイベント
    if cEventFuncName? && @constructor.prototype[cEventFuncName]?
      clickEventFunc = @constructor.prototype[cEventFuncName]
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

CommonEventListener =
  # アクションの初期化(閲覧モードのみ使用される)
  initListener: (timelineEvent) ->

ItemEventListener =
  # アクションの初期化(閲覧モードのみ使用される)
  initListener: (itemChange) ->
    miniObj = itemChange[TLEItemChange.minObj]
    @setMiniumObject(miniObj)
    @itemSize = miniObj.itemSize

    if @reDraw?
      @reDraw(false)
    sEvent = null
    cEvent = null
    if itemChange[TimelineEvent.PageValueKey.ACTIONTYPE] == Constant.ActionEventHandleType.SCROLL
      sEvent = itemChange[TimelineEvent.PageValueKey.METHODNAME]
    else
      cEvent = itemChange[TimelineEvent.PageValueKey.METHODNAME]
    @setEvents(sEvent, cEvent)

    # 共通イベントパラメータ
    @delay = null

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->