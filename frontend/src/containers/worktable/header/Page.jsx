import {connect} from 'react-redux';
import { currentPageNum, currentForknum } from "../../../util/state_util";
import Page from '../../../components/worktable/header/Page';
import {addWorktablePage, addWorktablePageFork, changeWorktablePage, removeWorktablePage, removeWorktablePageFork} from "../../../actions/worktable/page";

const mapStateToProps = (state) => {
  return {
    currentPageNum: currentPageNum(state),
    currentForkNum: currentForknum(state),
    page: Object.values(state.instanceAndEvent.events).map(e => e.forkNum)
  }
};

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    addPage: () => {
      dispatch(addWorktablePage());
    },
    addFork: () => {
      dispatch(addWorktablePageFork(ownProps.pageNum));
    },
    changePage: () => {
      dispatch(changeWorktablePage(ownProps.pageNum, ownProps.forkNum));
    },
    removePage: () => {
      dispatch(removeWorktablePage(ownProps.pageNum));
    },
    removeFork: () => {
      dispatch(removeWorktablePageFork(ownProps.pageNum, ownProps.forkNum));
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Page);