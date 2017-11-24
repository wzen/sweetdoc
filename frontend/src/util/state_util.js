export const isLogin = (state) => state.user && state.user.sessionId;
export const userThumbnailImage = (state) => state.user && state.user.thumbnailImage;
export const currentPageNum = (state) => {
  try {
    return state.general.currentPageNum;
  } catch(e) {
    return 0;
  }
};
export const currentForknum = (state, pageNum = currentPageNum(state)) => {
  try {
    return state.general.currentForkNum;
  } catch(e) {
    return 0;
  }
};
export const currentPageCount = (state) => {
  try{
    return Object.keys(state.instanceAndEvent.events).length;
  } catch (e) {
    return 0;
  }
};
export const currentForkCount = (state, pageNum = currentPageNum(state)) => {
  try {
    return Object.keys(state.instanceAndEvent.events[pageNum]).length;
  } catch(e) {
    return 0;
  }
};
export const currentEventCount = (state, pageNum = currentPageNum(state), forkNum = currentForknum(state, pageNum)) => {
  try{
    return Object.keys(currentEvents(state, pageNum, forkNum)).length;
  } catch(e) {
    return 0;
  }
};
export const currentEvents = (state, pageNum = currentPageNum(state), forkNum = currentForknum(state, pageNum)) => {
  try{
    return state.instanceAndEvent.events[pageNum][forkNum];
  } catch(e) {
    return 0;
  }
};