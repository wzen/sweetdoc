import {connect} from 'react-redux';
import TimelineItemCmp from '../../components/worktable/timeline/TimelineItem';
import { selectTimeline } from "../../actions/worktable/timeline";

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    onClick: () => {
      dispatch(selectTimeline(ownProps.distId));
    }
  }
};

const TimelineItem = connect(
  null,
  mapDispatchToProps
)(TimelineItemCmp);

export default TimelineItem;