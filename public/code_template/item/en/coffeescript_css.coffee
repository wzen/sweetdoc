# Test
class ItemPreviewTemp extends CssItemBase
  @IDENTITY = "ItemPreviewTemp"

  # ↓ Don't Delete
  if window.loadedItemToken?
    @ITEM_ACCESS_TOKEN = window.loadedItemToken

  @actionProperties =
  {
    defaultMethod: 'defaultClick'
    designConfig: true
    designConfigDefaultValues: {
      values: {
        design_slider_font_size_value: 14
        design_font_color_value: 'ffffff'
        design_slider_padding_top_value: 10
        design_slider_padding_left_value: 20
        design_slider_gradient_deg_value: 0
        design_slider_gradient_deg_value_webkit_value: 'left top, left bottom'
        design_bg_color1_value: 'ffbdf5'
        design_bg_color2_value: 'ff82ec'
        design_bg_color2_position_value: 25
        design_bg_color3_value: 'fc46e1'
        design_bg_color3_position_value: 50
        design_bg_color4_value: 'fc46e1'
        design_bg_color4_position_value: 75
        design_bg_color5_value: 'fc46e1'
        design_border_color_value: 'ffffff'
        design_slider_border_radius_value: 30
        design_slider_border_width_value: 3
        design_slider_shadow_left_value: 0
        design_slider_shadow_top_value: 3
        design_slider_shadow_size_value: 11
        design_shadow_color_value: '000,000,000'
        design_slider_shadow_opacity_value: 0.5
        design_slider_shadowinset_left_value: 0
        design_slider_shadowinset_top_value: 0
        design_slider_shadowinset_size_value: 1
        design_shadowinset_color_value: '255,000,217'
        design_slider_shadowinset_opacity_value: 1
        design_slider_text_shadow1_left_value: 0
        design_slider_text_shadow1_top_value: -1
        design_slider_text_shadow1_size_value: 0
        design_text_shadow1_color_value: '000,000,000'
        design_slider_text_shadow1_opacity_value: 0.2
        design_slider_text_shadow2_left_value: 0
        design_slider_text_shadow2_top_value: 1
        design_slider_text_shadow2_size_value: 0
        design_text_shadow2_color_value: '255,255,255'
        design_slider_text_shadow2_opacity_value: 0.3
      }
      flags: {
        design_bg_color2_moz_flag: false
        design_bg_color2_webkit_flag: false
        design_bg_color3_moz_flag: false
        design_bg_color3_webkit_flag: false
        design_bg_color4_moz_flag: false
        design_bg_color4_webkit_flag: false
      }
    }
    modifiables: {
      backgroundColor: {
        name: "Background Color"
        default: 'ffffff'
        type: 'color'
        ja :{
          name: "背景色"
        }
      }
    }
    methods: {
      defaultClick: {
        actionType: 'click'
        isDrawByAnimation: true
        eventDuration: 0.5
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
          name: 'Changing color by scroll'
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

      changeColorClick: {
        actionType: 'click'
        eventDuration: 0.5
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

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  reDraw: (show = true)->
    super(show)


  # イベント前の表示状態にする
  updateEventBefore: ->
    super()
    @getJQueryElement().css('opacity', 0)
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration')
    else if methodName == 'changeColorClick' || methodName == 'changeColorScroll'
      @backgroundColor = 'ffffff'

  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    @getJQueryElement().css('opacity', 1)
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().css({'-webkit-animation-duration':'0', '-moz-animation-duration', '0'})

  # 共通クリックイベント ※アクションイベント
  defaultClick : (opt) ->
    # ボタン凹むアクション
    @getJQueryElement().find('.css_item:first').addClass('defaultClick_' + @id)
    @getJQueryElement().off('webkitAnimationEnd animationend')
    @getJQueryElement().on('webkitAnimationEnd animationend', (e) =>
      #console.log('css-anim end')
      @getJQueryElement().find('.css_item:first').removeClass('defaultClick_' + @id)
      if opt.complete?
        opt.complete()
    )

  # *アクションイベント
  changeColorScroll: (opt) ->
    @getJQueryElement().find('.css_item_base').css('background', "##{@backgroundColor}")
    if opt.complete?
      opt.complete()

  # *アクションイベント
  changeColorClick: (opt) ->
    @getJQueryElement().find('.css_item_base').css('background', "##{@backgroundColor}")
    if opt.complete?
      opt.complete()

  # CSSアニメーションの定義(必要な場合)
  cssAnimationKeyframe : ->
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

    return keyframe

  willChapter: ->
    super()
    if @getEventMethodName() == 'defaultClick'
      # ボタンを表示
      @getJQueryElement().css('opacity', 1)
    else if @getEventMethodName() == 'changeColorClick' || @getEventMethodName() == 'changeColorScroll'
      # ボタンを表示
      @getJQueryElement().css('opacity', 1)

Common.setClassToMap(false, ItemPreviewTemp.ITEM_ACCESS_TOKEN, ItemPreviewTemp)

# Don't Delete
if window.itemInitFuncList? && !window.itemInitFuncList[ItemPreviewTemp.ITEM_ACCESS_TOKEN]?
  console.log('ItemPreviewTemp loaded')
  window.itemInitFuncList[ItemPreviewTemp.ITEM_ACCESS_TOKEN] = (option = {}) ->
    if window.isWorkTable && ItemPreviewTemp.jsLoaded?
      ItemPreviewTemp.jsLoaded(option)
    if window.debug
      console.log('ItemPreviewTemp init finished')

