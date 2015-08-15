# 共通イベント
class CommonEvent extends CommonEventBase
  @EVENT_ID = ''

  constructor: ->
    super()
    # @property [Int] id ID
    @id = "c" + @constructor.EVENT_ID + Common.generateId()
    # アイテムリストに保存
    createdObject[@id] = @
