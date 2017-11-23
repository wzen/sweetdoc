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

const mapDispatchToProps = (dispatch) => {
  return {
    addPage: () => {
      dispatch(addWorktablePage());
    },
    addFork: (pageNum) => {
      dispatch(addWorktablePageFork(pageNum));
    },
    changePage: (pageNum, forkNum) => {
      dispatch(changeWorktablePage(pageNum, forkNum));
    },
    removePage: (pageNum) => {
      dispatch(removeWorktablePage(pageNum));
    },
    removeFork: (pageNum, forkNum) => {
      dispatch(removeWorktablePageFork(pageNum, forkNum));
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Page);