import React from 'react';
import CssItemBase from '../CssItemBase';

// ボタンアイテム
// @extend CssItemBase
export default class PreloadItemButton extends CssItemBase {

  static get PROPERTIES() {
    return   {
      defaultEvent: {
        method: 'defaultClick',
        actionType: 'click',
        eventDuration: 0.5
      },
      designConfig: true,
      designConfigDefaultValues: {
        values: {
          designSliderFontSizeValue: 14,
          designFontColorValue: 'ffffff',
          designSliderPaddingTopValue: 10,
          designSliderPaddingLeftValue: 20,
          designSliderGradientDegValue: 0,
          designSliderGradientDegValueWebkitValue: 'left top, left bottom',
          designBgColor1Value: 'ffbdf5',
          designBgColor2Value: 'ff82ec',
          designBgColor2PositionValue: 25,
          designBgColor3Value: 'fc46e1',
          designBgColor3PositionValue: 50,
          designBgColor4Value: 'fc46e1',
          designBgColor4PositionValue: 75,
          designBgColor5Value: 'fc46e1',
          designBorderColorValue: 'ffffff',
          designSliderBorderRadiusValue: 30,
          designSliderBorderWidthValue: 3,
          designSliderShadowLeftValue: 0,
          designSliderShadowTopValue: 3,
          designSliderShadowSizeValue: 11,
          designShadowColorValue: '000,000,000',
          designSliderShadowOpacityValue: 0.5,
          designSliderShadowinsetLeftValue: 0,
          designSliderShadowinsetTopValue: 0,
          designSliderShadowinsetSizeValue: 1,
          designShadowinsetColorValue: '255,000,217',
          designSliderShadowinsetOpacityValue: 1,
          designSliderTextShadow1LeftValue: 0,
          designSliderTextShadow1TopValue: -1,
          designSliderTextShadow1SizeValue: 0,
          designTextShadow1ColorValue: '000,000,000',
          designSliderTextShadow1OpacityValue: 0.2,
          designSliderTextShadow2LeftValue: 0,
          designSliderTextShadow2TopValue: 1,
          designSliderTextShadow2SizeValue: 0,
          designTextShadow2ColorValue: '255,255,255',
          designSliderTextShadow2OpacityValue: 0.3
        },
        flags: {
          designBgColor2MozFlag: false,
          designBgColor2WebkitFlag: false,
          designBgColor3MozFlag: false,
          designBgColor3WebkitFlag: false,
          designBgColor4MozFlag: false,
          designBgColor4WebkitFlag: false
        }
      },
      modifiables: {
        backgroundColor: {
          name: "Background Color",
          default: 'ffffff',
          type: 'color',
          colorType: 'hex',
          ja: {
            name: "背景色"
          }
        },
        text: {
          name: "Text",
          type: 'string',
          default: 'Button',
          ja: {
            name: "文字"
          }
        },
        textColor: {
          name: 'TextColor',
          default: {r: 0, g: 0, b: 0},
          type: 'color',
          colorType: 'rgb',
          ja: {
            name: '文字色'
          }
        },
        fontFamily: {
          name: "Select Font",
          type: 'select',
          temp: 'fontFamily',
          default: 'Times New Roman',
          ja: {
            name: 'フォント選択'
          }
        },
        fontSize: {
          type: 'number',
          name: "FontSize",
          default: 14,
          min: 1,
          max: 100,
          ja: {
            name: 'フォントサイズ'
          }
        }
      },
      methods: {
        defaultClick: {
          finishWithHand: true,
          options: {
            id: 'defaultClick',
            name: 'Default click action',
            desc: "Click push action",
            ja: {
              name: '通常クリック',
              desc: 'デフォルトのボタンクリック'
            }
          }
        },

        changeColorScroll: {
          options: {
            id: 'changeColorScroll_Design',
            name: 'Changing color by scroll'
          },
          modifiables: {
            backgroundColor: {
              name: "Background Color",
              type: 'color',
              varAutoChange: true,
              ja: {
                name: "背景色"
              }
            }
          }
        },
        changeColorClick: {
          options: {
            id: 'changeColorClick_Design',
            name: 'Changing color by click',
            ja: {
              name: 'クリックで色変更'
            }
          },
          modifiables: {
            backgroundColor: {
              name: "Background Color",
              type: 'color',
              varAutoChange: true,
              ja: {
                name: "背景色"
              }
            }
          }
        }
      }
    }
  }

