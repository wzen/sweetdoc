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
const getAllScrollLength = (state, action) => {
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

const getScrollPointRange = (state, action) => {
  let scrollPointStart = null;
  let scrollPointEnd = null;
  if (action.instanceParams.canvasRegistCoord) {
    scrollPointStart = getAllScrollLength(state, action);
    // FIXME: スクロールの長さは要調整
    const adjust = 4.0;
    scrollPointEnd = scrollPointStart + (action.instanceParams.canvasRegistCoord.length * adjust);
    if(scrollPointStart > scrollPointEnd) {
      scrollPointStart = null;
      scrollPointEnd = null;
    }
  }
  return {scrollPointStart: scrollPointStart, scrollPointEnd: scrollPointEnd};
};

const defaultEvent = (state, action, itemInstanceId) => {
  if (!action.itemClass.defaultMethodName()) {
    return {};
  }

  let {scrollPointStart, scrollPointEnd} = getScrollPointRange(state, action);

  return {
    dist_id: Common.generateId(),
    id: itemInstanceId,
    itemClassName: action.itemClass.name,
    itemSizeDiff: {x: 0, y: 0, w: 0, h: 0},
    doFocus: true,
    isCommonEvent: false,
    finishPage: false,
    methodName: action.itemClass.defaultMethodName(),
    actionType: action.itemClass.defaultActionType(),
    scrollPointStart: scrollPointStart,
    scrollPointEnd: scrollPointEnd,
    isSync: false,
    scrollEnabledDirections: action.itemClass.defaultScrollEnabledDirection(),
    scrollForwardDirections: action.itemClass.defaultScrollForwardDirection(),
    eventDuration: action.itemClass.defaultClickDuration(),
    specificMethodValues: action.itemClass.defaultSpecificMethodValue(),
    modifiableVars: action.itemClass.defaultModifiableVars()
  };
};

const createInstance = (state, action) => {
  let instanceId = `i_${action.itemType}_${Common.generateId()}`;
  Object.assign(state, {
    instances: {
      [action.page]: {
        [instanceId]: {
          ...action.instanceParams
        }
      }
    },
    events: {
      [action.page]: {
        [forkKey(state, action)]: {
          [parseInt(currentEventCount(state, action)) + 1]: {
            ...defaultEvent(state, action, instanceId)
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