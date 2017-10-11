/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// Canvasアイテム
// @abstract
// @extend ItemBase
class CanvasItemBase extends ItemBase {
  static initClass() {

    if(window.isWorkTable) {
      this.include(canvasItemBaseWorktableExtend);
    }
  }

  // コンストラクタ
  constructor() {
    super();
    this._newDrawingSurfaceImageData = null;
    this._newDrawedSurfaceImageData = null;
    // @property [Array] scale 表示倍率
    this.scale = {w: 1.0, h: 1.0};
  }

  // CanvasのHTML要素IDを取得
  // @return [Int] Canvas要素ID
  canvasElementId() {
    return this.id + '_canvas';
  }

  // アイテム用のテンプレートHTMLを読み込み
  // @return [String] HTML
  createItemElement(callback) {
    // 新規キャンパス存在チェック
    const canvas = document.getElementById(this.canvasElementId());
    if(canvas !== null) {
      // 存在している場合は追加しない
      callback();
      return;
    }

    const contents = `\
<canvas id="${this.canvasElementId()}" class="canvas context_base" ></canvas>\
`;
    return this.addContentsToScrollInside(contents, callback);
  }

  // 伸縮率を設定
  setScale() {
    // 要素の伸縮
    const element = $(`#${this.id}`);
    const canvas = $(`#${this.canvasElementId()}`);
    element.width(this.itemSize.w * this.scale.w);
    element.height(this.itemSize.h * this.scale.h);
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    // キャンパスの伸縮
    const context = canvas[0].getContext('2d');
    return context.scale(this.scale.w, this.scale.h);
  }

  // キャンパス初期化処理
  initCanvas() {
    // 伸縮率を設定
    return this.setScale();
  }

  // アイテム描画
  // @param [Boolean] show 要素作成後に表示するか
  itemDraw(show) {
    if(show === null) {
      show = true;
    }
    super.itemDraw(show);
    if(!show) {
      // 描画を削除
      this.removeItemElement();
    }
    // キャンパスに対する初期化
    this.initCanvas();
    // 空の画面状態を保存
    return this.saveNewDrawingSurface();
  }

