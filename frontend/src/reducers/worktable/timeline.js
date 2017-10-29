import { combineReducers } from 'redux';

const timelineItems = (state, action) => {
  switch(action.type) {
    case 'CREATE_ITEM':
      return state;
    default:
      return state;
  }
};

const timeline = combineReducers({
  timelineItems
});
export default timeline;