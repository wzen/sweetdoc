import fetch from 'cross-fetch'

export const saveItemGalleryState = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/item_gallery/save_state`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in saveItemGalleryState.', error)
  ).then(json => dispatch({type: 'SAVE_ITEM_GALLERY_STATE', json}));

export const addUserUsed = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/item_gallery/add_user_used`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in addUserUsed.', error)
  ).then(json => dispatch({type: 'ADD_USER_USERD', json}));

export const removeUserUsed = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/item_gallery/remove_user_used`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in removeUserUsed.', error)
  ).then(json => dispatch({type: 'REMOVE_USER_USERD', json}));

