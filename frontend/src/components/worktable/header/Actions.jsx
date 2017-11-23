import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class Actions extends BaseComponent {
  render() {
    const {t} = this.props;
    let preloadItemList = [];
    if(this.props.preloadItems.length > 0) {
      this.props.preloadItems.forEach(item => {
        preloadItemList.push(
          <li>
            <a
              onClick={e => {
                e.preventDefault();
                this.props.selectItem(item.distToken);
              }}
              className="menu-item">
              {item.title}
            </a>
          </li>
        );
      })
    } else {
      preloadItemList = <li><a className="menu-item">No item</a></li>
    }
    let usingItemList = [];
    if(this.props.usingItems.length > 0) {
      this.props.usingItems.forEach(item => {
        usingItemList.push(
          <li>
            <a
              onClick={e => {
                e.preventDefault();
                this.props.selectItem(item.galleryAccessToken);
              }}
               className="menu-item">
              {item.title}
            </a>
          </li>
        )
      })
    } else {
      usingItemList = <li><a className="menu-item">No item</a></li>
    }
    let codingMenuParams = this.props.userSignin ? {href: '/coding/item'} : {href: '', disabled: 'disabled'};

    return (
      <li id="header_items_select_menu">
        <a className="dropdown-toggle" data-toggle="dropdown" href="#header_items_select_menu">
          <span id="header_items_selected_menu_span">{t('header_menu.action.select_action')}</span>
          <b className="caret"/>
        </a>
        <ul className="dropdown-menu" role="menu">
          <li className="dropdown-header">{t('header_menu.action.draw.draw')}</li>
          <li className="dropdown-submenu">
            <a className="menu-load">{t('header_menu.action.preload_item')}</a>
            <ul className="dropdown-menu">
              {preloadItemList}
            </ul>
          </li>
          <li className="dropdown-submenu">
            <a className="menu-load">{t('header_menu.action.added_item')}</a>
            <ul className="dropdown-menu">
              {usingItemList}
            </ul>
          </li>
          <li className="divider"/>
          <li>
            <a onClick={e => {
              e.preventDefault();
              this.props.changeModeEdit()}}
               className="menu-item">
              {t('header_menu.action.edit')}
            </a>
          </li>
          <li className="divider"/>
          <li>
            <a onClick={e => {
              e.preventDefault();
              this.props.showItemGalleryPage()}}
               className="menu-item href" href="/app/assets/stylesheets/item_gallery">
              <div className="icon">
              </div>
              <div>
                {t('header_menu.action.item_gallery')}
              </div>
            </a>
          </li>
          <li className={this.props.userSignin ? '' : 'disabled'}>
            <a onClick={e => {
              e.preventDefault();
              this.props.showCodingPage()}}
               className="menu-item href" {...codingMenuParams}>
              <div className="icon">
              </div>
              <div>
                {t('header_menu.action.item_coding')}
              </div>
            </a>
          </li>
        </ul>
      </li>
    )
  }
}

export default translate()(Actions);