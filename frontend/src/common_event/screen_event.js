import Common from '../base/common';
import CommonEvent from './common_event';

// 画面表示イベント
export default class ScreenEvent extends CommonEvent {
  static initClass() {
    this.instance = {};

    (function() {
      let _clearSpecificValue = undefined;
      let _overlay = undefined;
      let _setScaleAndUpdateViewing = undefined;
      let _getInitScale = undefined;
      const Cls = (this.PrivateClass = class PrivateClass extends CommonEvent.PrivateClass {
        static initClass() {
          this.EVENT_ID = '2';
          this.CLASS_DIST_TOKEN = "PI_ScreenEvent";

          this.actionProperties =
            {
              methods: {
                changeScreenPosition: {
                  options: {
                    id: 'changeScreenPosition',
                    name: 'Changing position',
                    ja: {
                      name: '表示位置変更'
                    }
                  },
                  specificValues: {
                    afterX: '',
                    afterY: '',
                    afterZ: ''
                  }
                }
              }
            };

          _clearSpecificValue = function(emt) {
            emt.find('.afterX:first').val('');
            emt.find('.afterY:first').val('');
            emt.find('.afterZ:first').val('');
            $('.clear_pointing:first', emt).hide();
            return EventDragPointingRect.clear();
          };

          _overlay = function(x, y, scale) {
            const _drawOverlay = function(context, x, y, width, height, scale) {
              const _rect = function(context, x, y, w, h) {
                context.moveTo(x, y);
                context.lineTo(x, y + h);
                context.lineTo(x + w, y + h);
                context.lineTo(x + w, y);
                return context.closePath();
              };

              context.save();
              context.fillStyle = "rgba(33, 33, 33, 0.5)";
              context.beginPath();
              context.rect(0, 0, width, height);
              // 枠を作成
              const wScale = WorktableCommon.getWorktableViewScale();
              const size = Common.convertCenterCoodToSize(x, y, wScale);
              const w = (size.width * wScale) / scale;
              const h = (size.height * wScale) / scale;
              const top = y - (h / 2.0);
              const left = x - (w / 2.0);
              context.clearRect(0, 0, width, height);
              _rect.call(this, context, left - window.scrollContents.scrollLeft(), top - window.scrollContents.scrollTop(), w, h);
              context.fill();
              return context.restore();
            };

            if(this._keepDispMag && (scale > WorktableCommon.getWorktableViewScale())) {
              let overlay = $('#preview_position_overlay');
              if((overlay === null) || (overlay.length === 0)) {
                // オーバーレイを被せる
                const w = $(window.drawingCanvas).attr('width');
                const h = $(window.drawingCanvas).attr('height');
                const canvas = $(`<canvas id='preview_position_overlay' class='canvas_container canvas' width='${w}' height='${h}' style='z-index: ${Common.plusPagingZindex(constant.Zindex.EVENTFLOAT) + 1}'></canvas>`);
                $(window.drawingCanvas).parent().append(canvas);
                overlay = $('#preview_position_overlay');
              }
              // オーバーレイ描画
              const canvasContext = overlay[0].getContext('2d');
              return _drawOverlay.call(this, canvasContext, x, y, overlay.width(), overlay.height(), scale);
            } else {
              // オーバーレイ削除
              return $('#preview_position_overlay').remove();
            }
          };

          _setScaleAndUpdateViewing = function(scale) {
            this._nowScreenEventScale = scale;
            this._notMoving = false;
            return Common.applyViewScale();
          };

          _getInitScale = function() {
            if(window.isWorkTable && !window.previewRunning) {
              return WorktableCommon.getWorktableViewScale();
            } else if(this.initConfigScale !== null) {
              return this.initConfigScale;
            } else {
              return 1.0;
            }
          };
        }

        getJQueryElement() {
          return window.mainWrapper;
        }

        constructor() {
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
          this.changeScreenPosition = this.changeScreenPosition.bind(this);
          super();
          this.name = 'Screen';
          this.initConfigX = null;
          this.initConfigY = null;
          this.initConfigScale = 1.0;
          this.eventBaseX = null;
          this.eventBaseY = null;
          this.eventBaseScale = null;
          this.previewLaunchBaseScale = null;
          this._notMoving = true;
          this._initDone = false;
        }

        // イベントの初期化
        // @param [Object] event 設定イベント
        initEvent(event, _keepDispMag) {
          if(_keepDispMag === null) {
            _keepDispMag = false;
          }
          this._keepDispMag = _keepDispMag;
          return super.initEvent(event);
        }

        initPreview() {
          this.previewLaunchBaseScale = this.eventBaseScale;
          if(this._notMoving) {
            this.previewLaunchBaseScale = _getInitScale.call(this);
            // 画面スクロール位置更新
            if(this.hasInitConfig()) {
              if(!this._keepDispMag) {
                Common.updateScrollContentsPosition(this.initConfigY, this.initConfigX, true, false);
              }
              this.eventBaseX = this.initConfigX;
              this.eventBaseY = this.initConfigY;
              return this.eventBaseScale = this.initConfigScale;
            }
          }
        }

        // 変更を戻して再表示
        refresh(show, callback = null) {
          if(show === null) {
            show = true;
          }
          const s = null;
          // 倍率を戻す
          if(window.isWorkTable && (!window.previewRunning || this._keepDispMag)) {
            this.resetNowScaleToWorktableScale();
            _setScaleAndUpdateViewing.call(this, WorktableCommon.getWorktableViewScale());
            if(!window.previewRunning) {
              this._notMoving = true;
            }
          } else if(this._notMoving) {
            // Run初期値で戻す
            _setScaleAndUpdateViewing.call(this, _getInitScale.call(this));
          } else {
            // イベント中の倍率
            _setScaleAndUpdateViewing.call(this, this.eventBaseScale);
          }
          // オーバーレイ削除
          $('#preview_position_overlay').remove();
          $('.keep_mag_base').remove();
          if(callback !== null) {
            return callback(this);
          }
        }

        // イベント前の表示状態にする
        updateEventBefore() {
          super.updateEventBefore();
          const methodName = this.getEventMethodName();
          if(methodName === 'changeScreenPosition') {
            if(!this._keepDispMag && (this.eventBaseScale !== null)) {
              _setScaleAndUpdateViewing.call(this, this.eventBaseScale);
              const size = Common.convertCenterCoodToSize(this.eventBaseX, this.eventBaseY, this.eventBaseScale);
              const scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
              return Common.updateScrollContentsPosition(size.top + (scrollContentsSize.height * 0.5), size.left + (scrollContentsSize.width * 0.5), true, false);
            }
          }
        }

        // イベント後の表示状態にする
        updateEventAfter() {
          super.updateEventAfter();
          const methodName = this.getEventMethodName();
          if(methodName === 'changeScreenPosition') {
            const p = Common.calcScrollTopLeftPosition(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterY, this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterX);
            this._progressX = parseFloat(p.left);
            this._progressY = parseFloat(p.top);
            this._progressScale = parseFloat(this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES].afterZ);
            if(this._keepDispMag) {
              _setScaleAndUpdateViewing.call(this, WorktableCommon.getWorktableViewScale());
              return _overlay.call(this, this._progressX, this._progressY, this._progressScale);
            } else {
              _setScaleAndUpdateViewing.call(this, this._progressScale);
              const size = Common.convertCenterCoodToSize(this._progressX, this._progressY, this._progressScale);
              const scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
              return Common.updateScrollContentsPosition(size.top + (scrollContentsSize.height * 0.5), size.left + (scrollContentsSize.width * 0.5), true, false);
            }
          }
        }

        // 画面移動イベント
        changeScreenPosition(opt) {
          this._progressScale = ((parseFloat(this._specificMethodValues.afterZ) - this.eventBaseScale) * (opt.progress / opt.progressMax)) + this.eventBaseScale;
          this._progressX = ((parseFloat(this._specificMethodValues.afterX) - this.eventBaseX) * (opt.progress / opt.progressMax)) + this.eventBaseX;
          this._progressY = ((parseFloat(this._specificMethodValues.afterY) - this.eventBaseY) * (opt.progress / opt.progressMax)) + this.eventBaseY;
          if(window.isWorkTable && opt.isPreview) {
            _overlay.call(this, this._progressX, this._progressY, this._progressScale);
            if(this._keepDispMag) {
              _setScaleAndUpdateViewing.call(this, WorktableCommon.getWorktableViewScale());
            }
          }
          if(!this._keepDispMag) {
            _setScaleAndUpdateViewing.call(this, this._progressScale);
            const size = Common.convertCenterCoodToSize(this._progressX, this._progressY, this._progressScale);
            const scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
            return Common.updateScrollContentsPosition(size.top + (scrollContentsSize.height * 0.5), size.left + (scrollContentsSize.width * 0.5), true, false);
          }
        }

        // プレビューを停止
        // @param [Function] callback コールバック
        stopPreview(callback = null) {
          setTimeout(() =>
              // オーバーレイを削除
              $('#preview_position_overlay').remove()

            , 0);
          return super.stopPreview(callback);
        }

        willChapter(callback = null) {
          if(window.previewRunning) {
            // 倍率を戻す
            this.eventBaseScale = this.previewLaunchBaseScale;
          } else {
            if(this._notMoving) {
              this.eventBaseScale = _getInitScale.call(this);
            }
          }
          return super.willChapter(callback);
        }

        didChapter(callback = null) {
          this.eventBaseX = this._progressX;
          this.eventBaseY = this._progressY;
          this.eventBaseScale = this._progressScale;
          this._progressScale = null;
          return super.didChapter(callback);
        }

        setMiniumObject(obj) {
          super.setMiniumObject(obj);
          if(!this._initDone) {
            if(!window.isWorkTable) {
              // スクロール位置設定
              Common.initScrollContentsPosition();
              _setScaleAndUpdateViewing.call(this, _getInitScale.call(this));
              this.eventBaseScale = _getInitScale.call(this);
              RunCommon.updateMainViewSize();
            } else {
              // スクロール位置更新
              WorktableCommon.initScrollContentsPosition();
              WorktableCommon.updateMainViewSize();
            }
            this._initDone = true;
            return this._notMoving = true;
          }
        }

        getNowScreenEventScale() {
          if((this._nowScreenEventScale === null)) {
            // 設定されていない場合は初期値を返す
            this._nowScreenEventScale = _getInitScale.call(this);
          }
          return this._nowScreenEventScale;
        }

        hasInitConfig() {
          return (this.initConfigX !== null) && (this.initConfigY !== null);
        }

        setInitConfig(x, y, scale) {
          this.initConfigX = x;
          this.initConfigY = y;
          this.initConfigScale = scale;
          this.eventBaseScale = this.initConfigScale;
          return this.setItemAllPropToPageValue();
        }

        clearInitConfig() {
          this.initConfigX = null;
          this.initConfigY = null;
          const s = 1.0;
          this.initConfigScale = s;
          this.eventBaseScale = s;
          return this.setItemAllPropToPageValue();
        }

        resetNowScaleToWorktableScale() {
          return this.eventBaseScale = WorktableCommon.getWorktableViewScale();
        }

        setEventBaseXAndY(x, y) {
          if(ScreenEvent.hasInstanceCache()) {
            const ins = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
            if(ins !== null) {
              ins.eventBaseX = x;
              ins.eventBaseY = y;
              PageValue.setInstancePageValue(PageValue.Key.instanceValue(this.id), ins);
            }
            this.eventBaseX = x;
            return this.eventBaseY = y;
          }
        }

        // 独自コンフィグのイベント初期化
        static initSpecificConfig(specificRoot) {
          const _updateConfigInput = function(emt, pointingSize) {
            const x = pointingSize.x + (pointingSize.w * 0.5);
            const y = pointingSize.y + (pointingSize.h * 0.5);
            let z = null;
            const screenSize = Common.getScreenSize();
            if(pointingSize.w > pointingSize.h) {
              z = screenSize.width / pointingSize.w;
            } else {
              z = screenSize.height / pointingSize.h;
            }
            emt.find('.afterX:first').val(x);
            emt.find('.afterY:first').val(y);
            emt.find('.afterZ:first').val(z);
            return $('.clear_pointing:first', emt).show();
          };

          const emt = specificRoot['changeScreenPosition'];
          const x = emt.find('.afterX:first');
          let xVal = null;
          let yVal = null;
          let zVal = null;
          let size = null;
          if(x.val().length > 0) {
            xVal = parseFloat(x.val());
          }
          const y = emt.find('.afterY:first');
          if(y.val().length > 0) {
            yVal = parseFloat(y.val());
          }
          const z = emt.find('.afterZ:first');
          if(z.val().length > 0) {
            zVal = parseFloat(z.val());
          }
          if((xVal !== null) && (yVal !== null) && (zVal !== null)) {
            const screenSize = Common.getScreenSize();
            const w = screenSize.width / zVal;
            const h = screenSize.height / zVal;
            size = {
              x: xVal - (w * 0.5),
              y: yVal - (h * 0.5),
              w,
              h
            };
            EventDragPointingRect.draw(size);
            $('.clear_pointing:first', emt).show();
          } else {
            EventDragPointingRect.clear();
            $('.clear_pointing:first', emt).hide();
          }
          emt.find('.event_pointing:first').eventDragPointingRect({
            applyDrawCallback: pointingSize => {
              return _updateConfigInput.call(this, emt, pointingSize);
            },
            closeCallback: () => {
              return EventDragPointingRect.draw(size);
            }
          });
          return emt.find('clear_pointing:first').off('click').on('click', e => {
            e.preventDefault();
            return _clearSpecificValue.call(this, emt);
          });
        }
      });
      Cls.initClass();
      return Cls;
    })();

    this.CLASS_DIST_TOKEN = this.PrivateClass.CLASS_DIST_TOKEN;
  }
}

ScreenEvent.initClass();

Common.setClassToMap(ScreenEvent.CLASS_DIST_TOKEN, ScreenEvent);
