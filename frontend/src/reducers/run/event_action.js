import PageValue from '../../base/page_value';
import Common from '../../base/common';
import ScrollOperationGuide from '../common_event/operation_guide/scroll_operation_guide';
import Page from './page';
import RunCommon from './common/run_common';

// イベント実行クラス
export default class EventAction {
  // コンストラクタ
  // @param [Array] @pageList ページオブジェクト
  // @param [Integer] @pageIndex ページ番号
  constructor(pageList, pageIndex) {
    this.pageList = pageList;
    this.pageIndex = pageIndex;
    this.finishedAllPages = false;
    this.nextPageIndex = null;
  }

  // 現在のページインスタンスを取得
  // @return [Object] 現在のページインスタンス
  thisPage() {
    return this.pageList[this.pageIndex];
  }

  // 前のページインスタンスを取得
  beforePage() {
    if(this.pageIndex > 0) {
      return this.pageList[this.pageIndex - 1];
    } else {
      return null;
    }
  }

  // 現在のページ番号を取得
  // @return [Object] 現在のページ番号
  thisPageNum() {
    return this.pageIndex + 1;
  }

  // 開始イベント
  start(callback = null) {
    // ページングガイド作成
    this.pagingOperationGuide = new ScrollOperationGuide(ScrollOperationGuide.Type.PAGING);
    this.rewindOperationGuide = new ScrollOperationGuide(ScrollOperationGuide.Type.REWIND, ScrollOperationGuide.Direction.REVERSE);
    // ページ数設定
    RunCommon.setPageNum(this.thisPageNum());
    // フォークをMasterに設定
    RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, window.eventAction.thisPageNum());
    RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM);
    return this.thisPage().willPage(() => {
      this.thisPage().start();
      if(callback !== null) {
        return callback();
      }
    });
  }

  // 中断
  shutdown() {
    if(this.thisPage() !== null) {
      return this.thisPage().shutdown();
    }
  }

  // 全てのチャプターが終了している場合、ページを進める
  // @param [Function] callback コールバック
  nextPageIfFinishedAllChapter(callback = null) {
    if(this.thisPage().finishedAllChapters) {
      return this.nextPage(callback);
    }
  }

  // ページを進める
  // @param [Function] callback コールバック
  nextPage(callback = null) {
    // ページ後処理
    this.thisPage().didPage();
    const beforePageIndex = this.pageIndex;
    if(this.pageList.length <= (this.pageIndex + 1)) {
      // 全ページ終了の場合
      this.finishAllPages();
      if(callback !== null) {
        return callback();
      }
    } else {
      if(this.nextPageIndex !== null) {
        this.pageIndex = this.nextPageIndex;
      } else {
        this.pageIndex += 1;
      }
      // ページ番号更新
      RunCommon.setPageNum(this.thisPageNum());
      PageValue.setPageNum(this.thisPageNum());
      return this.changePaging(beforePageIndex, this.pageIndex, callback);
    }
  }

  // ページを戻す
  // @param [Function] callback コールバック
  rewindPage(callback = null) {
    const beforePageIndex = this.pageIndex;
    this.pagingOperationGuide.clear();
    if(this.pageIndex > 0) {
      // 前ページが存在する場合は戻す
      this.pageIndex -= 1;
      RunCommon.setPageNum(this.thisPageNum());
      PageValue.setPageNum(this.thisPageNum());
      this.changePaging(beforePageIndex, this.pageIndex, callback);
      // チャプター動作済みに戻す
      return this.thisPage().thisChapter().doMoveChapter = true;
    } else {
      // 前ページが無い場合は現在のページを再開
      // ページ前処理
      return this.thisPage().willPage(() => {
        this.thisPage().start();
        if(callback !== null) {
          return callback();
        }
      });
    }
  }

  // ページ変更処理
  // @param [Integer] beforePageIndex 変更前ページIndex
  // @param [Integer] afterPageIndex 変更後ページIndex
  // @param [Function] コールバック
  changePaging(beforePageIndex, afterPageIndex, callback = null) {
    Common.hideModalView(true);
    Common.showModalFlashMessage('Page changing');

    const beforePageNum = beforePageIndex + 1;
    const afterPageNum = afterPageIndex + 1;
    if(window.debug) {
      console.log(`[changePaging] beforePageNum:${beforePageNum}`);
      console.log(`[changePaging] afterPageNum:${afterPageNum}`);
    }

    // 次ページのPageValue読み込み
    // 前ページに戻る場合は操作履歴も取得する
    const doLoadFootprint = beforePageNum > afterPageNum;
    return RunCommon.loadPagingPageValue(afterPageNum, doLoadFootprint, () => {
      // 必要JSファイル読み込み
      return Common.loadJsFromInstancePageValue(() => {
        // Mainコンテナ作成
        Common.createdMainContainerIfNeeded(afterPageNum, beforePageNum > afterPageNum);
        // ページングアニメーションクラス作成
        const pageFlip = new PageFlip(beforePageNum, afterPageNum);
        // 新規コンテナ初期化
        RunCommon.initMainContainer();
        if(this.thisPage() === null) {
          // 次のページオブジェクトがない場合は作成
          const forkEventPageValueList = {};
          for(let i = 0, end = PageValue.getForkCount(), asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
            forkEventPageValueList[i] = PageValue.getEventPageValueSortedListByNum(i, afterPageNum);
          }
          this.pageList[afterPageIndex] = new Page({
            forks: forkEventPageValueList
          });
          if(window.debug) {
            console.log('[nextPage] created page instance');
          }
        }
        PageValue.adjustInstanceAndEventOnPage();
        const _after = function() {
          this.thisPage().start();
          if(this.thisPage().thisChapter() !== null) {
            // イベント反応無効
            this.thisPage().thisChapter().disableEventHandle();
          }
          if(beforePageNum < afterPageNum) {
            // スクロール位置初期化
            Common.initScrollContentsPosition();
          }
          // ページングアニメーション
          return pageFlip.startRender(() => {
            // 次ページインデックスを初期化
            this.nextPageIndex = null;
            // 隠したビューを非表示にする
            const className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
            const section = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
            section.hide();
            // 隠したビューのアイテム表示を削除(インスタンスは残す)
            Common.removeAllItem(beforePageNum, false);
            // CSS削除
            $(`#${RunCommon.RUN_CSS.replace('@pagenum', beforePageNum)}`).remove();
            if(this.thisPage().thisChapter() !== null) {
              // イベント反応有効
              this.thisPage().thisChapter().enableEventHandle();
            }
            // モーダルを削除
            Common.hideModalView();
            // コールバック
            if(callback !== null) {
              return callback();
            }
          });
        };

        // ページ前処理
        if(beforePageNum > afterPageNum) {
          // 前ページ移動 前処理
          return this.thisPage().willPageFromRewind(() => {
            return _after.call(this);
          });
        } else {
          // フォークをMasterに設定
          RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, afterPageNum);
          RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM);
          // 後ページ移動 前処理
          return this.thisPage().willPage(() => {
            return _after.call(this);
          });
        }
      });
    });
  }

  // 全てのページを戻す
  rewindAllPages(callback = null) {
    let count = 0;
    return (() => {
      const result = [];
      for(let i = this.pageList.length - 1; i >= 0; i--) {
        const page = this.pageList[i];
        result.push(page.resetAllChapters(() => {
          count += 1;
          if(count >= this.pageList.length) {
            this.pageIndex = 0;
            RunCommon.setPageNum(this.thisPageNum());
            this.finishedAllPages = false;
            return this.start(callback);
          }
        }));
      }
      return result;
    })();
  }

  // 次のページが存在するか
  hasNextPage() {
    return this.pageIndex < (this.pageList.length - 1);
  }

  // 全ページ終了イベント
  finishAllPages() {
    this.finishedAllPages = true;
    if(window.debug) {
      return console.log('Finish All Pages!!!');
    }
  }
}
