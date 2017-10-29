export const selectEventUpdateState = (eventNum, itemId, state) => {
  return {
    type: 'SELECT_EVENT_UPDATE_STATE',
    state
  }
};

export const selectEventTarget = (eventNum, itemId) => {
  return {
    type: 'SELECT_EVENT_TARGET',
    itemId
  }
};

export const finishEventPage = (eventNum, itemId, page) => {
  return {
    type: 'FINISH_EVENT_PAGE',
    itemId,
    page
  }
};

export const showWillChapter = (eventNum, itemId) => {
  return {
    type: 'SHOW_WILL_CHAPTER',
    eventNum,
    itemId
  }
};

export const hideDidChapter = (eventNum, itemId) => {
  return {
    type: 'HIDE_DID_CHAPTER',
    eventNum,
    itemId
  }
};

export const switchKickType = (eventNum, itemId, kickType) => {
  return {
    type: 'SWITCH_KICK_TYPE',
    itemId,
    kickType
  }
};

export const enableEventSync = (eventNum, itemId, enabled) => {
  return {
    type: 'ENABLE_EVENT_SYNC',
    eventNum,
    itemId,
    enabled
  }
};

export const selectEventAction = (eventNum, itemId, actionName) => {
  return {
    type: 'SELECT_EVENT_ACTION',
    eventNum,
    itemId,
    actionName
  }
};

export const inputEventValue = (eventNum, itemId, values) => {
  return {
    type: 'INPUT_EVENT_VALUE',
    eventNum,
    itemId,
    values
  }
};

export const runEventPreview = (eventNum, itemId, keepDisplayMag) => {
  return {
    type: 'RUN_EVENT_PREVIEW',
    eventNum,
    itemId,
    keepDisplayMag
  }
};

export const stopEventPreview = (eventNum, itemId) => {
  return {
    type: 'STOP_EVENT_PREVIEW',
    eventNum,
    itemId
  }
};

export const applyEventConfig = (eventNum, itemId) => {
  return {
    type: 'APPLY_EVENT_CONFIG',
    eventNum,
    itemId
  }
};