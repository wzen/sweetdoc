# 背景イベント
class BackgroundEvent extends CommonEvent
  class @PrivateClass extends CommonEvent.PrivateClass
    @EVENT_ID = '1'
    @CLASS_DIST_TOKEN = "PI_BackgroundEvent"

    @actionProperties =
    {
      defaultMethod: 'changeBackgroundColor'
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
          actionType: 'scroll'
          options: {
            id: 'changeColorClick_Design'
            name: 'Changing color by click'
            ja: {
              name: 'クリックで色変更'
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

    # イベントの初期化
    # @param [Object] event 設定イベント
    initEvent: (event) ->
      super(event)

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
  @actionProperties = @PrivateClass.actionProperties

  if EventConfig?
    EventConfig.addEventConfigContents(@PrivateClass.CLASS_DIST_TOKEN)

Common.setClassToMap(true, BackgroundEvent.EVENT_ID, BackgroundEvent)

