import React from 'react';
import BaseComponent from '../BaseComponent';
import { translate } from 'react-i18next';

export default translate()(class ManageProject extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="modal-content <%= Const::ModalViewType::ADMIN_PROJECTS %>">
        <div className="am_scroll_wrapper scroll_x_content">
          <div className="am_wrapper clearfix">
            <div className="am_list_wrapper">
              <div className="am_list">
              </div>
              <div>
                <div className="button_wrapper">
                  <div>
                    <button className="cancel_button button_black width90per" value="Cancel">Cancel</button>
                  </div>
                </div>
              </div>
            </div>
            <div className="am_input_wrapper">
              <div className="am_input">
                <div className="display_project_new_wrapper">
                  <div className="cell_label">
                    <label>Project name:</label>
                  </div>
                  <div>
                    <input name="project_name" className="project_name" type="text" required="required"/><br />
                  </div>
                </div>
              </div>
              <div className="button_wrapper">
                <div>
                  <button className="update_button button_red width90per" value="Update">Update</button>
                  <button className="cancel_button button_black width90per" value="Cancel">Cancel</button>
                </div>
              </div>
              <input type="hidden" className="<%= Const::Project::Key::PROJECT_ID %>" value="" />
            </div>
          </div>
        </div>
      </div>      
    )
  }
})
