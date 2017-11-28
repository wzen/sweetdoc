const modal = (state = {}, action) => {
  switch (action.type) {
    case 'SHOW_MODAL':
      return {modalType: action.modalType};
    case 'HIDE_MODAL':
      return {};
    default:
      return {};
  }
};
export default modal;