import React from 'react';
import BaseComponent from './BaseComponent';
import Modal from '../../containers/common/Modal';
import ScreenFooter from '../../containers/common/ScreenFooter';

export default class Screen extends BaseComponent {
  render() {
    return (
      <div id="main" className="col-xs-12">
        <div id="screen_wrapper">
          <div id="project_wrapper" className="border" style={{display: 'none'}}>
            <div id="project_contents">
              <div id="pages"/>
            </div>
          </div>
          <ScreenFooter/>
        </div>
        {Screen.getChildrenComponent('timeline')}
      </div>
    )
  }
}