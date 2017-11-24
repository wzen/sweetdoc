import React from 'react';
import BaseComponent from './BaseComponent';
import Modal from '../../containers/common/Modal';

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
          <Modal/>
        </div>
        {Screen.getChildrenComponent('timeline')}
      </div>
    )
  }
}