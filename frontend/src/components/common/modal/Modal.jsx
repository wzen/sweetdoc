import React from 'react';
import BaseComponent from '../BaseComponent';
import CreateProject from '../../../containers/common/modal/CreateProject';
import ManageProject from '../../../containers/common/modal/ManageProject';
import Login from '../../../containers/common/modal/Login';
import About from './About';
import ChangeScreenSize from '../../../containers/common/modal/ChangeScreenSize';
import CreateUserCode from '../../../containers/common/modal/CreateUserCode';
import EnvironmentNotSupport from './EnvironmentNotSupport';
import ItemImageUpload from '../../../containers/common/modal/ItemImageUpload';
import ItemTextEdit from '../../../containers/common/modal/ItemTextEdit';
import Message from '../../../containers/common/modal/Message';

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
      case 'Login':
        return <Login/>;
      case 'About':
        return <About/>;
      case 'ChangeScreenSize':
        return <ChangeScreenSize/>;
      case 'CreateUserCode':
        return <CreateUserCode/>;
      case 'EnvironmentNotSupport':
        return <EnvironmentNotSupport/>;
      case 'ItemImageUpload':
        return <ItemImageUpload/>;
      case 'ItemTextEdit':
        return <ItemTextEdit/>;
      case 'Message':
        return <Message/>;
      default:
        return null;
    }
  }
}
