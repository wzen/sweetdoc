import React from 'react';
import BaseComponent from '../BaseComponent';
import Common from '../../../base/common';
import {translate} from 'react-i18next';

export default translate()(class CreateProject extends BaseComponent {

  async componentDidMount() {
    this.props.loadProjectList();
  }

  inputProjectTitle(e) {
    this.setState({title: e.target.value});
  }

  selectProject(e) {
    this.setState({userPagevalueId: e.target.value});
  }

  projectSelectOptions() {
    const {t} = this.props;
    const n = (new Date).getTime();
    let projectSelects = [];
    if (this.props.projects.userProjects.length > 0) {
      projectSelects.push(`<optgroup label='${t('modal.not_sample_project')}'>`);
      this.props.projects.userProjects.forEach(p => {
        let d = new Date(p['up_updated_at']);
        projectSelects.push(`<option value=${p['up_id']}>${p['p_title']} - ${Common.displayDiffAlmostTime(n, d.getTime())}</option>`);
      });
      projectSelects.push("</optgroup>");
    }
    if (this.props.projects.sampleProjects.length > 0) {
      projectSelects.push(`<optgroup label='${t('modal.sample_project')}'>`);
      this.props.projects.sampleProjects.forEach(p => {
        let d = new Date(p['up_updated_at']);
        projectSelects.push(`<option value=${p['up_id']}>${p['p_title']}</option>`);
      });
      projectSelects.push("</optgroup>");
    }
    return projectSelects;
  }

  render() {
    const {t} = this.props;

    return (
      <div className="modal-content <%= Const::ModalViewType::INIT_PROJECT}">
        <div className="content">
          <div className="project_create_wrapper">
            <div>
              <div style="display: inline-block">
                <label><input type="radio" name="project_create" value="select" checked />{t('modal.project_select')}</label>
              </div>
              <div style="display: inline-block">
                <label><input type="radio" name="project_create" value="new" />{t('modal.project_create')}</label>
              </div>
            </div>
          </div>
          <div className="display_project_new_wrapper">
            <div className="label_div">
              <label>{t('modal.project_name')}:</label>
            </div>
            <div>
              <input name="project_name" className="project_name" type="text" maxlength="30" required="required" onMouseUp={this.inputProjectTitle} /><br/>
            </div>
          </div>
          <div className="display_project_select_wrapper">
            <div className="label_div">
              <label>{t('modal.select_project')}:</label>
            </div>
            <div style="vertical-align: middle">
              <select className="project_select" onChange={this.selectProject}>
                {projectSelectOptions()}
              </select>
            </div>
          </div>
          <div className="button_wrapper">
            <div>
              <span className="new"><button className="create_button button_red width90per"
                                            onClick={e => {e.preventDefault(); this.props.createProject(this.state.title)}}
                                            value="Create">{t('modal.button.create')}</button></span>
              <span className="select"><button className="open_button button_red width90per"
                                               onClick={e => {e.preventDefault(); this.props.selectProject(this.state.userPagevalueId)}}
                                               value="Open">{t('modal.button.open')}</button></span>
              <button className="back_button button_black width90per"
                      value="Back to MainPage">{t('modal.button.back')}</button>
            </div>
          </div>
          <div className="error_wrapper" style="display: none">
            <div className="error">
            </div>
          </div>
        </div>
      </div>
    )
  }
})
