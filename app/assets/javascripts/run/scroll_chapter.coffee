# スクロール用Chapterクラス
class ScrollChapter extends Chapter
  # チャプターの前処理
  willChapter: (callback = null) ->
    super( =>
      @enableScrollHandleViewEvent()
      # スクロール位置初期化
      RunCommon.initHandleScrollView()
      # ガイド表示
      @showGuide(true)
      if callback?
        callback()
    )

  # チャプターの後処理
  didChapter: (callback = null) ->
    super( =>
      @hideGuide()
      if callback?
        callback()
    )

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
    if !@isFinishedAllEvent()
      @showGuide()

  # ガイド表示
  # @param [Boolean] calledByWillChapter チャプター開始時に呼ばれたか
  showGuide: (calledByWillChapter = false) ->
    if !super(calledByWillChapter)
      return false
    @hideGuide()
    idleTime = ScrollGuide.IDLE_TIMER
    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は即表示
      idleTime = 0

    @constructor.guideTimer = setTimeout( =>
      # ガイド表示
      @adjustGuideParams(calledByWillChapter)
      ScrollGuide.showGuide(@_enabledDirections, @_forwardDirections, @canForward, @canReverse)
    , idleTime)

  # ガイド非表示
  hideGuide: ->
    if @constructor.guideTimer?
      clearTimeout(@constructor.guideTimer)
      @constructor.guideTimer = null
    ScrollGuide.hideGuide()
    ClickGuide.hideGuide()

  # ガイドフラグ調整
  # @param [Boolean] calledByWillChapter チャプター開始時に呼ばれたか
  adjustGuideParams: (calledByWillChapter) ->
    @_enabledDirections = {
      top: false
      bottom: false
      left: false
      right: false
    }
    @_forwardDirections = {
      top: false
      bottom: false
      left: false
      right: false
    }
    @canForward = false
    @canReverse = false
    @eventObjList.forEach((event) =>
      if !event._isFinishedEvent
        # trueフラグ優先にまとめる
        for k, v of event._enabledDirections
          if !@_enabledDirections[k]
            @_enabledDirections[k] = v
        for k, v of event._forwardDirections
          if !@_forwardDirections[k]
            @_forwardDirections[k] = v

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
  isFinishedAllEvent: (cached = false) ->
    if cached && @_isFinishedAllEventCache?
      return @_isFinishedAllEventCache
    ret = true
    @eventObjList.forEach((event) ->
      if !event._isFinishedEvent
        ret = false
        return false
    )
    @_isFinishedAllEventCache = ret
    return ret

