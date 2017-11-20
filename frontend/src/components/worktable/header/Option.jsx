import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class Option extends Component {
  render() {
    const {t} = this.props;
    return (


      <li id="menu_sidebar_toggle_li">
        <a id="menu_sidebar_toggle">{image_tag("nav/sidebar.png", size:'32x32')}</a>
      </li>
    )
  }
}

export default translate()(Option);