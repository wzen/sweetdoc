import {connect} from 'react-redux';
import TimelineItemCmp from '../../../components/worktable/timeline/timeline_item';

const mapStateToProps = (state) => {
  return {
    type: ''
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    onClick: (type) => {
      dispatch();
    }
  }
};

const TimelineItem = connect(
  mapStateToProps,
  mapDispatchToProps
)(TimelineItemCmp);

export default TimelineItem;