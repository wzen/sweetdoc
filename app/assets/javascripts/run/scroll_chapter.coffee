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
        eventListener.scrollEvent(x, y)
    )