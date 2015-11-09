# ボタンアイテム
# @extend CssItemBase
class ButtonItem extends CssItemBase
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "Button"

  # @property [String] CSSTEMPID CSSテンプレートID
  @CSSTEMPID = "button_css_temp"

  if window.loadedItemId?
    # @property [String] ITEM_ID アイテム種別
    @ITEM_ID = window.loadedItemId

  @actionProperties =
    {
      defaultMethod: 'defaultClick'
      designConfig: 'design_tool'
      methods: {
        defaultClick: {
          actionType: 'click'
          clickAnimationDuration: 0.5
          options: {
            id: 'defaultClick'
            name: 'Default click action'
            desc: "Click push action"
            ja: {
              name: '通常クリック'
              desc: 'デフォルトのボタンクリック'
            }
          }
        }

        changeColorScroll: {
          actionType: 'scroll'
          scrollEnabledDirection: {
            top: true
            bottom: true
            left: false
            right: false
          }
          scrollForwardDirection: {
            top: false
            bottom: true
            left: false
            right: false
          }
          options: {
            id: 'changeColorScroll_Design'
            name: 'Changing color by click'
          }
        }
      }
    }

  # イベント前の表示状態にする
  updateEventBefore: ->
    super()
    @getJQueryElement().css('opacity', 0)
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration')

  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    @getJQueryElement().css('opacity', 1)
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().css({'-webkit-animation-duration':'0', '-moz-animation-duration', '0'})

  # 共通クリックイベント ※アクションイベント
  defaultClick : (e, complete) =>
    # ボタン凹むアクション
    @getJQueryElement().find('.css_item:first').addClass('defaultClick_' + @id)
    @getJQueryElement().off('webkitAnimationEnd animationend')
    @getJQueryElement().on('webkitAnimationEnd animationend', (e) =>
      #console.log('css-anim end')
      @getJQueryElement().find('.css_item:first').removeClass('defaultClick_' + @id)
      @isFinishedEvent = true
      if complete?
        complete()
    )

  # CSS
  cssAnimationElement : ->
    methodName = @getEventMethodName()
    funcName = "#{methodName}_#{@id}"
    keyFrameName = "#{@id}_frame"
    emt = @getJQueryElement().find('.css_item:first')
    top = emt.css('top')
    left = emt.css('left')
    width = emt.css('width')
    height = emt.css('height')

    # キーフレーム
    keyframe = """
    #{keyFrameName} {
      0% {
        top: #{ parseInt(top)}px;
        left: #{ parseInt(left)}px;
        width: #{parseInt(width)}px;
        height: #{parseInt(height)}px;
      }
      40% {
        top: #{ parseInt(top) + 10 }px;
        left: #{ parseInt(left) + 10 }px;
        width: #{parseInt(width) - 20}px;
        height: #{parseInt(height) - 20}px;
      }
      80% {
        top: #{ parseInt(top)}px;
        left: #{ parseInt(left)}px;
        width: #{parseInt(width)}px;
        height: #{parseInt(height)}px;
      }
      90% {
        top: #{ parseInt(top) + 5 }px;
        left: #{ parseInt(left) + 5 }px;
        width: #{parseInt(width) - 10}px;
        height: #{parseInt(height) - 10}px;
      }
      100% {
        top: #{ parseInt(top)}px;
        left: #{ parseInt(left)}px;
        width: #{parseInt(width)}px;
        height: #{parseInt(height)}px;
      }
    }
    """
    webkitKeyframe = "@-webkit-keyframes #{keyframe}"
    mozKeyframe = "@-moz-keyframes #{keyframe}"

    # CSSに設定
    css = """
    .#{funcName}
    {
    -webkit-animation-name: #{keyFrameName};
    -moz-animation-name: #{keyFrameName};
    -webkit-animation-duration: #{@constructor.actionProperties.methods[@getEventMethodName()].clickAnimationDuration}s;
    -moz-animation-duration: #{@constructor.actionProperties.methods[@getEventMethodName()].clickAnimationDuration}s;
    }
    """
    return "#{webkitKeyframe} #{mozKeyframe} #{css}"

  willChapter: ->
    super()
    if @getEventMethodName() == 'defaultClick'
      # ボタンを表示
      @getJQueryElement().css('opacity', 1)



Common.setClassToMap(false, ButtonItem.ITEM_ID, ButtonItem)

# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList[ButtonItem.ITEM_ID]?
  window.itemInitFuncList[ButtonItem.ITEM_ID] = (option = {}) ->
    if window.isWorkTable && ButtonItem.jsLoaded?
      ButtonItem.jsLoaded(option)
    #JS読み込み完了
    if window.debug
      console.log('button loaded')

