import React from 'react';
import BaseComponent from '../BaseComponent';
import { translate } from 'react-i18next';

export default translate()(class WithCloseButton extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="float_view_fixed_temp">
        <div className='wrapper clearfix'>
          <div className="icon_wrapper">
            <div className="icon"/>
          </div>
          <div className="contents_wrapper">
            <div className="message_wrapper">
              <div className="message">{this.props.message}</div>
            </div>
          </div>
          <div className="close_button_wrapper">
            <div className="table_wrapper">
              <div className="close_button put_center" onClick={e => {e.preventDefault(); this.props.hideScreenFooter()}}/>
            </div>
          </div>
        </div>
      </div>      
    )
  }
})
