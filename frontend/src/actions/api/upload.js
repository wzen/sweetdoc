import fetch from 'cross-fetch'

export const uploadContent = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/upload/content`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in uploadContent.', error)
  ).then(json => dispatch({type: 'UPLOAD_CONTENT', json}));

export const uploadItem = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/upload/item`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in uploadItem.', error)
  ).then(json => dispatch({type: 'UPLOAD_ITEM', json}));
