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
      id = obj[EventPageValueBase.PageValueKey.ID]
      distId = obj[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]
      # インスタンス作成
      event = Common.getInstanceFromMap(id, distId)
      @eventObjList.push(event)

    @doMoveChapter = false

  # チャプター実行前処理
  willChapter: ->
    if window.runDebug
      console.log('Chapter willChapter')

    # 個々イベントのwillChapter呼び出し & CSS追加
    for event, idx in @eventObjList
      event.initEvent(@eventList[idx])
      event.willChapter()
      @doMoveChapter = false

    # 対象アイテムにフォーカス
    @focusToActorIfNeed(false)
    # イベント反応有効
    @enableEventHandle()

  # チャプター共通の後処理
  didChapter: ->
    if window.runDebug
      console.log('Chapter didChapter')

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
      if @eventList[idx][EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false &&
        @eventList[idx][EventPageValueBase.PageValueKey.DO_FOCUS]
          item = e
          return false
    )

    if item?
      # TODO: center以外も?
      if type == 'center'
        Common.focusToTarget(item.getJQueryElement(), ->
          window.disabledEventHandler = false
        , isImmediate)
    else
      # フォーカスなし
      window.disabledEventHandler = false

  # スクロールイベント用のCanvasを反応させない
  disableScrollHandleViewEvent: ->
    if window.runDebug
      console.log('Chapter floatAllChapterEvents')
    window.scrollHandleWrapper.css('pointer-events', 'none')

  # スクロールイベント用のCanvasを反応させる
  enableScrollHandleViewEvent: ->
    if window.runDebug
      console.log('Chapter floatScrollHandleCanvas')
    window.scrollHandleWrapper.css('pointer-events', '')

  # チャプターのイベントをリセットする
  resetAllEvents: (callback = null) ->
    if window.runDebug
      console.log('Chapter resetAllEvents')

    # 描画を戻す
    count = 0
    max = @eventObjList.length
    for e, idx in @eventObjList
      e.initEvent(@eventList[idx])
      e.updateEventBefore()
      e.resetProgress()
      e.refresh(e.visible, =>
        count += 1
        if count >= max
          if callback?
            callback()
      )

  # チャプターのイベントを実行後にする
  forwardAllEvents: ->
    if window.runDebug
      console.log('Chapter forwardAllEvents')

    # とりあえずフォーカスはなし
    for e, idx in @eventObjList
      e.initEvent(@eventList[idx])
      e.updateEventAfter()
      # FIXME: 状態を後に戻す(現状didChapterにしておく)
      #e.refresh()
      e.didChapter()

  # ガイド表示
  # @param [Boolean] calledByWillChapter チャプター開始時に呼ばれたか
  showGuide: (calledByWillChapter = false) ->
    return RunSetting.isShowGuide()

  # ガイド非表示
  # @abstract
  hideGuide: ->

  # イベント反応を有効にする
  enableEventHandle: ->
    @eventObjList.forEach((e) =>
      e._skipEvent = false
    )

  # イベント反応を無効にする
  disableEventHandle: ->
    @eventObjList.forEach((e) =>
      e._skipEvent = true
    )
