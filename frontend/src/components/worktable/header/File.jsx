import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

export default translate()(class File extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <li id="header_items_file_menu">
        <a className="dropdown-toggle" data-toggle="dropdown" href="#header_items_file_menu">
          {t('header_menu.file.file')}
          <b className="caret"/>
        </a>
        <ul className="dropdown-menu" role="menu">
          <li><a onClick={e => {e.preventDefault(); this.props.showCreateProjectModal()}} className="menu-changeproject">{t('header_menu.file.changeproject')}</a></li>
          <li><a onClick={e => {e.preventDefault(); this.props.showManegeProjectModal()}} className="menu-adminproject">{t('header_menu.file.adminproject')}</a></li>
          <li className="menu-save-li"><a onClick={e => {e.preventDefault(); this.props.saveProject()}} className="menu-save">{t('header_menu.file.save')}</a></li>
        </ul>
      </li>
    )
  }
})
