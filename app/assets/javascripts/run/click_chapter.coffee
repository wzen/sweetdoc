# クリック用Chapterクラス
class ClickChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    @riseFrontAllActor()

  # チャプターの後処理
  didChapter: ->
