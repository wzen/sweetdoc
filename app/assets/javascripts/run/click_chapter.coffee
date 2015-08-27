# クリック用Chapterクラス
class ClickChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    super()

    # イベント設定
    self = @
    @eventObjList.forEach((event) ->
      event.getJQueryElement().off('click')
      event.getJQueryElement().on('click', (e) ->
        self.clickEvent(e)
      )

    )
    @riseFrontAllObj(@eventObjList)

  # チャプターの後処理
  didChapter: ->
    super()
    @sinkFrontAllObj()

  # クリックイベント
  clickEvent: (e) ->
    if window.disabledEventHandler
      return

    @eventObjList.forEach((event) ->
      if event.clickEvent?
        event.clickEvent(e, ->
          if window.eventAction?
            window.eventAction.nextChapterIfFinishedAllEvent()
        )
    )