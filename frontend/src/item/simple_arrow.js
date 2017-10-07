/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS202: Simplify dynamic range loops
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// 矢印アイテム
// @extend ItemBase
var SimpleArrowItem = (function() {
  let ARROW_WIDTH = undefined;
  let ARROW_HALF_WIDTH = undefined;
  let HEADER_WIDTH = undefined;
  let HEADER_HEIGHT = undefined;
  let PADDING_SIZE = undefined;
  let coodLength = undefined;
  let calDrection = undefined;
  let calTrianglePath = undefined;
  let drawCoodToCanvas = undefined;
  let clearArrow = undefined;
  let updateArrowRect = undefined;
  let coodLog = undefined;
  SimpleArrowItem = class SimpleArrowItem extends ItemBase {
    static initClass() {
      this.NAME_PREFIX = "simplearrow";
      if(window.loadedClassDistToken != null) {
        this.CLASS_DIST_TOKEN = window.loadedClassDistToken;
      }

      // @property [Int] ARROW_WIDTH 矢印幅
      ARROW_WIDTH = 30;
      // @property [Int] ARROW_HALF_WIDTH 矢印幅(半分)
      ARROW_HALF_WIDTH = ARROW_WIDTH / 2.0;

      // @property [Int] HEADER_WIDTH 矢印の頭の幅
      HEADER_WIDTH = 50;
      // @property [Int] HEADER_HEIGHT 矢印の頭の長さ
      HEADER_HEIGHT = 50;
      // @property [Int] PADDING_SIZE 矢印サイズのPadding
      PADDING_SIZE = HEADER_WIDTH + 5;

      // 座標間の距離を計算する
      // @private
      coodLength = (locA, locB) =>
        // 整数にする
        parseInt(Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2)))
      ;
      //Math.sqrt(Math.pow(locA.x - locB.x, 2) + Math.pow(locA.y - locB.y, 2))

      // 進行方向を設定
      // @private
      calDrection = function(beforeLoc, cood) {
        let x, y;
        if((beforeLoc == null) || (cood == null)) {
          return;
        }

        if(beforeLoc.x < cood.x) {
          x = 1;
        } else if(beforeLoc.x === cood.x) {
          x = 0;
        } else {
          x = -1;
        }

        if(beforeLoc.y < cood.y) {
          y = 1;
        } else if(beforeLoc.y === cood.y) {
          y = 0;
        } else {
          y = -1;
        }

        //console.log('direction x:' + x + ' y:' + y)
        return this.direction = {x, y};
      };

      // 矢印の頭を作成
      // @private
      calTrianglePath = function() {
        if(this.registCoord.length < 4) {
          return null;
        }

        const lastBodyCood = this.registCoord[this.registCoord.length - 1];
        const r = {
          x: this.registCoord[this.registCoord.length - 4].x - lastBodyCood.x,
          y: this.registCoord[this.registCoord.length - 4].y - lastBodyCood.y
        };
        const sita = Math.atan2(r.y, r.x);
        const sitaLeft = sita - (Math.PI / 2.0);
        const leftTop = {
          x: (Math.cos(sitaLeft) * HEADER_WIDTH) + lastBodyCood.x,
          y: (Math.sin(sitaLeft) * HEADER_WIDTH) + lastBodyCood.y
        };
        const sitaRight = sita + (Math.PI / 2.0);
        const rightTop = {
          x: (Math.cos(sitaRight) * HEADER_WIDTH) + lastBodyCood.x,
          y: (Math.sin(sitaRight) * HEADER_WIDTH) + lastBodyCood.y
        };

        const sitaMid = sita + Math.PI;
        const top = {
          x: (Math.cos(sitaMid) * HEADER_HEIGHT) + lastBodyCood.x,
          y: (Math.sin(sitaMid) * HEADER_HEIGHT) + lastBodyCood.y
        };

        return this._headPartCoord = [rightTop, top, leftTop];
      };

      // 座標をCanvasに描画
      // @private
      drawCoodToCanvas = function(drawingContext) {
        let i;
        let asc, end;
        let asc1, end1;
        if(this.registCoord.length < 2) {
          // 描かれてない場合
          return;
        }
        drawingContext.beginPath();
        drawingContext.lineWidth = ARROW_WIDTH;
        drawingContext.strokeStyle = 'red';
        drawingContext.lineCap = 'round';
        drawingContext.lineJoin = 'round';
        drawingContext.moveTo(this.registCoord[0].x, this.registCoord[0].y);
        for(i = 1, end = this.registCoord.length - 1, asc = 1 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
          drawingContext.lineTo(this.registCoord[i].x, this.registCoord[i].y);
        }
        drawingContext.stroke();

        if(this._headPartCoord.length < 2) {
          return;
        }
        drawingContext.beginPath();
        drawingContext.fillStyle = 'red';
        drawingContext.lineWidth = 1.0;
        drawingContext.moveTo(this._headPartCoord[0].x, this._headPartCoord[0].y);
        for(i = 1, end1 = this._headPartCoord.length - 1, asc1 = 1 <= end1; asc1 ? i <= end1 : i >= end1; asc1 ? i++ : i--) {
          drawingContext.lineTo(this._headPartCoord[i].x, this._headPartCoord[i].y);
        }
        drawingContext.closePath();
        drawingContext.fill();
        return drawingContext.stroke();
      };

      // 描画した矢印をクリア
      // @private
      clearArrow = function() {
        // 保存したキャンパスを張り付け
        return this.restoreRefreshingSurface(this.itemSize);
      };

      // 矢印のサイズ更新
      // @private
      updateArrowRect = function(cood) {
        if(this.itemSize === null) {
          return this.itemSize = {x: cood.x, y: cood.y, w: 0, h: 0};
        } else {
          let minX = cood.x - PADDING_SIZE;
          minX = minX < 0 ? 0 : minX;
          let minY = cood.y - PADDING_SIZE;
          minY = minY < 0 ? 0 : minY;
          let maxX = cood.x + PADDING_SIZE;
          maxX = maxX > drawingCanvas.width ? drawingCanvas.width : maxX;
          let maxY = cood.y + PADDING_SIZE;
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

      // 座標のログを表示
      // @private
      coodLog = (cood, name) => console.log(name + 'X:' + cood.x + ' ' + name + 'Y:' + cood.y);
    }

    // コンストラクタ
    // @param [Array] cood 座標
    constructor(cood = null) {
      super(cood);
      // @property [Array] direction 矢印の進行方向
      this.direction = {x: 0, y: 0};
      // @property [Array] registCoord ドラッグした座標
      this.registCoord = [];
      // @property [Array] _headPartCoord 矢印の頭部の座標
      this._headPartCoord = [];
    }

    // CanvasのHTML要素IDを取得
    // @return [Int] Canvas要素ID
    canvasElementId() {
      return this.id + '_canvas';
    }

    // 描画
    // @param [Array] moveCood 画面ドラッグ座標
    draw(moveCood) {
      calDrection.call(this, this.registCoord[this.registCoord.length - 1], moveCood);

      if(this.registCoord.length >= 2) {
        const b = this.registCoord[this.registCoord.length - 2];
        const mid = {
          x: (b.x + moveCood.x) / 2.0,
          y: (b.y + moveCood.y) / 2.0
        };
        this.registCoord[this.registCoord - 1] = mid;
      }

      this.registCoord.push(moveCood);

      updateArrowRect.call(this, moveCood);

      // 描画した矢印をクリア
      clearArrow.call(this);

      // 頭の部分の座標を計算
      calTrianglePath.call(this);
      //console.log("@traceTriangelHeadIndex:" + @traceTriangelHeadIndex)

      // 座標をCanvasに描画
      return drawCoodToCanvas.call(this, window.drawingContext);
    }

    // 描画終了時に呼ばれるメソッド
    // @param [Array] cood 座標
    // @param [Int] zindex z-index
    // @param [boolean] show 要素作成後に描画を表示するか
    endDraw(zindex, show, callback = null) {
      if(show == null) {
        show = true;
      }
      if(!super.endDraw(zindex)) {
        if(callback != null) {
          callback();
        }
        return false;
      }

      // 新しいCanvasに合わせるためにrect分座標を引く
      for(var l of Array.from(this.registCoord)) {
        l.x -= this.itemSize.x;
        l.y -= this.itemSize.y;
      }
      for(l of Array.from(this._headPartCoord)) {
        l.x -= this.itemSize.x;
        l.y -= this.itemSize.y;
      }

      this.drawAndMakeConfigs(show);
      if(callback != null) {
        callback();
      }
      return true;
    }

    // 再描画処理
    // @param [boolean] show 要素作成後に描画を表示するか
    refresh(show) {
      if(show == null) {
        show = true;
      }
      return this.drawAndMakeConfigs(show);
    }

    // CanvasのHTML要素を作成
    // @param [Array] cood 座標
    // @param [boolean] show 要素作成後に描画を表示するか
    // @return [Boolean] 処理結果
    drawAndMakeConfigs(show) {

      // Canvasを作成
      //$(ElementCode.get().createItemElement(@)).appendTo(window.scrollInside)
      if(show == null) {
        show = true;
      }
      $(`#${this.canvasElementId()}`).attr('width', $(`#${this.id}`).width());
      $(`#${this.canvasElementId()}`).attr('height', $(`#${this.id}`).height());
      this.setupItemEvents();

      if(show) {
        // 新しいCanvasに描画
        const drawingCanvas = document.getElementById(this.canvasElementId());
        const drawingContext = drawingCanvas.getContext('2d');
        return drawCoodToCanvas.call(this, drawingContext);
      }
    }

    // ストレージとDB保存用の最小限のデータを取得
    // @return [Array] アイテムオブジェクトの最小限データ
    getMinimumObject() {
      const obj = {
        classDistToken: this.constructor.CLASS_DIST_TOKEN,
        a: this.itemSize,
        b: this.zindex,
        c: this.registCoord,
        d: this._headPartCoord
      };
      return obj;
    }
  };
  SimpleArrowItem.initClass();
  return SimpleArrowItem;
})();
