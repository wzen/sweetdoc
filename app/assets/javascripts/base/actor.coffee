# アクション情報
class Actor

  # アクションの初期化(閲覧モードのみ使用される)
  initActor: (miniObj, actorSize, sEventStr, cEventStr) ->
    @setMiniumObject(miniObj)
    @actorSize = actorSize

    # TODO: 必須：セキュリティチェック
    # スクロールイベント
    if sEventStr?
      @scrollEventFunc = eval('(' + sEventStr + ')')

    # クリックイベント
    if cEventStr?
      @clickEventFunc = eval('(' + cEventStr + ')')

  # アクションのオブジェクトサイズ取得
  getActorSize: ->
    return @actorSize

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->

  # リセット(アクション前に戻す)
  # @abstract
  reset: ->

  # スクロールイベント
  scrollEvent : (x, y) ->
    if @scrollEventFunc?
      @scrollEventFunc(x, y)
  # クリックイベント
  clickEvent: (e) ->
    if @clickEventFunc?
      @clickEventFunc(e)

  # チャプターを進める
  nextChapter: ->
    if window.timeLine?
      window.timeLine.incrementChapter()
