import React from 'react';
import BaseComponent from '../common/BaseComponent';
import ScreenFooter from '../../containers/common/ScreenFooter';
import Timeline from '../../containers/worktable/timeline/Timeline';

const contents = (items) => {
  let ret = [];
  items.forEach(item => {

  });
  return ret;
};

export default class Screen extends BaseComponent {
  render() {
    return (
      <div id="main" className="col-xs-12">
        <div id="screen_wrapper">
          <div id="project_wrapper" className="border" style={{display: 'none'}}>
            <div id="project_contents">
              <div id="pages">
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