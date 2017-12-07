import {connect} from 'react-redux';
import { currentPageNum, currentForknum } from "../../../util/state_util";
import File from '../../../components/worktable/header/File';
import {showModal} from "../../../actions/common/modal";

const mapStateToProps = (state) => {
  return {
    currentPageNum: currentPageNum(state),
    currentForkNum: currentForknum(state),
    page: Object.values(state.instanceAndEvent.events).map(e => e.forkNum)
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    showCreateProjectModal: () => {
      dispatch(showModal('CreateProject'));
    },
    showManegeProjectModal: () => {
      dispatch(showModal('ManageProject'));
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(File);