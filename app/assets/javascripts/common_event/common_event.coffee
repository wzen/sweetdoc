# 共通イベント基底クラス
class CommonEvent extends CommonEventBase

  # インスタンスはページ毎持つ
  # 必要に応じてサブクラスで変更
  instance = {}

  constructor: ->
    super()
    return @constructor.getInstance()

  class @PrivateClass extends CommonEventBase
    @actionProperties = null

    constructor: ->
      super()
      # @property [Int] id ID
      @id = "c" + @constructor.EVENT_ID + Common.generateId()
      # @property [Int] eventId 共通イベントID
      @eventId =  @constructor.EVENT_ID
      # modifiables変数の初期化
      if @constructor.actionProperties.modifiables?
        for varName, value of @constructor.actionProperties.modifiables
          @[varName] = value.default

  @getInstance: ->
    if !instance[PageValue.getPageNum()]?
      instance[PageValue.getPageNum()] = new @PrivateClass()
    return instance[PageValue.getPageNum()]

  @deleteInstance: (objId) ->
    for k, v of instance
      if v.id == objId
        delete instance[k]
  @deleteAllInstance: ->
    for k, v of instance
      delete instance[k]

  @EVENT_ID = @PrivateClass.EVENT_ID
  @actionProperties = @PrivateClass.actionProperties
