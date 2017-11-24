import {connect} from 'react-redux';
import {hideScreenFooter} from "../../actions/common/screen_footer";
import ScreenFooter from '../../components/common/screen_footer/ScreenFooter';

const mapStateToProps = (state) => {
  return {
    show: Object.keys(state.screenFooter).length > 0,
    screenFooterType: state.screenFooter.screenFooterType
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    hideScreenFooter: () => {
      dispatch(hideScreenFooter());
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ScreenFooter);