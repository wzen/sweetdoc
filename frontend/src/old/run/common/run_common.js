import Common from '../../base/common';
import CommonVar from '../../base/common_var';
import Navbar from '../../navbar/navbar';
import PageValue from '../../base/page_value';
import GalleryCommon from '../../gallery/gallery_common';
import EventAction from '../event_action';

let constant = undefined;
export default class RunCommon {
  static initClass() {
    // 定数
    constant = gon.const;
    // @property [String] RUN_CSS CSSスタイルRoot
    this.RUN_CSS = constant.ElementAttribute.RUN_CSS;

    let Cls = (this.AttributeName = class AttributeName {
      static initClass() {
        this.CONTENTS_CREATOR_CLASSNAME = constant.Run.AttributeName.CONTENTS_CREATOR_CLASSNAME;
        this.CONTENTS_TITLE_CLASSNAME = constant.Run.AttributeName.CONTENTS_TITLE_CLASSNAME;
        this.CONTENTS_CAPTION_CLASSNAME = constant.Run.AttributeName.CONTENTS_CAPTION_CLASSNAME;
        this.CONTENTS_PAGE_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_PAGE_NUM_CLASSNAME;
        this.CONTENTS_PAGE_MAX_CLASSNAME = constant.Run.AttributeName.CONTENTS_PAGE_MAX_CLASSNAME;
        this.CONTENTS_CHAPTER_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_CHAPTER_NUM_CLASSNAME;
        this.CONTENTS_CHAPTER_MAX_CLASSNAME = constant.Run.AttributeName.CONTENTS_CHAPTER_MAX_CLASSNAME;
        this.CONTENTS_FORK_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_FORK_NUM_CLASSNAME;
        this.CONTENTS_TAGS_CLASSNAME = constant.Run.AttributeName.CONTENTS_TAGS_CLASSNAME;
      }
    });
    Cls.initClass();
    Cls = (this.Key = class Key {
      static initClass() {
        this.TARGET_PAGES = constant.Run.Key.TARGET_PAGES;
        this.LOADED_CLASS_DIST_TOKENS = constant.Run.Key.LOADED_CLASS_DIST_TOKENS;
        this.PROJECT_ID = constant.Run.Key.PROJECT_ID;
        this.ACCESS_TOKEN = constant.Run.Key.ACCESS_TOKEN;
        this.RUNNING_USER_PAGEVALUE_ID = constant.Run.Key.RUNNING_USER_PAGEVALUE_ID;
        this.FOOTPRINT_PAGE_VALUE = constant.Run.Key.FOOTPRINT_PAGE_VALUE;
        this.LOAD_FOOTPRINT = constant.Run.Key.LOAD_FOOTPRINT;
      }
    });
    Cls.initClass();
  }

