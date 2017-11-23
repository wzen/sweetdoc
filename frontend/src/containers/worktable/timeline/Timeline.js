import {connect} from 'react-redux';
import {currentPageNum, currentForknum} from "../../../util/state_util";
import Timeline from '../../../components/worktable/timeline/Timeline';

const timelineEvents = (state) => Object.values(state.instanceAndEvent.events[currentPageNum(state)][currentForknum(state)]);

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