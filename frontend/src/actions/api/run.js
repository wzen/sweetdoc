import fetch from 'cross-fetch'

export const runPaging = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/run/paging`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in runPaging.', error)
  ).then(json => dispatch({type: 'RUN_PAGING', json}));

export const saveGalleryFootprint = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/run/save_gallery_footprint`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in saveGalleryFootprint.', error)
  ).then(json => dispatch({type: 'SAVE_GALLERY_FOOTPRINT', json}));

export const loadCommonGalleryFootprint = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/run/load_common_gallery_footprint`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in loadCommonGalleryFootprint.', error)
  ).then(json => dispatch({type: 'LOAD_COMMON_GALLERY_FOOTPRINT', json}));
