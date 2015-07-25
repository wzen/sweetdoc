# クリック用Chapterクラス
class ClickChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    super()

    # イベント設定
    self = @
    @eventListenerList.forEach((eventListener) ->
      eventListener.getJQueryElement().off('click')
      eventListener.getJQueryElement().on('click', (e) ->
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

    @eventListenerList.forEach((eventListener) ->
      if eventListener.clickEvent?
        eventListener.clickEvent(e)
    )