  // HTML要素
  ItemRender() {
    return (
      <div className='content_table'>
        <div className='content_table_cell'>
          {this.text}
        </div>
      </div>
    )
  }

  /*
    // CSSスタイル
    cssStyle() {
      return `\
  #${this.id} .content_table {
    width: 100%;
    height: 100%;
    display: table;
  }
  #${this.id} .content_table_cell {
    display: table-cell;
    vertical-align: middle;
    text-align: center;
    font-family: ${this.fontFamily};
    font-size: ${this.fontSize}px;
    color: rgb(${this.textColor.r}, ${this.textColor.g}, ${this.textColor.b});
  }\
  `;
    }
    */

  // イベント前の表示状態にする
  updateEventBefore() {
    super.updateEventBefore();
    this.hideItem();
    const methodName = this.getEventMethodName();
    if (methodName === 'defaultClick') {
      return this.getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration');
    } else if ((methodName === 'changeColorClick') || (methodName === 'changeColorScroll')) {
      return this.backgroundColor = 'ffffff';
    }
  }

  // イベント後の表示状態にする
  updateEventAfter() {
    super.updateEventAfter();
    this.showItem();
    const methodName = this.getEventMethodName();
    if (methodName === 'defaultClick') {
      return this.getJQueryElement().css({
        '-webkit-animation-duration': '0',
        '-moz-animation-duration': '-moz-animation-duration',
        '0': '0'
      });
    }
  }

  // 共通クリックイベント ※アクションイベント
  defaultClick(opt) {
    this.disableHandleResponse();
    // ボタン凹むアクション
    this.getJQueryElement().find('.item_contents:first').addClass(`defaultClick_${this.id}`);
    return this.getJQueryElement().off('webkitAnimationEnd animationend').on('webkitAnimationEnd animationend', e => {
      this.getJQueryElement().find('.item_contents:first').removeClass(`defaultClick_${this.id}`);
      // イベント終了
      return this.finishEvent();
    });
  }

  // *アクションイベント
  changeColorScroll(opt) {
    return this.getJQueryElement().find('.css_item_base').css('background', `#${this.backgroundColor}`);
  }

  changeColorClick(opt) {
    return this.getJQueryElement().find('.css_item_base').css('background', `#${this.backgroundColor}`);
  }

  // CSSアニメーションの定義(必要な場合)
  cssAnimationKeyframe() {
    const methodName = this.getEventMethodName();
    const keyFrameName = `${this.id}_frame`;
    const emt = this.getJQueryElement().find('.item_contents:first');
    const top = emt.css('top');
    const left = emt.css('left');
    const width = emt.css('width');
    const height = emt.css('height');

    /*
    // キーフレーム
    const keyframe = `\
${keyFrameName} {
  0% {
    top: ${ parseInt(top)}px;
    left: ${ parseInt(left)}px;
    width: ${parseInt(width)}px;
    height: ${parseInt(height)}px;
  }
  40% {
    top: ${ parseInt(top) + 10 }px;
    left: ${ parseInt(left) + 10 }px;
    width: ${parseInt(width) - 20}px;
    height: ${parseInt(height) - 20}px;
  }
  80% {
    top: ${ parseInt(top)}px;
    left: ${ parseInt(left)}px;
    width: ${parseInt(width)}px;
    height: ${parseInt(height)}px;
  }
  90% {
    top: ${ parseInt(top) + 5 }px;
    left: ${ parseInt(left) + 5 }px;
    width: ${parseInt(width) - 10}px;
    height: ${parseInt(height) - 10}px;
  }
  100% {
    top: ${ parseInt(top)}px;
    left: ${ parseInt(left)}px;
    width: ${parseInt(width)}px;
    height: ${parseInt(height)}px;
  }
}\
`;
*/

    return keyframe;
  }
}