# スクロール用Chapterクラス
class ScrollChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    super()
    @sinkFrontAllObj()

  # チャプターの後処理
  didChapter: ->
    super()

  # スクロールイベント
  scrollEvent : (x, y) ->
    if window.disabledEventHandler
      return

    @eventObjList.forEach((event) ->
      if event.scrollEvent?
        event.scrollEvent(x, y, ->
          if window.eventAction?
            window.eventAction.thisPage().nextChapterIfFinishedAllEvent()
        )
    )

  # 全てのイベントアイテムのスクロールが終了しているか
  finishedAllEvent: ->
    ret = true
    @eventObjList.forEach((event) ->
      methodName = event.event[EventPageValueBase.PageValueKey.METHODNAME]
      if !event.isFinishedEvent
        ret = false
        return false
    )
    return ret
