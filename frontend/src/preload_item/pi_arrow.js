/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS202: Simplify dynamic range loops
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// 矢印アイテム
// @extend CanvasItemBase
var PreloadItemArrow = (function() {
  let HEADER_WIDTH = undefined;
  let HEADER_HEIGHT = undefined;
  let _coodLength = undefined;
  let _calDrection = undefined;
  let _calTrianglePath = undefined;
  let _calTailDrawPath = undefined;
  let _calBodyPath = undefined;
  let _drawCoodToCanvas = undefined;
  let _drawCoodToBaseCanvas = undefined;
  let _drawCoodToNewCanvas = undefined;
  let _drawNewCanvas = undefined;
  let _coodLog = undefined;
  let _updateArrowRect = undefined;
  let _drawPath = undefined;
  let _drawLine = undefined;
  let _resetDrawPath = undefined;
  PreloadItemArrow = class PreloadItemArrow extends CanvasItemBase {
    static initClass() {
      this.NAME_PREFIX = "Arrow";
      this.CLASS_DIST_TOKEN = 'PreloadItemArrow';

      // @property [Int] HEADER_WIDTH 矢印の頭の幅
      HEADER_WIDTH = 100;
      // @property [Int] HEADER_HEIGHT 矢印の頭の長さ
      HEADER_HEIGHT = 50;

      this.actionProperties =
        {
          defaultEvent: {
            method: 'changeDraw',
            actionType: 'scroll',
            scrollEnabledDirection: {
              top: true,
              bottom: true,
              left: false,
              right: false
            },
            scrollForwardDirection: {
              top: false,
              bottom: true,
              left: false,
              right: false
            }
          },
          designConfig: true,
          designConfigDefaultValues: {
            values: {
              design_slider_font_size_value: 14,
              design_font_color_value: 'ffffff',
              design_slider_padding_top_value: 10,
              design_slider_padding_left_value: 20,
              design_slider_gradient_deg_value: 0,
              design_bg_color1_value: 'ffbdf5',
              design_bg_color2_value: 'ff82ec',
              design_bg_color2_position_value: 25,
              design_bg_color3_value: 'fc46e1',
              design_bg_color3_position_value: 50,
              design_bg_color4_value: 'fc46e1',
              design_bg_color4_position_value: 75,
              design_bg_color5_value: 'fc46e1',
              design_border_color_value: 'ffffff',
              design_slider_border_radius_value: 30,
              design_slider_border_width_value: 3,
              design_slider_shadow_left_value: 3,
              design_slider_shadow_top_value: 3,
              design_slider_shadow_size_value: 11,
              design_shadow_color_value: '000,000,000',
              design_slider_shadow_opacity_value: 0.5
            },
            flags: {
              design_bg_color2_flag: false,
              design_bg_color3_flag: false,
              design_bg_color4_flag: false
            }
          },
          modifiables: {
            arrowWidth: {
              name: "Arrow's width",
              default: 37,
              type: 'number',
              min: 1,
              max: 99,
              ja: {
                name: "矢印の幅"
              }
            }
          },
          methods: {
            changeDraw: {
              modifiables: {
                arrowWidth: {
                  name: "Arrow's width",
                  type: 'number',
                  min: 1,
                  max: 99,
                  varAutoChange: true,
                  ja: {
                    name: "矢印の幅"
                  }
                }
              },
              options: {
                id: 'drawScroll',
                name: 'Draw',
                desc: "Draw",
                ja: {
                  name: '描画',
                  desc: '矢印を描画'
                }
              }
            },
            changeColor: {
              actionType: 'click',
              options: {
                id: 'changeColor_Design',
                name: 'Change color'
              }
            }
          }
        };

      // 座標間の距離を計算する
      // @private
      _coodLength = (locA, locB) =>
        // 整数にする
        parseInt(Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2)))
      ;

      // 進行方向を設定
      // @private
      _calDrection = function(beforeLoc, cood) {
        if((beforeLoc == null) || (cood == null)) {
          return;
        }

        let x = null;
        if(beforeLoc.x < cood.x) {
          x = 1;
        } else if(beforeLoc.x === cood.x) {
          x = 0;
        } else {
          x = -1;
        }

        let y = null;
        if(beforeLoc.y < cood.y) {
          y = 1;
        } else if(beforeLoc.y === cood.y) {
          y = 0;
        } else {
          y = -1;
        }

        //console.log('direction x:' + x + ' y:' + y)
        return this._direction = {x, y};
      };

      // 矢印の頭を作成
      // @private
      _calTrianglePath = function(leftCood, rightCood) {
        if((leftCood == null) || (rightCood == null)) {
          return null;
        }

        const r = {
          x: leftCood.x - rightCood.x,
          y: leftCood.y - rightCood.y
        };
        const sita = Math.atan2(r.y, r.x);
        const leftTop = {
          x: ((Math.cos(sita) * (this.header_width + this.arrowWidth)) / 2.0) + rightCood.x,
          y: ((Math.sin(sita) * (this.header_width + this.arrowWidth)) / 2.0) + rightCood.y
        };

        const sitaRight = sita + Math.PI;

        const rightTop = {
          x: ((Math.cos(sitaRight) * (this.header_width - this.arrowWidth)) / 2.0) + rightCood.x,
          y: ((Math.sin(sitaRight) * (this.header_width - this.arrowWidth)) / 2.0) + rightCood.y
        };

        const sitaTop = sita + (Math.PI / 2.0);

        const mid = {
          x: (leftCood.x + rightCood.x) / 2.0,
          y: (leftCood.y + rightCood.y) / 2.0
        };
        const top = {
          x: (Math.cos(sitaTop) * this.header_height) + mid.x,
          y: (Math.sin(sitaTop) * this.header_height) + mid.y
        };

        return this._headPartCoord = [rightTop, top, leftTop];
      };

      // 矢印の尾を作成
      // @private
      _calTailDrawPath = function() {
        /* 検証 */
        const _validate = function() {
          return this._drawCoodRegist.length === 2;
        };

        if(!_validate.call(this)) {
          return;
        }

        const locTail = this._drawCoodRegist[0];
        const locSub = this._drawCoodRegist[1];

        // 座標を保存
        const rad = Math.atan2(locSub.y - locTail.y, locSub.x - locTail.x);
        const arrowHalfWidth = this.arrowWidth / 2.0;
        this._rightBodyPartCoord.push({
          x: -(Math.sin(rad) * arrowHalfWidth) + locTail.x,
          y: (Math.cos(rad) * arrowHalfWidth) + locTail.y
        });
        return this._leftBodyPartCoord.push({
          x: (Math.sin(rad) * arrowHalfWidth) + locTail.x,
          y: -(Math.cos(rad) * arrowHalfWidth) + locTail.y
        });
      };

      // 矢印の本体を作成
      // @private
      _calBodyPath = function() {
        /* 検証 */
        const _validate = function() {
          return this._drawCoodRegist.length >= 3;
        };

        /* 3点から引く座標を求める */
        const _calCenterBodyCood = function(left, center, right) {

          const leftLength = _coodLength.call(this, left, center);
          const rightLength = _coodLength.call(this, right, center);

          const l = {x: left.x - center.x, y: left.y - center.y};
          const r = {x: right.x - center.x, y: right.y - center.y};
          let cos = ((l.x * r.x) + (l.y * r.y)) / (leftLength * rightLength);
          if(cos < -1) {
            cos = -1.0;
          }
          if(cos > 1) {
            cos = 1.0;
          }
          const vectorRad = Math.acos(cos);
          const rad = Math.atan2(r.y, r.x) + (vectorRad / 2.0);

          //      _coodLog.call(@, left, 'left:')
          //      _coodLog.call(@, center, 'center:')
          //      _coodLog.call(@, right, 'right:')
          //      _coodLog.call(@, l, 'l')
          //      _coodLog.call(@, r, 'r')
          //      console.log('leftLength:' + leftLength + ' rightLength:' + rightLength)
          //      console.log('vectorRad:' + vectorRad)
          //      console.log('rad:' + rad)
          //      console.log('locLeft:x ' + Math.cos(rad + Math.PI))
          //      console.log('locLeft:y ' + Math.sin(rad + Math.PI))
          //      console.log('locRight:x ' + Math.cos(rad))
          //      console.log('locRight:x ' + Math.sin(rad))

          const arrowHalfWidth = this.arrowWidth / 2.0;
          const leftX = parseInt((Math.cos(rad + Math.PI) * arrowHalfWidth) + center.x);
          const leftY = parseInt((Math.sin(rad + Math.PI) * arrowHalfWidth) + center.y);
          const rightX = parseInt((Math.cos(rad) * arrowHalfWidth) + center.x);
          const rightY = parseInt((Math.sin(rad) * arrowHalfWidth) + center.y);

          const ret = {
            coodLeftPart: {
              x: leftX,
              y: leftY
            },
            coodRightPart: {
              x: rightX,
              y: rightY
            }
          };
          return ret;
        };

        /* 進行方向から最適化 */
        const _suitCoodBasedDirection = function(cood) {

          const _suitCood = function(cood, beforeCood) {
            if((this._direction.x < 0) &&
              (beforeCood.x < cood.x)) {
              cood.x = beforeCood.x;
            } else if((this._direction.x > 0) &&
              (beforeCood.x > cood.x)) {
              cood.x = beforeCood.x;
            }
            if((this._direction.y < 0) &&
              (beforeCood.y < cood.y)) {
              cood.y = beforeCood.y;
            } else if((this._direction.y > 0) &&
              (beforeCood.y > cood.y)) {
              cood.y = beforeCood.y;
            }
            return cood;
          };

          const beforeLeftCood = this._leftBodyPartCoord[this._leftBodyPartCoord.length - 1];
          const beforeRightCood = this._rightBodyPartCoord[this._rightBodyPartCoord.length - 1];
          const leftCood = _suitCood.call(this, cood.coodLeftPart, beforeLeftCood);
          const rightCood = _suitCood.call(this, cood.coodRightPart, beforeRightCood);

          const ret = {
            coodLeftPart: leftCood,
            coodRightPart: rightCood
          };
          return ret;
        };

        if(!_validate.call(this)) {
          return;
        }

        const locLeftBody = this._leftBodyPartCoord[this._leftBodyPartCoord.length - 1];
        const locRightBody = this._rightBodyPartCoord[this._rightBodyPartCoord.length - 1];
        let centerBodyCood = _calCenterBodyCood.call(this, this._drawCoodRegist[this._drawCoodRegist.length - 3], this._drawCoodRegist[this._drawCoodRegist.length - 2], this._drawCoodRegist[this._drawCoodRegist.length - 1]);
        centerBodyCood = _suitCoodBasedDirection.call(this, centerBodyCood);
        //    console.log('Left')
        //    _coodLog.call(@, locLeftBody, 'moveTo')
        //    _coodLog.call(@, centerBodyCood.coodLeftPart, 'lineTo')
        //    console.log('Right')
        //    _coodLog.call(@, locRightBody, 'moveTo')
        //    _coodLog.call(@, centerBodyCood.coodRightPart, 'lineTo')

        this._leftBodyPartCoord.push(centerBodyCood.coodLeftPart);
        return this._rightBodyPartCoord.push(centerBodyCood.coodRightPart);
      };

      // 座標をCanvasに描画
      // @private
      // @param [Object] dc CanvasContext(isBaseCanvasがfalseの場合使用)
      _drawCoodToCanvas = function(dc = null) {
        let i;
        let asc1, end;
        let asc2, end1;
        let drawingContext = null;
        if(dc !== null) {
          drawingContext = dc;
        } else {
          ({drawingContext} = window);
        }
        if((this._leftBodyPartCoord.length <= 0) || (this._rightBodyPartCoord.length <= 0)) {
          // 尾が描かれてない場合
          return;
        }

        drawingContext.moveTo(this._leftBodyPartCoord[this._leftBodyPartCoord.length - 1].x, this._leftBodyPartCoord[this._leftBodyPartCoord.length - 1].y);
        if(this._leftBodyPartCoord.length >= 2) {
          let asc, start;
          for(start = this._leftBodyPartCoord.length - 2, i = start, asc = start <= 0; asc ? i <= 0 : i >= 0; asc ? i++ : i--) {
            drawingContext.lineTo(this._leftBodyPartCoord[i].x, this._leftBodyPartCoord[i].y);
          }
        }
        for(i = 0, end = this._rightBodyPartCoord.length - 1, asc1 = 0 <= end; asc1 ? i <= end : i >= end; asc1 ? i++ : i--) {
          drawingContext.lineTo(this._rightBodyPartCoord[i].x, this._rightBodyPartCoord[i].y);
        }
        for(i = 0, end1 = this._headPartCoord.length - 1, asc2 = 0 <= end1; asc2 ? i <= end1 : i >= end1; asc2 ? i++ : i--) {
          drawingContext.lineTo(this._headPartCoord[i].x, this._headPartCoord[i].y);
        }
        return drawingContext.closePath();
      };

      // 座標を基底Canvasに描画
      _drawCoodToBaseCanvas = function() {
        return _drawCoodToCanvas.call(this);
      };

      // 座標を新しいCanvasに描画
      _drawCoodToNewCanvas = function() {
        const drawingCanvas = document.getElementById(this.canvasElementId());
        const drawingContext = drawingCanvas.getContext('2d');
        return _drawCoodToCanvas.call(this, drawingContext);
      };

      // 新しいCanvasに矢印を描画
      _drawNewCanvas = function() {
        const drawingCanvas = document.getElementById(this.canvasElementId());
        const drawingContext = drawingCanvas.getContext('2d');
        drawingContext.beginPath();
        // 尾と体の座標をCanvasに描画
        _drawCoodToNewCanvas.call(this);
        return this.applyDesignTool();
      };

      // 座標のログを表示
      // @private
      _coodLog = function(cood, name) {
        if(window.debug) {
          return console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y);
        }
      };

      // 矢印のサイズ更新
      // @private
      _updateArrowRect = function(cood) {
        if(this.itemSize === null) {
          return this.itemSize = {x: cood.x, y: cood.y, w: 0, h: 0};
        } else {
          let minX = cood.x - this.padding_size;
          minX = minX < 0 ? 0 : minX;
          let minY = cood.y - this.padding_size;
          minY = minY < 0 ? 0 : minY;
          let maxX = cood.x + this.padding_size;
          maxX = maxX > drawingCanvas.width ? drawingCanvas.width : maxX;
          let maxY = cood.y + this.padding_size;
          maxY = maxY > drawingCanvas.height ? drawingCanvas.height : maxY;

          if(this.itemSize.x > minX) {
            this.itemSize.w += this.itemSize.x - minX;
            this.itemSize.x = minX;
          }
          if((this.itemSize.x + this.itemSize.w) < maxX) {
            this.itemSize.w += maxX - (this.itemSize.x + this.itemSize.w);
          }
          if(this.itemSize.y > minY) {
            this.itemSize.h += this.itemSize.y - minY;
            this.itemSize.y = minY;
          }
          if((this.itemSize.y + this.itemSize.h) < maxY) {
            return this.itemSize.h += maxY - (this.itemSize.y + this.itemSize.h);
          }
        }
      };

      // パスの描画
      // @param [Array] moveCood 画面ドラッグ座標
      _drawPath = function(moveCood) {
        _calDrection.call(this, this._drawCoodRegist[this._drawCoodRegist.length - 1], moveCood);
        this._drawCoodRegist.push(moveCood);

        // 尾の部分の座標を計算
        _calTailDrawPath.call(this);
        // 体の部分の座標を計算
        _calBodyPath.call(this, moveCood);
        // 頭の部分の座標を計算
        return _calTrianglePath.call(this, this._leftBodyPartCoord[this._leftBodyPartCoord.length - 1], this._rightBodyPartCoord[this._rightBodyPartCoord.length - 1]);
      };
      //console.log("@traceTriangelHeadIndex:" + @traceTriangelHeadIndex)

      // 線の描画
      _drawLine = function() {
        drawingContext.beginPath();
        // 尾と体の座標をCanvasに描画
        _drawCoodToBaseCanvas.call(this);
        drawingContext.globalAlpha = 0.3;
        return drawingContext.stroke();
      };

      // パスの情報をリセット
      _resetDrawPath = function() {
        this._headPartCoord = [];
        this._leftBodyPartCoord = [];
        this._rightBodyPartCoord = [];
        return this._drawCoodRegist = [];
      };
    }

    // コンストラクタ
    // @param [Array] cood 座標
    constructor(cood = null) {
      {
        // Hack: trick Babel/TypeScript into allowing this before super.
        if(false) {
          super();
        }
        let thisFn = (() => {
          this;
        }).toString();
        let thisName = thisFn.slice(thisFn.indexOf('{') + 1, thisFn.indexOf(';')).trim();
        eval(`${thisName} = this;`);
      }
      this.changeColor = this.changeColor.bind(this);
      super(cood);
      // @property [Array] direction 矢印の進行方向
      this._direction = {x: 0, y: 0};
      // @property [Array] _headPartCoord 矢印の頭部の座標
      this._headPartCoord = [];
      // @property [Array] _leftBodyPartCoord 矢印の体左部分の座標
      this._leftBodyPartCoord = [];
      // @property [Array] _rightBodyPartCoord 矢印の体右部分の座標
      this._rightBodyPartCoord = [];
      // @property [Int] header_width 矢印の頭の幅
      this.header_width = HEADER_WIDTH;
      // @property [Int] header_height 矢印の頭の長さ
      this.header_height = HEADER_HEIGHT;
      // @property [Int] padding_size CanvasのPadding
      this.padding_size = this.header_width;
      // @property [Array] drawCoodRegist 矢印のドラッグ座標(描画時のみ使用)
      // @private
      this._drawCoodRegist = [];
    }

    // アイテム描画
    // @param [Boolean] show 要素作成後に表示するか
    itemDraw(show) {
      if(show == null) {
        show = true;
      }
      super.itemDraw(show);
      // 座標をクリア
      _resetDrawPath.call(this);
      if(show) {
        // 座標を再計算
        for(let r of Array.from(this.registCoord)) {
          _drawPath.call(this, r);
        }
        // 描画
        return _drawNewCanvas.call(this);
      }
    }

    // 描画イベント ※アクションイベント
    changeDraw(opt) {
      const r = opt.progress / opt.progressMax;
      _resetDrawPath.call(this);
      this.restoreAllNewDrawingSurface();
      console.log(r);
      for(let reg of Array.from(this.registCoord.slice(0, parseInt(this.registCoord.length * r)))) {
        _drawPath.call(this, reg);
      }
      // 尾と体の座標をCanvasに描画
      return _drawNewCanvas.call(this);
    }

    // 色変更イベント ※アクションイベント
    changeColor(opt) {
    }

    // 描画(パス+線)
    // @param [Array] moveCood 画面ドラッグ座標
    draw(moveCood) {
      this.registCoord.push(moveCood);
      // 描画範囲の更新
      _updateArrowRect.call(this, moveCood);
      // パスの描画
      _drawPath.call(this, moveCood);
      // 描画した矢印をクリア
      this.restoreRefreshingSurface(this.itemSize);
      // 線の描画
      return _drawLine.call(this);
    }
  };
  PreloadItemArrow.initClass();
  return PreloadItemArrow;
})();

Common.setClassToMap(PreloadItemArrow.CLASS_DIST_TOKEN, PreloadItemArrow);

if((window.itemInitFuncList !== null) && (window.itemInitFuncList[PreloadItemArrow.CLASS_DIST_TOKEN] == null)) {
  if(window.debug) {
    console.log('arrow loaded');
  }
  window.itemInitFuncList[PreloadItemArrow.CLASS_DIST_TOKEN] = function(option) {
    if(option == null) {
      option = {};
    }
    if(window.isWorkTable && (PreloadItemArrow.jsLoaded !== null)) {
      PreloadItemArrow.jsLoaded(option);
    }
    //JS読み込み完了後の処理
    if(window.debug) {
      return console.log('arrow init Finish');
    }
  };
}
