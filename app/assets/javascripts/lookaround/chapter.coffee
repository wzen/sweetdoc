# チャプター(タイムラインの区切り)
class Chapter
  constructor: (actorList) ->
    @actorList = actorList


  # スクロールイベント
  scrollEvent : (x, y) ->
    @actorList.forEach((actor) ->
      actor.scrollEvent(x, y)
    )
  # クリックイベント
  clickEvent: (e) ->
    @actorList.forEach((actor) ->
      actor.clickEvent(e)
    )

  # チャプターの後処理
  # @abstract
  settleChapter: ->


