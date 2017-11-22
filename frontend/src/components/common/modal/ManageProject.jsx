import React from 'react';
import BaseComponent from '../BaseComponent';
import { translate } from 'react-i18next';

class ManageProject extends BaseComponent {
  render() {
    const {t} = this.props;
  }
}

export default translate()(ManageProject);