# チャプター(タイムラインの区切り)
class Chapter
  constructor: (actorList) ->
    @actorList = actorList


  # スクロールイベント
  scrollEvent : (x, y) ->
    @actorList.forEach((actor) ->
      if actor.scrollEvent?
        actor.scrollEvent(x, y)
    )

  # クリックイベント
  clickEvent: (e) ->
    @actorList.forEach((actor) ->
      if actor.clickEvent?
        actor.clickEvent(e)
    )

  # チャプターの後処理
  # @abstract
  settleChapter: ->

  # アイテムにフォーカス
  focusToActor: (type = "center") ->
    # 1つ目のアイテムにフォーカスする
    item = @actorList[0]
    if type == "center"
      left = item.itemSize.x + item.itemSize.w * 0.5 - (scrollContents.width() * 0.5)
      top = item.itemSize.y + item.itemSize.h * 0.5 - (scrollContents.height() * 0.5)
      scrollContents.animate({scrollTop: top, scrollLeft: left }, 500)

