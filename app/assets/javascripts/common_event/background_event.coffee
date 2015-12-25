# 背景イベント
class BackgroundEvent extends CommonEvent
  @instance = {}

  class @PrivateClass extends CommonEvent.PrivateClass
    @EVENT_ID = '1'
    @CLASS_DIST_TOKEN = "PI_BackgroundEvent"

    @actionProperties =
    {
      modifiables: {
        backgroundColor: {
          name: "Background Color"
          default: 'transparent'
          type: 'color'
          colorType: 'rgb'
          ja :{
            name: "背景色"
          }
        }
      }
      methods: {
        changeBackgroundColor: {
          options: {
            id: 'changeColorClick_Design'
            name: 'Changing backgroundcolor'
            ja: {
              name: '背景色変更'
            }
          }
          modifiables: {
            backgroundColor: {
              name: "Background Color"
              type: 'color'
              varAutoChange: true
              ja :{
                name: "背景色"
              }
            }
          }
        }
      }
    }

    constructor: ->
      super()
      @name = 'Background'

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event) ->
      super(event)

    # 変更を戻して再表示
    refresh: (show = true, callback = null) ->
      window.scrollInside.css('backgroundColor', '')
      if callback?
        callback()

    # イベント前の表示状態にする
    updateEventBefore: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeBackgroundColor'
        window.scrollInside.css('backgroundColor', @backgroundColor)

    # イベント後の表示状態にする
    updateEventAfter: ->
      super()
      methodName = @getEventMethodName()
      if methodName == 'changeBackgroundColor'
        window.scrollInside.css('backgroundColor', @backgroundColor)

    # スクロールイベント
    changeBackgroundColor: (opt) ->
      window.scrollInside.css('backgroundColor', @backgroundColor)

  @EVENT_ID = @PrivateClass.EVENT_ID
  @CLASS_DIST_TOKEN = @PrivateClass.CLASS_DIST_TOKEN
  @actionProperties = @PrivateClass.actionProperties

Common.setClassToMap(BackgroundEvent.CLASS_DIST_TOKEN, BackgroundEvent)

