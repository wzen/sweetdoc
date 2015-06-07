# スクロール用Chapterクラス
class ScrollChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    @sinkFrontAllActor()