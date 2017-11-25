import {connect} from 'react-redux';
import {hideScreenFooter, applyScreenFooter} from "../../actions/common/screen_footer";
import ScreenFooter from '../../components/common/screen_footer/ScreenFooter';

const mapStateToProps = (state) => {
  return {
    show: Object.keys(state.screenFooter).length > 0,
    screenFooterType: state.screenFooter.screenFooterType,
    applyParams: {
      applyType: state.screenFooter.applyType,
      params: state.screenFooter.params
    }
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    hideScreenFooter: () => {
      dispatch(hideScreenFooter());
    },
    applyScreenFooter: (params) => {
      dispatch(applyScreenFooter(params.applyType, params.params));
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ScreenFooter);