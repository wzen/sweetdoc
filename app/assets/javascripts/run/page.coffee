class Page

  @PAGE_CHANGE_SCROLL_DIST = 50

  # コンストラクタ
  constructor: (eventPageValueList) ->

    @chapterList = []
    if eventPageValueList?
      eventList = []
      $.each(eventPageValueList, (idx, obj) =>
        eventList.push(obj)

        parallel = false
        if idx < eventPageValueList.length - 1
          beforeEvent = eventPageValueList[idx + 1]
          if beforeEvent[EventPageValueBase.PageValueKey.IS_PARALLEL]
            parallel = true

        if !parallel
          chapter = null
          if obj[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionEventHandleType.CLICK
            chapter = new ClickChapter({eventList: eventList, num: idx})
          else
            chapter = new ScrollChapter({eventList: eventList, num: idx})
          @chapterList.push(chapter)
          eventList = []

        return true
      )

    @chapterIndex = 0
    @doMovePage = false
    @finishedAllChapters = false
    @finishedScrollDistSum = 0

  # 現在のチャプターを取得
  thisChapter: ->
    return @chapterList[@chapterIndex]

  # 開始イベント
  start: ->
    # チャプター数設定
    Navbar.setChapterNum(@chapterIndex + 1)

    # チャプター前処理
    @sinkFrontAllChapterObj()
    @thisChapter().willChapter()

  # 全てのイベントが終了している場合、チャプターを進める
  nextChapterIfFinishedAllEvent: ->
    if @thisChapter().finishedAllEvent()
      @nextChapter()

  # チャプターを進める
  nextChapter: ->
    # チャプター後処理
    @thisChapter().didChapter()
    # indexを更新
    if @chapterList.length <= @chapterIndex + 1
      @finishAllChapters()
    else
      @chapterIndex += 1
      # チャプター数設定
      Navbar.setChapterNum(@chapterIndex + 1)
      # チャプター前処理
      @thisChapter().willChapter()

  # チャプターを戻す
  rewindChapter: ->
    @resetChapter(@chapterIndex)
    if !@thisChapter().doMoveChapter && @chapterIndex > 0
      @chapterIndex -= 1
      @resetChapter(@chapterIndex)
      Navbar.setChapterNum(@chapterIndex + 1)

    # チャプター前処理
    @thisChapter().willChapter()

  # チャプターの内容をリセット
  resetChapter: (chapterIndex) ->
    @finishedAllChapters = false
    @chapterList[chapterIndex].resetAllEvents()

  # 全てのチャプターを戻す
  rewindAllChapters: ->
    for i in [(@chapterList.length - 1)..0] by -1
      chapter = @chapterList[i]
      chapter.resetAllEvents()
    @chapterIndex = 0
    Navbar.setChapterNum(@chapterIndex + 1)
    @finishedAllChapters = false
    @start()

  # スクロールイベントをハンドル
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  handleScrollEvent: (x, y) ->
    if !@finishedAllChapters
      if @isScrollChapter()
        @thisChapter().scrollEvent(x, y)
    else
      if stopTimer != null
        clearTimeout(stopTimer)
      stopTimer = setTimeout( =>
        @finishedScrollDistSum = 0
        clearTimeout(stopTimer)
        stopTimer = null
      , 200)
      @finishedScrollDistSum += x + y
      console.log('finishedScrollDistSum:' + @finishedScrollDistSum)
      if @finishedScrollDistSum > Page.PAGE_CHANGE_SCROLL_DIST
        # 次のページに移動
        window.eventAction.nextPageIfFinishedAllChapter()

  # スクロールチャプターか判定
  isScrollChapter: ->
    return @thisChapter().scrollEvent?

  # 全てのイベントアイテムをFrontから落とす
  sinkFrontAllChapterObj: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @chapterList.forEach((chapter) ->
      chapter.sinkFrontAllObj()
    )

  # ページ前処理
  willPage: ->
    # チャプターのイベントを初期化
    @initChapterEvent()
    # フォーカス
    @initFocus()
    # リセット
    @resetAllChapters()
    # チャプター最大値設定
    Navbar.setChapterMax(@chapterList.length)
    # キャッシュ保存
    LocalStorage.saveValueForRun()

  # ページ後処理
  didPage: ->

  # チャプターのイベントを初期化
  initChapterEvent: ->
    for chapter in @chapterList
      for i in [0..(chapter.eventObjList.length - 1)]
        event = chapter.eventObjList[i]
        event.initWithEvent(chapter.eventList[i])

  # チャプターのフォーカス初期化
  initFocus: ->
    flg = false
    for chapter in @chapterList
      if flg
        return false
      for event in chapter.eventList
        if flg
          return false
        if !event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
          chapter.focusToActorIfNeed(true)
          flg = true

  # 全てのチャプター内容をリセット
  resetAllChapters: ->
    @chapterList.forEach((chapter) ->
      chapter.resetAllEvents()
    )

  # イベント終了イベント
  finishAllChapters: ->
    @finishedAllChapters = true
    if window.debug
      console.log('Finish All Chapters!')

    # ページ移動のためのスクロールイベントを取るようにする
    @sinkFrontAllChapterObj()
