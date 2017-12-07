export const includeAuth = (getState, data = {}) => {
  return {sessionId: getState().user.sessionId, ...data}
};