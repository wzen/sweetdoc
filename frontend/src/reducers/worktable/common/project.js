const createdProjectList = (action) => {
  let user_pagevalue_list = action.json.user_pagevalue_list;
  let sampleProjects = user_pagevalue_list.map(u => u.p_is_sample === 1);
  let userProjects = user_pagevalue_list.map(u => u.p_is_sample === 0);
  return {
    userProjects: userProjects,
    sampleProjects: sampleProjects
  }
};

const project = (state = {}, action) => {
  switch(action.type) {
    case 'LOAD_CREATED_PROJECTS':
      state['createdProjectList'] = createdProjectList(action);
      return state;
    default:
      return state;
  }
};

export default project;