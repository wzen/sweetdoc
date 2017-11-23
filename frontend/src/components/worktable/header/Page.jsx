import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class Page extends BaseComponent {
  static divider() {
    return <li className='divider'/>;
  }
  pageMenu() {
      let forkNum, pageNum, pagePrefix;
      const pageCount = this.props.pageCount;
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

  selectPage() {
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
    if(pageNum !== null) {
      return this.selectPage(pageNum, forkNum);
    } else {
      return Common.hideModalView();
    }
  }

  render() {
    const {t} = this.props;
    let pageList = [];
    if (this.props.pages && this.props.pages.length > 0) {
      pageList.push();
    }

    return (
      <li>
        <a className="dropdown-toggle" data-toggle="dropdown" href="#header-pageing">
          <span />
          <b className="caret"/>
        </a>
        <ul className="dropdown-menu" role="menu">
          {this.pageMenu()}
        </ul>
      </li>
    )
  }
}

export default translate()(Page);