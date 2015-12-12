# 共通イベント基底クラス
class CommonEvent

  # インスタンスはページ毎持つ
  # 必要に応じてサブクラスで変更
  instance = {}

  constructor: ->
    return @constructor.getInstance()

  class @PrivateClass extends CommonEventBase
    @actionProperties = null

    constructor: ->
      super()
      # @property [Int] id ID
      @id = "c" + @constructor.EVENT_ID + Common.generateId()
      # @property [Int] eventId 共通イベントID
      @eventId =  @constructor.EVENT_ID

    getJQueryElement: ->
      return window.scrollInsideCover

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
