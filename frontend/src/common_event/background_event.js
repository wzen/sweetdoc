import Common from '../base/common';
import CommonEvent from './common_event';

// 背景イベント
export default class BackgroundEvent extends CommonEvent {
  static initClass() {
    this.instance = {};

    const Cls = (this.PrivateClass = class PrivateClass extends CommonEvent.PrivateClass {
      static initClass() {
        this.EVENT_ID = '1';
        this.CLASS_DIST_TOKEN = "PI_BackgroundEvent";

        this.actionProperties =
          {
            modifiables: {
              backgroundColor: {
                name: "Background Color",
                default: 'transparent',
                type: 'color',
                colorType: 'rgb',
                ja: {
                  name: "背景色"
                }
              }
            },
            methods: {
              changeBackgroundColor: {
                options: {
                  id: 'changeColorClick_Design',
                  name: 'Changing backgroundcolor',
                  ja: {
                    name: '背景色変更'
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
          };
      }

      constructor() {
        super();
        this.name = 'Background';
        this.backgroundColor = 'transparent';
      }

      // イベントの初期化
      // @param [Object] event 設定イベント
      initEvent(event) {
        return super.initEvent(event);
      }

      // 変更を戻して再表示
      refresh(show, callback = null) {
        if(show === null) {
          show = true;
        }
        window.scrollInside.css('backgroundColor', '');
        if(callback !== null) {
          return callback(this);
        }
      }

      // イベント前の表示状態にする
      updateEventBefore() {
        super.updateEventBefore();
        const methodName = this.getEventMethodName();
        if(methodName === 'changeBackgroundColor') {
          return window.scrollInside.css('backgroundColor', this.backgroundColor);
        }
      }

      // イベント後の表示状態にする
      updateEventAfter() {
        super.updateEventAfter();
        const methodName = this.getEventMethodName();
        if(methodName === 'changeBackgroundColor') {
          return window.scrollInside.css('backgroundColor', this.backgroundColor);
        }
      }

      // スクロールイベント
      changeBackgroundColor(opt) {
        return window.scrollInside.css('backgroundColor', this.backgroundColor);
      }
    });
    Cls.initClass();

    this.CLASS_DIST_TOKEN = this.PrivateClass.CLASS_DIST_TOKEN;
  }
}

BackgroundEvent.initClass();

Common.setClassToMap(BackgroundEvent.CLASS_DIST_TOKEN, BackgroundEvent);

