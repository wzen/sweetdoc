import {connect} from 'react-redux';
import {hideModal} from "../../actions/modal";
import Overlay from '../../components/common/Overlay';

const mapStateToProps = (state) => {
  return {
    show: Object.keys(state.modal).length > 0
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    hideModal: () => {
      dispatch(hideModal());
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Overlay);