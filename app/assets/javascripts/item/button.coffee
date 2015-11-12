# ボタンアイテム
# @extend CssItemBase
class ButtonItem extends CssItemBase
  # @property [String] IDENTITY アイテム識別名
  @IDENTITY = "Button"

  # ↓必須
  if window.loadedItemId?
    # @property [String] ITEM_ID アイテム種別
    @ITEM_ID = window.loadedItemId

  @actionProperties =
    {
      defaultMethod: 'defaultClick'
      designConfig: 'design_tool'
      designConfigDefaultValues: {
        design_slider_font_size_value: 14
        design_font_color: 'ffffff'
        design_slider_padding_top_value: 10
        design_slider_padding_left_value: 20
        design_slider_gradient_deg_value: 0
        design_bg_color1: 'ffbdf5'
        design_bg_color2: 'ff82ec'
        design_bg_color2_position: 25
        design_bg_color3: 'fc46e1'
        design_bg_color3_position: 50
        design_bg_color4: 'fc46e1'
        design_bg_color4_position: 75
        design_bg_color5: 'fc46e1'
        design_slider_gradient_deg_value_webkit: 'left top, left bottom'
        design_slider_border_radius_value: 30
        design_slider_border_width_value: 3
        design_slider_shadow_top_value: 3
        design_slider_shadow_size_value: 11
        design_shadow_color: '000,000,000'
        design_slider_shadow_opacity_value: 0.5
        design_slider_shadowinset_top_value: 0
        design_slider_shadowinset_size_value: 1
        design_shadowinset_color: '255,000,217'
        design_slider_shadowinset_opacity_value: 1
        design_slider_text_shadow1_left_value: 0
        design_slider_text_shadow1_top_value: -1
        design_slider_text_shadow1_size_value: 0
        design_text_shadow1_color: '000,000,000'
        design_slider_text_shadow1_opacity_value: 0.2
        design_slider_text_shadow2_left_value: 0
        design_slider_text_shadow2_top_value: 1
        design_slider_text_shadow2_size_value: 0
        design_text_shadow2_color: '255,255,255'
        design_slider_text_shadow2_opacity_value: 0.3
      }
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
  console.log('button loaded')
  window.itemInitFuncList[ButtonItem.ITEM_ID] = (option = {}) ->
    if window.isWorkTable && ButtonItem.jsLoaded?
      ButtonItem.jsLoaded(option)
    #JS読み込み完了
    if window.debug
      console.log('button init finished')

