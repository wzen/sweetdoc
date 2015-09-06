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
    @showGuide()

  # チャプターの後処理
  didChapter: ->
    super()
    @sinkFrontAllObj()
    @hideGuide()

  # クリックイベント
  clickEvent: (e) ->
    @hideGuide()
    if window.disabledEventHandler
      return

    @eventObjList.forEach((event) ->
      if event.clickEvent?
        event.clickEvent(e, ->
          if window.eventAction?
            window.eventAction.thisPage().nextChapterIfFinishedAllEvent()
        )
    )

  # ガイド表示
  showGuide: ->
    @hideGuide()
    @constructor.guideTimer = setTimeout( =>
      # ガイド表示
      items = []
      @eventObjList.forEach((event) ->
        if event instanceof ItemBase
          items.push(event)
      )
      ClickGuide.showGuide(items)
    , ClickGuide.IDLE_TIMER)

  # ガイド非表示
  hideGuide: ->
    if @constructor.guideTimer?
      clearTimeout(@constructor.guideTimer)
      @constructor.guideTimer = null
    ClickGuide.hideGuide()