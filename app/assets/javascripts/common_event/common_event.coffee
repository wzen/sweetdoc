# 共通イベント Singleton
class CommonEvent
  instance = null
  @EVENT_ID = ''

  constructor: ->
    return @constructor.getInstance()

  class @PrivateClass extends CommonEventBase
    constructor: ->
      super()
      # @property [Int] id ID
      @id = "c" + @constructor.EVENT_ID +  generateId()
      if !window.createdObject?
        window.createdObject = {}
      window.createdObject[@id] = @

  @getInstance: ->
    if !instance?
      instance = new @PrivateClass()
    return instance