  // 画面初期化
  static initView() {
    // Canvasサイズ設定
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width());
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height());
    // 暫定でスクロールを上に持ってくる
    window.scrollHandleWrapper.css('pointer-events', '');
    // スクロールビューの大きさ
    scrollInsideWrapper.width(window.scrollViewSize);
    scrollInsideWrapper.height(window.scrollViewSize);
    scrollInsideCover.width(window.scrollViewSize);
    scrollInsideCover.height(window.scrollViewSize);
    scrollHandle.width(window.scrollViewSize);
    scrollHandle.height(window.scrollViewSize);
    this.initHandleScrollView();
    return Common.initScrollContentsPosition();
  }

  // Mainビューのサイズ更新
  static updateMainViewSize() {
    if(!Common.isFixedScreenSize()) {
      // 画面指定しない場合は ビューの倍率1.0 & projectサイズ指定なし
      window.runScaleFromViewRate = 1.0;
      $('#project_wrapper').removeAttr('style');
    } else {
      // mainビュー高さ修正
      let scaleFromViewRate;
      const contentsWidth = $('#contents').width();
      const contentsHeight = $('#contents').height();
      // スクリーンサイズ修正
      const projectScreenSize = Common.getScreenSize();
      const updatedProjectScreenSize = $.extend(true, {}, projectScreenSize);
      let widthPadding = 30;
      if($('#project_wrapper').hasClass('fullscreen')) {
        widthPadding = 0;
      }
      let heightPadding = 10;
      if($('#project_wrapper').hasClass('fullscreen')) {
        heightPadding = 0;
      }
      // Paddingを考慮して比較
      if(contentsWidth < (projectScreenSize.width + widthPadding)) {
        // 縮小
        updatedProjectScreenSize.width = contentsWidth - widthPadding;
      }
      if(contentsHeight < (projectScreenSize.height + heightPadding)) {
        // 縮小
        updatedProjectScreenSize.height = contentsHeight - heightPadding;
      }

      // BaseScale 修正
      const widthRate = updatedProjectScreenSize.width / projectScreenSize.width;
      const heightRate = updatedProjectScreenSize.height / projectScreenSize.height;
      if(widthRate < heightRate) {
        scaleFromViewRate = widthRate;
      } else {
        scaleFromViewRate = heightRate;
      }
      if(scaleFromViewRate === 0.0) {
        scaleFromViewRate = 0.01;
      }
      window.runScaleFromViewRate = scaleFromViewRate;
      updatedProjectScreenSize.width = projectScreenSize.width * scaleFromViewRate;
      updatedProjectScreenSize.height = projectScreenSize.height * scaleFromViewRate;
      $('#project_wrapper').css({width: updatedProjectScreenSize.width, height: updatedProjectScreenSize.height});
      Common.applyViewScale();
    }
    return Common.saveMainWrapperSize();
  }

  // 画面リサイズイベント
  static resizeMainContainerEvent() {
    const beforeMainWrapperSize = window.mainWrapperSize;
    this.updateMainViewSize();
    Common.updateCanvasSize();
    if(!Common.isFixedScreenSize()) {
      // 画面指定なしの場合はビュー倍率が1.0固定のためスクロール位置修正
      const nowMainWrapperSize = {width: window.mainWrapper.width(), height: window.mainWrapper.height()};
      return this.adjustScrollPositionWhenScreenSizeChanging(beforeMainWrapperSize, nowMainWrapperSize);
    }
  }

  static adjustScrollPositionWhenScreenSizeChanging(beforeSize, afterSize) {
    const scale = Common.getViewScale();
    const diff = {
      width: ((beforeSize.width - afterSize.width) * 0.5) / scale,
      height: ((beforeSize.height - afterSize.height) * 0.5) / scale
    };
    // 小数点を切り上げor切り下げ
    diff.width = diff.width >= 0 ? Math.ceil(diff.width) : Math.floor(diff.width);
    diff.height = diff.height >= 0 ? Math.ceil(diff.height) : Math.floor(diff.height);
    window.scrollContents.scrollTop(window.scrollContents.scrollTop() + diff.height);
    return window.scrollContents.scrollLeft(window.scrollContents.scrollLeft() + diff.width);
  }

  // ウィンドウリサイズイベント
  static resizeEvent() {
    if((window.skipResizeEvent !== null) && window.skipResizeEvent) {
      return window.skipResizeEvent = false;
    } else {
      return RunCommon.resizeMainContainerEvent();
    }
  }

  // 詳細情報を表示
  static showCreatorInfo() {
    const info = $('#contents').find('.contents_info:first');
    const operation = $('#contents').find('.operation_parent:first');
    const share = $('#contents').find('.share_info:first');
    const bookmark = $('#contents').find('.bookmark_input:first');

    // Markdownを設定
    Common.markdownToHtml();

    const _setClose = () =>
      // ビュークリックで非表示
      $('#contents').off('click.contents_info').on('click.contents_info', function(e) {
        if(info.is(':visible')) {
          e.preventDefault();
          e.stopPropagation();
          operation.fadeOut({duration: '200', queue: false});
          info.fadeOut({duration: '200', queue: false});
          $('#contents').off('click.contents_info');
        }
        if(share.is(':visible')) {
          share.fadeOut('200');
        }
        if(bookmark.is(':visible')) {
          return bookmark.fadeOut('200');
        }
      })
    ;

    info.fadeIn('500', function() {
      // ビュークリックで非表示
      _setClose.call(this);
      return setTimeout(() => info.fadeOut('500')
        , 3000);
    });
    // iボタンで情報表示
    $('#contents .contents_info_show_button:first').off('click').on('click', e => {
      if(!info.is(':visible')) {
        e.preventDefault();
        e.stopPropagation();
        operation.fadeIn({duration: '200', queue: false});
        return info.fadeIn({
          duration: '200', queue: false, complete: () => {
            // ビュークリックで非表示
            return _setClose.call(this);
          }
        });
      }
    });
    if(!window.isMotionCheck) {
      // ブックマークボタン
      $('#contents .bookmark_button:first').off('click').on('click', e => {
        e.preventDefault();
        e.stopPropagation();
        const bookmarkButtonWrapper = $(e.target).closest('.bookmark_button');
        if(bookmarkButtonWrapper.find('.bookmarked:visible').length === 0) {
          // ブックマークなし
          if(!bookmark.is(':visible')) {
            bookmark.find('textarea.note').val('');
            bookmark.find('textarea, input').off('click.close').on('click.close', function(ee) {
              // テキストエリア選択でビューを閉じさせない
              ee.preventDefault();
              return ee.stopPropagation();
            });
            return bookmark.fadeIn('200', () => {
              _setClose.call(this);
              return bookmark.find('.post_button:first').off('click').on('click', ee => {
                ee.preventDefault();
                ee.stopPropagation();
                Common.showModalFlashMessage('Please wait...');
                return GalleryCommon.addBookmark(bookmark.find('textarea.note').val(), result => {
                  if(result) {
                    bookmarkButtonWrapper.find('.bookmarked').show();
                    bookmarkButtonWrapper.find('.bookmark').hide();
                    bookmark.fadeOut('200');
                  }
                  return Common.hideModalView();
                });
              });
            });
          }
        } else {
          // ブックマーク済み
          if(window.confirm(I18n.t('message.dialog.change_project'))) {
            Common.showModalFlashMessage('Please wait...');
            return GalleryCommon.removeBookmark(result => {
              if(result) {
                bookmarkButtonWrapper.find('.bookmarked').hide();
                bookmarkButtonWrapper.find('.bookmark').show();
                return Common.hideModalView();
              }
            });
          }
        }
      });
      // Share情報表示
      $('#contents .contents_share_show_button:first').off('click').on('click', e => {
        if(!share.is(':visible')) {
          e.preventDefault();
          e.stopPropagation();
          return share.fadeIn('200', () => {
            return _setClose.call(this);
          });
        }
      });
      return share.find('textarea, input').off('click.close').on('click.close', function(e) {
        // テキストエリア選択でビューを閉じない & 選択状態に
        e.preventDefault();
        e.stopPropagation();
        return $(this).select();
      });
    }
  }

  // イベント作成
  static initEventAction() {
    // アクションのイベントを取得
    const pageCount = PageValue.getPageCount();
    const pageNum = PageValue.getPageNum();
    const pageList = new Array(pageCount);
    for(let i = 1, end = pageCount, asc = 1 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
      if(i === parseInt(pageNum)) {
        // 初期表示ページのみ作成。ページング時に追加作成する。
        const forkEventPageValueList = {};
        for(let j = 0, end1 = PageValue.getForkCount(), asc1 = 0 <= end1; asc1 ? j <= end1 : j >= end1; asc1 ? j++ : j--) {
          forkEventPageValueList[j] = PageValue.getEventPageValueSortedListByNum(j, i);
        }
        const page = new Page({
          forks: forkEventPageValueList
        });
        pageList[i - 1] = page;
      } else {
        pageList[i - 1] = null;
      }
    }

    // ナビバーのページ数 & チャプター数設定
    RunCommon.setPageMax(pageCount);
    // アクション作成
    window.eventAction = new EventAction(pageList, PageValue.getPageNum() - 1);
    return window.eventAction.start();
  }

  // 操作ボタンイベント初期化
  static initOperationEvent() {
    const operationWrapper = $('.operation_wrapper');
    operationWrapper.find('.rewind_all_capter').off('click').on('click', e => {
      if(window.eventAction !== null) {
        e.preventDefault();
        e.stopPropagation();
        window.eventAction.thisPage().rewindAllChapters();
        if($(e.target).closest('.info_contents') !== null) {
          // ポップアップで実行の場合はポップアップ非表示
          return RunFullScreen.hidePopupInfo();
        }
      }
    });
    return operationWrapper.find('.rewind_capter').off('click').on('click', e => {
      if(window.eventAction !== null) {
        e.preventDefault();
        e.stopPropagation();
        window.eventAction.thisPage().rewindChapter();
        if($(e.target).closest('.info_contents') !== null) {
          // ポップアップで実行の場合はポップアップ非表示
          return RunFullScreen.hidePopupInfo();
        }
      }
    });
  }

  // Handleスクロールビューの初期化
  static initHandleScrollView(withSetupScrollEvent) {
    // スクロール位置初期化
    if(withSetupScrollEvent === null) {
      withSetupScrollEvent = true;
    }
    window.skipScrollEvent = true;
    window.scrollHandleWrapper.scrollLeft(window.scrollHandle.width() * 0.5);
    window.scrollHandleWrapper.scrollTop(window.scrollHandle.height() * 0.5);
    if(withSetupScrollEvent) {
      // スクロールイベント設定
      return this.setupScrollEvent();
    }
  }

  // スクロールイベントの初期化
  static setupScrollEvent() {
    window.lastLeft = window.scrollHandleWrapper.scrollLeft();
    window.lastTop = window.scrollHandleWrapper.scrollTop();
    return window.scrollHandleWrapper.off('scroll').on('scroll', e => {
      e.preventDefault();
      e.stopPropagation();
      const target = $(e.target);
      const x = target.scrollLeft();
      const y = target.scrollTop();
      if(((window.scrollRunning !== null) && window.scrollRunning) || !RunCommon.enabledScroll()) {
        // 動作中はイベント無視
        return;
      }
      if((window.skipScrollEvent !== null) && window.skipScrollEvent) {
        window.skipScrollEvent = false;
        return;
      }

      const distX = x - window.lastLeft;
      const distY = y - window.lastTop;
      //console.log('distX:' + distX + ' distY:' + distY)
      window.scrollRunning = true;
      if(window.scrollRunningTimer !== null) {
        clearTimeout(window.scrollRunningTimer);
        window.scrollRunningTimer = null;
      }
      window.scrollRunningTimer = setTimeout(() => {
          window.scrollRunning = true;
          RunCommon.initHandleScrollView(false);
          window.lastLeft = window.scrollHandleWrapper.scrollLeft();
          window.lastTop = window.scrollHandleWrapper.scrollTop();
          clearTimeout(window.scrollRunningTimer);
          window.scrollRunningTimer = null;
          return window.scrollRunning = false;
        }
        , 3000);
      window.eventAction.thisPage().handleScrollEvent(distX, distY);
      window.lastLeft = window.scrollHandleWrapper.scrollLeft();
      window.lastTop = window.scrollHandleWrapper.scrollTop();
      return window.scrollRunning = false;
    });
  }

  // スクロールが有効の状態か判定
  // @return [Boolena] 判定結果
  static enabledScroll() {
    let ret = false;
    if((window.eventAction !== null) &&
      (window.eventAction.thisPage() !== null) &&
      (window.eventAction.thisPage().finishedAllChapters || ((window.eventAction.thisPage().thisChapter() !== null) && window.eventAction.thisPage().isScrollChapter()))) {
      ret = true;
    }
    return ret;
  }

  // 対象ページのPageValueデータを読み込み
  // @param [Integer] loadPageNum 読み込むページ番号
  // @param [Function] callback コールバック
  // @param [Boolean] forceUpdate 既存データを上書きするか
  static loadPagingPageValue(loadPageNum, doLoadFootprint, callback = null, forceUpdate) {
    if(doLoadFootprint === null) {
      doLoadFootprint = false;
    }
    if(forceUpdate === null) {
      forceUpdate = false;
    }
    const lastPageNum = loadPageNum + Constant.Paging.PRELOAD_PAGEVALUE_NUM;
    const targetPages = [];
    for(let i = loadPageNum, end = lastPageNum, asc = loadPageNum <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
      if(forceUpdate) {
        targetPages.push(i);
      } else {
        const className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', i);
        const section = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
        if((section === null) || (section.length === 0)) {
          targetPages.push(i);
        }
      }
    }

    if(targetPages.length === 0) {
      if(callback !== null) {
        callback();
      }
      return;
    }

    const data = {};
    data[RunCommon.Key.TARGET_PAGES] = targetPages;
    data[RunCommon.Key.LOADED_CLASS_DIST_TOKENS] = JSON.stringify(PageValue.getLoadedclassDistTokens());
    data[RunCommon.Key.ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl();
    data[RunCommon.Key.RUNNING_USER_PAGEVALUE_ID] = PageValue.getGeneralPageValue(PageValue.Key.RUNNING_USER_PAGEVALUE_ID);
    if(window.isMotionCheck && doLoadFootprint) {
      // 動作確認の場合はLocalStorageから操作履歴を取得
      data[RunCommon.Key.LOAD_FOOTPRINT] = false;
      window.lStorage.loadPagingFootprintPageValue(loadPageNum);
    } else {
      data[RunCommon.Key.LOAD_FOOTPRINT] = doLoadFootprint;
    }
    return $.ajax(
      {
        url: "/run/paging",
        type: "POST",
        dataType: "json",
        data,
        success(data) {
          if(data.resultSuccess) {
            // JSを適用
            return Common.setupJsByList(data.itemJsList, function() {
              if(data.pagevalues !== null) {
                if(data.pagevalues.general_pagevalue !== null) {
                  PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, data.pagevalues.general_pagevalue, true);
                }
                if(data.pagevalues.instance_pagevalue !== null) {
                  PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, data.pagevalues.instance_pagevalue, true);
                }
                if(data.pagevalues.event_pagevalue !== null) {
                  PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, data.pagevalues.event_pagevalue, true);
                }
                if(data.pagevalues.footprint !== null) {
                  PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, data.pagevalues.footprint, true);
                }
              }

              // コールバック
              if(callback !== null) {
                return callback();
              }
            });
          } else {
            console.log('/run/paging server error');
            return Common.ajaxError(data);
          }
        },
        error(data) {
          console.log('/run/paging ajax error');
          return Common.ajaxError(data);
        }
      }
    );
  }

  static getForkStack(pn) {
    return PageValue.getFootprintPageValue(PageValue.Key.forkStack(pn));
  }

  static setForkStack(obj, pn) {
    return PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), [obj]);
  }

  // フォーク番号スタック初期化
  // @return [Boolean] 処理正常終了か
  static initForkStack(forkNum, pn) {
    // PageValueに書き込み
    this.setForkStack({
      changedChapterIndex: 0,
      forkNum
    }, pn);
    return true;
  }

  // フォーク番号をスタックに追加
  // @return [Boolean] 処理正常終了か
  static addForkNumToStack(forkNum, cIndex, pn) {
    const lastForkNum = this.getLastForkNumFromStack(pn);
    if((lastForkNum !== null) && (lastForkNum !== forkNum)) {
      // フォーク番号追加
      const stack = this.getForkStack(pn);
      stack.push(
        {
          changedChapterIndex: cIndex,
          forkNum
        }
      );
      // PageValueに書き込み
      PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), stack);
      return true;
    } else {
      return false;
    }
  }

  // スタックから最新フォークオブジェクトを取得
  // @return [Integer] 取得値
  static getLastObjestFromStack(pn) {
    const stack = this.getForkStack(pn);
    if((stack !== null) && (stack.length > 0)) {
      return stack[stack.length - 1];
    } else {
      return null;
    }
  }

  // スタックから最新フォーク番号を取得
  // @return [Integer] 取得値
  static getLastForkNumFromStack(pn) {
    const obj = this.getLastObjestFromStack(pn);
    if(obj !== null) {
      return obj.forkNum;
    } else {
      return null;
    }
  }

  // スタックから以前のフォークオブジェクトを取得
  // @return [Integer] 取得値
  static getOneBeforeObjestFromStack(pn) {
    const stack = this.getForkStack(pn);
    if((stack !== null) && (stack.length > 1)) {
      return stack[stack.length - 2];
    } else {
      return null;
    }
  }

  // スタックから最新フォーク番号を削除
  // @return [Boolean] 処理正常終了か
  static popLastForkNumInStack(pn) {
    const stack = this.getForkStack(pn);
    stack.pop();
    // PageValueに書き込み
    PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), stack);
    return true;
  }

  // ギャラリーアップロードビュー表示処理
  static showUploadGalleryConfirm() {
    const root = $('#nav');
    $(`input[name='${constant.Gallery.Key.PROJECT_ID}']`, root).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID));
    if(Common.isFixedScreenSize()) {
      $(`input[name='${constant.Gallery.Key.SCREEN_SIZE}']`, root).val(JSON.stringify(PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)));
    }
    $(`input[name='${constant.Gallery.Key.PAGE_MAX}']`, root).val(PageValue.getPageCount());
    return document.upload_gallery_form.submit();
  }

  // Mainコンテナ初期化
  static initMainContainer() {
    CommonVar.runCommonVar();
    this.initView();
    this.initHandleScrollView();
    Common.initResize(this.resizeEvent);
    Navbar.initRunNavbar();
    Common.applyEnvironmentFromPagevalue();
    return RunCommon.updateMainViewSize();
  }

  // 作成者を設定
  // @param [Integer] value 設定値
  static setCreator(value) {
    const e = $(`.${this.AttributeName.CONTENTS_CREATOR_CLASSNAME}`);
    if(e !== null) {
      return e.html(value);
    } else {
      return e.html('');
    }
  }

  // タイトルを設定
  static setTitle(title_name) {
    if(title_name !== null) {
      const base = title_name;
      if(!window.isWorkTable) {
        title_name += '(Preview)';
      }
      $(`#${Navbar.NAVBAR_ROOT}`).find('.nav_title').html(title_name);
      let e = $(`.${this.AttributeName.CONTENTS_TITLE_CLASSNAME}`);
      if((title_name !== null) && (title_name.length > 0)) {
        document.title = title_name;
      } else {
        document.title = window.appName;
      }

      e = $(`.${this.AttributeName.CONTENTS_TITLE_CLASSNAME}`);
      if(e !== null) {
        return e.html(base);
      } else {
        return e.html('');
      }
    }
  }

  // ページ番号を設定
  // @param [Integer] value 設定値
  static setPageNum(value) {
    const e = $(`.${this.AttributeName.CONTENTS_PAGE_NUM_CLASSNAME}`);
    if(e !== null) {
      return e.html(value);
    } else {
      return e.html('');
    }
  }

  // チャプター番号を設定
  // @param [Integer] value 設定値
  static setChapterNum(value) {
    const e = $(`.${this.AttributeName.CONTENTS_CHAPTER_NUM_CLASSNAME}`);
    if(e !== null) {
      return e.html(value);
    } else {
      return e.html('');
    }
  }

  // ページ総数を設定
  // @param [Integer] page_max 設定値
  static setPageMax(page_max) {
    const e = $(`.${this.AttributeName.CONTENTS_PAGE_MAX_CLASSNAME}`);
    if(e !== null) {
      return e.html(page_max);
    } else {
      return e.html('');
    }
  }

  // チャプター総数を設定
  // @param [Integer] chapter_max 設定値
  static setChapterMax(chapter_max) {
    const e = $(`.${this.AttributeName.CONTENTS_CHAPTER_MAX_CLASSNAME}`);
    if(e !== null) {
      return e.html(chapter_max);
    } else {
      return e.html('');
    }
  }

  // フォーク番号を設定
  // @param [Integer] num 設定値
  static setForkNum(num) {
    const e = $(`.${this.AttributeName.CONTENTS_FORK_NUM_CLASSNAME}`);
    if(e !== null) {
      e.html(num);
      return e.closest('li').css('display', num > 0 ? 'block' : 'none');
    } else {
      e.html('');
      return e.closest('li').hide();
    }
  }

  // 操作履歴を保存
  static saveFootprint(callback = null) {
    if((window.isMotionCheck !== null) && window.isMotionCheck) {
      // LocalStorageに保存
      window.lStorage.saveFootprintPageValue();
      if(callback !== null) {
        return callback();
      }
    } else {
      // Serverに保存
      const data = {};
      data[RunCommon.Key.ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl();
      data[RunCommon.Key.FOOTPRINT_PAGE_VALUE] = JSON.stringify(PageValue.getFootprintPageValue(PageValue.Key.F_PREFIX));
      return $.ajax(
        {
          url: "/run/save_gallery_footprint",
          type: "POST",
          data,
          dataType: "json",
          success(data) {
            if(data.resultSuccess) {
              if(callback !== null) {
                return callback();
              }
            } else {
              console.log('/run/save_gallery_footprint server error');
              return Common.ajaxError(data);
            }
          },
          error(data) {
            console.log('/run/save_gallery_footprint ajax error');
            return Common.ajaxError(data);
          }
        }
      );
    }
  }

  // 操作履歴を読み込み
  static loadCommonFootprint(callback = null) {
    if((window.isMotionCheck !== null) && window.isMotionCheck) {
      // LocalStorageから読み込み
      window.lStorage.loadCommonFootprintPageValue();
      if(callback !== null) {
        return callback();
      }
    } else {
      // Serverから読み込み
      const data = {};
      data[RunCommon.Key.ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl();
      return $.ajax(
        {
          url: "/run/load_common_gallery_footprint",
          type: "POST",
          data,
          dataType: "json",
          success(data) {
            if(data.resultSuccess) {
              PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, data.pagevalue_data);
              if(callback !== null) {
                return callback();
              }
            } else {
              console.log('/run/load_common_gallery_footprint server error');
              return Common.ajaxError(data);
            }
          },
          error(data) {
            console.log('/run/load_common_gallery_footprint ajax error');
            return Common.ajaxError(data);
          }
        }
      );
    }
  }

  static start(useLocalStorate) {
    if(useLocalStorate === null) {
      useLocalStorate = false;
    }
    window.eventAction = null;
    window.runPage = true;
    window.initDone = false;
    window.runScaleFromViewRate = 1.0;

    // メッセージ
    Common.showModalFlashMessage('Getting ready');

    // 変数初期化
    CommonVar.initVarWhenLoadedView();
    CommonVar.initCommonVar();

    if(useLocalStorate) {
      // キャッシュ読み込み
      const is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD);
      if(is_reload !== null) {
        window.lStorage.loadAllPageValues();
      } else {
        // 1ページから開始
        PageValue.setPageNum(1);
        // footprintを初期化
        PageValue.removeAllFootprint();
        window.lStorage.saveAllPageValues();
      }
    }

    // Mainコンテナ作成
    Common.createdMainContainerIfNeeded(PageValue.getPageNum());
    // コンテナ初期化
    RunCommon.initMainContainer();

    // 必要JS読み込み
    return Common.loadJsFromInstancePageValue(function() {
      // イベント初期化
      RunCommon.initEventAction();
      // 操作ボタン初期化
      RunCommon.initOperationEvent();
      // メッセージ非表示
      Common.hideModalView();
      // 初期化終了
      return window.initDone = true;
    });
  }

  static shutdown() {
    if(window.eventAction !== null) {
      return window.eventAction.shutdown();
    }
  }
};
RunCommon.initClass();




