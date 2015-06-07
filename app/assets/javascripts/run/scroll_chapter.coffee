# スクロール用Chapterクラス
class ScrollChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    super()
    @sinkFrontAllActor()

  # チャプターの後処理
  didChapter: ->
    super()