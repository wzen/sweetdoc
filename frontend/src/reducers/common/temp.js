const temp = (state = {}, action) => {
  switch(action.type) {
    case 'LOAD_CREATED_PROJECTS':
      return {
        loadCreatedProjects: action.json
      };
    default:
      return state;
  }
};

export default temp;