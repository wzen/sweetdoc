export const createProject = () => {
  return {
    type: 'CRAETE_PROJECT'
  }
};

export const loadProject = (user_pagevalue_id) => {
  return {
    type: 'LOAD_PROJECT',
    user_pagevalue_id
  }
};
