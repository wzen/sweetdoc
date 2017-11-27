import React from 'react';
import BaseComponent from '../BaseComponent';
import { translate } from 'react-i18next';

export default translate()(class ItemTextEdit extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="modal-content <%= Const::ModalViewType::ITEM_TEXT_EDITING %>">
        <div className="content">
          <div className="textarea_wrapper">
            <textarea className="textarea" placeholder="input text"/>
          </div>
          <div>
            <select className="drawHorizontal_select">
            </select>
          </div>
          <div className="button_wrapper">
            <div>
              <button className="create_button button_red" value="Apply">Apply</button>
              <button className="back_button button_black" value="Cancel">Cancel</button>
            </div>
          </div>
        </div>
      </div>      
    )
  }
})
