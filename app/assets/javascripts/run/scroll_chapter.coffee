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

    @eventListenerList.forEach((eventListener) ->
      if eventListener.scrollEvent?
        eventListener.scrollEvent(x, y, ->
          if window.timeLine?
            window.timeLine.nextChapterIfFinishedAllEvent()
        )
    )

  # 全てのイベントアイテムのスクロールが終了しているか
  finishedAllEvent: ->
    ret = true
    @eventListenerList.forEach((eventListener) ->
      methodName = eventListener.timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
      if !eventListener.isFinishedEvent
        ret = false
        return false
    )
    return ret