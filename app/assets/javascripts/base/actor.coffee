# アクション情報
class Actor
  # コンストラクタ
  constructor: ->
    # アクションイベント一覧
    @actionEventFunc = {}

  # アクションの初期化(閲覧モードのみ使用される)
  initActor: (miniObj, itemSize, sEventStr, cEventStr) ->
    @setMiniumObject(miniObj)
    @itemSize = itemSize

    # TODO: 必須：セキュリティチェック
    # スクロールイベント
    if sEventStr?
      @scrollEvent = eval('(' + sEventStr + ')')

    # クリックイベント
    if cEventStr?
      # contextを取るために必要
      _this = this

      clickEventFunc = eval('(' + cEventStr + ')')
      @getJQueryElement().on('click', clickEventFunc)

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
