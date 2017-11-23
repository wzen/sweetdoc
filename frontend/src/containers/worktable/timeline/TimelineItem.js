import {connect} from 'react-redux';
import TimelineItem from '../../../components/worktable/timeline/TimelineItem';
import { selectTimeline, removeTimeline } from "../../../actions/worktable/timeline";
import { runEventPreview } from "../../../actions/worktable/config/event";

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    selectTimeline: () => {
      dispatch(selectTimeline(ownProps.distId));
    },
    removeTimeline: () => {
      dispatch(removeTimeline(ownProps.distId));
    },
    runEventPreview: () => {
      dispatch(runEventPreview({distId: ownProps.distId}));
    }
  }
};

export default connect(
  null,
  mapDispatchToProps
)(TimelineItem);