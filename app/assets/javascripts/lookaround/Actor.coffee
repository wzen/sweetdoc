# アイテムのアクション情報
class Actor
  # コンストラクタ
  constructor: (obj) ->
    # デフォルト情報
    @defaultObj = obj
    # アクションで変化する情報
    @actionObj = obj
    # オブジェクトのID
    @objId = null

  # 初期化
  init: ->
    @actionObj = @defaultObj