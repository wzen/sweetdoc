const screenFooter = (state, action) => {
  switch (action.type) {
    case 'SHOW_SCREEN_FOOTER':
      return action;
    case 'HIDE_SCREEN_FOOTER':
      return {};
    default:
      return {};
  }
};

export default screenFooter;