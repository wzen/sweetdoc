# チャプター(イベントの区切り)
class Chapter
  # ガイド表示用タイマー
  @guideTimer = null

  # コンストラクタ
  # @param [Array] list イベント情報
  constructor: (list) ->
    @eventList = list.eventList
    @num = list.num
    @eventObjList = []
    for obj in @eventList
      isCommonEvent = obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
      id = obj[EventPageValueBase.PageValueKey.ID]
      classMapId = if isCommonEvent then obj[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] else obj[EventPageValueBase.PageValueKey.ITEM_ID]
      event = Common.getInstanceFromMap(isCommonEvent, id, classMapId)
      @eventObjList.push(event)

    @doMoveChapter = false

  # チャプター実行前処理
  willChapter: ->

    # イベントのwillChapter呼び出し & CSS追加
    for event, idx in @eventObjList
      event.initEvent(@eventList[idx])
      event.willChapter()
      if event instanceof CssItemBase
        event.appendAnimationCssIfNeeded()
      @doMoveChapter = false

    # Canvasを前面に表示
    @floatScrollHandleCanvas()
    # 対象アイテムにフォーカス
    @focusToActorIfNeed(false)

  # チャプター共通の後処理
  didChapter: ->
    @eventObjList.forEach((event) ->
      event.didChapter()
    )

  # アイテムにフォーカス(アイテムが1つのみの場合)
  # @param [Boolean] isImmediate 即時反映するか
  # @param [String] フォーカスタイプ
  focusToActorIfNeed: (isImmediate, type = "center") ->
    window.disabledEventHandler = true
    item = null
    @eventObjList.forEach((e, idx) =>
      if @eventList[idx][EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
        item = e
        return false
    )

    if item?
        width = item.itemSize.w
        height = item.itemSize.h
        if item.scale?
          width *= item.scale.w
          height *= item.scale.h

        left = null
        top = null
        if type == "center"
          left = item.itemSize.x + width * 0.5 - (window.scrollContentsSize.width * 0.5)
          top = item.itemSize.y + height * 0.5 - (window.scrollContentsSize.height * 0.5)

        if isImmediate
          window.scrollContents.scrollTop(top)
          window.scrollContents.scrollLeft(left)
          window.disabledEventHandler = false
        else
          window.scrollContents.animate({scrollTop: top, scrollLeft: left }, 'normal', 'linear', ->
            window.disabledEventHandler = false
          )
    else
      window.disabledEventHandler = false

  # イベントアイテムを前面に表示
  floatAllChapterEvents: ->
    window.scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.off)
    window.scrollContents.css('z-index', scrollViewSwitchZindex.on)
    @eventObjList.forEach((e) ->
      if e.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
        e.getJQueryElement().css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
    )

  # スクロールイベント用のCanvasを前面に表示
  floatScrollHandleCanvas: ->
    window.scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    window.scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @eventObjList.forEach((e) =>
      if e.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
        e.getJQueryElement().css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + @num))
    )

  # チャプターのイベントをリセットする
  resetAllEvents: ->
    @eventObjList.forEach((e) =>
      e.resetEvent()
    )

  # チャプターのイベントを実行後にする
  forwardAllEvents: ->
    @eventObjList.forEach((e) =>
      e.forwardEvent()
    )