# イベント実行クラス
class EventAction
  # コンストラクタ
  constructor: (@chapterList) ->
    @chapterIndex = 0
    @finished = false

  # 現在のチャプターを取得
  thisChapter: ->
    return @chapterList[@chapterIndex]

  # 開始イベント
  start: ->
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
      @finishAllEvents()
    else
      # チャプター前処理
      @thisChapter().willChapter()

  # チャプターを戻す
  backChapter: ->
    # リセット
    @resetChapter(@chapterIndex)
    if @chapterIndex > 0
      @chapterIndex -= 1
      # 前のアイテムにフォーカス
      @thisChapter().focusToActorIfNeed(false)

  # チャプターの内容をリセット
  resetChapter: (chapterIndex) ->
    @chapterList[chapterIndex].reset()

  # スクロールイベントをハンドル
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  handleScrollEvent: (x, y) ->
    if !@finished && @isScrollChapter()
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
          event.getJQueryElement().css('z-index', Constant.Zindex.EVENTBOTTOM + chapter.num)
      )
    )

  # イベント終了イベント
  finishAllEvents: ->
    @finished = true
    console.log('Finish!')