import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class Others extends BaseComponent {
  render() {
    const {t} = this.props;
    let langList = [];
    if(this.props.langs && this.props.langs.length > 0) {
      this.props.langs.forEach(lang => {
        langList.push(
          <li className={lang.locale === window.locale ? 'active':'' }>
            <a onClick={e => {e.preventDefault(); this.props.switchLang(lang.locale)}} className="menu-item" href="#">
              {lang.locale_name}
            </a>
          </li>
        )
      })
    }
    return (
      <li id="header_etc_select_menu">
        <a className="dropdown-toggle" data-toggle="dropdown" href="#header_etc_select_menu">
          {t('header_menu.etc.etc')}
          <b className="caret" />
        </a>
        <ul className="dropdown-menu" role="menu">
          <li className="dropdown-submenu">
            <a>{t('header_menu.etc.language')}</a>
            <ul className="dropdown-menu">
              {langList}
            </ul>
          </li>
          <li className="divider" />
          <li><a onClick={e => {e.preventDefault(); this.props.showAboutModal()}} className="menu-about">{t('header_menu.etc.about')}</a></li>
          <li className="divider" />
          <li><a onClick={e => {e.preventDefault(); this.props.showGalleryPage()}} className="menu-backtomainpage">{t('header_menu.etc.back_to_gallery')}</a></li>
        </ul>
      </li>
    )
  }
}

export default translate()(Others);