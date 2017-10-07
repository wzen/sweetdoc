/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Handwrite {
  static initClass() {

    //@item = null
    this.drag = false;
    this.click = false;
    this.enableMoveEvent = true;
    this.queueLoc = null;
    this.zindex = null;
  }

  // 手書きイベント初期化
  static initHandwrite() {
    this.drag = false;
    this.click = false;
    window.handwritingItem = null;
    let lastX = null;
    let lastY = null;
    this.enableMoveEvent = true;
    this.queueLoc = null;
    const MOVE_FREQUENCY = 7;

    // ウィンドウ座標からCanvas座標に変換する
    // @param [Object] canvas Canvas
    // @param [Int] x x座標
    // @param [Int] y y座標
    const _windowToCanvas = function(canvas, x, y) {
      const bbox = canvas.getBoundingClientRect();
      return {x: x - (bbox.left * (canvas.width / bbox.width)), y: y - (bbox.top * (canvas.height / bbox.height))};
    };

    // 手書きイベントを設定
    return (() => {
      // 画面のウィンドウ座標からCanvas座標に変換
      // @param [Array] e ウィンドウ座標
      // @return [Array] Canvas座標
      let loc, x, y;
      const _calcCanvasLoc = e => {
        const worktableScale = WorktableCommon.getWorktableViewScale();
        x = (e.x || e.clientX) / worktableScale;
        y = (e.y || e.clientY) / worktableScale;
        return _windowToCanvas(drawingCanvas, x, y);
      };

      // 座標の状態を保存
      // @param [Array] loc 座標
      const _saveLastLoc = function(loc) {
        lastX = loc.x;
        return lastY = loc.y;
      };

      // マウスダウンイベント
      // @param [Array] e ウィンドウ座標
      drawingCanvas.onmousedown = e => {
        e.preventDefault();
        e.stopPropagation();
        if(this.drag && this.click) {
          // 描画に失敗した場合は一旦削除
          drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height);
          this.drag = false;
          this.click = false;
        }
        if(e.which === 1) { //左クリック
          this.zindex = constant.Zindex.EVENTBOTTOM + window.scrollInside.children().length + 1;
          loc = _calcCanvasLoc.call(this, e);
          _saveLastLoc(loc);
          this.click = true;
          if(this.isDrawMode(this)) {
            e.preventDefault();
            return this.mouseDownDrawing(loc);
          }
        }
      };

      // マウスドラッグイベント
      // @param [Array] e ウィンドウ座標
      drawingCanvas.onmousemove = e => {
        e.preventDefault();
        e.stopPropagation();
        if(e.which === 1) { //左クリック
          loc = _calcCanvasLoc.call(this, e);
          if(this.click &&
            ((Math.abs(loc.x - lastX) + Math.abs(loc.y - lastY)) >= MOVE_FREQUENCY)) {
            if(this.isDrawMode(this)) {
              e.preventDefault();
              this.mouseMoveDrawing(loc);
            }
            return _saveLastLoc(loc);
          }
        }
      };

      // マウスアップイベント
      // @param [Array] e ウィンドウ座標
      return drawingCanvas.onmouseup = e => {
        e.preventDefault();
        e.stopPropagation();
        if(e.which === 1) { //左クリック
          if(this.drag && this.isDrawMode(this)) {
            e.preventDefault();
            this.mouseUpDrawing();
          }
        }
        this.drag = false;
        return this.click = false;
      };
    })();
  }

  // マウスダウン時の描画イベント
  // @param [Array] loc Canvas座標
  static mouseDownDrawing(loc) {
    if(window.mode === constant.Mode.DRAW) {
      // 通常描画
      if(typeof selectItemMenu !== 'undefined' && selectItemMenu !== null) {
        // インスタンス作成
        window.handwritingItem = new (Common.getClassFromMap(selectItemMenu))(loc);
        window.instanceMap[window.handwritingItem.id] = window.handwritingItem;
        return window.handwritingItem.mouseDownDrawing();
      }
    }
  }

  // マウスドラッグ時の描画イベント
  // @param [Array] loc Canvas座標
  static mouseMoveDrawing(loc) {
    if(window.handwritingItem != null) {
      if(this.enableMoveEvent) {
        this.enableMoveEvent = false;
        this.drag = true;
        window.handwritingItem.draw(loc);

        // 待ちキューがある場合はもう一度実行
        if(this.queueLoc !== null) {
          const q = this.queueLoc;
          this.queueLoc = null;
          window.handwritingItem.draw(q);
        }

        return this.enableMoveEvent = true;
      } else {
        // 待ちキューに保存
        return this.queueLoc = loc;
      }
    }
  }

  // マウスアップ時の描画イベント
  static mouseUpDrawing() {
    if(window.handwritingItem != null) {
      return window.handwritingItem.mouseUpDrawing(this.zindex, () => {
        this.zindex += 1;
        return window.handwritingItem = null;
      });
    }
  }

  static isDrawMode() {
    return window.mode === constant.Mode.DRAW;
  }
}

Handwrite.initClass();
