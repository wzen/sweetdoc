import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

export default translate()(class Page extends BaseComponent {
  static divider = () => <li className='divider'/>;

  pageMenu() {
    const {t} = this.props;
    let li = [];
    this.props.page.forEach((p, idx) => {
      let pageNum = idx + 1;
      let active = this.props.currentForkNum === 0;
      let subLi = [
        <li className={active ? 'active' : ''}>
          <a className='menu-item'
             onClick={e => {
               e.preventDefault();
               this.props.selectPage(pageNum, p);
             }}>
            {t('header_menu.page.master')}
            </a>
        </li>
      ];
      if(p > 0) {
        for(i = 1; i <= p; i++) {
          let active = this.props.currentForkNum === i;
          subLi.push(
            <li className={active ? 'active' : ''}>
              <a className='menu-item' onClick={e => {
                e.preventDefault();
                this.props.selectPage(pageNum, i);
              }}>
                {`${t('header_menu.page.fork')} ${i}`}
                </a>
            </li>
          )
        }
      }
      if(pageNum === this.props.currentPageNum) {
        subLi.push(Page.divider());
        subLi.push(
          <li>
            <a className='menu-item'
               onClick={e => {
                 e.preventDefault();
                 this.props.addFork(pageNum);
               }}>
              {t('header_menu.page.add_fork')}
              </a>
          </li>
        )
      }
      if(pageNum > 1) {
        // ページ１以外は削除メニュー追加
        subLi.push(Page.divider());
        subLi.push(
          <li>
            <a className='menu-item'
               onClick={e => {
                 e.preventDefault();
                 this.props.removePage(pageNum);
               }}>
              {t('header_menu.page.delete_page')}
            </a>
          </li>
        );
      }
      li.push(
        <li className="dropdown-submenu">
          <a>{`${t('header_menu.page.page')} ${pageNum}`}</a>
          <ul className="dropdown-menu">
            {subLi}
          </ul>
        </li>
      )
    });
    li.push(Page.divider());
    li.push(
      <li>
        <a className='menu-item'
           onClick={e => {
             e.preventDefault();
             this.props.addPage();
           }}>
          {t('header_menu.page.add_page')}</a>
      </li>
    );
    return li;
  }

  render() {
    const {t} = this.props;
    let pageList = [];
    if (this.props.pages && this.props.pages.length > 0) {
      pageList.push();
    }
    let nowMenuName = `${t('header_menu.page.page')} ${this.props.currentPageNum}`;
    if(this.props.currentForkNum > 0) {
      const name = `${t('header_menu.page.fork')} ${this.props.currentForkNum}`;
      nowMenuName += ` - (${name})`;
    }
    return (
      <li>
        <a className="dropdown-toggle" data-toggle="dropdown" href="#header-pageing">
          <span>{nowMenuName}</span>
          <b className="caret"/>
        </a>
        <ul className="dropdown-menu" role="menu">
          {this.pageMenu()}
        </ul>
      </li>
    )
  }
})
