import React from 'react';
import BaseComponent from '../BaseComponent';
import Icon from './Icon';
import IconAndMessage from './IconAndMessage';
import WithApplyButton from './WithApplyButton';
import WithCloseButton from './WithCloseButton';

export default class Modal extends BaseComponent {
  render() {
    if(!this.props.show) {
      return null;
    }
    switch (this.props.screenFooterType) {
      case 'Icon':
        return <Icon {...this.props}/>;
      case 'IconAndMessage':
        return <IconAndMessage {...this.props}/>;
      case 'WithApplyButton':
        return <WithApplyButton {...this.props}/>;
      case 'WithCloseButton':
        return <WithCloseButton {...this.props}/>;
      default:
        return null;
    }
  }
}
