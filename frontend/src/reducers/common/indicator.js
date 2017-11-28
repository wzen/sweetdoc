const indicator = (state = {}, action) => {
  switch (action.type) {
    case 'SHOW_INDICATOR':
      return { message: action.message };
    case 'HIDE_INDICATOR':
      return {};
    default:
      return {};
  }
};

export default indicator;