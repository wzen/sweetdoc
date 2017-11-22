import React from 'react';
import BaseComponent from '../BaseComponent';
import CreateProject from './CreateProject';
import ManageProject from './ManageProject';

export default class Modal extends BaseComponent {
  render() {
    if(this.props.hideModal) {
      return null;
    }
    switch (this.props.modalType) {
      case 'CreateProject':
        return <CreateProject/>;
      case 'ManageProject':
        return <ManageProject/>;
      default:
        return null;
    }
  }
}
