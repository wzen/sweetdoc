export const selectTimeline = (timeline_type) => {
  return {
    type: 'SELECT_TIMELINE',
    timeline_type
  }
};