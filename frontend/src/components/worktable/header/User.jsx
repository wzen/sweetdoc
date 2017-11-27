import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';
import UserIcon from '../../../containers/common/UserIcon';

export default translate()(class User extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <li>
        <UserIcon/>
      </li>
    )
  }
})
