# クリック用Chapterクラス
class ClickChapter extends Chapter
  # コンストラクタ
  constructor: (actorList) ->
    super(actorList)
    @riseFrontAllActor()

  # Frontに浮上
  riseFrontAllActor: ->
    @actorList.forEach((actor) ->
      actor.getJQueryElement().css('z-index', scrollViewZindex + 1)
    )

  # Frontから沈む
  sinkFrontAllActor: ->
    @actorList.forEach((actor) ->
      actor.getJQueryElement().css('z-index', 0)
    )

  # チャプターの後処理
  settleChapter: ->
    @sinkFrontAllActor()