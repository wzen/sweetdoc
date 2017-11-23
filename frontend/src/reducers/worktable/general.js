const createProject = (action) => {
  return {
    projectId: action.projectId,
    title: action.title,
    isSampleProject: false,
    currentPageNum: 1,
    pageMax: 1,
    updatedUserPagevalueId: null,
    lastSaveTime: action.lastSaveTime,
    pageInfo: {
      1: {
        wsScale: 1.0,
        wsDisplayPosition: {
          top: 0.0,
          left: 0.0
        }
      }
    }
  };
};

const general = (state, action) => {
  switch(action.type) {
    case 'CREATE_PROJECT':
      return createProject(action);
    default:
      return state;
  }
};

export default general;