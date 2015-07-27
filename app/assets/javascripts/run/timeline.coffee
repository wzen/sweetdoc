# タイムライン
class TimeLine
  # コンストラクタ
  constructor: (chapterList) ->
    @chapterList = chapterList
    @chapterIndex = 0
    @finished = false

  # 現在のチャプターを取得
  thisChapter: ->
    return @chapterList[@chapterIndex]

  # 開始イベント
  start: ->
    # チャプター前処理
    @thisChapter().willChapter()

  # 全てのイベントが終了している場合、チャプターを進める
  nextChapterIfFinishedAllEvent: ->
    if @thisChapter().finishedScrollAllActor()
      @nextChapter()

  # チャプターを進める
  nextChapter: ->
    # チャプター後処理
    @thisChapter().didChapter()
    # indexを更新
    @chapterIndex += 1
    if @chapterList.length <= @chapterIndex
      @finishTimeline()
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

  # クリックイベントをハンドル
#  handleClickEvent: (e) ->
#    if !@finished
#      @thisChapter().clickEvent(e)

  # タイムライン終了イベント
  finishTimeline: ->
    @finished = true
    console.log('Finish!')