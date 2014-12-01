# タイムライン
class TimeLine
  # コンストラクタ
  constructor: (chapterList) ->
    @chapterList = chapterList
    @chapterIndex = 0

  # チャプターを進める
  incrementChapter: ->
    @chapterIndex += 1
    if @chapterList.length <= @chapterIndex
      @finishTimeline()

  # チャプターを戻す
  resetChapter: (chapterIndex) ->
    @chapterList[chapterIndex].reset()

  # スクロールイベントをハンドル
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  handleScrollEvent: (x, y) ->
    @chapterList[@chapterIndex].scrollEvent(x, y)

  # クリックイベントをハンドル
  handleClickEvent: ->
    @chapterList[@chapterIndex].clickEvent(e)

  # タイムライン終了イベント
  finishTimeline: ->
    alert('Finish!')
