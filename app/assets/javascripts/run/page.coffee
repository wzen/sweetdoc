class Page
  # コンストラクタ
  constructor: (@chapterList) ->
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
  willForwardPage: ->
    # 全てのアイテムを削除 & 次のページデータを読み込み

    @thisChapter().reset()

#    # ページング
#    pn = if beforePageNum < window.pageNum then beforePageNum else window.pageNum
#    pageFlip = new PageFlip(pn)
#    pageFlip.startRender(PageFlip.DIRECTION.FORWARD, ->
#    )

    Navbar.setChapterMax(@chapterList.length)

  # ページ後処理
  didPage: ->


  # 全てのページ内容をリセット
  reset: ->
    @chapterList.forEach((chapter) ->
      chapter.reset()
    )

  # イベント終了イベント
  finishAllChapters: ->
    @finishedAllChapters = true
    console.log('Finish All Events!')
