/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// イベントリスナー Extend
var EventBase = (function() {
  let constant = undefined;
  EventBase = class EventBase extends Extend {
    static initClass() {
      // @abstract
      // @property [String] CLASS_DIST_TOKEN クラス種別
      this.CLASS_DIST_TOKEN = "";
      this.STEP_INTERVAL_DURATION = 0.01;

      constant = gon.const;
      this.BEFORE_MODIFY_VAR_SUFFIX = constant.BEFORE_MODIFY_VAR_SUFFIX;
      this.AFTER_MODIFY_VAR_SUFFIX = constant.AFTER_MODIFY_VAR_SUFFIX;
      const Cls = (this.ActionPropertiesKey = class ActionPropertiesKey {
        static initClass() {
          this.TYPE = constant.ItemActionPropertiesKey.TYPE;
          this.METHODS = constant.ItemActionPropertiesKey.METHODS;
          this.DEFAULT_EVENT = constant.ItemActionPropertiesKey.DEFAULT_EVENT;
          this.METHOD = constant.ItemActionPropertiesKey.METHOD;
          this.DEFAULT_METHOD = constant.ItemActionPropertiesKey.DEFAULT_METHOD;
          this.ACTION_TYPE = constant.ItemActionPropertiesKey.ACTION_TYPE;
          this.COLOR_TYPE = constant.ItemActionPropertiesKey.COLOR_TYPE;
          this.SPECIFIC_METHOD_VALUES = constant.ItemActionPropertiesKey.SPECIFIC_METHOD_VALUES;
          this.SCROLL_ENABLED_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_ENABLED_DIRECTION;
          this.SCROLL_FORWARD_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_FORWARD_DIRECTION;
          this.OPTIONS = constant.ItemActionPropertiesKey.OPTIONS;
          this.EVENT_DURATION = constant.ItemActionPropertiesKey.EVENT_DURATION;
          this.MODIFIABLE_VARS = constant.ItemActionPropertiesKey.MODIFIABLE_VARS;
          this.MODIFIABLE_CHILDREN = constant.ItemActionPropertiesKey.MODIFIABLE_CHILDREN;
          this.MODIFIABLE_CHILDREN_OPENVALUE = constant.ItemActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE;
          this.FINISH_WITH_HAND = constant.ItemActionPropertiesKey.FINISH_WITH_HAND;
        }
      });
      Cls.initClass();
    }

    constructor() {
      // modifiables変数の初期化
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
      if((this.constructor.actionProperties != null) && (this.constructor.actionPropertiesModifiableVars() != null)) {
        const object = this.constructor.actionPropertiesModifiableVars();
        for(let varName in object) {
          const value = object[varName];
          this[varName] = value.default;
        }
      }
    }

    // ⇣ コンフィグから変更するわけでないので
    //@changeInstanceVarByConfig(varName, value.default)

    // インスタンス値セッター
    changeInstanceVarByConfig(varName, value) {
      this[varName] = value;
      return this.clearAllCache();
    }

    // 変更を戻して再表示
    // @abstract
    refresh(show, callback = null) {
      if(show == null) {
        show = true;
      }
      if(callback != null) {
        return callback();
      }
    }

    // 現在の表示状態
    isItemVisible() {
      const op = this.getJQueryElement().css('opacity');
      if(op.length > 0) {
        return parseInt(op) === 1;
      }
      return true;
    }

    // インスタンス変数で描画
    // データから読み込んで描画する処理に使用
    // @param [Boolean] show 要素作成後に表示するか
    refreshFromInstancePageValue(show, callback = null) {
      if(show == null) {
        show = true;
      }
      if(window.runDebug) {
        console.log(`EventBase refreshWithEventBefore id:${this.id}`);
      }

      // インスタンス値初期化
      const obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id));
      if(obj) {
        this.setMiniumObject(obj);
      }
      return this.refresh(show, callback);
    }

    // イベントの初期化
    // @param [Object] event 設定イベント
    initEvent(event) {
      this._event = event;
      this._isFinishedEvent = false;
      this._skipEvent = true;
      this._runningEvent = false;
      this._isScrollHeader = true;
      this._doPreviewLoop = false;
      this._handlerFuncComplete = null;
      this._enabledDirections = this._event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS];
      this._forwardDirections = this._event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS];
      return this._specificMethodValues = this._event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES];
    }

    // スクロールイベント
    scrollEvent(x, y, complete = null) {
      if((this._handlerFuncComplete == null)) {
        this._handlerFuncComplete = complete;
      }
      return this.scrollHandlerFunc(false, x, y);
    }

    // クリックイベント
    clickEvent(e, complete = null) {
      if((this._handlerFuncComplete == null)) {
        this._handlerFuncComplete = complete;
      }
      return this.clickHandlerFunc(false, e);
    }

    // 設定されているイベントメソッド名を取得
    // @return [String] メソッド名
    getEventMethodName() {
      if(this._event != null) {
        const methodName = this._event[EventPageValueBase.PageValueKey.METHODNAME];
        if(methodName != null) {
          return methodName;
        } else {
          return EventPageValueBase.NO_METHOD;
        }
      } else {
        return EventPageValueBase.NO_METHOD;
      }
    }

    // 設定されているイベントアクションタイプを取得
    // @return [Integer] アクションタイプ
    getEventActionType() {
      if(this._event != null) {
        return this._event[EventPageValueBase.PageValueKey.ACTIONTYPE];
      }
    }

    // 変更設定されているフォーク番号を取得
    // @return [Integer] フォーク番号
    getChangeForkNum() {
      if(this._event != null) {
        const num = this._event[EventPageValueBase.PageValueKey.CHANGE_FORKNUM];
        if(num != null) {
          return parseInt(num);
        } else {
          // forkNumが無い場合はNULL
          return null;
        }
      } else {
        return null;
      }
    }

    // プレビュー実行前の処理があれば記入
    // @abstract
    initPreview() {
    }

    // プレビュー開始
    preview(loopFinishCallback = null) {
      this.loopFinishCallback = loopFinishCallback;
      if(window.runDebug) {
        console.log(`EventBase preview id:${this.id}`);
      }
      return this.stopPreview(() => {
        this._runningPreview = true;
        this.initPreview();
        return this.willChapter(() => {
          this._doPreviewLoop = false;
          this._skipEvent = false;
          this._loopCount = 0;
          this._previewTimer = null;
          this._runningEvent = false;
          // FloatView表示
          FloatView.showWithCloseButton(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW, () => {
              if(this.loopFinishCallback != null) {
                return this.loopFinishCallback();
              }
            }
            , true);
          this._progress = 0;
          if(window.debug) {
            console.log('start previewStepDraw');
          }
          return this.previewStepDraw();
        });
      });
    }

    // プレビューStep実行
    previewStepDraw() {
      // イベントハンドリング有効時のみ
      if(!this._skipEvent) {
        this._stepLoopCount = 0;

        if(this.getEventActionType() === constant.ActionType.SCROLL) {
          if(this._previewTimer != null) {
            clearTimeout(this._previewTimer);
            this._previewTimer = null;
          }
          return this._previewTimer = setTimeout(() => {
              if((this._progress + Constant.EventBase.PREVIEW_STEP) > this.progressMax()) {
                this._doPreviewLoop = false;
                clearTimeout(this._previewTimer);
                this._previewTimer = null;
              }

              this.scrollHandlerFunc(true);
              if((this._progress + Constant.EventBase.PREVIEW_STEP) > this.progressMax()) {
                if(!this.isFinishedWithHand()) {
                  return this.finishEvent();
                }
              } else {
                this._progress += Constant.EventBase.PREVIEW_STEP;
                if(this._progress > this.progressMax()) {
                  this._progress = this.progressMax();
                }
                return this.previewStepDraw();
              }
            }
            , this.constructor.STEP_INTERVAL_DURATION * 1000);
        } else if(this.getEventActionType() === constant.ActionType.CLICK) {
          this.clickHandlerFunc(true);
          return this._doPreviewLoop = false;
        }
      } else if(!this._isFinishedEvent && ((this._stepLoopCount == null) || (this._stepLoopCount < 20))) {
        if((this._stepLoopCount == null)) {
          this._stepLoopCount = 0;
        }
        return setTimeout(() => {
            // 0.3秒毎に再実行
            this._stepLoopCount += 1;
            return this.previewStepDraw();
          }
          , 300);
      }
    }

    // プレビュー実行ループ
    previewLoop() {
      if(this._doPreviewLoop) {
        // 二重実行はしない
        return;
      }

      const loopDelay = 1000; // 1秒毎イベント実行
      const loopMaxCount = 3; // ループ2回(全部で3回実行)
      this._doPreviewLoop = true;
      this._loopCount += 1;
      if(window.debug) {
        console.log(`_loopCount:${this._loopCount}`);
      }
      if(this._loopCount >= loopMaxCount) {
        this.stopPreview();
        if(this.loopFinishCallback != null) {
          this.loopFinishCallback();
          this.loopFinishCallback = null;
        }
      }
      if(this._previewTimer != null) {
        clearTimeout(this._previewTimer);
        this._previewTimer = null;
      }
      return this._previewTimer = setTimeout(() => {
          if(this._runningPreview) {
            this.updateEventBefore();
            return this.refresh(this.visible, () => {
              return this.willChapter(() => {
                this._progress = 0;
                return this.previewStepDraw();
              });
            });
          }
        }
        , loopDelay);
    }

    // プレビューを停止
    // @param [Function] callback コールバック
    stopPreview(callback = null) {
      if(window.runDebug) {
        console.log(`EventBase stopPreview id:${this.id}`);
      }

      if((this._runningPreview == null) || !this._runningPreview) {
        // 停止済み
        if(callback != null) {
          callback(false);
        }
        return;
      }
      this._runningPreview = false;

      if(this._previewTimer != null) {
        clearTimeout(this._previewTimer);
        FloatView.hide();
        this._previewTimer = null;
      }
      if(this._clickIntervalTimer != null) {
        clearInterval(this._clickIntervalTimer);
        this._clickIntervalTimer = null;
      }
      if(callback != null) {
        return callback(true);
      }
    }

    // アイテムのJQueryエレメントを取得
    // @abstract
    getJQueryElement() {
      return null;
    }

    // アイテムのクリック対象を取得
    clickTargetElement() {
      return this.getJQueryElement();
    }

    saveCache(key, value) {
      if((this['__saveCache'] == null)) {
        this['__saveCache'] = {};
      }
      if($.isArray(key)) {
        key = key.join('__');
      }
      this['__saveCache'][key + ''] = value;
      return true;
    }

    loadCache(key) {
      if((this['__saveCache'] == null)) {
        return null;
      }
      if($.isArray(key)) {
        key = key.join('__');
      }
      return this['__saveCache'][key + ''];
    }

    clearAllCache() {
      if(this['__saveCache'] != null) {
        return delete this['__saveCache'];
      }
    }

    // チャプター開始前イベント
    willChapter(callback = null) {
      // インスタンスの状態を保存
      this.saveToFootprint(this.id, true, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
      // イベント前後の変数の設定
      this.setModifyBeforeAndAfterVar();
      // ステータス値初期化
      this.resetProgress();
      if(callback != null) {
        return callback();
      }
    }

    // チャプター終了時イベント
    didChapter(callback = null) {
      // キャッシュ用の「__Cache」と付くインスタンス変数を削除
      for(let k in this) {
        const v = this[k];
        if(k.lastIndexOf('__Cache') >= 0) {
          delete this[k];
        }
      }
      // インスタンスの状態を保存
      this.saveToFootprint(this.id, false, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
      if(callback != null) {
        return callback();
      }
    }

    // メソッド実行
    execMethod(opt, callback = null) {
      // メソッド共通処理
      // アイテム位置&サイズ更新
      this.updateInstanceParamByStep(opt.progress);
      if(callback != null) {
        return callback();
      }
    }

    // スクロール基底メソッド
    // @param [Integer] x スクロール横座標
    // @param [Integer] y スクロール縦座標
    scrollHandlerFunc(isPreview, x, y) {
      if(isPreview == null) {
        isPreview = false;
      }
      if(x == null) {
        x = 0;
      }
      if(y == null) {
        y = 0;
      }
      if(this._skipEvent || (!isPreview && window.eventAction.thisPage().thisChapter().isFinishedAllEvent(true))) {
        // 全イベント終了済みorイベントを反応させない場合はスキップ
        return;
      }
      if(isPreview) {
        // プレビュー時は1ずつ実行
        this.stepValue += Constant.EventBase.PREVIEW_STEP;
        // 進行方向は+
        this.forward = true;
      } else {
        // スクロール値更新
        //if window.debug
        //console.log("y:#{y}")
        let plusX = 0;
        let plusY = 0;
        if((x > 0) && this._enabledDirections.right) {
          plusX = parseInt((x + 9) / 10);
        } else if((x < 0) && this._enabledDirections.left) {
          plusX = parseInt((x - 9) / 10);
        }
        if((y > 0) && this._enabledDirections.bottom) {
          plusY = parseInt((y + 9) / 10);
        } else if((y < 0) && this._enabledDirections.top) {
          plusY = parseInt((y - 9) / 10);
        }

        if(((plusX > 0) && !this._forwardDirections.right) ||
          ((plusX < 0) && this._forwardDirections.left)) {
          plusX = -plusX;
        }
        if(((plusY > 0) && !this._forwardDirections.bottom) ||
          ((plusY < 0) && this._forwardDirections.top)) {
          plusY = -plusY;
        }

        // FIXME: -webkit-overflow-scrollingは現状使用しない
        //if !isIosAccess || window.scrollHandleWrapper.hasClass('disable_inertial_scroll')
        // 「-webkit-overflow-scrolling: touch;」が効かないor無効の場合、調整
        this.stepValue += parseInt((plusX + plusY) * 3.5);
        //      else
        //        @stepValue += plusX + plusY
        this.forward = (plusX + plusY) >= 0;

        if(this._isFinishedEvent) {
          if(!this.forward) {
            // 終了状態で戻した場合はOFFに戻す
            this._isFinishedEvent = false;
            if(!isPreview) {
              // 終了判定のキャッシュを更新するために一度実行
              window.eventAction.thisPage().thisChapter().isFinishedAllEvent(false);
            }
          } else {
            // イベント終了 & 進行 -> 処理なし
            return;
          }
        }
      }

      const sPoint = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
      const ePoint = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) + 1;
      // スクロール指定範囲外なら反応させない
      if((this.stepValue < sPoint) && !isPreview) {
        if(this.stepValue < 0) {
          if(!this._runningEvent) {
            // チャプター戻しガイド表示
            const page = window.eventAction.thisPage();
            const chapter = page.thisChapter();
            if((window.eventAction.pageIndex > 0) || (page.getChapterIndex() > 0)) {
              chapter.showRewindOperationGuide(this, -this.stepValue);
            }
          }
          this.stepValue = 0;
          this._runningEvent = false;
        }
        if(!this._isScrollHeader) {
          // イベント頭で一回実行
          this.execMethod({
            isPreview,
            progress: 0,
            progressMax: this.progressMax(),
            forward: this.forward
          });
          this._isScrollHeader = true;
        }
        return;
      } else if(this.stepValue >= ePoint) {
        this._runningEvent = true;
        this._isScrollHeader = false;
        // 動作済みフラグON
        if(!isPreview) {
          window.eventAction.thisPage().thisChapter().doMoveChapter = true;
        }
        if(!this._isFinishedEvent) {
          // 終了時に最終ステップで実行
          this.execMethod({
            isPreview,
            progress: this.progressMax(),
            progressMax: this.progressMax(),
            forward: this.forward
          }, () => {
            if(!this.isFinishedWithHand()) {
              // 終了イベント
              this.finishEvent();
            }
            if(!isPreview) {
              return ScrollGuide.hideGuide();
            }
          });
        }
        return;
      }

      this._runningEvent = true;
      this._isScrollHeader = false;
      // 動作済みフラグON
      if(!isPreview) {
        window.eventAction.thisPage().thisChapter().doMoveChapter = true;
        window.eventAction.thisPage().thisChapter().hideRewindOperationGuide(this);
      }
      this.canForward = this.stepValue < ePoint;
      this.canReverse = this.stepValue > sPoint;

      // ステップ実行
      return this.execMethod({
        isPreview,
        progress: this.stepValue - sPoint,
        progressMax: this.progressMax(),
        forward: this.forward
      });
    }

    // スクロールの長さを取得
    // @return [Integer] スクロール長さ
    scrollLength() {
      return parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
    }

    // クリック基底メソッド
    // @param [Object] e クリックオブジェクト
    clickHandlerFunc(isPreview, e = null) {
      if(isPreview == null) {
        isPreview = false;
      }
      if(e != null) {
        e.preventDefault();
      }

      if(this._isFinishedEvent || this._skipEvent || this._runningEvent) {
        // 終了済みorイベントを反応させない場合
        return;
      }

      // クリックイベントは一回のみ実行
      this._runningEvent = true;

      // 動作済みフラグON
      if(window.eventAction != null) {
        window.eventAction.thisPage().thisChapter().doMoveChapter = true;
      }

      // ステップ実行
      const progressMax = this.progressMax();
      this.stepValue = 0;
      return this._clickIntervalTimer = setInterval(() => {
          if(!this._skipEvent) {
            return this.execMethod({
              isPreview,
              progress: this.stepValue,
              progressMax,
              forward: true
            }, () => {
              this.stepValue += 1;
              if(progressMax < this.stepValue) {
                clearInterval(this._clickIntervalTimer);
                if(!this.isFinishedWithHand()) {
                  // 終了イベント
                  return this.finishEvent();
                }
              }
            });
          }
        }
        , this.constructor.STEP_INTERVAL_DURATION * 1000);
    }

    // Step値を戻す
    resetProgress(withResetFinishedEventFlg) {
      if(withResetFinishedEventFlg == null) {
        withResetFinishedEventFlg = true;
      }
      this.stepValue = 0;
      this._skipEvent = false;
      this._runningEvent = false;
      if(withResetFinishedEventFlg) {
        return this._isFinishedEvent = false;
      }
    }

    // UIの反応を有効にする
    enableHandleResponse() {
      return this._skipEvent = false;
    }

    // UIの反応を無効にする
    disableHandleResponse() {
      return this._skipEvent = true;
    }

    // イベントを終了する
    finishEvent() {
      if(this._isFinishedEvent) {
        // 二重でコールしない
        return;
      }
      this._isFinishedEvent = true;
      if(this._clickIntervalTimer != null) {
        clearInterval(this._clickIntervalTimer);
        this._clickIntervalTimer = null;
      }
      if(this._runningPreview) {
        return this.previewLoop();
      } else {
        if(window.eventAction != null) {
          if(this._event[EventPageValueBase.PageValueKey.FINISH_PAGE]) {
            // このイベント終了時にページ遷移する場合
            if(this._event[EventPageValueBase.PageValueKey.JUMPPAGE_NUM] !== EventPageValueBase.NO_JUMPPAGE) {
              // 指定ページに遷移
              return window.eventAction.thisPage().finishAllChapters(this._event[EventPageValueBase.PageValueKey.JUMPPAGE_NUM] - 1);
            } else {
              // 全ページ終了
              return window.eventAction.finishAllPages();
            }
          } else {
            if(this._handlerFuncComplete != null) {
              this._handlerFuncComplete();
              return this._handlerFuncComplete = null;
            }
          }
        }
      }
    }

    // イベント前のインスタンスオブジェクトを取得
    getMinimumObjectEventBefore() {
      return PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceBefore(this._event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
    }

    // イベント前の表示状態にする
    updateEventBefore() {
      if((this._event == null)) {
        // イベントが初期化されていない場合は無視
        return;
      }
      if(window.runDebug) {
        console.log(`EventBase updateEventBefore id:${this.id}`);
      }
      // インスタンスを戻す
      this.setMiniumObject(this.getMinimumObjectEventBefore());
      if(this._event[EventPageValueBase.PageValueKey.DO_FOCUS] && (this instanceof ScreenEvent.PrivateClass === false)) {
        // フォーカスを戻す
        Common.focusToTarget(this.getJQueryElement(), null, true);
      }
      return this.resetProgress();
    }

    // イベント後の表示状態にする
    updateEventAfter() {
      if((this._event == null)) {
        // イベントが初期化されていない場合は無視
        return;
      }
      if(window.runDebug) {
        console.log(`EventBase updateEventAfter id:${this.id}`);
      }
      const actionType = this.getEventActionType();
      if(actionType === constant.ActionType.SCROLL) {
        this.stepValue = this.scrollLength();
      }
      this.updateInstanceParamByStep(null, true);
      // インスタンスの状態を保存
      return this.saveToFootprint(this.id, false, this._event[EventPageValueBase.PageValueKey.DIST_ID]);
    }

    // 最終ステップでメソッドを実行
    execLastStep(callback = null) {
      const progressMax = this.progressMax();
      return this.execMethod({
        isPreview: false,
        progress: progressMax,
        progressMax,
        forward: true
      }, callback);
    }

    // ステップ実行によるアイテム状態更新
    updateInstanceParamByStep(progressValue, immediate) {
      if(immediate == null) {
        immediate = false;
      }
      if(this.getEventMethodName() === EventPageValueBase.NO_METHOD) {
        return;
      }

      let progressMax = this.progressMax();
      if((progressMax == null)) {
        progressMax = 1;
      }
      // NOTICE: varAutoChange=falseの場合は(変数)_xxxの形で変更前、変更後、進捗を渡してdraw側で処理させる
      const progressPercentage = progressValue / progressMax;
      const eventBeforeObj = this.getMinimumObjectEventBefore();
      const mod = this.constructor.actionPropertiesModifiableVars(this.getEventMethodName());
      return (() => {
        const result = [];
        for(let varName in mod) {
          const value = mod[varName];
          if((this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
            const before = eventBeforeObj[varName];
            const after = this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
            if((before != null) && (after != null)) {
              if(immediate) {
                result.push(this.changeInstanceVarByConfig(varName, after));
              } else {
                if(value.varAutoChange) {
                  // 変数自動変更
                  if(value.type === constant.ItemDesignOptionType.NUMBER) {
                    result.push(this.changeInstanceVarByConfig(varName, before + ((after - before) * progressPercentage)));
                  } else if(value.type === constant.ItemDesignOptionType.COLOR) {
                    const colorCacheVarName = `${varName}ColorChange__Cache`;
                    if((this[colorCacheVarName] == null)) {
                      let {colorType} = this.constructor.actionPropertiesModifiableVars()[varName];
                      if((colorType == null)) {
                        colorType = 'hex';
                      }
                      this[colorCacheVarName] = Common.colorChangeCacheData(before, after, progressMax, colorType);
                    }
                    result.push(this.changeInstanceVarByConfig(varName, this[colorCacheVarName][progressValue]));
                  } else {
                    result.push(undefined);
                  }
                } else {
                  result.push(undefined);
                }
              }
            } else {
              result.push(undefined);
            }
          } else {
            result.push(undefined);
          }
        }
        return result;
      })();
    }

    // アニメーションによるアイテム状態更新
    updateInstanceParamByAnimation(immediate) {
      let after, timer, value, varName;
      if(immediate == null) {
        immediate = false;
      }
      if(this.getEventMethodName() === EventPageValueBase.NO_METHOD) {
        return;
      }

      // NOTICE: varAutoChange=falseの場合は(変数)_xxxの形で変更前、変更後、進捗を渡してdraw側で処理させる
      const ed = this.eventDuration();
      const progressMax = this.progressMax();
      const eventBeforeObj = this.getMinimumObjectEventBefore();
      const mod = this.constructor.actionPropertiesModifiableVars(this.getEventMethodName());
      if(immediate) {
        for(varName in mod) {
          value = mod[varName];
          if((this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
            after = this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
            if(after != null) {
              this.changeInstanceVarByConfig(varName, after);
            }
          }
        }
        return;
      }

      let count = 1;
      return timer = setInterval(() => {
          const progressPercentage = (this.constructor.STEP_INTERVAL_DURATION * count) / ed;
          for(varName in mod) {
            value = mod[varName];
            if((this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
              const before = eventBeforeObj[varName];
              after = this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
              if((before != null) && (after != null)) {
                if(value.varAutoChange) {
                  if(value.type === constant.ItemDesignOptionType.NUMBER) {
                    this.changeInstanceVarByConfig(varName, before + ((after - before) * progressPercentage));
                  } else if(value.type === constant.ItemDesignOptionType.COLOR) {
                    const colorCacheVarName = `${varName}ColorChange__Cache`;
                    if((this[colorCacheVarName] == null)) {
                      let {colorType} = this.constructor.actionPropertiesModifiableVars()[varName];
                      if((colorType == null)) {
                        colorType = 'hex';
                      }
                      this[colorCacheVarName] = Common.colorChangeCacheData(before, after, progressMax, colorType);
                    }
                    this.changeInstanceVarByConfig(varName, this[colorCacheVarName][count]);
                  }
                }
              }
            }
          }
          count += 1;
          if(count > progressMax) {
            clearInterval(timer);
            return (() => {
              const result = [];
              for(varName in mod) {
                value = mod[varName];
                if((this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null)) {
                  after = this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
                  if(after != null) {
                    result.push(this.changeInstanceVarByConfig(varName, after));
                  } else {
                    result.push(undefined);
                  }
                } else {
                  result.push(undefined);
                }
              }
              return result;
            })();
          }
        }
        , this.constructor.STEP_INTERVAL_DURATION * 1000);
    }

    // イベント前後の変数を設定 [xxx__before] & [xxx__after]
    setModifyBeforeAndAfterVar() {
      if((this._event == null)) {
        return;
      }

      const beforeObj = this.getMinimumObjectEventBefore();
      const mod = this.constructor.actionPropertiesModifiableVars(this.getEventMethodName());
      return (() => {
        const result = [];
        for(let varName in mod) {
          const value = mod[varName];
          if(beforeObj != null) {
            this[varName + this.constructor.BEFORE_MODIFY_VAR_SUFFIX] = beforeObj[varName];
          }
          if(this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) {
            const afterObj = this._event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
            if(afterObj != null) {
              result.push(this[varName + this.constructor.AFTER_MODIFY_VAR_SUFFIX] = afterObj);
            } else {
              result.push(undefined);
            }
          } else {
            result.push(undefined);
          }
        }
        return result;
      })();
    }

    // アイテムの情報をページ値に保存
    // @property [Boolean] isCache キャッシュとして保存するか
    setItemAllPropToPageValue(isCache) {
      if(isCache == null) {
        isCache = false;
      }
      const prefix_key = isCache ? PageValue.Key.instanceValueCache(this.id) : PageValue.Key.instanceValue(this.id);
      const obj = this.getMinimumObject();
      return PageValue.setInstancePageValue(prefix_key, obj);
    }

    // ステップ数最大値
    progressMax() {
      if(this._event[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.SCROLL) {
        return this.scrollLength();
      } else {
        return this.clickDurationStepMax();
      }
    }

    // クリック時間ステップ数最大値
    clickDurationStepMax() {
      const ed = this.eventDuration();
      return Math.ceil(ed / this.constructor.STEP_INTERVAL_DURATION);
    }

    // クリック実行時間
    eventDuration() {
      let d = this._event[EventPageValueBase.PageValueKey.EVENT_DURATION];
      if(d === 'undefined') {
        d = null;
      }
      return d;
    }

    // 保存用の最小限のデータを取得 保存不要なタイプの判定は適宜追加
    // @return [Object] 取得データ
    getMinimumObject() {
      const obj = {};
      for(let k in this) {
        const v = this[k];
        if(v != null) {
          if((k.indexOf('_') !== 0) &&
            ((v instanceof ImageData) === false) &&
            !Common.isElement(v) &&
            (typeof v !== 'function')) {
            obj[k] = Common.makeClone(v);
          }
        }
      }
      return obj;
    }

    // 最小限のデータを設定 保存不要なタイプの判定は適宜追加
    // @param [Object] obj 設定データ
    setMiniumObject(obj) {
      // ID変更のため一度instanceMapから削除
      delete window.instanceMap[this.id];
      for(let k in obj) {
        const v = obj[k];
        if(v != null) {
          if((k.indexOf('_') !== 0) &&
            ((v instanceof ImageData) === false) &&
            !Common.isElement(v) &&
            (typeof v !== 'function')) {
            this[k] = Common.makeClone(v);
          }
        }
      }
      return window.instanceMap[this.id] = this;
    }

    // 独自コンフィグのイベント初期化
    // @abstract
    static initSpecificConfig(specificRoot) {
    }

    // 編集可能変数プロパティを取得(childrenを含む)
    static actionPropertiesModifiableVars(methodName = null, isDefault) {
      if(isDefault == null) {
        isDefault = false;
      }
      var _actionPropertiesModifiableVars = function(modifiableRoot, ret) {
        if(modifiableRoot != null) {
          for(let k in modifiableRoot) {
            const v = modifiableRoot[k];
            ret[k] = v;
            if(v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN] != null) {
              // Childrenを含める
              for(let ck in v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN]) {
                const cv = v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN][ck];
                if(cv != null) {
                  ret = $.extend(ret, _actionPropertiesModifiableVars.call(this, cv, ret));
                }
              }
            }
          }
        }
        return ret;
      };

      const ret = {};
      let modifiableRoot = {};
      if(methodName != null) {
        if(isDefault) {
          if(this.actionProperties[methodName] != null) {
            modifiableRoot = this.actionProperties[methodName][this.ActionPropertiesKey.MODIFIABLE_VARS];
          }
        } else {
          if((this.actionProperties.methods != null) && (this.actionProperties.methods[methodName] != null)) {
            modifiableRoot = this.actionProperties.methods[methodName][this.ActionPropertiesKey.MODIFIABLE_VARS];
          }
        }
      } else {
        modifiableRoot = this.actionProperties[this.ActionPropertiesKey.MODIFIABLE_VARS];
      }

      return _actionPropertiesModifiableVars.call(this, modifiableRoot, ret);
    }

    isFinishedWithHand() {
      const methodName = this.getEventMethodName();
      if((methodName != null) && (this.constructor.actionProperties.methods != null) && (this.constructor.actionProperties.methods[methodName] != null)) {
        const m = this.constructor.actionProperties.methods[methodName];
        return (m[this.constructor.ActionPropertiesKey.FINISH_WITH_HAND] != null) && m[this.constructor.ActionPropertiesKey.FINISH_WITH_HAND];
      }
      return false;
    }

    saveToFootprint(targetObjId, isChangeBefore, eventDistNum, pageNum) {
      if(pageNum == null) {
        pageNum = PageValue.getPageNum();
      }
      return PageValue.saveToFootprint(targetObjId, isChangeBefore, eventDistNum);
    }
  };
  EventBase.initClass();
  return EventBase;
})();
//    if @_event[EventPageValueBase.PageValueKey.DO_FOCUS] && @ instanceof ScreenEvent.PrivateClass == false
//      # フォーカスされる場合はスクロール位置も保存
//      se = new ScreenEvent()
//      if se?
//        PageValue.saveToFootprint(se.id, isChangeBefore, eventDistNum)
