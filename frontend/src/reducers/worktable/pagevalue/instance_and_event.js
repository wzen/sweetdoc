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

// スクロールの合計の長さを取得
// @return [Integer] 取得値
const getAllScrollLength = (state) => {
  let maxTeNum = 0;
  let ret = null;
  $(`#${PageValue.Key.E_ROOT} .${PageValue.Key.E_SUB_ROOT} .${PageValue.Key.pageRoot()}`).children('div').each((i, e) => {
    const teNum = parseInt($(e).attr('class'));
    if(teNum > maxTeNum) {
      const start = $(e).find(`.${this.PageValueKey.SCROLL_POINT_START}:first`).val();
      const end = $(e).find(`.${this.PageValueKey.SCROLL_POINT_END}:first`).val();
      if((start !== null) && (start !== "null") && (end !== null) && (end !== "null")) {
        maxTeNum = teNum;
        return ret = end;
      }
    }
  });
  if((ret === null)) {
    return 0;
  }

  return parseInt(ret);
};

const _defaultEvent = (state, action, itemInstanceId) => {
  let start = getAllScrollLength(state);
  // FIXME: スクロールの長さは要調整
  const adjust = 4.0;
  let end = start + (item.registCoord.length * adjust);
  if(start > end) {
    start = null;
    end = null;
  }
  return {
    dist_id: Common.generateId(),
    id: itemInstanceId,
    item_class_name: action.item_class.name,
    item_size_diff: {x: 0, y: 0, w: 0, h: 0},
    do_focus: true,
    is_common_event: false,
    finish_page: false,
    method_name: action.item_class.DEFAULT_METHOD_NAME,
    action_type: action.item_class.DEFAULT_ACTION_TYPE,
    scroll_point_start: start,
    scroll_point_end: end,
    is_sync: false,
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