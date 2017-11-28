const screenFooter = (state = {}, action) => {
  switch (action.type) {
    case 'SHOW_SCREEN_FOOTER':
      return {
        screenFooterType: action.screenFooterType,
        message: action.message
      };
    case 'SET_SCREEN_FOOTER_PARAMS':
      return Object.assign({}, state, {
        params: action.params
      });
    case 'APPLY_SCREEN_FOOTER':
    case 'HIDE_SCREEN_FOOTER':
      return {};
    default:
      return state;
  }
};

export default screenFooter;