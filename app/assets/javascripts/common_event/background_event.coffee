# 背景イベント
class BackgroundEvent extends CommonEvent
  @EVENT_ID = '1'

  @actionProperties =
    {
      defaultMethod: 'changeBackgroundColor'
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
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    @targetBackground = section
#
#  # イベント前の表示状態にする
#  updateEventBefore: ->
#    super()
#    methodName = @getEventMethodName()
#    if methodName == 'changeBackgroundColor'
#      bColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.BASE_COLOR]
#      @targetBackground.css('backgroundColor', bColor)
#
#  # イベント後の表示状態にする
#  updateEventAfter: ->
#    super()
#    methodName = @getEventMethodName()
#    if methodName == 'changeBackgroundColor'
#      cColor = @event[EventPageValueBase.PageValueKey.VALUE][EPVBackgroundColor.CHANGE_COLOR]
#      @targetBackground.css('backgroundColor', cColor)

  # スクロールイベント
  changeBackgroundColor: (opt) ->
    @targetBackground.css('backgroundColor', "##{backgroundColor}")

Common.setClassToMap(true, BackgroundEvent.EVENT_ID, BackgroundEvent)
