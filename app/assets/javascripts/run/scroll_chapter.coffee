# スクロール用Chapterクラス
class ScrollChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    super()
    @sinkFrontAllActor()

  # チャプターの後処理
  didChapter: ->
    super()

  # スクロールイベント
  scrollEvent : (x, y) ->
    if window.disabledEventHandler
      return

    @eventList.forEach((event) ->
      if event.scrollEvent?
        event.scrollEvent(x, y, ->
          if window.timeLine?
            window.timeLine.nextChapterIfFinishedAllEvent()
        )
    )

  # 全てのイベントアイテムのスクロールが終了しているか
  finishedAllEvent: ->
    ret = true
    @eventList.forEach((event) ->
      methodName = event.timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
      if !event.isFinishedEvent
        ret = false
        return false
    )
    return ret