import fetch from 'cross-fetch'

export const saveState = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/page_value_state/save_state`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in saveState.', error)
  ).then(json => dispatch({type: 'SAVE_STATE', json}));

export const loadState = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/page_value_state/load_state`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in loadState.', error)
  ).then(json => dispatch({type: 'LOAD_STATE', json}));

export const loadCreatedProjects = () => (dispatch) =>
  fetch(`${window.apiUrl}/page_value_state/load_created_projects`).then(
    response => response.json(),
    error => console.log('An error occurred in loadCreatedProjects.', error)
  ).then(json => dispatch({type: 'LOAD_CREATED_PROJECTS', json}));

export const userPagevalueListSortedUpdate = () => (dispatch) =>
  fetch(`${window.apiUrl}/page_value_state/user_pagevalue_list_sorted_update`).then(
    response => response.json(),
    error => console.log('An error occurred in userPagevalueListSortedUpdate.', error)
  ).then(json => dispatch({type: 'USER_PAGEVALUE_LIST_SORTED_UPDATE', json}));
