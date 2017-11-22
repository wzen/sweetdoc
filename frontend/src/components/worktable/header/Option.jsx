import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class Option extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <li id="menu_sidebar_toggle_li">
        <a id="menu_sidebar_toggle">{Option.imageTag({src: "nav/sidebar.png", size: '32x32'})}</a>
      </li>
    )
  }
}

export default translate()(Option);