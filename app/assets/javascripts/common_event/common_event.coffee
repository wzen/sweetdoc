# 共通イベント
class CommonEvent extends Extend
  @include EventListener
  @include CommonEventListener

  @EVENT_ID = ''
  @ID = ''

  constructor: ->
    super()
    # @property [Int] id ID
    @id = "c" + @constructor.EVENT_ID +  generateId()
