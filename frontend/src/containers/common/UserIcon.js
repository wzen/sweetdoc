import {connect} from 'react-redux';
import { isLogin, userThumbnailImage } from "../../util/state_util";
import { showModal } from "../../actions/modal";
import UserIcon from '../../components/common/UserIcon';

const mapStateToProps = (state, ownProps) => {
  return {
    isLogin: isLogin(state),
    userThumbnailImage: userThumbnailImage(state),
    isGallery: ownProps.isGallery,
    showLoginModal: ownProps.showLoginModal
  }
};

const mapDispatchToProps = (dispatch) => {
  return {
    showModal: () => {
      dispatch(showModal('Login'));
    }
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(UserIcon);