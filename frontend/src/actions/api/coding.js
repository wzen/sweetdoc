import fetch from 'cross-fetch'
import {includeAuth} from "./api_util";

export const saveAll = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/coding/save_all`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in saveAll.', error)
  ).then(json => dispatch({type: 'SAVE_CODING_ALL', json}));

export const saveTree = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/coding/save_tree`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in saveTree.', error)
  ).then(json => dispatch({type: 'SAVE_CODING_TREE', json}));

export const updateCode = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/coding/update_code`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in updateCode.', error)
  ).then(json => dispatch({type: 'UPDATE_CODING_CODE', json}));

