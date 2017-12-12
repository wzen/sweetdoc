const createProject = (action) => {
  return {
    projectId: action.projectId,
    title: action.title,
    isSampleProject: false,
    currentPageNum: 1,
    pageMax: 1,
    userPagevalueId: null,
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

const loadState = (action) => {
  return {
    ...action.json.generalPagevalueData,
    currentPageNum: 1,
    pageMax: Object.keys(action.json.generalPagevalueData.pageInfo).length
  }
};

const general = (state = {}, action) => {
  switch(action.type) {
    case 'CREATE_PROJECT':
      return createProject(action);
    case 'LOAD_STATE':
      return loadState(action);
    default:
      return state;
  }
};

export default general;