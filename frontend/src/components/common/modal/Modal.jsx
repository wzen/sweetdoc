import React from 'react';
import BaseComponent from '../BaseComponent';
import CreateProject from './CreateProject';
import ManageProject from './ManageProject';
import Login from './Login';
import About from './About';
import ChangeScreenSize from './ChangeScreenSize';
import CreateUserCode from './CreateUserCode';
import EnvironmentNotSupport from './EnvironmentNotSupport';
import ItemImageUpload from './ItemImageUpload';
import ItemTextEdit from './ItemTextEdit';
import Message from './Message';

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
      case 'About':
        return <About {...this.props}/>;
      case 'ChangeScreenSize':
        return <ChangeScreenSize {...this.props}/>;
      case 'CreateUserCode':
        return <CreateUserCode {...this.props}/>;
      case 'EnvironmentNotSupport':
        return <EnvironmentNotSupport {...this.props}/>;
      case 'ItemImageUpload':
        return <ItemImageUpload {...this.props}/>;
      case 'ItemTextEdit':
        return <ItemTextEdit {...this.props}/>;
      case 'Message':
        return <Message {...this.props}/>;
      default:
        return null;
    }
  }
}
