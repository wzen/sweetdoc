import React from 'react';
import BaseComponent from '../BaseComponent';
import {translate} from 'react-i18next';

export default translate()(class Login extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="modal-content <%= Const::ModalViewType::NOTICE_LOGIN}">
        <div className="content">
          <form action="/user/sign_in" method="get">
            <div>
              {/* render "base/mention/#{I18n.locale}/notice_login" */}
            </div>
            <div className="button_wrapper clearfix">
              <div>
                <button className="create_button button_red"
                        value="Create">{t('account.login_or_create_account')}</button>
                <button className="back_button button_black" value="continue_as_guest"
                        onClick="Common.hideModalView(); return false;">{t('account.continue_as_guest')}</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    )
  }
})