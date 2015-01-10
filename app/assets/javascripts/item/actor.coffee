# アクション情報
class Actor

  # アクションの初期化(閲覧モードのみ使用される)
  initActor: (miniObj, itemSize) ->
    @setMiniumObject(miniObj)
    @itemSize = itemSize

  setEvents: (sEventFuncName, cEventFuncName) ->
    # スクロールイベント
    if sEventFuncName? && @constructor.prototype[sEventFuncName]?
      @scrollEvent = @constructor.prototype[sEventFuncName]

    # クリックイベント
    if cEventFuncName? && @constructor.prototype[cEventFuncName]?
      clickEventFunc = @constructor.prototype[cEventFuncName]
      @getJQueryElement().on('click', (e) =>
        clickEventFunc.call(@, e)
      )

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->

  # リセット(アクション前に戻す)
  # @abstract
  reset: ->

  # JQueryエレメントを取得
  # @abstract
  getJQueryElement: ->

  # チャプターを進める
  nextChapter: ->
    if window.timeLine?
      window.timeLine.nextChapter()
