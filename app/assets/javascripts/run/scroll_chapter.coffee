# スクロール用Chapterクラス
class ScrollChapter extends Chapter
  # チャプターの前処理
  willChapter: ->
    super()
    @floatScrollHandleCanvas()

    # ガイド表示
    @showGuide(true)

  # チャプターの後処理
  didChapter: ->
    super()
    @hideGuide()

  # スクロールイベント
  # @param [Integer] x 横方向スクロール位置
  # @param [Integer] y 縦方向スクロール位置
  scrollEvent : (x, y) ->
    if window.disabledEventHandler
      return

    @eventObjList.forEach((event) =>
      if event.scrollEvent?
        event.scrollEvent(x, y, =>
          @hideGuide()
          if window.eventAction?
            window.eventAction.thisPage().nextChapterIfFinishedAllEvent()
        )
    )
    if !@finishedAllEvent()
      @showGuide()

  # ガイド表示
  # @param [Boolean] calledByWillChapter チャプター開始時に呼ばれたか
  showGuide: (calledByWillChapter = false) ->
    @hideGuide()
    @constructor.guideTimer = setTimeout( =>
      # ガイド表示
      @adjustGuideParams(calledByWillChapter)
      ScrollGuide.showGuide(@enabledDirections, @forwardDirections, @canForward, @canReverse)
    , ScrollGuide.IDLE_TIMER)

  # ガイド非表示
  hideGuide: ->
    if @constructor.guideTimer?
      clearTimeout(@constructor.guideTimer)
      @constructor.guideTimer = null
    ScrollGuide.hideGuide()

  # ガイドフラグ調整
  # @param [Boolean] calledByWillChapter チャプター開始時に呼ばれたか
  adjustGuideParams: (calledByWillChapter) ->
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
      if !event.isFinishedEvent
        # trueフラグ優先にまとめる
        for k, v of event.enabledDirections
          if !@enabledDirections[k]
            @enabledDirections[k] = v
        for k, v of event.forwardDirections
          if !@forwardDirections[k]
            @forwardDirections[k] = v

        if !calledByWillChapter
          if event.canForward? && event.canForward
            @canForward = true
          if event.canReverse? && event.canReverse
            @canReverse = true
    )

    if calledByWillChapter
      # チャプター開始時はForwardのみ
      @canForward = true
      @canReverse = false

  # 全てのイベントアイテムのスクロールが終了しているか
  # @return [Boolean] 判定結果
  finishedAllEvent: ->
    ret = true
    @eventObjList.forEach((event) ->
      methodName = event.event[EventPageValueBase.PageValueKey.METHODNAME]
      if !event.isFinishedEvent
        ret = false
        return false
    )
    return ret

