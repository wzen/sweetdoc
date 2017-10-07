/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
var EventDragPointingRect = (function() {
  let instance = undefined;
  EventDragPointingRect = class EventDragPointingRect {
    static initClass() {
      // SingleTon

      instance = null;

      const Cls = (this.PrivateClass = class PrivateClass extends CssItemBase {
        static initClass() {
          this.NAME_PREFIX = "EDPointingRect";
          this.CLASS_DIST_TOKEN = 'EDPointingRect';

          this.include(itemBaseWorktableExtend);
        }

        setApplyCallback(callback) {
          return this.applyCallback = callback;
        }

        clearDraw() {
          // アイテム削除
          return this.removeItemElement();
        }

        applyDraw() {
          if(this.applyCallback != null) {
            return this.applyCallback(this.itemSize);
          }
        }

        // マウスダウン時の描画イベント
        // @param [Array] loc Canvas座標
        mouseDownDrawing(callback = null) {
          // アイテム削除
          this.removeItemElement();
          this.saveDrawingSurface();
          if(callback != null) {
            return callback();
          }
        }

        // マウスアップ時の描画イベント
        mouseUpDrawing(zindex, callback = null) {
          this.restoreAllDrawingSurface();
          return this.endDraw(callback);
        }

        startCood(cood) {
          if(cood != null) {
            this._moveLoc = {x: cood.x, y: cood.y};
          }
          return this.itemSize = null;
        }

        // ドラッグ描画(枠)
        // @param [Array] cood 座標
        draw(cood) {
          if(this.itemSize !== null) {
            this.restoreRefreshingSurface(this.itemSize);
          }

          this.itemSize = {x: null, y: null, w: null, h: null};
          this.itemSize.w = Math.abs(cood.x - this._moveLoc.x);
          this.itemSize.h = Math.abs(cood.y - this._moveLoc.y);
          if(cood.x > this._moveLoc.x) {
            this.itemSize.x = this._moveLoc.x;
          } else {
            this.itemSize.x = cood.x;
          }
          if(cood.y > this._moveLoc.y) {
            this.itemSize.y = this._moveLoc.y;
          } else {
            this.itemSize.y = cood.y;
          }
          return drawingContext.strokeRect(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h);
        }

        endDraw(zindex, show, callback = null) {
          if(show == null) {
            show = true;
          }
          this.itemSize.x += scrollContents.scrollLeft();
          this.itemSize.y += scrollContents.scrollTop();
          this.zindex = Common.plusPagingZindex(constant.Zindex.EVENTFLOAT) + 1;

          return this.refresh(true, () => {
              this.getJQueryElement().addClass('drag_pointing');
              // コントローラ表示
              FloatView.showPointingController(this);
              if(callback != null) {
                return callback();
              }
            }
            , false);
        }

        // 以下の処理はなし
        saveObj(newCreated) {
          if(newCreated == null) {
            newCreated = false;
          }
        }

        getItemPropFromPageValue(prop, isCache) {
          if(isCache == null) {
            isCache = false;
          }
        }

        setItemPropToPageValue(prop, value, isCache) {
          if(isCache == null) {
            isCache = false;
          }
        }

        applyDefaultDesign() {
        }

        makeCss(forceUpdate) {
          if(forceUpdate == null) {
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
      if((instance == null)) {
        instance = new this.PrivateClass();
      }
      instance.startCood(cood);
      return instance;
    }

    static run(opt) {
      const {applyDrawCallback} = opt;
      const {closeCallback} = opt;
      let pointing = new (this)();
      pointing.setApplyCallback(pointingSize => {
        applyDrawCallback(pointingSize);
        Handwrite.initHandwrite();
        WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
        return EventDragPointingRect.draw(pointingSize);
      });
      PointingHandwrite.initHandwrite(this);
      WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.DRAW);
      FloatView.showWithCloseButton('Drag position', FloatView.Type.POINTING_DRAG, () => {
        if(closeCallback != null) {
          closeCallback();
        } else {
          // 画面上のポイントアイテムを削除
          pointing = new (this)();
          pointing.getJQueryElement().remove();
        }
        Handwrite.initHandwrite();
        return WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
      });
      return this.clear();
    }

    static draw(size) {
      if(size != null) {
        const pointing = new (this)();
        pointing.itemSize = size;
        pointing.zindex = Common.plusPagingZindex(constant.Zindex.EVENTFLOAT) + 1;
        return pointing.refresh(true, () => {
            return pointing.getJQueryElement().addClass('drag_pointing');
          }
          , false);
      }
    }

    static clear() {
      const pointing = new (this)();
      return pointing.clearDraw();
    }
  };
  EventDragPointingRect.initClass();
  return EventDragPointingRect;
})();

$.fn.eventDragPointingRect = function(opt, eventType) {
  if(eventType == null) {
    eventType = 'click';
  }
  if(eventType === 'click') {
    return $(this).off('click.event_pointing_rect').on('click.event_pointing_rect', e => {
      return EventDragPointingRect.run(opt);
    });
  }
};
