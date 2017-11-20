import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class User extends Component {
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