  // 描画時のキャンパスの画面を保存
  saveNewDrawingSurface() {
    const canvas = document.getElementById(this.canvasElementId());
    if(canvas !== null) {
      const context = canvas.getContext('2d');
      return this._newDrawingSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height);
    }
  }

  // 描画済みの新規キャンパスの画面を保存
  saveNewDrawedSurface() {
    const canvas = document.getElementById(this.canvasElementId());
    if(canvas !== null) {
      const context = canvas.getContext('2d');
      return this._newDrawedSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height);
    }
  }

  // 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawingSurface() {
    if(this._newDrawingSurfaceImageData !== null) {
      const canvas = document.getElementById(this.canvasElementId());
      if(canvas !== null) {
        const context = canvas.getContext('2d');
        return context.putImageData(this._newDrawingSurfaceImageData, 0, 0);
      }
    }
  }

  // 保存した画面を新規キャンパスの全画面に再設定
  restoreAllNewDrawedSurface() {
    if(this._newDrawedSurfaceImageData) {
      const canvas = document.getElementById(this.canvasElementId());
      if(canvas !== null) {
        const context = canvas.getContext('2d');
        return context.putImageData(this._newDrawedSurfaceImageData, 0, 0);
      }
    }
  }

  // 描画を削除
  removeItemElement() {
    const canvas = document.getElementById(this.canvasElementId());
    if(canvas !== null) {
      const context = canvas.getContext('2d');
      context.clearRect(0, 0, canvas.width, canvas.height);
      // キャンパスに対する初期化
      return this.initCanvas();
    }
  }

  // アイテムサイズ更新
  updateItemSize(w, h) {
    const element = $(`#${this.id}`);
    element.css({width: w, height: h});
    const canvas = $(`#${this.canvasElementId()}`);
    const scaleW = element.width() / this.itemSize.w;
    const scaleH = element.height() / this.itemSize.h;
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    const drawingCanvas = document.getElementById(this.canvasElementId());
    const drawingContext = drawingCanvas.getContext('2d');
    drawingContext.scale(scaleW, scaleH);
    this.scale.w = scaleW;
    return this.scale.h = scaleH;
  }

  // アニメーション変更前のアイテムサイズ
  originalItemElementSize() {
    const obj = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceBefore(this._event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
    const {itemSize} = obj;
    const originalScale = obj.scale;
    return {
      x: itemSize.x,
      y: itemSize.y,
      w: itemSize.w * originalScale.w,
      h: itemSize.h * originalScale.h
    };
  }

  // CanvasにDesignToolの内容を反映
  applyDesignTool() {
    const drawingCanvas = document.getElementById(this.canvasElementId());
    const drawingContext = drawingCanvas.getContext('2d');

    (() => {
      // 背景色
      const halfSlopLength = Math.sqrt(Math.pow(drawingCanvas.width / 2.0, 2) + Math.pow(drawingCanvas.height / 2.0, 2));
      const deg = this.designs.values.design_slider_gradient_deg_value;
      //if window.debug
      //console.log("deg: #{deg}")
      const pi = (deg / 180.0) * Math.PI;
      const tanX = drawingCanvas.width * (Math.sin(pi) >= 0 ? Math.ceil(Math.sin(pi)) : Math.floor(Math.sin(pi)));
      const tanY = drawingCanvas.height * (Math.cos(pi) >= 0 ? Math.ceil(Math.cos(pi)) : Math.floor(Math.cos(pi)));
      const l1 = halfSlopLength * Math.cos((Math.abs(((Math.atan2(tanX, tanY) * 180.0) / Math.PI) - deg) / 180.0) * Math.PI);
      //if window.debug
      //console.log("l1: #{l1}")
      const centorCood = {x: drawingCanvas.width / 2.0, y: drawingCanvas.height / 2.0};
      const startX = centorCood.x + parseInt((l1 * Math.sin(pi)));
      const startY = centorCood.y - parseInt((l1 * Math.cos(pi)));
      const endX = centorCood.x + parseInt((l1 * Math.sin(pi + Math.PI)));
      const endY = centorCood.y - parseInt((l1 * Math.cos(pi + Math.PI)));
      //if window.debug
      //console.log("startX: #{startX}, startY: #{startY}, endX: #{endX}, endY: #{endY}")
      const gradient = drawingContext.createLinearGradient(startX, startY, endX, endY);
      gradient.addColorStop(0, `#${this.designs.values.design_bg_color1_value}`);
      if(this.designs.flags.design_bg_color2_flag) {
        gradient.addColorStop(this.designs.values.design_bg_color2_position_value / 100, `#${this.designs.values.design_bg_color2_value}`);
      }
      if(this.designs.flags.design_bg_color3_flag) {
        gradient.addColorStop(this.designs.values.design_bg_color3_position_value / 100, `#${this.designs.values.design_bg_color3_value}`);
      }
      if(this.designs.flags.design_bg_color4_flag) {
        gradient.addColorStop(this.designs.values.design_bg_color4_position_value / 100, `#${this.designs.values.design_bg_color4_value}`);
      }
      gradient.addColorStop(1, `#${this.designs.values.design_bg_color5_value}`);
      return drawingContext.fillStyle = gradient;
    })();

    (() => {
      // 影
      drawingContext.shadowColor = `rgba(${this.designs.values.design_shadow_color_value},${this.designs.values.design_slider_shadow_opacity_value})`;
      drawingContext.shadowOffsetX = this.designs.values.design_slider_shadow_left_value;
      drawingContext.shadowOffsetY = this.designs.values.design_slider_shadow_top_value;
      return drawingContext.shadowBlur = this.designs.values.design_slider_shadow_size_value;
    })();

    (() => {
      // 線
      drawingContext.strokeStyle = `#${this.designs.values.design_border_color_value}`;
      drawingContext.lineWidth = this.designs.values.design_slider_border_width_value;
      return drawingContext.miterLimit = this.designs.values.design_slider_border_radius_value;
    })();

    drawingContext.stroke();
    return drawingContext.fill();
  }
}

CanvasItemBase.initClass();