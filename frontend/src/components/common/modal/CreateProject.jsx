import React from 'react';
import BaseComponent from '../BaseComponent';
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
    let projectSelects = [];
    this.props.temp.loadCreatedProjects.forEach(l => {
      projectSelects.push(<option value={l.userPagevalueId}>{l.name}</option>)
    });
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
