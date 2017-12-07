import fetch from 'cross-fetch'
import {includeAuth} from "./api_util";

export const saveState = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/page_value_state/save_state`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in saveState.', error)
  ).then(json => dispatch({type: 'SAVE_STATE', json}));

export const loadState = () => (dispatch, getState) => {
  if(!getState().general.userPagevalueId) return;
  return fetch(`${window.apiUrl}/page_value_state/load_state`, {method: 'POST', body: includeAuth(getState, {userPagevalueId: getState().general.userPagevalueId})}).then(
    response => response.json(),
    error => console.log('An error occurred in loadState.', error)
  ).then(json => dispatch({type: 'LOAD_STATE', json}))
};

export const loadCreatedProjects = () => (dispatch, getState) =>
  fetch(`${window.apiUrl}/page_value_state/load_created_projects`, {method: 'GET', body: includeAuth(getState)}).then(
    response => response.json(),
    error => console.log('An error occurred in loadCreatedProjects.', error)
  ).then(json => dispatch({type: 'LOAD_CREATED_PROJECTS', json}));

export const userPagevalueListSortedUpdate = () => (dispatch, getState) =>
  fetch(`${window.apiUrl}/page_value_state/user_pagevalue_list_sorted_update`, {method: 'GET', body: includeAuth(getState)}).then(
    response => response.json(),
    error => console.log('An error occurred in userPagevalueListSortedUpdate.', error)
  ).then(json => dispatch({type: 'USER_PAGEVALUE_LIST_SORTED_UPDATE', json}));
