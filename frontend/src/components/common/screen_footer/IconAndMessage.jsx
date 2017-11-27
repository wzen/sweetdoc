import React from 'react';
import BaseComponent from '../BaseComponent';
import { translate } from 'react-i18next';

export default translate()(class IconAndMessage extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="float_view_temp">
        <div className='wrapper clearfix'>
          <div className="icon_wrapper">
            <div className="icon"/>
          </div>
          <div className="contents_wrapper">
            <div className="message_wrapper">
              <div className="message">{this.props.message}</div>
            </div>
          </div>
        </div>
      </div>      
    )
  }
})
