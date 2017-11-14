import Common from '../../../base/common';

const pageKey = (page) => {
  return `p_${page}`;
};

const eventKey = (eventNum) => {
  return `te_${eventNum}`;
};

const forkKey = (state, action) => {
  let forkNum = currentForkNum(state, action);
  return forkNum ? `ef_${forkNum}` : 'master';
};

const currentEventCount = (state, action) => {
  try {
    return state.events[pageKey(action.page)][forkKey(state, action)];
  } catch (e) {
    return 0;
  }
};

const currentForkNum = (state, action) => {
  try {
    return state.events[pageKey(action.page)].fork_num;
  } catch (e) {
    return null;
  }
};

const _defaultEvent = (action, itemInstanceId) => {
  return {
    dist_id: Common.generateId(),
    id: itemInstanceId,
    item_class_name: action.item_class_name,
    item_size_diff: {x: 0, y: 0, w: 0, h: 0},
    do_focus: true,
    is_common_event: false,
    finish_page: false,
    method_name: '',
    action_type: '',
    scroll_point_start: '',
    scroll_point_end: '',
    is_sync: '',
    scroll_enabled_directions: '',
    scroll_forward_directions: '',
    eventDuration: '',
    specificMethodValues: null,
    modifiable_vars: null
  };
};

const createInstance = (state, action) => {
  let instanceId = `i_${action.itemType}_${Common.generateId()}`;
  Object.assign(state, {
    instances: {
      [pageKey(action.page)]: {
        [instanceId]: {

          ...action.params
        }
      }
    },
    events: {
      [pageKey(action.page)]: {
        [forkKey(state, action)]: {
          [eventKey(parseInt(currentEventCount(state, action)) + 1)]: {
            ..._defaultEvent(action, instanceId)
          }
        }
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