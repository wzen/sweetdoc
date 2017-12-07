import fetch from 'cross-fetch'
import {includeAuth} from "./api_util";

export const createProject = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/project/create`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in createProject.', error)
  ).then(json => dispatch({type: 'CREATE_PROJECT', json}));

export const getProject = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/project/get_project_by_user_pagevalue_id`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in getProject.', error)
  ).then(json => dispatch({type: 'GET_PROJECT', json}));

export const getAdminMenu = () => (dispatch, getState) =>
  fetch(`${window.apiUrl}/project/admin_menu`).then(
    response => response.json(),
    error => console.log('An error occurred in saveAll.', error)
  ).then(json => dispatch({type: 'GET_PROJECT_ADMIN_MENU', json}));

export const updateProject = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/project/update`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in updateProject.', error)
  ).then(json => dispatch({type: 'UPDATE_PROJECT', json}));

export const resetProject = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/project/reset`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in resetProject.', error)
  ).then(json => dispatch({type: 'RESET_PROJECT', json}));

export const removeProject = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/project/remove`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in removeProject.', error)
  ).then(json => dispatch({type: 'REMOVE_PROJECT', json}));
