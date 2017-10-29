import Common from '../base/common';
import PageValue from '../base/page_value';
import FloatView from '../base/float_view';
import ClickChapter from './click_chapter';
import ScrollChapter from './scroll_chapter';
import EventPageValueBase from '../event_page_value/base/base';
import RunCommon from './common/run_common';

export default class Page {
  // コンストラクタ
  // @param [Object] eventPageValeuList イベントPageValue
  constructor(eventPageValueArray) {

    const _setupChapterList = function(eventPageValueList, chapterList) {
      if(eventPageValueList !== null) {
        let eventList = [];
        return $.each(eventPageValueList, (idx, obj) => {
          eventList.push(obj);

          let sync = false;
          if(idx < (eventPageValueList.length - 1)) {
            const beforeEvent = eventPageValueList[idx + 1];
            if(beforeEvent[EventPageValueBase.PageValueKey.IS_SYNC]) {
              sync = true;
            }
          }

          if(!sync) {
            let chapter = null;
            if(obj[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.CLICK) {
              chapter = new ClickChapter({eventList, num: idx});
            } else {
              chapter = new ScrollChapter({eventList, num: idx});
            }
            chapterList.push(chapter);
            eventList = [];
          }

          return true;
        });
      }
    };

    this.forkChapterList = {};
    this.forkChapterIndex = {};
    for(let k in eventPageValueArray.forks) {
      const forkEventPageValueList = eventPageValueArray.forks[k];
      this.forkChapterList[k] = [];
      this.forkChapterIndex[k] = 0;
      _setupChapterList.call(this, forkEventPageValueList, this.forkChapterList[k]);
    }

    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
  }

  // フォーク内のチャプターリスト取得
  // @return [Array] チャプターリスト
  getForkChapterList() {
    const lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum());
    if(lastForkNum !== null) {
      return this.forkChapterList[lastForkNum];
    } else {
      return [];
    }
  }

  // 進行するチャプターリスト取得
  // @return [Array] チャプターリスト
  getProgressChapterList() {
    // フォークスタックを参照してページ内のチャプターリストを取得
    const ret = [];
    const stack = RunCommon.getForkStack(window.eventAction.thisPageNum());
    for(let sIndex = 0; sIndex < stack.length; sIndex++) {
      const s = stack[sIndex];
      for(let cIndex = 0; cIndex < this.forkChapterList[s.forkNum].length; cIndex++) {
        const chapter = this.forkChapterList[s.forkNum][cIndex];
        if((stack[sIndex + 1] !== null) && (cIndex > stack[sIndex + 1].changedChapterIndex)) {
          break;
        }
        ret.push(chapter);
      }
    }
    return ret;
  }

  // 全チャプターリスト取得
  // @return [Array] チャプターリスト
  getAllChapterList() {
    // フォークスタックを参照してページ内のチャプターリストを取得
    const ret = [];
    for(let k in this.forkChapterList) {
      const forkList = this.forkChapterList[k];
      for(let chapter of Array.from(forkList)) {
        ret.push(chapter);
      }
    }
    return ret;
  }

