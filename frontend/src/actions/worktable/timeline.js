export const selectTimeline = (distId) => {
  return {
    type: 'SELECT_TIMELINE',
    distId
  }
};