import {connect} from 'react-redux';
import Timeline from '../../components/worktable/timeline/Timeline';

const timelineEvents = (state) => {
  let pageNum = state.generalPagevalue.currentPageNum;
  let formNum = state.instanceAndEventPagevalue.events[pageNum]['fork_num'];
  return Object.values(state.instanceAndEventPagevalue.events[pageNum][formNum]);
};

const actionType = (state) => {
  if(state.actionType !== 'click' && state.actionType !== 'scroll') return 'blank';
  return state.actionType;
};

const items = (state) => {
  return timelineEvents(state).map(e => {
    return {
      distId: e.distId,
      actionType: actionType(e),
      isSync: e.isSync
    }
  });
};

const mapStateToProps = (state) => {
  return {
    items: items()
  }
};

export default connect(
  mapStateToProps
)(Timeline);