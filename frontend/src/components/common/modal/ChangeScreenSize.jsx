import React from 'react';
import BaseComponent from '../BaseComponent';
import {translate} from 'react-i18next';

export default translate()(class ChangeScreenSize extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="modal-content <%= Const::ModalViewType::CHANGE_SCREEN_SIZE}">
        <div className="content">
          <div>
            <div>
              <div className="display_size_wrapper">
                <div>
                  <label>
                    <input type="radio" name="project_size" value="default" checked/>{t('modal.not_fix_screen_size')}
                  </label>
                </div>
                <div>
                  <label>
                    <input type="radio" name="project_size" value="input"/>{t('modal.fix_screen_size')}
                  </label>
                </div>
              </div>
              <div className="display_size_input_wrapper" style="display: none">
                <div style="display: inline-block">
                  {t('modal.width')}:<input className="display_size_input_width" type="number" value="" maxlength="4"
                                            style="max-width: 50px"/>
                </div>
                <div style="display: inline-block">
                  {t('modal.height')}:<input className="display_size_input_height" type="number" value="" maxlength="4"
                                             style="max-width: 50px"/>
                </div>
              </div>
            </div>
          </div>
          <div className="button_wrapper">
            <div>
              <button className="update_button button_red width90per" value="Update">Update</button>
              <button className="cancel_button button_black width90per" value="Cancel">Cancel</button>
            </div>
          </div>
        </div>
      </div>
    )
  }
})
