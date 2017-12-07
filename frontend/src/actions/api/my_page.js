import fetch from 'cross-fetch'
import {includeAuth} from "./api_util";

export const getBookmarks = () => (dispatch, getState) =>
  fetch(`${window.apiUrl}/my_page/bookmarks`).then(
    response => response.json(),
    error => console.log('An error occurred in getBookmarks.', error)
  ).then(json => dispatch({type: 'GET_BOOKMARKS', json}));

export const removeBookmarks = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/my_page/remove_bookmark`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in removeBookmarks.', error)
  ).then(json => dispatch({type: 'REMOVE_BOOKMARKS', json}));

export const getCreatedContents = () => (dispatch, getState) =>
  fetch(`${window.apiUrl}/my_page/created_contents`).then(
    response => response.json(),
    error => console.log('An error occurred in getCreatedContents.', error)
  ).then(json => dispatch({type: 'GET_CREATED_CONTENTS', json}));

export const removeContent = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/my_page/remove_contents`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in removeContent.', error)
  ).then(json => dispatch({type: 'REMOVE_CONTENT', json}));

export const getCreatedItems = () => (dispatch, getState) =>
  fetch(`${window.apiUrl}/my_page/created_items`).then(
    response => response.json(),
    error => console.log('An error occurred in getCreatedItems.', error)
  ).then(json => dispatch({type: 'GET_CREATED_ITEMS', json}));

export const getUsingItems = () => (dispatch, getState) =>
  fetch(`${window.apiUrl}/my_page/using_items`).then(
    response => response.json(),
    error => console.log('An error occurred in getUsingItems.', error)
  ).then(json => dispatch({type: 'GET_USING_ITEMS', json}));
