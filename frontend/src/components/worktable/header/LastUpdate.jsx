import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class LastUpdate extends Component {
  render() {
    const {t} = this.props;
    if (!this.props.lastUpdateTime) {
      return <li/>
    } else {
      return (
        <li>
          <a href="">
            <span>{t('header_menu.etc.last_update_date')} {this.props.lastUpdateTime}</span>
          </a>
        </li>
      )
    }
  }
}

export default translate()(LastUpdate);