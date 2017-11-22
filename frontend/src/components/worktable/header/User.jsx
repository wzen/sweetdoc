import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class User extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <li>
        {/* render ' base/user/login_user'*/}
      </li>
    )
  }
}

export default translate()(User);