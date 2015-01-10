# クリック用Chapterクラス
class ClickChapter extends Chapter
  # コンストラクタ
  constructor: (actorList) ->
    super(actorList)
    @riseFrontAllActor()

  # Frontに浮上
  riseFrontAllActor: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.off)
    scrollContents.css('z-index', scrollViewSwitchZindex.on)
    @actorList.forEach((actor) ->
      actor.getJQueryElement().css('z-index', scrollInsideCoverZindex + 1)
    )

  # Frontから沈む
  sinkFrontAllActor: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @actorList.forEach((actor) ->
      actor.getJQueryElement().css('z-index', 0)
    )

  # チャプターの後処理
  settleChapter: ->
    @sinkFrontAllActor()
