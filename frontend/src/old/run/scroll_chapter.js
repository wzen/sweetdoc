import Chapter from './chapter';
import ClickGuide from './guide/click';
import ScrollGuide from './guide/scroll';
import RunCommon from './common/run_common';

// スクロール用Chapterクラス
export default class ScrollChapter extends Chapter {
  // チャプターの前処理
  willChapter(callback = null) {
    return super.willChapter(() => {
      this.enableScrollHandleViewEvent();
      // スクロール位置初期化
      RunCommon.initHandleScrollView();
      // ガイド表示
      this.showGuide(true);
      if(callback !== null) {
        return callback();
      }
    });
  }

  // チャプターの後処理
  didChapter(callback = null) {
    return super.didChapter(() => {
      this.hideGuide();
      if(callback !== null) {
        return callback();
      }
    });
  }

  // スクロールイベント
  // @param [Integer] x 横方向スクロール位置
  // @param [Integer] y 縦方向スクロール位置
  scrollEvent(x, y) {
    if(window.disabledEventHandler) {
      return;
    }
    this.eventObjList.forEach(event => {
      if(event.scrollEvent !== null) {
        return event.scrollEvent(x, y, () => {
          this.hideGuide();
          if(window.eventAction !== null) {
            return window.eventAction.thisPage().nextChapterIfFinishedAllEvent();
          }
        });
      }
    });
    if(!this.isFinishedAllEvent()) {
      return this.showGuide();
    }
  }

  // ガイド表示
  // @param [Boolean] calledByWillChapter チャプター開始時に呼ばれたか
  showGuide(calledByWillChapter) {
    if(calledByWillChapter === null) {
      calledByWillChapter = false;
    }
    if(!super.showGuide(calledByWillChapter)) {
      return false;
    }
    this.hideGuide();
    let idleTime = ScrollGuide.IDLE_TIMER;
    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は即表示
      idleTime = 0;
    }

    return this.constructor.guideTimer = setTimeout(() => {
        // ガイド表示
        this.adjustGuideParams(calledByWillChapter);
        return ScrollGuide.showGuide(this._enabledDirections, this._forwardDirections, this.canForward, this.canReverse);
      }
      , idleTime);
  }

  // ガイド非表示
  hideGuide() {
    if(this.constructor.guideTimer !== null) {
      clearTimeout(this.constructor.guideTimer);
      this.constructor.guideTimer = null;
    }
    ScrollGuide.hideGuide();
    return ClickGuide.hideGuide();
  }

  // ガイドフラグ調整
  // @param [Boolean] calledByWillChapter チャプター開始時に呼ばれたか
  adjustGuideParams(calledByWillChapter) {
    this._enabledDirections = {
      top: false,
      bottom: false,
      left: false,
      right: false
    };
    this._forwardDirections = {
      top: false,
      bottom: false,
      left: false,
      right: false
    };
    this.canForward = false;
    this.canReverse = false;
    this.eventObjList.forEach(event => {
      if(!event._isFinishedEvent) {
        // trueフラグ優先にまとめる
        let v;
        for(var k in event._enabledDirections) {
          v = event._enabledDirections[k];
          if(!this._enabledDirections[k]) {
            this._enabledDirections[k] = v;
          }
        }
        for(k in event._forwardDirections) {
          v = event._forwardDirections[k];
          if(!this._forwardDirections[k]) {
            this._forwardDirections[k] = v;
          }
        }

        if(!calledByWillChapter) {
          if((event.canForward !== null) && event.canForward) {
            this.canForward = true;
          }
          if((event.canReverse !== null) && event.canReverse) {
            return this.canReverse = true;
          }
        }
      }
    });

    if(calledByWillChapter) {
      // チャプター開始時はForwardのみ
      this.canForward = true;
      return this.canReverse = false;
    }
  }

  // 全てのイベントアイテムのスクロールが終了しているか
  // @return [Boolean] 判定結果
  isFinishedAllEvent(cached) {
    if(cached === null) {
      cached = false;
    }
    if(cached && (this._isFinishedAllEventCache !== null)) {
      return this._isFinishedAllEventCache;
    }
    let ret = true;
    this.eventObjList.forEach(function(event) {
      if(!event._isFinishedEvent) {
        ret = false;
        return false;
      }
    });
    this._isFinishedAllEventCache = ret;
    return ret;
  }
}

