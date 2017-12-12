import Common from '../../../base/common';
import {currentForknum, currentPageNum, currentEvents, currentEventCount} from "../../../util/state_util";

const loadState = (action) => {
  return {
    instances: action.json.instancePagevalueData,
    events: action.json.eventPagevalueData
  };
};

// スクロールの合計の長さを取得
// @return [Integer] 取得値
const getAllScrollLength = (state) => {
  try {
    let ret = 0;
    let timelines = currentEvents(state);
    Object.keys(timelines).reverse().forEach((key) => {
      if(!timelines[key].scrollPointEnd) { return false }
      ret = timelines[key].scrollPointEnd;
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
    scrollPointStart = getAllScrollLength(state);
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
    distId: Common.generateId(),
    id: itemInstanceId,
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
  state.instances[currentPageNum(state)][instanceId] = action.instanceParams;
  state.events[currentPageNum(state)][currentForknum(state)][parseInt(currentEventCount(state)) + 1] = defaultEvent(state, action, instanceId);
  return state
};

const applyScreenFooter = (state, action) => {

};

const instanceAndEvent = (state = {instances: {}, events: {}}, action) => {
  switch(action.type) {
    case 'LOAD_STATE':
      return loadState(action);
    case 'CREATE_ITEM':
      return createInstance(state, action);
    case 'APPLY_SCREEN_FOOTER':
      return applyScreenFooter(state, action);
    default:
      return state;
  }
};

export default instanceAndEvent;