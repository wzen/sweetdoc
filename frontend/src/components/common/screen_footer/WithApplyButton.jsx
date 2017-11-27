import React from 'react';
import BaseComponent from '../BaseComponent';
import { translate } from 'react-i18next';

export default translate()(class WithApplyButton extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="float_view_pointing_controller_temp">
        <div className='wrapper clearfix'>
          <div className="contents">
            <div className="button_wrapper clearfix">
              <div className="clear_button_wrapper">
                <div className="clear_button" onClick={e => {e.preventDefault(); this.props.hideScreenFooter()}}/>
              </div>
              <div className="apply_button_wrapper">
                <div className="apply_button" onClick={e => {e.preventDefault(); this.props.applyScreenFooter(this.props.applyParams)}}/>
              </div>
            </div>
          </div>
        </div>
      </div>      
    )
  }
})
