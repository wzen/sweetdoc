# スクロール用Chapterクラス
class ScrollChapter extends Chapter
  @guideTimer = null

  constructor: (list) ->
    super(list)

  # チャプターの前処理
  willChapter: ->
    super()
    @sinkFrontAllObj()

    # ガイド表示
    @showGuide(true)

  # チャプターの後処理
  didChapter: ->
    super()

  # スクロールイベント
  scrollEvent : (x, y) ->
    if window.disabledEventHandler
      return

    @eventObjList.forEach((event) =>
      if event.scrollEvent?
        event.scrollEvent(x, y, =>
          # ガイド停止
          if @constructor.guideTimer?
            clearTimeout(@constructor.guideTimer)
            @constructor.guideTimer = null
          ScrollGuide.hideGuide()
          if window.eventAction?
            window.eventAction.thisPage().nextChapterIfFinishedAllEvent()
        )
    )
    if !@finishedAllEvent()
      @showGuide()

  # ガイド表示
  showGuide: (willChapter = false) ->
    if @constructor.guideTimer?
      clearTimeout(@constructor.guideTimer)
      @constructor.guideTimer = null
    ScrollGuide.hideGuide()
    @constructor.guideTimer = setTimeout( =>
      # ガイド表示
      @adjustGuideParams(willChapter)
      ScrollGuide.showGuide(@enabledDirections, @forwardDirections, @canForward, @canReverse)
    , ScrollGuide.IDLE_TIMER)

  # ガイドフラグ調整
  adjustGuideParams: (willChapter) ->
    @enabledDirections = {
      top: false
      bottom: false
      left: false
      right: false
    }
    @forwardDirections = {
      top: false
      bottom: false
      left: false
      right: false
    }
    @canForward = false
    @canReverse = false
    @eventObjList.forEach((event) =>
      # trueフラグ優先にまとめる
      for k, v of event.enabledDirections
        if !@enabledDirections[k]
          @enabledDirections[k] = v
      for k, v of event.forwardDirections
        if !@forwardDirections[k]
          @forwardDirections[k] = v

      if !willChapter
        if event.canForward? && event.canForward
          @canForward = true
        if event.canReverse? && event.canReverse
          @canReverse = true
    )

    if willChapter
      # チャプター開始時はForwardのみ
      @canForward = true
      @canReverse = false

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