  // チャプターインデックス取得
  // @return [Integer] チャプターインデックス
  getChapterIndex() {
    const lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum());
    if(lastForkNum !== null) {
      return this.forkChapterIndex[lastForkNum];
    } else {
      return 0;
    }
  }

  // チャプターインデックス設定
  // @param [Integer] num 設定値
  setChapterIndex(num) {
    const lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum());
    if(lastForkNum !== null) {
      return this.forkChapterIndex[lastForkNum] = num;
    }
  }

  // チャプターインデックス追加
  // @param [Integer] addNum 追加値
  addChapterIndex(addNum) {
    const lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum());
    if(lastForkNum !== null) {
      return this.forkChapterIndex[lastForkNum] = this.forkChapterIndex[lastForkNum] + addNum;
    }
  }

  // 現在のチャプターインスタンスを取得
  // @return [Object] 現在のチャプターインスタンス
  thisChapter() {
    return this.getForkChapterList()[this.getChapterIndex()];
  }

  // 現在のチャプター番号を取得
  // @return [Integer] 現在のチャプター番号
  thisChapterNum() {
    return this.getChapterIndex() + 1;
  }

  // 開始イベント
  start() {
    if(window.runDebug) {
      console.log('Page Start');
    }
    // チャプター数設定
    RunCommon.setChapterNum(this.thisChapterNum());
    // チャプター前処理
    this.floatPageScrollHandleCanvas();
    if(this.thisChapter() !== null) {
      return this.thisChapter().willChapter();
    } else {
      // チャプター無し -> 終了
      return this.finishAllChapters();
    }
  }

  // 全てのイベントが終了している場合、チャプターを進める
  nextChapterIfFinishedAllEvent() {
    if(this.thisChapter().isFinishedAllEvent(false)) {
      return this.nextChapter();
    }
  }

  // 次のチャプター処理
  nextChapter() {
    if((this.thisChapter().changeForkNum !== null) && (this.thisChapter().changeForkNum !== RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum()))) {
      // フォーク変更
      return this.switchFork();
    } else {
      // チャプターをすすめる
      return this.progressChapter();
    }
  }

  // 現在のフォークでチャプターを進める
  progressChapter() {
    // 全ガイド非表示
    this.hideAllGuide();
    // チャプター後処理
    return this.thisChapter().didChapter(() => {
      // indexを更新
      if(this.getForkChapterList().length <= (this.getChapterIndex() + 1)) {
        return this.finishAllChapters();
      } else {
        this.addChapterIndex(1);
        // チャプター数設定
        RunCommon.setChapterNum(this.thisChapterNum());
        // チャプター前処理
        return this.thisChapter().willChapter();
      }
    });
  }

  // フォークを変更する
  switchFork() {
    // 全ガイド非表示
    this.hideAllGuide();
    // チャプター後処理
    return this.thisChapter().didChapter(() => {
      // フォーク番号変更
      if(this.thisChapter().changeForkNum !== null) {
        const nfn = this.thisChapter().changeForkNum;
        if(RunCommon.addForkNumToStack(nfn, this.getChapterIndex(), window.eventAction.thisPageNum())) {
          RunCommon.setForkNum(nfn);
        }
      }
      // チャプター数設定
      RunCommon.setChapterNum(this.thisChapterNum());
      // チャプター最大値設定
      RunCommon.setChapterMax(this.getForkChapterList().length);
      // チャプター前処理
      return this.thisChapter().willChapter();
    });
  }

  // チャプターを戻す
  rewindChapter(callback = null) {
    if(window.runDebug) {
      console.log('Page rewindChapter');
    }
    if((window.runningOperation !== null) && window.runningOperation) {
      // 二重実行防止
      return;
    }
    window.runningOperation = true;
    // 全ガイド非表示
    this.hideAllGuide();
    if((this.thisChapter() === null)) {
      // チャプターが無い場合はページを戻す
      window.eventAction.rewindPage(() => {
        FloatView.show('Rewind previous page', FloatView.Type.REWIND_CHAPTER, 1.0);
        window.runningOperation = false;
        if(callback !== null) {
          return callback();
        }
      });
      return;
    }

    return this.resetChapter(this.getChapterIndex(), () => {
      if(!this.thisChapter().doMoveChapter) {
        if(this.getChapterIndex() > 0) {
          this.addChapterIndex(-1);
          return this.resetChapter(this.getChapterIndex(), () => {
            RunCommon.setChapterNum(this.thisChapterNum());
            // チャプター前処理
            return this.thisChapter().willChapter(() => {
              FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0);
              window.runningOperation = false;
              if(callback !== null) {
                return callback();
              }
            });
          });
        } else {
          const oneBeforeForkObj = RunCommon.getOneBeforeObjestFromStack(window.eventAction.thisPageNum());
          const lastForkObj = RunCommon.getLastObjestFromStack(window.eventAction.thisPageNum());
          if(oneBeforeForkObj && (oneBeforeForkObj.forkNum !== lastForkObj.forkNum)) {
            // 最後のフォークオブジェクトを削除
            RunCommon.popLastForkNumInStack(window.eventAction.thisPageNum());
            // フォーク番号変更
            const nfn = oneBeforeForkObj.forkNum;
            RunCommon.setForkNum(nfn);
            // チャプター番号をフォーク以前に変更
            this.setChapterIndex(lastForkObj.changedChapterIndex);
            // チャプターリセット
            return this.resetChapter(this.getChapterIndex(), () => {
              // チャプター番号設定
              RunCommon.setChapterNum(this.thisChapterNum());
              // チャプター最大値設定
              RunCommon.setChapterMax(this.getForkChapterList().length);
              // チャプター前処理
              return this.thisChapter().willChapter(() => {
                FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0);
                window.runningOperation = false;
                if(callback !== null) {
                  return callback();
                }
              });
            });
          } else {
            const beforePage = window.eventAction.beforePage();
            if(beforePage !== null) {
              // ページ戻し
              return window.eventAction.rewindPage(() => {
                FloatView.show('Rewind previous page', FloatView.Type.REWIND_CHAPTER, 1.0);
                window.runningOperation = false;
                if(callback !== null) {
                  return callback();
                }
              });
            } else {
              return this.thisChapter().willChapter(() => {
                FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0);
                window.runningOperation = false;
                if(callback !== null) {
                  return callback();
                }
              });
            }
          }
        }
      } else {
        // チャプター前処理
        return this.thisChapter().willChapter(() => {
          FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0);
          window.runningOperation = false;
          if(callback !== null) {
            return callback();
          }
        });
      }
    });
  }

  // チャプターの内容をリセット
  resetChapter(chapterIndex, callback = null) {
    if(chapterIndex === null) {
      chapterIndex = this.getChapterIndex();
    }
    if(window.runDebug) {
      console.log('Page resetChapter');
    }
    this.finishedAllChapters = false;
    this.finishedScrollDistSum = 0;
    const chapterList = this.getForkChapterList()[chapterIndex];
    if(chapterList !== null) {
      return chapterList.resetAllEvents(callback);
    } else {
      if(callback !== null) {
        return callback();
      }
    }
  }

  // 全てのチャプターを戻す
  rewindAllChapters(rewindPageIfNeed, callback = null) {
    if(rewindPageIfNeed === null) {
      rewindPageIfNeed = true;
    }
    if(window.runDebug) {
      console.log('Page rewindAllChapters');
    }
    if(rewindPageIfNeed && (window.runningOperation !== null) && window.runningOperation) {
      // 二重実行防止
      return;
    }
    window.runningOperation = true;
    // 全ガイド非表示
    this.hideAllGuide();
    const chapter = this.thisChapter();
    if((chapter === null) || (!chapter.doMoveChapter && rewindPageIfNeed)) {
      // 前ページを先頭チャプターに戻す
      const beforePage = window.eventAction.beforePage();
      if(beforePage !== null) {
        return window.eventAction.rewindPage(() => {
          return beforePage.rewindAllChapters(false, () => {
            FloatView.show('Rewind previous page', FloatView.Type.REWIND_CHAPTER, 1.0);
            window.runningOperation = false;
            if(callback !== null) {
              return callback();
            }
          });
        });
      } else {
        window.runningOperation = false;
        if(callback !== null) {
          return callback();
        }
      }
    } else {
      const _callback = function() {
        this.setChapterIndex(0);
        RunCommon.setChapterNum(this.thisChapterNum());
        // フォークをMasterに設定
        RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, window.eventAction.thisPageNum());
        RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM);
        this.finishedAllChapters = false;
        this.finishedScrollDistSum = 0;
        this.start();
        if(rewindPageIfNeed) {
          FloatView.show('Rewind all events', FloatView.Type.REWIND_ALL_CHAPTER, 1.0);
          window.runningOperation = false;
        }
        if(callback !== null) {
          return callback();
        }
      };

      const list = this.getProgressChapterList();
      if(list.length === 0) {
        return _callback.call(this);
      } else {
        let count = 0;
        return (() => {
          const result = [];
          for(let i = list.length - 1; i >= 0; i--) {
            const c = list[i];
            result.push(c.resetAllEvents(() => {
              count += 1;
              if(count >= list.length) {
                return _callback.call(this);
              }
            }));
          }
          return result;
        })();
      }
    }
  }

  // スクロールイベントをハンドル
  // @param [Int] x X軸の動作値
  // @param [Int] y Y軸の動作値
  handleScrollEvent(x, y) {
    if(!this.finishedAllChapters) {
      if(this.isScrollChapter()) {
        return this.thisChapter().scrollEvent(x, y);
      }
    } else {
      if(window.eventAction.hasNextPage() && ((x + y) > 0)) {
        // 次ページ移動ガイドを表示する
        return window.eventAction.pagingOperationGuide.scrollEvent(x, y);
      } else if((x + y) < 0) {
        // チャプター戻し
        const v = -(x + y);
        return window.eventAction.rewindOperationGuide.scrollEventByDistSum(v);
      }
    }
  }

  // スクロールチャプターか判定
  isScrollChapter() {
    return (this.thisChapter().scrollEvent !== null);
  }

  // 全てのイベントアイテムをFrontから落とす
  floatPageScrollHandleCanvas() {
    if(window.runDebug) {
      console.log('Page floatPageScrollHandleCanvas');
    }

    window.scrollHandleWrapper.css('pointer-events', '');
    return this.getForkChapterList().forEach(chapter => chapter.enableScrollHandleViewEvent());
  }

  // ページ前処理
  willPage(callback = null) {
    if(window.runDebug) {
      console.log('Page willPage');
    }
    // ページ状態初期化のため、ここで全チャプターのイベントを初期化
    this.initChapterEvent();
    // リセット
    return this.resetAllChapters(() => {
      // アイテム状態初期化
      return this.initItemDrawingInPage(() => {
        // フォーカス
        this.initFocus(true);
        // チャプター最大値設定
        RunCommon.setChapterMax(this.getForkChapterList().length);
        // キャッシュ保存
        window.lStorage.saveAllPageValues();
        if(callback !== null) {
          return callback();
        }
      });
    });
  }

  // ページ戻し前処理
  willPageFromRewind(callback = null) {
    if(window.runDebug) {
      console.log('Page willPageFromRewind');
    }

    // ページ状態初期化のため、ここで全チャプターのイベントを初期化
    this.initChapterEvent();
    // アイテム状態初期化
    return this.initItemDrawingInPage(() => {
      // フォーカス
      this.initFocus(false);
      // 最後のイベントのみリセット
      return this.forwardProgressChapters(() => {
        return this.getForkChapterList()[this.getForkChapterList().length - 1].resetAllEvents(() => {
          // チャプター最大値設定
          RunCommon.setChapterMax(this.getForkChapterList().length);
          // インデックスを最後のチャプターに
          this.setChapterIndex(this.getForkChapterList().length - 1);
          // フォーク番号設定
          RunCommon.setForkNum(RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum()));
          // チャプター初期化
          return this.resetChapter(this.getChapterIndex(), () => {
            // キャッシュ保存
            window.lStorage.saveAllPageValues();
            if(callback !== null) {
              return callback();
            }
          });
        });
      });
    });
  }

  // ページ後処理
  didPage() {
    if(window.runDebug) {
      console.log('Page didPage');
    }

    // 操作履歴を保存
    return RunCommon.saveFootprint();
  }

  // チャプターのイベントを初期化
  initChapterEvent() {
    return Array.from(this.getAllChapterList()).map((chapter) =>
      (() => {
        const result = [];
        for(let i = 0, end = chapter.eventObjList.length - 1, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
          const event = chapter.eventObjList[i];
          result.push(event.initEvent(chapter.eventList[i]));
        }
        return result;
      })());
  }

  // チャプターのフォーカス初期化
  initFocus(focusToFirst) {
    let chapter, event;
    if(focusToFirst === null) {
      focusToFirst = true;
    }
    let flg = false;
    if(focusToFirst) {
      for(chapter of Array.from(this.getForkChapterList())) {
        if(flg) {
          return false;
        }
        for(event of Array.from(chapter.eventList)) {
          if(flg) {
            return false;
          }
          if(!event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
            chapter.focusToActorIfNeed(true);
            flg = true;
          }
        }
      }
    } else {
      for(let i = this.getForkChapterList().length - 1; i >= 0; i--) {
        chapter = this.getForkChapterList()[i];
        if(flg) {
          return false;
        }
        for(event of Array.from(chapter.eventList)) {
          if(flg) {
            return false;
          }
          if(!event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
            chapter.focusToActorIfNeed(true);
            flg = true;
          }
        }
      }
    }
  }

  // アイテム表示の初期化
  initItemDrawingInPage(callback = null) {
    if(window.runDebug) {
      console.log('Page initItemDrawingInPage');
    }

    // アイテムインスタンス取得(無い場合は作成 & 初期化もする)
    const objs = Common.itemInstancesInPage(PageValue.getPageNum(), true, true);
    if(objs.length === 0) {
      if(callback !== null) {
        callback();
      }
      return;
    }
    let finishCount = 0;
    return Array.from(objs).map((obj) =>
      //if obj.visible
      // 初期表示
      obj.refreshIfItemNotExist(obj.visible, obj => {
        if(obj.firstFocus) {
          // 初期フォーカス
          window.disabledEventHandler = true;
          Common.focusToTarget(obj.getJQueryElement(), () => window.disabledEventHandler = false
            , true);
        }
        finishCount += 1;
        if(finishCount >= objs.length) {
          if(callback !== null) {
            return callback();
          }
        }
      }));
  }

  // 全てのチャプターをリセット
  resetAllChapters(callback = null) {
    if(window.runDebug) {
      console.log('Page resetAllChapters');
    }
    let count = 0;
    const max = this.getAllChapterList().length;
    if(max === 0) {
      if(callback !== null) {
        return callback();
      }
    } else {
      return this.getAllChapterList().forEach(chapter =>
        chapter.resetAllEvents(() => {
          count += 1;
          if(count >= max) {
            if(callback !== null) {
              return callback();
            }
          }
        })
      );
    }
  }

  // フォークを含んだ動作予定のチャプターを進行
  forwardProgressChapters(callback = null) {
    let count = 0;
    const list = this.getProgressChapterList();
    return list.forEach(chapter =>
      chapter.forwardAllEvents(() => {
        count += 1;
        if(count >= list.length) {
          if(callback !== null) {
            return callback();
          }
        }
      })
    );
  }

  // 全てのチャプターのガイドを非表示
  hideAllGuide() {
    return this.getForkChapterList().forEach(chapter => chapter.hideGuide());
  }

  // イベント終了イベント
  finishAllChapters(nextPageIndex = null) {
    if(window.runDebug) {
      console.log('Page finishAllChapters');
      if(nextPageIndex !== null) {
        console.log(`nextPageIndex: ${nextPageIndex}`);
      }
    }
    if(nextPageIndex !== null) {
      window.eventAction.nextPageIndex = nextPageIndex;
    }
    this.finishedAllChapters = true;
    if(nextPageIndex || window.eventAction.hasNextPage()) {
      // ページ移動のためのスクロールイベントを取るようにする
      return this.floatPageScrollHandleCanvas();
    } else {
      // 全ページ終了の場合
      window.eventAction.finishAllPages();
      return FloatView.show('Finished all', FloatView.Type.FINISH, 3.0);
    }
  }

  // 中断
  shutdown() {
    return this.hideAllGuide();
  }
}
