import React from 'react';
import BaseComponent from '../BaseComponent';
import {translate} from 'react-i18next';

export default translate()(class EnvironmentNotSupport extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="modal-content <%= Const::ModalViewType::ENVIRONMENT_NOT_SUPPORT}">
        <div className="content">
          <div>
            {t('modal.environment_not_support')}
          </div>
          <!-- 対応するブラウザリスト -->

          <div className="button_wrapper">
            <div>
              <button className="back_button button_black" value="Back to MainPage">{t('modal.button.back')}</button>
            </div>
          </div>
        </div>
      </div>
    )
  }
})
