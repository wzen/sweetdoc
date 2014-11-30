# タイムライン
class TimeLine
  # コンストラクタ
  constructor: (chapterList) ->
    @chapterList = chapterList
    @chapterIndex = 0

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