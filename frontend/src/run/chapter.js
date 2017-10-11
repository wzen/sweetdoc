/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

// チャプター(イベントの区切り)
class Chapter {
  static initClass() {
    // ガイド表示用タイマー
    this.guideTimer = null;
  }

  // コンストラクタ
  // @param [Array] list イベント情報
  constructor(list) {
    this.eventList = list.eventList;
    this.num = list.num;
    this.eventObjList = [];
    for(let obj of Array.from(this.eventList)) {
      const id = obj[EventPageValueBase.PageValueKey.ID];
      const distId = obj[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN];
      // インスタンス作成
      const event = Common.getInstanceFromMap(id, distId);
      this.eventObjList.push(event);
    }
    this.doMoveChapter = false;
  }

  // チャプター実行前処理
  willChapter(callback = null) {
    if(window.runDebug) {
      console.log('Chapter willChapter');
    }
    let count = 0;
    // 個々イベントのwillChapter呼び出し & CSS追加
    return (() => {
      const result = [];
      for(let idx = 0; idx < this.eventObjList.length; idx++) {
        const event = this.eventObjList[idx];
        event.initEvent(this.eventList[idx]);
        result.push(event.willChapter(() => {
          this.doMoveChapter = false;
          count += 1;
          if(count >= this.eventObjList.length) {
            // 対象アイテムにフォーカス
            this.focusToActorIfNeed(false);
            // イベント反応有効
            this.enableEventHandle();
            if(callback !== null) {
              return callback();
            }
          }
        }));
      }
      return result;
    })();
  }

  // チャプター共通の後処理
  didChapter(callback = null) {
    if(window.runDebug) {
      console.log('Chapter didChapter');
    }
    let count = 0;
    return this.eventObjList.forEach(event => {
      return event.didChapter(() => {
        count += 1;
        if(count >= this.eventObjList.length) {
          if(callback !== null) {
            return callback();
          }
        }
      });
    });
  }

  // アイテムにフォーカス(アイテムが1つのみの場合)
  // @param [Boolean] isImmediate 即時反映するか
  // @param [String] フォーカスタイプ
  focusToActorIfNeed(isImmediate, type) {
    if(type == null) {
      type = "center";
    }
    window.disabledEventHandler = true;
    let item = null;
    this.eventObjList.forEach((e, idx) => {
      if((this.eventList[idx][EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === false) &&
        this.eventList[idx][EventPageValueBase.PageValueKey.DO_FOCUS]) {
        item = e;
        return false;
      }
    });

    if(item !== null) {
      // TODO: center以外も?
      if(type === 'center') {
        return Common.focusToTarget(item.getJQueryElement(), () => window.disabledEventHandler = false
          , isImmediate);
      }
    } else {
      // フォーカスなし
      return window.disabledEventHandler = false;
    }
  }

  // スクロールイベント用のCanvasを反応させない
  disableScrollHandleViewEvent() {
    if(window.runDebug) {
      console.log('Chapter floatAllChapterEvents');
    }
    return window.scrollHandleWrapper.css('pointer-events', 'none');
  }

  // スクロールイベント用のCanvasを反応させる
  enableScrollHandleViewEvent() {
    if(window.runDebug) {
      console.log('Chapter floatScrollHandleCanvas');
    }
    return window.scrollHandleWrapper.css('pointer-events', '');
  }

  // チャプターのイベントをリセットする
  resetAllEvents(callback = null) {
    if(window.runDebug) {
      console.log('Chapter resetAllEvents');
    }

    // 描画を戻す
    let count = 0;
    const max = this.eventObjList.length;
    if(max === 0) {
      if(callback !== null) {
        return callback();
      }
    } else {
      return (() => {
        const result = [];
        for(let idx = 0; idx < this.eventObjList.length; idx++) {
          const e = this.eventObjList[idx];
          e.initEvent(this.eventList[idx]);
          e.updateEventBefore();
          e.resetProgress();
          result.push(e.refresh(e.visible, () => {
            count += 1;
            if(count >= max) {
              if(callback !== null) {
                return callback();
              }
            }
          }));
        }
        return result;
      })();
    }
  }

  // チャプターのイベントを実行後にする
  forwardAllEvents(callback = null) {
    if(window.runDebug) {
      console.log('Chapter forwardAllEvents');
    }

    // とりあえずフォーカスはなし
    let count = 0;
    return (() => {
      const result = [];
      for(let idx = 0; idx < this.eventObjList.length; idx++) {
        var e = this.eventObjList[idx];
        e.initEvent(this.eventList[idx]);
        e.updateEventAfter();
        // FIXME: 状態を後に戻す(現状didChapterにしておく)
        result.push(e.execLastStep(() => {
          e.didChapter();
          count += 1;
          if(count >= this.eventObjList.length) {
            if(callback !== null) {
              return callback();
            }
          }
        }));
      }
      return result;
    })();
  }

  // ガイド表示
  // @param [Boolean] calledByWillChapter チャプター開始時に呼ばれたか
  showGuide(calledByWillChapter) {
    if(calledByWillChapter == null) {
      calledByWillChapter = false;
    }
    return RunSetting.isShowGuide();
  }

  // ガイド非表示
  // @abstract
  hideGuide() {
  }

  // イベント反応を有効にする
  enableEventHandle() {
    return this.eventObjList.forEach(e => {
      return e._skipEvent = false;
    });
  }

  // イベント反応を無効にする
  disableEventHandle() {
    return this.eventObjList.forEach(e => {
      return e._skipEvent = true;
    });
  }

  // 全てのイベントアイテムが終了しているか
  // @abstract
  isFinishedAllEvent() {
    return false;
  }

  // 全てのイベントがイベントの頭にいる場合は動作フラグを戻す
  reverseDoMoveChapterFlgIfAllEventOnHeader() {
    this.eventObjList.forEach(e => {
      if(e._runningEvent) {
        return false;
      }
    });
    this.doMoveChapter = false;
    return true;
  }

  // ページ戻しガイド表示
  showRewindOperationGuide(target, value) {
    if(this.reverseDoMoveChapterFlgIfAllEventOnHeader()) {
      return window.eventAction.rewindOperationGuide.scrollEventByDistSum(value, target);
    }
  }

  hideRewindOperationGuide(target) {
    // チャプター戻しガイドを削除
    return window.eventAction.rewindOperationGuide.clear(target);
  }
}

Chapter.initClass();
