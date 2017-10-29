import Common from '../base/common';
import Navbar from '../navbar/navbar';
import PageValue from '../base/page_value';
import WorktableCommon from '../worktable/common/worktable_common';
import CanvasItemBase from '../item/canvas_item_base';
import EventBase from '../base/event_base/event_base';
import EventPageValueBase from '../event_page_value/base/base';
import EventDragPointingDraw from '../worktable/event/pointing/event_drag_pointing_draw';

let constant = undefined;
let _startOpenAnimation = undefined;
let _startCloseAnimation = undefined;
let _openCbk = undefined;
let _oCbk = undefined;
let _closeCbk = undefined;
let _setTextStyle = undefined;
let _setNoTextStyle = undefined;
let _drawTextAndBalloonToCanvas = undefined;
let _getRandomInt = undefined;
let _balloonStyle = undefined;
let _drawBalloon = undefined;
let _adjustFreeHandPath = undefined;
let _freeHandBalloonDraw = undefined;
let _calcHorizontalColumnWidth = undefined;
let _calcHorizontalColumnWidthMax = undefined;
let _calcVerticalColumnHeight = undefined;
let _calcHorizontalColumnHeightMax = undefined;
let _calcHorizontalColumnHeightSum = undefined;
let _calcVerticalColumnHeightMax = undefined;
let _setTextAlpha = undefined;
let _writeLength = undefined;
let _drawText = undefined;
let _calcWordMeasure = undefined;
let _measureImage = undefined;
let _isWordSmallJapanease = undefined;
let _isWordNeedRotate = undefined;
let _calcFontSizeAbout = undefined;
let _showInputModal = undefined;
let _settingTextDbclickEvent = undefined;
let _prepareEditModal = undefined;
let _calcRowWordLength = undefined;
let _defaultWorkWidth = undefined;
export default class PreloadItemText extends CanvasItemBase {
  static initClass() {
    this.NAME_PREFIX = "text";
    this.CLASS_DIST_TOKEN = 'PreloadItemText';
    this.NO_TEXT = 'Blank text';
    this.WRITE_TEXT_BLUR_LENGTH = 5;
    constant = gon.const;
    let Cls = (this.BalloonType = class BalloonType {
      static initClass() {
        this.FREE = constant.PreloadItemText.BalloonType.FREE;
        this.ARC = constant.PreloadItemText.BalloonType.ARC;
        this.RECT = constant.PreloadItemText.BalloonType.RECT;
        this.BROKEN_ARC = constant.PreloadItemText.BalloonType.BROKEN_ARC;
        this.BROKEN_RECT = constant.PreloadItemText.BalloonType.BROKEN_RECT;
        this.FLASH = constant.PreloadItemText.BalloonType.FLASH;
        this.CLOUD = constant.PreloadItemText.BalloonType.CLOUD;
      }
    });
    Cls.initClass();
    Cls = (this.WriteDirectionType = class WriteDirectionType {
      static initClass() {
        this.HORIZONTAL = constant.PreloadItemText.WriteDirectionType.HORIZONTAL;
        this.VERTICAL = constant.PreloadItemText.WriteDirectionType.VERTICAL;
      }
    });
    Cls.initClass();
    Cls = (this.WordAlign = class WordAlign {
      static initClass() {
        this.LEFT = constant.PreloadItemText.WordAlign.LEFT;
        this.CENTER = constant.PreloadItemText.WordAlign.CENTER;
        this.RIGHT = constant.PreloadItemText.WordAlign.RIGHT;
      }
    });
    Cls.initClass();
    Cls = (this.ShowAnimationType = class ShowAnimationType {
      static initClass() {
        this.POPUP = constant.PreloadItemText.ShowAnimationType.POPUP;
        this.FADE = constant.PreloadItemText.ShowAnimationType.FADE;
      }
    });
    Cls.initClass();

    this.actionProperties =
      {
        modifiables: {
          textColor: {
            name: 'TextColor',
            default: {r: 0, g: 0, b: 0},
            colorType: 'rgb',
            type: 'color',
            ja: {
              name: '文字色'
            }
          },
          drawHorizontal: {
            name: 'Horizontal / Vertical',
            type: 'select',
            options: [
              {
                name: 'Horizontal',
                value: this.WriteDirectionType.HORIZONTAL,
                ja: {
                  name: '横書き'
                }
              },
              {
                name: 'Vertical',
                value: this.WriteDirectionType.VERTICAL,
                ja: {
                  name: '縦書き'
                }
              }
            ],
            ja: {
              name: '横書き / 縦書き'
            }
          },
          showBalloon: {
            name: 'Show Balloon',
            default: false,
            type: 'boolean',
            openChildrenValue: {one: true},
            ja: {
              name: '吹き出し表示'
            },
            children: {
              one: {
                balloonColor: {
                  name: 'BalloonColor',
                  default: {r: 255, g: 255, b: 255},
                  type: 'color',
                  colorType: 'rgb',
                  ja: {
                    name: '吹き出しの色'
                  }
                },
                balloonBorderColor: {
                  name: 'BalloonBorderColor',
                  default: {r: 0, g: 0, b: 0},
                  type: 'color',
                  colorType: 'rgb',
                  ja: {
                    name: '吹き出し枠の色'
                  }
                },
                balloonBorderWidth: {
                  name: 'BalloonBorderWidth',
                  default: 1,
                  type: 'number',
                  min: 1,
                  max: 30,
                  ja: {
                    name: '吹き出し枠の幅'
                  }
                },
                balloonType: {
                  name: 'BalloonType',
                  type: 'select',
                  options: [
                    {name: 'Arc', value: this.BalloonType.ARC},
                    {name: 'Broken Arc', value: this.BalloonType.BROKEN_ARC},
                    {name: 'Rect', value: this.BalloonType.RECT},
                    {name: 'Broken Rect', value: this.BalloonType.BROKEN_RECT},
                    {name: 'Flash', value: this.BalloonType.FLASH},
                    {name: 'Cloud', value: this.BalloonType.CLOUD},
                    {name: 'FreeHand', value: this.BalloonType.FREE}
                  ],
                  ja: {
                    name: '吹き出しのタイプ'
                  },
                  openChildrenValue: {
                    one: this.BalloonType.RECT
                  },
                  children: {
                    one: {
                      balloonRadius: {
                        name: 'BalloonRadius',
                        default: 30,
                        type: 'number',
                        min: 1,
                        max: 100,
                        ja: {
                          name: '吹き出しの角丸'
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          fontFamily: {
            name: "Select Font",
            type: 'select',
            temp: 'fontFamily',
            ja: {
              name: 'フォント選択'
            }
          },
          isFixedFontSize: {
            name: "Font Size Fixed",
            type: 'boolean',
            default: false,
            openChildrenValue: {one: true},
            ja: {
              name: 'フォントサイズ指定'
            },
            children: {
              one: {
                fixedFontSize: {
                  type: 'number',
                  name: "Font Size",
                  min: 1,
                  max: 100,
                  default: 14
                }
              }
            }
          },
          wordAlign: {
            name: "Word Align",
            type: 'select',
            options: [
              {name: 'left', value: this.WordAlign.LEFT},
              {name: 'center', value: this.WordAlign.CENTER},
              {name: 'right', value: this.WordAlign.RIGHT}
            ],
            ja: {
              name: '文字寄せ'
            }
          }
        },
        methods: {
          changeText: {
            finishWithHand: true,
            modifiables: {
              inputText: {
                name: "Text",
                type: 'string',
                ja: {
                  name: "文字"
                }
              },
              showWithAnimation: {
                name: 'Show with animation',
                default: false,
                type: 'boolean',
                openChildrenValue: {one: true},
                ja: {
                  name: 'アニメーション表示'
                },
                children: {
                  one: {
                    showAnimationType: {
                      name: 'AnimationType',
                      type: 'select',
                      default: this.ShowAnimationType.POPUP,
                      options: [
                        {name: 'Popup', value: this.ShowAnimationType.POPUP},
                        {name: 'Fade', value: this.ShowAnimationType.FADE}
                      ]
                    }
                  }
                }
              }
            },
            options: {
              id: 'changeText',
              name: 'changeText',
              desc: "changeText",
              ja: {
                name: 'テキスト',
                desc: 'テキスト変更'
              }
            }
          },
          writeText: {
            finishWithHand: true,
            modifiables: {
              showWithAnimation: {
                name: 'Show with animation',
                default: false,
                type: 'boolean',
                openChildrenValue: {one: true},
                ja: {
                  name: 'アニメーション表示'
                },
                children: {
                  one: {
                    showAnimationType: {
                      name: 'AnimationType',
                      type: 'select',
                      default: this.ShowAnimationType.POPUP,
                      options: [
                        {name: 'Popup', value: this.ShowAnimationType.POPUP},
                        {name: 'Fade', value: this.ShowAnimationType.FADE}
                      ]
                    }
                  }
                }
              }
            },
            options: {
              id: 'writeText',
              name: 'writeText',
              desc: "writeText",
              ja: {
                name: 'テキスト',
                desc: 'テキスト描画'
              }
            }
          }
        }
      };

    this.getCircumPos =
      {
        x(d, r, cx) {
          return (Math.cos((Math.PI / 180) * d) * r) + cx;
        },
        y(d, r, cy) {
          return (Math.sin((Math.PI / 180) * d) * r) + cy;
        }
      };
    _startOpenAnimation = function(callback = null) {
      let progressPercent, step1, timemax;
      if((this._canvas === null)) {
        this._canvas = document.getElementById(this.canvasElementId());
        this._context = this._canvas.getContext('2d');
        this._context.save();
      }

      const emt = this.getJQueryElement();
      let x = null;
      let y = null;
      let width = null;
      let height = null;
      if(this.showAnimationType === this.constructor.ShowAnimationType.POPUP) {
        timemax = 8;
        step1 = 0.6;
        const step2 = 0.8;
        const step3 = 1;
        if((this._time / timemax) <= step1) {
          progressPercent = this._time / (timemax * step1);
          x = (this.itemSize.w * 0.5) + ((((this.itemSize.w - (this.itemSize.w * 0.9)) * 0.5) - (this.itemSize.w * 0.5)) * progressPercent);
          y = (this.itemSize.h * 0.5) + ((((this.itemSize.h - (this.itemSize.h * 0.9)) * 0.5) - (this.itemSize.h * 0.5)) * progressPercent);
          width = (this.itemSize.w * 0.9) * progressPercent;
          height = (this.itemSize.h * 0.9) * progressPercent;
          this._step1 = {x, y, w: width, h: height};
          this._time1 = this._time;
        } else if((this._time / timemax) <= step2) {
          progressPercent = (this._time - this._time1) / (timemax * (step2 - step1));
          x = this._step1.x + ((((this.itemSize.w - (this.itemSize.w * 0.6)) * 0.5) - this._step1.x) * progressPercent);
          y = this._step1.y + ((((this.itemSize.h - (this.itemSize.h * 0.6)) * 0.5) - this._step1.y) * progressPercent);
          width = this._step1.w + (((this.itemSize.w * 0.6) - this._step1.w) * progressPercent);
          height = this._step1.h + (((this.itemSize.h * 0.6) - this._step1.h) * progressPercent);
          this._step2 = {x, y, w: width, h: height};
          this._time2 = this._time;
        } else if((this._time / timemax) <= step3) {
          progressPercent = (this._time - this._time2) / (timemax * (step3 - step2));
          if(progressPercent > 1) {
            progressPercent = 1;
          }
          x = this._step2.x - (this._step2.x * progressPercent);
          y = this._step2.y - (this._step2.y * progressPercent);
          width = this._step2.w + ((this.itemSize.w - this._step2.w) * progressPercent);
          height = this._step2.h + ((this.itemSize.h - this._step2.h) * progressPercent);
        }
      } else if(this.showAnimationType === this.constructor.ShowAnimationType.FADE) {
        timemax = 30;
        step1 = 1;
        x = 0;
        y = 0;
        ({width} = this._canvas);
        ({height} = this._canvas);
        if((this._time / timemax) <= step1) {
          progressPercent = this._time / (timemax * step1);
          this._fixedBalloonAlpha = progressPercent;
        }
      }

      this._context.clearRect(0, 0, this._canvas.width, this._canvas.height);
      _drawBalloon.call(this, this._context, x, y, width, height, this._canvas.width, this._canvas.height);
      this._time += this._pertime;
      if(this._time <= timemax) {
        return requestAnimationFrame(() => {
          return _startOpenAnimation.call(this, callback);
        });
      } else {
        this._context.restore();
        if(callback !== null) {
          callback();
        }
        this.enableHandleResponse();
        return this._runningBallonAnimation = false;
      }
    };
    _startCloseAnimation = function(callback = null) {
      let progressPercent, step1, timemax;
      const emt = this.getJQueryElement();
      let x = null;
      let y = null;
      let width = null;
      let height = null;
      if(this.showAnimationType === this.constructor.ShowAnimationType.POPUP) {
        timemax = 8;
        step1 = 0.2;
        const step2 = 0.5;
        const step3 = 1;
        if((this._time / timemax) <= step1) {
          progressPercent = this._time / (timemax * step1);
          x = (this.itemSize.w - (this.itemSize.w * 0.5)) * 0.5 * progressPercent;
          y = (this.itemSize.h - (this.itemSize.h * 0.5)) * 0.5 * progressPercent;
          width = this.itemSize.w + (((this.itemSize.w * 0.5) - this.itemSize.w) * progressPercent);
          height = this.itemSize.h + (((this.itemSize.h * 0.5) - this.itemSize.h) * progressPercent);
          this._step1 = {x, y, w: width, h: height};
          this._time1 = this._time;
        } else if((this._time / timemax) <= step2) {
          progressPercent = (this._time - this._time1) / (timemax * (step2 - step1));
          x = this._step1.x + ((((this.itemSize.w - (this.itemSize.w * 0.9)) * 0.5) - this._step1.x) * progressPercent);
          y = this._step1.y + ((((this.itemSize.h - (this.itemSize.h * 0.9)) * 0.5) - this._step1.y) * progressPercent);
          width = this._step1.w + (((this.itemSize.w * 0.9) - this._step1.w) * progressPercent);
          height = this._step1.h + (((this.itemSize.h * 0.9) - this._step1.h) * progressPercent);
          this._step2 = {x, y, w: width, h: height};
          this._time2 = this._time;
        } else if((this._time / timemax) <= step3) {
          progressPercent = (this._time - this._time2) / (timemax * (step3 - step2));
          if(progressPercent > 1) {
            progressPercent = 1;
          }
          x = this._step2.x + (((this.itemSize.w * 0.5) - this._step2.x) * progressPercent);
          y = this._step2.y + (((this.itemSize.h * 0.5) - this._step2.y) * progressPercent);
          width = this._step2.w - (this._step2.w * progressPercent);
          height = this._step2.h - (this._step2.h * progressPercent);
        }
      } else if(this.showAnimationType === this.constructor.ShowAnimationType.FADE) {
        timemax = 30;
        step1 = 1;
        x = 0;
        y = 0;
        ({width} = this._canvas);
        ({height} = this._canvas);
        if((this._time / timemax) <= step1) {
          progressPercent = 1 - (this._time / (timemax * step1));
          this._fixedBalloonAlpha = progressPercent;
          this._fixedTextAlpha = progressPercent;
        }
      }

      this._context.clearRect(0, 0, this._canvas.width, this._canvas.height);
      _drawBalloon.call(this, this._context, x, y, width, height, this._canvas.width, this._canvas.height);
      this._time += this._pertime;
      if(this._time <= timemax) {
        return requestAnimationFrame(() => {
          return _startCloseAnimation.call(this, callback);
        });
      } else {
        this._context.clearRect(0, 0, this._canvas.width, this._canvas.height);
        if(callback !== null) {
          callback();
        }
        this.enableHandleResponse();
        return this._runningBallonAnimation = false;
      }
    };

    _openCbk = function() {
      if((this._canvas === null)) {
        this._canvas = document.getElementById(this.canvasElementId());
        this._context = this._canvas.getContext('2d');
      }
      this._animationFlg['isOpen'] = true;
      this.resetProgress();
      this.fontSize = _calcFontSizeAbout.call(this, this.inputText, this._canvas.width, this._canvas.height, this.isFixedFontSize, this.drawHorizontal);
      _setTextStyle.call(this);
      this._beforeWriteLength = 0;
      this._writeTextRunning = false;
      return this._isScrollHeader = false;
    };

    _oCbk = function() {
      this._animationFlg['isOpen'] = false;
      this.resetProgress();
      this._beforeWriteLength = 0;
      return this._writeTextRunning = false;
    };

    _closeCbk = function() {
      this._animationFlg['isOpen'] = false;
      if(!this._isFinishedEvent) {
        // 終了イベント
        this.finishEvent();
        if(typeof ScrollGuide !== 'undefined' && ScrollGuide !== null) {
          ScrollGuide.hideGuide();
        }
        if(typeof callback !== 'undefined' && callback !== null) {
          return callback();
        }
      }
    };

    _setTextStyle = function() {
      const canvas = document.getElementById(this.canvasElementId());
      const context = canvas.getContext('2d');
      return context.fillStyle = `rgb(${this.textColor.r},${this.textColor.g},${this.textColor.b})`;
    };

    _setNoTextStyle = function() {
      const canvas = document.getElementById(this.canvasElementId());
      const context = canvas.getContext('2d');
      return context.fillStyle = `rgba(${this.textColor.r},${this.textColor.g},${this.textColor.b}, 0.3)`;
    };

    _drawTextAndBalloonToCanvas = function(text, writingLength) {
      if(writingLength === null) {
        writingLength = text.length;
      }
      if((text === null)) {
        return;
      }
      const canvas = document.getElementById(this.canvasElementId());
      const context = canvas.getContext('2d');
      context.clearRect(0, 0, canvas.width, canvas.height);
      _drawBalloon.call(this, context, 0, 0, canvas.width, canvas.height);
      if((this.fontSize === null)) {
        this.fontSize = _calcFontSizeAbout.call(this, text, canvas.width, canvas.height, this.isFixedFontSize, this.drawHorizontal);
      }
      return _drawText.call(this, context, text, 0, 0, canvas.width, canvas.height, this.fontSize, writingLength);
    };

    _getRandomInt = (max, min) => Math.floor(Math.random() * (max - min)) + min;

    _balloonStyle = function(context) {
      context.fillStyle = `rgba(${this.balloonColor.r},${this.balloonColor.g},${this.balloonColor.b}, 0.95)`;
      context.strokeStyle = `rgba(${this.balloonBorderColor.r},${this.balloonBorderColor.g},${this.balloonBorderColor.b}, 0.95)`;
      context.lineWidth = this.balloonBorderWidth;
      // 影
      context.shadowColor = 'rgba(0,0,0,0.3)';
      context.shadowOffsetX = 3;
      context.shadowOffsetY = 3;
      return context.shadowBlur = 4;
    };

    _drawBalloon = function(context, x, y, width, height, canvasWidth, canvasHeight) {
      let addDeg, asc, beginX, beginY, bex, bey, c1x, c1y, c2x, c2y, cp1x, cp1y, cp2x, cp2y, cx, cy, deg, end, endX,
        endY, ex, ey, i, num, punkLineMax, punkLineMin, radiusX, radiusY, random, s;
      if(canvasWidth === null) {
        canvasWidth = width;
      }
      if(canvasHeight === null) {
        canvasHeight = height;
      }
      if(!this.showBalloon) {
        return;
      }
      if((width <= 0) || (height <= 0)) {
        // サイズが無い場合は描画無し
        return;
      }

      // キャッシュ参照
      const fba = (this._fixedBalloonAlpha !== null) ? this._fixedBalloonAlpha : 1;
      const cache = this.loadCache(['drawBalloonPathCacle', x, y, width, height, this.balloonType, fba]);
      if(cache !== null) {
        context.putImageData(cache, 0, 0);
        return;
      }

      const _drawArc = function() {
        // 円
        let r;
        context.beginPath();
        context.translate(canvasWidth * 0.5, canvasHeight * 0.5);
        // 調整
        const diff = 10.0;
        if(width > height) {
          context.scale(canvasWidth / canvasHeight, 1);
          r = (height * 0.5) - diff;
          if(r < 0) {
            r = 0;
          }
          context.arc(0, 0, Math.round(r), 0, Math.PI * 2);
        } else {
          context.scale(1, canvasHeight / canvasWidth);
          r = (width * 0.5) - diff;
          if(r < 0) {
            r = 0;
          }
          context.arc(0, 0, Math.round(r), 0, Math.PI * 2);
        }
        context.fill();
        return context.stroke();
      };

      const _drawRect = function() {
        // 四角
        context.beginPath();
        // FIXME: 描画オプション追加
        return context.fillRect(x, y, width, height);
      };

      const _drawBArc = function() {
        // 円 破線
        // 調整値
        let l, r, sum;
        const diff = 10.0;
        context.translate(canvasWidth * 0.5, canvasHeight * 0.5);
        const per = (Math.PI * 2) / 100;
        if(width > height) {
          context.scale(canvasWidth / canvasHeight, 1);
          sum = 0;
          x = 0;
          return (() => {
            const result = [];
            while(sum < (Math.PI * 2)) {
              context.beginPath();
              l = ((2 * Math.abs(Math.cos(x))) + 1) * per;
              y = x + l;
              r = (height * 0.5) - diff;
              if(r < 0) {
                r = 0;
              }
              context.arc(0, 0, Math.round(r), x, y);
              context.fill();
              context.stroke();
              sum += l;
              x = y;
              // 空白
              l = ((1 * Math.abs(Math.cos(x))) + 1) * per;
              y = x + l;
              sum += l;
              result.push(x = y);
            }
            return result;
          })();

        } else {
          context.scale(1, canvasHeight / canvasWidth);
          sum = 0;
          x = 0;
          return (() => {
            const result1 = [];
            while(sum < (Math.PI * 2)) {
              context.beginPath();
              l = ((2 * Math.abs(Math.sin(x))) + 1) * per;
              y = x + l;
              r = (width * 0.5) - diff;
              if(r < 0) {
                r = 0;
              }
              context.arc(0, 0, r, x, y);
              context.fill();
              context.stroke();
              sum += l;
              x = y;
              // 空白
              l = ((1 * Math.abs(Math.sin(x))) + 1) * per;
              y = x + l;
              sum += l;
              result1.push(x = y);
            }
            return result1;
          })();
        }
      };

      const _drawBRect = function() {
        // 四角 破線
        const dashLength = 5;
        context.beginPath();
        const _draw = function(sx, sy, ex, ey) {
          const deltaX = ex - sx;
          const deltaY = ey - sy;
          const numDashes = Math.floor(Math.sqrt((deltaX * deltaX) + (deltaY * deltaY)) / dashLength);
          return __range__(0, (numDashes - 1), true).map((i) =>
            (i % 2) === 0 ?
              context.moveTo(sx + ((deltaX / numDashes) * i), sy + ((deltaY / numDashes) * i))
              :
              context.lineTo(sx + ((deltaX / numDashes) * i), sy + ((deltaY / numDashes) * i)));
        };

        _draw.call(this, x, y, width, y);
        _draw.call(this, width, y, width, height);
        _draw.call(this, width, height, x, height);
        _draw.call(this, x, height, x, y);
        context.fillRect(x, y, width, height);
        return context.stroke();
      };

      const _drawShout = () => {
        // 叫び
        num = 18;
        radiusX = width / 2;
        radiusY = height / 2;
        cx = x + (width / 2);
        cy = y + (height / 2);
        if(this.drawHorizontal) {
          s = this.itemSize.h;
        } else {
          s = this.itemSize.w;
        }
        punkLineMax = s * 0.2;
        punkLineMin = s * 0.1;
        deg = 0;
        addDeg = 360 / num;
        // 共通設定
        context.beginPath();
        context.lineJoin = 'round';
        context.lineCap = 'round';
        if((this.balloonRandomIntValue === null)) {
          this.balloonRandomIntValue = _getRandomInt.call(this, punkLineMax, punkLineMin);
        }
        for(i = 0, end = num - 1, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
          deg += addDeg;
          random = this.balloonRandomIntValue;
          // 始点・終点
          beginX = PreloadItemText.getCircumPos.x(deg, radiusX, cx);
          beginY = PreloadItemText.getCircumPos.y(deg, radiusY, cy);
          endX = PreloadItemText.getCircumPos.x(deg + addDeg, radiusX, cx);
          endY = PreloadItemText.getCircumPos.y(deg + addDeg, radiusY, cy);
          // 制御値
          cp1x = PreloadItemText.getCircumPos.x(deg, radiusX - (random * 0.6), cx);
          cp1y = PreloadItemText.getCircumPos.y(deg, radiusY - (random * 0.6), cy);
          cp2x = PreloadItemText.getCircumPos.x(deg + addDeg, radiusX - (random * 0.6), cx);
          cp2y = PreloadItemText.getCircumPos.y(deg + addDeg, radiusY - (random * 0.6), cy);

          // 開始点と最終点のズレを調整する
          bex = Math.round(beginX);
          bey = Math.round(beginY);
          ex = Math.round(endX);
          ey = Math.round(endY);
          c1x = Math.round(cp1x);
          c1y = Math.round(cp1y);
          c2x = Math.round(cp2x);
          c2y = Math.round(cp2y);
          if(i === 0) {
            context.moveTo(bex, bey);
            context.arcTo(bex, bey, ex, ey, punkLineMax);
          }
          context.bezierCurveTo(c1x, c1y, c2x, c2y, ex, ey);
        }

        context.fill();
        return context.stroke();
      };

      const _drawThink = () => {
        // 考え中
        num = 8;
        cx = x + ((width) / 2);
        cy = y + ((height) / 2);
        if(this.drawHorizontal) {
          s = this.itemSize.h;
        } else {
          s = this.itemSize.w;
        }
        punkLineMax = s * 0.3;
        punkLineMin = s * 0.1;
        const diff = punkLineMin + ((punkLineMax - punkLineMin) * 0.6);
        radiusX = (width - diff) / 2;
        radiusY = (height - diff) / 2;
        deg = 0;
        addDeg = 360 / num;
        // 共通設定
        context.beginPath();
        context.lineJoin = 'round';
        context.lineCap = 'round';
        if((this.balloonRandomIntValue === null)) {
          this.balloonRandomIntValue = _getRandomInt.call(this, punkLineMax, punkLineMin);
        }
        for(i = 0, end = num - 1, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
          deg += addDeg;
          random = this.balloonRandomIntValue;
          // 始点・終点
          beginX = PreloadItemText.getCircumPos.x(deg, radiusX, cx);
          beginY = PreloadItemText.getCircumPos.y(deg, radiusY, cy);
          endX = PreloadItemText.getCircumPos.x(deg + addDeg, radiusX, cx);
          endY = PreloadItemText.getCircumPos.y(deg + addDeg, radiusY, cy);
          // 制御値
          cp1x = PreloadItemText.getCircumPos.x(deg, radiusX + (random * 0.7), cx);
          cp1y = PreloadItemText.getCircumPos.y(deg, radiusY + (random * 0.7), cy);
          cp2x = PreloadItemText.getCircumPos.x(deg + addDeg, radiusX + (random * 0.7), cx);
          cp2y = PreloadItemText.getCircumPos.y(deg + addDeg, radiusY + (random * 0.7), cy);

          bex = Math.round(beginX);
          bey = Math.round(beginY);
          ex = Math.round(endX);
          ey = Math.round(endY);
          c1x = Math.round(cp1x);
          c1y = Math.round(cp1y);
          c2x = Math.round(cp2x);
          c2y = Math.round(cp2y);
          // 開始点と最終点のズレを調整する
          if(i === 0) {
            context.moveTo(bex, bey);
            context.arcTo(bex, bey, ex, ey, punkLineMax);
          }
          context.bezierCurveTo(c1x, c1y, c2x, c2y, ex, ey);
        }

        context.fill();
        return context.stroke();
      };

      const _drawFreeHand = () => {
        if(this.freeHandDrawPaths !== null) {
          return _freeHandBalloonDraw.call(this, context, x, y, width, height, canvasWidth, canvasHeight, this.freeHandDrawPaths);
        }
      };

      context.save();
      context.globalAlpha = fba;
      _balloonStyle.call(this, context);
      if(this.balloonType === this.constructor.BalloonType.ARC) {
        _drawArc.call(this);
      } else if(this.balloonType === this.constructor.BalloonType.RECT) {
        _drawRect.call(this);
      } else if(this.balloonType === this.constructor.BalloonType.BROKEN_ARC) {
        _drawBArc.call(this);
      } else if(this.balloonType === this.constructor.BalloonType.BROKEN_RECT) {
        _drawBRect.call(this);
      } else if(this.balloonType === this.constructor.BalloonType.FLASH) {
        _drawShout.call(this);
      } else if(this.balloonType === this.constructor.BalloonType.CLOUD) {
        _drawThink.call(this);
      } else if(this.balloonType === this.constructor.BalloonType.FREE) {
        _drawFreeHand.call(this);
      }
      // キャッシュ保存
      this.saveCache(['drawBalloonPathCacle', x, y, width, height, this.balloonType], context.getImageData(0, 0, width, height));
      return context.restore();
    };

    _adjustFreeHandPath = function(drawPaths) {
      let i = drawPaths.length - 1;
      while(i >= 0) {
        // 不要なパスの削除
        if(drawPaths[i].length === 0) {
          drawPaths.splice(i, 1);
        }
        i -= 1;
      }

      // サブパス間のパスを追加
      const retArray = [drawPaths[0]];
      const searchedIndex = [0];
      var _search = function(targetIndex, isTail) {
        const searchTarget = drawPaths[targetIndex];
        const targetCood = isTail ? searchTarget[searchTarget.length - 1] : searchTarget[0];
        let mLen = 999999;
        let m = null;
        i = null;
        let it = null;
        for(let idx = 0; idx < drawPaths.length; idx++) {
          const dp = drawPaths[idx];
          for(let j of [0, dp.length - 1]) {
            // 一番距離が近いサブパスを検索
            if(searchedIndex.indexOf(idx) < 0) {
              const sq = Math.pow(dp[j].x - targetCood.x, 2) + Math.pow(dp[j].y - targetCood.y, 2);
              if(sq < mLen) {
                mLen = sq;
                m = {x: dp[j].x, y: dp[j].y};
                it = j !== 0;
                i = idx;
              }
            }
          }
        }
        if(m !== null) {
          let a = drawPaths[i].concat();
          if(it) {
            // 配列を反転させる
            a = a.reverse();
          }
          searchedIndex.push(i);
          retArray.push([targetCood, m]);
          retArray.push(a);
          return _search.call(this, i, !it);
        }
      };

      _search(0, true);

      return retArray;
    };

    _freeHandBalloonDraw = function(context, x, y, width, height, canvasWidth, canvasHeight, drawPaths) {
      let d, dp;
      const cx = canvasWidth * 0.5;
      const cy = canvasHeight * 0.5;
      // 座標修正
      const percent = width / canvasWidth;
      const modDP = [];
      for(let i1 = 0; i1 < drawPaths.length; i1++) {
        dp = drawPaths[i1];
        modDP[i1] = [];
        for(let i2 = 0; i2 < dp.length; i2++) {
          d = dp[i2];
          modDP[i1][i2] = {
            x: cx - ((cx - d.x) * percent),
            y: cy - ((cy - d.y) * percent)
          };
        }
      }

      // 描画
      context.beginPath();
      for(let idx1 = 0; idx1 < modDP.length; idx1++) {
        dp = modDP[idx1];
        for(let idx2 = 0; idx2 < dp.length; idx2++) {
          d = dp[idx2];
          const dx = d.x;
          const dy = d.y;
          if((idx1 === 0) && (idx2 === 0)) {
            context.moveTo(dx, dy);
          } else {
            context.lineTo(dx, dy);
          }
        }
      }
      context.closePath();
      context.lineJoin = 'round';
      context.lineCap = 'round';
      context.fill();
      return context.stroke();
    };

    _calcHorizontalColumnWidth = function(context, columnText) {
      let sum = 0;
      for(let char of Array.from(columnText.split(''))) {
        sum += context.measureText(char).width;
      }
      return sum;
    };

    _calcHorizontalColumnWidthMax = function(context, columns) {
      let ret = 0;
      for(let c of Array.from(columns)) {
        const r = _calcHorizontalColumnWidth.call(this, context, c);
        if(ret < r) {
          ret = r;
        }
      }
      return ret;
    };

    _calcVerticalColumnHeight = function(columnText, fontSize) {
      let ret = 0;
      for(let c of Array.from(columnText.split(''))) {
        const measure = _calcWordMeasure.call(this, c, fontSize, this.fontFamily);
        if(PreloadItemText.isJapanease(c)) {
          ret += _defaultWorkWidth.call(this, fontSize, this.fontFamily);
        } else {
          ret += measure.height;
        }
      }
      return ret;
    };

    _calcHorizontalColumnHeightMax = function(columnText, fontSize) {
      let ret = 0;
      for(let c of Array.from(columnText.split(''))) {
        const measure = _calcWordMeasure.call(this, c, fontSize, this.fontFamily);
        const r = measure.height;
        if(ret < r) {
          ret = r;
        }
      }
      return ret;
    };

    _calcHorizontalColumnHeightSum = function(columns, fontSize) {
      let sum = 0;
      for(let c of Array.from(columns)) {
        sum += _calcHorizontalColumnHeightMax.call(this, c, fontSize);
      }
      return sum;
    };

    _calcVerticalColumnHeightMax = function(columns, fontSize) {
      let ret = 0;
      for(let c of Array.from(columns)) {
        const r = _calcVerticalColumnHeight.call(this, c, fontSize);
        if(ret < r) {
          ret = r;
        }
      }
      return ret;
    };

    _setTextAlpha = function(context, idx, writingLength) {
      //writingLength = parseInt(writingLength)
      const methodName = this.getEventMethodName();
      if(methodName === 'changeText') {
        if(this._fixedTextAlpha !== null) {
          return context.globalAlpha = this._fixedTextAlpha;
        }
      } else if(methodName === 'writeText') {
        let ga;
        if(this._forward) {
          ga = 1;
          if((writingLength === 0) || (idx > writingLength)) {
            ga = 0;
          } else if(idx <= (writingLength - this._writeBlurLength)) {
            ga = 1;
          } else {
            ga = this._alphaDiff;
            if(ga < 0) {
              ga = 0;
            }
            if(ga > 1) {
              ga = 1;
            }
          }
          //console.log('ga:' + ga + ' _alphaDiff:' + @_alphaDiff + ' _writeBlurLength:' + @_writeBlurLength + ' idx:' + idx)
          return context.globalAlpha = ga;
        } else {
          ga = 1;
          if((writingLength === 0) || (idx > (writingLength + this._writeBlurLength))) {
            ga = 0;
          } else if(idx <= writingLength) {
            ga = 1;
          } else {
            ga = this._alphaDiff;
            if(ga < 0) {
              ga = 0;
            }
            if(ga > 1) {
              ga = 1;
            }
          }
          return context.globalAlpha = ga;
        }
      }
    };

    _writeLength = function(column, writingLength, wordSum) {
      let v = parseInt(writingLength - wordSum);
      if(v > column.length) {
        v = column.length;
      } else if(v < 0) {
        v = 0;
      }
      return v;
    };

    _drawText = function(context, text, x, y, width, height, fontSize, writingLength) {
      let c, idx, j;
      if(writingLength === null) {
        writingLength = text.length;
      }
      context.save();
      context.font = `${fontSize}px ${this.fontFamily}`;
      const wordWidth = _defaultWorkWidth.call(this, fontSize, this.fontFamily);
      const column = [''];
      let line = 0;
      text = text.replace("{br}", "\n", "gm");
      for(let i = 0, end = text.length - 1, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
        let char = text.charAt(i);
        if(((this.rowWordLength !== null) && (this.rowWordLength <= column[line].length)) || (char === "\n")) {
          line += 1;
          column[line] = '';
          if(char === "\n") {
            char = '';
          }
        }
        column[line] += char;
      }
      const sizeSum = 0;
      let wordSum = 0;
      if(this.drawHorizontal === this.constructor.WriteDirectionType.HORIZONTAL) {
        let asc1, end1;
        let heightLine = y + ((height - _calcHorizontalColumnHeightSum.call(this, column, fontSize)) * 0.5);
        const widthMax = _calcHorizontalColumnWidthMax.call(this, context, column);
        if(this.balloonType === this.constructor.BalloonType.FREE) {
          x += this.freeHandTextOffset.left;
          heightLine += this.freeHandTextOffset.top;
        }
        for(j = 0, end1 = column.length - 1, asc1 = 0 <= end1; asc1 ? j <= end1 : j >= end1; asc1 ? j++ : j--) {
          heightLine += _calcHorizontalColumnHeightMax.call(this, column[j], fontSize);
          let w = x;
          if(this.wordAlign === this.constructor.WordAlign.LEFT) {
            w += (width - widthMax) * 0.5;
          } else if(this.wordAlign === this.constructor.WordAlign.CENTER) {
            w += (width - _calcHorizontalColumnWidth.call(this, context, column[j])) * 0.5;
          } else {
            // RIGHT
            w += ((width + widthMax) * 0.5) - _calcHorizontalColumnWidth.call(this, context, column[j]);
          }
          context.beginPath();
          let wl = 0;
          const iterable = column[j].split('');
          for(idx = 0; idx < iterable.length; idx++) {
            c = iterable[idx];
            _setTextAlpha.call(this, context, idx + wordSum + 1, writingLength);
            context.fillText(c, Math.round(w + wl), Math.round(heightLine));
            wl += context.measureText(c).width;
          }
          wordSum += column[j].length;
        }
      } else {
        let asc2, end2;
        let widthLine = x + ((width + (wordWidth * column.length)) * 0.5);
        const heightMax = _calcVerticalColumnHeightMax.call(this, column, fontSize);
        if(this.balloonType === this.constructor.BalloonType.FREE) {
          widthLine += this.freeHandTextOffset.left;
          y += this.freeHandTextOffset.top;
        }
        for(j = 0, end2 = column.length - 1, asc2 = 0 <= end2; asc2 ? j <= end2 : j >= end2; asc2 ? j++ : j--) {
          widthLine -= wordWidth;
          let h = y;
          if(this.wordAlign === this.constructor.WordAlign.LEFT) {
            h += (height - heightMax) * 0.5;
          } else if(this.wordAlign === this.constructor.WordAlign.CENTER) {
            h += (height - _calcVerticalColumnHeight.call(this, column[j], fontSize)) * 0.5;
          } else {
            // RIGHT
            h += ((height + heightMax) * 0.5) - _calcVerticalColumnHeight.call(this, column[j], fontSize);
          }
          context.beginPath();
          let hl = 0;
          const iterable1 = column[j].split('');
          for(idx = 0; idx < iterable1.length; idx++) {
            c = iterable1[idx];
            const measure = _calcWordMeasure.call(this, c, fontSize, this.fontFamily);
            _setTextAlpha.call(this, context, idx + wordSum + 1, writingLength);
            if(PreloadItemText.isJapanease(c)) {
              hl += wordWidth;
            } else {
              hl += measure.height;
            }
            if(_isWordSmallJapanease.call(this, c)) {
              // 小文字は右上に寄せる
              const heightDiff = wordWidth * 0.1;
              context.fillText(c, Math.round(widthLine + ((wordWidth - measure.width) * 0.5)), Math.round((h + hl) - heightDiff));
            } else if(_isWordNeedRotate.call(this, c)) {
              // 90°回転
              var ww;
              context.save();
              context.beginPath();
              if(PreloadItemText.isJapanease(c)) {
                ww = wordWidth;
              } else {
                ww = measure.height;
              }
              context.translate(widthLine + (wordWidth * 0.5), (h + hl) - (ww * 0.5));
              // デバッグ用の円
              //context.arc(0, 0, 20, 0, Math.PI*2, false)
              //context.stroke()
              context.rotate(Math.PI / 2);
              // 「wordWidth * 0.75」は調整用の値
              // engDiffは英字の調整
              const engDiff = wordWidth - ww;
              context.fillText(c, Math.round(-measure.width * 0.5), Math.round((wordWidth * 0.75 * 0.5) - (engDiff * 0.5)));
              context.restore();
            } else {
              context.fillText(c, Math.round(widthLine), Math.round(h + hl));
            }
          }
          wordSum += column[j].length;
        }
      }
      return context.restore();
    };

    _calcWordMeasure = function(char, fontSize, fontFamily) {
      const fontSizeKey = `${fontSize}`;
      const cache = this.loadCache(['fontMeatureCache', fontSizeKey, fontFamily.replace(' ', '_'), char]);
      if(cache !== null) {
        return cache;
      }

      const nCanvas = document.createElement('canvas');
      nCanvas.width = 500;
      nCanvas.height = 500;
      const nContext = nCanvas.getContext('2d');
      nContext.font = `${fontSize}px ${fontFamily}`;
      nContext.textBaseline = 'top';
      nContext.fillStyle = (nCanvas.strokeStyle = '#ff0000');
      nContext.fillText(char, 0, 0);
      const writedImage = nContext.getImageData(0, 0, nCanvas.width, nCanvas.height);
      const mi = _measureImage.call(this, writedImage);

      //    if window.debug
      //      console.log('char: ' + char + ' textWidth:' + mi.width + ' textHeight:' + mi.height)

      this.saveCache(['fontMeatureCache', fontSizeKey, fontFamily.replace(' ', '_'), char], mi);
      return mi;
    };

    _measureImage = function(_writedImage) {
      const w = _writedImage.width;
      let x = 0;
      let y = 0;
      let minX = 9999;
      let maxX = 0;
      let minY = 9999;
      let maxY = 0;
      for(let i = 0, end = _writedImage.data.length - 1; i <= end; i += 4) {
        if(_writedImage.data[i + 0] > 128) {
          if(x < minX) {
            minX = x;
          }
          if(x > maxX) {
            maxX = x;
          }
          if(y < minY) {
            minY = y;
          }
          if(y > maxY) {
            maxY = y;
          }
        }
        x += 1;
        if(x >= w) {
          x = 0;
          y += 1;
        }
      }
      return {
        width: (maxX - minX) + 1,
        height: (maxY - minY) + 1
      };
    };

    _isWordSmallJapanease = function(char) {
      let list = '、。ぁぃぅぇぉっゃゅょゎァィゥェォッャュョヮヵヶ'.split('');
      list = list.concat([',', '\\.']);
      const regex = new RegExp(list.join('|'));
      return char.match(regex);
    };

    _isWordNeedRotate = function(char) {
      if(!PreloadItemText.isJapanease(char)) {
        // 英字は回転
        return true;
      }

      const list = 'ー＝〜・';
      const regex = new RegExp(list.split('').join('|'));
      return char.match(regex);
    };

    // 描画枠から大体のフォントサイズを計算
    _calcFontSizeAbout = function(text, width, height, isFixedFontSize, drawHorizontal) {
      if((width <= 0) || (height <= 0)) {
        return;
      }

      if((this.inputText === null)) {
        // Blankの場合は小さめのフォントで表示
        return 12;
      }

      // 文字数計算
      const a = text.length;
      // 文末の改行を削除
      text = text.replace(/\n+$/g, '');
      if(!isFixedFontSize) {
        // フォントサイズを計算
        let h, w;
        const newLineCount = text.split('\n').length - 1;
        // キャッシュ確認
        const cache = this.loadCache(['calcFontSizeAboutCache', newLineCount, width, height, drawHorizontal, this.showBalloon]);
        if(cache !== null) {
          return cache;
        }

        if(drawHorizontal === this.constructor.WriteDirectionType.HORIZONTAL) {
          w = height;
          h = width;
        } else {
          w = width;
          h = height;
        }
        let fontSize = ((Math.sqrt(Math.pow(newLineCount, 2) + ((w * 4 * (a + 1)) / h)) - newLineCount) * h) / ((a + 1) * 2);
        //      if debug
        //        console.log('fontSize:' + fontSize)

        // FontSizeは暫定
        fontSize = parseInt(fontSize / 1.8);
        if(fontSize < 1) {
          fontSize = 1;
        }
        if(this.showBalloon && (fontSize >= 6)) {
          fontSize -= 5;
        }
        // キャッシュ保存
        this.saveCache(['calcFontSizeAboutCache', newLineCount, width, height, drawHorizontal, this.showBalloon], fontSize);
        return fontSize;
      } else {
        return this.fixedFontSize;
      }
    };

    _showInputModal = function() {
      return Common.showModalView(constant.ModalViewType.ITEM_TEXT_EDITING, false, (modalEmt, params, callback = null) => {
        _prepareEditModal.call(this, modalEmt);
        if(callback !== null) {
          return callback();
        }
      });
    };

    _settingTextDbclickEvent = function() {
      // ダブルクリックでEditに変更
      return this.getJQueryElement().off('dblclick').on('dblclick', e => {
        e.preventDefault();
        // Modal表示
        return _showInputModal.call(this);
      });
    };

    _prepareEditModal = function(modalEmt) {
      if(this.inputText !== null) {
        $('.textarea:first', modalEmt).val(this.inputText);
      } else {
        $('.textarea:first', modalEmt).val('');
      }
      const directionSelect = $('.drawHorizontal_select:first', modalEmt);
      if(directionSelect.children().length === 0) {
        for(let o of Array.from(this.constructor.actionProperties.modifiables.drawHorizontal.options)) {
          $.extend(o, o[window.locale]);
          directionSelect.append(`<option value='${o.value}'>${o.name}</option>`);
        }
      }
      directionSelect.val('');

      $('.create_button', modalEmt).off('click').on('click', e => {
        // Inputを反映して再表示
        const emt = $(e.target).closest('.modal-content');
        this.inputText = $('.textarea:first', emt).val();
        this.drawHorizontal = parseInt($('.drawHorizontal_select:first', emt).val());
        // 吹き出し無し状態のfontSizeと行数を撮り直す
        const canvas = document.getElementById(this.canvasElementId());
        const sb = this.showBalloon;
        this.showBalloon = false;
        const fontSize = _calcFontSizeAbout.call(this, this.inputText, canvas.width, canvas.height, this.isFixedFontSize, this.drawHorizontal);
        this.rowWordLength = _calcRowWordLength.call(this, this.inputText, canvas.width, canvas.height, fontSize, this.fontFamily);
        this.showBalloon = sb;
        this.fontSize = _calcFontSizeAbout.call(this, this.inputText, canvas.width, canvas.height, this.isFixedFontSize, this.drawHorizontal);
        // データ保存
        this.saveObj();
        // モードを描画モードに
        Navbar.setModeDraw(this.classDistToken, () => {
          WorktableCommon.changeMode(constant.Mode.DRAW);
          this.refresh(true, () => {
            Common.hideModalView();
          });
        });
      });
      $('.back_button', modalEmt).off('click').on('click', e => {
        return Common.hideModalView();
      });
    };

    _calcRowWordLength = function(text, width, height, fontSize, fontFamily) {
      const canvas = document.getElementById(this.canvasElementId());
      const nCanvas = document.createElement('canvas');
      nCanvas.width = width;
      nCanvas.height = height;
      const nContext = nCanvas.getContext('2d');
      nContext.font = `${fontSize}px ${fontFamily}`;
      const column = [''];
      let line = 0;
      text = text.replace("{br}", "\n", "gm");
      for(let i = 0, end = text.length - 1, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
        let char = text.charAt(i);
        if((char === "\n") || ((this.drawHorizontal === this.constructor.WriteDirectionType.HORIZONTAL) && (nContext.measureText(column[line] + char).width > width)) || ((this.drawHorizontal === this.constructor.WriteDirectionType.VERTICAL) && (_calcVerticalColumnHeight.call(this, column[line] + char, fontSize) > height))) {
          if((char !== "\n") && !this.showBalloon) {
            return column[line].length;
          }
          line += 1;
          column[line] = '';
          if(char === "\n") {
            char = '';
          }
        }
        column[line] += char;
      }
      return null;
    };

    _defaultWorkWidth = function(fontSize, fontFamily) {
      const fontSizeKey = `${fontSize}`;
      if((this._defaultWorkWidth[fontSizeKey] !== null) && (this._defaultWorkWidth[fontSizeKey][fontFamily] !== null)) {
        return this._defaultWorkWidth[fontSizeKey][fontFamily];
      }

      const nCanvas = document.createElement('canvas');
      nCanvas.width = 500;
      nCanvas.height = 500;
      const context = nCanvas.getContext('2d');
      context.font = `${fontSize}px ${fontFamily}`;
      const wordWidth = context.measureText('あ').width;
      if((this._defaultWorkWidth[fontSizeKey] === null)) {
        this._defaultWorkWidth[fontSizeKey] = {};
      }
      return this._defaultWorkWidth[fontSizeKey][fontFamily] = wordWidth;
    };
  }

  // コンストラクタ
  // @param [Array] cood 座標
  constructor(cood = null) {
    super(cood);
    if(cood !== null) {
      this._moveLoc = {x: cood.x, y: cood.y};
    }
    this.inputText = null;
    this.drawHorizontal = this.constructor.WriteDirectionType.HORIZONTAL;
    //@fontFamily = 'Times New Roman'
    this.fontFamily = 'HGP行書体';
    this.fontSize = null;
    this.isFixedFontSize = false;
    this.rowWordLength = null;
    this.showBalloon = false;
    this.balloonValue = {};
    this.balloonType = null;
    this.balloonRandomIntValue = null;
    this.textPositions = null;
    this.wordAlign = this.constructor.WordAlign.LEFT;
    this.originalItemSize = null;
    this.freeHandItemSize = null;
    this.freeHandDrawPaths = null;
    this.freeHandTextOffset = {top: 0, left: 0};
    this._freeHandDrawPadding = 5;
    this._fixedTextAlpha = null;
    this._defaultWorkWidth = {};
  }

  // アイテム描画
  // @param [Boolean] show 要素作成後に表示するか
  itemDraw(show) {
    if(show === null) {
      show = true;
    }
    super.itemDraw(show);
    if(show) {
      // スタイル設定
      if(this.inputText !== null) {
        _setTextStyle.call(this);
      } else {
        _setNoTextStyle.call(this);
      }
      // 文字配置 & フォント設定
      if(this.inputText !== null) {
        return _drawTextAndBalloonToCanvas.call(this, this.inputText);
      } else {
        return _drawTextAndBalloonToCanvas.call(this, this.constructor.NO_TEXT);
      }
    }
  }

  // メソッド実行(ItemEventBaseのオーバーライド)
  // FIXME: アニメーション処理などで各メソッドの終了が遅れる場合があるため、全メソッドでcallbackを呼ばせるように変更するか考える
  execMethod(opt, callback = null) {
    return EventBase.prototype.execMethod.call(this, opt, () => {
      const methodName = this.getEventMethodName();
      if(methodName !== EventPageValueBase.NO_METHOD) {
        if(methodName === 'writeText') {
          return (this.constructor.prototype[methodName]).call(this, opt, callback);
        } else {
          (this.constructor.prototype[methodName]).call(this, opt);
          if(callback !== null) {
            return callback();
          }
        }
      } else {
        // アイテム状態の表示反映
        this.updatePositionAndItemSize(this.itemSize, false, false);
        if(callback !== null) {
          return callback();
        }
      }
    });
  }

  // 再描画処理
  // @param [boolean] show 要素作成後に描画を表示するか
  // @param [Function] callback コールバック
  refresh(show, callback = null) {
    if(show === null) {
      show = true;
    }
    return super.refresh(show, () => {
      _settingTextDbclickEvent.call(this);
      if(callback !== null) {
        return callback(this);
      }
    });
  }

  changeInstanceVarByConfig(varName, value) {
    let canvas, h, height, w, width;
    if((varName === 'drawHorizontal') && (this.drawHorizontal !== value)) {
      // Canvas縦横変更
      canvas = document.getElementById(this.canvasElementId());
      ({width} = canvas);
      ({height} = canvas);
      //$(canvas).css({width: "#{height}px", height: "#{width}px"})
      $(canvas).attr({width: height, height: width});
      ({w} = this.itemSize);
      ({h} = this.itemSize);
      this.itemSize.w = h;
      this.itemSize.h = w;
    } else if((varName === 'showBalloon') && (this.showBalloon !== value) && !this.isFixedFontSize) {
      // FontSizeを撮り直す
      canvas = document.getElementById(this.canvasElementId());
      this.showBalloon = value;
      this.fontSize = _calcFontSizeAbout.call(this, this.inputText, canvas.width, canvas.height, this.isFixedFontSize, this.drawHorizontal);
    } else if((varName === 'isFixedFontSize') || (varName === 'fixedFontSize')) {
      // FontSizeを撮り直す
      canvas = document.getElementById(this.canvasElementId());
      this[varName] = value;
      this.fontSize = _calcFontSizeAbout.call(this, this.inputText, canvas.width, canvas.height, this.isFixedFontSize, this.drawHorizontal);
    } else if((varName === 'balloonType') && (this.balloonType !== null) && (this.balloonType !== value)) {
      if(value === this.constructor.BalloonType.FREE) {
        // パスを消去して新規作成する
        this.freeHandDrawPaths = null;
        const opt = {
          multiDraw: true,
          applyDrawCallback: drawPaths => {
            // 配列調整
            let d;
            drawPaths = _adjustFreeHandPath.call(this, drawPaths);
            if((drawPaths === null)) {
              // 調整失敗
              return false;
            }

            // キャンパスサイズ拡張
            this.originalItemSize = $.extend({}, this.itemSize);
            let minX = 999999;
            let maxX = -1;
            let minY = 999999;
            let maxY = -1;
            for(var dp of Array.from(drawPaths)) {
              for(d of Array.from(dp)) {
                if(minX > d.x) {
                  minX = d.x;
                }
                if(minY > d.y) {
                  minY = d.y;
                }
                if(maxX < d.x) {
                  maxX = d.x;
                }
                if(maxY < d.y) {
                  maxY = d.y;
                }
              }
            }
            // drawPaths値更新
            for(let idx1 = 0; idx1 < drawPaths.length; idx1++) {
              dp = drawPaths[idx1];
              for(let idx2 = 0; idx2 < dp.length; idx2++) {
                d = dp[idx2];
                drawPaths[idx1][idx2] = {
                  x: Math.round((d.x - minX) + this._freeHandDrawPadding),
                  y: Math.round((d.y - minY) + this._freeHandDrawPadding)
                };
              }
            }

            this.itemSize.x = (window.scrollContents.scrollLeft() + minX) - this._freeHandDrawPadding;
            this.itemSize.y = (window.scrollContents.scrollTop() + minY) - this._freeHandDrawPadding;
            this.itemSize.w = (maxX - minX) + (this._freeHandDrawPadding * 2);
            this.itemSize.h = (maxY - minY) + (this._freeHandDrawPadding * 2);
            this.freeHandTextOffset.left = (this.originalItemSize.x + (this.originalItemSize.w * 0.5)) - (this.itemSize.x + (this.itemSize.w * 0.5));
            this.freeHandTextOffset.top = (this.originalItemSize.y + (this.originalItemSize.h * 0.5)) - (this.itemSize.y + (this.itemSize.h * 0.5));
            this.getJQueryElement().remove();
            this.createItemElement(() => {
              this.freeHandItemSize = $.extend({}, this.itemSize);
              this.freeHandDrawPaths = drawPaths;
              this.saveObj();
              this.itemDraw(true);
              if(this.setupItemEvents !== null) {
                // アイテムのイベント設定
                return this.setupItemEvents();
              }

            });
            return true;
          }
        };
        EventDragPointingDraw.run(opt);
      } else {
        // アイテムのサイズを戻す
        if(this.originalItemSize !== null) {
          this.itemSize = $.extend({}, this.originalItemSize);
          this.getJQueryElement().remove();
          this.createItemElement(() => {
            this.saveObj();
            if(this.setupItemEvents !== null) {
              // アイテムのイベント設定
              return this.setupItemEvents();
            }
          });
        }
        this.freeHandTextOffset = {top: 0, left: 0};
      }
    }

    return super.changeInstanceVarByConfig(varName, value);
  }

  // テキストはCanvasの伸縮をさせないため、メソッド上書き
  updateItemSize(w, h) {
    const element = $(`#${this.id}`);
    element.css({width: w, height: h});
    const canvas = $(`#${this.canvasElementId()}`);
    const scaleW = element.width() / this.itemSize.w;
    const scaleH = element.height() / this.itemSize.h;
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    this.itemSize.w = w;
    return this.itemSize.h = h;
  }

  // アニメーション変更前のアイテムサイズ
  // テキストはCanvasの伸縮をさせないため、メソッド上書き
  originalItemElementSize() {
    const obj = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceBefore(this._event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
    return obj.itemSize;
  }

  // マウスアップ時の描画イベント
  mouseUpDrawing(zindex, callback = null) {
    this.restoreAllDrawingSurface();
    // テキストModal表示
    _showInputModal.call(this);
    // 編集状態で描画
    return this.endDraw(zindex, true, () => {
      this.setupItemEvents();
      this.saveObj(true);
      // フォーカス設定
      this.firstFocus = Common.firstFocusItemObj() === null;
      // 編集モード
      Navbar.setModeEdit();
      WorktableCommon.changeMode(constant.Mode.EDIT);
      if(callback !== null) {
        return callback();
      }
    });
  }

  // イベント前の表示状態にする
  updateEventBefore() {
    super.updateEventBefore();
    this._animationFlg = {};
    return this._animationFlg['isOpen'] = false;
  }

  // イベント後の表示状態にする
  updateEventAfter() {
    super.updateEventAfter();
    this._animationFlg = {};
    return this._animationFlg['isOpen'] = false;
  }

  // 最終ステップでメソッドを実行(オーバーライド)
  execLastStep(callback = null) {
    // イベント終了を呼ぶだけ(開始と終了で表示が変わらないため)
    this.finishEvent();
    if(callback !== null) {
      return callback();
    }
  }

  startOpenAnimation(callback = null) {
    if((this._runningBallonAnimation !== null) && this._runningBallonAnimation) {
      return;
    }
    this._runningBallonAnimation = true;
    this._time = 0;
    this._pertime = 1;
    this.disableHandleResponse();
    return requestAnimationFrame(() => {
      return _startOpenAnimation.call(this, callback);
    });
  }

  startCloseAnimation(callback = null) {
    if((this._runningBallonAnimation !== null) && this._runningBallonAnimation) {
      return;
    }
    this._runningBallonAnimation = true;
    this._time = 0;
    this._pertime = 1;
    this.disableHandleResponse();
    return requestAnimationFrame(() => {
      return _startCloseAnimation.call(this, callback);
    });
  }

  willChapter(callback = null) {
    this._animationFlg = {};
    this._animationFlg['isOpen'] = false;
    return super.willChapter(callback);
  }

  static isJapanease(c) {
    return c.charCodeAt(0) >= 256;
  }

  changeText(opt) {
    this.showWithAnimation = this.showWithAnimation__after;
    this.showAnimationType = this.showAnimationType__after;
    this.showAnimationType;
    if(this.showWithAnimation && (this._animationFlg['isOpen'] === null)) {
      this.startOpenAnimation(() => {
        return this.changeText(opt);
      });
      this._animationFlg['isOpen'] = true;
    } else {
      const opa = opt.progress / opt.progressMax;
      const canvas = document.getElementById(this.canvasElementId());
      const context = canvas.getContext('2d');
      context.clearRect(0, 0, canvas.width, canvas.height);
      context.fillStyle = `rgb(${this.textColor.r},${this.textColor.g},${this.textColor.b})`;
      this._fixedTextAlpha = 1 - opa;
      _drawTextAndBalloonToCanvas.call(this, this.inputText__before);
      this._fixedTextAlpha = opa;
      _drawTextAndBalloonToCanvas.call(this, this.inputText__after);
    }

    if((opt.progress === opt.progressMax) && this.showWithAnimation && (this._animationFlg['isOpen'] !== null) && this._animationFlg['isOpen']) {
      this.startCloseAnimation();
      return this._animationFlg['isOpen'] = false;
    }
  }

  writeText(opt, callback = null) {
    this.showWithAnimation = this.showWithAnimation__after;
    this.showAnimationType = this.showAnimationType__after;
    this._forward = opt.forward;
    if(this._forward && ((this._animationFlg['isOpen'] === null) || !this._animationFlg['isOpen'])) {
      if(this.showWithAnimation) {
        this.startOpenAnimation(() => {
          return _openCbk.call(this);
        });
      } else {
        _openCbk.call(this);
      }
    } else {
      if(!this._forward && (opt.progress <= 0) && this._animationFlg['isOpen']) {
        if(this.showWithAnimation) {
          this.startCloseAnimation(() => {
            return _oCbk.call(this);
          });
        } else {
          _oCbk.call(this);
        }
      } else if((opt.progress <= opt.progressMax) && (this.inputText !== null) && (this.inputText.length > 0)) {
        if((this._writeTextRunning === null) || !this._writeTextRunning) {
          this._fixedTextAlpha = null;
          const adjustProgress = opt.progressMax / this.inputText.length;
          const writeLength = (this.inputText.length * (opt.progress + (adjustProgress * 0.5))) / opt.progressMax;
          const writeBlurLength = parseInt(writeLength) - parseInt(this._beforeWriteLength);
          if(Math.abs(writeBlurLength) > 0) {
            this._animationFlg['isOpen'] = true;
            if(parseInt(writeLength) < this.inputText.length) {
              this._finishedWrite = false;
            }
            this._writeTextRunning = true;
            this._beforeWriteLength = writeLength;
            this._writeBlurLength = Math.abs(writeBlurLength);
            let cache = this.loadCache('writeTextBlurCache');
            if(cache !== null) {
              this._context.putImageData(cache, 0, 0);
            } else {
              this._context.clearRect(0, 0, this._canvas.width, this._canvas.height);
              _drawBalloon.call(this, this._context, 0, 0, this._canvas.width, this._canvas.height);
              this.saveCache('writeTextBlurCache', this._context.getImageData(0, 0, this._canvas.width, this._canvas.height));
              cache = this.loadCache('writeTextBlurCache');
            }
            this._alphaDiff = 0;
            var _write = function() {
              this._context.putImageData(cache, 0, 0);
              _drawText.call(this, this._context, this.inputText, 0, 0, this._canvas.width, this._canvas.height, this.fontSize, writeLength);
              this._alphaDiff += 0.25;
              if(this._alphaDiff <= 1) {
                return _write.call(this);
              } else {
                this._writeTextRunning = false;
                return this._finishedWrite = parseInt(writeLength) >= this.inputText.length;
              }
            };
            _write.call(this);
          }
        }
      }
    }

    if((opt.progress >= opt.progressMax) && (this._finishedWrite !== null) && this._finishedWrite && ((this._animationFlg['isOpen'] !== null) && this._animationFlg['isOpen'])) {
      this._writeTextRunning = false;
      if(this.showWithAnimation) {
        return this.startCloseAnimation(() => {
          return _closeCbk.call(this);
        });
      } else {
        return _closeCbk.call(this);
      }
    } else {
      if(callback !== null) {
        return callback();
      }
    }
  }
};
PreloadItemText.initClass();

Common.setClassToMap(PreloadItemText.CLASS_DIST_TOKEN, PreloadItemText);

if((window.itemInitFuncList !== null) && (window.itemInitFuncList[PreloadItemText.CLASS_DIST_TOKEN] === null)) {
  if(window.debug) {
    console.log('PreloadItemText loaded');
  }
  window.itemInitFuncList[PreloadItemText.CLASS_DIST_TOKEN] = function(option) {
    if(option === null) {
      option = {};
    }
    if(window.isWorkTable && (PreloadItemText.jsLoaded !== null)) {
      PreloadItemText.jsLoaded(option);
    }
    //JS読み込み完了後の処理
    if(window.debug) {
      return console.log('PreloadItemText init Finish');
    }
  };
}

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for(let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}