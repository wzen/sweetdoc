import React from 'react';
import BaseComponent from '../BaseComponent';
import CreateProject from './CreateProject';
import ManageProject from './ManageProject';
import Login from './Login';

export default class Modal extends BaseComponent {
  render() {
    if(this.props.hideModal) {
      return null;
    }
    switch (this.props.modalType) {
      case 'CreateProject':
        return <CreateProject {...this.props}/>;
      case 'ManageProject':
        return <ManageProject {...this.props}/>;
      case 'Login':
        return <Login {...this.props}/>;
      default:
        return null;
    }
  }
}
