import Common from '../../../base/common';

const forkKey = (state, action) => {
  let forkNum = currentForkNum(state, action);
  return forkNum ? forkNum : 0;
};

const currentEventCount = (state, action) => {
  try {
    return Object.keys(state.events[action.page][forkKey(state, action)]).length;
  } catch (e) {
    return 0;
  }
};

const currentForkNum = (state, action) => {
  try {
    return parseInt(state.events[action.page].fork_num);
  } catch (e) {
    return null;
  }
};

// スクロールの合計の長さを取得
// @return [Integer] 取得値
const _getAllScrollLength = (state, action) => {
  try {
    let ret = 0;
    let timelines = state.events[action.page][forkKey(state, action)];
    Object.keys(timelines).reverse().forEach((key) => {
      if(!timelines[key]['scroll_point_end']) { return false }
      ret = timelines[key]['scroll_point_end'];
      return true;
    });
    return parseInt(ret);
  } catch {
    return 0;
  }
};

const _getScrollPointRange = (state, action) => {
  let scroll_point_start = null;
  let scroll_point_end = null;
  if (action.canvasRegistCoord) {
    scroll_point_start = _getAllScrollLength(state, action);
    // FIXME: スクロールの長さは要調整
    const adjust = 4.0;
    scroll_point_end = scroll_point_start + (action.canvasRegistCoord.length * adjust);
    if(scroll_point_start > scroll_point_end) {
      scroll_point_start = null;
      scroll_point_end = null;
    }
  }
  return {scroll_point_start, scroll_point_end};
};

const _defaultEvent = (state, action, itemInstanceId) => {
  if (!action.item_class.defaultMethodName()) {
    return {};
  }

  let {scroll_point_start,scroll_point_end} = _getScrollPointRange(state, action);

  return {
    dist_id: Common.generateId(),
    id: itemInstanceId,
    item_class_name: action.item_class.name,
    item_size_diff: {x: 0, y: 0, w: 0, h: 0},
    do_focus: true,
    is_common_event: false,
    finish_page: false,
    method_name: action.item_class.defaultMethodName(),
    action_type: action.item_class.defaultActionType(),
    scroll_point_start: scroll_point_start,
    scroll_point_end: scroll_point_end,
    is_sync: false,
    scroll_enabled_directions: action.item_class.defaultScrollEnabledDirection(),
    scroll_forward_directions: action.item_class.defaultScrollForwardDirection(),
    eventDuration: action.item_class.defaultClickDuration(),
    specificMethodValues: action.item_class.defaultSpecificMethodValue(),
    modifiable_vars: action.item_class.defaultModifiableVars()
  };
};

const createInstance = (state, action) => {
  let instanceId = `i_${action.itemType}_${Common.generateId()}`;
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
        [forkKey(state, action)]: {
          [parseInt(currentEventCount(state, action)) + 1]: {
            ..._defaultEvent(state, action, instanceId)
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