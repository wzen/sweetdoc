export const selectTimeline = (distId = null) => {
  return {
    type: 'SELECT_TIMELINE',
    distId
  }
};
export const removeTimeline = (distId) => {
  return {
    type: 'REMOVE_TIMELINE',
    distId
  }
};