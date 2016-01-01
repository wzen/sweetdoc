# 共通イベント基底クラス
class CommonEvent

  # インスタンスはページ毎持つ
  # TODO: サブクラスでオブジェクト宣言
  # @abstract
  @instance = null

  constructor: ->
    return @constructor.getInstance()

  class @PrivateClass extends CommonEventBase
    # @property [String] ID_PREFIX IDプレフィックス
    @ID_PREFIX = "c"
    @actionProperties = null

    constructor: ->
      super()
      # @property [Int] id ID
      @id = @constructor.ID_PREFIX + @constructor.EVENT_ID + Common.generateId()
      # @property [Int] eventId 共通イベントID
      @eventId =  @constructor.EVENT_ID
      # @property [ItemType] CLASS_DIST_TOKEN アイテム種別
      @classDistToken = @constructor.CLASS_DIST_TOKEN

    getJQueryElement: ->
      return $('#common_event_click_overlay')

    clickTargetElement: ->
      return $('#common_event_click_overlay')

    willChapter: ->
      if @_event[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionType.CLICK
        # クリック用オーバーレイを追加
        z_index = Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT)
        if $('#common_event_click_overlay').length == 0
          $('body').append("<div id='common_event_click_overlay' style='z-index:#{z_index}'></div>")
      super()

    didChapter: ->
      if @_event[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionType.CLICK
        # クリック用オーバーレイを削除
        $('#common_event_click_overlay').remove()
      super()

  @getInstance: ->
    if !@instance[PageValue.getPageNum()]?
      @instance[PageValue.getPageNum()] = new @PrivateClass()
    return @instance[PageValue.getPageNum()]

  @deleteInstance: (objId) ->
    for k, v of @instance
      if v.id == objId
        delete @instance[k]
  @deleteAllInstance: ->
    for k, v of @instance
      delete @instance[k]

  # TODO: サブクラスで定義必須
  # @abstract
  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN

