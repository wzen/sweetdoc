# チャプター(タイムラインの区切り)
class Chapter
  constructor: (eventListenerList) ->
    @eventListenerList = eventListenerList


  # スクロールイベント
  scrollEvent : (x, y) ->
    @eventListenerList.forEach((eventListener) ->
      if eventListener.scrollEvent?
        eventListener.scrollEvent(x, y)
    )

  # クリックイベント
  clickEvent: (e) ->
    @eventListenerList.forEach((eventListener) ->
      if eventListener.clickEvent?
        eventListener.clickEvent(e)
    )

  # チャプターの後処理
  # @abstract
  settleChapter: ->

  # アイテムにフォーカス
  focusToActor: (type = "center") ->
    # 1つ目のアイテムにフォーカスする
    item = @eventListenerList[0]
    width = item.itemSize.w
    height = item.itemSize.h
    if item.scale?
      width *= item.scale.w
      height *= item.scale.h

    if type == "center"
      left = item.itemSize.x + width * 0.5 - (scrollContents.width() * 0.5)
      top = item.itemSize.y + height * 0.5 - (scrollContents.height() * 0.5)
      scrollContents.animate({scrollTop: top, scrollLeft: left }, 500)

