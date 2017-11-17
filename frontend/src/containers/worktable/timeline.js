import {connect} from 'react-redux';
import TimelineCmp from '../../components/worktable/timeline/timeline';

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

const mapDispatchToProps = (dispatch) => {
  return {
    onClick: (type) => {
      dispatch();
    }
  }
};

const Timeline = connect(
  mapStateToProps,
  mapDispatchToProps
)(TimelineCmp);

export default Timeline;