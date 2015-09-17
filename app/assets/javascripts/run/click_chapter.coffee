# クリックチャプター
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
    @floatAllChapterEvents()
    @showGuide()

  # チャプターの後処理
  didChapter: ->
    super()
    @floatScrollHandleCanvas()
    @hideGuide()

  # クリックイベント
  # @param [Object] e クリックオブジェクト
  clickEvent: (e) ->
    @hideGuide()
    if window.disabledEventHandler
      return

    @eventObjList.forEach((event) ->
      if event.id == $(e.currentTarget).attr('id')
        event.clickEvent(e, ->
          stack = window.forkNumStacks[window.eventAction.thisPageNum()]
          if stack[stack.length - 1] != event.getForkNum()
            # フォーク番号変更
            stack.push(event.getForkNum())
            Navbar.setForkNum(event.getForkNum())
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