/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS202: Simplify dynamic range loops
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Paging {

  // 初期化処理
  static initPaging() {
    return this.createPageSelectMenu();
  }

  // 選択メニュー作成
  static createPageSelectMenu() {
    let forkNum, pageNum, pagePrefix;
    const pageCount = PageValue.getPageCount();
    const root = $(`#${constant.Paging.NAV_ROOT_ID}`);
    const selectRoot = $(`.${constant.Paging.NAV_SELECT_ROOT_CLASS}`, root);

    // ページ選択メニュー
    const divider = "<li class='divider'></li>";
    const newPageMenu = `<li><a class='${Constant.Paging.NAV_MENU_ADDPAGE_CLASS} menu-item'>${I18n.t('header_menu.page.add_page')}</a></li>`;
    const newForkMenu = `<li><a class='${Constant.Paging.NAV_MENU_ADDFORK_CLASS} menu-item'>${I18n.t('header_menu.page.add_fork')}</a></li>`;
    let pageMenu = '';
    for(let i = 1, end = pageCount, asc = 1 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
      const navPageClass = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', i);
      const navPageName = `${I18n.t('header_menu.page.page')} ${i}`;
      const deletePageMenu = `<li><a class='${navPageClass} ${Constant.Paging.NAV_MENU_DELETEPAGE_CLASS} menu-item'>${I18n.t('header_menu.page.delete_page')}</a></li>`;

      // サブ選択メニュー
      const forkCount = PageValue.getForkCount(i);
      forkNum = PageValue.getForkNum(i);
      const active = forkNum === PageValue.Key.EF_MASTER_FORKNUM ? 'class="active"' : '';
      let subMenu = `<li ${active}><a class='${navPageClass} menu-item '>${I18n.t('header_menu.page.master')}</a></li>`;
      if(forkCount > 0) {
        for(let j = 1, end1 = forkCount, asc1 = 1 <= end1; asc1 ? j <= end1 : j >= end1; asc1 ? j++ : j--) {
          const navForkClass = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', j);
          const navForkName = `${I18n.t('header_menu.page.fork')} ${j}`;
          const subActive = j === forkNum ? 'class="active"' : '';
          subMenu += `\
<li ${subActive}><a class='${navPageClass} ${navForkClass} menu-item '>${navForkName}</a></li>\
`;
        }
      }
      if(i === PageValue.getPageNum()) {
        subMenu += divider + newForkMenu;
      }
      if(i > 1) {
        // ページ１以外は削除メニュー追加
        subMenu += divider + deletePageMenu;
      }
      pageMenu += `\
<li class="dropdown-submenu">
    <a>${navPageName}</a>
    <ul class="dropdown-menu">
        ${subMenu}
    </ul>
</li>\
`;
    }
    pageMenu += divider + newPageMenu;
    selectRoot.children().remove();
    $(pageMenu).appendTo(selectRoot);

    // 現在のページ
    let nowMenuName = `${I18n.t('header_menu.page.page')} ${PageValue.getPageNum()}`;
    if(PageValue.getForkNum() > 0) {
      const name = `${I18n.t('header_menu.page.fork')} ${PageValue.getForkNum()}`;
      nowMenuName += ` - (${name})`;
    }
    $(`.${constant.Paging.NAV_SELECTED_CLASS}`, root).html(nowMenuName);

    // イベント設定
    selectRoot.find(".menu-item").off('click').on('click', e => {
      Common.hideModalView(true);
      Common.showModalFlashMessage('Changing...');
      pagePrefix = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', '');
      const forkPrefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '');
      pageNum = null;
      forkNum = PageValue.Key.EF_MASTER_FORKNUM;
      const classList = $(e.target).attr('class').split(' ');
      classList.forEach(function(c) {
        if(c.indexOf(pagePrefix) >= 0) {
          return pageNum = parseInt(c.replace(pagePrefix, ''));
        } else if(c.indexOf(forkPrefix) >= 0) {
          return forkNum = parseInt(c.replace(forkPrefix, ''));
        }
      });
      if(pageNum != null) {
        return this.selectPage(pageNum, forkNum);
      } else {
        return Common.hideModalView();
      }
    });

    selectRoot.find(`.${Constant.Paging.NAV_MENU_ADDPAGE_CLASS}`, root).off('click').on('click', () => {
      return this.createNewPage();
    });
    selectRoot.find(`.${Constant.Paging.NAV_MENU_ADDFORK_CLASS}`, root).off('click').on('click', () => {
      return this.createNewFork();
    });
    return selectRoot.find(`.${Constant.Paging.NAV_MENU_DELETEPAGE_CLASS}`, root).off('click').on('click', e => {
      if(window.confirm(I18n.t('message.dialog.delete_page'))) {
        pagePrefix = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', '');
        const page = $.grep($(e.target).attr('class').split(' '), n => n.indexOf(pagePrefix) >= 0)[0];
        pageNum = parseInt(page.replace(pagePrefix, ''));
        return this.removePage(pageNum);
      }
    });
  }

  // 表示ページ切り替え
  // @param [Integer] pageNum 変更ページ番号
  static switchSectionDisplay(pageNum) {
    $(`#${constant.Paging.ROOT_ID}`).find(".section").hide();
    const className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
    const section = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
    return section.show();
  }

  // ページ追加作成
  static createNewPage() {
    Common.hideModalView(true);
    Common.showModalFlashMessage('Creating...');
    const beforePageNum = PageValue.getPageNum();
    if(window.debug) {
      console.log(`[createNewPage] beforePageNum:${beforePageNum}`);
    }

    Sidebar.closeSidebar();
    // WebStorageのアイテム&イベント情報を消去
    window.lStorage.clearWorktableWithoutSetting();
    EventConfig.removeAllConfig();
    // Mainコンテナ作成
    const created = Common.createdMainContainerIfNeeded(PageValue.getPageCount() + 1);
    // ページ番号更新
    PageValue.setPageNum(PageValue.getPageCount() + 1);
    // 新規コンテナ初期化
    WorktableCommon.initMainContainer();
    PageValue.adjustInstanceAndEventOnPage();
    return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(() => {
      // 共通イベントのインスタンス作成
      WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded();
      // 作成ページのモード設定
      WorktableCommon.changeMode(window.mode);
      // タイムライン更新
      Timeline.refreshAllTimeline();
      // ページ表示変更
      let className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
      const newSection = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
      newSection.show();
      className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
      const oldSection = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
      oldSection.hide();
      Common.removeAllItem(beforePageNum);
      // ページ総数 & フォーク総数の更新
      PageValue.setEventPageValue(PageValue.Key.eventCount(), 0);
      PageValue.updatePageCount();
      // 画面倍率は作成前ページと同じにする
      WorktableCommon.setWorktableViewScale(WorktableCommon.getWorktableViewScale(beforePageNum), true);
      // 表示位置を戻す
      WorktableCommon.initScrollContentsPosition();
      if(created) {
        // 履歴に画面初期時状態を保存
        OperationHistory.add(true);
      }
      // キャッシュ保存
      window.lStorage.saveAllPageValues();
      // 選択メニューの更新
      this.createPageSelectMenu();
      // モーダルを削除
      return Common.hideModalView();
    });
  }

  // ページ選択
  // @param [Integer] selectedNum 選択ページ番号
  // @param [Integer] selectedNum 選択フォーク番号
  static selectPage(selectedPageNum, selectedForkNum, callback = null) {
    if(selectedForkNum == null) {
      selectedForkNum = PageValue.Key.EF_MASTER_FORKNUM;
    }
    if(selectedPageNum === PageValue.getPageNum()) {
      if(selectedForkNum === PageValue.getForkNum()) {
        // 同じページ & 同じフォークの場合は変更しない
        Common.hideModalView();
        if(callback != null) {
          callback();
        }
        return;
      } else {
        this.selectFork(selectedForkNum, () => {
          // タイムライン更新
          Timeline.refreshAllTimeline();
          // キャッシュ保存
          window.lStorage.saveAllPageValues();
          // 選択メニューの更新
          this.createPageSelectMenu();
          // モーダルを削除
          Common.hideModalView();
          if(callback != null) {
            return callback();
          }
        });
        return;
      }
    }
    if(window.debug) {
      console.log(`[selectPage] selectedNum:${selectedPageNum}`);
    }
    if(selectedPageNum <= 0) {
      if(callback != null) {
        callback();
      }
      return;
    }
    const pageCount = PageValue.getPageCount();
    if((selectedPageNum < 0) || (selectedPageNum > pageCount)) {
      if(callback != null) {
        callback();
      }
      return;
    }
    const beforePageNum = PageValue.getPageNum();
    if(window.debug) {
      console.log(`[selectPage] beforePageNum:${beforePageNum}`);
    }
    Sidebar.closeSidebar();
    // WebStorageのアイテム&イベント情報を消去
    window.lStorage.clearWorktableWithoutSetting();
    EventConfig.removeAllConfig();
    // Mainコンテナ作成
    const created = Common.createdMainContainerIfNeeded(selectedPageNum, false);
    // ページ番号更新
    PageValue.setPageNum(selectedPageNum);
    // 新規コンテナ初期化
    WorktableCommon.initMainContainer();
    PageValue.adjustInstanceAndEventOnPage();
    return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(() => {
      // フォーク内容反映
      return Paging.selectFork(selectedForkNum, () => {
        // ページ変更後のモード設定
        WorktableCommon.changeMode(window.mode, selectedPageNum);
        // タイムライン更新
        Timeline.refreshAllTimeline();
        let className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', selectedPageNum);
        const newSection = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
        newSection.show();
        // 隠したビューを非表示にする
        className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum);
        const oldSection = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
        oldSection.hide();
        if(window.debug) {
          console.log(`[selectPage] deleted pageNum:${beforePageNum}`);
        }
        // 隠したビューのアイテムを削除(インスタンスは消さない)
        Common.removeAllItem(beforePageNum, false);
        if(created) {
          // 履歴に画面初期時状態を保存
          OperationHistory.add(true);
        }
        // キャッシュ保存
        window.lStorage.saveAllPageValues();
        // 選択メニューの更新
        this.createPageSelectMenu();
        // モーダルを削除
        Common.hideModalView();
        if(callback != null) {
          return callback();
        }
      });
    });
  }

  // フォーク追加作成
  static createNewFork() {
    // フォーク番号更新
    PageValue.setForkNum(PageValue.getForkCount() + 1);
    // フォーク総数更新
    PageValue.setEventPageValue(PageValue.Key.eventCount(), 0);
    PageValue.updateForkCount();
    // 履歴に画面初期時状態を保存
    OperationHistory.add(true);
    // キャッシュ保存
    window.lStorage.saveAllPageValues();
    // 選択メニューの更新
    this.createPageSelectMenu();
    // タイムライン更新
    return Timeline.refreshAllTimeline();
  }

  // フォーク選択
  // @param [Integer] selectedForkNum 選択フォーク番号
  // @param [Function] コールバック
  static selectFork(selectedForkNum, callback = null) {
    if((selectedForkNum == null) || (selectedForkNum === PageValue.getForkNum())) {
      // フォーク番号が同じ場合は処理なし
      if(callback != null) {
        callback();
      }
      return;
    }

    // フォーク番号更新
    PageValue.setForkNum(selectedForkNum);
    if(selectedForkNum === PageValue.Key.EF_MASTER_FORKNUM) {
      // Masterに変更する場合
      // とりあえず何もしない
      if(callback != null) {
        return callback();
      }
    } else {
      // Forkに変更
      // フォークのアイテムを描画
      return WorktableCommon.createAllInstanceAndDrawFromInstancePageValue(function() {
        if(callback != null) {
          return callback();
        }
      });
    }
  }

  static removePage(pageNum, callback = null) {
    if(pageNum <= 1) {
      // 1ページ目は消去しない
      if(callback != null) {
        callback();
      }
      return;
    }

    const _removePage = function(pageNum) {
      // ページを削除
      return WorktableCommon.removePage(pageNum, () => {
        window.lStorage.saveAllPageValues();
        // 選択メニューの更新
        this.createPageSelectMenu();
        if(callback != null) {
          return callback();
        }
      });
    };

    if(pageNum === PageValue.getPageNum()) {
      // 現在のページの場合は前ページに変更
      return this.selectPage(pageNum - 1, PageValue.Key.EF_MASTER_FORKNUM, () => {
        return _removePage.call(this, pageNum);
      });
    } else {
      return _removePage.call(this, pageNum);
    }
  }

  static removeFork(forkNum, callback = null) {
  }
}

// TODO: 実装する
//    _removeFork = ->
//
//    if forkNum == PageValue.getForkNum()
//      @selectFork(selectedForkNum, callback = null) ->

