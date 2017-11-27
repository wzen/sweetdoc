import React from 'react';
import BaseComponent from '../BaseComponent';
import { translate } from 'react-i18next';

export default translate()(class Message extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="modal-content <%= Const::ModalViewType::MESSAGE %>">
        <div className="content">
          <div className="message_wrapper">
            <div>
              <div className="message_contents">
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
})
