# 共通イベント Singleton
class CommonEvent
  instance = null
  @EVENT_ID = ''

  constructor: ->
    return @constructor.getInstance()

  class @PrivateClass extends CommonEventBase
    constructor: ->
      super()

  @getInstance: ->
    if !instance?
      instance = new @PrivateClass()
      instance.id = "c" + @EVENT_ID +  generateId()
      if !window.createdObject?
        window.createdObject = {}
      window.createdObject[instance.id] = instance
    return instance
