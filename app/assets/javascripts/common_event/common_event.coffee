# 共通イベント基底クラス
class CommonEvent extends CommonEventBase
  @EVENT_ID = ''

  constructor: ->
    super()
    # @property [Int] id ID
    @id = "c" + @constructor.EVENT_ID + Common.generateId()
    # modifiables変数の初期化
    if @constructor.actionProperties.modifiables?
      for varName, value of @constructor.actionProperties.modifiables
        @[varName] = value.default

  # 保存用の最小限のデータを取得
  getMinimumObject: ->
    obj = {
      id: Common.makeClone(@id)
      eventId: Common.makeClone(@constructor.EVENT_ID)
    }
    mod = {}
    # modifiables変数の追加
    if @constructor.actionProperties.modifiables?
      for varName, value of @constructor.actionProperties.modifiables
        mod[varName] = Common.makeClone(@[varName])
    $.extend(obj, mod)
    return obj

  # 最小限のデータを設定
  setMiniumObject: (obj) ->
    # ID変更のため一度instanceMapから削除
    delete window.instanceMap[@id]
    @id = Common.makeClone(obj.id)
    # modifiables変数の追加
    if @constructor.actionProperties.modifiables?
      for varName, value of @constructor.actionProperties.modifiables
        @[varName] = Common.makeClone(obj[varName])
    window.instanceMap[@id] = @