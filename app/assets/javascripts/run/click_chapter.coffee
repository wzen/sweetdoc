# クリック用Chapterクラス
class ClickChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    super()

    # イベント設定
    self = @
    @eventList.forEach((event) ->
      event.getJQueryElement().off('click')
      event.getJQueryElement().on('click', (e) ->
        self.clickEvent(e)
      )
    )

    @riseFrontAllActor()

  # チャプターの後処理
  didChapter: ->
    super()

  # クリックイベント
  clickEvent: (e) ->
    if window.disabledEventHandler
      return

    @eventList.forEach((event) ->
      if event.clickEvent?
        event.clickEvent(e, ->
          if window.timeLine?
            window.timeLine.nextChapterIfFinishedAllEvent()
        )
    )
