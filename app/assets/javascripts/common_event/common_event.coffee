# 共通イベント
class CommonEvent extends CommonEventBase
  @EVENT_ID = ''

  constructor: ->
    super()
    # @property [Int] id ID
    @id = "c" + @constructor.EVENT_ID + Common.generateId()

  # 保存用の最小限のデータを取得
  getMinimumObject: ->
    obj = {
      id: Common.makeClone(@id)
      eventId: Common.makeClone(@constructor.EVENT_ID)
    }
    return obj