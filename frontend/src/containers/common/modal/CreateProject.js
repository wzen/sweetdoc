import {connect} from 'react-redux';
import CreateProject from '../../../components/common/modal/CreateProject';
import {createProject, getProject} from "../../../actions/api/project";
import {loadCreatedProjects} from "../../../actions/api/state";

const mapStateToProps = (state) => {
  return {
    projects: {
      userProjects: state.project.createdProjectList.userProjects,
      sampleProjects: state.project.createdProjectList.sampleProjects
    }
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    loadProjectList: () => {
      dispatch(loadCreatedProjects());
    },
    createProject: (title) => {
      if(!title || title.length === 0) return;
      dispatch(createProject({title: title}));
    },
    selectProject: (userPagevalueId) => {
      if(!userPagevalueId) return;
      dispatch(getProject({userPagevalueId: userPagevalueId}));
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(CreateProject);