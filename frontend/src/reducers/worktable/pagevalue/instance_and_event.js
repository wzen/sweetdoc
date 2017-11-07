const defaultEvent = (action) => {

};

const createInstance = (state, action) => {
  let instanceId = test;
  Object.assign(state, {
    instances: {
      [action.page]: {
        [instanceId]: {

          ...action.params
        }
      }
    },
    events: {
      [action.page]: {

      }
    }
  });
  return state
};

const instanceAndEventPagevalue = (state = {}, action) => {
  switch(action.type) {
    case 'CREATE_ITEM':
      return createInstance(state, action);
    default:
      return state;
  }
};

export default instanceAndEventPagevalue;