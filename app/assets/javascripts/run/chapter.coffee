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

  # チャプターの前処理
  # @abstract
  willChapter: ->

  # チャプターの後処理
  # @abstract
  didChapter: ->

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

  # 全てのイベントアイテムをFrontに浮上
  riseFrontAllActor: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.off)
    scrollContents.css('z-index', scrollViewSwitchZindex.on)
    @eventListenerList.forEach((eventListener) ->
      eventListener.getJQueryElement().css('z-index', scrollInsideCoverZindex + 1)
    )

  # 全てのイベントアイテムをFrontから落とす
  sinkFrontAllActor: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @eventListenerList.forEach((eventListener) ->
      eventListener.getJQueryElement().css('z-index', 0)
    )