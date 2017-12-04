import {connect} from 'react-redux';
import Screen from '../../components/worktable/Screen';
import {loadState} from "../../actions/api/state";
import {currentPageNum} from "../../util/state_util";

const mapStateToProps = (state) => {
  return {
    items: state.instances[currentPageNum(state)]
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    loadItemsFromServer: () => {
      dispatch(loadState());
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Screen);