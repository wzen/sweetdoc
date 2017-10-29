import FloatView from '../../../../base/float_view';
import CssItemBase from '../../../item/css_item_base';
import Handwrite from '../../handwrite/handwrite';
import PointingHandwrite from '../../handwrite/pointing_handwrite';
import WorktableCommon from '../../common/worktable_common';

let instance = undefined;
export default class EventDragPointingDraw {
  static initClass() {
    // SingleTon

    instance = null;

    const Cls = (this.PrivateClass = class PrivateClass extends CssItemBase {
      static initClass() {
        this.NAME_PREFIX = "EDPointingDraw";
        this.CLASS_DIST_TOKEN = 'EDPointingDraw';

        this.include(itemBaseWorktableExtend);
      }

      setApplyCallback(callback) {
        return this.applyCallback = callback;
      }

      setEndDrawCallback(callback) {
        return this.endDrawCallback = callback;
      }

      clearDraw() {
        // アイテム削除
        drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height);
        this.drawPaths = [];
        return this.drawPathIndex = 0;
      }

      applyDraw() {
        // アイテム削除
        drawingContext.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height);
        if(this.applyCallback !== null) {
          return this.applyCallback(this.drawPaths);
        }
      }

      initData(multiDraw) {
        this.multiDraw = multiDraw;
        this.drawPaths = [];
        return this.drawPathIndex = 0;
      }

      // マウスダウン時の描画イベント
      // @param [Array] loc Canvas座標
      mouseDownDrawing(callback = null) {
        //@saveDrawingSurface()
        if(callback !== null) {
          return callback();
        }
      }

      // マウスアップ時の描画イベント
      mouseUpDrawing(zindex, callback = null) {
        //@restoreAllDrawingSurface()
        return this.endDraw(callback);
      }

      startCood(cood) {
        if(cood !== null) {
          this._moveLoc = {x: cood.x, y: cood.y};
        }
        if(this.multiDraw && (this.drawPaths.length > 0)) {
          this.drawPathIndex += 1;
        } else {
          this.drawPaths = [];
          this.drawPathIndex = 0;
        }
        this.drawPaths[this.drawPathIndex] = [];
        return this.itemSize = null;
      }

      // ドラッグ描画(線)
      // @param [Array] cood 座標
      draw(cood) {
        this.drawPaths[this.drawPathIndex].push(cood);

        return (() => {
          const result = [];
          for(let d of Array.from(this.drawPaths)) {
            drawingContext.beginPath();
            for(let idx = 0; idx < d.length; idx++) {
              const p = d[idx];
              if(idx === 0) {
                drawingContext.moveTo(p.x, p.y);
              } else {
                drawingContext.lineTo(p.x, p.y);
              }
            }
            result.push(drawingContext.stroke());
          }
          return result;
        })();
      }

      endDraw(zindex, show, callback = null) {
        if(show === null) {
          show = true;
        }
        if(this.endDrawCallback !== null) {
          this.endDrawCallback(this.drawPaths);
        }
        // コントローラ表示
        FloatView.showPointingController(this);
        if(callback !== null) {
          return callback();
        }
      }

      // 以下の処理はなし
      saveObj(newCreated) {
        if(newCreated === null) {
          newCreated = false;
        }
      }

      getItemPropFromPageValue(prop, isCache) {
        if(isCache === null) {
          isCache = false;
        }
      }

      setItemPropToPageValue(prop, value, isCache) {
        if(isCache === null) {
          isCache = false;
        }
      }

      applyDefaultDesign() {
      }

      makeCss(forceUpdate) {
        if(forceUpdate === null) {
          forceUpdate = false;
        }
      }
    });
    Cls.initClass();
  }

  constructor(cood = null) {
    return this.constructor.getInstance(cood);
  }

  static getInstance(cood = null) {
    if((instance === null)) {
      instance = new this.PrivateClass();
    }
    instance.startCood(cood);
    return instance;
  }

  static run(opt) {
    const {endDrawCallback} = opt;
    const {applyDrawCallback} = opt;
    let {multiDraw} = opt;
    if((multiDraw === null)) {
      multiDraw = false;
    }
    let pointing = new (this)();
    pointing.setApplyCallback(pointingPaths => {
      const _cb = () => {
        pointing = new (this)();
        pointing.getJQueryElement().remove();
        Handwrite.initHandwrite();
        return WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
      };
      if(applyDrawCallback !== null) {
        if(applyDrawCallback(pointingPaths)) {
          return _cb.call(this);
        }
      } else {
        return _cb.call(this);
      }
    });
    pointing.setEndDrawCallback(pointingPaths => {
      if(endDrawCallback !== null) {
        return endDrawCallback(pointingPaths);
      }
    });
    pointing.initData(multiDraw);
    PointingHandwrite.initHandwrite(this);
    WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.DRAW);
    return FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, () => {
      // 画面上のポイントアイテムを削除
      pointing = new (this)();
      pointing.getJQueryElement().remove();
      Handwrite.initHandwrite();
      return WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
    });
  }
};
EventDragPointingDraw.initClass();

$.fn.eventDragPointingDraw = function(opt, eventType) {
  if(eventType === null) {
    eventType = 'click';
  }
  if(eventType === 'click') {
    return $(this).off('click.event_pointing_draw').on('click.event_pointing_draw', e => {
      return EventDragPointingDraw.run(opt);
    });
  } else if(eventType === 'change') {
    return $(this).off('change.event_pointing_draw').on('change.event_pointing_draw', e => {
      if($(e.target).val === opt.targetValue) {
        return EventDragPointingDraw.run(opt);
      }
    });
  }
};