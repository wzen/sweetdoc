import fetch from 'cross-fetch'
import {includeAuth} from "./api_util";

export const runPaging = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/run/paging`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in runPaging.', error)
  ).then(json => dispatch({type: 'RUN_PAGING', json}));

export const saveGalleryFootprint = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/run/save_gallery_footprint`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in saveGalleryFootprint.', error)
  ).then(json => dispatch({type: 'SAVE_GALLERY_FOOTPRINT', json}));

export const loadCommonGalleryFootprint = (data) => (dispatch, getState) =>
  fetch(`${window.apiUrl}/run/load_common_gallery_footprint`, {method: 'POST', body: includeAuth(getState, data)}).then(
    response => response.json(),
    error => console.log('An error occurred in loadCommonGalleryFootprint.', error)
  ).then(json => dispatch({type: 'LOAD_COMMON_GALLERY_FOOTPRINT', json}));
