# クリック用Chapterクラス
class ClickChapter extends Chapter

  # チャプターの前処理
  willChapter: ->
    super()
    @riseFrontAllActor()

  # チャプターの後処理
  didChapter: ->
    super()
