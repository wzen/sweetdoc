import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class Page extends Component {
  render() {
    const {t} = this.props;
    return (
      <li id="{ Const::Paging::NAV_ROOT_ID }">
        <a className="dropdown-toggle" data-toggle="dropdown" href="#header-pageing">
          <span className="{ Const::Paging::NAV_SELECTED_CLASS }"/>
          <b className="caret"/>
        </a>
        <ul className="dropdown-menu { Const::Paging::NAV_SELECT_ROOT_CLASS }" role="menu">
        </ul>
      </li>
    )
  }
}

export default translate()(Page);