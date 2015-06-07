# タイムライン
class TimeLine
  # コンストラクタ
  constructor: (chapterList) ->
    @chapterList = chapterList
    @chapterIndex = 0
    @finished = false


  # 開始イベント
  start: ->
    # チャプター前処理
    @chapterList[@chapterIndex].willChapter()

  # チャプターを進める
  nextChapter: ->
    # チャプター後処理
    @chapterList[@chapterIndex].didChapter()
    # indexを更新
    @chapterIndex += 1
    if @chapterList.length <= @chapterIndex
      @finishTimeline()
    else
      # チャプター前処理
      @chapterList[@chapterIndex].willChapter()
      # 次のアイテムにフォーカス
      @chapterList[@chapterIndex].focusToActor()

  # チャプターを戻す
  backChapter: ->
    # リセット
    @resetChapter(@chapterIndex)
    if @chapterIndex > 0
      @chapterIndex -= 1
      # 前のアイテムにフォーカス
      @chapterList[@chapterIndex].focusToActor()

  # チャプターの内容をリセット
  resetChapter: (chapterIndex) ->
    @chapterList[chapterIndex].reset()

  # スクロールイベントをハンドル
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  handleScrollEvent: (x, y) ->
    if !@finished
      @chapterList[@chapterIndex].scrollEvent(x, y)

  # クリックイベントをハンドル
  handleClickEvent: ->
    if !@finished
      @chapterList[@chapterIndex].clickEvent(e)

  # タイムライン終了イベント
  finishTimeline: ->
    @finished = true
    console.log('Finish!')