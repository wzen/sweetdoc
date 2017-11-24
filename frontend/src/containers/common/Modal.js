import {connect} from 'react-redux';
import Modal from '../../components/common/modal/Modal';

const mapStateToProps = (state, ownProps) => {
  return {
    hideModal: Object.keys(state.modal).length === 0,
    modalType: state.modal.modalType,
  }
};

export default connect(
  mapStateToProps
)(Modal);