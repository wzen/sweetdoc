import React from 'react';
import BaseComponent from '../common/BaseComponent';
import ScreenFooter from '../../containers/common/ScreenFooter';

const contents = (items) => {
  let ret = [];
  items.forEach(item => {

  });
  return ret;
};

class ScrollHandler extends BaseComponent {
  render() {
    return (
      <div className="scroll_handle_wrapper enable_inertial_scroll">
        <div className="scroll_handle"/>
      </div>
    )
  }
}

class PopupInfoButton extends BaseComponent {
  render() {
    return (
      <div className="info_wrapper">
        <a className="info_button"
           onClick={e => {
             e.preventDefault();
             this.props.showPopupInfo()
           }}>
          {PopupInfoButton.imageTag({src: "run/popup_info_24.png", size: '24x24'})}
        </a>
      </div>
    )
  }
}

class PopupInfo extends BaseComponent {
  render() {
    return (

      <div id="popup_info_wrapper">
        <div className="wrapper">
          <div className="info_contents">
            <div className="close_wrapper">
              <a title="Close"
                 onClick="RunFullScreen.hidePopupInfo()">{PopupInfo.imageTag({src: "run/close_24.png", size: '24x24'})}
              </a>
            </div>
            <div className="info_parent put_center">
              {/*render 'run/fullscreen/popup/creator_info' */}
              {/* if show_page_num */}
              <div className="page">
                <span> {t('contents_info.page')}:</span>
                <span className="<%= Const::Run::AttributeName::CONTENTS_PAGE_NUM_CLASSNAME %>"/>
                <span>/</span>
                <span className="<%= Const::Run::AttributeName::CONTENTS_PAGE_MAX_CLASSNAME %>">{@page_max}</span>
              </div>
              {/*end */}
              {/*if show_chapter_num*/}
              <div>
                <div className="chapter">
                  <span>{t('contents_info.chapter')}:</span>
                  <span className="<%= Const::Run::AttributeName::CONTENTS_CHAPTER_NUM_CLASSNAME %>"/>
                  <span>/</span>
                  <span
                    className="<%= Const::Run::AttributeName::CONTENTS_CHAPTER_MAX_CLASSNAME %>">{@chapter_max}</span>
                </div>
                <div className="fork">
                  <span>{t('contents_info.fork')}:</span>
                  <span className="<%= Const::Run::AttributeName::CONTENTS_FORK_NUM_CLASSNAME %>"/>
                </div>
              </div>
              {/*end*/}
              {/*
        <% if @tags.present? %>
            <div className="<%= Const::Run::AttributeName::CONTENTS_TAGS_CLASSNAME %>">
              <div className="tags tagcloud">
                <ul>
                  <% @tags.each do |tag| %>
                      <li><a href=""><%= tag[:name] %></a></li>
                      <input type="hidden" value="<%= tag[:id] %>">
                  <% end %>
                </ul>
              </div>
            </div>
        <% end %>
        */}
            </div>
            <div className="operation_parent">
              {/*render 'run/operation'*/}
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default class Screen extends BaseComponent {
  render() {
    if(window.isFullscreen) {
      return (
        <div id="main">
          <div id="screen_wrapper">
            <div id="project_wrapper" className="border" style="display: none">
              <div id="project_contents">
                <div id="pages">
                  {/* render 'run/guide/guide'*/}
                  <ScrollHandler/>
                </div>
              </div>
            </div>
            <ScreenFooter/>
          </div>
        </div>
      )
    } else {
      return (
        <div id="main" className="fullscreen">
          <div id="screen_wrapper">
            <!-- fullscreenではスクロールビューは全画面に合わせる -->
            <ScrollHandler/>
            <div id="project_wrapper" className="fullscreen border" style={{display: 'none'}}>
              <div id="project_contents">
                <div id="pages">
                  {/* render 'run/guide/guide'*/}
                  <div className="main-wrapper">
                    <div className="scroll_wrapper">
                      <div className="scroll_contents">
                        <div className="scroll_inside_wrapper">
                          <div className="scroll_background">
                            <div className="scroll_inside">
                              <div className="scroll_inside_cover"/>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div className="canvas_wrapper">
                      <canvas className="canvas_container canvas"/>
                    </div>
                  </div>

                </div>
              </div>
            </div>
            <PopupInfoButton showPopupInfo={this.props.showPopupInfo}/>
            <PopupInfo {...this.props}/>
            <ScreenFooter isRun="true"/>
          </div>
        </div>
      )
    }
  }
}