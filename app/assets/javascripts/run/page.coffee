class Page
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
    @chapterIndex += 1
    if @chapterList.length <= @chapterIndex
      @finishAllChapters()
    else
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

    # チャプター前処理
    @thisChapter().willChapter()

  # チャプターの内容をリセット
  resetChapter: (chapterIndex) ->
    @chapterList[chapterIndex].reset()

  # 全てのチャプターを戻す
  rewindAllChapters: ->
    for i in [(@chapterList.length - 1)..0] by -1
      chapter = @chapterList[i]
      chapter.reset()
    @chapterIndex = 0
    @finishedAllChapters = false
    @start()

  # スクロールイベントをハンドル
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  handleScrollEvent: (x, y) ->
    if !@finishedAllChapters && @isScrollChapter()
      @thisChapter().scrollEvent(x, y)

  # スクロールチャプターか判定
  isScrollChapter: ->
    return @thisChapter().scrollEvent?

  # 全てのイベントアイテムをFrontから落とす
  sinkFrontAllChapterObj: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @chapterList.forEach((chapter) ->
      chapter.eventObjList.forEach((event) ->
        if event.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] == false
          event.getJQueryElement().css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + chapter.num))
      )
    )

  # ページ前処理
  willPage: ->
    # チャプターのイベントを初期化
    @initChapterEvent()
    # フォーカス
    @initFocus()


    # 全てのアイテムを削除 & 次のページデータを読み込み
    @thisChapter().reset()

    # 次ページ初期化



#    # ページング
#    pn = if beforePageNum < PageValue.getPageNum() then beforePageNum else PageValue.getPageNum()
#    pageFlip = new PageFlip(pn)
#    pageFlip.startRender(PageFlip.DIRECTION.FORWARD, ->
#    )

    Navbar.setChapterMax(@chapterList.length)
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
    for chapter in @chapterList
      for event in chapter.eventList
        if !event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
          chapter.focusToActorIfNeed(true)

  # 全てのページ内容をリセット
  reset: ->
    @chapterList.forEach((chapter) ->
      chapter.reset()
    )

  # イベント終了イベント
  finishAllChapters: ->
    @finishedAllChapters = true
    console.log('Finish All Events!')
