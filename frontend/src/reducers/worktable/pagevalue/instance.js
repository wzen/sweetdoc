const createInstance = (state, action) => {

  return state
};

const instancePagevalue = (state, action) => {
  switch(action.type) {
    case 'CREATE_ITEM':
      return createInstance(state, action);
    default:
      return state;
  }
};

export default instancePagevalue;