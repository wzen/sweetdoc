import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class Others extends Component {
  render() {
    const {t} = this.props;
    return (
      <li id="header_etc_select_menu">
        <a className="dropdown-toggle" data-toggle="dropdown" href="#header_etc_select_menu">
          {t(' header_menu.etc.etc')}
          <b className="caret"></b>
        </a>
        <ul className="dropdown-menu" role="menu">
          <li className="dropdown-submenu">
            <a>{t(' header_menu.etc.language')}</a>
            <ul className="dropdown-menu">
              {/*{ render_cell :locale, :index }*/}
            </ul>
          </li>
          <li className="divider"></li>
          <!--<li><a className="menu-intro">{ t(' header_menu.etc.introduction') }</a></li>-->
          <li><a className="menu-about">{t(' header_menu.etc.about')}</a></li>
          <li className="divider"></li>
          <li><a className="menu-backtomainpage">{t(' header_menu.etc.back_to_gallery')}</a></li>
        </ul>
      </li>
    )
  }
}

export default translate()(Others);