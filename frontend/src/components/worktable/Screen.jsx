import React from 'react';
import BaseComponent from '../common/BaseComponent';
import ScreenFooter from '../../containers/common/ScreenFooter';
import Timeline from '../../containers/worktable/timeline/Timeline';
import {translate} from 'react-i18next';

let Container = translate()(class Container extends BaseComponent {
  contents(items) {
    let ret = [];
    this.props.items.forEach(item => {

    });
    return ret;
  }

  render() {
    return (
      <div className="main-wrapper">
        <div className="scroll_wrapper">
          <div className="scroll_contents">
            <div className="scroll_inside_wrapper">
              <div className="scroll_background">
                <div className="scroll_inside"/>
              </div>
            </div>
          </div>
        </div>
        <canvas className="canvas_container canvas" style="z-index: <%= Const::Zindex::EVENTBOTTOM %>"/>
      </div>
    )
  }
});

export default class Screen extends BaseComponent {
  render() {
    return (
      <div id="main" className="col-xs-12">
        <div id="screen_wrapper">
          <div id="project_wrapper" className="border" style={{display: 'none'}}>
            <div id="project_contents">
              <div id="pages">
                <Container {...this.props}/>
              </div>
            </div>
          </div>
          <ScreenFooter/>
        </div>
        <Timeline/>
      </div>
    )
  }
}