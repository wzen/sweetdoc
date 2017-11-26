import {connect} from 'react-redux';
import {hideModal} from "../../actions/common/modal";
import {hideScreenFooter} from "../../actions/common/screen_footer";
import Overlay from '../../components/common/Overlay';

const mapStateToProps = (state) => {
  return {
    show: Object.keys(state.modal).length > 0 || Object.keys(state.screen_footer).length > 0
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    hide: () => {
      dispatch(hideModal());
      dispatch(hideScreenFooter());
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Overlay);