# Test
class ItemPreviewTemp extends CssItemBase
  @NAME_PREFIX = "ItemPreviewTemp"

  # ↓ Don't Delete
  if window.loadedClassDistToken?
    @CLASS_DIST_TOKEN = window.loadedClassDistToken

  @actionProperties =
  {
    defaultEvent: {
      method: 'defaultClick'
      actionType: 'click'
      eventDuration: 0.5
    }
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
        colorType: 'hex'
        ja :{
          name: "背景色"
        }
      }
      text: {
        name: "Text"
        type: 'string'
        default: 'Button'
        ja: {
          name: "文字"
        }
      }
      textColor: {
        name: 'TextColor'
        default: {r:0, g:0, b:0}
        type: 'color'
        colorType: 'rgb'
        ja: {
          name: '文字色'
        }
      }
      fontFamily: {
        name: "Select Font"
        type: 'select'
        temp: 'fontFamily'
        default: 'Times New Roman'
        ja: {
          name: 'フォント選択'
        }
      }
      fontSize: {
        type: 'number'
        name: "FontSize"
        default: 14
        min: 1
        max: 100
        ja: {
          name: 'フォントサイズ'
        }
      }
    }
    methods: {
      defaultClick: {
        finishWithHand: true
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

  # HTML要素
  cssItemHtml: ->
    return """
      <div class='content_table'><div class='content_table_cell'>#{@text}</div></div>
    """

  # CSSスタイル
  cssStyle: ->
    return """
      ##{@id} .content_table {
        width: 100%;
        height: 100%;
        display: table;
      }
      ##{@id} .content_table_cell {
        display: table-cell;
        vertical-align: middle;
        text-align: center;
        font-family: #{@fontFamily};
        font-size: #{@fontSize}px;
        color: rgb(#{@textColor.r}, #{@textColor.g}, #{@textColor.b});
      }
    """

  # イベント前の表示状態にする
  updateEventBefore: ->
    super()
    @hideItem()
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration')
    else if methodName == 'changeColorClick' || methodName == 'changeColorScroll'
      @backgroundColor = 'ffffff'

  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    @showItem()
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().css({'-webkit-animation-duration':'0', '-moz-animation-duration', '0'})

  # 共通クリックイベント ※アクションイベント
  defaultClick : (opt) ->
    @disableHandleResponse()
    # ボタン凹むアクション
    @getJQueryElement().find('.item_contents:first').addClass('defaultClick_' + @id)
    @getJQueryElement().off('webkitAnimationEnd animationend').on('webkitAnimationEnd animationend', (e) =>
      @getJQueryElement().find('.item_contents:first').removeClass('defaultClick_' + @id)
      # イベント終了
      @finishEvent()
    )

  # *アクションイベント
  changeColorScroll: (opt) ->
    @getJQueryElement().find('.css_item_base').css('background', "##{@backgroundColor}")

  changeColorClick: (opt) ->
    @getJQueryElement().find('.css_item_base').css('background', "##{@backgroundColor}")

  # CSSアニメーションの定義(必要な場合)
  cssAnimationKeyframe : ->
    methodName = @getEventMethodName()
    keyFrameName = "#{@id}_frame"
    emt = @getJQueryElement().find('.item_contents:first')
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

Common.setClassToMap(ItemPreviewTemp.CLASS_DIST_TOKEN, ItemPreviewTemp)

# Don't Delete
if window.itemInitFuncList? && !window.itemInitFuncList[ItemPreviewTemp.CLASS_DIST_TOKEN]?
  window.itemInitFuncList[ItemPreviewTemp.CLASS_DIST_TOKEN] = (option = {}) ->
    if window.isWorkTable && ItemPreviewTemp.jsLoaded?
      ItemPreviewTemp.jsLoaded(option)
