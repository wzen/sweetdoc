import fetch from 'cross-fetch'
import {includeAuth} from "./api_util";

export const createImage = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/item_image/create_img`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in createImage.', error)
  ).then(json => dispatch({type: 'CREATE_IMAGE', json}));

export const removeWorktableProjectImage = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/item_image/remove_worktable_project_img`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in removeWorktableProjectImage.', error)
  ).then(json => dispatch({type: 'REMOVE_WORKTABLE_PROJECT_IMAGE', json}));

export const removeWorktableItemImage = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/item_image/remove_worktable_item_image`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in removeWorktableItemImage.', error)
  ).then(json => dispatch({type: 'REMOVE_WORKTABLE_ITEM_IMAGE', json}));

export const removeGalleryImage = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/item_image/remove_gallery_image`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in removeGalleryImage.', error)
  ).then(json => dispatch({type: 'REMOVE_GALLERY_IMAGE', json}));

