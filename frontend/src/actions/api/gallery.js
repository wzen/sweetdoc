import fetch from 'cross-fetch'

export const getGalleryPage = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/gallery/grid`, {method: 'GET', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in getGalleryPage.', error)
  ).then(json => dispatch({type: 'GET_GALLERY_PAGE', json}));

export const getGalleryInfo = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/gallery/get_info`, {method: 'GET', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in getGalleryInfo.', error)
  ).then(json => dispatch({type: 'GET_GALLERY_INFO', json}));

export const getGalleryDetail = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/gallery/detail`, {method: 'GET', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in getGalleryDetail.', error)
  ).then(json => dispatch({type: 'GET_GALLERY_DETAIL', json}));

export const saveGalleryState = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/gallery/save_state`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in saveGalleryState.', error)
  ).then(json => dispatch({type: 'SAVE_GALLERY_STATE', json}));

export const updateGalleryLastState = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/gallery/update_last_state`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in updateGalleryLastState.', error)
  ).then(json => dispatch({type: 'UPDATE_GALLERY_LAST_STATE', json}));

export const getPopularAndRecommendTags = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/gallery/get_popular_and_recommend_tags`, {method: 'GET', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in getPopularAndRecommendTags.', error)
  ).then(json => dispatch({type: 'GET_POPULAR_AND_RECOMMEND_TAGS', json}));

export const addBookmark = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/gallery/add_bookmark`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in addBookmark.', error)
  ).then(json => dispatch({type: 'ADD_BOOKMARK', json}));

export const removeBookmark = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/gallery/remove_bookmark`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in removeBookmark.', error)
  ).then(json => dispatch({type: 'REMOVE_BOOKMARK', json}));


